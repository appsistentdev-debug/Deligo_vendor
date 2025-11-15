import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:equatable/equatable.dart';

abstract class VendorCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

class FetchVendorCategoryEvent extends VendorCategoryEvent {
  final VendorInfo? vendorInfo;
  final String? vendorType;

  FetchVendorCategoryEvent({this.vendorInfo, this.vendorType});

  @override
  List<Object?> get props => [vendorInfo];
}
