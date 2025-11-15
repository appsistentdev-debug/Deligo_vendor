import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Components/placeholder_widgets.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/orders_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/orders_event.dart';
import 'package:delivoo_store/OrderItemAccount/Order/BLOC/orders_state.dart';
import 'package:delivoo_store/Themes/colors.dart';

import 'order_card.dart';

abstract class OrderTabsInteractor {
  void onOrderCompleted(OrderData? orderData);
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> implements OrderTabsInteractor {
  final GlobalKey<OrdersTabState> _pastOrdersWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Tab> tabs = <Tab>[
      Tab(text: AppLocalizations.of(context)!.newOrder),
      Tab(text: AppLocalizations.of(context)!.pastOrder),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.orderText,
            style: theme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TabBar(
                indicatorColor: kMainColor,
                labelStyle: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.bold, color: kMainColor),
                isScrollable: true,
                dividerHeight: 0,
                tabs: tabs,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                unselectedLabelStyle: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold, color: theme.primaryColorDark),
              ),
            ),
          ),
        ),
        body: ColoredBox(
          color: theme.cardColor,
          child: TabBarView(children: [
            BlocProvider<OrdersBloc>(
              create: (context) => OrdersBloc.orderList(true),
              child: OrdersTab(this, null),
            ),
            BlocProvider<OrdersBloc>(
              create: (context) => OrdersBloc.orderList(false),
              child: OrdersTab(null, _pastOrdersWidgetKey),
            )
          ]),
        ),
      ),
    );
  }

  @override
  void onOrderCompleted(OrderData? orderData) {
    if (_pastOrdersWidgetKey.currentState != null && orderData != null)
      _pastOrdersWidgetKey.currentState!.addOrder(orderData);
  }
}

class OrdersTab extends StatefulWidget {
  final OrderTabsInteractor? orderTabsInteractor;

  OrdersTab(this.orderTabsInteractor, Key? key) : super(key: key);

  @override
  OrdersTabState createState() => OrdersTabState();
}

class OrdersTabState extends State<OrdersTab>
    with AutomaticKeepAliveClientMixin
    implements OrderRefreshListener {
  late OrdersBloc _orderBloc;
  bool _triggeredPagination = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrdersBloc>(context);
    _orderBloc.add(FetchOrdersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _orderBloc.add(FetchOrdersEvent());
      },
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, orderState) {
          if (widget.orderTabsInteractor != null) {
            if (orderState is SuccessOrdersState &&
                orderState.updatedIndex != -1) {
              if (orderState.orders?[orderState.updatedIndex].status ==
                  "complete") {
                widget.orderTabsInteractor?.onOrderCompleted(
                    orderState.orders?.removeAt(orderState.updatedIndex));
              }
            }
          }
        },
        builder: (context, orderState) {
          if (orderState is SuccessOrdersState) {
            _triggeredPagination = false;
            if (orderState.orders != null && orderState.orders!.isNotEmpty)
              return ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: orderState.orders!.length,
                itemBuilder: (context, index) {
                  if (!_triggeredPagination &&
                      index == orderState.orders!.length - 1) {
                    _orderBloc.add(PaginateOrdersEvent());
                    _triggeredPagination = true;
                  }
                  return OrderCard(orderState.orders![index], this);
                },
              );
            else
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: PlaceholderWidgets.errorRetryWidget(
                  context,
                  AppLocalizations.of(context)!
                      .getTranslationOf("no_orders_found"),
                  AppLocalizations.of(context)!.getTranslationOf('refresh'),
                  () => _orderBloc.add(FetchOrdersEvent()),
                ),
              );
          } else if (orderState is LoadingOrdersState) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.separated(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: 10,
                itemBuilder: (context, index) => OrderShimmerCard(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.networkError),
            );
          }
        },
      ),
    );
  }

  @override
  void updateOrderInList(OrderData orderData) {
    _orderBloc.add(OrderChangedEvent(orderData));
  }

  void addOrder(OrderData orderData) {
    _orderBloc.add(OrderCompletedEvent(orderData));
  }
}

abstract class OrderRefreshListener {
  void updateOrderInList(OrderData orderData);
}
