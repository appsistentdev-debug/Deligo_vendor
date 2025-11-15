// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      (json['id'] as num).toInt(),
      (json['amount'] as num?)?.toDouble(),
      json['type'] as String?,
      json['meta'],
      json['created_at'] as String,
      json['updated_at'] as String,
      json['user'] == null
          ? null
          : UserInformation.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'meta': instance.dynamicMeta,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
    };
