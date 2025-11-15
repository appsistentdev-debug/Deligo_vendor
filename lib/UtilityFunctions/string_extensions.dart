import 'package:phone_numbers_parser/phone_numbers_parser.dart';

extension StringExtension on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String? normalisePhoneNumber(String isoCode) {
    if (isBlank) return null;
    PhoneNumber number = PhoneNumber.parse(
      this!,
      callerCountry: IsoCode.fromJson(isoCode),
    );
    if (number.isValid()) {
      return number.international;
    }
    return null;
  }
}
