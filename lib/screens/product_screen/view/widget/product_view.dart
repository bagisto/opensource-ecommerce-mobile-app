/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

//ignore: must_be_immutable
class ProductView extends StatefulWidget {
  final BookingSlotsData? bookingSlotsData;
  final NewProducts? productData;
  final bool isLoading;
  final ProductScreenBLoc? productScreenBLoc;
  int? productId;
  bool isLoggedIn = false;
  dynamic configurableProductId;
  String? price;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final ScrollController? scrollController;
  Function(
    List configurableParams,
    List bundleParams,
    List selectList,
    List selectParam,
    List groupedParams,
    List downloadLinks,
    int qty,
    dynamic configurableProductId,
    Map<String, dynamic> bookingParams,
    Map<String, dynamic> customizableOptionsSelection, // <-- add this
  )? callback;

  ProductView(
      {super.key,
      required this.productData,
      required this.isLoading,
      this.productScreenBLoc,
      required this.isLoggedIn,
      this.price,
      required this.scaffoldMessengerKey,
      this.configurableProductId,
      this.productId,
      this.callback,
      this.scrollController,
      required this.bookingSlotsData});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int qty = 1;
  List downloadLinks = [];
  List groupedParams = [];
  List bundleParams = [];
  List configurableParams = [];
  List selectList = [];
  List selectParam = [];
  Map<String, dynamic> bookingParams = {};
  Map<String, dynamic> customizableOptionsSelection = {}; // <-- add this
  dynamic productFlats;
  callback() {
    return widget.callback!(
        configurableParams,
        bundleParams,
        selectList,
        selectParam,
        groupedParams,
        downloadLinks,
        qty,
        widget.configurableProductId,
        bookingParams,
        customizableOptionsSelection // <-- add here
    );
  }

  @override
  void initState() {
    productFlats = widget.productData?.productFlats
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          widget.productScreenBLoc
              ?.add(FetchProductEvent(widget.productData?.urlKey ?? ""));
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageView(
                    imgList: widget.productData?.images
                            ?.map((e) => e.url ?? "")
                            .toList() ??
                        [],
                    callBack: (type) {
                      ProductScreenBLoc productScreenBLoc =
                          context.read<ProductScreenBLoc>();
                      if (type == StringConstants.compare) {
                        if (widget.isLoggedIn == true) {
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: true));
                          productScreenBLoc.add(AddToCompareListEvent(
                              widget.productData?.id ?? "", ""));
                        } else {
                          ShowMessage.warningNotification(
                              StringConstants.pleaseLogin.localized(), context);
                        }
                      } else if (type == StringConstants.wishlist) {
                        if (widget.isLoggedIn == true) {
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: true));
                          if (widget.productData?.isInWishlist ?? false) {
                            productScreenBLoc.add(RemoveFromWishlistEvent(
                                widget.productData?.id ?? "",
                                widget.productData));
                            productScreenBLoc.add(OnClickProductLoaderEvent(
                                isReqToShowLoader: true));
                          } else {
                            productScreenBLoc.add(AddToWishListProductEvent(
                                widget.productData?.id ?? "",
                                widget.productData));
                            productScreenBLoc.add(OnClickProductLoaderEvent(
                                isReqToShowLoader: true));
                          }
                        } else {
                          ShowMessage.warningNotification(
                              StringConstants.pleaseLogin.localized(), context);
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: false));
                        }
                      }
                    },
                    productData: widget.productData,
                    product:
                        productFlats ?? widget.productData?.productFlats?[0],
                  ),
                  CommonWidgets().getHeightSpace(AppSizes.spacingSmall),
                  ProductTypeView(
                    bookingSlotsData: widget.bookingSlotsData,
                    productScreenBLoc: widget.productScreenBLoc,
                    scaffoldMessengerKey: widget.scaffoldMessengerKey,
                    callback: (configurableParams,
                        bundleParams,
                        selectList,
                        selectParam,
                        groupedParams,
                        downloadLinks,
                        qty,
                        configurableProductId,
                        bookingParams,
                        customizableOptionsSelection
                        ) {
                      this.configurableParams = configurableParams;
                      this.bundleParams = bundleParams;
                      this.selectList = selectList;
                      this.selectParam = selectParam;
                      this.groupedParams = groupedParams;
                      this.downloadLinks = downloadLinks;
                      this.qty = qty;
                      this.bookingParams = bookingParams;
                      widget.configurableProductId = configurableProductId;
                      this.customizableOptionsSelection = customizableOptionsSelection;
                      callback();
                      setState(() {

                      });
                    },
                    qty: qty,
                    isLoggedIn: widget.isLoggedIn,
                    price: widget.price,
                    productData: widget.productData,
                    scrollController: widget.scrollController,
                    configurableProductId: widget.configurableProductId,
                  ),
                  CommonWidgets().getHeightSpace(10),
                  AboutProductView(
                    productData: widget.productData,
                    isLoggedIn: widget.isLoggedIn,
                  ),
                  if ((widget.productData?.reviews?.length ?? 0) > 0)
                    Card(
                      child: ExpansionTile(
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        title: Text(
                          StringConstants.reviews.localized(),
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.spacingLarge),
                        ),
                        initiallyExpanded: true,
                        children: [
                          SizedBox(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    widget.productData?.reviews?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4),
                                        child: Text(
                                          widget.productData?.reviews?[index]
                                                  .title ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: AppSizes.spacingMedium),
                                        child: RatingBar(
                                          starCount: 5,
                                          isCenter: false,
                                          size: AppSizes.spacingLarge,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          rating: num.tryParse(widget
                                                          .productData
                                                          ?.reviews?[index]
                                                          .rating
                                                          .toString() ??
                                                      '0.0')
                                                  ?.toDouble() ??
                                              0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSizes.spacingLarge,
                                            vertical: AppSizes.spacingSmall),
                                        child: Text(widget.productData
                                                ?.reviews?[index].comment ??
                                            ""),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4),
                                        child: Text(
                                            "${StringConstants.reviewBy.localized()} ${widget.productData?.reviews?[index].customerName ?? ""} , ${widget.productData?.reviews?[index].createdAt ?? ""}"),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.isLoading)
            const Align(
              alignment: Alignment.center,
              child: SizedBox(child: Loader()),
            )
        ],
      ),
    );
  }
}
