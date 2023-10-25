import 'package:bagisto_app_demo/screens/product_screen/view/product_screen_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

import '../../../../configuration/app_global_data.dart';
class AboutProductView extends StatefulWidget {
  final Product productData;
  final bool isLoggedIn;

  const AboutProductView({Key? key, required this.productData, required this.isLoggedIn}) : super(key: key);

  @override
  State<AboutProductView> createState() => _AboutProductViewState();
}

class _AboutProductViewState extends State<AboutProductView> {
  bool? isExpansionInfo = true;
  bool? isExpansion = true;
  bool? isExpansionDetail = true;
  dynamic productFlats;
  @override
  void initState() {
     productFlats = widget.productData.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 16, top: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isExpansion = !isExpansion!;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "shortDescription".localized(),
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                        isExpansion == true
                            ? Icon(
                          CupertinoIcons.chevron_up,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                            : Icon(
                          CupertinoIcons.chevron_down,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      ],
                    ),
                  ),
                ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
                if (isExpansion ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 4),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: HtmlWidget(
                          productFlats.shortDescription ?? "",
                        ),
                      ),
                    ),
                  ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
              ],
            )),
        CommonWidgets().getTextFieldHeight(NormalWidth),
        Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 16, top: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isExpansionDetail = !isExpansionDetail!;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Details".localized(),
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                        isExpansionDetail == true
                            ? Icon(
                          CupertinoIcons.chevron_up,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                            : Icon(
                          CupertinoIcons.chevron_down,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      ],
                    ),
                  ),
                ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
                if (isExpansionDetail ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 4),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: HtmlWidget(
                          productFlats.description ?? "",
                        ),
                      ),
                    ),
                  ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
              ],
            )),
        Card(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isExpansionInfo = !isExpansionInfo!;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MoreInformation".localized(),
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                        isExpansionInfo == true
                            ? Icon(
                          CupertinoIcons.chevron_up,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                            : Icon(
                          CupertinoIcons.chevron_down,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      ],
                    ),
                  ),
                ),
                if (isExpansionInfo ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 4),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.productData.additionalData?.length,
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
                                                .additionalData?[index].label ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[400]),
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
                                                .additionalData?[index].value ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[400]),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              })),
                    ),
                  ),
              ],
            )),
        Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isLoggedIn
                    ? ProductReviewSummaryView(
                  averageRating: widget.productData.averageRating ?? "",
                  percentage: widget.productData.percentageRating,
                  review: widget.productData.reviews,
                  productImage: ((widget.productData.images?.length ?? 0) > 0 ||
                      (widget.productData.images ?? []).isNotEmpty)
                      ? (widget.productData.images?[0].url ?? "")
                      : "",
                  productName:
                  ((widget.productData.productFlats?.length ?? 0) > 0 ||
                      widget.productData.productFlats!.isNotEmpty)
                      ? (productFlats.name ?? "")
                      : "",
                  productId: widget.productData.id.toString(),
                  isLogin: widget.isLoggedIn,
                )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
