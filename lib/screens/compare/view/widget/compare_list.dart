/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

class CompareList extends StatelessWidget {
  final CompareProductsData compareScreenModel;
  final CompareScreenBloc? compareScreenBloc;

  const CompareList(
      {Key? key, this.compareScreenBloc, required this.compareScreenModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6,
      width: (compareScreenModel.data?.length ?? 0) *
          MediaQuery.of(context).size.width /
          2.0,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: compareScreenModel.data?.length ?? 0,
          itemBuilder: (context, index) {
            int ? rating;
            if (compareScreenModel.data?[index].product?.averageRating != null) {
               rating = (double.parse(compareScreenModel
                          .data?[index].product?.averageRating
                          .toString() ??
                      "")
                  .toInt());
            }

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productScreen,
                    arguments: PassProductData(
                        title:
                            compareScreenModel.data?[index].product?.name ?? "",
                        urlKey:
                            compareScreenModel.data?[index].product?.urlKey ??
                                "",
                        productId: int.parse(
                            compareScreenModel.data?[index].product?.id ??
                                "")));
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        compareScreenModel
                                    .data?[index].product?.images?.isNotEmpty ==
                                true
                            ? ImageView(
                                url: compareScreenModel
                                        .data?[index].product?.images?[0].url ??
                                    "",
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 4,
                              )
                            : ImageView(
                                url: "",
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 4,
                              ),
                        Positioned(
                          right: AppSizes.spacingNormal,
                          top: AppSizes.spacingNormal,
                          child: InkWell(
                            onTap: () {
                              compareScreenBloc?.add(OnClickCompareLoaderEvent(
                                  isReqToShowLoader: true));
                              compareScreenBloc?.add(RemoveFromCompareListEvent(
                                  compareScreenModel.data?[index].productId ??
                                      "",
                                  ""));
                            },
                            child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppSizes.spacingWide)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.grey[500],
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.spacingNormal,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.spacingNormal),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceWidgetHtml(
                              priceHtml: compareScreenModel.data?[index].product
                                      ?.priceHtml?.priceHtml ??
                                  ""),
                          InkWell(
                              onTap: () {
                                if (compareScreenModel
                                        .data![index].product?.isInWishlist ??
                                    false) {
                                  compareScreenBloc?.add(
                                      FetchDeleteWishlistItemEvent(
                                          int.parse(compareScreenModel
                                                  .data![index].product?.id ??
                                              ""),
                                          compareScreenModel.data?[index]));
                                  compareScreenBloc?.add(
                                      OnClickCompareLoaderEvent(
                                          isReqToShowLoader: true));
                                } else {
                                  compareScreenBloc?.add(
                                      AddToWishlistCompareEvent(
                                          compareScreenModel
                                              .data![index].product?.id,
                                          compareScreenModel.data?[index]));
                                  compareScreenBloc?.add(
                                      OnClickCompareLoaderEvent(
                                          isReqToShowLoader: true));
                                }
                              },
                              child: (compareScreenModel
                                          .data?[index].product?.isInWishlist ??
                                      false)
                                  ? Icon(
                                      Icons.favorite,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.grey,
                                    )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.spacingNormal, 0, 0, 0),
                        child: Text(
                          compareScreenModel.data?[index].product?.name ?? "",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: AppSizes.spacingLarge),
                        ),
                      ),
                    ),
                    compareScreenModel
                        .data?[index].product?.averageRating != null ?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.spacingNormal, AppSizes.spacingNormal, 0, 0),
                      child: Container(
                        width: 60,
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.spacingNormal,
                            AppSizes.spacingSmall,
                            AppSizes.spacingNormal,
                            AppSizes.spacingSmall),
                        color: ReviewColorHelper.getColor(double.parse(
                            compareScreenModel
                                    .data?[index].product?.averageRating
                                    .toString() ??
                                "")),
                        child: Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(
                              width: AppSizes.spacingSmall,
                            ),
                            const Icon(
                              Icons.star,
                              size: AppSizes.spacingLarge,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ):Container(),
                    Opacity(
                      opacity: (compareScreenModel
                                  .data?[index].product?.isSaleable ??
                              false)
                          ? 1
                          : 0.4,
                      child: Container(
                        key: index == 0 ? key : null,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.spacingNormal),
                          child: CommonWidgets().appButton(
                            context,
                            StringConstants.addToCart.localized(),
                            MediaQuery.of(context).size.width / 2.5,
                            (compareScreenModel
                                        .data?[index].product?.isSaleable ??
                                    false)
                                ? () {
                                    compareScreenBloc?.add(
                                        OnClickCompareLoaderEvent(
                                            isReqToShowLoader: true));
                                    if ((compareScreenModel
                                                .data?[index].product?.type ==
                                            StringConstants.simple ||
                                        compareScreenModel
                                                .data?[index].product?.type ==
                                            StringConstants.virtual)&& ((compareScreenModel
                                        .data?[index].product?.customizableOptions??[]).length ==0)) {
                                      compareScreenBloc?.add(
                                          AddToCartCompareEvent(
                                              (compareScreenModel.data?[index]
                                                      .product?.id ??
                                                  ""),
                                              1,
                                              ""));
                                    } else {
                                      ShowMessage.showNotification(
                                          StringConstants.addOptions
                                              .localized(),
                                          "",
                                          Colors.yellow,
                                          const Icon(Icons.warning_amber));
                                      Navigator.pushNamed(context, productScreen,
                                          arguments: PassProductData(
                                              title:
                                              compareScreenModel.data?[index].product?.name ?? "",
                                              urlKey:
                                              compareScreenModel.data?[index].product?.urlKey ??
                                                  "",
                                              productId: int.parse(
                                                  compareScreenModel.data?[index].product?.id ??
                                                      "")));
                                      compareScreenBloc?.add(
                                          OnClickCompareLoaderEvent(
                                              isReqToShowLoader: false));
                                    }
                                  }
                                : () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
