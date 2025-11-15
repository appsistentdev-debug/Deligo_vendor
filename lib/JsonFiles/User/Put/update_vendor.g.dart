// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateVendorInfo _$UpdateVendorInfoFromJson(Map<String, dynamic> json) =>
    UpdateVendorInfo(
      name: json['name'] as String?,
      tagLine: json['tagline'] as String?,
      details: json['details'] as String?,
      minimumOrder: (json['minimun_order'] as num?)?.toInt(),
      deliveryFee: (json['delivery_fee'] as num?)?.toInt(),
      area: json['area'] as String?,
      address: json['address'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      imageUrl: json['image_urls'] as List<dynamic>?,
      dynamicMeta: json['meta'],
    );

Map<String, dynamic> _$UpdateVendorInfoToJson(UpdateVendorInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tagline': instance.tagLine,
      'details': instance.details,
      'minimun_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'categories': instance.categories,
      'image_urls': instance.imageUrl,
      'meta': instance.dynamicMeta,
    };
