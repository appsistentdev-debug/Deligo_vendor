import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';

part 'check_vendor_event.dart';
part 'check_vendor_state.dart';

class CheckVendorBloc extends Bloc<CheckVendorEvent, CheckVendorState> {
  CheckVendorBloc() : super(CheckVendorInitial());

  AuthRepo _authRepo = AuthRepo();

  @override
  Stream<CheckVendorState> mapEventToState(CheckVendorEvent event) async* {
    try {
      VendorInfo vendor = await _authRepo.getVendorByToken();

      List<String> vts =
          AppSettings.vendorType.split(",").map((e) => e.trim()).toList();
      vts.removeWhere((element) => element.isEmpty);

      yield CheckVendorSuccess(
        vts.contains(vendor.getMeta()?.vendor_type),
        vendor,
      );
    } catch (e) {
      yield CheckVendorFailure(e);
    }
  }
}
