// reviews_state.dart
import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:equatable/equatable.dart';

class ReviewsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingReviewsState extends ReviewsState {}

class SuccessReviewsState extends ReviewsState {
  final BaseListResponse<RatingsData> ratingsList;

  SuccessReviewsState(this.ratingsList);

  @override
  List<Object> get props => [ratingsList];
}

class FailureReviewsState extends ReviewsState {
  final e;

  FailureReviewsState(this.e);

  @override
  List<Object> get props => [e];
}
