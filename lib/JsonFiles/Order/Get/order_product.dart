import 'package:delivoo_store/JsonFiles/Products/vendor_product.dart';
import 'package:json_annotation/json_annotation.dart';

import 'addon_choice_new.dart';

part 'order_product.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderProduct {
  final int id;
  final int quantity;
  final double total;
  final double? subtotal;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'vendor_product_id')
  final int? vendorProductId;
  @JsonKey(name: 'vendor_product')
  final VendorProduct vendorProduct;
  @JsonKey(name: 'addon_choices')
  final List<AddOnChoiceNew>? addonChoices;

  OrderProduct({
    required this.id,
    required this.quantity,
    required this.total,
    required this.subtotal,
    required this.orderId,
    required this.vendorProductId,
    required this.vendorProduct,
    required this.addonChoices,
  });

  factory OrderProduct.fromJson(Map json) => _$OrderProductFromJson(json);

  Map toJson() => _$OrderProductToJson(this);

  String addonChoicesToString(String seperatorLast) {
    String toReturn = "";
    if (addonChoices != null && addonChoices!.isNotEmpty) {
      for (int i = 0; i < addonChoices!.length - 1; i++) {
        toReturn += "${addonChoices![i].addOnChoiceInnerNew.title}, ";
      }
      if (toReturn.isNotEmpty) {
        toReturn = toReturn.substring(0, toReturn.length - 2);
        toReturn +=
            " $seperatorLast ${addonChoices![addonChoices!.length - 1].addOnChoiceInnerNew.title}";
      } else {
        toReturn +=
            "${addonChoices![addonChoices!.length - 1].addOnChoiceInnerNew.title}";
      }
    }
    return toReturn;
  }
}
