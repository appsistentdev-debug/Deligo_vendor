// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_groups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnGroups _$AddOnGroupsFromJson(Map<String, dynamic> json) => AddOnGroups(
      (json['id'] as num).toInt(),
      json['title'] as String?,
      (json['max_choices'] as num?)?.toInt(),
      (json['min_choices'] as num?)?.toInt(),
      (json['product_id'] as num).toInt(),
      (json['addon_choices'] as List<dynamic>?)
          ?.map((e) => AddOnChoices.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddOnGroupsToJson(AddOnGroups instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'max_choices': instance.maxChoices,
      'min_choices': instance.minChoices,
      'product_id': instance.productId,
      'addon_choices': instance.addOnChoices?.map((e) => e.toJson()).toList(),
    };
