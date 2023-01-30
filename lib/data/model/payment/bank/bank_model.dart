import 'package:json_annotation/json_annotation.dart';
import 'package:mast/data/model/payment/bank/bank_account_model.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class BankModel {
  BankModel({
    this.bankName,
    this.bankAccounts,
  });

  String? bankName;
  List<BankAccountModel>? bankAccounts;

  // from json
  factory BankModel.fromJson(Map<String, dynamic> json) =>
      _$BankModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$BankModelToJson(this);
}
