// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMeta _$OrderMetaFromJson(Map json) => OrderMeta(
      json['category_id'] as String?,
      json['category_title'] as String?,
      json['category_image'] as String?,
      json['customer_id'] as String?,
      json['customer_image'] as String?,
      json['reach_time'] as String?,
      json['reject_reason'] as String?,
    );

Map<String, dynamic> _$OrderMetaToJson(OrderMeta instance) => <String, dynamic>{
      'category_id': instance.category_id,
      'category_title': instance.category_title,
      'category_image': instance.category_image,
      'customer_id': instance.customer_id,
      'customer_image': instance.customer_image,
      'reach_time': instance.reach_time,
      'reject_reason': instance.reject_reason,
    };
