import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Components/confirm_dialog.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

import 'login_interactor.dart';

class Mobile extends StatefulWidget {
  final LoginInteractor loginPageInteractor;

  Mobile(this.loginPageInteractor);

  @override
  _MobileInputState createState() => _MobileInputState();
}

class _MobileInputState extends State<Mobile> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String? _dialCode, _isoCode;

  @override
  void initState() {
    if (AppConfig.isDemoMode) {
      _isoCode = "IN";
      _dialCode = '+91';
      _numberController.text = "8787878787";
      _countryController.text = "India";

      Future.delayed(
        Duration(seconds: 1),
        () => ConfirmDialog.showConfirmation(
            context,
            AppLocalizations.of(context)!.getTranslationOf("demo_login_title"),
            AppLocalizations.of(context)!
                .getTranslationOf("demo_login_message"),
            null,
            AppLocalizations.of(context)!.getTranslationOf("okay")),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Text(
              AppLocalizations.of(context)!.getTranslationOf("signin_title"),
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
          ),
          SizedBox(height: 16),

          Stack(
            children: [
              EntryField(
                hint: AppLocalizations.of(context)!
                    .getTranslationOf("select_country"),
                controller: _countryController,
                readOnly: true,
                title: AppLocalizations.of(context)!
                    .getTranslationOf("choose_country"),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: theme.hintColor,
                ),
              ),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: CountryCodePicker(
                  hideMainText: true,
                  dialogBackgroundColor: isDark ? Colors.black : Colors.white,
                  dialogTextStyle: theme.textTheme.bodyMedium
                      ?.copyWith(color: isDark ? Colors.white : Colors.black),
                  textStyle: theme.textTheme.bodyMedium
                      ?.copyWith(color: isDark ? Colors.white : Colors.black),
                  searchStyle: theme.textTheme.bodyMedium
                      ?.copyWith(color: isDark ? Colors.white : Colors.black),
                  searchDecoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 20,
                    ),
                    fillColor: isDark ? Colors.black12 : Colors.white10,
                    prefixIconColor: isDark ? Colors.black : Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.hintColor.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.hintColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if ((_dialCode == null || value.dialCode != _dialCode) ||
                        (_isoCode == null || value.code != _isoCode)) {
                      _dialCode = value.dialCode;
                      _isoCode = value.code;
                      _countryController.text = value.name ?? "";
                      _numberController.clear();
                      setState(() {});
                    }
                  },
                  builder: (value) => Padding(
                    padding: EdgeInsets.only(bottom: 7.0),
                  ),
                  initialSelection: _isoCode,
                  showFlag: false,
                  enabled: !(AppConfig.fireConfig?.disableCountryCodePicker ??
                      false),
                  showFlagDialog: true,
                  favorite: ['+91', 'US'],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          //takes phone number as input
          EntryField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            readOnly: false,
            hint: (_dialCode != null && _dialCode!.isNotEmpty)
                ? "${AppLocalizations.of(context)!.getTranslationOf("enter_phone_exluding")} $_dialCode"
                : AppLocalizations.of(context)!
                    .getTranslationOf("enter_phone_number"),
            title:
                AppLocalizations.of(context)!.getTranslationOf("phone_number"),
          ),

          // CustomTextField(
          //   controller: _numberController,
          //   hintText: (_dialCode != null && _dialCode!.isNotEmpty)
          //       ? "${AppLocalizations.of(context)!.getTranslationOf("enter_phone_exluding")} $_dialCode"
          //       : AppLocalizations.of(context)!
          //           .getTranslationOf("enter_phone"),
          //   title: (_dialCode != null && _dialCode!.isNotEmpty)
          //       ? "${AppLocalizations.of(context)!.getTranslationOf("enter_phone_exluding")} $_dialCode"
          //       : AppLocalizations.of(context)!
          //           .getTranslationOf("enter_phone"),
          //   textInputType: TextInputType.phone,
          //   // validator: (value) =>
          //   //     _numberController.text.validateMobileNumber("$_dialCode"),
          //   prefixIcon: CountryCodePicker(
          //     dialogTextStyle: theme.textTheme.bodyLarge,
          //     textStyle: theme.textTheme.bodySmall,
          //     onChanged: (value) {
          //       if ((_dialCode == null || value.dialCode != _dialCode) ||
          //           (_isoCode == null || value.code != _isoCode)) {
          //         _dialCode = value.dialCode;
          //         _isoCode = value.code;
          //         _countryController.text = value.name ?? "";
          //         _numberController.clear();
          //         setState(() {});
          //       }
          //     },
          //     padding: EdgeInsets.zero,
          //     initialSelection: _isoCode,
          //     favorite: const ['IN', 'US'],
          //     showDropDownButton: true,
          //     dialogBackgroundColor: theme.scaffoldBackgroundColor,
          //     showFlag: false,
          //   ),
          // ),

          //if phone number is valid, button gets enabled and takes to register screen
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 26),
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  AppLocalizations.of(context)!.continueText,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: kWhiteColor, fontSize: 15),
                ),
              ),
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () => _checkAndLogin(),
            ),
          ),
        ],
      ),
    );
  }

  _checkAndLogin() {
    Helper.clearFocus(context);
    if (_dialCode == null || _dialCode!.isEmpty) {
      showToast(
          AppLocalizations.of(context)!.getTranslationOf("choose_country"));
      return;
    }
    if (_numberController.text.trim().isEmpty) {
      showToast(AppLocalizations.of(context)!.getTranslationOf("enter_phone"));
      return;
    }
    ConfirmDialog.showConfirmation(
            context,
            "$_dialCode${_numberController.text.trim()}",
            AppLocalizations.of(context)!.getTranslationOf("alert_phone"),
            AppLocalizations.of(context)!.getTranslationOf("no"),
            AppLocalizations.of(context)!.getTranslationOf("yes"))
        .then((value) {
      if (value != null && value == true) {
        widget.loginPageInteractor.loginWithMobile(PhoneNumberData(
            _countryController.text,
            _isoCode,
            _dialCode,
            _numberController.text,
            null));
      }
    });
  }
}
