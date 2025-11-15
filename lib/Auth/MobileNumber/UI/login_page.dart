import 'package:delivoo_store/Auth/MobileNumber/UI/mobile_input.dart';
import 'package:delivoo_store/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Auth/MobileNumber/Bloc/mobile_cubit.dart';
import 'package:delivoo_store/Auth/MobileNumber/UI/login_interactor.dart';
import 'package:delivoo_store/Auth/login_navigator.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<MobileCubit>(
        create: (context) => MobileCubit(),
        child: LoginBody(),
      );
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> implements LoginInteractor {
  late MobileCubit _mobileBloc;

  @override
  void initState() {
    _mobileBloc = BlocProvider.of<MobileCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<MobileCubit, MobileState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is LoginExistsLoaded) {
          goToNextScreen(
              state.isRegistered, state.normalizedPhoneNumber, context);
        } else if (state is LoginError) {
          showToast(
              AppLocalizations.of(context)!.getTranslationOf(state.messageKey));
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              F.name == Flavor.vendor.name
                  ? (isDark
                      ? "assets/deligo_logo_dark.png"
                      : "assets/deligo_logo_light.png")
                  : (isDark
                      ? "assets/deliq_logo_dark.png"
                      : "assets/deliq_logo_light.png"),
              height: 150.0,
              width: 150,
            ),
            const SizedBox(
              height: 100,
            ),
            Mobile(this),
          ],
        ),
      ),
    );
  }

  void goToNextScreen(
      bool isRegistered, String normalizedPhoneNumber, BuildContext context) {
    if (isRegistered) {
      Navigator.pushNamed(context, LoginRoutes.verification,
          arguments: LoginData(normalizedPhoneNumber, null, null));
    } else {
      Navigator.pushNamed(context, LoginRoutes.registration,
          arguments: normalizedPhoneNumber);
    }
  }

  @override
  void loginWithMobile(PhoneNumberData phoneNumberData) =>
      _mobileBloc.initLoginPhone(phoneNumberData);
}
