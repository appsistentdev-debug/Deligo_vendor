import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:equatable/equatable.dart';

class UpdateProfileState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SuccessUpdateProfile extends UpdateProfileState {
  final VendorInfo vendorInfo;

  SuccessUpdateProfile(this.vendorInfo);

  @override
  List<Object> get props => [vendorInfo];
}

class FailureUpdateProfile extends UpdateProfileState {
  final e;

  FailureUpdateProfile(this.e);

  @override
  List<Object> get props => [e];
}

class LoadingUpdateProfile extends UpdateProfileState {}
