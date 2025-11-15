import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

//States for list of orders.
class LoadingOrdersState extends OrdersState {}

class SuccessOrdersState extends OrdersState {
  final List<OrderData>? orders;
  final int updatedIndex;

  SuccessOrdersState(this.orders, this.updatedIndex);

  @override
  List<Object?> get props => [orders, updatedIndex];
}

class FailureOrdersState extends OrdersState {
  final e;

  FailureOrdersState(this.e);

  @override
  List<Object> get props => [e];
}

//States for single order.
class OrderSuccess extends OrdersState {
  final OrderData order;

  OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}
