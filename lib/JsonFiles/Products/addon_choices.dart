import 'package:delivoo_store/JsonFiles/Products/addon_group_choice_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addon_choices.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class AddOnChoices {
  final int id;
  String? title;
  double? price;
  @JsonKey(name: 'product_addon_group_id')
  final int productAddonGroupId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  AddOnChoices(this.id, this.title, this.price, this.productAddonGroupId,
      this.createdAt, this.updatedAt);

  factory AddOnChoices.fromJson(Map json) => _$AddOnChoicesFromJson(json);

  Map toJson() => _$AddOnChoicesToJson(this);

  String? validate() {
    if (title == null || title!.trim().isEmpty) {
      return "invalid_choice_title";
    } else if (price == null || price! < 0) {
      return "invalid_choice_price";
    } else {
      return null;
    }
  }

  AddonGroupsChoiceRequest getRequest() {
    return AddonGroupsChoiceRequest(title, price);
  }
}
