/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names


import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/review_model/review_model.dart';
import 'package:bagisto_app_demo/screens/review/events/fetch_review_evnt.dart';
import 'package:bagisto_app_demo/screens/review/events/review_base_event.dart';
import 'package:bagisto_app_demo/screens/review/repository/review_repository.dart';
import 'package:bagisto_app_demo/screens/review/state/fetch_review_state.dart';
import 'package:bagisto_app_demo/screens/review/state/review_base_state.dart';
import 'package:bagisto_app_demo/screens/review/state/review_initial_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base_model/graphql_base_model.dart';

class ReviewsBloc extends Bloc<ReviewsBaseEvent, ReviewsBaseState> {
  ReviewsRepository? repository;
BuildContext? context;
  ReviewsBloc({@required this.repository,this.context}) : super(ReviewInitialState()){
    on<ReviewsBaseEvent>(mapEventToState);
  }

  void mapEventToState(ReviewsBaseEvent event,Emitter<ReviewsBaseState> emit) async {
    if (event is FetchReviewsEvent) {
      try {
        ReviewModel reviewModel = await repository!.callReviewApi();


          emit (FetchReviewState.success(reviewModel: reviewModel));

      } catch (e) {
        emit (FetchReviewState.fail(error: "SomethingWrong".localized()));
      }
    }else if (event is RemoveReviewEvent) {
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
        emit(RemoveReviewState.fail(
            error: "SomethingWrong".localized()));
      }
    }
    else if (event is RemoveAllReviewsEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeAllReviews();
        if (baseModel.status == true) {
          emit(RemoveAllReviewState.success(
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(RemoveAllReviewState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveAllReviewState.fail(
            error:"SomethingWrong".localized()));
      }
    }

  }


}
