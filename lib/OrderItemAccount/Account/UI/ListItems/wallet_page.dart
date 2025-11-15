import 'package:delivoo_store/Components/placeholder_widgets.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UI/ListItems/addtobank_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/WalletBloc/wallet_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/WalletBloc/wallet_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/WalletBloc/wallet_state.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<WalletBloc>(
        create: (context) => WalletBloc(),
        child: Scaffold(
          body: BlocProvider<WalletBloc>(
            create: (context) => WalletBloc(),
            child: WalletStateful(),
          ),
        ),
      );
}

class WalletStateful extends StatefulWidget {
  @override
  _WalletStatefulState createState() => _WalletStatefulState();
}

class _WalletStatefulState extends State<WalletStateful> {
  double balance = 0;
  List<Transaction> transactions = [];
  bool isLoading = true;
  bool allDone = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<WalletBloc>(context).add(FetchWalletBalanceEvent());
    BlocProvider.of<WalletBloc>(context).add(FetchWalletTransactionsEvent(1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletBalanceLoaded) {
          balance = state.balance;
          setState(() {});
        }

        if (state is WalletTransactionsLoaded) {
          isLoading = false;
          page = state.transactionsResponse.meta.current_page ?? 1;
          allDone = state.transactionsResponse.meta.current_page ==
              state.transactionsResponse.meta.last_page;
          if (page == 1) {
            transactions.clear();
          }
          transactions.addAll(state.transactionsResponse.data);
          setState(() {});
        }

        if (state is WalletTransactionsFailed) {
          isLoading = false;
          setState(() {});
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                Assets.assetsWalletBgBig,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 220,
              ),
              Positioned(
                top: 0,
                right: 20,
                child: Image.asset(
                  Assets.assetsVectorWallet,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              PositionedDirectional(
                bottom: -10,
                start: 0,
                end: 0,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 30,
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 24.0)
                      .copyWith(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 24,
                            ),
                            // padding: const EdgeInsets.only(left: 16),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.wallet,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.availableBalance,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: orderGreenLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${AppSettings.currencyIcon} ${balance.toStringAsFixed(2)}",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: kWhiteColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          if (!isLoading)
                            MaterialButton(
                              color: theme.cardColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                if (balance > 0)
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddToBankPage(balance)))
                                      .then((value) {
                                    if (value != null &&
                                        (value as Map).containsKey("refresh") &&
                                        value["refresh"] == true) {
                                      transactions.clear();
                                      isLoading = true;
                                      allDone = false;
                                      page = 1;
                                      setState(() {});
                                      BlocProvider.of<WalletBloc>(context)
                                          .add(FetchWalletBalanceEvent());
                                      BlocProvider.of<WalletBloc>(context)
                                          .add(FetchWalletTransactionsEvent(1));
                                    }
                                  });
                                else
                                  showToast(AppLocalizations.of(context)!
                                      .getTranslationOf("no_balance"));
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 12.0),
                              child: Text(
                                AppLocalizations.of(context)!.sendToBank,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: kMainColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)!.recent,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Color(0xFFB0B0B0),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Shimmer.fromColors(
                              baseColor: theme.cardColor,
                              highlightColor: theme.cardColor,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        )
                      : transactions.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: PlaceholderWidgets.errorRetryWidget(
                                  context,
                                  AppLocalizations.of(context)!
                                      .getTranslationOf(
                                          "no_transactions_found"),
                                  AppLocalizations.of(context)!
                                      .getTranslationOf("okay"),
                                  () => Navigator.pop(context),
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: transactions.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 16,
                              ),
                              itemBuilder: (context, index) {
                                var transaction = transactions[index];
                                bool isPayout = transaction.type == 'payout';
                                bool isEarning = transaction.type == 'deposit';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction.meta?.description ??
                                                  AppLocalizations.of(context)!
                                                      .getTranslationOf(
                                                          transaction.type ??
                                                              "deposit"),
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              '${transaction.createdAtFormatted ?? "..."}',
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                color: Color(0xFFB0B0B0),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${AppSettings.currencyIcon}${(transaction.meta?.sourceAmount ?? transaction.amount)?.toStringAsFixed(2)}',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            transaction
                                                    .meta?.sourcePaymentType ??
                                                "",
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${AppSettings.currencyIcon}${transaction.amount?.toStringAsFixed(2)}',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: isPayout
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            isEarning
                                                ? 'Earning'
                                                : 'Withdrawal',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
