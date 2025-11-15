import 'package:json_annotation/json_annotation.dart';

import 'order_product.dart';

part 'create_order.g.dart';

@JsonSerializable()
class CreateOrder {
  @JsonKey(name: 'address_id')
  final int addressId;
  @JsonKey(name: 'payment_method_slug')
  final String paymentMethodSlug;
  final List<OrderProduct> products;
  final String type;

  @JsonKey(name: 'scheduled_on')
  final scheduledOn;

  @JsonKey(name: 'notes')
  final notes;

  CreateOrder(
    this.addressId,
    this.paymentMethodSlug,
    this.products,
    this.type,
    this.scheduledOn,
    this.notes,
  );

  factory CreateOrder.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderToJson(this);
}
