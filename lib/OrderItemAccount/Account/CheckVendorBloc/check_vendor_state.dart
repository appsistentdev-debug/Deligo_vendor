part of 'check_vendor_bloc.dart';

abstract class CheckVendorState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CheckVendorInitial extends CheckVendorState {}

class CheckVendorSuccess extends CheckVendorState {
  final bool isStoreRegistered;
  final VendorInfo vendor;

  CheckVendorSuccess(this.isStoreRegistered, this.vendor);

  @override
  List<Object> get props => [isStoreRegistered, vendor];
}

class CheckVendorFailure extends CheckVendorState {
  final e;

  CheckVendorFailure(this.e);

  @override
  List<Object> get props => [e];
}
