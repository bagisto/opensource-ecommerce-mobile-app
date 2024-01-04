/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import 'package:bagisto_app_demo/data_model/review_model/review_model.dart';
import '../../../utils/index.dart';

abstract class ReviewsRepository {
  Future<ReviewModel> callReviewApi();
  Future<GraphQlBaseModel> removeReview(int productId);
}

class ReviewsRepositoryImp implements ReviewsRepository {
  @override
  Future<ReviewModel> callReviewApi() async {
    ReviewModel? reviewModel;
    try {
      reviewModel = await ApiClient().getReviewList();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return reviewModel!;
  }

  @override
  Future<GraphQlBaseModel> removeReview(int productId)async{
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().removeReview(productId);
    return baseModel!;
  }
}
