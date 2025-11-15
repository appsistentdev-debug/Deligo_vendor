import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/custom_appbar.dart';
import 'package:delivoo_store/Components/placeholder_widgets.dart';
import 'package:delivoo_store/Items/BLOC/items_bloc.dart';
import 'package:delivoo_store/Items/BLOC/items_event.dart';
import 'package:delivoo_store/Items/BLOC/items_state.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Pages/additem.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

abstract class ItemsPageInteractor {
  void addItem(ProductData productData);
}

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> implements ItemsPageInteractor {
  final List<CategoryData> _productCategories = [], _newCategories = [];
  final List<GlobalKey<ItemsTabStatefulState>> _tabBarStateKeys = [];

  Future<List<CategoryData>> _getCategories() async {
    _productCategories.clear();
    try {
      VendorInfo? vendorInfo = await Helper().getVendorInfo();
      _productCategories.addAll(vendorInfo?.productCategories ?? []);
      if (_newCategories.isNotEmpty) {
        _productCategories.addAll(_newCategories);
        vendorInfo?.productCategories?.clear();
        vendorInfo?.productCategories?.addAll(_productCategories);
        await Helper().saveVendorInfo(vendorInfo);
      }
    } catch (e) {
      print("_getCategories");
    }
    return _productCategories;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<List<CategoryData>>(
      future: _getCategories(),
      builder: (BuildContext context,
              AsyncSnapshot<List<CategoryData>> snapshot) =>
          snapshot.hasData
              ? DefaultTabController(
                  length: _productCategories.isEmpty
                      ? 1
                      : _productCategories.length,
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(100.0),
                      child: CustomAppBar(
                        titleWidget: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            AppLocalizations.of(context)!
                                .getTranslationOf('my_items'),
                            style: theme.textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(40.0),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TabBar(
                              tabs: _productCategories.isEmpty
                                  ? [
                                      Tab(
                                        text: AppLocalizations.of(context)!
                                            .getTranslationOf("all"),
                                      )
                                    ]
                                  : _productCategories
                                      .map((e) => Tab(text: e.title))
                                      .toList(),
                              isScrollable: true,
                              labelStyle: theme.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.7,
                                  color: kMainColor),
                              unselectedLabelStyle: theme.textTheme.titleSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.7,
                                      color: theme.primaryColorDark),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 3,
                              tabAlignment: TabAlignment.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: _productCategories.isEmpty
                          ? [
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: PlaceholderWidgets.errorRetryWidget(
                                  context,
                                  AppLocalizations.of(context)!
                                      .getTranslationOf("no_items"),
                                ),
                              )
                            ]
                          : _genTabBarChildren(),
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: kMainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onPressed: () => addItem(null),
                      tooltip: AppLocalizations.of(context)!.add,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: PlaceholderWidgets.loadingWidget(context),
                ),
    );
  }

  @override
  void addItem(ProductData? productData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem(productData)),
    ).then((value) {
      if (value != null && value is ProductData) {
        List<int> categoryIndexes = [];
        List<CategoryData> categoriesNew = [];
        for (CategoryData categoryData in (value.categories ?? [])) {
          int indexInProductCategories = -1;
          for (int i = 0; i < _productCategories.length; i++) {
            if (_productCategories[i].id == categoryData.id) {
              indexInProductCategories = i;
              break;
            }
          }
          if (indexInProductCategories == -1) {
            categoriesNew.add(categoryData);
          } else {
            categoryIndexes.add(indexInProductCategories);
          }
        }
        print(
            "categoryIndexes.length == value.categories.length: ${categoryIndexes.length == value.categories?.length}");
        if (categoryIndexes.length == value.categories?.length) {
          for (int index in categoryIndexes) {
            if (_tabBarStateKeys[index].currentState != null)
              _tabBarStateKeys[index].currentState!.addOrUpdateInList(value);
          }
        } else {
          _newCategories.clear();
          _newCategories.addAll(categoriesNew);
          setState(() {});
        }
      }
    });
  }

  _genTabBarChildren() {
    List<Widget> toReturn = [];
    _tabBarStateKeys.clear();
    for (CategoryData categoryData in _productCategories) {
      GlobalKey<ItemsTabStatefulState> itemsTabStatefulStateGlobalKey =
          GlobalKey();
      toReturn.add(
        BlocProvider(
          create: (BuildContext context) =>
              ItemsBloc()..add(FetchItemsEvent(categoryData.id)),
          child: ItemsTabStateful(
            itemsTabStatefulStateGlobalKey,
            categoryData.id,
            this,
          ),
        ),
      );
      _tabBarStateKeys.add(itemsTabStatefulStateGlobalKey);
    }
    return toReturn;
  }
}

class ItemsTabStateful extends StatefulWidget {
  final int categoryId;
  final ItemsPageInteractor itemsPageInteractor;

  ItemsTabStateful(Key key, this.categoryId, this.itemsPageInteractor)
      : super(key: key);

  @override
  ItemsTabStatefulState createState() => ItemsTabStatefulState();
}

class ItemsTabStatefulState extends State<ItemsTabStateful>
    with AutomaticKeepAliveClientMixin {
  late ItemsBloc _itemsBloc;

  @override
  void initState() {
    super.initState();
    _itemsBloc = BlocProvider.of<ItemsBloc>(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    super.build(context);
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsSuccessState) {
          if (state.products.isNotEmpty) {
            return Column(
              children: <Widget>[
                Divider(
                  color: theme.cardColor,
                  thickness: 8.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      if (index == state.products.length - 1) {
                        BlocProvider.of<ItemsBloc>(context)
                          ..add(PaginateItemsEvent(widget.categoryId));
                      }
                      final product = state.products[index];
                      return InkWell(
                        onTap: () =>
                            widget.itemsPageInteractor.addItem(product),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedImage(
                                  product.image,
                                  height: 96,
                                  width: 96,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(product.title,
                                        style: theme.textTheme.headlineMedium!
                                            .copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppSettings.currencyIcon} ${product.price.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.disabledColor),
                                        ),
                                        SizedBox(width: 16.0),
                                        // Text(
                                        //   product.inStock == true ? 'In Stock' : 'Out of Stock',
                                        //   style: TextStyle(
                                        //     color: product.inStock == true ? kLightTextColor : kLightTextColor,
                                        //     fontWeight: FontWeight.w600,
                                        //     fontSize: 15.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    if (product.variationSummary.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        // inStock = widget.productData?.vendorProducts?[0].stockQuantity != 0;
                                        child: Text(
                                          product.variationSummary,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: theme.hintColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        // child: Row(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: [
                                        //     Text(
                                        //       'With Cheese',
                                        //       style: TextStyle(
                                        //         color: kLightTextColor,
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 15.0,
                                        //       ),
                                        //     ),
                                        //     Icon(
                                        //       Icons.keyboard_arrow_down_rounded,
                                        //       color: kLightTextColor,
                                        //       size: 20,
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                  ],
                                ),
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Switch(
                              //       value: product.inStock == true,
                              //       onChanged: (val) {},
                              //       activeColor: kMainColor,
                              //       inactiveTrackColor: kLightTextColor,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: PlaceholderWidgets.errorRetryWidget(
                context,
                AppLocalizations.of(context)!
                    .getTranslationOf("empty_products"),
              ),
            );
          }
        } else if (state is ItemsLoadingState) {
          return Column(
            children: <Widget>[
              Divider(
                color: theme.cardColor,
                thickness: 8.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Container(
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  height: 14,
                                  width: 120,
                                  color: theme.cardColor,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  height: 14,
                                  width: 80,
                                  color: theme.cardColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: PlaceholderWidgets.errorRetryWidget(
              context,
              AppLocalizations.of(context)!.getTranslationOf("something_wrong"),
            ),
          );
        }
      },
    );
  }

  void addOrUpdateInList(ProductData newUpdatedProduct) {
    print("addOrUpdateInList");
    _itemsBloc..add(AddUpdateInList(newUpdatedProduct));
  }
}
