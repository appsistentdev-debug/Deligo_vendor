import 'package:buy_this_app/buy_this_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/Auth/BLoC/auth_bloc.dart';
import 'package:delivoo_store/Auth/BLoC/auth_event.dart';
import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/confirm_dialog.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/OrderItemAccount/StoreProfile/store_profile_account.dart';
import 'package:delivoo_store/Routes/routes.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:delivoo_store/generated/assets.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Account(),
        // BottomNavigationBar is assumed to be handled by the parent widget or main scaffold
      );
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isLoaderShowing = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FutureBuilder<VendorInfo?>(
      future: Helper().getVendorInfo(),
      builder: (BuildContext context, AsyncSnapshot<VendorInfo?> snapshot) =>
          Column(
        //physics: BouncingScrollPhysics(),
        children: [
          AppBar(
            title: Text(
              AppLocalizations.of(context)!.account,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (AppConfig.isDemoMode)
                Transform.scale(
                  scale: 0.8,
                  child: BuyThisApp.button(
                    AppConfig.appName,
                    'https://dashboard.vtlabs.dev/projects/envato-referral-buy-link?project_slug=cab_book_flutter',
                    target: Target.WhatsApp,
                    color: const Color(0xffF80048),
                  ),
                ),
              if (AppConfig.isDemoMode)
                const SizedBox(
                  width: 8,
                ),
            ],
          ),
          SizedBox(height: 24),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              if (snapshot.data != null) {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AccountProfilePage(snapshot.data!)))
                    .then((value) => setState(() {}));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?.name ?? "",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          snapshot.data?.address ?? "",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedImage(
                      snapshot.data?.image,
                      height: 76,
                      width: 76,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Wallet Card
          WalletMeGlance(),
          SizedBox(height: 24),
          // Menu List
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20),
              children: [
                _MenuItem(
                  icon: Icons.analytics,
                  text: AppLocalizations.of(context)!.insight,
                  onTap: () =>
                      Navigator.pushNamed(context, PageRoutes.insightPage),
                ),
                _MenuItem(
                  icon: Icons.star,
                  text: AppLocalizations.of(context)!.review,
                  onTap: () => Navigator.pushNamed(context, PageRoutes.review,
                      arguments: snapshot.data),
                ),
                _MenuItem(
                  icon: Icons.mail,
                  text: AppLocalizations.of(context)!.support,
                  onTap: () =>
                      Navigator.pushNamed(context, PageRoutes.supportPage),
                ),
                _MenuItem(
                  icon: Icons.help_outline,
                  text: AppLocalizations.of(context)!.getTranslationOf("faqs"),
                  onTap: () => Navigator.pushNamed(context, PageRoutes.faqs),
                ),
                _MenuItem(
                  icon: Icons.assignment,
                  text: AppLocalizations.of(context)!.tnc,
                  onTap: () => Navigator.pushNamed(context, PageRoutes.tncPage),
                ),
                _MenuItem(
                  icon: Icons.language_sharp,
                  text: AppLocalizations.of(context)!
                      .getTranslationOf("changeLanguage"),
                  onTap: () => Navigator.pushNamed(context, PageRoutes.setting),
                ),
                if (snapshot.data == null)
                  _MenuItem(
                    icon: Icons.assignment,
                    text: AppLocalizations.of(context)!.login,
                    onTap: () =>
                        Navigator.pushNamed(context, PageRoutes.loginNavigator),
                  ),
                if (snapshot.data != null)
                  _MenuItem(
                    icon: Icons.logout,
                    text: AppLocalizations.of(context)!.logout,
                    onTap: () => ConfirmDialog.showConfirmation(
                            context,
                            AppLocalizations.of(context)!.loggingOut,
                            AppLocalizations.of(context)!.areYouSure,
                            AppLocalizations.of(context)!.no,
                            AppLocalizations.of(context)!.yes)
                        .then(
                      (value) {
                        if (value == true) {
                          _doLogout();
                        }
                      },
                    ),
                  ),
                if (snapshot.data != null)
                  _MenuItem(
                    icon: Icons.delete,
                    text: AppLocalizations.of(context)!
                        .getTranslationOf("delete_account"),
                    onTap: () => ConfirmDialog.showConfirmation(
                            context,
                            AppLocalizations.of(context)!
                                .getTranslationOf("delete_account"),
                            AppLocalizations.of(context)!
                                .getTranslationOf("delete_account_msg"),
                            AppLocalizations.of(context)!.no,
                            AppLocalizations.of(context)!.yes)
                        .then(
                      (value) {
                        if (value == true) {
                          _doDeleteAccount();
                        }
                      },
                    ),
                  ),
              ]
                  .map((item) => InkWell(
                        onTap: item.onTap,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 40),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                color: kMainColor,
                                size: 24,
                              ),
                              SizedBox(width: 20),
                              Text(
                                item.text,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          if (AppConfig.isDemoMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BuyThisApp.developerRowVerbose(
                theme.scaffoldBackgroundColor,
                theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  void _doLogout() => BlocProvider.of<AuthBloc>(context).add(LoggedOut());

  void _doDeleteAccount() async {
    Loader.showLoader(context);
    try {
      await AuthRepo().deleteUser();
      showToast(AppLocalizations.of(context)!
          .getTranslationOf("delete_account_success"));
      BlocProvider.of<AuthBloc>(context).add(LoggedOut());
    } catch (e) {
      print("deleteAccount: $e");
      showToast(AppLocalizations.of(context)!
          .getTranslationOf("delete_account_failure"));
    }
    Loader.dismissLoader(context);
  }
}

class WalletMeGlance extends StatefulWidget {
  const WalletMeGlance({super.key});

  @override
  State<WalletMeGlance> createState() => _WalletMeGlanceState();
}

class _WalletMeGlanceState extends State<WalletMeGlance> {
  @override
  Widget build(BuildContext context) {
    ProductRepository repository = ProductRepository();
    ThemeData theme = Theme.of(context);
    return FutureBuilder<WalletBalance?>(
      future: repository.getBalance(),
      builder: (BuildContext context,
              AsyncSnapshot<WalletBalance?> snapshotBalance) =>
          GestureDetector(
        onTap: () => Navigator.pushNamed(context, PageRoutes.walletPage)
            .then((value) => setState(() {})),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.accountWalletBg,
              ),
              Row(
                children: [
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.flash_on,
                      color: kMainColor,
                      size: 36,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .getTranslationOf("wallet"),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${AppSettings.currencyIcon} ${snapshotBalance.data?.balance.toStringAsFixed(0) ?? 0}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  _MenuItem({required this.icon, required this.text, required this.onTap});
}
