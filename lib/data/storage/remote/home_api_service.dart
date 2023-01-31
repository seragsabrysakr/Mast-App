import 'package:dio/dio.dart';
import 'package:mast/app/api_urls.dart';
import 'package:mast/data/model/base_response.dart';
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
  }); @GET(ApiUrls.viewSpecial)
  Future<BaseResponse<List<StoreModel>>> viewSpecial({
    @Query('skip') int? skip,
    @Query('take') int? take,
    @Query('title') String? title,
  });
}
