import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel(
    this.id,
    this.email,
    this.token,
    this.phone,
    this.name,
    this.image,
    this.isActive,
  );

  int? id;
  String? email;
  @JsonKey(name: 'access_token')
  String? token;
  String? phone;
  String? name;
  String? image;
  @JsonKey(name: 'is_active')
  bool? isActive;

// from json
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
