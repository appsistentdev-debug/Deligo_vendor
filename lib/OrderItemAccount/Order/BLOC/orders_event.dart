import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

//List order events
class FetchOrdersEvent extends OrdersEvent {}

class PaginateOrdersEvent extends OrdersEvent {}

//Single order events
class FetchOrderUpdatesEvent extends OrdersEvent {}

class FireOrderEvent extends OrdersEvent {
  final OrderData orderData;
  FireOrderEvent(this.orderData);
  @override
  List<Object> get props => [orderData];
}

class OrderAddedEvent extends FireOrderEvent {
  OrderAddedEvent(OrderData orderData) : super(orderData);
}

class OrderChangedEvent extends FireOrderEvent {
  OrderChangedEvent(OrderData orderData) : super(orderData);
}

class OrderCompletedEvent extends FireOrderEvent {
  OrderCompletedEvent(OrderData orderData) : super(orderData);
}
