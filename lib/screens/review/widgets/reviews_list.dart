import 'package:bagisto_app_demo/screens/home_page/utils/route_argument_helper.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:bagisto_app_demo/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:bagisto_app_demo/screens/review/utils/index.dart';
import 'package:collection/collection.dart';

import '../../../utils/status_color_helper.dart';

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
    productFlats = widget.reviewData?.product?.productFlats
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, productScreen,
            arguments: PassProductData(
                title: productFlats?.name ??
                    widget.reviewData?.product?.productFlats?[0].name,
                urlKey: widget.reviewData?.product?.urlKey,
                productId:
                    int.tryParse(widget.reviewData?.productId ?? "") ?? 0));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal,
              AppSizes.spacingNormal, 0, AppSizes.spacingNormal),
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
                            width: MediaQuery.of(context).size.width / 4.5,
                            height: MediaQuery.of(context).size.width / 5,
                          ),
                        )
                      : ImageView(
                          url: "",
                          width: MediaQuery.of(context).size.width / 4.5,
                          height: MediaQuery.of(context).size.width / 5,
                        ),
                  const SizedBox(width: AppSizes.spacingNormal),
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
                                          color: ReviewColorHelper.getColor(
                                              double.parse(widget
                                                      .reviewData?.rating
                                                      .toString() ??
                                                  "")),
                                          size: 16.0,
                                        )
                                      : Icon(
                                          Icons.star,
                                          color: ReviewColorHelper.getColor(
                                              double.parse(widget
                                                      .reviewData?.rating
                                                      .toString() ??
                                                  "")),
                                          size: 16.0,
                                        ))),
                          const SizedBox(width: AppSizes.spacingNormal),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(widget.reviewData?.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: AppSizes.spacingNormal),
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
                            StringConstants.reviewBy.localized(),
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
                      Text("${StringConstants.email.localized()}:",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(widget.reviewData?.customerName ?? "",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("${StringConstants.date.localized()}:",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(
                        widget.reviewData?.createdAt ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: AppSizes.spacingNormal),
                    ],
                  )
                ],
              ),
              const SizedBox(height: AppSizes.spacingNormal),
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
            StringConstants.deleteReviewWarning.localized(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                StringConstants.no.localized(),
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
                child: Text(StringConstants.yes.localized(), style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }
}
