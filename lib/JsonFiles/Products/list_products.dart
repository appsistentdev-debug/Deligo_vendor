import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_products.g.dart';

@JsonSerializable()
class ListProduct {
  @JsonKey(name: 'data')
  final List<ProductData> products;

  ListProduct(this.products);
  factory ListProduct.fromJson(Map<String, dynamic> json) =>
      _$ListProductFromJson(json);

  Map<String, dynamic> toJson() => _$ListProductToJson(this);
}
