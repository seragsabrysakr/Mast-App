import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_request.freezed.dart';
part 'store_request.g.dart';

@freezed
class StoreRequest with _$StoreRequest {
  factory StoreRequest({
    int? skip,
    int? take,
    String? title,
  }) = _StoreRequest;

  factory StoreRequest.fromJson(Map<String, dynamic> json) =>
      _$StoreRequestFromJson(json);
}
