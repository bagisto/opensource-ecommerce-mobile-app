/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/product_screen/view/widget/review_linear_progress_indicator.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/string_constants.dart';
import '../../home_page/data_model/new_product_data.dart';
import 'package:flutter/material.dart';


//ignore: must_be_immutable
class ProductReviewSummaryView extends StatefulWidget {
  List<Reviews>? review;
  String? productId;
  String? averageRating;
  dynamic percentage;
  String? productName;
  String? productImage;
  bool? isLogin;

  ProductReviewSummaryView(
      {Key? key,
      this.review,
      this.productName,
      this.productImage,
      this.averageRating,
      this.percentage,
      this.productId,
      this.isLogin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductReviewSummaryViewState();
  }
}

class ProductReviewSummaryViewState extends State<ProductReviewSummaryView> {
  var percentage;

  @override
  void initState() {
    percentage = (widget.percentage.toString()) != "[]"
        ? json.decode(widget.percentage.toString())
        : [];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Theme.of(context).colorScheme.onPrimary,
        tilePadding:const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge) ,
        title: Text(
          StringConstants.customerRating.localized(),
          style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
        ),
        initiallyExpanded: true,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(AppSizes.spacingNormal),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if ((widget.review?.length ?? 0) > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Column(children: [
                              Text(
                                  "${widget.averageRating?.toString() ?? ''} ${StringConstants.star.localized()}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              RatingBar.builder(
                                unratedColor: MobikulTheme.appBarBackgroundColor,
                                itemSize: 16,
                                initialRating:
                                    num.tryParse(widget.averageRating.toString())
                                            ?.toDouble() ??
                                        0.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.black,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              const SizedBox(height: 6),
                              Text(
                                  "${widget.averageRating?.toString() ?? ''} Rating & "
                                  "${widget.review?.length.toString() ?? ''} Reviews",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12
                                  )),
                              const SizedBox(height: 8),
                            ]),
                          ),
                          ReviewLinearProgressIndicator(percentage: percentage),
                        ],
                      ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            8, ((widget.review?.length ?? 0) > 0 ? 8 : 0), 0, 0),
                        child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15)),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.onPrimary),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)))),
                            onPressed: () {
                              widget.isLogin ?? false
                                  ? Navigator.pushNamed(context, addReviewScreen,
                                      arguments: AddReviewDetail(
                                          imageUrl: widget.productImage,
                                          productId: widget.productId,
                                          productName: widget.productName))
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content:
                                          Text(StringConstants.pleaseLoginReview.localized()),
                                      duration: const Duration(seconds: 3),
                                    ));
                            },
                            child: Text(StringConstants.writeReview.localized().toUpperCase(), style: const TextStyle(fontSize: 17)))),
                  ])),
        ],
      ),
    );
  }
}
