import 'package:json_annotation/json_annotation.dart';

part 'order_addons.g.dart';

@JsonSerializable()
class OrderAddOns {
  final int id;

  @JsonKey(name: 'choice_id')
  final List<int>? choiceId;

  OrderAddOns(this.id, this.choiceId);

  factory OrderAddOns.fromJson(Map<String, dynamic> json) =>
      _$OrderAddOnsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAddOnsToJson(this);
}
