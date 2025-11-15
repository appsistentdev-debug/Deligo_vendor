import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchItemsEvent extends ItemsEvent {
  final int categoryId;

  FetchItemsEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class PaginateItemsEvent extends ItemsEvent {
  final int categoryId;

  PaginateItemsEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class AddUpdateInList extends ItemsEvent {
  final ProductData productData;

  AddUpdateInList(this.productData);

  @override
  List<Object> get props => [productData];
}
