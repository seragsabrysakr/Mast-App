import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/storage/local/app_prefs.dart';

@injectable
class ProfileCubit extends Cubit<FlowState> {
  final AppPreferences _preferences;

  ProfileCubit(this._preferences) : super(ContentState());

  static ProfileCubit get(BuildContext context) => context.read<ProfileCubit>();
  UserModel? user;

  void updateProfile(
    String userName,
    String mobileNumber,
    String email,
  ) {
    emit(LoadingState(
      stateRendererType: StateRendererType.popupLoadingState,
    ));
    // useCase
    //     .execute(UpdateProfileInput(
    //       userName,
    //       mobileNumber,
    //       email,
    //     ))
    //     .then((value) => value.fold((failure) {
    //           emit(ErrorState(
    //               StateRendererType.toastErrorState, failure.message));
    //         }, (data) {
    //           print(data.data.toString());
    //           user = data.data;
    //           print(user?.newPhoneCheck.toString());
    //           saveUserData(data.data);
    //           emit(SuccessState(
    //             message: App.tr.success,
    //             stateRendererType: StateRendererType.toastSuccess,
    //           ));
    //         }));
  }

  void saveUserData(UserModel data) {
    _preferences.userDataModel = data;
    print("data saved $data");
  }
}
