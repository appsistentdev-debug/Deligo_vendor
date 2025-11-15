import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/Themes/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color? color;
  final Color? textColor;

  BottomBar(
      {required this.onTap, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? kMainColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: bottomBarTextStyle.copyWith(color: textColor),
          ),
        ),
        height: 60.0,
      ),
    );
  }
}
