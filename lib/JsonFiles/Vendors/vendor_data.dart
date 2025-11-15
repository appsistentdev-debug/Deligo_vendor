import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Commons/list_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendor_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Vendor {
  final int id;
  final String name;
  final String tagline;
  final String details;
  final meta;

  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;

  @JsonKey(name: 'minimum_order')
  final int minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final double deliveryFee;
  final String area;
  final String address;
  final double longitude;
  final double latitude;

  @JsonKey(name: 'is_verified')
  final int isVerified;

  @JsonKey(name: 'user_id')
  final int userId;

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
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? vendorType;

  Vendor(
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
    this.user,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
    this.productCategories,
  );

  factory Vendor.fromJson(Map json) => _$VendorFromJson(json);

  Map toJson() => _$VendorToJson(this);

  ListImage? get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }

  void setup() {
    try {
      vendorType = (meta as Map)["vendor_type"];
    } catch (e) {
      // ignore: avoid_print
      print("meta: $e");
    }
  }
}
