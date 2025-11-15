import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/insights/vendor_insight.dart';
import 'package:equatable/equatable.dart';

abstract class SummaryState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

//base states
class InitialSummaryState extends SummaryState {}

class LoadingSummaryState extends SummaryState {}

class LoadedSummaryState extends SummaryState {}

class FailureSummaryState extends SummaryState {}

//ingith states
class LoadingInsightState extends LoadingSummaryState {
  final String duration;
  LoadingInsightState(this.duration);
  @override
  List<Object> get props => [duration];
  @override
  bool get stringify => true;
}

class LoadedInsightState extends LoadedSummaryState {
  final VendorInsight vendorInsight;
  LoadedInsightState(this.vendorInsight);
  @override
  List<Object> get props => [vendorInsight];
  @override
  bool get stringify => true;
}

//top selling states
class LoadingTopSellingState extends LoadingSummaryState {}

class LoadedTopSellingState extends SummaryState {
  final List<ProductData> products;
  LoadedTopSellingState(this.products);
  @override
  List<Object> get props => [products];
  @override
  bool get stringify => true;
}
