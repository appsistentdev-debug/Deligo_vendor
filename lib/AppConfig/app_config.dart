import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/Locale/english.dart';
import 'package:delivoo_store/Locale/french.dart';
import 'package:delivoo_store/Locale/german.dart';
import 'package:delivoo_store/Locale/indonesian.dart';
import 'package:delivoo_store/Locale/italian.dart';
import 'package:delivoo_store/Locale/portuguese.dart';
import 'package:delivoo_store/Locale/spanish.dart';
import 'package:delivoo_store/Locale/swahili.dart';
import 'package:delivoo_store/Locale/turkish.dart';
import 'package:delivoo_store/flavors.dart';

class AppConfig {
  static String appName = F.title;
  static const String baseUrl = "http://10.0.2.2:8000/api/";
  static const String googleApiKey = "YourGoogleMapsApiKey";
  static const String onesignalAppId = "98fecee9-ad67-4d49-bd1a-f959569f3cbc";
  static final String languageDefault = "en";
  static const String themeDefault = Constants.themeLight;
  static const Map<String, double> mapCenterDefault = {
    "latitude": 28.6440836,
    "longitude": 77.0932313,
  };
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English", englishLocale()),
    //"ar": AppLanguage("عربى", arabicLocale()),
    "fr": AppLanguage("Français", frenchLocale()),
    "es": AppLanguage("Española", spanishLocale()),
    "id": AppLanguage("Bahasa Indonesia", indonesianLocale()),
    "de": AppLanguage("Deutsch", germanLocale()),
    "pt": AppLanguage("Português", portugueseLocale()),
    "tr": AppLanguage("Türk", turkishLocale()),
    "it": AppLanguage("Italiano", italianLocale()),
    "sw": AppLanguage("Kiswahili", swahiliLocale()),
  };
  static final bool isDemoMode = false;
  static FireConfig? fireConfig;
}

class FireConfig {
  String countryIsoCode = "US";
  bool enableAmPm = false;
  bool enableOrderRejectReason = false;
  bool disableCountryCodePicker = false;
}

class AppLanguage {
  final String name;
  final Map<String, String> values;

  AppLanguage(this.name, this.values);
}
