import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/address.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_meta.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo_store/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'delivery_data.dart';
import 'order_product.dart';

part 'order_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderData {
  final int id;
  final String? notes;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  final double? subtotal;
  final double? taxes;
  @JsonKey(name: 'delivery_fee')
  final double? deliveryFee;
  final double? total;
  final double? discount;
  final String? type;
  @JsonKey(name: 'order_type')
  final String? orderType;

  @JsonKey(name: 'customer_name')
  final String? customerName;
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @JsonKey(name: 'customer_mobile')
  final String? customerMobile;

  @JsonKey(name: 'scheduled_on')
  final String? scheduledOn;
  final String? status;
  @JsonKey(name: 'vendor_id')
  final int? vendorId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final List<OrderProduct>? products;
  final Vendor? vendor;
  final UserInformation? user;
  final Address? address;

  final DeliveryData? delivery;
  final Payment? payment;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? createdAtFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? scheduledOnFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? totalFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  CategoryData? _categoryData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? color;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? colorLight;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? image;

  OrderData(
    this.id,
    this.notes,
    this.dynamicMeta,
    this.subtotal,
    this.taxes,
    this.deliveryFee,
    this.total,
    this.discount,
    this.type,
    this.scheduledOn,
    this.status,
    this.vendorId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.vendor,
    this.user,
    this.address,
    this.delivery,
    this.payment,
    this.orderType,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
  );

  setup(List<CategoryData> categoriesHome) {
    createdAtFormatted = Helper.formatDateTime(
        createdAt!, false, AppConfig.fireConfig!.enableAmPm);
    if (scheduledOn != null)
      scheduledOnFormatted = Helper.formatDateTime(
          scheduledOn!, false, AppConfig.fireConfig!.enableAmPm);
    totalFormatted = "${AppSettings.currencyIcon} ${total?.toStringAsFixed(2)}";
    switch (status) {
      case "new":
      case "pending":
        color = kMainColor;
        colorLight = orderGreenLight;
        break;
      case "complete":
      case "failed":
      case "cancelled":
        color = kRedColor;
        colorLight = kLightRedColor;
        break;
      case "rejected":
        color = orderBlack;
        colorLight = orderBlackLight;
        break;
      default:
        color = kOrangeColor;
        colorLight = orderOrangeLight;
        break;
    }
    vendor?.setup();
    try {
      for (CategoryData ch in categoriesHome) {
        if (ch.slug == "${Constants.scopeHome}-${vendor?.vendorType}") {
          image = ch.image;
          break;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("orderImageSetup: $e");
    } finally {
      try {
        image ??= (meta as Map)["category_image"];
      } catch (e) {
        // ignore: avoid_print
        print("orderImageInnerSetup: $e");
      }
    }
  }

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);

  bool isFinalised() {
    return status != null &&
        (status == 'complete' ||
            status == 'rejected' ||
            status == 'failed' ||
            status == 'cancelled');
  }

  LatLng get sourceLatLng => LatLng(vendor!.latitude, vendor!.longitude);

  LatLng get destinationLatLng =>
      LatLng(address?.latitude ?? 0, address?.longitude ?? 0);

  bool get isNormal => orderType?.toLowerCase() == "normal";

  OrderMeta? get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? OrderMeta.fromJson(dynamicMeta)
        : null;
  }

  String get getCategoryName {
    String? toReturn;
    if (_categoryData == null &&
        meta != null &&
        meta?.category_id != null &&
        vendor != null) {
      List<CategoryData> categoriesAll = [];
      if (vendor?.categories != null) categoriesAll.addAll(vendor!.categories!);
      if (vendor?.productCategories != null)
        categoriesAll.addAll(vendor!.productCategories!);
      for (CategoryData categoryData in categoriesAll) {
        if (categoryData.id == (int.tryParse(meta!.category_id!) ?? 0)) {
          _categoryData = categoryData;
          break;
        }
      }
    }
    if (_categoryData != null) toReturn = _categoryData?.title;
    if (toReturn == null && meta != null && meta?.category_title != null)
      toReturn = meta?.category_title;
    if (toReturn == null) toReturn = user?.name ?? "";
    return toReturn;
  }
}
