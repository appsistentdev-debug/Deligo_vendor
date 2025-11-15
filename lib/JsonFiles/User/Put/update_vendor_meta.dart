import 'package:json_annotation/json_annotation.dart';

part 'update_vendor_meta.g.dart';

@JsonSerializable()
class UpdateVendorMeta {
  String? vendor_type;
  String? time;
  String? opening_time;
  String? closing_time;
  String? document_license;
  String? document_id;

  UpdateVendorMeta(this.vendor_type, this.time, this.opening_time,
      this.closing_time, this.document_license, this.document_id);

  factory UpdateVendorMeta.fromJson(Map<String, dynamic> json) =>
      _$UpdateVendorMetaFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateVendorMetaToJson(this);
}
