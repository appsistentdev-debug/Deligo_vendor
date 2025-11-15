import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivoo_store/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo_store/Auth/BLoC/auth_bloc.dart';
import 'package:delivoo_store/Auth/BLoC/auth_event.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/User/Put/update_vendor.dart';
import 'package:delivoo_store/JsonFiles/User/Put/update_vendor_meta.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Maps/UI/location_page.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UpdateProfileBloc/update_profile_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UpdateProfileBloc/update_profile_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/UpdateProfileBloc/update_profile_state.dart';
import 'package:delivoo_store/OrderItemAccount/Account/VendorCategoryBloc/vendor_category_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/VendorCategoryBloc/vendor_category_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/VendorCategoryBloc/vendor_category_state.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/Themes/style.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:delivoo_store/UtilityFunctions/picker.dart';
import 'package:delivoo_store/theme_cubit.dart';

class AccountProfilePage extends StatelessWidget {
  final VendorInfo vendorInfo;
  final bool fromRoot;

  AccountProfilePage(this.vendorInfo, {this.fromRoot = false});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<UpdateProfileBloc>(
            create: (context) => UpdateProfileBloc(),
          ),
          BlocProvider<VendorCategoryBloc>(
            create: (context) => VendorCategoryBloc(),
          ),
        ],
        child: AccountProfileBody(vendorInfo, fromRoot),
      );
}

class AccountProfileBody extends StatefulWidget {
  final VendorInfo vendorInfo;
  final bool fromRoot;

  AccountProfileBody(this.vendorInfo, this.fromRoot);

  @override
  _AccountProfileBodyState createState() => _AccountProfileBodyState();
}

class _AccountProfileBodyState extends State<AccountProfileBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VendorCategoryBloc>(context).add(FetchVendorCategoryEvent(
      vendorInfo: widget.vendorInfo,
      vendorType: widget.vendorInfo.getMeta()?.vendor_type,
    ));
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VendorCategoryBloc, VendorCategoryState>(
        builder: (context, categoryState) => Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppLocalizations.of(context)!.editProfile,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: widget.fromRoot
                ? [
                    IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                          Phoenix.rebirth(context);
                        }),
                  ]
                : null,
          ),
          //this column contains 3 textFields and a bottom bar
          body: AccountRegisterForm(widget.vendorInfo, widget.fromRoot),
        ),
      );
}

class AccountRegisterForm extends StatefulWidget {
  final VendorInfo? vendorInformation;
  final bool fromRoot;

  AccountRegisterForm(this.vendorInformation, this.fromRoot);

  @override
  _AccountRegisterFormState createState() => _AccountRegisterFormState();
}

class _AccountRegisterFormState extends State<AccountRegisterForm> {
  late UpdateProfileBloc _updateProfileBloc;
  String? imageUrl, openingTime, closingTime, documentLic, documentId;
  List<int> categories = [];
  List<CategoryData> categoriesAll = [
    CategoryData(id: 22, slug: 'dsfd', title: 'sfsfds', sortOrder: 1)
  ];
  double? longitude;
  double? latitude;
  bool isLoaderShowing = false;
  late TextEditingController _nameController,
      _vendorTypeController,
      _storeCategoryController,
      _addressController,
      _timeController,
      _timeOpeningController,
      _timeClosingController,
      _docLicController,
      _docIdController;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _docLicController.text = AppLocalizations.of(context)!
        .getTranslationOf(documentLic == null ? "upload" : "uploaded");
    _docIdController.text = AppLocalizations.of(context)!
        .getTranslationOf(documentId == null ? "upload" : "uploaded");
  }

  void loadData() {
    _updateProfileBloc = BlocProvider.of<UpdateProfileBloc>(context);
    _nameController =
        TextEditingController(text: widget.vendorInformation?.name);
    latitude = widget.vendorInformation?.latitude;
    longitude = widget.vendorInformation?.longitude;
    _addressController =
        TextEditingController(text: widget.vendorInformation?.address);
    _vendorTypeController = TextEditingController(
        text: widget.vendorInformation?.getMeta()?.vendor_type);
    if (widget.vendorInformation?.categories != null) {
      for (CategoryData category in widget.vendorInformation!.categories!)
        categories.add(category.id);
      _storeCategoryController = TextEditingController(
          text: widget.vendorInformation!.categories!
              .map((e) => e.title)
              .join(', '));
    }
    _timeController = TextEditingController();
    _timeOpeningController = TextEditingController();
    _timeClosingController = TextEditingController();
    _docLicController = TextEditingController();
    _docIdController = TextEditingController();
    documentLic = widget.vendorInformation?.getMeta()?.document_license;
    documentId = widget.vendorInformation?.getMeta()?.document_id;

    if (widget.vendorInformation?.getMeta() != null) {
      _timeController.text = widget.vendorInformation?.getMeta()?.time ?? "";
      openingTime =
          widget.vendorInformation?.getMeta()?.opening_time ?? "08:00";
      closingTime =
          widget.vendorInformation?.getMeta()?.closing_time ?? "20:00";
      _timeOpeningController.text = openingTime!;
      _timeClosingController.text = closingTime!;
    } else {
      openingTime = "08:00";
      closingTime = "20:00";
      _timeOpeningController.text = openingTime!;
      _timeClosingController.text = closingTime!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _vendorTypeController.dispose();
    _storeCategoryController.dispose();
    _timeController.dispose();
    _timeOpeningController.dispose();
    _timeClosingController.dispose();
    _docLicController.dispose();
    _docIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        BlocListener<UpdateProfileBloc, UpdateProfileState>(
          listener: (context, state) async {
            if (state is LoadingUpdateProfile)
              Loader.showLoader(context);
            else
              Loader.dismissLoader(context);
            if (state is SuccessUpdateProfile) {
              showToast(AppLocalizations.of(context)!
                  .getTranslationOf("updated_successfully"));
              if (widget.fromRoot) {
                BlocProvider.of<AuthBloc>(context)
                    .add(AddProfile(state.vendorInfo));
              } else {
                Navigator.pop(context, state.vendorInfo);
              }
            } else if (state is FailureUpdateProfile) {
              showToast(AppLocalizations.of(context)!
                  .getTranslationOf("something_wrong"));
            }
          },
          child: BlocBuilder<VendorCategoryBloc, VendorCategoryState>(
              builder: (context, categoryState) {
            if (categoryState is SuccessVendorCategoryState) {
              categoriesAll = categoryState.listCategories;
              // if (categoriesAll.isEmpty) {
              //   categoriesAll.add(CategoryData(
              //       id: 22, slug: 'dsfd', title: 'sfsfds', sortOrder: 1));
              // }
              return ListView(
                children: [
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      File? filePicked = await Picker().pickImageFile(
                          context, PickerSource.ask, CropConfig.square);
                      if (filePicked != null) {
                        Loader.showLoader(context);
                        String? url;
                        try {
                          url = (await AuthRepo().uploadFile(filePicked)).url;
                        } catch (e) {
                          print(e);
                        }
                        Loader.dismissLoader(context);
                        if (url != null) {
                          setState(() {
                            imageUrl = url;
                          });
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedImage(
                              getImage(),
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                          PositionedDirectional(
                            end: -15,
                            top: 40,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.scaffoldBackgroundColor,
                              child: const Icon(Icons.camera_alt, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.profileInfo,
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 1.0,
                          color: kMainTextColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  //name textField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      title: AppLocalizations.of(context)!.fullName,
                      // initialValue: widget.userInformation.name,
                    ),
                  ),
                  //category textField
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      controller: _vendorTypeController,
                      onTap: () {
                        List<String> vts = AppSettings.vendorType
                            .split(",")
                            .map((e) => e.trim())
                            .toList();
                        vts.removeWhere((element) => element.isEmpty);
                        if (vts.isEmpty) return;
                        showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (context) => VendorTypeSelectionSheet(
                              vts, _vendorTypeController.text),
                        ).then((value) {
                          if (value != null) {
                            _vendorTypeController.text = value;
                            categories = [];
                            _storeCategoryController.clear();
                            setState(() {});
                            BlocProvider.of<VendorCategoryBloc>(context)
                                .add(FetchVendorCategoryEvent(
                              vendorInfo: widget.vendorInformation,
                              vendorType: value,
                            ));
                          }
                        });
                      },
                      readOnly: true,
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      textCapitalization: TextCapitalization.words,
                      title: AppLocalizations.of(context)!
                          .getTranslationOf("vendor_type"),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      controller: _storeCategoryController,
                      onTap: () {
                        if (categoriesAll.isEmpty) {
                          showToast(AppLocalizations.of(context)!
                              .getTranslationOf("empty_categories"));
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (context) =>
                              CategorySelectionSheet(categoriesAll),
                        ).then((value) {
                          if (value != null) {
                            List<CategoryData> categoriesSelected = [];
                            for (CategoryData category in value)
                              if (category.isSelected ?? false)
                                categoriesSelected.add(category);
                            categories =
                                categoriesSelected.map((e) => e.id).toList();
                            _storeCategoryController.text = categoriesSelected
                                .map((e) => e.title)
                                .toList()
                                .join(', ');
                          }
                        });
                      },
                      readOnly: true,
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      textCapitalization: TextCapitalization.words,
                      title: AppLocalizations.of(context)!.category,
                    ),
                  ),

                  SizedBox(height: 20),
                  //phone textField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      title: AppLocalizations.of(context)!.mobileNumber,
                      initialValue:
                          widget.vendorInformation?.user?.mobileNumber,
                      readOnly: true,
                    ),
                  ),

                  SizedBox(height: 20),
                  //email textField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      textCapitalization: TextCapitalization.none,
                      title: AppLocalizations.of(context)!.emailAddress,
                      readOnly: true,
                      initialValue: widget.vendorInformation?.user?.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.address,
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.0,
                              color: kMainTextColor),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationPage(
                                _addressController.text,
                                latitude != null && longitude != null
                                    ? LatLng(latitude!, longitude!)
                                    : null,
                              ),
                            ),
                          ).then((value) {
                            if (value != null &&
                                value is List &&
                                value.isNotEmpty) {
                              _addressController.text = value[0];
                              latitude = value[1].latitude;
                              longitude = value[1].longitude;
                              setState(() {});
                            }
                          }),
                          child: Text(
                            AppLocalizations.of(context)!
                                .getTranslationOf("pinonmap"),
                            style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                letterSpacing: 1.0,
                                color: kMainColor),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  //address textField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      controller: _addressController,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.storeTimings,
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.0,
                          color: kMainTextColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: EntryField(
                            readOnly: true,
                            textCapitalization: TextCapitalization.words,
                            controller: _timeOpeningController,
                            title: AppLocalizations.of(context)!.openingTime,
                            onTap: () {
                              List<String> scheduledOnTimeSplit =
                                  openingTime != null &&
                                          openingTime!.contains(":")
                                      ? openingTime!.split(":")
                                      : ["05", "00"];
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: int.parse(scheduledOnTimeSplit[0]),
                                    minute: int.parse(scheduledOnTimeSplit[1])),
                                builder: (context, child) =>
                                    timePickerBuilder(theme, child!),
                              ).then((picked) {
                                if (picked != null) {
                                  openingTime =
                                      ((picked.hour.toString().length == 1
                                              ? ("0" + picked.hour.toString())
                                              : picked.hour.toString()) +
                                          ":" +
                                          (picked.minute.toString().length == 1
                                              ? ("0" + picked.minute.toString())
                                              : picked.minute.toString()));
                                  _timeOpeningController.text = openingTime!;
                                  setState(() {});
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: EntryField(
                            readOnly: true,
                            textCapitalization: TextCapitalization.words,
                            controller: _timeClosingController,
                            title: AppLocalizations.of(context)!.closingTime,
                            onTap: () {
                              List<String> scheduledOnTimeSplit =
                                  closingTime != null &&
                                          closingTime!.contains(":")
                                      ? closingTime!.split(":")
                                      : ["20", "00"];
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: int.parse(scheduledOnTimeSplit[0]),
                                    minute: int.parse(scheduledOnTimeSplit[1])),
                                builder: (context, child) =>
                                    timePickerBuilder(theme, child!),
                              ).then((picked) {
                                if (picked != null) {
                                  closingTime =
                                      ((picked.hour.toString().length == 1
                                              ? ("0" + picked.hour.toString())
                                              : picked.hour.toString()) +
                                          ":" +
                                          (picked.minute.toString().length == 1
                                              ? ("0" + picked.minute.toString())
                                              : picked.minute.toString()));
                                  _timeClosingController.text = closingTime!;
                                  setState(() {});
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .getTranslationOf("time_to_prepare_order"),
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.0,
                          color: kMainTextColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      controller: _timeController,
                      hint: AppLocalizations.of(context)!
                          .getTranslationOf("in_unit_mins"),
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: false,
                      ),
                      prefixIcon: Icon(
                        Icons.watch_later_outlined,
                        color: kMainColor,
                        size: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .getTranslationOf("documents"),
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.0,
                          color: kMainTextColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      title: AppLocalizations.of(context)!
                          .getTranslationOf("store_lic"),
                      controller: _docLicController,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: documentLic == null ? null : kMainColor,
                        size: 20.0,
                      ),
                      onTap: () async {
                        File? filePicked = await Picker().pickImageFile(
                            context, PickerSource.ask, CropConfig.free);
                        if (filePicked != null) {
                          Loader.showLoader(context);
                          String? url;
                          try {
                            url = (await AuthRepo().uploadFile(filePicked)).url;
                          } catch (e) {
                            print(e);
                          }
                          Loader.dismissLoader(context);
                          if (url != null) {
                            documentLic = url;
                            _docLicController.text =
                                AppLocalizations.of(context)!.getTranslationOf(
                                    documentLic == null
                                        ? "upload"
                                        : "uploaded");
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryField(
                      title: AppLocalizations.of(context)!
                          .getTranslationOf("store_id"),
                      controller: _docIdController,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: documentId == null ? null : kMainColor,
                        size: 20.0,
                      ),
                      onTap: () async {
                        File? filePicked = await Picker().pickImageFile(
                            context, PickerSource.ask, CropConfig.free);
                        if (filePicked != null) {
                          Loader.showLoader(context);
                          String? url;
                          try {
                            url = (await AuthRepo().uploadFile(filePicked)).url;
                          } catch (e) {
                            print(e);
                          }
                          Loader.dismissLoader(context);
                          if (url != null) {
                            documentId = url;
                            _docIdController.text =
                                AppLocalizations.of(context)!.getTranslationOf(
                                    documentId == null ? "upload" : "uploaded");
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 100.0),
                  //continue button bar
                ],
              );
            } else if (categoryState is FailureVendorCategoryState) {
              return Center(child: Text('Failed to load!'));
            } else if (categoryState is LoadingVendorCategoriesState) {
              return Center(
                  child: Loader.circularProgressIndicatorPrimary(context));
            } else {
              return Center(
                  child: Loader.circularProgressIndicatorPrimary(context));
            }
          }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BottomBar(
                text: AppLocalizations.of(context)!.updateInfo,
                onTap: () {
                  Helper.clearFocus(context);
                  if (_nameController.text.isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("add_business_name"));
                  } else if (latitude == null || longitude == null) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("add_operating_location"));
                  } else if (categories.isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("select_categories"));
                  } else if (_timeController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("time_to_prepare_enter"));
                  } else if (documentLic == null) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_store_lic"));
                  } else if (documentId == null) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("err_store_id"));
                  } else {
                    UpdateVendorMeta vendorMeta = widget.vendorInformation
                            ?.getMeta() ??
                        UpdateVendorMeta(null, null, null, null, null, null);
                    vendorMeta.vendor_type = _vendorTypeController.text;
                    vendorMeta.time = _timeController.text;
                    vendorMeta.opening_time = openingTime;
                    vendorMeta.closing_time = closingTime;
                    vendorMeta.document_id = documentId;
                    vendorMeta.document_license = documentLic;
                    _updateProfileBloc.add(UpdateProfileEvent(
                        widget.vendorInformation!.id,
                        UpdateVendorInfo(
                          name: _nameController.text,
                          imageUrl: imageUrl == null ? [] : [imageUrl],
                          tagLine: 'tagline',
                          details: 'details',
                          minimumOrder: 100,
                          deliveryFee: 25,
                          address: _addressController.text,
                          area: 'DEF',
                          latitude: latitude,
                          longitude: longitude,
                          categories: categories,
                          dynamicMeta: jsonEncode(vendorMeta.toJson()),
                        )));
                  }
                  // Navigator.pushNamed(context, PageRoutes.accountPage);
                }),
          ),
        ),
      ],
    );
  }

  getImage() => imageUrl != null
      ? imageUrl
      : (widget.vendorInformation?.mediaUrls?.images?[0].defaultImage != null)
          ? widget.vendorInformation!.mediaUrls!.images![0].defaultImage
          : null;
}

//bottom sheets that pops up on select vendor type field
class VendorTypeSelectionSheet extends StatefulWidget {
  final List<String> vendorTypes;
  final String? vtSelected;
  const VendorTypeSelectionSheet(this.vendorTypes, this.vtSelected);

  @override
  State<VendorTypeSelectionSheet> createState() =>
      _VendorTypeSelectionSheetState();
}

class _VendorTypeSelectionSheetState extends State<VendorTypeSelectionSheet> {
  late ThemeCubit _themeCubit;
  String? selection;

  @override
  void initState() {
    selection = widget.vtSelected;
    super.initState();
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          color: _themeCubit.isDark
              ? theme.colorScheme.surface
              : kCardBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!
                    .getTranslationOf("select_vendor_type"),
                style: theme.textTheme.headlineMedium,
              ),
              ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.getTranslationOf("done")),
                onPressed: () => Navigator.pop(context, selection),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor),
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20),
            itemCount: widget.vendorTypes.length,
            itemBuilder: (context, index) => RadioListTile(
              value: widget.vendorTypes[index],
              groupValue: selection,
              title: Text(
                widget.vendorTypes[index],
                style: theme.textTheme.bodyLarge,
              ),
              onChanged: (value) {
                if (value != null) {
                  selection = value;
                  setState(() {});
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

//bottom sheets that pops up on select package type field
class CategorySelectionSheet extends StatefulWidget {
  final List<CategoryData> categories;

  CategorySelectionSheet(this.categories);

  @override
  _CategorySelectionSheetState createState() => _CategorySelectionSheetState();
}

class _CategorySelectionSheetState extends State<CategorySelectionSheet> {
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          color: _themeCubit.isDark
              ? theme.colorScheme.surface
              : kCardBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!
                    .getTranslationOf("select_categories"),
                style: theme.textTheme.headlineMedium,
              ),
              ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.getTranslationOf("done")),
                onPressed: () => Navigator.pop(context, widget.categories),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor),
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              var categoryData = widget.categories[index];
              return CheckboxListTile(
                activeColor: theme.primaryColor,
                title: Text(categoryData.title),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => categoryData.isSelected = val);
                  }
                },
                value: categoryData.isSelected ?? false,
              );
            },
          ),
        ),
      ],
    );
  }
}
