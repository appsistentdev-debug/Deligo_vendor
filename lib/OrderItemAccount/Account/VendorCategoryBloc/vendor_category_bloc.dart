import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';

import 'vendor_category_event.dart';
import 'vendor_category_state.dart';

class VendorCategoryBloc
    extends Bloc<VendorCategoryEvent, VendorCategoryState> {
  VendorCategoryBloc() : super(LoadingVendorCategoriesState());

  ProductRepository _repository = ProductRepository();

  @override
  Stream<VendorCategoryState> mapEventToState(
      VendorCategoryEvent event) async* {
    if (event is FetchVendorCategoryEvent) {
      yield* _mapFetchVendorCategoriesToState(
          event.vendorInfo, event.vendorType);
    }
  }

  Stream<VendorCategoryState> _mapFetchVendorCategoriesToState(
      VendorInfo? vendorInfo, String? vendorType) async* {
    try {
      print('VendorCategoryBloc: fetching categories for vendorType: $vendorType');
      List<CategoryData> listCategories =
          await _repository.getVendorCategory(vendorType);
      print('VendorCategoryBloc: received ${listCategories.length} categories -> ' +
          listCategories.map((c) => c.title).toList().toString());
      
      // If no categories found for specific vendor type, try fetching all categories
      if (listCategories.isEmpty && vendorType != null) {
        print('VendorCategoryBloc: No categories for vendor type "$vendorType", fetching all categories as fallback');
        listCategories = await _repository.getVendorCategory(null);
        print('VendorCategoryBloc: fallback received ${listCategories.length} categories');
      }
      
      listCategories.removeWhere((element) => element.slug == "custom");
      for (CategoryData categoryNew in listCategories) {
        categoryNew.isSelected = false;
        if (vendorInfo != null && vendorInfo.categories != null) {
          for (CategoryData categoryExisting in (vendorInfo.categories ?? [])) {
            if (categoryExisting.id == categoryNew.id) {
              categoryNew.isSelected = true;
              break;
            }
          }
        }
      }
      yield SuccessVendorCategoryState(listCategories);
    } catch (e) {
      print('VendorCategoryBloc: error fetching categories: $e');
      yield FailureVendorCategoryState(e);
    }
  }
}
