// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingsData _$RatingsDataFromJson(Map<String, dynamic> json) => RatingsData(
      (json['id'] as num).toInt(),
      (json['rating'] as num).toInt(),
      json['review'] as String,
      json['created_at'] as String,
      UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingsDataToJson(RatingsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'review': instance.review,
      'created_at': instance.createdAt,
      'user': instance.user,
      'vendor': instance.vendor,
    };
