import 'package:flutter/material.dart';

// Color kMainColor = Color(0xff009D06);
// Color kDisabledColor = Color(0xffA9ABB0);
// Color kWhiteColor = Colors.white;
// Color kLightTextColor = Color(0xffc1c1c1);
// Color kCardBackgroundColor = Color(0xfff8f9fd);
// Color kCardColor = Color(0xfff5f7f9);

// Color kTransparentColor = Colors.transparent;
// Color kHintColor = Color(0xff999e93);
// Color kTextColor = const Color(0xff8B8D92);
// Color kMainTextColor = Color(0xff000000);
// Color declineButtonColor = Colors.red;
// Color kOrangeColor = Color(0xffF19823);
// Color kIconColor = Color(0xffBBBBBB);
// Color kRedColor = Color(0xffEB5757);
// Color kLightRedColor = Color(0xffFFD2D2);
// Color orderGreenLight = const Color(0xffE9FFCE);
// Color orderOrangeLight = const Color(0xffFFEAC2);
// Color orderBlack = const Color(0xff27292E);
// Color orderBlackLight = const Color(0xffEFF1F6);

Color kMainColor = Color(0xFFF57C00);
Color kDisabledColor = Color(0xFF0B2A55);
Color kWhiteColor = Colors.white;
Color kLightTextColor = Color(0xFF0B2A55);
Color kCardBackgroundColor = Color(0xfff8f9fd);
Color kCardColor = Color(0xfff5f7f9);

Color kTransparentColor = Colors.transparent;
Color kHintColor = Color(0xff999e93);
Color kTextColor = const Color(0xFF0B2A55);
Color kMainTextColor = Color(0xff000000);
Color declineButtonColor = Colors.red;
Color kOrangeColor = Color(0xffF19823);
Color kIconColor = Color(0xFF0B2A55);
Color kRedColor = Color(0xffEB5757);
Color kLightRedColor = Color(0xffFFD2D2);
Color orderGreenLight = const Color(0xffE9FFCE);
Color orderOrangeLight = const Color(0xffFFEAC2);
Color orderBlack = const Color(0xff27292E);
Color orderBlackLight = const Color(0xffEFF1F6);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
