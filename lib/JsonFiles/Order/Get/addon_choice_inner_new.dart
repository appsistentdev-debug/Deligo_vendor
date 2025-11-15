import 'package:json_annotation/json_annotation.dart';

part 'addon_choice_inner_new.g.dart';

@JsonSerializable()
class AddOnChoiceInnerNew {
  final int id;
  final String title;
  final double price;
  @JsonKey(name: 'product_addon_group_id')
  final int productAddonGroupId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  AddOnChoiceInnerNew(this.id, this.title, this.price, this.productAddonGroupId,
      this.createdAt, this.updatedAt);

  factory AddOnChoiceInnerNew.fromJson(Map<String, dynamic> json) =>
      _$AddOnChoiceInnerNewFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnChoiceInnerNewToJson(this);
}
