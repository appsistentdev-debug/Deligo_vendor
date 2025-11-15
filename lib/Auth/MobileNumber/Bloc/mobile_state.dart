part of 'mobile_cubit.dart';

abstract class MobileState {
  const MobileState();
}

class MobileInitial extends MobileState {
  const MobileInitial();
}

class LoginLoading extends MobileState {
  const LoginLoading();
}

class LoginExistsLoaded extends MobileState {
  final bool isRegistered;
  final String normalizedPhoneNumber;

  const LoginExistsLoaded(this.isRegistered, this.normalizedPhoneNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginExistsLoaded &&
          runtimeType == other.runtimeType &&
          isRegistered == other.isRegistered &&
          normalizedPhoneNumber == other.normalizedPhoneNumber;

  @override
  int get hashCode => isRegistered.hashCode ^ normalizedPhoneNumber.hashCode;
}

class LoginError extends MobileState {
  final String message, messageKey;

  const LoginError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;

  @override
  String toString() => 'LoginError(message: $message)';
}
