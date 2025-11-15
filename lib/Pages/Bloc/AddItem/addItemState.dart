import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:equatable/equatable.dart';

abstract class AddItemState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

//general AddItemState's
class AddItemStateInitial extends AddItemState {}

class AddItemStateLoading extends AddItemState {}

class AddItemStateLoaded extends AddItemState {}

class AddItemStateLoadFailed extends AddItemState {}

//categories states
class AddItemStateLoadingCategories extends AddItemStateLoading {}

class AddItemStateLoadedCategories extends AddItemStateLoaded {
  final List<CategoryData> categories;
  AddItemStateLoadedCategories(this.categories);
  @override
  List<Object> get props => [categories];
  @override
  bool get stringify => true;
}

class AddItemStateLoadFailedCategories extends AddItemStateLoadFailed {}

//addItems states
class AddItemStateLoadingProduct extends AddItemStateLoading {}

class AddItemStateLoadedProduct extends AddItemStateLoaded {
  final ProductData productData;
  AddItemStateLoadedProduct(this.productData);
  @override
  List<Object> get props => [productData];
  @override
  bool get stringify => true;
}

class AddItemStateLoadFailedProduct extends AddItemStateLoadFailed {}
