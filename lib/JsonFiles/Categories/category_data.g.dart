// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map json) => CategoryData(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      title: json['title'] as String,
      sortOrder: (json['sort_order'] as num).toInt(),
      dynamicMediaUrls: json['mediaurls'],
      parentId: (json['parent_id'] as num?)?.toInt(),
      isSelected: json['isSelected'] as bool?,
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'sort_order': instance.sortOrder,
      'mediaurls': instance.dynamicMediaUrls,
      'parent_id': instance.parentId,
      'isSelected': instance.isSelected,
    };
