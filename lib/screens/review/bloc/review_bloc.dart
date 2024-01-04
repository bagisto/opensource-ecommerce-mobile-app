/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/review_model/review_model.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_event.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_repo.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_state.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsBloc extends Bloc<ReviewsBaseEvent, ReviewsBaseState> {
  ReviewsRepository? repository;
  BuildContext? context;

  ReviewsBloc({@required this.repository, this.context})
      : super(ReviewInitialState()) {
    on<ReviewsBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      ReviewsBaseEvent event, Emitter<ReviewsBaseState> emit) async {
    if (event is FetchReviewsEvent) {
      try {
        ReviewModel reviewModel = await repository!.callReviewApi();

        emit(FetchReviewState.success(reviewModel: reviewModel));
      } catch (e) {
        emit(FetchReviewState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveReviewEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeReview(
          int.parse(event.productId),
        );
        if (baseModel.status == true) {
          emit(RemoveReviewState.success(
              productDeletedId: int.parse(event.productId),
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(RemoveReviewState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveReviewState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
