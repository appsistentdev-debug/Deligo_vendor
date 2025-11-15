import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SupportBloc/support_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SupportBloc/support_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SupportBloc/support_state.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/flavors.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<SupportBloc>(
        create: (context) => SupportBloc(),
        child: SupportBody(),
      );
}

class SupportBody extends StatefulWidget {
  @override
  _SupportBodyState createState() => _SupportBodyState();
}

class _SupportBodyState extends State<SupportBody> {
  TextEditingController _controller = TextEditingController();

  late SupportBloc _supportBloc;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _supportBloc = BlocProvider.of<SupportBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is LoadingSupportState) {
            Loader.showLoader(context);
          } else {
            Loader.dismissLoader(context);
          }

          if (state is SuccessSupportState) {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf('support_has_been_submitted'));
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppLocalizations.of(context)!.support,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Image(
                    image: AssetImage(
                      F.name == Flavor.vendor.name
                          ? (isDark
                              ? "assets/deligo_logo_dark.png"
                              : "assets/deligo_logo_light.png")
                          : (isDark
                              ? "assets/deliq_logo_dark.png"
                              : "assets/deliq_logo_light.png"),
                    ),
                    height: 130.0,
                    width: 99.7,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.orWrite,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text(
                          "Ask us of suggest anyway we can improve",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: kTextColor),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      EntryField(
                        title: AppLocalizations.of(context)!.message,
                        hint: AppLocalizations.of(context)!.enterMessage,
                        maxLines: 6,
                        controller: _controller,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BottomBar(
              text: AppLocalizations.of(context)!.submit,
              onTap: () {
                if (_controller.text.trim().length < 10 ||
                    _controller.text.trim().length > 140) {
                  showToast(AppLocalizations.of(context)!
                      .getTranslationOf("invalid_length_message"));
                } else {
                  _supportBloc.add(SupportEvent(_controller.text.trim()));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
