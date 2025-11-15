import 'dart:convert';

import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/JsonFiles/custom_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._privateConstructor() {
    _initPref();
  }

  static final Helper _instance = Helper._privateConstructor();

  factory Helper() => _instance;

  _initPref() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  SharedPreferences? _sharedPreferences;
  UserInformation? _userData;
  String? _authToken;

  init() async {
    await _initPref();
    await getAuthToken();
    await getUserInfo();
  }

  deInit() async {
    await _initPref();
    await setAuthToken(null);
    await setUserInfo(null);
    _sharedPreferences?.clear();
  }

  Future<String?> getAuthToken() async {
    await _initPref();
    _authToken ??= _sharedPreferences!.getString("token");
    return _authToken;
  }

  Future<bool> setAuthToken(String? token) async {
    await _initPref();
    this._authToken = token;
    return token == null
        ? _sharedPreferences!.remove("token")
        : _sharedPreferences!.setString("token", token);
  }

  Future<UserInformation?> getUserInfo() async {
    await _initPref();
    try {
      if (_userData == null) {
        var userData = _sharedPreferences!.getString("user_info");
        if (userData == null) return null;
        _userData = UserInformation.fromJson(json.decode(userData));
      }
    } catch (e) {
      print("getUserInfo: $e");
    }
    return _userData;
  }

  Future<bool> setUserInfo(UserInformation? userInfo) async {
    await _initPref();
    this._userData = userInfo;
    if (userInfo == null) {
      await _sharedPreferences!.remove("photo");
      return _sharedPreferences!.remove("user_info");
    } else {
      if (userInfo.image != null) {
        _sharedPreferences!.setString("photo", userInfo.image!);
      }
      return _sharedPreferences!
          .setString("user_info", json.encode(userInfo.toJson()));
    }
  }

  Future<VendorInfo?> getVendorInfo() async {
    await _initPref();
    var vendorInfo = _sharedPreferences!.getString("vendor_info");
    if (vendorInfo == null) return null;
    return VendorInfo.fromJson(json.decode(vendorInfo));
  }

  Future<bool> saveVendorInfo(VendorInfo? vendorInfo) async {
    await _initPref();
    if (vendorInfo == null) {
      return _sharedPreferences!.remove("vendor_info");
    } else {
      return _sharedPreferences!
          .setString("vendor_info", json.encode(vendorInfo.toJson()));
    }
  }

  Future<CustomLocation?> getSavedLocation() async {
    await _initPref();
    Map? savedMediaMap = _sharedPreferences!.containsKey("key_my_loc")
        ? (json.decode(_sharedPreferences!.getString("key_my_loc")!))
        : null;
    return savedMediaMap != null
        ? CustomLocation.fromJson(savedMediaMap as Map<String, dynamic>)
        : null;
  }

  Future<void> setSavedLocation(CustomLocation myLocation) async {
    await _initPref();
    _sharedPreferences!.setString("key_my_loc", json.encode(myLocation));
  }

  Future<bool> saveCategoriesHome(List<CategoryData> homeCats) async {
    await _initPref();
    return _sharedPreferences!.setString("home_cats_key", jsonEncode(homeCats));
  }

  Future<List<CategoryData>> getCategoriesHome() async {
    await _initPref();
    String? settingVal = _sharedPreferences!.getString("home_cats_key");
    if (settingVal != null && settingVal.isNotEmpty) {
      try {
        return (jsonDecode(settingVal) as List)
            .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print("getCategoriesHome(): $e");
        }
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<bool> launchCustomUrl(String urlToLaunch) async {
    try {
      Uri uri = Uri.parse(urlToLaunch);
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("launch: $e");
      return false;
    }
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }

    if (tokens.isEmpty) {
      tokens.add('${seconds}s');
    }

    return tokens.join(' ');
  }

  static String formatDurationHhMmSs(Duration duration) =>
      duration.toString().substring(2, 7);

  static String formatDurationAgoFromMillis(int millis) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(millis);
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).ceil().toString() + ' WEEKS AGO';
      }
    }
    return time;
  }

  static String formatDate(String createdAt, bool fullDate) {
    DateTime dateTime = Helper._dateUtcCheckParse(createdAt);
    return DateFormat(fullDate
            ? "d'${Helper._dateSuffix(dateTime.day)}' MMM yyyy"
            : "dd MMM")
        .format(dateTime);
  }

  static String formatTime(String timeStamp, bool amPm) =>
      DateFormat(amPm ? "h:mm a" : "HH:mm")
          .format(Helper._dateUtcCheckParse(timeStamp));

  static String formatDateTime(String createdAt, bool fullDate, bool amPm) {
    DateTime dateTime = Helper._dateUtcCheckParse(createdAt);
    return DateFormat(fullDate
            ? "d'${Helper._dateSuffix(dateTime.day)}' MMM yyyy, ${amPm ? 'h:mm a' : 'HH:mm'}"
            : "d'${Helper._dateSuffix(dateTime.day)}' MMM, ${amPm ? 'h:mm a' : 'HH:mm'}")
        .format(dateTime);
  }

  static String formatDateFromMillis(int millis, bool fullDate) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateFormat(fullDate
            ? "d'${Helper._dateSuffix(dateTime.day)}' MMM yyyy"
            : "d'${Helper._dateSuffix(dateTime.day)}' MMM")
        .format(dateTime);
  }

  static String formatTimeFromMillis(int millis, bool amPm) =>
      DateFormat(amPm ? "h:mm a" : "HH:mm")
          .format(DateTime.fromMillisecondsSinceEpoch(millis));

  static String formatDateTimeFromMillis(int millis, bool fullDate, bool amPm) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateFormat(fullDate
            ? "d'${Helper._dateSuffix(dateTime.day)}' MMM yyyy, ${amPm ? 'h:mm a' : 'HH:mm'}"
            : "d'${Helper._dateSuffix(dateTime.day)}' MMM, ${amPm ? 'h:mm a' : 'HH:mm'}")
        .format(dateTime);
  }

  static String _dateSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static DateTime _dateUtcCheckParse(String toCheck) {
    String createdAt = DateTime.parse(toCheck).toString();
    bool isUtc = createdAt.endsWith("000") || createdAt.endsWith("000Z");
    print("isUtc: $isUtc");
    DateTime dateTime = isUtc
        ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(createdAt, true)
        : DateTime.parse(createdAt);
    if (isUtc) {
      dateTime = dateTime.toLocal();
    }
    return dateTime;
  }

  static void clearFocus(BuildContext context) {
    try {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild!.unfocus();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
