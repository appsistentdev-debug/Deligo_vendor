import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/JsonFiles/insights/vendor_insight.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  int? _profileId;

  SummaryBloc() : super(InitialSummaryState());

  ProductRepository _productRepository = ProductRepository();

  @override
  Stream<SummaryState> mapEventToState(SummaryEvent event) async* {
    if (event is FetchSummaryEvent) {
      yield* _mapFetchSummaryToState(event.duration);
    } else if (event is FetchBestSellingEvent) {
      yield* _mapFetchTopSellingToState();
    }
  }

  Stream<SummaryState> _mapFetchSummaryToState(String duration) async* {
    yield LoadingInsightState(duration);
    try {
      if (_profileId == null) {
        _profileId = (await Helper().getVendorInfo())?.id;
      }
      VendorInsight vendorInsight = await _productRepository.fetchInsights(
          _profileId!, _getRequest(duration));
      yield LoadedInsightState(vendorInsight);
    } catch (e) {
      print("_mapFetchSummaryToState ${e.runtimeType}: $e");
      yield LoadedInsightState(VendorInsight.getDefault());
    }
  }

  Stream<SummaryState> _mapFetchTopSellingToState() async* {
    yield LoadingTopSellingState();
    try {
      if (_profileId == null) {
        _profileId = (await Helper().getVendorInfo())?.id;
      }
      BaseListResponse<ProductData> products =
          await _productRepository.fetchTopSellingItems(_profileId!);
      yield LoadedTopSellingState(products.data);
    } catch (e) {
      print("_mapFetchTopSellingToState ${e.runtimeType}: $e");
      yield LoadedTopSellingState([]);
    }
  }

  Map<String, String> _getRequest(String duration) {
    switch (duration) {
      case "today":
        return {"duration": "hours", "limit": "${DateTime.now().hour}"};
      case "week":
        return {"duration": "days", "limit": "7"};
      case "month":
        return {"duration": "months", "limit": "12"};
      default:
        return {"duration": "years", "limit": "12"};
    }
  }
}
