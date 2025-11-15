import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:flutter/material.dart';

class PlaceholderWidgets {
  static Widget loadingWidget(BuildContext context, [String? message]) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(kMainColor),
                  ),
                ),
              ),
              Text(
                message != null && message.isNotEmpty
                    ? message
                    : AppLocalizations.of(context)!.getTranslationOf("loading"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )),
    );
  }

  static Widget errorRetryWidget(BuildContext context, String message,
      [String? actionText, VoidCallback? action]) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (actionText != null && action != null)
                MaterialButton(
                  child: Text(
                    actionText,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: action,
                ),
            ],
          )),
    );
  }
}
