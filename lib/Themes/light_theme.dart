import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: 'GoogleSans',
  scaffoldBackgroundColor: Colors.white,
  secondaryHeaderColor: kMainTextColor,
  primaryColor: kMainColor,
  unselectedWidgetColor: const Color(0xffc7c9ce),
  primaryColorDark: Colors.black,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  splashColor: Colors.transparent,
  hoverColor: Colors.transparent,
  highlightColor: Colors.transparent,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kMainColor,
  ),
  canvasColor: Colors.black,
  cardColor: const Color(0xfff5f7f9),
  hintColor: const Color(0xff979ca7),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(kMainColor),
  )),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(kMainColor),
  )),
  bottomAppBarTheme: BottomAppBarThemeData(color: kMainColor),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    color: kTransparentColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(color: Colors.black),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
  //text theme which contains all text styles
  textTheme: TextTheme(
    //text style of 'Delivering almost everything' at phone_number page
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.3,
    ),

    //text style of 'Everything.' at phone_number page
    bodyMedium: TextStyle(
      fontSize: 18.3,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    labelLarge: TextStyle(
      fontSize: 13.3,
      color: kWhiteColor,
    ),

    //text style of 'Got Delivered' at home page
    headlineMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16.7,
    ),

    //text style of we'll send verification code at register page
    titleLarge: TextStyle(
      color: kLightTextColor,
      fontSize: 13.3,
    ),

    //text style of 'everything you need' at home page
    headlineSmall: TextStyle(
      color: kDisabledColor,
      fontSize: 20.0,
      letterSpacing: 0.5,
    ),

    //text entry text style
    bodySmall: TextStyle(
      color: kMainTextColor,
      fontSize: 13.3,
    ),

    labelSmall: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    displayMedium: TextStyle(
      color: kMainTextColor,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    titleSmall: TextStyle(
      color: kLightTextColor,
      fontSize: 13.3,
    ),
  ).apply(
      fontFamily: 'GoogleSans',
      bodyColor: Colors.black,
      displayColor: Colors.black),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kMainColor),

  dialogTheme: DialogThemeData(
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: kMainTextColor,
      fontFamily: 'GoogleSans',
    ),
    contentTextStyle: TextStyle(
      fontSize: 16.0,
      color: kDisabledColor,
      fontFamily: 'GoogleSans',
    ),
    // You can also specify other properties here like:
    // backgroundColor: Colors.white,
    // elevation: 8.0,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    // ),
  ),
  tabBarTheme: TabBarThemeData(indicatorColor: kMainColor),
);
