import 'package:json_annotation/json_annotation.dart';

part 'transaction_meta.g.dart';

@JsonSerializable()
class TransactionMeta {
  final String? type;
  @JsonKey(name: 'bank_code')
  final String? bankCode;
  @JsonKey(name: 'bank_name')
  final String? bankName;
  final String? description;
  @JsonKey(name: 'bank_account_name')
  final String? bankAccountName;
  @JsonKey(name: 'bank_account_number')
  final String? bankAccountNumber;
  final String? source;
  @JsonKey(name: 'source_id')
  final int? sourceId;
  @JsonKey(name: 'source_title')
  final String? sourceTitle;
  @JsonKey(name: 'source_amount')
  final double? sourceAmount;
  @JsonKey(name: 'source_payment_type')
  final String? sourcePaymentType;

  TransactionMeta(
    this.type,
    this.bankCode,
    this.bankName,
    this.description,
    this.bankAccountName,
    this.bankAccountNumber,
    this.source,
    this.sourceId,
    this.sourceTitle,
    this.sourceAmount,
    this.sourcePaymentType,
  );

  factory TransactionMeta.fromJson(Map<String, dynamic> json) =>
      _$TransactionMetaFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionMetaToJson(this);
}
