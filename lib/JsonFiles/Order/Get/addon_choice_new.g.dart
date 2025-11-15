// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_choice_new.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnChoiceNew _$AddOnChoiceNewFromJson(Map<String, dynamic> json) =>
    AddOnChoiceNew(
      (json['id'] as num).toInt(),
      AddOnChoiceInnerNew.fromJson(
          json['addon_choice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddOnChoiceNewToJson(AddOnChoiceNew instance) =>
    <String, dynamic>{
      'id': instance.id,
      'addon_choice': instance.addOnChoiceInnerNew,
    };
