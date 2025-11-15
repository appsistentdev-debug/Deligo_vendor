import 'package:delivoo_store/UtilityFunctions/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'Auth/BLoC/auth_bloc.dart';
import 'UtilityFunctions/bloc_delegate.dart';
import 'app.dart';
import 'flavors.dart';
import 'language_cubit.dart';
import 'theme_cubit.dart';

//fvm flutter run --flavor deligo
void main() async {
  F.appFlavor =
      Flavor.values.firstWhere((element) => element.name == appFlavor);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  Bloc.observer = SimpleBlocDelegate();
  runApp(Phoenix(
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ConnectivityCubit()),
      ],
      child: App(),
    ),
  ));
}
