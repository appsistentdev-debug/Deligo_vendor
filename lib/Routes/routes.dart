import 'package:delivoo_store/Auth/login_navigator.dart';
import 'package:delivoo_store/Maps/UI/location_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/faqs_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/insight_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/reviews.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/settings_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/support_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/tnc_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/wallet_page.dart';
import 'package:delivoo_store/OrderItemAccount/Order/UI/order_info_page.dart';
import 'package:delivoo_store/OrderItemAccount/Order/UI/order_page.dart';
import 'package:delivoo_store/OrderItemAccount/order_item_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageRoutes {
  static const String locationPage = 'location_page';
  static const String orderItemAccountPage = 'order_item_account';
  static const String orderPage = 'order_page';
  static const String orderInfoPage = 'orderinfo_page';
  static const String tncPage = 'tnc_page';
  static const String savedAddressesPage = 'saved_addresses_page';
  static const String supportPage = 'support_page';
  static const String walletPage = 'wallet_page';
  static const String loginNavigator = 'login_navigator';
  static const String insightPage = 'insight_page';
  static const String review = 'reviews';
  static const String setting = 'settings_page';
  static const String faqs = 'faqs_page';

  Map<String, WidgetBuilder> routes() => {
        locationPage: (context) => LocationPage(),
        orderPage: (context) => OrderPage(),
        tncPage: (context) => TncPage(),
        supportPage: (context) => SupportPage(),
        loginNavigator: (context) => LoginNavigator(),
        walletPage: (context) => WalletPage(),
        insightPage: (context) => InsightPage(),
        orderItemAccountPage: (context) => OrderItemAccount(),
        review: (context) => ReviewPage(),
        setting: (context) => SettingsPage(),
        orderInfoPage: (context) => OrderInfoPage(),
        faqs: (context) => FaqsPage(),
      };
}
