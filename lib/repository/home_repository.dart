import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/app/constants.dart';
import 'package:mast/app/di/module/dio_module.dart';
import 'package:mast/app/fuctions.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/model/base_response.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/request/register_request.dart';
import 'package:mast/data/storage/remote/home_api_service.dart';

import '../app/di/di.dart';
import '../app/network/error_handler.dart';
import '../app/network/save_api.dart';
import '../data/request/login_request.dart';
import '../data/storage/local/app_prefs.dart';
import '../data/storage/remote/auth_api_service.dart';

@injectable
class HomeRepository {
  final HomeServiceClient _appServiceClient;
  final SafeApi safeApi;
  final AppPreferences appPreferences;

  HomeRepository(
    this._appServiceClient,
    this.safeApi,
    this.appPreferences,
  );

  Future<Either<Failure, BaseResponse<List<StoreModel>>>> viewStores({
    int? skip,
    int? take,
    String? title,
  }) async {
    Future<Either<Failure, BaseResponse<List<StoreModel>>>> data = safeApi.call(
        apiCall: _appServiceClient.viewStores(
      skip: skip,
      take: take,
      title: title,
    ));
    return data;
  }
}
