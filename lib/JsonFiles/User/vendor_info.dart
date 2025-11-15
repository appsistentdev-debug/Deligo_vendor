import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Commons/list_image.dart';
import 'package:delivoo_store/JsonFiles/User/Put/update_vendor_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendor_info.g.dart';

@JsonSerializable()
class VendorInfo {
  final int id;
  final String? name;
  final String? tagline;
  final String? details;
  final dynamic meta;

  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;

  @JsonKey(name: 'minimum_order')
  final int? minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final double? deliveryFee;
  final String? area;
  final String? address;
  final double? longitude;
  final double? latitude;

  @JsonKey(name: 'is_verified')
  final int? isVerified;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final List<CategoryData>? categories;
  @JsonKey(name: 'product_categories')
  final List<CategoryData>? productCategories;
  final UserInformation? user;
  final double? ratings;
  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;
  @JsonKey(name: 'favourite_count')
  final int? favouriteCount;
  @JsonKey(name: 'is_favourite')
  final bool? isFavourite;

  VendorInfo(
    this.id,
    this.name,
    this.tagline,
    this.details,
    this.meta,
    this.dynamicMediaUrls,
    this.minimumOrder,
    this.deliveryFee,
    this.area,
    this.address,
    this.longitude,
    this.latitude,
    this.isVerified,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.productCategories,
    this.user,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
  );

  factory VendorInfo.fromJson(Map<String, dynamic> json) =>
      _$VendorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VendorInfoToJson(this);

  UpdateVendorMeta? getMeta() {
    return (meta != null && meta is Map)
        ? (UpdateVendorMeta.fromJson(meta))
        : null;
  }

  String? get image => mediaUrls?.images?.first.defaultImage;

  ListImage? get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }
}
