import 'package:delivoo_store/JsonFiles/insights/chart_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendor_insight.g.dart';

@JsonSerializable()
class VendorInsight {
  @JsonKey(name: 'orders')
  final dynamic ordersDynamic;
  @JsonKey(name: 'revenue')
  final dynamic revenueDynamic;
  @JsonKey(name: 'items_sold')
  final dynamic itemsSoldDynamic;

  @JsonKey(name: 'chart_data')
  final List<ChartData> chartData;
  @JsonKey(name: 'items_sold_chart')
  final List<ChartData> itemschartData;

  VendorInsight(
    this.ordersDynamic,
    this.revenueDynamic,
    this.itemsSoldDynamic,
    this.chartData,
    this.itemschartData,
  );

  factory VendorInsight.fromJson(Map<String, dynamic> json) =>
      _$VendorInsightFromJson(json);

  Map<String, dynamic> toJson() => _$VendorInsightToJson(this);

  int get orders => (ordersDynamic.runtimeType is int
      ? ordersDynamic
      : int.tryParse("$ordersDynamic") ?? 0);

  String get revenue => (revenueDynamic.runtimeType is double
          ? revenueDynamic
          : double.tryParse("$revenueDynamic") ?? 0.0)
      .toStringAsFixed(2);

  int get itemsSold => (itemsSoldDynamic.runtimeType is int
      ? itemsSoldDynamic
      : int.tryParse("$itemsSoldDynamic") ?? 0);

  static VendorInsight getDefault() => VendorInsight(0, 0, 0, [
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0")
      ], [
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0")
      ]);
}
