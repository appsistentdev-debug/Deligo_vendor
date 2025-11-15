import 'dart:async';
import 'dart:convert';

import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Categories/category_data.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/orders_event.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/orders_state.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Moment.parse(newOrder.createdAt).date.millisecondsSinceEpoch

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  ProductRepository _repository = ProductRepository();
  StreamSubscription<DatabaseEvent>? _ordersNewStreamSubscription,
      _ordersUpdateStreamSubscription;

  //StreamSubscription<Event> _orderStreamSubscription;
  List<OrderData>? _orders;
  // ignore: unused_field
  OrderData? _order;
  int _page = 1;
  int? _vendorId;
  bool _allDone = false, _isLoading = false;
  bool _isOrdersNew = false;
  int? _latestOrderMillis = -1;

  OrdersBloc.orderList(this._isOrdersNew) : super(LoadingOrdersState());

  OrdersBloc.orderDetail(this._order) : super(OrderSuccess(_order!));

  @override
  Future<void> close() async {
    await _unRegisterOrdersUpdates();
    //await _unRegisterOrderUpdates();
    return super.close();
  }

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    if (event is FetchOrdersEvent) {
      yield* _mapFetchPastOrdersToState(1);
    } else if (event is PaginateOrdersEvent) {
      if (!_isLoading && !_allDone) {
        yield* _mapFetchPastOrdersToState(_page + 1);
      } else {
        print("all caught up");
      }
    } else if (event is OrderAddedEvent) {
      yield* _addOrder(event.orderData);
    } else if (event is OrderChangedEvent) {
      yield* _updateOrder(event.orderData);
    } else if (event is OrderCompletedEvent) {
      _orders!.insert(0, event.orderData);
      yield SuccessOrdersState(_orders!, -1);
    }
  }

  Stream<OrdersState> _mapFetchPastOrdersToState(int page) async* {
    yield LoadingOrdersState();
    if (_orders == null || page == 1) _orders = [];
    _isLoading = true;
    if (_vendorId == null) {
      _vendorId = (await Helper().getVendorInfo())?.id;
    }
    try {
      //From local assets, testing.
      // String sampleOrderString =
      //     await rootBundle.loadString('assets/sample_order.json');
      // OrderData orderData = OrderData.fromJson(jsonDecode(sampleOrderString));

      // String sampleOrdersString =
      //     await rootBundle.loadString('assets/sample_orders.json');
      // BaseListResponse<OrderData> sampleOrders =
      //     BaseListResponse<OrderData>.fromJson(jsonDecode(sampleOrdersString),
      //         (json) => OrderData.fromJson(json as Map<String, dynamic>));
      // sampleOrders.data[0] = orderData;
      // for (OrderData orderData in sampleOrders.data) orderData.setup();
      // _orders.addAll(sampleOrders.data);
      // _page = sampleOrders.meta.current_page;
      // _allDone = sampleOrders.meta.current_page == sampleOrders.meta.last_page;
      // _isLoading = false;
      // yield SuccessOrdersState(_orders, -1);

      List<CategoryData> categoriesHome = await Helper().getCategoriesHome();
      if (categoriesHome.isEmpty) {
        categoriesHome =
            await _repository.getCategoriesWithScope(Constants.scopeHome);
      }
      //From api
      BaseListResponse<OrderData> orderRes = _isOrdersNew
          ? await _repository.getOrdersNew(_vendorId!, page)
          : await _repository.getOrdersPast(_vendorId!, page);

      if (orderRes.data.isNotEmpty &&
          orderRes.data[0].createdAt != null &&
          (_latestOrderMillis == null ||
              _latestOrderMillis! <
                  DateTime.parse(orderRes.data[0].createdAt!)
                      .millisecondsSinceEpoch)) {
        _latestOrderMillis =
            DateTime.parse(orderRes.data[0].createdAt!).millisecondsSinceEpoch;
        print("_latestOrderMillis: $_latestOrderMillis");
      }

      for (OrderData orderData in orderRes.data)
        orderData.setup(categoriesHome);
      _orders!.addAll(orderRes.data);
      _page = orderRes.meta.current_page ?? 0;
      _allDone = orderRes.meta.current_page == orderRes.meta.last_page;
      _isLoading = false;
      yield SuccessOrdersState(_orders!, -1);
      if (_isOrdersNew) {
        await _registerOrdersUpdates();
      }
    } catch (e) {
      print("FailureOrdersState: $e");
      _isLoading = false;
      yield FailureOrdersState(e);
    } finally {
      try {
        _repository
            .getCategoriesWithScope(Constants.scopeHome)
            .then((value) => Helper().saveCategoriesHome(value));
      } catch (e) {}
    }
  }

  Stream<OrdersState> _addOrder(OrderData newOrder) async* {
    if (!(newOrder.status == "new" || newOrder.status == "pending")) return;
    int newOrderCreateMillis =
        DateTime.parse(newOrder.createdAt!).millisecondsSinceEpoch;
    print(
        "newOrderCreateMillis > _latestOrderMillis: ${newOrderCreateMillis > _latestOrderMillis!}");
    if (newOrderCreateMillis > _latestOrderMillis!) {
      _latestOrderMillis = newOrderCreateMillis;
      yield LoadingOrdersState();
      List<CategoryData> categoriesHome = await Helper().getCategoriesHome();
      int existingIndex = -1;
      for (int i = 0; i < _orders!.length; i++) {
        if (_orders![i].id == newOrder.id) {
          existingIndex = i;
          break;
        }
      }
      print("_addOrder found_at $existingIndex");
      newOrder.setup(categoriesHome);
      if (existingIndex == -1) {
        _orders!.insert(0, newOrder);
      } else {
        _orders![existingIndex] = newOrder;
      }
      yield SuccessOrdersState(_orders!, -1);
    }
  }

  Stream<OrdersState> _updateOrder(OrderData newOrder) async* {
    yield LoadingOrdersState();
    List<CategoryData> categoriesHome = await Helper().getCategoriesHome();
    int index = -1;
    try {
      for (int i = 0; i < _orders!.length; i++) {
        if (_orders![i].id == newOrder.id) {
          index = i;
          break;
        }
      }
      print("_updateOrder found_at $index");
      if (index != -1) {
        newOrder.setup(categoriesHome);
        _orders![index] = newOrder;
      }
    } catch (e) {
      print("_updateOrder-${e.runtimeType}: $e");
    }
    yield SuccessOrdersState(_orders!, index);
  }

  Future<void> _registerOrdersUpdates() async {
    if (_vendorId == null) {
      _vendorId = (await Helper().getVendorInfo())?.id;
    }
    if (_ordersNewStreamSubscription == null) {
      _ordersNewStreamSubscription = _repository
          .getOrdersFirebaseDbRefChildAdded(_vendorId!)
          .listen(
              (DatabaseEvent event) => _handleFireEvent(event, "child_added"));
    }
    if (_ordersUpdateStreamSubscription == null) {
      _ordersUpdateStreamSubscription = _repository
          .getOrdersFirebaseDbRefChildChanged(_vendorId!)
          .listen((DatabaseEvent event) =>
              _handleFireEvent(event, "child_changed"));
    }
  }

  _unRegisterOrdersUpdates() async {
    await _ordersNewStreamSubscription?.cancel();
    _ordersNewStreamSubscription = null;
    await _ordersUpdateStreamSubscription?.cancel();
    _ordersUpdateStreamSubscription = null;
  }

  // _unRegisterOrderUpdates() async {
  //   if (_orderStreamSubscription != null) {
  //     await _orderStreamSubscription.cancel();
  //     _orderStreamSubscription = null;
  //   }
  // }

  _handleFireEvent(DatabaseEvent event, String eventType) {
    if (event.snapshot.value != null) {
      try {
        Map requestMap = event.snapshot.value as Map;

        OrderData? orderUpdated = requestMap.containsKey("data")
            ? OrderData.fromJson(jsonDecode(jsonEncode(requestMap["data"])))
            : null;
        if (orderUpdated?.id != null && orderUpdated?.status != null) {
          if (eventType == "child_added")
            add(OrderAddedEvent(orderUpdated!));
          else
            add(OrderChangedEvent(orderUpdated!));
        }
      } catch (e) {
        print("requestMapCastError: $e");
      }
    }
  }
}
