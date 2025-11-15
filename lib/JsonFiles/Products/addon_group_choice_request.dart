import 'package:json_annotation/json_annotation.dart';
part 'addon_group_choice_request.g.dart';

@JsonSerializable()
class AddonGroupsChoiceRequest {
  final String? title;
  final double? price;

  AddonGroupsChoiceRequest(this.title, this.price);

  factory AddonGroupsChoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$AddonGroupsChoiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddonGroupsChoiceRequestToJson(this);
}
