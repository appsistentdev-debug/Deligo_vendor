// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorInfo _$VendorInfoFromJson(Map<String, dynamic> json) => VendorInfo(
      (json['id'] as num).toInt(),
      json['name'] as String?,
      json['tagline'] as String?,
      json['details'] as String?,
      json['meta'],
      json['mediaurls'],
      (json['minimum_order'] as num?)?.toInt(),
      (json['delivery_fee'] as num?)?.toDouble(),
      json['area'] as String?,
      json['address'] as String?,
      (json['longitude'] as num?)?.toDouble(),
      (json['latitude'] as num?)?.toDouble(),
      (json['is_verified'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      json['created_at'] as String,
      json['updated_at'] as String,
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['product_categories'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      (json['ratings'] as num?)?.toDouble(),
      (json['ratings_count'] as num?)?.toInt(),
      (json['favourite_count'] as num?)?.toInt(),
      json['is_favourite'] as bool?,
    );

Map<String, dynamic> _$VendorInfoToJson(VendorInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'meta': instance.meta,
      'mediaurls': instance.dynamicMediaUrls,
      'minimum_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_verified': instance.isVerified,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'categories': instance.categories,
      'product_categories': instance.productCategories,
      'user': instance.user,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
    };
