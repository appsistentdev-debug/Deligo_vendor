// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProduct _$ListProductFromJson(Map<String, dynamic> json) => ListProduct(
      (json['data'] as List<dynamic>)
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListProductToJson(ListProduct instance) =>
    <String, dynamic>{
      'data': instance.products,
    };
