import 'package:json_annotation/json_annotation.dart';

part 'bank_account_model.g.dart';

@JsonSerializable()
class BankAccountModel {
  BankAccountModel({
    this.accountNumber,
    this.branchName,
  });

  String? accountNumber;
  String? branchName;
  // from json
  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BankAccountModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$BankAccountModelToJson(this);
}
