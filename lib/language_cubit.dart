import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(AppConfig.languageDefault));

  String _locale = AppConfig.languageDefault;

  String get currentLocale => _locale;

  void localeSelected(String key) {
    emit(Locale(key));
  }

  void getCurrentLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('locale')) {
      var langCode = prefs.getString('locale');
      if (langCode != null) {
        _locale = langCode;
      }
    }
    localeSelected(_locale);
  }

  setCurrentLanguage(String langCode, bool save) async {
    _locale = langCode;
    if (save) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', langCode);
    }
    localeSelected(langCode);
  }
}
