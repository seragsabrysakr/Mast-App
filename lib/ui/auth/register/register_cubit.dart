import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/request/register_request.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/repository/auth_repository.dart';

@injectable
class RegisterCubit extends Cubit<FlowState> {
  final AuthRepository _repository;
  final AppPreferences _preferences;
  RegisterCubit(this._repository, this._preferences) : super(ContentState());
  static RegisterCubit get(BuildContext context) => context.read<RegisterCubit>();
  UserModel? userData;
  void register({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    _repository
        .register(RegisterRequest(
            email: email,
            password: password,
            phone: phone,
            name: name,
            fireBaseToken: _preferences.firebaseToken))
        .then((value) => value.fold(
              (failure) {
                emit(ErrorState(StateRendererType.toastErrorState, failure.message));
                print("errorMessage: ${failure.message}");
              },
              (data) {
                print(data.toString());
                _repository.userVerifyPhone(phone: phone, code: '999999');
                userData = data.data;
                _preferences.isUserLogin = true;

                _repository.saveAsAuthenticatedUser(data.data!);
                emit(SuccessState(
                  StateRendererType.toastSuccess,
                  message: MyApp.tr.loginSuccess,
                ));
              },
            ));
  }
}
