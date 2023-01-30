import 'package:dio/dio.dart';
import 'package:mast/app/api_urls.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/model/base_response.dart';
import 'package:retrofit/http.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: ApiUrls.baseUrl)
abstract class AuthServiceClient {
  factory AuthServiceClient(Dio dio, {String baseUrl}) = _AuthServiceClient;

  @MultiPart()
  @POST(ApiUrls.login)
  Future<BaseResponse<UserModel>> login({
    @Part(name: 'email') required String email,
    @Part(name: 'password') required String password,
    @Part(name: 'fcm_token') required String fireBaseToken,
  });

  @MultiPart()
  @POST(ApiUrls.register)
  Future<BaseResponse<UserModel>> register({
    @Part(name: 'email') required String email,
    @Part(name: 'password') required String password,
    @Part(name: 'name') required String name,
    @Part(name: 'phone') required String phone,
    @Part(name: 'fcm_token') required String fireBaseToken,
  });
  @MultiPart()
  @POST(ApiUrls.userVerifyPhone)
  Future<BaseResponse<UserModel>> userVerifyPhone({
    @Part(name: 'phone') required String phone,
    @Part(name: 'otp') required String code,
  });
}
