import 'package:bagisto_app_demo/widgets/price_widget.dart';

import '../../../../utils/status_color_helper.dart';
import '../group_product.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';


// ignore: must_be_immutable
class ProductTypeView extends StatefulWidget {
  final NewProducts? productData;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  bool isLoggedIn = false;
  Function(
    List configurableParams,
    List bundleParams,
    List selectList,
    List selectParam,
    List groupedParams,
    List downloadLinks,
    int qty,
    dynamic configurableProductId,
  )? callback;
  int qty = 1;
  String? price;
  final scrollController;
  dynamic configurableProductId;

  ProductTypeView({
    Key? key,
    this.productData,
    this.price,
    required this.scaffoldMessengerKey,
    this.scrollController,
    required this.qty,
    this.configurableProductId,
    required this.isLoggedIn,
    this.callback,
  }) : super(key: key);

  @override
  State<ProductTypeView> createState() => _ProductTypeViewState();
}

class _ProductTypeViewState extends State<ProductTypeView> {
  List downloadLinks = [];
  List groupedParams = [];
  List bundleParams = [];
  List configurableParams = [];
  List selectList = [];
  List selectParam = [];
  @override
  Widget build(BuildContext context) {
    var productFlats = widget.productData?.productFlats
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productFlats?.name ?? "",
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CommonWidgets().getHeightSpace(8),
                  PriceWidgetHtml(priceHtml: widget.price ??
                      widget.productData?.priceHtml?.priceHtml ?? ""),
                  if (widget.productData?.reviews?.isNotEmpty ?? true)
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ReviewColorHelper.getColor(double.tryParse(
                                      widget.productData?.rating.toString() ??
                                          "0") ??
                                  0),
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: AppSizes.spacingNormal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.productData?.reviews?.isNotEmpty ??
                                  true)
                                Text(
                                    (widget.productData?.reviews?[0].rating ??
                                            0)
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              if (widget.productData?.reviews?.isNotEmpty ??
                                  true)
                                CommonWidgets()
                                    .getWidthSpace(AppSizes.spacingSmall),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                        CommonWidgets().getWidthSpace(AppSizes.spacingNormal),
                        GestureDetector(
                          onTap: () {
                            ((widget.productData?.reviews?.length ?? 0) > 0)
                                ? widget.scrollController.animateTo(
                                    widget.scrollController.position
                                        .maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease)
                                : null;
                          },
                          child: Text(
                            "${widget.productData?.reviews?.length} Review(s)"
                                .localized(),
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.productData?.type != StringConstants.grouped)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type != StringConstants.grouped)
          Card(
            elevation: 2,
            child: StatefulBuilder(builder: (context, changeState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: QuantityView(
                  qty: widget.qty.toString(),
                  callBack: (qty) {
                    changeState(() {
                      widget.qty = qty;
                    });
                    widget.callback!(
                        configurableParams,
                        bundleParams,
                        selectList,
                        selectParam,
                        groupedParams,
                        downloadLinks,
                        widget.qty,
                        widget.configurableProductId);
                  },
                ),
              );
            }),
          ),
        if (widget.productData?.type == StringConstants.grouped)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.grouped)
          Card(
            child: GroupProduct(
              groupedProducts: widget.productData?.groupedProducts,
              callBack: (qty) {
                groupedParams = qty;
                selectList = groupedParams;
                widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    widget.qty,
                    widget.configurableProductId);
              },
            ),
          ),
        if (widget.productData?.type == StringConstants.downloadable)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.downloadable)
          Card(
            child: Column(
              children: [
                DownloadProductSample(
                  samples: widget.productData?.downloadableSamples,
                  scaffoldMessengerKey: widget.scaffoldMessengerKey,
                ),
                DownloadProductOptions(
                  options: widget.productData?.downloadableLinks,
                  callBack: (ids) {
                    downloadLinks = ids;
                    selectList = downloadLinks;
                    widget.callback!(
                        configurableParams,
                        bundleParams,
                        selectList,
                        selectParam,
                        groupedParams,
                        downloadLinks,
                        widget.qty,
                        widget.configurableProductId);
                  },
                )
              ],
            ),
          ),
        if (widget.productData?.type == StringConstants.configurable)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.configurable)
          Card(
            child: CustomOptionsView(
              productData: widget.productData,
              customOptions: widget.productData?.configurableData?.attributes,
              variants: widget.productData?.variants,
              callback: (data, id) {
                configurableParams = data;
                widget.configurableProductId = id;
                selectList = configurableParams;
                widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    widget.qty,
                    widget.configurableProductId);
                getConfigurablePrice();
              },
            ),
          ),
        if (widget.productData?.type == StringConstants.bundle)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.bundle)
          Card(
            child: BundleOptionsView(
              options: widget.productData?.bundleOptions,
              callBack: (data) {
                bundleParams = data;
                selectList = bundleParams;
                widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    widget.qty,
                    widget.configurableProductId);
              },
            ),
          ),
      ],
    );
  }

  String? getConfigurablePrice() {
    for (int i = 0;
        i <= (widget.productData?.configurableData?.variantPrices?.length ?? 0);
        i++) {
      if (widget.configurableProductId ==
          widget.productData?.configurableData?.variantPrices?[i].id) {
        setState(() {
          widget.price = widget.productData?.configurableData?.variantPrices?[i]
              .regularPrice?.formattedPrice;
        });
      } else {}
    }
    return widget.price;
  }
}
