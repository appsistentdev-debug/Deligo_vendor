import 'package:delivoo_store/Components/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/placeholder_widgets.dart';
import 'package:delivoo_store/JsonFiles/Products/product_data.dart';
import 'package:delivoo_store/JsonFiles/insights/vendor_insight.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SummaryBloc/summary_bloc.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SummaryBloc/summary_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/SummaryBloc/summary_state.dart';
import 'package:delivoo_store/Routes/routes.dart';
import 'package:delivoo_store/UtilityFunctions/app_settings.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:delivoo_store/theme_cubit.dart';

class InsightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<SummaryBloc>(
      create: (context) => SummaryBloc(), child: InsightStateful());
}

class BarChartData {
  String time;
  num earning;

  BarChartData({required this.time, required this.earning});
}

class InsightStateful extends StatefulWidget {
  @override
  _InsightStatefulState createState() => _InsightStatefulState();
}

class _InsightStatefulState extends State<InsightStateful> {
  late SummaryBloc _summaryBloc;
  List<BarChartData> chartData = [];
  late VendorInsight _vendorInsight;
  String _popupSelection = 'today';
  String? _popupSelectionOld;
  List<ProductData>? _products;

  bool _isLoadingInsights = true;
  bool _isLoadingProducts = true;

  String _getPeriodLabel(String periodValue) {
    List<String> months = [
      "jan",
      "feb",
      "mar",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "oct",
      "nov",
      "dec"
    ];
    if (periodValue.contains("_") || periodValue.contains("-")) {
      return Helper.formatDate(periodValue, false);
    } else if (_popupSelectionOld == "month") {
      int index = int.tryParse(periodValue) ?? 0;
      return AppLocalizations.of(context)!
          .getTranslationOf(months[index > 0 ? index - 1 : index]);
    } else if (_popupSelectionOld == "today") {
      String toReturn = periodValue;
      if (periodValue.length == 1) toReturn = "0" + toReturn;
      if (int.tryParse(periodValue) != null) toReturn = toReturn += ":00";
      return toReturn;
    } else {
      return periodValue;
    }
  }

  // ignore: unused_field
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _summaryBloc = context.read<SummaryBloc>();
    _vendorInsight = VendorInsight.getDefault();
    super.initState();
    _summaryBloc.add(FetchSummaryEvent(_popupSelection));
    _summaryBloc.add(FetchBestSellingEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<SummaryBloc, SummaryState>(
      listener: (context, state) {
        if (state is LoadingInsightState) {
          _isLoadingInsights = true;
          setState(() => _popupSelection = state.duration);
        } else if (state is LoadedInsightState) {
          setState(() {
            _popupSelectionOld = _popupSelection;
            _vendorInsight = state.vendorInsight;
            _isLoadingInsights = false;
            chartData = _vendorInsight.chartData
                .map((data) => BarChartData(
                    time: _getPeriodLabel(data.period.toString()),
                    earning: double.tryParse(data.total) ?? 0))
                .toList();
          });
        }

        if (state is LoadingTopSellingState) {
          _isLoadingProducts = true;
        } else if (state is LoadedTopSellingState) {
          _products = state.products;
          _isLoadingProducts = false;
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0.0,
          title: Text(
            AppLocalizations.of(context)!.insight,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (_popupSelectionOld == null || _popupSelectionOld != value)
                  _summaryBloc.add(FetchSummaryEvent(value));
              },
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("insight_filter_$_popupSelection"),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 15.0,
                      letterSpacing: 1.5,
                      //color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  _isLoadingInsights
                      ? SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.primaryColor),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          //color: theme.primaryColor,
                        ),
                  SizedBox(width: 20.0)
                ],
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'today',
                  child: Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("insight_filter_today"),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      //color: theme.primaryColor,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'week',
                  child: Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("insight_filter_week"),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      //color: theme.primaryColor,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'month',
                  child: Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("insight_filter_month"),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      //color: theme.primaryColor,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'year',
                  child: Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("insight_filter_year"),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      //color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            // Summary Card
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(
                        label: AppLocalizations.of(context)!
                            .getTranslationOf("orders"),
                        value: _vendorInsight.orders.toString(),
                        theme: theme,
                      ),
                      //SizedBox(width: 20),
                      _buildStatColumn(
                        label: AppLocalizations.of(context)!
                            .getTranslationOf("itemSold"),
                        value: _vendorInsight.itemsSold.toString(),
                        theme: theme,
                      ),
                      //SizedBox(width: 20),
                      _buildStatColumn(
                        label: AppLocalizations.of(context)!
                            .getTranslationOf("earnings"),
                        value:
                            "${AppSettings.currencyIcon}${_vendorInsight.revenue}",
                        theme: theme,
                      ),
                    ],
                  ),
                  // Green underline for Earnings
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 4,
                  //         child: Container(
                  //           height: 2,
                  //           color: orderBlackLight,
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 2,
                  //         child: Container(
                  //           height: 2,
                  //           color: theme.primaryColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            // Earnings Chart Title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.orders,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            // Earnings Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _isLoadingInsights
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: 16.0,
                          width: 16.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primaryColor),
                          ),
                        ),
                      ),
                    )
                  : SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: TextStyle(color: Colors.black),
                        axisLine: AxisLine(color: theme.primaryColor),
                        majorGridLines:
                            MajorGridLines(width: 0, color: theme.primaryColor),
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <CartesianSeries<BarChartData, String>>[
                        StackedColumnSeries<BarChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (BarChartData data, _) => data.time,
                          yValueMapper: (BarChartData data, _) => data.earning,
                          trackColor: theme.primaryColor.withValues(alpha: 0.2),
                          //
                          color: theme.primaryColor,
                          isTrackVisible: true,
                          width: 0.4,
                          //
                          //name: 'Sales',
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
            ),
            // View all Transactions Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, PageRoutes.walletPage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            // Top 5 Selling Items Title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .getTranslationOf("top_selling"),
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.getTranslationOf("total")} ${_vendorInsight.itemsSold} ${AppLocalizations.of(context)!.getTranslationOf("item_sales")} ",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.disabledColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Top 5 Selling Items List
            if (_isLoadingProducts)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: PlaceholderWidgets.loadingWidget(context),
              ),
            if (!_isLoadingProducts &&
                (_products == null || _products!.isEmpty))
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: PlaceholderWidgets.errorRetryWidget(
                  context,
                  AppLocalizations.of(context)!
                      .getTranslationOf("empty_products_best"),
                ),
              ),
            if (!_isLoadingProducts &&
                (_products != null && _products!.isNotEmpty))
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _products!.length > 5 ? 5 : _products!.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: CustomDivider(
                    padding: 4,
                  ),
                ),
                itemBuilder: (context, index) {
                  final product = _products![index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedImage(
                            product.image,
                            height: 61.3,
                            width: 61.3,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(product.title,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 8.0),
                            Text(
                              product.vendorProducts != null &&
                                      product.vendorProducts!.isNotEmpty &&
                                      product.vendorProducts![0].price != null
                                  ? "\$${product.vendorProducts![0].price}"
                                  : "",
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 13,
                                color: theme.disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String value,
    required ThemeData theme,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(0xFFBFC2C7),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
