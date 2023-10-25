import 'package:bagisto_app_demo/screens/product_screen/view/product_screen_index.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/widget/product_type_view.dart';
import '../../../../configuration/app_global_data.dart';
import 'about_product_view.dart';
import 'package:collection/collection.dart';
class ProductView extends StatefulWidget {
  final Product productData;
  final bool isLoading;
  final ProductScreenBLoc? productScreenBLoc;
  int? productId;
  bool isLoggedIn = false;
  dynamic configurableProductId;
  String? price;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final scrollController;
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
   productFlats = widget.productData.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          widget.productScreenBLoc?.add(FetchProductEvent(widget.productId));
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
                        widget.productData.images?.map((e) => e.url ?? "").toList() ??
                            [],
                    callBack: (type) {
                      ProductScreenBLoc productScreenBLoc =
                          context.read<ProductScreenBLoc>();
                      if (type == compare) {
                        if (widget.isLoggedIn == true) {
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: true));
                          productScreenBLoc.add(AddToCompareListEvent(
                              productFlats.id ?? "", ""));
                        } else {
                          ShowMessage.showNotification(
                              "pleaseLogin".localized(),
                              "",
                              Colors.yellow,
                              const Icon(Icons.warning_amber));
                        }
                      } else if (type == wishlist) {
                        if (widget.isLoggedIn == true) {
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: true));
                          if (widget.productData != null) {
                            if (widget.productData.isInWishlist ?? false) {
                              productScreenBLoc.add(RemoveFromWishlistEvent(
                                  int.parse(widget.productData.id ?? ""),
                                  widget.productData));
                              productScreenBLoc.add(OnClickProductLoaderEvent(
                                  isReqToShowLoader: true));
                            } else {
                              productScreenBLoc.add(AddtoWishListProductEvent(
                                  widget.productData.id ?? "", widget.productData));
                              productScreenBLoc.add(OnClickProductLoaderEvent(
                                  isReqToShowLoader: true));
                            }
                          }
                        } else {
                          ShowMessage.showNotification(
                              "pleaseLogin".localized(),
                              "",
                              Colors.yellow,
                              const Icon(Icons.warning_amber));
                          productScreenBLoc.add(OnClickProductLoaderEvent(
                              isReqToShowLoader: false));
                        }
                      }
                    },
                    productData: widget.productData,
                    product: productFlats,
                  ),
                  CommonWidgets().getTextFieldHeight(NormalHeight),
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
                  CommonWidgets().getTextFieldHeight(MinHeight),
                  AboutProductView(
                    productData: widget.productData,
                    isLoggedIn: widget.isLoggedIn,
                  ),
                  if ((widget.productData.reviews?.length ?? 0) > 0)
                    Card(
                      child: ExpansionTile(
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        title: Text(
                          "Reviews".localized(),
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                        initiallyExpanded: true,
                        children: [
                          SizedBox(
                            // height:100,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.productData.reviews?.length,
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
                                          widget.productData.reviews?[index].title ??
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
                                                                .reviews?[index]
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
                                                .reviews?[index].comment ??
                                            ""),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4),
                                        child: Text("ReviewBy".localized() +
                                            " ${widget.productData.reviews?[index].customerName ?? ""}" +
                                            " ," +
                                            " ${widget.productData.reviews?[index].createdAt ?? ""}"),
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
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  child:
                      CircularProgressIndicatorClass.circularProgressIndicator(
                          context)),
            )
        ],
      ),
    );
  }
}
