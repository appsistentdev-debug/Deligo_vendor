import 'package:json_annotation/json_annotation.dart';

part 'update_vendor.g.dart';

@JsonSerializable()
class UpdateVendorInfo {
  final String? name;

  @JsonKey(name: 'tagline')
  final String? tagLine;
  final String? details;

  @JsonKey(name: 'minimun_order')
  final int? minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final int? deliveryFee;

  final String? area;
  final String? address;
  final double? longitude;
  final double? latitude;
  final List<int>? categories;

  @JsonKey(name: 'image_urls')
  final List? imageUrl;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;

  UpdateVendorInfo({
    this.name,
    this.tagLine,
    this.details,
    this.minimumOrder,
    this.deliveryFee,
    this.area,
    this.address,
    this.longitude,
    this.latitude,
    this.categories,
    this.imageUrl,
    this.dynamicMeta,
  });

  factory UpdateVendorInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateVendorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateVendorInfoToJson(this);

  String get meta {
    return (dynamicMeta != null && dynamicMeta is String) ? dynamicMeta : null;
  }
}
