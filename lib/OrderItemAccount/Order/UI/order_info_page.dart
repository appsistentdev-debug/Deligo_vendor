import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Chat/UI/chatting_page.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/custom_appbar.dart';
import 'package:delivoo_store/Components/custom_divider.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Components/loader.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Chat/chat.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/UpdateOrderBloc/update_order_bloc.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:delivoo_store/theme_cubit.dart';

class OrderInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderData order = ModalRoute.of(context)!.settings.arguments as OrderData;
    return BlocProvider<UpdateOrderBloc>(
      create: (context) => UpdateOrderBloc(order.id),
      child: OrderInfo(order),
    );
  }
}

class OrderInfo extends StatefulWidget {
  final OrderData _order;

  OrderInfo(this._order);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  late UpdateOrderBloc _updateOrderBloc;
  OrderData? _orderData;
  bool isLoaderShowing = false;
  bool _rrListShow = false;

  final TextEditingController _rejectReasonController = TextEditingController();

  @override
  void initState() {
    _updateOrderBloc = BlocProvider.of<UpdateOrderBloc>(context);
    _orderData = widget._order;
    super.initState();
  }

  @override
  void dispose() {
    _rejectReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<UpdateOrderBloc, UpdateOrderStatusState>(
        listener: (context, state) async {
          if (state is UpdateLoading) {
            Loader.showLoader(context);
          } else {
            Loader.dismissLoader(context);
          }

          if (state is RefreshingOrderLoaded || state is UpdatingOrderLoaded) {
            OrderData orderData = state is RefreshingOrderLoaded
                ? state.orderData
                : (state as UpdatingOrderLoaded).orderData;
            _orderData = orderData;
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('order_update', json.encode(_orderData!.toJson()));
            setState(() {});
            if (state is RefreshingOrderLoaded) {
              _actionAct(state.updateBody);
            } else if (!_isOrderUpdateAble()) {
              Navigator.pop(context);
            }
          }
          if (state is UpdateLoadFailed) {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf(state.errMsgKey));
          }
        },
        child: getChildWidget(),
      );

  getChildWidget() {
    if (_orderData != null) {
      ThemeData theme = Theme.of(context);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(136.0),
          child: CustomAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
              padding: const EdgeInsets.only(left: 16),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              if (_orderData?.delivery?.delivery == null)
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () => _confirmStatusUpdate("rejected"),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: kLightRedColor, width: 1)),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "Reject Order",
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: kRedColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(
                color: theme.scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  dense: true,
                  title: Text(
                    (((_orderData?.user?.name ?? _orderData?.customerName) ??
                            _orderData?.getCategoryName)) ??
                        "",
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.07,
                    ),
                  ),
                  subtitle: (_orderData?.type == "LATER" &&
                          _orderData?.scheduledOn != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.getTranslationOf("created")}: ${_orderData?.createdAtFormatted}",
                              style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12,
                                  letterSpacing: 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.getTranslationOf("scheduled")}: ${_orderData?.scheduledOnFormatted}",
                              style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12,
                                  letterSpacing: 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          "${_orderData?.createdAtFormatted}",
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 12,
                              letterSpacing: 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border:
                                  Border.all(color: theme.cardColor, width: 1)),
                          child: IconButton(
                            icon: Icon(
                              Icons.message,
                              color: kMainColor,
                              size: 20.0,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChattingPage(
                                    Chat.fromOrder(
                                        _orderData!, Constants.ROLE_USER)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border:
                                  Border.all(color: theme.cardColor, width: 1)),
                          child: IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: kMainColor,
                              size: 20.0,
                            ),
                            onPressed: () => Helper.launchCustomUrl(
                                "tel:${_orderData?.user?.mobileNumber ?? _orderData?.customerMobile}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Divider(
                    color: theme.cardColor,
                    thickness: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      color: theme.scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.item,
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: kDisabledColor,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _orderData?.products?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final product = _orderData?.products?[index];
                                final addons = product?.addonChoices ?? [];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product?.vendorProduct.product
                                                    ?.title ??
                                                AppLocalizations.of(context)!
                                                    .getTranslationOf(
                                                        'product'),
                                            style: theme
                                                .textTheme.headlineMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "x(${product?.quantity})    ",
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: kTextColor,
                                          ),
                                        ),
                                        Text(
                                          "${AppSettings.currencyIcon} ${product?.vendorProduct.price}",
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...addons.map((addon) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                  ),
                                                  child: Text(
                                                    addon.addOnChoiceInnerNew
                                                        .title,
                                                    style: theme
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kTextColor,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${AppSettings.currencyIcon} ${addon.addOnChoiceInnerNew.price}",
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: kTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                child: CustomDivider(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_orderData?.orderType?.toLowerCase() != "normal" &&
                      _orderData?.meta?.reach_time != null)
                    Divider(
                      color: theme.cardColor,
                      thickness: 10.0,
                    ),
                  if (_orderData?.orderType?.toLowerCase() != "normal" &&
                      _orderData?.meta?.reach_time != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: kIconColor,
                            size: 20,
                          ),
                          SizedBox(width: 18.0),
                          Text(
                            "${AppLocalizations.of(context)!.getTranslationOf("reaching_in")} ${_orderData?.meta?.reach_time ?? "1"} ${AppLocalizations.of(context)!.getTranslationOf("in_unit_mins")}",
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  if (_orderData?.notes != null &&
                      _orderData!.notes!.isNotEmpty)
                    Divider(
                      color: theme.cardColor,
                      thickness: 10.0,
                    ),
                  if (_orderData?.notes != null &&
                      _orderData!.notes!.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/custom/ic_instruction.png',
                            height: 20.0,
                            width: 20.0,
                          ),
                          SizedBox(width: 18.0),
                          Text(
                            _orderData?.notes ?? "",
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  if (_orderData?.meta?.reject_reason != null)
                    Divider(
                      color: theme.cardColor,
                      thickness: 10.0,
                    ),
                  if (_orderData?.meta?.reject_reason != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.cancel_outlined,
                            color: kIconColor,
                            size: 20,
                          ),
                          SizedBox(width: 18.0),
                          Flexible(
                            child: Text(
                              "${AppLocalizations.of(context)!.getTranslationOf("reject_reason")}: ${_orderData?.meta?.reject_reason ?? ""}",
                              style: theme.textTheme.bodySmall!
                                  .copyWith(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                  Divider(
                    color: theme.cardColor,
                    thickness: 10.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Text(
                        AppLocalizations.of(context)!.payment.toUpperCase(),
                        style: theme.textTheme.titleLarge!.copyWith(
                            letterSpacing: 1.0,
                            fontSize: 14,
                            color: kTextColor,
                            fontWeight: FontWeight.bold)),
                    color: theme.scaffoldBackgroundColor,
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 4.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.sub,
                            style: theme.textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            '${AppSettings.currencyIcon} ${_orderData?.subtotal?.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ]),
                  ),
                  if (_orderData?.discount != null && _orderData!.discount! > 0)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                      child: CustomDivider(),
                    ),
                  if (_orderData?.discount != null && _orderData!.discount! > 0)
                    Container(
                      color: theme.scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!
                                  .getTranslationOf("coupon"),
                              style: theme.textTheme.headlineMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Text(
                              '${AppSettings.currencyIcon} ${_orderData?.discount?.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                          ]),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                    child: CustomDivider(),
                  ),
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.service,
                            style: theme.textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            '${AppSettings.currencyIcon} ${_orderData?.taxes?.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                    child: CustomDivider(),
                  ),
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .getTranslationOf("delivery_fee"),
                            style: theme.textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            '${AppSettings.currencyIcon} ${_orderData?.deliveryFee?.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                    child: CustomDivider(),
                  ),
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _orderData?.payment?.paymentMethod?.title ??
                              AppLocalizations.of(context)!.cod,
                          style: theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: kMainColor),
                        ),
                        Text(
                          '${AppSettings.currencyIcon} ${_orderData?.total}',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                    child: CustomDivider(),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (_orderData?.delivery?.delivery != null)
                      ListTile(
                        tileColor: theme.scaffoldBackgroundColor,
                        leading: CachedImage(
                          _orderData?.delivery?.delivery?.user?.mediaUrls
                              ?.images?.first.defaultImage,
                          height: 50,
                          width: 50,
                        ),
                        subtitle: Text(
                          _orderData?.delivery?.delivery?.user?.name ?? "",
                          style: theme.textTheme.headlineMedium!.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.deliveryPartner,
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        trailing: _orderData?.status != 'complete'
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    border: Border.all(
                                        color: orderBlackLight, width: 1)),
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.navigation,
                                  color: kMainColor,
                                  size: 20.0,
                                ),
                              )
                            : SizedBox.shrink(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChattingPage(Chat.fromOrder(
                                _orderData!, Constants.ROLE_DELIVERY)),
                          ),
                        ),
                      ),
                    if (_orderData?.status == 'new')
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: BottomBar(
                          text: AppLocalizations.of(context)!
                              .getTranslationOf("order_status_action_new"),
                          onTap: () => _confirmStatusUpdate("accepted"),
                        ),
                      ),
                    if (_orderData?.status != 'new')
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: BottomBar(
                          text: _actionText(),
                          onTap: () {
                            if (_isOrderUpdateAble())
                              _updateOrderBloc.add(RefreshOrderEvent());
                          },
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Loader.circularProgressIndicatorPrimary(context),
        ),
      );
    }
  }

  String? _statusToUpdate() {
    switch (_orderData?.status) {
      case "new":
      case "pending":
        return "accepted";
      // case "accepted":
      //   return "preparing";
      // case "preparing":
      //   toUpdate = "prepared";
      case "preparing":
      case "accepted":
        return "prepared";
      case "prepared":
        return _orderData?.orderType?.toLowerCase() == "normal"
            ? "dispatched"
            : "complete";
      default:
        return null;
    }
  }

  bool _isOrderUpdateAble() => _statusToUpdate() != null;

  _actionAct(Map<String, dynamic>? updateRequest) {
    if (updateRequest != null) {
      _updateOrderBloc.add(DoUpdateEvent(updateRequest));
    } else {
      String? toUpdate = _statusToUpdate();
      if (toUpdate != null) {
        if (toUpdate == "dispatched") {
          if (_orderData?.delivery?.delivery == null) {
            showToast(
                AppLocalizations.of(context)!.getTranslationOf("delivery_na"));
            _updateOrderBloc.add(
                DoUpdateEvent({"status": _orderData?.status ?? "prepared"}));
          } else if (_orderData?.delivery?.status == "new" ||
              _orderData?.delivery?.status == "pending" ||
              _orderData?.delivery?.status == "allotted") {
            showToast(AppLocalizations.of(context)!
                .getTranslationOf("delivery_left_na"));
          } else {
            _updateOrderBloc.add(DoUpdateEvent({"status": toUpdate}));
          }
        } else {
          _updateOrderBloc.add(DoUpdateEvent({"status": toUpdate}));
        }
      }
    }
  }

  String _actionText() {
    return AppLocalizations.of(context)!.getTranslationOf(
        _orderData?.status == "prepared" &&
                _orderData?.orderType?.toLowerCase() != "normal"
            ? "order_status_action_mark_complete"
            : "order_status_action_${_orderData?.status}");
  }

  _confirmStatusUpdate(String status) {
    bool rre =
        status == "rejected" && AppConfig.fireConfig!.enableOrderRejectReason;
    ThemeData theme = Theme.of(context);
    if (rre && !_rrListShow) {
      showModalBottomSheet(
        context: context,
        builder: (context) => RejectReasonsWidget(),
      ).then((value) {
        if (value != null && value is String) {
          if (value == "reject_reason_template_4") {
            _rrListShow = true;
            _confirmStatusUpdate(status);
          } else {
            Map<String, dynamic> updateRequest = {"status": status};
            Map<String, dynamic> metaExisting = {};
            if (_orderData?.dynamicMeta != null &&
                _orderData?.dynamicMeta is Map) {
              metaExisting.addAll(_orderData?.dynamicMeta);
            }
            metaExisting["reject_reason"] =
                AppLocalizations.of(context)!.getTranslationOf(value);
            updateRequest["meta"] = jsonEncode(metaExisting);
            _updateOrderBloc.add(RefreshOrderEvent(updateRequest));
          }
        }
      });
    } else {
      _rrListShow = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String keyTitle = status == "accepted"
              ? "confirm_accept_title"
              : "confirm_reject_title";
          String keyMessage = status == "accepted"
              ? "confirm_accept_message"
              : "confirm_reject_message";
          return AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title:
                Text(AppLocalizations.of(context)!.getTranslationOf(keyTitle)),
            content: rre
                ? EntryField(
                    textCapitalization: TextCapitalization.words,
                    controller: _rejectReasonController,
                    label: AppLocalizations.of(context)!
                        .getTranslationOf("reject_reason"),
                  )
                : Text(
                    AppLocalizations.of(context)!.getTranslationOf(keyMessage)),
            actions: <Widget>[
              MaterialButton(
                child: Text(AppLocalizations.of(context)!.no),
                textColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.primaryColor)),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                child: Text(AppLocalizations.of(context)!.yes),
                textColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.primaryColor)),
                onPressed: () {
                  if (rre && _rejectReasonController.text.trim().isEmpty) {
                    showToast(AppLocalizations.of(context)!
                        .getTranslationOf("share_reject_reason"));
                  } else {
                    Map<String, dynamic> updateRequest = {"status": status};
                    if (rre) {
                      Map<String, dynamic> metaExisting = {};
                      if (_orderData?.dynamicMeta != null &&
                          _orderData?.dynamicMeta is Map) {
                        metaExisting.addAll(_orderData?.dynamicMeta);
                      }
                      metaExisting["reject_reason"] =
                          _rejectReasonController.text.trim();
                      updateRequest["meta"] = jsonEncode(metaExisting);
                    }
                    _updateOrderBloc.add(RefreshOrderEvent(updateRequest));
                    _rejectReasonController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class RejectReasonsWidget extends StatefulWidget {
  const RejectReasonsWidget({Key? key}) : super(key: key);

  @override
  State<RejectReasonsWidget> createState() => _RejectReasonsWidgetState();
}

class _RejectReasonsWidgetState extends State<RejectReasonsWidget> {
  List<String> _rejectReasons = [
    "reject_reason_template_1",
    "reject_reason_template_2",
    "reject_reason_template_3",
    "reject_reason_template_4"
  ];

  String? _rejectReasonSelected;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          color: _themeCubit.isDark
              ? theme.colorScheme.surface
              : kCardBackgroundColor,
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!
                    .getTranslationOf("select_reason_to_reject"),
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _rejectReasons.length,
            itemBuilder: (context, index) => RadioListTile<String>(
              dense: true,
              title: Text(
                AppLocalizations.of(context)!
                    .getTranslationOf(_rejectReasons[index]),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _rejectReasons[index],
              groupValue: _rejectReasonSelected,
              onChanged: (String? rr) =>
                  setState(() => _rejectReasonSelected = rr),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: BottomBar(
            text:
                AppLocalizations.of(context)!.getTranslationOf("continueText"),
            onTap: () {
              if (_rejectReasonSelected == null) {
                showToast(AppLocalizations.of(context)!
                    .getTranslationOf("select_reason_to_reject"));
              } else {
                Navigator.pop(context, _rejectReasonSelected);
              }
            },
          ),
        ),
      ],
    );
  }
}
