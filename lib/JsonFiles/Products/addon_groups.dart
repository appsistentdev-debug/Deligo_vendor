import 'package:delivoo_store/JsonFiles/Products/addon_choices.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_group_request.dart';
import 'package:json_annotation/json_annotation.dart';

import 'addon_group_choice_request.dart';

part 'addon_groups.g.dart';

@JsonSerializable(explicitToJson: true)
class AddOnGroups {
  final int id;
  String? title;
  @JsonKey(name: 'max_choices')
  int? maxChoices;
  @JsonKey(name: 'min_choices')
  int? minChoices;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'addon_choices')
  List<AddOnChoices>? addOnChoices;

  AddOnGroups(this.id, this.title, this.maxChoices, this.minChoices,
      this.productId, this.addOnChoices);

  factory AddOnGroups.fromJson(Map<String, dynamic> json) =>
      _$AddOnGroupsFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnGroupsToJson(this);

  String? validate() {
    if (title == null || title!.trim().isEmpty) {
      return "invalid_group_title";
    } else if (minChoices == null || minChoices! < 1) {
      return "invalid_group_choice_min";
    } else if (maxChoices == null || maxChoices! < (minChoices ?? 1)) {
      return "invalid_group_choice_max";
    } else if (addOnChoices == null || addOnChoices!.isEmpty) {
      return "invalid_group_choices_empty";
    } else {
      String? invalidMsgKey =
          addOnChoices?[addOnChoices!.length - 1].validate();
      if (invalidMsgKey == null) {
        return addOnChoices!.length < (minChoices ?? 1)
            ? "invalid_group_choice_min_length"
            : null;
      } else {
        return invalidMsgKey;
      }
    }
  }

  AddonGroupsRequest getRequest() {
    List<AddonGroupsChoiceRequest> addOnGroupChoicesRequest = [];
    for (AddOnChoices addOnChoice in (addOnChoices ?? []))
      addOnGroupChoicesRequest.add(addOnChoice.getRequest());
    return AddonGroupsRequest(
        title, minChoices, maxChoices, addOnGroupChoicesRequest);
  }
}
