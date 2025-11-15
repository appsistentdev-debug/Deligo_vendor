// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListImage _$ListImageFromJson(Map json) => ListImage(
      (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$ListImageToJson(ListImage instance) => <String, dynamic>{
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };
