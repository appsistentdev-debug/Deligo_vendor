import 'package:delivoo_store/Components/regular_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Post/send_to_bank.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SendToBankBloc/send_to_bank_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SendToBankBloc/send_to_bank_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SendToBankBloc/send_to_bank_state.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/Themes/style.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';

class AddToBankPage extends StatelessWidget {
  final double balance;

  const AddToBankPage(this.balance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
        title: AppLocalizations.of(context)!.sendToBank,
      ),
      body: BlocProvider<SendToBankBloc>(
        create: (context) => SendToBankBloc(),
        child: AddToBankBody(balance),
      ),
    );
  }
}

class AddToBankBody extends StatefulWidget {
  final double balance;

  const AddToBankBody(this.balance);

  @override
  _AddToBankBodyState createState() => _AddToBankBodyState();
}

class _AddToBankBodyState extends State<AddToBankBody> {
  bool isLoaderShowing = false;
  late SendToBankBloc _sendToBankBloc;
  TextEditingController _holderNameController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _branchCodeController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sendToBankBloc = BlocProvider.of<SendToBankBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendToBankBloc, SendToBankState>(
      listener: (context, state) {
        if (state is LoadingSendToBankState) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is SuccessSendToBankState ||
            state is FailureSendToBankState) {
          showToast(AppLocalizations.of(context)!.getTranslationOf(
              state is SuccessSendToBankState
                  ? "request_submitted"
                  : "request_submition_failed"));
          Navigator.pop(context, {"refresh": state is SuccessSendToBankState});
        }
      },
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                EntryField(
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  controller: _amountController,
                  title: AppLocalizations.of(context)!.enterAmountToTransfer,
                  hint: 'Enter here',
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.availableBalance +
                        '  ' +
                        AppSettings.currencyIcon +
                        ' ' +
                        widget.balance.toString(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        letterSpacing: 0.67,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kMainTextColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 10.0, left: 8, right: 8),
                  child: Text(
                    AppLocalizations.of(context)!.bankInfo,
                    style: titleTextStyle,
                  ),
                ),
                SizedBox(height: 10),
                EntryField(
                  textCapitalization: TextCapitalization.words,
                  controller: _holderNameController,
                  title: AppLocalizations.of(context)!.accountHolderName,
                  hint: 'Enter here',
                ),
                SizedBox(height: 20),
                EntryField(
                  textCapitalization: TextCapitalization.words,
                  controller: _bankNameController,
                  title: AppLocalizations.of(context)!.bankName,
                  hint: 'Enter here',
                ),
                SizedBox(height: 20),
                EntryField(
                  textCapitalization: TextCapitalization.none,
                  controller: _branchCodeController,
                  title: AppLocalizations.of(context)!.branchCode,
                  hint: 'Enter here',
                ),
                SizedBox(height: 20),
                EntryField(
                  textCapitalization: TextCapitalization.none,
                  controller: _accountNumberController,
                  title: AppLocalizations.of(context)!.accountNumber,
                  hint: 'Enter here',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: BottomBar(
                text: AppLocalizations.of(context)!.sendToBank,
                onTap: () {
                  if (_bankNameController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_field_bank_name"));
                  } else if (_holderNameController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_field_bank_account_name"));
                  } else if (_accountNumberController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_field_bank_account_number"));
                  } else if (_branchCodeController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_field_bank_code"));
                  } else if (double.tryParse(_amountController.text.trim()) ==
                          null ||
                      ((double.tryParse(_amountController.text.trim()) ?? 0)) >
                          widget.balance) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_field_amount"));
                  } else {
                    _sendToBankBloc.add(SendToBankEvent(SendToBank(
                        _bankNameController.text,
                        _holderNameController.text,
                        _accountNumberController.text,
                        _branchCodeController.text,
                        double.parse(_amountController.text))));
                  }
                }),
          )
        ],
      ),
    );
  }
}
