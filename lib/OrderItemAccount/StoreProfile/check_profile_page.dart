import 'package:delivoo_store/Components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Auth/BLoC/auth_bloc.dart';
import 'package:delivoo_store/Auth/BLoC/auth_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/CheckVendorBloc/check_vendor_bloc.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/StoreProfile/store_profile_account.dart';

class CheckProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<CheckVendorBloc>(
        create: (context) => CheckVendorBloc()..add(CheckVendorEvent()),
        child: CheckProfileBody(),
      );
}

class CheckProfileBody extends StatefulWidget {
  @override
  _CheckProfileBodyState createState() => _CheckProfileBodyState();
}

class _CheckProfileBodyState extends State<CheckProfileBody> {
  @override
  Widget build(BuildContext context) =>
      BlocListener<CheckVendorBloc, CheckVendorState>(
        listener: (context, state) {
          if (state is CheckVendorSuccess) {
            if (state.isStoreRegistered) {
              BlocProvider.of<AuthBloc>(context).add(AddProfile(state.vendor));
            }
          } else {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf("were_logged_out"));
            BlocProvider.of<AuthBloc>(context).add(LoggedOut());
          }
        },
        child: BlocBuilder<CheckVendorBloc, CheckVendorState>(
          builder: (context, state) =>
              state is CheckVendorSuccess && !state.isStoreRegistered
                  ? AccountProfilePage(
                      state.vendor,
                      fromRoot: true,
                    )
                  : Scaffold(
                      body: Center(
                        child: Loader.circularProgressIndicatorPrimary(context),
                      ),
                    ),
        ),
      );
}
