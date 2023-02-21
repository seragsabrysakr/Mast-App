import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/request/login_request.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/repository/auth_repository.dart';

@injectable
class LoginCubit extends Cubit<FlowState> {
  final AuthRepository _repository;
  final AppPreferences _preferences;
  LoginCubit(this._repository, this._preferences) : super(ContentState());
  static LoginCubit get(BuildContext context) => context.read<LoginCubit>();
  UserModel? userData;
  void login({
    required String email,
    required String password,
  }) {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    _repository
        .login(LoginRequest(
            email: email, password: password, fireBaseToken: _preferences.firebaseToken))
        .then((value) => value.fold(
              (failure) {
                emit(ErrorState(StateRendererType.toastErrorState, failure.message));
                print("errorMessage: ${failure.message}");
              },
              (data) {
                print(data.toString());
                userData = data.data;
                _repository.saveAsAuthenticatedUser(data.data!);
                emit(SuccessState(
                  StateRendererType.toastSuccess,
                  message: MyApp.tr.success,
                ));
              },
            ));
  }
}
