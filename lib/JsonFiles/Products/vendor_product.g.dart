// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProduct _$VendorProductFromJson(Map json) => VendorProduct(
      (json['id'] as num).toInt(),
      json['title'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['sale_price'] as num?)?.toDouble(),
      (json['sale_price_from'] as num?)?.toDouble(),
      (json['sale_price_to'] as num?)?.toDouble(),
      (json['stock_quantity'] as num).toInt(),
      (json['stock_low_threshold'] as num).toInt(),
      (json['product_id'] as num).toInt(),
      (json['vendor_id'] as num).toInt(),
      json['vendor'] == null ? null : Vendor.fromJson(json['vendor'] as Map),
      (json['sells_count'] as num?)?.toInt(),
      json['product'] == null
          ? null
          : ProductData.fromJson(json['product'] as Map),
    );

Map<String, dynamic> _$VendorProductToJson(VendorProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'sale_price_from': instance.salePriceFrom,
      'sale_price_to': instance.salePriceTo,
      'stock_quantity': instance.stockQuantity,
      'stock_low_threshold': instance.stockLowThreshold,
      'product_id': instance.productId,
      'vendor_id': instance.vendorId,
      'vendor': instance.vendor?.toJson(),
      'product': instance.product?.toJson(),
      'sells_count': instance.sellsCount,
    };
