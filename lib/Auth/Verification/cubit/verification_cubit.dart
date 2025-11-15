import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/login_response.dart';

part 'verification_state.dart';

abstract class VerificationCallbacks {
  void onCodeSent();

  void onCodeSendError(bool codeSent);

  void onCodeVerifying();

  void onCodeVerified(LoginResponse loggedInResponse);

  void onCodeVerificationError(String erroCode);
}

class VerificationCubit extends Cubit<VerificationState>
    implements VerificationCallbacks {
  AuthRepo _authRepo = AuthRepo();

  VerificationCubit() : super(VerificationLoading());

  void initAuthentication(String phoneNumberFull) {
    Future.delayed(const Duration(milliseconds: 500),
        () => emit(const VerificationSendingLoading()));
    _authRepo.otpSend(phoneNumberFull, this);
  }

  void verifyOtp(String otp) async {
    if (_isOtpValid(otp)) {
      onCodeVerifying();
      await _authRepo.otpVerify(otp, this);
    } else {
      emit(VerificationError("Please enter a valid otp", "otp_invalid"));
    }
  }

  @override
  void onCodeSent() {
    emit(VerificationSentLoaded());
  }

  @override
  void onCodeSendError(bool codeSent) {
    emit(VerificationError("Something went wrong",
        codeSent ? "something_wrong_verifying" : "something_wrong_sending"));
  }

  @override
  void onCodeVerifying() {
    emit(VerificationVerifyingLoading());
  }

  @override
  void onCodeVerified(LoginResponse loggedInResponse) {
    emit(VerificationVerifyingLoaded(loggedInResponse));
  }

  bool _isOtpValid(String otp) {
    RegExp otpPattern = RegExp('^\\d{6}\$');
    return otpPattern.hasMatch(otp);
  }

  @override
  void onCodeVerificationError(String erroCode) {
    emit(VerificationError("Something went wrong", erroCode));
  }
}
