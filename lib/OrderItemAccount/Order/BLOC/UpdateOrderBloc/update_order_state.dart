part of 'update_order_bloc.dart';

abstract class UpdateOrderStatusState extends Equatable {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

//base states
class UpdateOrderInitial extends UpdateOrderStatusState {}

class UpdateLoading extends UpdateOrderStatusState {}

class UpdateLoaded extends UpdateOrderStatusState {
  final OrderData orderData;
  UpdateLoaded(this.orderData);
  @override
  List<Object?> get props => [orderData];
}

class UpdateLoadFailed extends UpdateOrderStatusState {
  final String errMsgKey;
  UpdateLoadFailed(this.errMsgKey);
}

//order refresh states
class RefreshingOrderLoading extends UpdateLoading {}

class RefreshingOrderLoaded extends UpdateLoaded {
  final Map<String, dynamic>? updateBody;
  RefreshingOrderLoaded(this.updateBody, OrderData orderData)
      : super(orderData);
  @override
  List<Object?> get props => [updateBody, orderData];
}

class RefreshingOrderFailed extends UpdateLoadFailed {
  RefreshingOrderFailed(String errMsgKey) : super(errMsgKey);
}

//order update states
class UpdatingOrderLoading extends UpdateLoading {}

class UpdatingOrderLoaded extends UpdateLoaded {
  UpdatingOrderLoaded(OrderData orderData) : super(orderData);
}

class UpdatingOrderFailed extends UpdateLoadFailed {
  UpdatingOrderFailed(String errMsgKey) : super(errMsgKey);
}
