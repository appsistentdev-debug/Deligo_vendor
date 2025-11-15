// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivoo_store/Auth/AuthRepo/test_status_code.dart';
import 'package:delivoo_store/Auth/Verification/cubit/verification_cubit.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/login_response.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Auth/check_user_json.dart';
import 'package:delivoo_store/JsonFiles/Auth/login_json.dart';
import 'package:delivoo_store/JsonFiles/Auth/register_json.dart';
import 'package:delivoo_store/JsonFiles/Notification/notification.dart';
import 'package:delivoo_store/JsonFiles/Support/support_json.dart';
import 'package:delivoo_store/JsonFiles/User/Put/update_vendor.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/JsonFiles/file_upload_response.dart';
import 'package:delivoo_store/JsonFiles/settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_client.dart';
import 'auth_interceptor.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Dio dio;
  final AuthClient client;
  String? _verificationId;
  int? _resendToken;

  AuthRepo._(this.dio, this.client);

  factory AuthRepo() {
    Dio dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    AuthClient client = AuthClient(dio);
    return AuthRepo._(dio, client);
  }

  Future<bool> saveUser(UserInformation user) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_info', json.encode(user.toJson()));
  }

  ///check whether the user is registered or not
  Future<bool> isRegistered(String number) {
    CheckUser checkUser = CheckUser(mobileNumber: number);
    return client.checkUser(checkUser).then((value) => true).catchError(
        (Object obj) => false,
        test: (obj) => TestStatusCode.check(obj, 422));
  }

  ///register user
  Future<void> registerUser(String phoneNumber, String name, String email) {
    RegisterUser registerUser = RegisterUser(
      name: name,
      email: email,
      role: 'vendor',
      mobileNumber: phoneNumber,
    );
    return client.registerUser(registerUser);
  }

  ///phone number Sign In
  // Future<Null> signInWithPhoneNumber(
  //     AuthCredential authCredential, String phoneNumber) async {
  //   await _firebaseAuth.signInWithCredential(authCredential);
  //   var user = _firebaseAuth.currentUser;
  //   var idToken = await user.getIdToken();
  //   print(idToken);
  //   Login login = Login(token: idToken, role: 'vendor');
  //   final loginResponse = await client.login(login);
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('token', loginResponse.token);
  //   await updateNotificationId();
  // }

  Future<LoginResponse> signInWithPhoneNumber(String fireToken) async {
    Login loginRequest = Login(token: fireToken, role: 'vendor');
    return await client.login(loginRequest);
  }

  AuthCredential getCredential(String verId, String otp) {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
    return credential;
  }

  Future<void> logout() async {
    await Helper().deInit();
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("firebaseAuth.signOut: $e");
    }
  }

  Future<void> support(String message) async {
    UserInformation? userInformation = await Helper().getUserInfo();
    if (userInformation == null) return;
    Support support = Support(
      name: userInformation.name,
      email: userInformation.email,
      message: message,
    );
    return client.createSupport(support);
  }

  Future<VendorInfo> getVendorByToken() => client.getVendorByToken();

  Future<VendorInfo> updateVendor(UpdateVendorInfo updateVendor, int id) async {
    return client.updateVendor(id, updateVendor);
  }

  Future<void> updateNotificationId(int userId) async {
    try {
      await OneSignal.Notifications.requestPermission(true);

      await FirebaseDatabase.instance
          .ref()
          .child(Constants.REF_USERS_FCM_IDS)
          .child("$userId${Constants.ROLE_USER}")
          .set(OneSignal.User.pushSubscription.id!);

      await client.updateNotificationId(Notification(
          "{\"${Constants.ROLE_VENDOR}\":\"${OneSignal.User.pushSubscription.id!}\"}"));
    } catch (e) {
      if (kDebugMode) {
        print("userLanguageAndPlayerId: $e");
      }
    }
  }

  Future<void> otpSend(
      String phoneNumberFull, VerificationCallbacks verificationCallback) {
    _resendToken = -1;
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberFull,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (Platform.isAndroid) {
          verificationCallback.onCodeVerifying();
          _fireSignIn(credential, verificationCallback);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("FirebaseAuthException: $e");
        print("FirebaseAuthException_message: ${e.message}");
        print("FirebaseAuthException_code: ${e.code}");
        print("FirebaseAuthException_phoneNumber: ${e.phoneNumber}");
        verificationCallback.onCodeSendError(_resendToken != -1);
        FirebaseDatabase.instance
            .ref()
            .child("fire_app/issues")
            .child("seller")
            .child("FirebaseAuthException_Send")
            .set("${e.message} - ${e.toString()}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        verificationCallback.onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) =>
          _verificationId = verificationId,
      timeout: const Duration(seconds: 60),
    );
  }

  otpVerify(String otp, VerificationCallbacks verificationCallback) {
    _fireSignIn(
        PhoneAuthProvider.credential(
            verificationId: _verificationId!, smsCode: otp),
        verificationCallback);
  }

  _fireSignIn(AuthCredential credential,
      VerificationCallbacks verificationCallback) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      try {
        var user = _firebaseAuth.currentUser;
        var idToken = await user?.getIdToken();
        final loggedInResponse = await signInWithPhoneNumber(idToken!);

        await Helper().setAuthToken(loggedInResponse.token);
        await Helper().setUserInfo(loggedInResponse.userInfo);
        await updateNotificationId(loggedInResponse.userInfo.id);

        verificationCallback.onCodeVerified(loggedInResponse);
      } catch (e) {
        print("signInWithCredential - ${e.runtimeType}: $e");
        String errorToReturn = "something_wrong";
        if (e is DioError) {
          //signout of social accounts.
          try {
            logout();
          } catch (le) {
            print(le);
          }
          if ((e).response != null) {
            Map<String, dynamic> errorResponse = (e).response?.data;
            if (errorResponse.containsKey("message")) {
              String errorMessage = errorResponse["message"] as String;
              print("errorMessage: $errorMessage");
              if (errorMessage.toLowerCase().contains("role")) {
                errorToReturn = "role_exists";
              }
            }
          }
        }
        verificationCallback.onCodeVerificationError(errorToReturn);
        FirebaseDatabase.instance
            .ref()
            .child("fire_app/issues")
            .child("delivery")
            .child("FirebaseAuthException_Verify")
            .set(e.toString());
      }
    } catch (e) {
      print("signInWithCredential - ${e.runtimeType}: $e");
      verificationCallback.onCodeVerificationError("unable_otp_verification");
    }
  }

  Future<void> deleteUser() => client.deleteUser();

  Future<List<Setting>> getSettings() {
    return client.getSettings();
  }

  Future<FileUploadResponse> uploadFile(File file) =>
      client.uploadFile(file: file);
}
