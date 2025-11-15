import 'package:json_annotation/json_annotation.dart';

import 'addon_group_choice_request.dart';

part 'addon_group_request.g.dart';

@JsonSerializable()
class AddonGroupsRequest {
  final String? title;
  final int? min_choices, max_choices;
  final List<AddonGroupsChoiceRequest> choices;

  AddonGroupsRequest(
      this.title, this.min_choices, this.max_choices, this.choices);

  factory AddonGroupsRequest.fromJson(Map<String, dynamic> json) =>
      _$AddonGroupsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddonGroupsRequestToJson(this);
}
