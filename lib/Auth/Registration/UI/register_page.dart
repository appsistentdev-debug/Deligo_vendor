import 'package:delivoo_store/Components/regular_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Auth/Registration/Bloc/register_bloc.dart';
import 'package:delivoo_store/Auth/Registration/Bloc/register_event.dart';
import 'package:delivoo_store/Auth/Registration/Bloc/register_state.dart';
import 'package:delivoo_store/Auth/login_navigator.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

class RegisterPage extends StatelessWidget {
  final String phoneNumber;

  RegisterPage(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
        title: AppLocalizations.of(context)!.register,
      ),
      //this column contains 3 textFields and a bottom bar
      body: BlocProvider<RegisterBloc>(
        create: (BuildContext context) => RegisterBloc(),
        child: RegisterForm(phoneNumber),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String phoneNumber;

  RegisterForm(this.phoneNumber);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late RegisterBloc _registerBloc;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state.isSuccess) {
          Navigator.pushReplacementNamed(context, LoginRoutes.verification,
              arguments: LoginData(widget.phoneNumber, _nameController.text,
                  _emailController.text));
        } else {
          if (state.isServerError) {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf("phone_email_taken"));
          } else if (!state.isNameValid) {
            showToast(AppLocalizations.of(context)!.invalidName);
          } else if (!state.isEmailValid) {
            showToast(AppLocalizations.of(context)!.invalidEmail);
          } else if (!state.isNameValid && !state.isEmailValid) {
            showToast(AppLocalizations.of(context)!.invalidNameAndEmail);
          }
        }
      },
      child:
          BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!
                      .getTranslationOf("signup_title"),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                //name textField
                EntryField(
                  controller: _nameController,
                  hint: AppLocalizations.of(context)!.fullName,
                  title: AppLocalizations.of(context)!
                      .getTranslationOf("fullName"),
                ),
                SizedBox(height: 30),
                //phone textField
                EntryField(
                  title: AppLocalizations.of(context)!.mobileNumber,
                  initialValue: widget.phoneNumber,
                  readOnly: true,
                ),

                SizedBox(height: 30),
                //email textField
                EntryField(
                  controller: _emailController,
                  title: AppLocalizations.of(context)!.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                ),
                // Text(
                //   AppLocalizations.of(context)!.verificationText,
                //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                //         color: Theme.of(context).hintColor,
                //       ),
                // ),

                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BottomBar(
                    text: AppLocalizations.of(context)!.continueText,
                    onTap: () => _onFormSubmitted(),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  void _onFormSubmitted() {
    Helper.clearFocus(context);
    _registerBloc.add(
      SubmittedEvent(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: widget.phoneNumber),
    );
  }
}
