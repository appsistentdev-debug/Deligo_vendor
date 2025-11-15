import 'package:buy_this_app/buy_this_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Components/animated_bottom_bar.dart';
import 'package:delivoo_store/Items/UI/items.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/account_page.dart';
import 'package:delivoo_store/OrderItemAccount/Order/UI/order_page.dart';

class OrderItemAccount extends StatefulWidget {
  @override
  _OrderItemAccountState createState() => _OrderItemAccountState();
}

class _OrderItemAccountState extends State<OrderItemAccount> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkForBuyNow();
  }

  @override
  Widget build(BuildContext context) {
    final List<BarItem> barItems = [
      BarItem(
        text: AppLocalizations.of(context)!.orderText,
        image: 'assets/footermenu/ic_orders.svg',
      ),
      BarItem(
        text: AppLocalizations.of(context)!.product,
        image: 'assets/footermenu/ic_items.svg',
      ),
      BarItem(
        text: AppLocalizations.of(context)!.account,
        image: 'assets/footermenu/ic_account.svg',
      ),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          OrderPage(),
          ItemsPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomBar(
        barItems: barItems,
        selectedBarIndex: _currentIndex,
        onBarTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  void _checkForBuyNow() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!(sharedPreferences.containsKey("KEY_BUY_THIS_SHOWN")) &&
        AppConfig.isDemoMode) {
      Future.delayed(Duration(seconds: 20), () async {
        if (mounted) {
          BuyThisApp.showSubscribeDialog(context);
          sharedPreferences.setBool("KEY_BUY_THIS_SHOWN", true);
        }
      });
    }
  }
}
