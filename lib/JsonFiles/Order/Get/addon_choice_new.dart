import 'package:json_annotation/json_annotation.dart';

import 'addon_choice_inner_new.dart';

part 'addon_choice_new.g.dart';

@JsonSerializable()
class AddOnChoiceNew {
  final int id;
  @JsonKey(name: 'addon_choice')
  final AddOnChoiceInnerNew addOnChoiceInnerNew;

  AddOnChoiceNew(this.id, this.addOnChoiceInnerNew);

  factory AddOnChoiceNew.fromJson(Map<String, dynamic> json) =>
      _$AddOnChoiceNewFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnChoiceNewToJson(this);
}
