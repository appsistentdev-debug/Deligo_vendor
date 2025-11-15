// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_group_choice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddonGroupsChoiceRequest _$AddonGroupsChoiceRequestFromJson(
        Map<String, dynamic> json) =>
    AddonGroupsChoiceRequest(
      json['title'] as String?,
      (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddonGroupsChoiceRequestToJson(
        AddonGroupsChoiceRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
    };
