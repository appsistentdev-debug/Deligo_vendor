// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_vendor_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateVendorMeta _$UpdateVendorMetaFromJson(Map<String, dynamic> json) =>
    UpdateVendorMeta(
      json['vendor_type'] as String?,
      json['time'] as String?,
      json['opening_time'] as String?,
      json['closing_time'] as String?,
      json['document_license'] as String?,
      json['document_id'] as String?,
    );

Map<String, dynamic> _$UpdateVendorMetaToJson(UpdateVendorMeta instance) =>
    <String, dynamic>{
      'vendor_type': instance.vendor_type,
      'time': instance.time,
      'opening_time': instance.opening_time,
      'closing_time': instance.closing_time,
      'document_license': instance.document_license,
      'document_id': instance.document_id,
    };
