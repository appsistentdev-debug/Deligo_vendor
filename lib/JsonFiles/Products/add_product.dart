import 'package:delivoo_store/JsonFiles/Products/addon_group_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_product.g.dart';

@JsonSerializable()
class AddProduct {
  final String title;
  final String detail;
  final double price;

  @JsonKey(name: 'vendor_id')
  final int vendorId;
  final List<String> categories;

  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  final List<AddonGroupsRequest> addon_groups;

  AddProduct(this.title, this.detail, this.price, this.vendorId,
      this.categories, this.imageUrls, this.stockQuantity, this.addon_groups);

  factory AddProduct.fromJson(Map<String, dynamic> json) =>
      _$AddProductFromJson(json);

  Map<String, dynamic> toJson() => _$AddProductToJson(this);
}
