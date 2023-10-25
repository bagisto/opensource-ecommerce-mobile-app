import 'package:bagisto_app_demo/screens/product_screen/view/product_screen_index.dart';

import '../../../../configuration/app_global_data.dart';
import '../group_product.dart';
import 'package:collection/collection.dart';
class ProductTypeView extends StatefulWidget {
  final Product? productData;
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
  var configurableProductId;



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
    var productFlats = widget.productData?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

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
                  CommonWidgets().getTextFieldHeight(8),
                  ((widget.productData?.priceHtml?.special ?? "").isEmpty ||
                      (( productFlats?.maxPrice ==
                          productFlats?.minPrice) &&
                          ( productFlats?.maxPrice !=
                              null)))
                      ? CommonWidgets().priceText(widget.price ??
                      widget.productData?.priceHtml?.regular ??
                      "")
                      : CommonWidgets().priceText(widget.price ??
                      widget.productData?.priceHtml?.special ??
                      ""),
                  ((widget.productData?.priceHtml?.special ?? "").isEmpty ||
                      ( productFlats?.maxPrice ==
                          productFlats?.minPrice) &&
                          productFlats?.maxPrice !=
                              null)
                      ? const Text("")
                      : Text(widget.productData?.priceHtml?.regular ?? "",
                      style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough)),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: MobikulTheme().getColor(double.tryParse(
                                widget.productData?.averageRating
                                    .toString() ??
                                    "0") ??
                                0),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: NormalPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.productData?.reviews?.isNotEmpty ?? true)
                              Text(
                                  (widget.productData?.reviews?[0].rating ?? 0)
                                      .toString(),
                                  style: const TextStyle(color: Colors.white)),
                            if (widget.productData?.reviews?.isNotEmpty ?? true)
                              CommonWidgets().getTextFieldWidth(NormalWidth),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                      CommonWidgets().getTextFieldWidth(HighWidth),
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
        if (widget.productData?.type != Grouped)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type != Grouped)
          Card(
            elevation: 2,
            child: StatefulBuilder(builder: (context, changeState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: QuantityView(
                  qty: widget.qty.toString(),
                  callBack: (qty) {
                    changeState(() {
                      this.widget.qty = qty;
                    });
                    widget.callback!(configurableParams,
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
        if (widget.productData?.type == Grouped)
          GroupProduct(
            groupedProducts: widget.productData?.groupedProducts,
            callBack: (qties) {
              groupedParams = qties;
              selectList = groupedParams;
              widget.callback!(configurableParams,
                bundleParams,
                selectList,
                selectParam,
                groupedParams,
                downloadLinks,
                widget.qty,
              widget.configurableProductId);            },
          ),
        if (widget.productData?.type == Downloadable)
          Column(
            children: [
              DownloadProductSample(
                samples: widget.productData?.downloadableSamples,
                scaffoldMessengerKey: widget.scaffoldMessengerKey,
              ),
              DownloadProductOptions(
                options: widget.productData?.downloadableLinks,
                callBack: (ids) {
                  downloadLinks = ids;
                  selectList =downloadLinks;
                  widget.callback!(configurableParams,
                     bundleParams,
                     selectList,
                     selectParam,
                     groupedParams,
                     downloadLinks,
                    widget.qty,widget.configurableProductId);
                },
              )
            ],
          ),
        if (widget.productData?.type == configurable)
          CustomOptionsView(
            productData: widget.productData,
            customOptions: widget.productData?.configutableData?.attributes,
            variants: widget.productData?.variants,
            callback: (data, id) {
             configurableParams = data;
              widget.configurableProductId = id;
             selectList =configurableParams;
             widget.callback!(configurableParams,
               bundleParams,
               selectList,
               selectParam,
               groupedParams,
               downloadLinks,
               widget.qty, widget.configurableProductId);
             getConfigurablePrice();
            },
          ),
        if (widget.productData?.type == Bundle)
          BundleOptionsView(
            options: widget.productData?.bundleOptions,
            callBack: (data) {
              bundleParams = data;
              selectList = bundleParams;
              widget.callback!(configurableParams,
                bundleParams,
                selectList,
                selectParam,
                groupedParams,
                downloadLinks,
                widget.qty,widget.configurableProductId);
            },
          ),
      ],
    );
  }

  String? getConfigurablePrice() {
    for (int i = 0;
        i <= (widget.productData?.configutableData?.variantPrices?.length ?? 0);
        i++) {
      if (widget.configurableProductId ==
          widget.productData?.configutableData?.variantPrices?[i].id) {
        setState(() {
          widget.price = widget.productData?.configutableData?.variantPrices?[i]
              .regularPrice?.formatedPrice;
        });
      } else {}
    }
    return widget.price;
  }
}
