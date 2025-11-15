import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class Uninitialized extends AuthState {}

class Initialized extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class ProfileAdded extends AuthState {}

class RestartState extends AuthState {}

class FailureSettingsState extends AuthState {
  final e;

  FailureSettingsState(this.e);

  @override
  List<Object> get props => [e];
}
