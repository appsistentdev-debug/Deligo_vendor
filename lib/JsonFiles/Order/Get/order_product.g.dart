// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map json) => OrderProduct(
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      total: (json['total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      orderId: (json['order_id'] as num).toInt(),
      vendorProductId: (json['vendor_product_id'] as num?)?.toInt(),
      vendorProduct: VendorProduct.fromJson(json['vendor_product'] as Map),
      addonChoices: (json['addon_choices'] as List<dynamic>?)
          ?.map((e) =>
              AddOnChoiceNew.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'order_id': instance.orderId,
      'vendor_product_id': instance.vendorProductId,
      'vendor_product': instance.vendorProduct.toJson(),
      'addon_choices': instance.addonChoices?.map((e) => e.toJson()).toList(),
    };
