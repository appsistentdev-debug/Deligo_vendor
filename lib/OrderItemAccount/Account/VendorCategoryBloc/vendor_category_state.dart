import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:equatable/equatable.dart';

abstract class VendorCategoryState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SuccessVendorCategoryState extends VendorCategoryState {
  final List<CategoryData> listCategories;

  SuccessVendorCategoryState(this.listCategories);

  @override
  List<Object> get props => [listCategories];
}

class LoadingVendorCategoriesState extends VendorCategoryState {}

class FailureVendorCategoryState extends VendorCategoryState {
  final dynamic e;

  FailureVendorCategoryState(this.e);

  @override
  List<Object> get props => [e];
}
