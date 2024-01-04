
import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../product_review_summary_view.dart';



class AboutProductView extends StatefulWidget {
  final NewProducts? productData;
  final bool isLoggedIn;

  const AboutProductView(
      {Key? key, required this.productData, required this.isLoggedIn})
      : super(key: key);

  @override
  State<AboutProductView> createState() => _AboutProductViewState();
}

class _AboutProductViewState extends State<AboutProductView> {
  bool? isExpansionInfo = true;
  bool? isExpansion = true;
  bool? isExpansionDetail = true;
  ProductFlats? productFlats;

  @override
  void initState() {
    productFlats = widget.productData?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Theme(
            data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Theme.of(context).colorScheme.onPrimary,
              tilePadding:const EdgeInsets.fromLTRB(16,0,16,0) ,
              title: Text(
                StringConstants.description.localized(),
                style:
                TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
              ),
              initiallyExpanded: true,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 16,left: 16),
                  child:HtmlWidget(
                    productFlats?.description ?? "",
                  ),),
              ],
            ),
          ),
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingSmall),
        Card(
          child: Theme(
            data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Theme.of(context).colorScheme.onPrimary,
              tilePadding:const EdgeInsets.fromLTRB(16,0,16,0) ,
              title: Text(
                StringConstants.moreInformation.localized(),
                style:
                TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
              ),
              initiallyExpanded: true,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.topLeft,
                    child:   Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.productData?.additionalData?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          widget.productData
                                              ?.additionalData?[index].label ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          widget.productData
                                              ?.additionalData?[index].value ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            })),),
              ],
            ),
          ),
        ),
        Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: widget.isLoggedIn
                ? ProductReviewSummaryView(
                    averageRating: widget.productData?.averageRating ?? "",
                    percentage: widget.productData?.percentageRating,
                    review: widget.productData?.reviews,
                    productImage:
                        ((widget.productData?.images?.length ?? 0) > 0 ||
                                (widget.productData?.images ?? []).isNotEmpty)
                            ? (widget.productData?.images?[0].url ?? "")
                            : "",
                    productName: ((widget
                                        .productData?.productFlats?.length ??
                                    0) >
                                0 ||
                            (widget.productData?.productFlats ?? []).isNotEmpty)
                        ? (productFlats?.name ?? "")
                        : "",
                    productId: widget.productData?.id.toString(),
                    isLogin: widget.isLoggedIn,
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}
