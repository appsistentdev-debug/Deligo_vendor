// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_addons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAddOns _$OrderAddOnsFromJson(Map<String, dynamic> json) => OrderAddOns(
      (json['id'] as num).toInt(),
      (json['choice_id'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$OrderAddOnsToJson(OrderAddOns instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choice_id': instance.choiceId,
    };
