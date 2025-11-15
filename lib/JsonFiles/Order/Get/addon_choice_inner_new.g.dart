// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_choice_inner_new.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnChoiceInnerNew _$AddOnChoiceInnerNewFromJson(Map<String, dynamic> json) =>
    AddOnChoiceInnerNew(
      (json['id'] as num).toInt(),
      json['title'] as String,
      (json['price'] as num).toDouble(),
      (json['product_addon_group_id'] as num).toInt(),
      json['created_at'] as String,
      json['updated_at'] as String,
    );

Map<String, dynamic> _$AddOnChoiceInnerNewToJson(
        AddOnChoiceInnerNew instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'product_addon_group_id': instance.productAddonGroupId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
