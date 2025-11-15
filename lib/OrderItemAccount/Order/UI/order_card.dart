import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/custom_divider.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Order/UI/order_page.dart';
import 'package:delivoo_store/Routes/routes.dart';
import 'package:delivoo_store/Themes/colors.dart';

class OrderShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final containerColor = isDark ? Colors.grey[700]! : Colors.white;

    return Column(
      children: [
        Divider(color: theme.cardColor, thickness: 8.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 14,
                  width: 50,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 10,
                  width: 90,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: theme.cardColor,
          thickness: 1.2,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 94, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 14,
                  width: 50,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 14,
                  width: 50,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 14,
                  width: 50,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderData order;
  final OrderRefreshListener? _orderRefreshListener;

  OrderCard(this.order, [this._orderRefreshListener]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () => Navigator.pushNamed(context, PageRoutes.orderInfoPage,
              arguments: order)
          .then((value) async {
        if (_orderRefreshListener != null) {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey("order_update")) {
            try {
              String? orderUpdate = prefs.getString('order_update');
              if (orderUpdate != null) {
                OrderData orderData =
                    OrderData.fromJson(json.decode(orderUpdate));
                _orderRefreshListener?.updateOrderInList(orderData);
              }
            } catch (e) {
              print("SharedPreferencesOrderUpdate: $e");
            }
          }
          prefs.remove("order_update");
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(top: 10),
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedImage(
                    order.image ?? order.user?.image,
                    height: 48,
                    width: 48,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          order.user?.name ?? order.getCategoryName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.orderNumber}${order.id}${!order.isNormal ? ", ${AppLocalizations.of(context)!.getTranslationOf("order_type_${order.orderType?.toLowerCase()}")}" : ""}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: kTextColor,
                              ),
                            ),
                            Text(
                              order.createdAtFormatted ?? "",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: kTextColor,
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
            CustomDivider(),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${order.products?.length} ${AppLocalizations.of(context)!.getTranslationOf("items")}",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: kTextColor,
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(
                      order.totalFormatted ?? "",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: order.colorLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("order_status_${order.status}")
                        .toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: order.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
