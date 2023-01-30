import 'package:json_annotation/json_annotation.dart';
import 'package:mast/data/model/payment/bank/bank_model.dart';
import 'package:mast/data/model/payment/company/company_model.dart';
import 'package:mast/data/model/payment/mobil_cash/mobile_cash_model.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  PaymentModel({
    this.company,
    this.banks,
    this.mobileCash,
  });

  CompanyModel? company;
  List<BankModel>? banks;
  List<MobileCashModel>? mobileCash;
  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

// to json
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
