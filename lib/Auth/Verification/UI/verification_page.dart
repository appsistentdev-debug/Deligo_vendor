import 'dart:async';

import 'package:delivoo_store/Components/regular_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Auth/BLoC/auth_bloc.dart';
import 'package:delivoo_store/Auth/BLoC/auth_event.dart';
import 'package:delivoo_store/Auth/Verification/cubit/verification_cubit.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

//Verification page that sends otp to the phone number entered on phone number page
class VerificationPage extends StatelessWidget {
  final String phoneNumber;
  final String? name;
  final String? email;

  VerificationPage(this.phoneNumber, this.name, this.email);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: RegularAppBar(
          title: AppLocalizations.of(context)!.verification,
        ),
        body: BlocProvider<VerificationCubit>(
          create: (BuildContext context) => VerificationCubit(),
          child: OtpVerify(phoneNumber, name, email),
        ),
      );
}

//otp verification class
class OtpVerify extends StatefulWidget {
  final String phoneNumber;
  final String? name;
  final String? email;

  OtpVerify(this.phoneNumber, this.name, this.email);

  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _controller = TextEditingController();
  bool isLoaderShowing = false;
  late VerificationCubit _verificationCubit;
  late AppLocalizations _locale;

  int _counter = 60;
  Timer? _timer;

  _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) =>
            setState(() => _counter > 0 ? _counter-- : _timer?.cancel()));
  }

  @override
  void initState() {
    super.initState();
    _verificationCubit = context.read<VerificationCubit>();
    _verificationCubit.initAuthentication(widget.phoneNumber);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context)!;
    return BlocListener<VerificationCubit, VerificationState>(
      listener: (context, state) {
        print("VerificationState IS: ${state.runtimeType}");
        if (state is VerificationLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is VerificationSentLoaded) {
          _startTimer();
          showToast(_locale.getTranslationOf("code_sent"));
          if (AppConfig.isDemoMode &&
              widget.phoneNumber.contains("8787878787")) {
            _controller.text = "123456";
            _verificationCubit.verifyOtp("123456");
          }
        } else if (state is VerificationVerifyingLoaded) {
          Navigator.popUntil(context, (route) => route.isFirst);
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        } else if (state is VerificationError) {
          showToast(_locale.getTranslationOf(state.messageKey));
          // if (state.messageKey == "something_wrong" ||
          //     state.messageKey == "role_exists") {
          //   Navigator.of(context).pop();
          // }
        }
      },
      child: BlocBuilder<VerificationCubit, VerificationState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                _locale.enterVerification,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30),
              EntryField(
                controller: _controller,
                readOnly: false,
                title: _locale.verificationCode,
                maxLength: 6,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "$_counter ${_locale.getTranslationOf('sec')}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  MaterialButton(
                    child: Text(
                      _locale.resend,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    textColor: _counter < 1 ? kDisabledColor : kLightTextColor,
                    // padding: EdgeInsets.all(24.0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor)),
                    onPressed: () {
                      if (_counter < 1) {
                        _verificationCubit
                            .initAuthentication(widget.phoneNumber);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 50),
              BottomBar(
                text: _locale.continueText,
                onTap: () {
                  Helper.clearFocus(context);
                  if (_controller.text.trim().isNotEmpty) {
                    _verificationCubit.verifyOtp(_controller.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
