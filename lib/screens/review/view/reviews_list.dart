// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../common_widget/image_view.dart';
import '../../../../models/review_model/review_model.dart';
import '../../../../routes/route_constants.dart';
import '../../../configuration/app_global_data.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/review_bloc.dart';
import '../events/fetch_review_evnt.dart';
import 'package:collection/collection.dart';

class ReviewsList extends StatefulWidget {
  ReviewData? reviewData;
  ReviewsBloc? reviewsBloc;

  ReviewsList({Key? key, this.reviewData, this.reviewsBloc}) : super(key: key);

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  dynamic productFlats;
  @override
  void initState() {
     productFlats = widget.reviewData?.product?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductPage,
            arguments: PassProductData(
                title: productFlats.name ?? widget.reviewData?.product?.productFlats?[0].name,
                productId: int.tryParse(widget.reviewData?.productId ?? "") ?? 0));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.normalPadding,
              AppSizes.normalPadding, 0, AppSizes.normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.reviewData?.product?.images ?? []).isNotEmpty
                      ? Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    child: ImageView(
                      url: widget.reviewData?.product?.images?[0].url ??
                          "",
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 5,
                    ),
                  )
                      : ImageView(
                    url: "",
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                              children: List.generate(
                                  5,
                                      (index) => (index >=
                                      num.parse(widget.reviewData?.rating
                                          .toString() ??
                                          ""))
                                      ? Icon(
                                    Icons.star_border,
                                    color: MobikulTheme().getColor(
                                        double.parse(widget
                                            .reviewData?.rating
                                            .toString() ??
                                            "")),
                                    size: 16.0,
                                  )
                                      : Icon(
                                    Icons.star,
                                    color: MobikulTheme().getColor(
                                        double.parse(widget
                                            .reviewData?.rating
                                            .toString() ??
                                            "")),
                                    size: 16.0,
                                  ))),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/4.8,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(widget.reviewData?.title ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: AppSizes.width / 5,
                          ),
                          InkWell(
                              onTap: () {
                                _onPressRemove(context);
                              },
                              child: const Icon(Icons.delete))
                        ],
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: HtmlWidget(widget.reviewData?.comment ?? ""),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "ReviewBy".localized(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.reviewData?.customerName ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                          "Email".localized()+":",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)
                      ),
                      Text(widget.reviewData?.customerName ?? "",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "date".localized()+":",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)
                      ),
                      Text(
                        widget.reviewData?.createdAt ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: AppSizes.normalPadding),

                    ],
                  )

                ],
              ),
              const SizedBox(height: AppSizes.normalPadding),
            ],
          ),
        ),
      ),
    );
  }

  _onPressRemove(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "deleteReviewWarning".localized(),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "ButtonLabelNO".localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();

                  if (widget.reviewsBloc != null) {
                    widget.reviewsBloc
                        ?.add(RemoveReviewEvent(widget.reviewData?.id, ""));
                  }
                },
                child: Text("ButtonLabelYes".localized()))
          ],
        );
      },
    );
  }
}
