import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mast/app/api_urls.dart';
import 'package:mast/data/model/base_response.dart';
import 'package:mast/data/model/home/notification_server_model.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:retrofit/http.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: ApiUrls.baseUrl)
abstract class HomeServiceClient {
  factory HomeServiceClient(Dio dio, {String baseUrl}) = _HomeServiceClient;

  @GET(ApiUrls.viewStores)
  Future<BaseResponse<List<StoreModel>>> viewStores({
    @Query('skip') int? skip,
    @Query('take') int? take,
    @Query('title') String? title,
  });

  @GET(ApiUrls.viewTopRated)
  Future<BaseResponse<List<StoreModel>>> viewTopRated({
    @Query('skip') int? skip,
    @Query('take') int? take,
    @Query('title') String? title,
  });

  @GET(ApiUrls.viewNotification)
  Future<BaseResponse<List<NotificationServerModel>>> viewNotification({
    @Query('skip') int? skip,
    @Query('take') int? take,
  });

  @GET(ApiUrls.viewSpecial)
  Future<BaseResponse<List<StoreModel>>> viewSpecial({
    @Query('skip') int? skip,
    @Query('take') int? take,
    @Query('title') String? title,
  });
  @MultiPart()
  @POST(ApiUrls.addRating)
  Future<BaseResponse<String>> addRating({
    @Part(name: 'shop_id') required String shopId,
    @Part(name: 'comment') required String comment,
    @Part(name: 'shop_rating') required String shopRating,
  });
  @MultiPart()
  @POST(ApiUrls.addStore)
  Future<BaseResponse<List<StoreModel>>> addStore({
    @Part(name: 'image') required File image,
    @Part(name: 'title') required String title,
    @Part(name: 'description') required String description,
    @Part(name: 'url') required String url,
    @Part(name: 'type') required String type,
  });
}
