// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorInsight _$VendorInsightFromJson(Map<String, dynamic> json) =>
    VendorInsight(
      json['orders'],
      json['revenue'],
      json['items_sold'],
      (json['chart_data'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['items_sold_chart'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VendorInsightToJson(VendorInsight instance) =>
    <String, dynamic>{
      'orders': instance.ordersDynamic,
      'revenue': instance.revenueDynamic,
      'items_sold': instance.itemsSoldDynamic,
      'chart_data': instance.chartData,
      'items_sold_chart': instance.itemschartData,
    };
