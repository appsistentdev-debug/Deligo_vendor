import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class ItemsLoadingState extends ItemsState {}

class ItemsSuccessState extends ItemsState {
  final List<ProductData> products;
  ItemsSuccessState(this.products);
  @override
  List<Object> get props => [products];
}

class ItemsFailureState extends ItemsState {
  final e;
  ItemsFailureState(this.e);
  @override
  List<Object> get props => [e];
}
