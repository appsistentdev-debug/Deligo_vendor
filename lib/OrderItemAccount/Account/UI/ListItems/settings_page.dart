import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Auth/BLoC/auth_bloc.dart';
import 'package:delivoo_store/Auth/BLoC/auth_event.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/language_cubit.dart';
import 'package:delivoo_store/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeList {
  final String title, subtitle, value;

  ThemeList({required this.title, required this.subtitle, required this.value});
}

class SettingsPage extends StatefulWidget {
  final bool fromRoot;

  SettingsPage([this.fromRoot = false]);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late LanguageCubit _languageCubit;
  late ThemeCubit _themeCubit;
  late String selectedTheme, selectedLocale;

  @override
  void initState() {
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    selectedTheme = _themeCubit.isDark ? 'dark_mode' : 'light_mode';
    selectedLocale = _languageCubit.currentLocale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.fromRoot
            ? Text(
                AppLocalizations.of(context)!
                    .getTranslationOf("language")
                    .padLeft(14),
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold))
            : Text(
                AppLocalizations.of(context)!.getTranslationOf("language"),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<LanguageCubit, Locale>(builder: (_, locale) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: AppConfig.languagesSupported.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => setState(() => selectedLocale =
                      AppConfig.languagesSupported.keys.elementAt(index)),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedLocale ==
                                AppConfig.languagesSupported.keys
                                    .elementAt(index)
                            ? theme.primaryColor.withValues(alpha: 0.4)
                            : kTextColor.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: selectedLocale ==
                              AppConfig.languagesSupported.keys.elementAt(index)
                          ? theme.primaryColor.withValues(alpha: 0.2)
                          : theme.scaffoldBackgroundColor,
                    ),
                    child: Text(
                      AppConfig
                          .languagesSupported[AppConfig.languagesSupported.keys
                              .elementAt(index)]!
                          .name,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: selectedLocale ==
                                AppConfig.languagesSupported.keys
                                    .elementAt(index)
                            ? theme.primaryColor
                            : theme.secondaryHeaderColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(bottom: 28.0, left: 16, right: 16, top: 8),
        child: BottomBar(
            text: AppLocalizations.of(context)!.getTranslationOf('update'),
            onTap: () {
              _languageCubit.setCurrentLanguage(selectedLocale, true);
              _themeCubit.setTheme(selectedTheme == 'dark_mode');
              if (widget.fromRoot) {
                BlocProvider.of<AuthBloc>(context).add(AppStarted());
              } else {
                Navigator.pop(context);
              }
            }),
      ),
    );
  }
}
