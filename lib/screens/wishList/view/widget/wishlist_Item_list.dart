/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/wishList/utils/index.dart';

import '../../../product_screen/view/quantity_view.dart';

class WishlistItemList extends StatefulWidget {
 final WishListData? model;
 final bool isLoading;
 final WishListBloc? wishListBloc;

  const WishlistItemList(
      {Key? key,
      required this.model,
      required this.isLoading,
      this.wishListBloc})
      : super(key: key);

  @override
  State<WishlistItemList> createState() => _WishlistItemListState();
}

class _WishlistItemListState extends State<WishlistItemList> {
 Map<String, String> quantityMap = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: widget.model?.data?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: (MediaQuery.of(context).size.height / 3) + 170,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            WishlistData? item = widget.model?.data?[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  productScreen,
                  arguments: PassProductData(
                    title: item?.product?.name ?? "",
                    urlKey: item?.product?.urlKey,
                    productId: int.parse(item?.product?.id ?? ""),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.all(4),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: [
                            ImageView(
                              url: (item?.product?.images ?? []).isNotEmpty
                                  ? item?.product?.images![0].url ?? ""
                                  : "",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 5,
                            ),
                            Positioned(
                              top: 0,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  widget.wishListBloc?.add(
                                      OnClickWishListLoaderEvent(isReqToShowLoader: true));
                                  widget.wishListBloc?.add(
                                      FetchDeleteAddItemEvent(item?.productId));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.close, color: Colors.grey[500]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppSizes.spacingWide, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  item?.product?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        PriceWidgetHtml(
                            priceHtml: item?.product?.priceHtml?.priceHtml ?? ""),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: QuantityView(
                            qty: quantityMap["${item?.product?.id}"] ?? "1",
                            callBack: (qty) {
                              quantityMap["${item?.product?.id}"] = qty.toString();
                            },
                            showTitle: false,
                          ),
                        ),
                        Opacity(
                          opacity: (item?.product?.isSaleable ?? false) ? 1 : 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CommonWidgets().appButton(
                              context,
                              StringConstants.addToCart.localized(),
                              MediaQuery.of(context).size.width,
                              (item?.product?.isSaleable ?? false)
                                  ? () {
                                if ((item?.product?.type == StringConstants.simple ||
                                    item?.product?.type == StringConstants.virtual)&& ((item?.product?.customizableOptions??[]).length ==0) ) {
                                  widget.wishListBloc?.add(
                                      OnClickWishListLoaderEvent(
                                          isReqToShowLoader: true));
                                  widget.wishListBloc?.add(AddToCartWishlistEvent(
                                      item?.id,
                                      quantityMap["${item?.product?.id}"] ?? "1"));
                                } else {
                                  ShowMessage.showNotification(
                                    StringConstants.warning.localized(),
                                    StringConstants.addOptions.localized(),
                                    Colors.yellow,
                                    const Icon(Icons.warning_amber),
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    productScreen,
                                    arguments: PassProductData(
                                      title: item?.product?.name ?? "",
                                      urlKey: item?.product?.urlKey,
                                      productId: int.parse(item?.product?.id ?? ""),
                                    ),
                                  );
                                }
                              }
                                  : () {},
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.isLoading)
          const Align(
            alignment: Alignment.center,
            child: SkeletonLoader(
              builder: Loader(),
            ),
          )
      ],
    );
  }
}
