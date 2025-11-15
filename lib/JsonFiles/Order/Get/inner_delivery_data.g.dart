// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inner_delivery_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InnerDeliveryData _$InnerDeliveryDataFromJson(Map json) => InnerDeliveryData(
      (json['id'] as num).toInt(),
      json['meta'],
      (json['is_verified'] as num).toInt(),
      (json['is_online'] as num).toInt(),
      (json['assigned'] as num).toInt(),
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      json['user'] == null
          ? null
          : UserInformation.fromJson(json['user'] as Map),
    );

Map<String, dynamic> _$InnerDeliveryDataToJson(InnerDeliveryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'is_verified': instance.isVerified,
      'is_online': instance.isOnline,
      'assigned': instance.assigned,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'user': instance.user?.toJson(),
    };
