// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:delivoo_store/Auth/MobileNumber/UI/login_page.dart';
import 'package:delivoo_store/Auth/Registration/UI/register_page.dart';
import 'package:delivoo_store/Auth/Verification/UI/verification_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginRoutes {
  static const String loginRoot = 'login/';
  static const String registration = 'login/registration';
  static const String verification = 'login/verification';
}

class LoginData {
  final String phoneNumber;
  final String? name;
  final String? email;

  LoginData(this.phoneNumber, this.name, this.email);
}

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState?.canPop() ?? false;
        if (canPop) {
          navigatorKey.currentState!.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: LoginRoutes.loginRoot,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case LoginRoutes.loginRoot:
              builder = (BuildContext _) => LoginPage();
              break;
            case LoginRoutes.registration:
              builder = (BuildContext _) =>
                  RegisterPage(settings.arguments as String);
              break;
            case LoginRoutes.verification:
              LoginData loginData = settings.arguments as LoginData;
              builder = (BuildContext _) => VerificationPage(
                    loginData.phoneNumber,
                    loginData.name,
                    loginData.email,
                  );
              break;
            default:
              builder = (BuildContext _) => LoginPage();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
