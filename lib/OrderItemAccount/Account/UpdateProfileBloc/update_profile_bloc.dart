import 'package:bloc/bloc.dart';
import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

import 'update_profile_event.dart';
import 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  AuthRepo _userRepository = AuthRepo();

  UpdateProfileBloc() : super(LoadingUpdateProfile());

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    yield* _mapUpdateProfileToState(event);
  }

  Stream<UpdateProfileState> _mapUpdateProfileToState(
      UpdateProfileEvent event) async* {
    yield LoadingUpdateProfile();
    try {
      //int id = (await _userRepository.getVendorByToken()).id;
      VendorInfo vendorInfo = await _userRepository.updateVendor(
          event.updateVendorInfo, event.vendorId);
      await Helper().saveVendorInfo(vendorInfo);
      await _userRepository.saveUser(vendorInfo.user!);
      yield SuccessUpdateProfile(vendorInfo);
    } catch (e) {
      yield FailureUpdateProfile(e);
    }
  }
}
