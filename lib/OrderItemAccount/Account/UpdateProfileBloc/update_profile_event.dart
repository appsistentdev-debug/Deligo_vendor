import 'package:delivoo_store/JsonFiles/User/Put/update_vendor.dart';
import 'package:equatable/equatable.dart';

class UpdateProfileEvent extends Equatable {
  final int vendorId;
  final UpdateVendorInfo updateVendorInfo;

  UpdateProfileEvent(this.vendorId, this.updateVendorInfo);

  @override
  List<Object> get props => [vendorId, updateVendorInfo];

  @override
  bool get stringify => true;
}
