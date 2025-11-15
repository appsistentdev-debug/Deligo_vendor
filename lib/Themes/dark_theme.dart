import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: false,
).copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  secondaryHeaderColor: kWhiteColor,
  primaryColor: kMainColor,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  primaryColorDark: Colors.white,
  unselectedWidgetColor: Color(0xffc7c9ce),

  // cardColor: Color(0xff212321),
  cardColor: Color(0xff1e1e1e),
  hintColor: const Color(0xff979ca7),
  canvasColor: Colors.black,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kMainColor,
  ),

  ///elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(kMainColor),
  )),

  ///text button theme
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

  ///app bar theme
  appBarTheme: AppBarTheme(
    color: kTransparentColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),

  ///text theme which contains all text styles
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
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16.7,
    ),

    //text style of we'll send verification code at register page
    titleLarge: TextStyle(
      color: kDisabledColor,
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
      color: Colors.white,
      fontSize: 13.3,
    ),

    labelSmall: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    displayMedium: TextStyle(
      color: Colors.white,
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
      bodyColor: Colors.white,
      displayColor: Colors.white),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kMainColor),
  tabBarTheme: TabBarThemeData(indicatorColor: kMainColor),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: kMainColor,
    backgroundColor: Color(0xFF27292E),
    selectedLabelStyle: TextStyle(
      color: Colors.black,
      fontSize: 10,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 10,
    ),
    unselectedItemColor: Color(0xFF4F5156),
  ),
);
