part of 'update_order_bloc.dart';

abstract class UpdateOrderStatusEvent extends Equatable {
  final Map<String, dynamic>? updateBody;

  UpdateOrderStatusEvent(this.updateBody);

  @override
  List<Object?> get props => [updateBody];

  @override
  bool get stringify => true;
}

class RefreshOrderEvent extends UpdateOrderStatusEvent {
  RefreshOrderEvent([Map<String, dynamic>? updateBody]) : super(updateBody);
}

class DoUpdateEvent extends UpdateOrderStatusEvent {
  DoUpdateEvent(super.updateBody);
}
