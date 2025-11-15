// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'update_order_event.dart';

part 'update_order_state.dart';

class UpdateOrderBloc
    extends Bloc<UpdateOrderStatusEvent, UpdateOrderStatusState> {
  final int orderId;
  ProductRepository _repository = ProductRepository();

  UpdateOrderBloc(this.orderId) : super(UpdateOrderInitial());

  @override
  Stream<UpdateOrderStatusState> mapEventToState(
      UpdateOrderStatusEvent event) async* {
    if (event is RefreshOrderEvent) {
      yield RefreshingOrderLoading();
      try {
        List<CategoryData> categoriesHome = await Helper().getCategoriesHome();
        OrderData orderData = await _repository.getOrderById(orderId);
        orderData.setup(categoriesHome);
        yield RefreshingOrderLoaded(event.updateBody, orderData);
      } catch (e) {
        print("getOrderById: ${e.runtimeType}-$e");
        yield RefreshingOrderFailed("something_wrong");
      }
    } else if (event is DoUpdateEvent) {
      yield UpdatingOrderLoading();
      try {
        List<CategoryData> categoriesHome = await Helper().getCategoriesHome();
        OrderData orderData =
            await _repository.updateOrder(orderId, event.updateBody!);
        orderData.setup(categoriesHome);
        yield UpdatingOrderLoaded(orderData);
      } catch (e) {
        print("updateOrder: ${e.runtimeType}-$e");
        String errMsgKey = "something_wrong";
        if (e is DioError && e.response != null) {
          Map<String, dynamic>? errorResponse = e.response?.data;
          if (errorResponse != null && errorResponse.containsKey("errors")) {
            try {
              var errorResponse2 = errorResponse["errors"]?["status"];
              if (errorResponse2 != null) {
                List<String>? errors = new List<String>.from(errorResponse2);
                for (String errorString in errors) {
                  if (errorString.contains("picker is assigned")) {
                    errMsgKey = "picker_na";
                    break;
                  }
                  if (errorString.contains("delivery is assigned")) {
                    errMsgKey = "delivery_na";
                    break;
                  }
                }
              }
            } catch (epe) {
              print("epe: $epe");
            }
          }
        }
        yield UpdatingOrderFailed(errMsgKey);
      }
    }
  }
}
