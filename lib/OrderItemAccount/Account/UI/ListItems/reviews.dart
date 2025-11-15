import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/custom_divider.dart';
import 'package:delivoo_store/Components/placeholder_widgets.dart';
import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/OrderItemAccount/Account/ReviewsBloc/reviews_cubit.dart';
import 'package:delivoo_store/OrderItemAccount/Account/ReviewsBloc/reviews_state.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<ReviewsCubit>(
        create: (context) => ReviewsCubit(),
        child: ReviewBody(
            ModalRoute.of(context)!.settings.arguments as VendorInfo),
      );
}

class ReviewBody extends StatefulWidget {
  final VendorInfo vendorInfo;

  ReviewBody(this.vendorInfo);

  @override
  _ReviewBodyState createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<ReviewBody> {
  late ReviewsCubit _reviewsCubit;

  final List<Color> avatarBgColors = [
    Color(0xFFFFE5B4), // light orange
    Color(0xFFFFD6E0), // light pink
    Color(0xFFD1E7FF), // light blue
    Color(0xFFFFE5EC), // light rose
    Color(0xFFE5F9E0), // light green
  ];

  List<RatingsData> reviews = [];
  bool isLoading = true;
  bool allDone = false;
  int page = 1;
  double? ratings;
  int? ratingsCount;

  @override
  void initState() {
    ratings = widget.vendorInfo.ratings;
    ratingsCount = widget.vendorInfo.ratingsCount;
    super.initState();
    _reviewsCubit = BlocProvider.of<ReviewsCubit>(context);
    _reviewsCubit.getReviews(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is SuccessReviewsState) {
          isLoading = false;
          page = state.ratingsList.meta.current_page ?? 1;
          allDone = state.ratingsList.meta.current_page ==
              state.ratingsList.meta.last_page;
          if (page == 1) {
            reviews.clear();
          }
          reviews.addAll(state.ratingsList.data);

          if (state.ratingsList.data.isNotEmpty) {
            ratings = state.ratingsList.data.first.vendor.ratings;
            ratingsCount = state.ratingsList.data.first.vendor.ratingsCount;
          }
          setState(() {});
        }

        if (state is FailureReviewsState) {
          isLoading = false;
          setState(() {});
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 8),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.vendorInfo.name ?? "",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsetsDirectional.only(start: 56),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: kWhiteColor, size: 16),
                          SizedBox(width: 4),
                          Text(
                            ratings?.toStringAsFixed(1) ?? "0",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: kWhiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${ratingsCount ?? 0} ${AppLocalizations.of(context)!.getTranslationOf("ratings")}",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: kLightTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: theme.cardColor, thickness: 2),
              ),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () => _reviewsCubit.getReviews(1),
                    child: reviews.isNotEmpty
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: reviews.length,
                            separatorBuilder: (context, index) => CustomDivider(
                              color: theme.hintColor,
                            ),
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              top: 8,
                            ),
                            itemBuilder: (context, index) {
                              if (index == reviews.length - 1 &&
                                  !isLoading &&
                                  !allDone) {
                                _reviewsCubit.getReviews(page + 1);
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 56,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedImage(
                                              reviews[index].user.image,
                                              height: 56,
                                              width: 56,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  reviews[index].user.name,
                                                  style: theme
                                                      .textTheme.headlineMedium!
                                                      .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kMainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.star,
                                                          color: kWhiteColor,
                                                          size: 16),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        reviews[index]
                                                            .rating
                                                            .toString(),
                                                        style: theme
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                          color: kWhiteColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            Helper.formatDate(
                                                reviews[index].createdAt, true),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      reviews[index].review,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : (isLoading
                            ? ListView.builder(
                                itemCount: 4,
                                itemBuilder: (context, index) =>
                                    _ReviewShimmerCard(),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: PlaceholderWidgets.errorRetryWidget(
                                  context,
                                  AppLocalizations.of(context)!
                                      .getTranslationOf("no_reviews_yet"),
                                ),
                              ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final backgroundColor = isDark ? Colors.grey.shade900 : kWhiteColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      height: 16,
                      width: 100,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      height: 16,
                      width: 60,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      height: 14,
                      width: 200,
                      color: baseColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String convertToString(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return month.toString();
  }
}
