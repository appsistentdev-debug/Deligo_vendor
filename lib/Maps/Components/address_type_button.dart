import 'package:delivoo_store/Themes/colors.dart';
import 'package:flutter/material.dart';

class AddressTypeButton extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Color selectedColor = Colors.white;
  final Color unSelectedColor = Colors.black;

  AddressTypeButton({
    required this.label,
    required this.image,
    this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        foregroundColor: isSelected ? selectedColor : unSelectedColor,
        backgroundColor: isSelected ? kMainColor : Theme.of(context).cardColor,
      ),
      onPressed: onPressed,
      icon: Image.asset(
        image,
        scale: 3.5,
        color: isSelected ? selectedColor : unSelectedColor,
      ),
      label: Text(label),
    );
  }
}
