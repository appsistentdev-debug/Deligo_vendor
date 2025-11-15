// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingsList _$RatingsListFromJson(Map<String, dynamic> json) => RatingsList(
      (json['data'] as List<dynamic>)
          .map((e) => RatingsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['meta'],
    );

Map<String, dynamic> _$RatingsListToJson(RatingsList instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.dynamicMeta,
    };
