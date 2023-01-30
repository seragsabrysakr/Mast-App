import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  CompanyModel({
    this.companyName,
    this.companyPhone,
    this.companyAddress,
    this.companyLat,
    this.companyLang,
  });
  String? companyName;
  String? companyPhone;
  String? companyAddress;
  String? companyLat;
  String? companyLang;
  // from json
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
