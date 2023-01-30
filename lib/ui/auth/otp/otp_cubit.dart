import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/app/state_renderer/state_renderer.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/repository/auth_repository.dart';

@injectable
class PhoneVerificationCubit extends Cubit<FlowState> {
  final AuthRepository _repository;
  final AppPreferences appPreferences;

  PhoneVerificationCubit(
    this._repository,
    this.appPreferences,
  ) : super(ContentState());
  static PhoneVerificationCubit get(BuildContext context) =>
      context.read<PhoneVerificationCubit>();
  late String verificationId;

  Future<void> sendOtp(String phone) async {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    dPrint("sendOtp $phone");
    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: verificationCompleted,
          timeout: const Duration(seconds: 120),
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        )
        .then((value) => {});
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void verificationFailed(FirebaseAuthException exception) {
    emit(ErrorState(StateRendererType.toastErrorState, 'verificationFailed'));

    dPrint(exception.toString());
  }

  void codeSent(String verificationId, int? resendToken) {
    dPrint("codeSent");
    this.verificationId = verificationId;
    emit(ContentState());
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    dPrint('verificationCompleted');
    await signIn(credential);
    emit(SuccessState(StateRendererType.toastSuccess,
        message: MyApp.tr.success));
  }

  Future<void> verifySmsCode(String otpCode) async {
    emit(LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    dPrint("verifySmsCode $otpCode");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError((e) {
      emit(
          ErrorState(StateRendererType.toastErrorState, MyApp.tr.userNotExist));
    }).then((user) => {
              if (user.user != null)
                emit(SuccessState(
                  StateRendererType.contentState,
                  message: MyApp.tr.verifyCode,
                ))
              else
                emit(ErrorState(
                    StateRendererType.toastErrorState, MyApp.tr.userNotExist))
            });
  }

  Future<void> verifyUserPhone({
    required String phone,
    required String code,
  }) async {
    _repository
        .userVerifyPhone(
          phone: phone,
          code: '999999',
        )
        .then((value) => value.fold(
              (failure) {
                emit(ErrorState(
                    StateRendererType.toastErrorState, failure.message));
                print("errorMessage: ${failure.message}");
              },
              (data) {
                print(data.toString());
                appPreferences.isUserLogin = true;
                _repository.saveAsAuthenticatedUser(data.data!);
                emit(SuccessState(StateRendererType.toastSuccess,
                    message: MyApp.tr.success));
              },
            ));
  }
}
