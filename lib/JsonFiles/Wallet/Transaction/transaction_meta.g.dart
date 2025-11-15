// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionMeta _$TransactionMetaFromJson(Map<String, dynamic> json) =>
    TransactionMeta(
      json['type'] as String?,
      json['bank_code'] as String?,
      json['bank_name'] as String?,
      json['description'] as String?,
      json['bank_account_name'] as String?,
      json['bank_account_number'] as String?,
      json['source'] as String?,
      (json['source_id'] as num?)?.toInt(),
      json['source_title'] as String?,
      (json['source_amount'] as num?)?.toDouble(),
      json['source_payment_type'] as String?,
    );

Map<String, dynamic> _$TransactionMetaToJson(TransactionMeta instance) =>
    <String, dynamic>{
      'type': instance.type,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
      'description': instance.description,
      'bank_account_name': instance.bankAccountName,
      'bank_account_number': instance.bankAccountNumber,
      'source': instance.source,
      'source_id': instance.sourceId,
      'source_title': instance.sourceTitle,
      'source_amount': instance.sourceAmount,
      'source_payment_type': instance.sourcePaymentType,
    };
