// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_vendors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVendors _$ListVendorsFromJson(Map<String, dynamic> json) => ListVendors(
      (json['data'] as List<dynamic>)
          .map((e) => Vendor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListVendorsToJson(ListVendors instance) =>
    <String, dynamic>{
      'data': instance.listOfData,
    };
