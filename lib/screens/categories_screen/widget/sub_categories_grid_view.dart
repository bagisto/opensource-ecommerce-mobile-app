// ignore_for_file: must_be_immutable

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/mobikul_theme.dart';
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:bagisto_app_demo/widgets/wishlist_compare_widget.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/app_constants.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../../widgets/image_view.dart';
import '../../../../widgets/show_message.dart';
import 'package:collection/collection.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/status_color_helper.dart';
import '../../../utils/string_constants.dart';
import '../../home_page/data_model/new_product_data.dart';
import '../../home_page/utils/route_argument_helper.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_event.dart';

class SubCategoriesGridView extends StatelessWidget {
  bool? isLogin;
  NewProducts? data;
  CategoryBloc? subCategoryBloc;

  SubCategoriesGridView(
      {this.isLogin, this.data, this.subCategoryBloc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productFlats = data?.productFlats
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, productScreen,
            arguments: PassProductData(
              title: productFlats?.name ?? data?.productFlats?.firstOrNull?.name ?? "",
              urlKey: data?.urlKey,
              productId: int.parse(data?.id ?? ""),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: AppSizes.spacingNormal),
        child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacingNormal),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Stack(
                    children: [
                      (data?.images ?? []).isNotEmpty
                          ? Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.spacingNormal)),
                              margin: const EdgeInsets.fromLTRB(
                                  AppSizes.spacingNormal,
                                  AppSizes.spacingNormal,
                                  AppSizes.spacingNormal,
                                  0),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ImageView(
                                url: data?.images?.firstOrNull?.url ?? "",
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                              ),
                            )
                          : ImageView(
                              url: "",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4.5,
                            ),
                      (data?.isInSale ?? false)
                          ? Positioned(
                              left: AppSizes.spacingNormal,
                              top: AppSizes.spacingNormal,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MobikulTheme.saleRedColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppSizes.spacingLarge))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppSizes.spacingMedium,
                                        right: AppSizes.spacingMedium,
                                        top: AppSizes.spacingSmall,
                                        bottom: AppSizes.spacingSmall),
                                    child: Text(
                                      StringConstants.sale.localized(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              ))
                          : (data?.productFlats?.firstOrNull?.isNew ?? true)
                              ? Positioned(
                                  left: AppSizes.spacingSmall,
                                  top: AppSizes.spacingSmall,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppSizes.spacingLarge))),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: AppSizes.spacingNormal,
                                            right: AppSizes.spacingNormal,
                                            top: AppSizes.spacingSmall / 2,
                                            bottom: AppSizes.spacingSmall),
                                        child: Text(
                                          StringConstants.statusNew.localized(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                  ))
                              : Container(
                                  color: Colors.transparent,
                                ),
                    ],
                  ),
                  Positioned(
                      right: AppSizes.spacingMedium,
                      top: AppSizes.spacingMedium,
                      child: InkWell(
                        onTap: () {
                          subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                              isReqToShowLoader: true));
                          if (isLogin ?? false) {
                            if (data?.isInWishlist ?? false) {
                              subCategoryBloc?.add(FetchDeleteItemEvent(
                                  data?.id ?? "", data));
                            } else {
                              subCategoryBloc?.add(
                                  FetchDeleteAddItemCategoryEvent(
                                      data?.id, data));
                            }
                          } else {
                            ShowMessage.warningNotification(
                                StringConstants.pleaseLogin.localized(), context);
                            subCategoryBloc?.add(
                                OnClickSubCategoriesLoaderEvent(
                                    isReqToShowLoader: false));
                          }
                        },
                        child: wishlistIcon(context, data?.isInWishlist)
                      )),
                  Positioned(
                    right: AppSizes.spacingMedium,
                    top: AppSizes.buttonHeight,
                    child: InkWell(
                      onTap: () {
                        if (isLogin == true) {
                          subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                              isReqToShowLoader: true));
                          subCategoryBloc?.add(AddToCompareSubCategoryEvent(
                              data?.id ?? "", ""));
                        } else {
                          ShowMessage.warningNotification(
                              StringConstants.pleaseLogin.localized(), context);
                        }
                      },
                      child: compareIcon(context)
                    ),
                  )
                ]),
                const SizedBox(
                  height: AppSizes.size4,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spacingWide/2, left: AppSizes.spacingWide/2, right: AppSizes.spacingWide/2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          productFlats?.name ??
                              data?.productFlats?.firstOrNull?.name ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spacingWide/2, left: AppSizes.spacingWide/2, right: AppSizes.spacingWide/2),
                  child: PriceWidgetHtml(priceHtml: data?.priceHtml?.priceHtml ?? ""),
                ),
                ((data?.reviews ?? []).isNotEmpty && data?.reviews != null)
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: AppSizes.spacingSmall,
                          left: AppSizes.spacingWide/2,
                          right: AppSizes.spacingWide/2,
                        ),
                        child: Row(
                          children: [
                            Row(
                                children: List.generate(
                                    5,
                                    (i) => (i >=
                                            num.parse(data?.reviews?.firstOrNull
                                                    ?.rating
                                                    .toString() ??
                                                ""))
                                        ? Icon(
                                            Icons.star_border,
                                            color: ReviewColorHelper.getColor(
                                                double.parse(data?.reviews
                                                        ?.firstOrNull?.rating
                                                        .toString() ??
                                                    "")),
                                            size: AppSizes.spacingLarge,
                                          )
                                        : Icon(
                                            Icons.star,
                                            color: ReviewColorHelper.getColor(
                                                double.parse(data?.reviews
                                                        ?.firstOrNull?.rating
                                                        .toString() ??
                                                    "")),
                                            size: AppSizes.spacingLarge,
                                          ))),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: AppSizes.spacingWide,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CommonWidgets().appButton(
                      context,
                      StringConstants.addToCart.localized(),
                      MediaQuery.of(context).size.width, () {
                      subCategoryBloc?.add(
                        OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
                    if (data?.type == StringConstants.simple || data?.type == StringConstants.virtual) {
                      var dict = <String, dynamic>{};
                      dict['product_id'] = data?.id ?? '';
                      dict['quantity'] = 1;
                      subCategoryBloc?.add(
                          AddToCartSubCategoriesEvent((data?.id ?? ""), 1, ""));
                    } else {
                      ShowMessage.warningNotification(StringConstants.addOptions.localized(), context);
                      subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                          isReqToShowLoader: false));
                    }
                  }),
                )
              ],
            )),
      ),
    );
  }
}
