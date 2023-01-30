import 'package:json_annotation/json_annotation.dart';

part 'cash_account_number_model.g.dart';

@JsonSerializable()
class MobileCashAccountNumberModel {
  MobileCashAccountNumberModel({
    this.accountNumber,
  });

  String? accountNumber;

  factory MobileCashAccountNumberModel.fromJson(Map<String, dynamic> json) =>
      _$MobileCashAccountNumberModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$MobileCashAccountNumberModelToJson(this);
}
