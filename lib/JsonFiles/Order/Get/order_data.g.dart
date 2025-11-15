// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map json) => OrderData(
      (json['id'] as num).toInt(),
      json['notes'] as String?,
      json['meta'],
      (json['subtotal'] as num?)?.toDouble(),
      (json['taxes'] as num?)?.toDouble(),
      (json['delivery_fee'] as num?)?.toDouble(),
      (json['total'] as num?)?.toDouble(),
      (json['discount'] as num?)?.toDouble(),
      json['type'] as String?,
      json['scheduled_on'] as String?,
      json['status'] as String?,
      (json['vendor_id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      json['created_at'] as String?,
      json['updated_at'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => OrderProduct.fromJson(e as Map))
          .toList(),
      json['vendor'] == null ? null : Vendor.fromJson(json['vendor'] as Map),
      json['user'] == null
          ? null
          : UserInformation.fromJson(json['user'] as Map),
      json['address'] == null ? null : Address.fromJson(json['address'] as Map),
      json['delivery'] == null
          ? null
          : DeliveryData.fromJson(json['delivery'] as Map),
      json['payment'] == null ? null : Payment.fromJson(json['payment'] as Map),
      json['order_type'] as String?,
      json['customer_name'] as String?,
      json['customer_email'] as String?,
      json['customer_mobile'] as String?,
    );

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'meta': instance.dynamicMeta,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'delivery_fee': instance.deliveryFee,
      'total': instance.total,
      'discount': instance.discount,
      'type': instance.type,
      'order_type': instance.orderType,
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'customer_mobile': instance.customerMobile,
      'scheduled_on': instance.scheduledOn,
      'status': instance.status,
      'vendor_id': instance.vendorId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'vendor': instance.vendor?.toJson(),
      'user': instance.user?.toJson(),
      'address': instance.address?.toJson(),
      'delivery': instance.delivery?.toJson(),
      'payment': instance.payment?.toJson(),
    };
