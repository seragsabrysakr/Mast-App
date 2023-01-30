import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/constants.dart';
import 'package:mast/app/di/module/dio_module.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/model/base_response.dart';
import 'package:mast/data/request/register_request.dart';

import '../app/di/di.dart';
import '../app/network/error_handler.dart';
import '../app/network/save_api.dart';
import '../data/request/login_request.dart';
import '../data/storage/local/app_prefs.dart';
import '../data/storage/remote/auth_api_service.dart';

@injectable
class AuthRepository {
  final AuthServiceClient _appServiceClient;
  final SafeApi safeApi;
  final AppPreferences appPreferences;

  AuthRepository(
    this._appServiceClient,
    this.safeApi,
    this.appPreferences,
  );

  Future<Either<Failure, BaseResponse<UserModel>>> login(
      LoginRequest loginRequest) async {
    Future<Either<Failure, BaseResponse<UserModel>>> data = safeApi.call(
        apiCall: _appServiceClient.login(
            email: loginRequest.email,
            password: loginRequest.password,
            fireBaseToken: loginRequest.fireBaseToken));
    return data;
  }

  Future<Either<Failure, BaseResponse<UserModel>>> register(
      RegisterRequest request) async {
    Future<Either<Failure, BaseResponse<UserModel>>> data = safeApi.call(
        apiCall: _appServiceClient.register(
            email: request.email,
            password: request.password,
            name: request.name,
            phone: request.phone,
            fireBaseToken: request.fireBaseToken));
    return data;
  }

  Future<Either<Failure, BaseResponse<UserModel>>> userVerifyPhone({
    required String phone,
    required String code,
  }) async {
    Future<Either<Failure, BaseResponse<UserModel>>> data = safeApi.call(
        apiCall: _appServiceClient.userVerifyPhone(
      phone: phone,
      code: code,
    ));
    return data;
  }

  void saveAsAuthenticatedUser(UserModel data) {
    appPreferences.userDataModel = data;
    appPreferences.token = data.token!;
    dPrint(appPreferences.token);
    getIt<Dio>().updateHeader(appPreferences);
  }

  void removeOldUserData() {
    appPreferences.remove(Constants.userData);
    getIt<Dio>().updateHeader(appPreferences);
  }
}
