import 'package:bloc/bloc.dart';
import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/Auth/MobileNumber/UI/login_interactor.dart';

part 'mobile_state.dart';

class MobileCubit extends Cubit<MobileState> {
  AuthRepo _userRepository = AuthRepo();

  MobileCubit() : super(const MobileInitial());

  void initLoginPhone(PhoneNumberData phoneNumberData) async {
    emit(const LoginLoading());
    String? normalizedNumber =
        "${phoneNumberData.dialCode}${phoneNumberData.phoneNumber}";
    try {
      bool isRegistered = await _userRepository.isRegistered(normalizedNumber);
      emit(LoginExistsLoaded(isRegistered, normalizedNumber));
    } catch (e) {
      print("isRegistered: $e");
      emit(const LoginError("Something went wrong", "something_wrong"));
    }
  }
}
