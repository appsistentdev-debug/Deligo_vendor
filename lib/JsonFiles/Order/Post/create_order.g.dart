// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrder _$CreateOrderFromJson(Map<String, dynamic> json) => CreateOrder(
      (json['address_id'] as num).toInt(),
      json['payment_method_slug'] as String,
      (json['products'] as List<dynamic>)
          .map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['type'] as String,
      json['scheduled_on'],
      json['notes'],
    );

Map<String, dynamic> _$CreateOrderToJson(CreateOrder instance) =>
    <String, dynamic>{
      'address_id': instance.addressId,
      'payment_method_slug': instance.paymentMethodSlug,
      'products': instance.products,
      'type': instance.type,
      'scheduled_on': instance.scheduledOn,
      'notes': instance.notes,
    };
