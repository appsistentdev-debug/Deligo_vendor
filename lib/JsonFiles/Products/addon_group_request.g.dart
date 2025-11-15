// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddonGroupsRequest _$AddonGroupsRequestFromJson(Map<String, dynamic> json) =>
    AddonGroupsRequest(
      json['title'] as String?,
      (json['min_choices'] as num?)?.toInt(),
      (json['max_choices'] as num?)?.toInt(),
      (json['choices'] as List<dynamic>)
          .map((e) =>
              AddonGroupsChoiceRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddonGroupsRequestToJson(AddonGroupsRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'min_choices': instance.min_choices,
      'max_choices': instance.max_choices,
      'choices': instance.choices,
    };
