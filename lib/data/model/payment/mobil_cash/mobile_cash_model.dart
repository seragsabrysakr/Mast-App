import 'package:json_annotation/json_annotation.dart';
import 'package:mast/data/model/payment/mobil_cash/cash_account_number_model.dart';

part 'mobile_cash_model.g.dart';

@JsonSerializable()
class MobileCashModel {
  MobileCashModel({
    this.mobileCashServiceProviderName,
    this.mobileCashAccountNumbers,
  });

  String? mobileCashServiceProviderName;
  List<MobileCashAccountNumberModel>? mobileCashAccountNumbers;
  factory MobileCashModel.fromJson(Map<String, dynamic> json) =>
      _$MobileCashModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$MobileCashModelToJson(this);
}
