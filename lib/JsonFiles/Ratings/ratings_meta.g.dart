// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingsMeta _$RatingsMetaFromJson(Map<String, dynamic> json) => RatingsMeta(
      (json['current_page'] as num).toInt(),
      (json['from'] as num).toInt(),
      (json['last_page'] as num).toInt(),
      json['path'] as String,
      (json['per_page'] as num).toInt(),
      (json['to'] as num).toInt(),
      (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$RatingsMetaToJson(RatingsMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'path': instance.path,
      'per_page': instance.perPage,
      'to': instance.to,
      'total': instance.total,
    };
