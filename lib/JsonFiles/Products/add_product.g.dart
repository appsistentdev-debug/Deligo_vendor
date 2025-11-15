// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProduct _$AddProductFromJson(Map<String, dynamic> json) => AddProduct(
      json['title'] as String,
      json['detail'] as String,
      (json['price'] as num).toDouble(),
      (json['vendor_id'] as num).toInt(),
      (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      (json['image_urls'] as List<dynamic>).map((e) => e as String).toList(),
      (json['stock_quantity'] as num).toInt(),
      (json['addon_groups'] as List<dynamic>)
          .map((e) => AddonGroupsRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddProductToJson(AddProduct instance) =>
    <String, dynamic>{
      'title': instance.title,
      'detail': instance.detail,
      'price': instance.price,
      'vendor_id': instance.vendorId,
      'categories': instance.categories,
      'image_urls': instance.imageUrls,
      'stock_quantity': instance.stockQuantity,
      'addon_groups': instance.addon_groups,
    };
