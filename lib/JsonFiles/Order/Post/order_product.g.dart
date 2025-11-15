// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
      (json['id'] as num).toInt(),
      (json['quantity'] as num).toInt(),
      (json['addons'] as List<dynamic>?)
          ?.map((e) => OrderAddOns.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'addons': instance.addons,
    };
