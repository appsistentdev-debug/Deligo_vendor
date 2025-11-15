import 'package:delivoo_store/Themes/colors.dart';
import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final String? label;
  final String? image;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final InputBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  final String? Function(String? value)? validator;
  final ValueChanged<String>? onSaved;
  final Key? myKey;
  final InputBorder? inputBorder;
  final bool shrink;
  final bool restrictHeight;
  final TextAlignVertical? textAlignVertical;

  EntryField({
    this.title,
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.border,
    this.maxLines,
    this.suffixIcon,
    this.onTap,
    this.textCapitalization,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.myKey,
    this.inputBorder,
    this.shrink = false,
    this.restrictHeight = false,
    this.textAlignVertical,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
          ),
          SizedBox(height: shrink ? 0 : 13),
        ],
        SizedBox(
          height: restrictHeight ? 64 : null,
          child: TextFormField(
            key: myKey,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            textAlignVertical: textAlignVertical,
            cursorColor: kMainColor,
            onTap: onTap,
            autofocus: false,
            controller: controller,
            initialValue: initialValue,
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            minLines: 1,
            maxLength: maxLength,
            maxLines: maxLines,
            validator: validator,
            onChanged: onSaved,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.cardColor,
              prefixIcon: prefixIcon ?? null,
              suffixIcon: suffixIcon,
              hintText: hint ?? label,
              hintStyle:
                  theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
              border: inputBorder ?? _getBorder(theme.hintColor),
              enabledBorder: _getBorder(theme.primaryColor),
              focusedBorder: _getBorder(theme.primaryColor),
              counter: Offstage(),
            ),
          ),
        ),
      ],
    );
  }

  InputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color.withValues(alpha: 0.3), width: 0.5),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
