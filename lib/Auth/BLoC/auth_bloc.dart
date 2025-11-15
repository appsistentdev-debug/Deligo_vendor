import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/JsonFiles/settings.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthRepo _userRepository;

  AuthBloc() : super(Uninitialized());

  void failed() {
    FlutterNativeSplash.remove();
    emit(FailureSettingsState("network_issue"));
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      await Firebase.initializeApp();
      if (AppConfig.onesignalAppId.isNotEmpty) {
        OneSignal.initialize(AppConfig.onesignalAppId);
        //await OneSignal.shared.promptUserForPushNotificationPermission();
        //_addOnesignalEvents();
      }
      await Helper().init();
      await _setupFireConfig();
      _userRepository = AuthRepo();
      try {
        await _setupSettings();
        yield* _mapAppStartedToState();
      } catch (e) {
        print("getSettings: $e");
        yield FailureSettingsState(e);
      }
    } else if (event is LoggedIn) {
      yield _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is AddProfile) {
      yield* _mapAddProfileToState(event.vendor);
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("language_selection_promted") &&
        AppConfig.isDemoMode) {
      prefs.setBool("language_selection_promted", true);
      yield Initialized();
    } else {
      UserInformation? userInformation = await Helper().getUserInfo();
      if (userInformation == null) {
        yield Unauthenticated();
      } else {
        yield Authenticated();
      }
    }
    FlutterNativeSplash.remove();
  }

  AuthState _mapLoggedInToState() {
    return Authenticated();
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    await _userRepository.logout();
    yield RestartState();
  }

  Stream<AuthState> _mapAddProfileToState(VendorInfo vendorInfo) async* {
    await Helper().saveVendorInfo(vendorInfo);
    await _userRepository.saveUser(vendorInfo.user!);
    _userRepository.updateNotificationId(vendorInfo.user!.id);
    yield ProfileAdded();
  }

  _setupFireConfig() async {
    if (AppConfig.fireConfig == null) {
      AppConfig.fireConfig = FireConfig();
      try {
        DatabaseReference configRef =
            FirebaseDatabase.instance.ref().child(Constants.REF_CONFIG);
        DataSnapshot databaseSnapshotFireConfig =
            (await configRef.once()).snapshot;
        if (databaseSnapshotFireConfig.value != null &&
            databaseSnapshotFireConfig.value is Map) {
          AppConfig.fireConfig!.countryIsoCode =
              ((databaseSnapshotFireConfig.value as Map)["countryIsoCode"]
                      as String?) ??
                  "US";
          AppConfig.fireConfig!.enableAmPm = ((databaseSnapshotFireConfig.value
                  as Map)["enableAmPm"] as bool?) ??
              false;
          AppConfig.fireConfig!.enableOrderRejectReason =
              ((databaseSnapshotFireConfig.value
                      as Map)["enableOrderRejectReason"] as bool?) ??
                  false;
          AppConfig.fireConfig!.disableCountryCodePicker =
              ((databaseSnapshotFireConfig.value
                      as Map)["disableCountryCodePicker"] as bool?) ??
                  false;
        }
      } catch (e) {
        print("setupFireConfig: $e");
      }
      print("FireConfig: ${AppConfig.fireConfig}");
    }
  }

  _setupSettings() async {
    bool setuped = await AppSettings.setupBase();
    if (setuped) {
      _userRepository
          .getSettings()
          .then((settings) => AppSettings.saveSettings(settings));
    } else {
      List<Setting> settings = await _userRepository.getSettings();
      await AppSettings.saveSettings(settings);
    }
  }

  // void _addOnesignalEvents() async {
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //       (OSNotificationReceivedEvent event) {
  //     if (kDebugMode) {
  //       print('FOREGROUND HANDLER CALLED WITH: $event');
  //     }
  //   });
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     if (kDebugMode) {
  //       print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
  //     }
  //   });
  // }
}
