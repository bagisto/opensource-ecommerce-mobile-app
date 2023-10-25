import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/image_view.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/string_constants.dart';
import '../../../models/compare_model/compare_product_model.dart';
import '../../../routes/route_constants.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/compare_screen_bloc.dart';
import '../event/addtocart_compare_event.dart';
import '../event/addtowishlist_compare_event.dart';
import '../event/compare_loader_event.dart';
import '../event/compare_remove_item_event.dart';

class CompareList extends StatelessWidget {
 final CompareProductsData  compareScreenModel;
 final CompareScreenBloc ? compareScreenBloc ;
   const CompareList({Key? key,this.compareScreenBloc,required this.compareScreenModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.height > 800
          ? MediaQuery.of(context).size.height / 2.2
          : MediaQuery.of(context).size.height / 2,
      width: (compareScreenModel.data?.length ?? 0) *
          MediaQuery.of(context).size.width /
          2.2,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: compareScreenModel.data?.length ?? 0,
          itemBuilder: (context, index) {
            int rating = (double.parse(compareScreenModel.data?[index]
                .productFlat?.product?.averageRating
                .toString() ??
                "")
                .toInt());
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProductPage,
                    arguments: PassProductData(
                        title: compareScreenModel
                            .data?[index].productFlat?.name ??
                            "",
                        productId: int.parse(compareScreenModel
                            .data?[index]
                            .productFlat
                            ?.product
                            ?.id ??
                            "")));
              },
              child: Container(
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
                      ((  compareScreenModel
                            .data?[index]
                            .productFlat
                            ?.product
                            ?.images ??[] ).isNotEmpty) ?
                        ImageView(
                          url: compareScreenModel
                              .data?[index]
                              .productFlat
                              ?.product
                              ?.images?[0]
                              .url ??
                              "",
                          width:
                          MediaQuery.of(context).size.width / 2.2,
                          height:
                          MediaQuery.of(context).size.height / 4,
                        ):ImageView(
                        url: "",
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                        Positioned(
                          right: 8.0,
                          top: 8.0,
                          child: InkWell(
                            onTap: () {

                              compareScreenBloc?.add(
                                  OnClickCompareLoaderEvent(
                                      isReqToShowLoader: true));
                              compareScreenBloc?.add(
                                  RemoveFromCompareListEvent(
                                      compareScreenModel.data?[index]
                                          .productFlatId ??
                                          "",
                                      ""));
                            },
                            child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0,
                                          1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: AppSizes.iconSize,
                                  color: Colors.grey[500],
                                )),
                          ),
                          // top: 10.0,
                          // right: 10.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.spacingNormal,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            compareScreenModel
                                .data?[index]
                                .productFlat
                                ?.product
                                ?.priceHtml
                                ?.regular ??
                                "",
                            style: const TextStyle(
                                fontSize: AppSizes.normalFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (compareScreenModel
                                  .data![index]
                                  .productFlat
                                  ?.product
                                  ?.isInWishlist ??
                                  false) {
                                compareScreenBloc?.add(
                                    FetchDeleteWishlistItemEvent(
                                        int.parse(compareScreenModel
                                            .data![index]
                                            .productFlat
                                            ?.product
                                            ?.id ??
                                            ""),
                                        compareScreenModel
                                            .data?[index]));
                                compareScreenBloc?.add(
                                    OnClickCompareLoaderEvent(
                                        isReqToShowLoader: true));
                              } else {
                                compareScreenBloc?.add(
                                    AddtoWishlistCompareEvent(
                                        compareScreenModel
                                            .data![index]
                                            .productFlat
                                            ?.product
                                            ?.id,
                                        compareScreenModel
                                            .data?[index]));
                                compareScreenBloc?.add(
                                    OnClickCompareLoaderEvent(
                                        isReqToShowLoader: true));
                              }
                            },
                            child: (compareScreenModel
                                .data?[index]
                                .productFlat
                                ?.product
                                ?.isInWishlist ??
                                false)
                                ?  Icon(
                              Icons.favorite,
                              color:Theme.of(context).colorScheme.onPrimary,
                            )
                                : const Icon(
                              Icons.favorite_outline_rounded,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          compareScreenModel
                              .data?[index].productFlat?.name ??
                              "",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: AppSizes.normalFontSize),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(8.0, 8, 0, 0),
                      child: Container(
                        padding:
                        const EdgeInsets.fromLTRB(8, 2, 8, 2),
                        color: MobikulTheme().getColor(double.parse(
                            compareScreenModel
                                .data?[index]
                                .productFlat
                                ?.product
                                ?.averageRating
                                .toString() ??
                                "")),
                        child: Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.normalFontSize),
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
                    ) ,
                    Container(
                      key: index == 0 ? key : null,
                      child:   Padding(
                        padding: const EdgeInsets.all(8),
                        child: CommonWidgets().appButton(
                          context,
                          "AddToCart".localized(),
                          MediaQuery.of(context).size.width/2.5,  () {
                          debugPrint(compareScreenModel.data?[index]
                              .productFlat?.product?.type ??
                              "");
                          compareScreenBloc?.add(
                              OnClickCompareLoaderEvent(
                                  isReqToShowLoader: true));
                          if (compareScreenModel.data?[index]
                              .productFlat?.product?.type ==
                              simple) {
                            compareScreenBloc?.add(
                                AddToCartCompareEvent(
                                    (compareScreenModel
                                        .data?[index]
                                        .productFlat
                                        ?.product
                                        ?.id ??
                                        ""),
                                    1,
                                    ""));
                          } else {
                            ShowMessage.showNotification("addOptions".localized(),"", Colors.yellow,const Icon(Icons.warning_amber));
                            compareScreenBloc?.add(
                                OnClickCompareLoaderEvent(
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
