import 'package:buy_this_app/buy_this_app.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivoo_store/Components/error_final_widget.dart';
import 'package:delivoo_store/Themes/dark_theme.dart';
import 'package:delivoo_store/Themes/light_theme.dart';
import 'package:delivoo_store/UtilityFunctions/connectivity_cubit.dart';
import 'package:delivoo_store/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'Auth/BLoC/auth_bloc.dart';
import 'Auth/BLoC/auth_event.dart';
import 'Auth/BLoC/auth_state.dart';
import 'Auth/login_navigator.dart';
import 'Locale/locales.dart';
import 'OrderItemAccount/Account/UI/ListItems/settings_page.dart';
import 'OrderItemAccount/StoreProfile/check_profile_page.dart';
import 'OrderItemAccount/order_item_account.dart';
import 'Routes/routes.dart';
import 'language_cubit.dart';
import 'splash.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // void _initializeApp() {
  //   BlocProvider.of<ConnectivityCubit>(context).monitorInternet();
  //   BlocProvider.of<AuthBloc>(context).add(AppStarted());
  //   BlocProvider.of<LanguageCubit>(context).getCurrentLanguage();
  // }
  void _initializeApp() async {
    ConnectivityCubit cc = BlocProvider.of<ConnectivityCubit>(context);
    cc.monitorInternet();
    bool ic = await cc.checkConnectivity();
    if (mounted) {
      if (ic) {
        BlocProvider.of<AuthBloc>(context).add(AppStarted());
        BlocProvider.of<LanguageCubit>(context).getCurrentLanguage();
      } else {
        BlocProvider.of<AuthBloc>(context).failed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LanguageCubit, Locale>(builder: (_, locale) {
      return MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          BuyThisApp.delegate,
        ],
        supportedLocales: AppLocalizations.getSupportedLocales(),
        locale: locale,
        theme: appTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RestartState) {
              Phoenix.rebirth(context);
            }
          },
          builder: (BuildContext context, authState) {
            switch (authState.runtimeType) {
              case Initialized:
                return SettingsPage(true);
              case Unauthenticated:
                return LoginNavigator();
              case Authenticated:
                return CheckProfilePage();
              case ProfileAdded:
                return OrderItemAccount();
              case FailureSettingsState:
                return BlocListener<ConnectivityCubit, ConnectivityState>(
                  listener: (context, state) {
                    if (state.isConnected) {
                      _initializeApp();
                    }
                  },
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: ErrorFinalWidget.errorWithRetry(
                      context: context,
                      message: AppLocalizations.of(context)!
                          .getTranslationOf("network_issue"),
                      imageAsset: Assets.emptyOrders,
                      actionText: AppLocalizations.of(context)!
                          .getTranslationOf("okay"),
                      action: () => SystemNavigator.pop(),
                    ),
                  ),
                );
              default:
                return SplashScreenSecondary();
            }
          },
        ),
        routes: PageRoutes().routes(),
      );
    });
  }
}
