// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryData _$DeliveryDataFromJson(Map json) => DeliveryData(
      (json['id'] as num).toInt(),
      json['status'] as String,
      (json['order_id'] as num?)?.toInt(),
      json['delivery'] == null
          ? null
          : InnerDeliveryData.fromJson(json['delivery'] as Map),
    );

Map<String, dynamic> _$DeliveryDataToJson(DeliveryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'order_id': instance.orderId,
      'delivery': instance.delivery?.toJson(),
    };
