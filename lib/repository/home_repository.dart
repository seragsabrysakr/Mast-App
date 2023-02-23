import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mast/data/model/base_response.dart';
import 'package:mast/data/model/home/notification_server_model.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/data/storage/remote/home_api_service.dart';

import '../app/network/error_handler.dart';
import '../app/network/save_api.dart';
import '../data/storage/local/app_prefs.dart';

@injectable
class HomeRepository {
  final HomeServiceClient _appServiceClient;
  final SafeApi safeApi;
  final AppPreferences appPreferences;

  HomeRepository(this._appServiceClient, this.safeApi, this.appPreferences);

  Future<Either<Failure, BaseResponse<List<StoreModel>>>> viewStores(
      {int? skip, int? take, String? title}) async {
    Future<Either<Failure, BaseResponse<List<StoreModel>>>> data = safeApi.call(
        apiCall:
            _appServiceClient.viewStores(skip: skip, take: take, title: title));
    return data;
  }

  Future<Either<Failure, BaseResponse<List<StoreModel>>>> viewTopRated(
      {int? skip, int? take, String? title}) async {
    Future<Either<Failure, BaseResponse<List<StoreModel>>>> data = safeApi.call(
        apiCall: _appServiceClient.viewTopRated(
            skip: skip, take: take, title: title));
    return data;
  }

  Future<Either<Failure, BaseResponse<List<StoreModel>>>> viewSpecial(
      {int? skip, int? take, String? title}) async {
    Future<Either<Failure, BaseResponse<List<StoreModel>>>> data = safeApi.call(
        apiCall: _appServiceClient.viewSpecial(
            skip: skip, take: take, title: title));
    return data;
  }

  Future<Either<Failure, BaseResponse<List<NotificationServerModel>>>>
      viewNotification({int? skip, int? take}) async {
    Future<Either<Failure, BaseResponse<List<NotificationServerModel>>>> data =
        safeApi.call(
            apiCall:
                _appServiceClient.viewNotification(skip: skip, take: take));
    return data;
  }

  Future<Either<Failure, BaseResponse<String>>> addRating({
    required String comment,
    required String shopRating,
    required String shopId,
  }) async {
    Future<Either<Failure, BaseResponse<String>>> data = safeApi.call(
        apiCall: _appServiceClient.addRating(
            comment: comment, shopRating: shopRating, shopId: shopId));
    return data;
  }

  Future<Either<Failure, BaseResponse<List<StoreModel>>>> addStore({
    required File image,
    required String title,
    required String description,
    required String url,
    required String type,
  }) async {
    Future<Either<Failure, BaseResponse<List<StoreModel>>>> data = safeApi.call(
        apiCall: _appServiceClient.addStore(
            image: image,
            title: title,
            description: description,
            url: url,
            type: type));
    return data;
  }
}
