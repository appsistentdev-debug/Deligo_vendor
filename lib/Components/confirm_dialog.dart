// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<dynamic> showConfirmation(
      BuildContext context,
      String titleText,
      String contentText,
      String? noButtonText,
      String yesButtonText) {
    ThemeData theme = Theme.of(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(titleText),
        content: Text(contentText),
        actions: [
          if (noButtonText != null)
            MaterialButton(
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColor)),
              onPressed: () => Navigator.pop(context, false),
              child: Text(noButtonText),
            ),
          MaterialButton(
            textColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor)),
            onPressed: () => Navigator.pop(context, true),
            child: Text(yesButtonText),
          ),
        ],
      ),
    );
  }
}
