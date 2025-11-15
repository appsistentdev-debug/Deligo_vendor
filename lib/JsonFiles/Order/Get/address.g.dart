// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) => Address(
      (json['id'] as num).toInt(),
      json['formatted_address'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'formatted_address': instance.formattedAddress,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'order_id': instance.orderId,
    };
