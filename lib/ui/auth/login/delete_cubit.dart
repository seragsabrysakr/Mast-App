import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/repository/auth_repository.dart';

@injectable
class DeleteCubit extends Cubit<FlowState> {
  final AuthRepository _repository;
  final AppPreferences _preferences;
  DeleteCubit(this._repository, this._preferences) : super(ContentState());
  static DeleteCubit get(BuildContext context) => context.read<DeleteCubit>();

  void deleteAcount() {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    _repository.deleteAcount().then((value) => value.fold(
          (failure) {
            emit(ErrorState(StateRendererType.toastErrorState, failure.message));
            print("errorMessage: ${failure.message}");
          },
          (data) {
            print(data.toString());

            _repository.removeOldUserData();
            _preferences.isUserLogin = false;
            _preferences.remove('token');

            emit(SuccessState(
              StateRendererType.toastSuccess,
              message: 'تم حذف الحساب بنجاح',
            ));
          },
        ));
  }
}
