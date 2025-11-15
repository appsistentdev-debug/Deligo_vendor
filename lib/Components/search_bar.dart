import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hint;
  final VoidCallback? onTap;
  final Color? color;
  final BoxShadow? boxShadow;
  final bool autofocus, readOnly;

  CustomSearchBar({
    this.hint,
    this.onTap,
    this.color,
    this.boxShadow,
    this.autofocus = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeCubit _themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(color: kCardBackgroundColor),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: color ?? kCardBackgroundColor,
      ),
      child: TextField(
        readOnly: readOnly,
        autofocus: autofocus,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          icon: ImageIcon(
            AssetImage('assets/icons/ic_search.png'),
            color:
                _themeCubit.isDark ? Theme.of(context).hintColor : Colors.black,
            size: 16,
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.titleLarge,
          border: InputBorder.none,
        ),
        onTap: onTap,
      ),
    );
  }
}
