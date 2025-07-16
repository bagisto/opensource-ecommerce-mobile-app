/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import 'package:bagisto_app_demo/screens/add_review/utils/index.dart';

import 'package:http/http.dart';

abstract class AddReviewRepository {
  Future<AddReviewModel> callAddReviewApi(String name, String title, int rating,
      String comment, int productId, List<MultipartFile> attachments);
}

class AddReviewRepositoryImp implements AddReviewRepository {
  @override
  Future<AddReviewModel> callAddReviewApi(String name, String title, int rating,
      String comment, int productId, List<MultipartFile> attachments) async {
    AddReviewModel? addReviewModel;
    try {
      addReviewModel = await ApiClient()
          .addReview(name, title, rating, comment, productId, attachments);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addReviewModel!;
  }
}
