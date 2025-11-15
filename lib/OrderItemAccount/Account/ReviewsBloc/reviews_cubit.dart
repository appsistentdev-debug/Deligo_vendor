// reviews_cubit.dart
import 'package:delivoo_store/JsonFiles/Ratings/ratings_data.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/OrderItemAccount/Account/ReviewsBloc/reviews_state.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ProductRepository _repository = ProductRepository();

  ReviewsCubit() : super(LoadingReviewsState());

  Future<void> getReviews(int page) async {
    emit(LoadingReviewsState());
    try {
      int? id = (await Helper().getVendorInfo())?.id;
      if (id != null) {
        BaseListResponse<RatingsData> ratingsList =
            await _repository.getVendorReviews(id, page);
        emit(SuccessReviewsState(ratingsList));
      } else {
        emit(FailureReviewsState("something_went_wrong"));
      }
    } catch (e) {
      emit(FailureReviewsState(e));
    }
  }
}
