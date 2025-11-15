import 'package:json_annotation/json_annotation.dart';

part 'order_meta.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderMeta {
  final String? category_id;
  final String? category_title,
      category_image,
      customer_id,
      customer_image,
      reach_time,
      reject_reason;

  OrderMeta(
    this.category_id,
    this.category_title,
    this.category_image,
    this.customer_id,
    this.customer_image,
    this.reach_time,
    this.reject_reason,
  );

  factory OrderMeta.fromJson(Map json) => _$OrderMetaFromJson(json);

  Map toJson() => _$OrderMetaToJson(this);
}
