import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import '../../../../utils/status_color_helper.dart';
import '../../../../widgets/image_view.dart';
import '../../../home_page/utils/route_argument_helper.dart';
import '../../bloc/compare_screen_bloc.dart';
import '../../bloc/compare_screen_event.dart';
import '../../data_model/compare_product_model.dart';

class CompareList extends StatelessWidget {
  final   CompareProductsData compareScreenModel;
  final CompareScreenBloc? compareScreenBloc;

  const CompareList(
      {Key? key, this.compareScreenBloc, required this.compareScreenModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.7,
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
            int rating = (double.parse(compareScreenModel
                        .data?[index].product?.averageRating
                        .toString() ??
                    "")
                .toInt());
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productScreen,
                    arguments: PassProductData(
                        title:
                            compareScreenModel.data?[index].product?.name ??
                                "",
                        urlKey: compareScreenModel.data?[index].product?.urlKey ?? "",
                        productId: int.parse(compareScreenModel
                                .data?[index].product?.id ??
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
                        compareScreenModel.data?[index].product?.images?.isNotEmpty == true ?
                        ImageView(
                          url: compareScreenModel.data?[index].product?.images?[0].url ??
                              "",
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 4,
                        ) : ImageView(
                          url: "",
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Positioned(
                          right: 8.0,
                          top: 8.0,
                          child: InkWell(
                            onTap: () {
                              compareScreenBloc?.add(OnClickCompareLoaderEvent(
                                  isReqToShowLoader: true));
                              compareScreenBloc?.add(RemoveFromCompareListEvent(
                                  compareScreenModel
                                          .data?[index].productId ??
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
                                      Radius.circular(20)),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceWidgetHtml(priceHtml: compareScreenModel.data?[index].product?.priceHtml?.priceHtml ?? ""),
                          InkWell(
                              onTap: () {
                                if (compareScreenModel.data![index].product?.isInWishlist ??
                                    false) {
                                  compareScreenBloc?.add(
                                      FetchDeleteWishlistItemEvent(
                                          int.parse(compareScreenModel
                                                  .data![index].product
                                                  ?.id ??
                                              ""),
                                          compareScreenModel.data?[index]));
                                  compareScreenBloc?.add(
                                      OnClickCompareLoaderEvent(
                                          isReqToShowLoader: true));
                                } else {
                                  compareScreenBloc?.add(
                                      AddToWishlistCompareEvent(
                                          compareScreenModel.data![index].product?.id,
                                          compareScreenModel.data?[index]));
                                  compareScreenBloc?.add(
                                      OnClickCompareLoaderEvent(
                                          isReqToShowLoader: true));
                                }
                              },
                              child: (compareScreenModel.data?[index].product?.isInWishlist ??
                                      false)
                                  ? Icon(
                                      Icons.favorite,
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          compareScreenModel.data?[index].product?.name ??
                              "",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: AppSizes.spacingLarge),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 0),
                      child: Container(
                         width: 42,
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        color: ReviewColorHelper.getColor(double.parse(
                            compareScreenModel.data?[index].product
                                    ?.averageRating
                                    .toString() ??
                                "")),
                        child: Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      key: index == 0 ? key : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CommonWidgets().appButton(
                          context,
                          StringConstants.addToCart.localized(),
                          MediaQuery.of(context).size.width / 2.5,
                          () {
                            debugPrint(compareScreenModel
                                    .data?[index].product?.type ??
                                "");
                            compareScreenBloc?.add(OnClickCompareLoaderEvent(
                                isReqToShowLoader: true));
                            if (compareScreenModel
                                    .data?[index].product?.type == StringConstants.simple || compareScreenModel
                                .data?[index].product?.type == StringConstants.virtual) {
                              compareScreenBloc?.add(AddToCartCompareEvent(
                                  (compareScreenModel.data?[index].product?.id ??
                                      ""),
                                  1,
                                  ""));
                            } else {
                              ShowMessage.showNotification(
                                  StringConstants.addOptions.localized(),
                                  "",
                                  Colors.yellow,
                                  const Icon(Icons.warning_amber));
                              compareScreenBloc?.add(OnClickCompareLoaderEvent(
                                  isReqToShowLoader: false));
                            }
                          },
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
