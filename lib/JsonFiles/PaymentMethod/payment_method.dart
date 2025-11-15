import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentMethod {
  final int id;
  final String? slug;
  final String title;
  final int enabled;
  final String type;

  PaymentMethod(this.id, this.slug, this.title, this.enabled, this.type);

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
