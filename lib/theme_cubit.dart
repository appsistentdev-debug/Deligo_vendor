import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppConfig/app_config.dart';
import 'Constants/constants.dart';
import 'Themes/dark_theme.dart';
import 'Themes/light_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static final String isDarkTheme = "is_dark_theme";
  late bool _isDark;

  ThemeCubit()
      : super(AppConfig.themeDefault == Constants.themeDark
            ? darkTheme
            : appTheme) {
    _isDark = AppConfig.themeDefault == Constants.themeDark;
  }

  bool get isDark => _isDark;

  void setTheme(bool isDark) async {
    this._isDark = isDark;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isDarkTheme, isDark);
    emit(isDark ? darkTheme : appTheme);
  }
}
