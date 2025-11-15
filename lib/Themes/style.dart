import 'package:delivoo_store/Themes/colors.dart';
import 'package:flutter/material.dart';

Widget timePickerBuilder(ThemeData theme, Widget child) => Theme(
      data: theme.copyWith(
        colorScheme: ColorScheme.light(
          primary: theme.primaryColor,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          dayPeriodColor: theme.dividerColor,
          helpTextStyle: theme.textTheme.titleLarge?.copyWith(
            color: Colors.black,
          ),
        ),
      ),
      child: child,
    );

//text style of continue bottom bar
final TextStyle bottomBarTextStyle = TextStyle(
  fontSize: 18.0,
  color: kWhiteColor,
  fontWeight: FontWeight.w600,
  fontFamily: 'GoogleSans',
);

//text style of text input and account page list
final TextStyle inputTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontFamily: 'GoogleSans',
);

final TextStyle listTitleTextStyle = TextStyle(
  fontSize: 16.7,
  fontWeight: FontWeight.bold,
  color: kMainColor,
  fontFamily: 'GoogleSans',
);

final TextStyle titleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Color(0xFF1D1F24),
  fontFamily: 'GoogleSans',
);

final TextStyle orderMapAppBarTextStyle = TextStyle(
  fontSize: 13.3,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: 'GoogleSans',
);

final ColorFilter invertColor = ColorFilter.matrix([
  -1, //RED
  0,
  0,
  0,
  255, //GREEN
  0,
  -1,
  0,
  0,
  255, //BLUE
  0,
  0,
  -1,
  0,
  255, //ALPHA
  0,
  0,
  0,
  1,
  0,
]);
