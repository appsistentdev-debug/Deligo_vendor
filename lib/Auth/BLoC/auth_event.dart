import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}

class AddProfile extends AuthEvent {
  final VendorInfo vendor;

  AddProfile(this.vendor);

  @override
  List<Object> get props => [vendor];
}
