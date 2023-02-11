import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/repository/auth_repository.dart';

@injectable
class ProfileCubit extends Cubit<FlowState> {
  final AppPreferences _preferences;
  final AuthRepository authRepository;
  ProfileCubit(this._preferences, this.authRepository) : super(ContentState());

  static ProfileCubit get(BuildContext context) => context.read<ProfileCubit>();
  UserModel? user;

  void updateProfile({
    File? image,
    String? userName,
    String? email,
  }) {
    emit(LoadingState(
      stateRendererType: StateRendererType.popupLoadingState,
    ));

    authRepository
        .updateProfile(image: image, name: userName ?? user!.name!, email: email ?? user!.email!)
        .then((value) => value.fold((failure) {
              emit(ErrorState(StateRendererType.toastErrorState, failure.message));
            }, (data) {
              dPrint(data.data.toString());
              user = data.data;
              saveUserData(data.data!);
              emit(SuccessState(StateRendererType.toastSuccess, message: MyApp.tr.success));
            }));
  }

  void saveUserData(UserModel data) {
    _preferences.userDataModel = data;
    print("data saved $data");
  }
}
