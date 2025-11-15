import 'package:delivoo_store/JsonFiles/Commons/list_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class CategoryData {
  final int id;
  final String slug;
  final String title;
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;

  @JsonKey(name: 'parent_id')
  final int? parentId;

  bool? isSelected;

  CategoryData({
    required this.id,
    required this.slug,
    required this.title,
    required this.sortOrder,
    this.dynamicMediaUrls,
    this.parentId,
    this.isSelected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryData.fromJson(Map json) => _$CategoryDataFromJson(json);

  Map toJson() => _$CategoryDataToJson(this);

  String? get image => mediaUrls?.images?.first.defaultImage;

  ListImage? get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }
}
