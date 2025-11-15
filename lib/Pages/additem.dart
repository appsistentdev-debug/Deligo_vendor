import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/confirm_dialog.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_choices.dart';
import 'package:delivoo_store/JsonFiles/Products/addon_groups.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/Pages/Bloc/AddItem/addItemBloc.dart';
import 'package:delivoo_store/Pages/Bloc/AddItem/addItemEvent.dart';
import 'package:delivoo_store/Pages/Bloc/AddItem/addItemState.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:delivoo_store/UtilityFunctions/picker.dart';
import 'package:delivoo_store/theme_cubit.dart';

class AddItem extends StatelessWidget {
  final ProductData? productData;

  AddItem([this.productData]);

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (BuildContext context) => AddItemBloc(),
      child: AddItemBody(productData));
}

class AddItemBody extends StatefulWidget {
  final ProductData? productData;

  AddItemBody(this.productData);

  @override
  _AddItemBodyState createState() => _AddItemBodyState();
}

class _AddItemBodyState extends State<AddItemBody> {
  bool _enableMultipleImagesSupport = false,
      _enableAddonGroupsManagementSupport = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<String> imageUrls = [];
  final List<AddOnGroups> addOnGroups = [];
  List<CategoryData> _categories = [];
  int? catIdSelected;
  bool inStock = true;

  late AddItemBloc _addItemBloc;
  bool isLoaderShowing = false;

  @override
  void initState() {
    _addItemBloc = BlocProvider.of<AddItemBloc>(context);
    _addItemBloc.add(FetchCategoriesEvent());

    if (widget.productData != null) {
      _titleController.text = widget.productData?.title ?? "";
      _descriptionController.text = widget.productData?.detail ?? "";
      _priceController.text =
          widget.productData?.price.toStringAsFixed(2) ?? "";
      inStock = widget.productData?.vendorProducts?[0].stockQuantity != 0;
      _quantityController.text = inStock
          ? (widget.productData?.vendorProducts?[0].stockQuantity ?? 1)
              .toString()
          : "0";
      if (widget.productData?.categories != null &&
          widget.productData!.categories!.isNotEmpty) {
        _categoryController.text =
            widget.productData?.categories?[0].title ?? "";
        catIdSelected = widget.productData?.categories?[0].id ?? -1;
      }
      if (widget.productData?.mediaUrls?.images != null &&
          widget.productData!.mediaUrls!.images!.isNotEmpty) {
        if (_enableMultipleImagesSupport) {
          for (var imageUrl in widget.productData!.mediaUrls!.images!)
            if (imageUrl.defaultImage != null) {
              imageUrls.add(imageUrl.defaultImage!);
            }
        } else {
          if (widget.productData?.mediaUrls?.images?.first.defaultImage != null)
            imageUrls.add(
              widget.productData!.mediaUrls!.images!.first.defaultImage!,
            );
        }
      }

      if (widget.productData?.addOnGroups != null)
        for (AddOnGroups addOnGroup in widget.productData!.addOnGroups ?? [])
          addOnGroups.add(AddOnGroups.fromJson(addOnGroup.toJson()));
      for (AddOnGroups addOnGroup in widget.productData!.addOnGroups ?? []) {
        if (addOnGroup.addOnChoices == null) addOnGroup.addOnChoices = [];
        if (addOnGroup.addOnChoices!.isEmpty)
          addOnGroup.addOnChoices!.add(AddOnChoices(-1, "", 0, -1, "", ""));
      }
    }

    // Future.delayed(Duration(seconds: 2), () {
    //   imageUrls.add(
    //       "https://i.picsum.photos/id/126/200/200.jpg?hmac=K-6__ZO7BY87ACqo_8JSL1t0d0eQU7g2lmJIZX_cmYY");
    //   setState(() {});
    // });
    // Future.delayed(Duration(seconds: 4), () {
    //   imageUrls.add(
    //       "https://i.picsum.photos/id/314/200/200.jpg?hmac=bCAc2iO5ovLPrvwDQV31aBPS13QTyv33ut2H2wY4QXU");
    //   setState(() {});
    // });
    // Future.delayed(Duration(seconds: 6), () {
    //   imageUrls.add(
    //       "https://i.picsum.photos/id/881/200/200.jpg?hmac=34beeNIxYSbYK-_PTy_YXvWyn11npGQSygCM7hjOUFo");
    //   setState(() {});
    // });
    // Future.delayed(Duration(seconds: 8), () {
    //   imageUrls.add(
    //       "https://i.picsum.photos/id/727/200/200.jpg?hmac=3t3XFTDKvF4DdvtTj-t8IMm5uwdlyzdECQmn87m3qk0");
    //   setState(() {});
    // });

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
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
        title: Text(
          AppLocalizations.of(context)!
              .getTranslationOf(widget.productData == null ? "add" : "edit"),
          style: theme.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          if (widget.productData != null)
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.getTranslationOf("stock"),
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(width: 4),
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: inStock,
                    onChanged: (value) => setState(() {
                      inStock = value;
                      _quantityController.text = inStock ? "-1" : "0";
                    }),
                    activeColor: Color(0xFFFFFFFF),
                    activeTrackColor: kMainColor,
                    inactiveThumbColor: Color(0xFFF1F1F1),
                    inactiveTrackColor: Color(0xFFE0E0E0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
        ],
      ),
      body: BlocListener<AddItemBloc, AddItemState>(
        listener: (context, state) {
          if (state is AddItemStateLoading)
            Loader.showLoader(context);
          else
            Loader.dismissLoader(context);

          if (state is AddItemStateLoadedCategories) {
            if (widget.productData == null && state.categories.isNotEmpty) {
              //_categoryController.text = state.categories[0].title;
              catIdSelected = state.categories[0].id;
            }
            setState(() => _categories = state.categories);
          }

          if (state is AddItemStateLoadedProduct) {
            Navigator.pop(context, state.productData);
          } else if (state is AddItemStateLoadFailedProduct) {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf('something_wrong'));
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () async {
                        File? filePicked = await Picker().pickImageFile(
                            context, PickerSource.ask, CropConfig.square);
                        if (filePicked != null) {
                          Loader.showLoader(context);
                          String? url;
                          try {
                            url = (await ProductRepository()
                                    .uploadFile(filePicked))
                                .url;
                          } catch (e) {
                            print(e);
                          }
                          Loader.dismissLoader(context);
                          if (url != null) {
                            if (_enableMultipleImagesSupport)
                              imageUrls.add(url);
                            else
                              imageUrls = [url];
                            setState(() {});
                          }
                        }
                      },
                      child: Badge(
                        label: CircleAvatar(
                          backgroundColor: kMainColor,
                          radius: 20,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 22),
                        ),
                        backgroundColor: Colors.transparent,
                        offset: Offset(
                            -MediaQuery.of(context).size.width / 1.5, 40),
                        child: Container(
                          child: CachedImage(
                            imageUrls.firstOrNull,
                            width: 140.0,
                            height: 110.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .getTranslationOf("itemCategory"),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            if (_categories.isNotEmpty)
                              showModalBottomSheet<CategoryData>(
                                context: context,
                                backgroundColor: theme.cardColor,
                                builder: (context) => ModalBottomWidget(
                                  _categories,
                                  _categoryController.text.isNotEmpty
                                      ? _categoryController.text
                                      : "",
                                ),
                              ).then((value) => setState(() {
                                    catIdSelected = value?.id;
                                    _categoryController.text =
                                        value?.title ?? "";
                                  }));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _categoryController.text.isEmpty
                                      ? AppLocalizations.of(context)!
                                          .getTranslationOf("selectCategory")
                                      : _categoryController.text,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!
                              .getTranslationOf("itemName"),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _titleController,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .getTranslationOf("enterTitle"),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!
                              .getTranslationOf("item_description"),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .getTranslationOf("enter_item_description"),
                            ),
                            maxLines: 3,
                          ),
                        ),

                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!
                              .getTranslationOf("price"),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              border: InputBorder.none,
                              hintText:
                                  "${AppLocalizations.of(context)!.getTranslationOf("enterPrice")}(${AppSettings.currencyIcon})",
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .getTranslationOf("quantity"),
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              margin: EdgeInsetsDirectional.only(end: 16),
                              child: GestureDetector(
                                onTap: () => ConfirmDialog.showConfirmation(
                                    context,
                                    AppLocalizations.of(context)!
                                        .getTranslationOf("quantity_info"),
                                    AppLocalizations.of(context)!
                                        .getTranslationOf("quantity_info_msg"),
                                    null,
                                    AppLocalizations.of(context)!
                                        .getTranslationOf("okay")),
                                child: Icon(
                                  Icons.info,
                                  color: kMainColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _quantityController,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .getTranslationOf("enterQuantity"),
                            ),
                          ),
                        ),

                        if (addOnGroups.isEmpty)
                          SizedBox(
                            height: 16.0,
                          ),
                        if (_enableAddonGroupsManagementSupport &&
                            addOnGroups.isEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => _validateLastAddGroup(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .getTranslationOf("add_group"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // SizedBox(height: 28),
                        // Text(
                        //   AppLocalizations.of(context)!
                        //       .getTranslationOf("variation"),
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 20,
                        //   ),
                        // ),
                        // SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         "Addon",
                        //         style: TextStyle(
                        //           color: Colors.grey,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 16,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Text("Selling Price",
                        //           style: TextStyle(
                        //               color: Colors.grey,
                        //               fontWeight: FontWeight.w600,
                        //               fontSize: 16)),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 8),
                        // ..._buildAddonRows(),
                        // SizedBox(height: 8),
                        // if (_enableAddonGroupsManagementSupport &&
                        //     addOnGroups.isEmpty)
                        //   Align(
                        //     alignment: Alignment.centerRight,
                        //     child: GestureDetector(
                        //       onTap: () => _validateLastAddGroup(),
                        //       child: Padding(
                        //         padding: EdgeInsets.symmetric(horizontal: 16.0),
                        //         child: Text(
                        //           AppLocalizations.of(context)!
                        //               .getTranslationOf("add_more_choice"),
                        //           style: TextStyle(
                        //             color: kMainColor,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 18,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // SizedBox(height: 32),
                      ],
                    ),
                  ),
                  if (_enableAddonGroupsManagementSupport)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getAddOnChildrenWidgets(),
                    )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Helper.clearFocus(context);
                    if (_titleController.text.trim().isEmpty) {
                      showToast(AppLocalizations.of(context)!
                          .getTranslationOf("enterTitle"));
                      return;
                    }
                    if (_descriptionController.text.trim().isEmpty) {
                      showToast(AppLocalizations.of(context)!
                          .getTranslationOf("enter_item_description"));
                      return;
                    }
                    if (_categoryController.text.isEmpty) {
                      showToast(AppLocalizations.of(context)!
                          .getTranslationOf('select_category'));
                      return;
                    }
                    if (_priceController.text.trim().isEmpty) {
                      showToast(AppLocalizations.of(context)!
                          .getTranslationOf("enterPrice"));
                      return;
                    }
                    if (_quantityController.text.trim().isEmpty) {
                      showToast(AppLocalizations.of(context)!
                          .getTranslationOf("enterQuantity"));
                      return;
                    }
                    if (addOnGroups.isNotEmpty) {
                      for (int i = 0; i < addOnGroups.length; i++) {
                        String? invalidMsgKey = addOnGroups[i].validate();
                        if (invalidMsgKey != null) {
                          if (_enableAddonGroupsManagementSupport) {
                            showToast(
                                "${AppLocalizations.of(context)!.getTranslationOf("invalid_group")} $i");
                            showToast(AppLocalizations.of(context)!
                                .getTranslationOf(invalidMsgKey));
                            return;
                          } else {
                            addOnGroups.clear();
                          }
                        }
                      }
                    }
                    _addItemBloc.add(
                      AddSubmittedEvent(
                        widget.productData != null
                            ? widget.productData?.id
                            : null,
                        _titleController.text,
                        _descriptionController.text,
                        double.tryParse(_priceController.text) ?? 0,
                        [catIdSelected.toString()],
                        imageUrls,
                        (double.tryParse(_quantityController.text) ?? 0)
                            .toInt(),
                        addOnGroups,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.getTranslationOf(
                        widget.productData == null ? "add" : "save"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  confirmDeleteImage(int index) => ConfirmDialog.showConfirmation(
              context,
              AppLocalizations.of(context)!
                  .getTranslationOf("delete_image_title"),
              AppLocalizations.of(context)!
                  .getTranslationOf("delete_image_body"),
              AppLocalizations.of(context)!.getTranslationOf("no"),
              AppLocalizations.of(context)!.getTranslationOf("yes"))
          .then(
        (value) {
          if (value == true) {
            imageUrls.removeAt(index);
          }
          setState(() {});
        },
      );

  List<Widget> getAddOnChildrenWidgets() {
    List<Widget> toReturn = [];
    for (AddOnGroups addOnGroup in addOnGroups) {
      toReturn.addAll(_genAddonGroupWidgets(addOnGroup));
    }
    if (addOnGroups.isNotEmpty) {
      toReturn.add(SizedBox(
        height: 30.0,
      ));
      toReturn.add(Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => _validateLastAddGroup(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalizations.of(context)!.getTranslationOf("add_more_group"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ));
      toReturn.add(SizedBox(height: 30.0));
    }
    toReturn.add(SizedBox(height: 5.0));
    return toReturn;
  }

  _validateLastAddGroup() {
    if (addOnGroups.isEmpty) {
      Helper.clearFocus(context);
      setState(() => addOnGroups.add(AddOnGroups(
          -1, "", 0, 0, -1, [AddOnChoices(-1, "", 0, -1, "", "")])));
    } else {
      String? invalidMsgKey = addOnGroups[addOnGroups.length - 1].validate();
      if (invalidMsgKey == null) {
        Helper.clearFocus(context);
        setState(() => addOnGroups.add(AddOnGroups(
            addOnGroups[addOnGroups.length - 1].id - 1,
            "",
            0,
            0,
            -1,
            [AddOnChoices(-1, "", 0, -1, "", "")])));
      } else {
        showToast(
            AppLocalizations.of(context)!.getTranslationOf(invalidMsgKey));
      }
    }
  }

  _validateLastAddChoice(AddOnGroups addOnGroup) {
    if (addOnGroup.addOnChoices!.isEmpty) {
      Helper.clearFocus(context);
      setState(() =>
          addOnGroup.addOnChoices!.add(AddOnChoices(-1, "", 0, -1, "", "")));
    } else {
      String? invalidMsgKey = addOnGroup
          .addOnChoices?[addOnGroup.addOnChoices!.length - 1]
          .validate();
      if (invalidMsgKey == null) {
        Helper.clearFocus(context);
        setState(() => addOnGroup.addOnChoices?.add(AddOnChoices(
            addOnGroup.addOnChoices![addOnGroup.addOnChoices!.length - 1].id -
                1,
            "",
            0,
            -1,
            "",
            "")));
      } else {
        showToast(
            AppLocalizations.of(context)!.getTranslationOf(invalidMsgKey));
      }
    }
  }

  List<Widget> _genAddonGroupWidgets(AddOnGroups addOnGroup) {
    final int posInList = addOnGroups.indexOf(addOnGroup);
    ThemeData theme = Theme.of(context);
    List<Widget> toReturn = [];
    toReturn.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!
                  .getTranslationOf("addon_group_name"),
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.w500, color: kHintColor),
            ),
          ),
          IconButton(
              onPressed: () => setState(() => addOnGroups.removeAt(posInList)),
              icon: Icon(Icons.delete, color: Colors.red),
              iconSize: 20,
              padding: const EdgeInsets.all(2.0))
        ],
      ),
    ));
    toReturn.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: EntryField(
        myKey: Key("group_title_${addOnGroup.title}"),
        textCapitalization: TextCapitalization.words,
        title:
            AppLocalizations.of(context)!.getTranslationOf("addon_group_name"),
        hint: AppLocalizations.of(context)!.getTranslationOf("group_name"),
        initialValue: addOnGroup.title,
        onSaved: (newText) => addOnGroup.title = newText,
      ),
    ));
    toReturn.add(SizedBox(height: 16));
    toReturn.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            child: EntryField(
              myKey: Key("minChoices_${addOnGroup.minChoices}"),
              title:
                  AppLocalizations.of(context)!.getTranslationOf("min_choice"),
              hint: AppLocalizations.of(context)!
                  .getTranslationOf("min_choice_enter"),
              keyboardType: TextInputType.number,
              initialValue: "${addOnGroup.minChoices}",
              onSaved: (newText) =>
                  addOnGroup.minChoices = int.tryParse(newText) ?? 0,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: EntryField(
              myKey: Key("maxChoices${addOnGroup.maxChoices}"),
              title:
                  AppLocalizations.of(context)!.getTranslationOf("max_choice"),
              hint: AppLocalizations.of(context)!
                  .getTranslationOf("max_choice_enter"),
              keyboardType: TextInputType.number,
              initialValue: "${addOnGroup.maxChoices}",
              onSaved: (newText) =>
                  addOnGroup.maxChoices = int.tryParse(newText) ?? 0,
            ),
          ),
        ],
      ),
    ));
    toReturn.add(SizedBox(height: 16));
    toReturn.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        AppLocalizations.of(context)!.getTranslationOf("choices"),
        style: theme.textTheme.titleLarge!
            .copyWith(fontWeight: FontWeight.w500, color: kHintColor),
      ),
    ));
    toReturn.add(SizedBox(height: 10));
    for (AddOnChoices addOnChoice in (addOnGroup.addOnChoices ?? []))
      toReturn.addAll(_genAddonGroupChoiceWidgets(addOnGroup, addOnChoice));
    toReturn.add(Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _validateLastAddChoice(addOnGroup),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            AppLocalizations.of(context)!.getTranslationOf("add_more_choice"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ));
    return toReturn;
  }

  List<Widget> _genAddonGroupChoiceWidgets(
      AddOnGroups addOnGroup, AddOnChoices addOnChoice) {
    final int posInList = addOnGroup.addOnChoices!.indexOf(addOnChoice);
    List<Widget> toReturn = [];
    toReturn.add(Padding(
      padding: EdgeInsetsDirectional.only(
        start: 30,
        end: 16,
      ),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: EntryField(
              myKey: Key("choice_name_${addOnGroup.id}_${addOnChoice.id}"),
              title:
                  AppLocalizations.of(context)!.getTranslationOf("choice_name"),
              hint: AppLocalizations.of(context)!
                  .getTranslationOf("choice_name_enter"),
              keyboardType: TextInputType.text,
              initialValue: addOnChoice.title,
              onSaved: (newText) => addOnChoice.title = newText,
              shrink: true,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: EntryField(
              myKey: Key("choice_price${addOnGroup.id}_${addOnChoice.id}"),
              title: AppLocalizations.of(context)!
                  .getTranslationOf("choice_price"),
              hint: AppLocalizations.of(context)!
                  .getTranslationOf("choice_price_enter"),
              keyboardType: TextInputType.number,
              initialValue: "${addOnChoice.price}",
              onSaved: (newText) =>
                  addOnChoice.price = double.tryParse(newText) ?? 0,
              shrink: true,
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => addOnGroup.addOnChoices!.removeAt(posInList)),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.delete,
                color: Colors.red[300],
              ),
            ),
          ),
          // IconButton(
          //   onPressed: () =>
          //       setState(() => addOnGroup.addOnChoices!.removeAt(posInList)),
          //   icon: Icon(Icons.delete, color: Colors.red[300]),
          //   iconSize: 18,
          //   padding: const EdgeInsets.all(2.0),
          // )
        ],
      ),
    ));
    toReturn.add(SizedBox(height: 10));
    return toReturn;
  }
}

class ModalBottomWidget extends StatefulWidget {
  final List<CategoryData> categories;
  final String? previousSelectedCategoryTitle;

  ModalBottomWidget(this.categories, this.previousSelectedCategoryTitle);

  @override
  _ModalBottomWidgetState createState() => _ModalBottomWidgetState();
}

class _ModalBottomWidgetState extends State<ModalBottomWidget> {
  late String selectedValue;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    selectedValue = widget.previousSelectedCategoryTitle != null &&
            widget.previousSelectedCategoryTitle!.isNotEmpty
        ? widget.previousSelectedCategoryTitle!
        : widget.categories.first.title;
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          color: theme.cardColor,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .getTranslationOf("selectCategory"),
                style: theme.textTheme.headlineMedium,
              ),
              ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.getTranslationOf("done")),
                onPressed: () {
                  CategoryData? categoryData;
                  for (CategoryData cd in widget.categories) {
                    if (cd.title == selectedValue) {
                      categoryData = cd;
                      break;
                    }
                  }
                  Navigator.pop(context, categoryData);
                },
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
          child: ListView(
            children: widget.categories
                .map(
                  (category) => RadioListTile(
                    activeColor: theme.primaryColor,
                    value: category.title,
                    groupValue: selectedValue,
                    onChanged: (String? checked) =>
                        setState(() => selectedValue = checked!),
                    title: Text(
                      category.title,
                      style: TextStyle(
                          color:
                              _themeCubit.isDark ? Colors.white : kTextColor),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
