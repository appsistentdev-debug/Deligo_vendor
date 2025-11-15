import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onTap;
  final String? hint;
  final PreferredSizeWidget? bottom;
  final Color? color;
  final BoxShadow? boxShadow;
  final bool? centerTitle;
  final bool autofocus, readOnly;

  CustomAppBar({
    this.titleWidget,
    this.actions,
    this.leading,
    this.onTap,
    this.hint,
    this.bottom,
    this.color,
    this.boxShadow,
    this.autofocus = false,
    this.readOnly = false,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: centerTitle,
        titleSpacing: 0.0,
        leading: leading,
        title: titleWidget,
        actions: actions,
        bottom: bottom
      );
}
