// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map json) => ProductData(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['detail'] as String,
      json['meta'],
      (json['price'] as num).toDouble(),
      json['owner'] as String,
      (json['parent_id'] as num?)?.toInt(),
      (json['attribute_term_id'] as num?)?.toInt(),
      json['created_at'] as String,
      json['updated_at'] as String,
      (json['addon_groups'] as List<dynamic>?)
          ?.map(
              (e) => AddOnGroups.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map))
          .toList(),
      (json['vendor_products'] as List<dynamic>?)
          ?.map((e) => VendorProduct.fromJson(e as Map))
          .toList(),
      json['mediaurls'],
      (json['ratings'] as num?)?.toDouble(),
      (json['ratings_count'] as num?)?.toInt(),
      (json['favourite_count'] as num?)?.toInt(),
      json['is_favourite'] as bool?,
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.dynamicMeta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parentId,
      'attribute_term_id': instance.attributeTermId,
      'mediaurls': instance.dynamicMediaUrls,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'addon_groups': instance.addOnGroups?.map((e) => e.toJson()).toList(),
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'vendor_products':
          instance.vendorProducts?.map((e) => e.toJson()).toList(),
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
    };
