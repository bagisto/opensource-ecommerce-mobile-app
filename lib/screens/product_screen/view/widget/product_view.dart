import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'about_product_view.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';



//ignore: must_be_immutable
class ProductView extends StatefulWidget {
  final NewProducts? productData;
  final bool isLoading;
  final ProductScreenBLoc? productScreenBLoc;
  int? productId;
  bool isLoggedIn = false;
  var configurableProductId;
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
      )? callback;

  ProductView(
      {Key? key,
      required this.productData,
      required this.isLoading,
      this.productScreenBLoc,
      required this.isLoggedIn,
      this.price,
      required this.scaffoldMessengerKey,
      this.configurableProductId,
      this.productId, this.callback,
      this.scrollController})
      : super(key: key);

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

  dynamic productFlats;
  callback(){
    return
      widget.callback!(
        configurableParams,
        bundleParams,
        selectList,
        selectParam,
        groupedParams,
        downloadLinks,
        qty,
        widget.configurableProductId,
      );
  }
  @override
  void initState() {
    productFlats = widget.productData?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          widget.productScreenBLoc?.add(FetchProductEvent(widget.productData?.urlKey ??""));
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
                    imgList:
                        widget.productData?.images?.map((e) => e.url ?? "").toList() ??
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
                              StringConstants.pleaseLogin.localized(),context);
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
                                widget.productData?.id ?? "", widget.productData));
                            productScreenBLoc.add(OnClickProductLoaderEvent(
                                isReqToShowLoader: true));
                          }
                        } else {
                          ShowMessage.warningNotification(
                              StringConstants.pleaseLogin.localized(),context);
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: false));
                        }
                      }
                    },
                    productData: widget.productData,
                    product: productFlats ?? widget.productData?.productFlats?[0],
                  ),
                  CommonWidgets().getHeightSpace(AppSizes.spacingSmall),
                  ProductTypeView(
                    scaffoldMessengerKey: widget.scaffoldMessengerKey,
                    callback: (configurableParams, bundleParams, selectList, selectParam, groupedParams, downloadLinks, qty,configurableProductId){
                        this.configurableParams=configurableParams;
                        this.bundleParams=bundleParams;
                        this.selectList=selectList;
                        this.selectParam=selectParam;
                        this.groupedParams=groupedParams;
                        this.downloadLinks=downloadLinks;
                        this.qty=qty;
                        widget.configurableProductId=configurableProductId;
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
                              fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
                        ),
                        initiallyExpanded: true,
                        children: [
                          SizedBox(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.productData?.reviews?.length ?? 0,
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
                                          widget.productData?.reviews?[index].title ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SizedBox(
                                          width: 120,
                                          child: RatingBar.builder(
                                            unratedColor: MobikulTheme
                                                .appBarBackgroundColor,
                                            itemSize: 16,
                                            initialRating: num.tryParse(
                                                        widget.productData
                                                                ?.reviews?[index]
                                                                .rating
                                                                .toString() ??
                                                            '0.0')
                                                    ?.toDouble() ??
                                                0.0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4),
                                        child: Text(widget.productData
                                                ?.reviews?[index].comment ??
                                            ""),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4),
                                        child: Text("${StringConstants.reviewBy.localized()} ${widget.productData?.reviews?[index].customerName ?? ""} , ${widget.productData?.reviews?[index].createdAt ?? ""}"),
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
              child: SizedBox(
                  child:
                      Loader()),
            )
        ],
      ),
    );
  }
}
