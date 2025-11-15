// ignore_for_file: deprecated_member_use

import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Commons/list_image.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_groups.dart';
import 'package:delivoo_store/JsonFiles/Products/vendor_product.dart';
import 'package:json_annotation/json_annotation.dart';

import 'food_type_meta.dart';

part 'product_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ProductData {
  final int id;
  final String title;
  final String detail;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  final double price;
  final String owner;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @JsonKey(name: 'attribute_term_id')
  final int? attributeTermId;
  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'addon_groups')
  final List<AddOnGroups>? addOnGroups;
  final List<CategoryData>? categories;
  @JsonKey(name: 'vendor_products')
  final List<VendorProduct>? vendorProducts;
  final double? ratings;

  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;

  @JsonKey(name: 'favourite_count')
  final int? favouriteCount;

  @JsonKey(name: 'is_favourite')
  final bool? isFavourite;

  @JsonKey(ignore: true)
  int quantity = 0;

  ProductData(
    this.id,
    this.title,
    this.detail,
    this.dynamicMeta,
    this.price,
    this.owner,
    this.parentId,
    this.attributeTermId,
    this.createdAt,
    this.updatedAt,
    this.addOnGroups,
    this.categories,
    this.vendorProducts,
    this.dynamicMediaUrls,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
  );

  factory ProductData.fromJson(Map json) => _$ProductDataFromJson(json);

  Map toJson() => _$ProductDataToJson(this);

  FoodTypeMeta? get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? FoodTypeMeta.fromJson(dynamicMeta)
        : null;
  }

  String? get image => mediaUrls?.images?.first.defaultImage;

  ListImage? get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }

  String get variationSummary {
    String toReturn = "";
    for (AddOnGroups g in (addOnGroups ?? [])) {
      toReturn += g.title ?? "";
      toReturn += "(";
      toReturn += (g.addOnChoices
                  ?.map(
                    (e) => e.title,
                  )
                  .toList() ??
              [])
          .join(", ");
      toReturn += "), ";
    }
    if (toReturn.isNotEmpty) {
      toReturn = toReturn.substring(0, toReturn.length - 2);
      //toReturn += ".";
    }
    return toReturn;
  }
}
