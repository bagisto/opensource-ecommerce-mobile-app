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
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:bagisto_app_demo/widgets/wishlist_compare_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../../widgets/image_view.dart';
import '../../../../widgets/show_message.dart';
import 'package:collection/collection.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/status_color_helper.dart';
import '../../home_page/data_model/new_product_data.dart';
import '../../home_page/utils/route_argument_helper.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_event.dart';

//ignore: must_be_immutable
class SubCategoriesList extends StatelessWidget {
  bool? isLogin;
  NewProducts? data;
  CategoryBloc? subCategoryBloc;

  SubCategoriesList(
      {Key? key, this.isLogin, required this.data, this.subCategoryBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productFlats = data?.productFlats
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, productScreen,
            arguments: PassProductData(
                title: productFlats?.name ?? data?.productFlats?.firstOrNull?.name ?? "",
                urlKey: data?.urlKey,
                productId: int.parse(data?.id ?? "")));
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingNormal),
        child: Card(
          elevation: AppSizes.spacingSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.spacingNormal),
          ),
          child: FittedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.spacingNormal),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.spacingNormal)),
                    ),
                    child: Stack(
                      children: [
                        (data?.images ?? []).isNotEmpty
                            ? ImageView(
                                url: data?.images?.firstOrNull?.url ?? "",
                                width: MediaQuery.of(context).size.width / 3,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.cover,
                              )
                            : ImageView(
                                url: "",
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                        (data?.isInSale ?? false)
                            ? Positioned(
                                left: AppSizes.spacingNormal,
                                top: AppSizes.spacingNormal,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
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
                                        style: const TextStyle(
                                            color: Colors.white),
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.spacingLarge),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: AppSizes.spacingWide * 8,
                              child: Text(
                                  productFlats?.name ??
                                      data?.productFlats?.firstOrNull?.name ??
                                      "",
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                          const SizedBox(height: AppSizes.spacingNormal),
                          PriceWidgetHtml(priceHtml: data?.priceHtml?.priceHtml ?? ""),
                          const SizedBox(height: AppSizes.spacingNormal),
                          if ((data?.reviews ?? []).isNotEmpty &&
                              data?.reviews != null)
                            Row(
                              children: [
                                Row(
                                    children: List.generate(
                                        5,
                                        (index) => (index >=
                                                num.parse(data?.reviews
                                                        ?.firstOrNull?.rating
                                                        .toString() ??
                                                    ""))
                                            ? Icon(
                                                Icons.star_border,
                                                color:
                                                    ReviewColorHelper.getColor(
                                                        double.parse(data
                                                                ?.reviews
                                                                ?.firstOrNull
                                                                ?.rating
                                                                .toString() ??
                                                            "")),
                                                size: AppSizes.spacingLarge,
                                              )
                                            : Icon(
                                                Icons.star,
                                                color:
                                                    ReviewColorHelper.getColor(
                                                        double.parse(data
                                                                ?.reviews
                                                                ?.firstOrNull
                                                                ?.rating
                                                                .toString() ??
                                                            "")),
                                                size: AppSizes.spacingLarge,
                                              ))),
                              ],
                            ),
                          const SizedBox(height:AppSizes.spacingNormal),
                          CommonWidgets().appButton(
                              context, StringConstants.addToCart.localized(),
                              AppSizes.buttonWidth, () {
                            subCategoryBloc?.add(
                                OnClickSubCategoriesLoaderEvent(
                                    isReqToShowLoader: true));
                            if (data?.type == StringConstants.simple || data?.type == StringConstants.virtual) {
                              CategoryBloc subCategories =
                                  context.read<CategoryBloc>();

                              var dict = <String, dynamic>{};
                              dict['product_id'] = data?.id ?? '';
                              dict['quantity'] = 1;
                              subCategories.add(AddToCartSubCategoriesEvent(
                                  (data?.id ?? ""), 1, ""));
                            } else {
                              ShowMessage.warningNotification(
                                  StringConstants.addOptions.localized(), context,
                                  title: "");
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: false));
                            }
                          })
                        ],
                      ),
                      Positioned(
                          right: 0,
                          top: AppSizes.spacingSmall,
                          child: InkWell(
                            onTap: () {
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: true));
                              if (isLogin ?? false) {
                                if (data?.isInWishlist ?? false) {
                                  subCategoryBloc?.add(FetchDeleteItemEvent(
                                      data?.id ?? "", data));
                                } else {
                                  subCategoryBloc?.add(
                                      FetchDeleteAddItemCategoryEvent(
                                          data?.id, data!));
                                }
                              } else {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseLogin.localized(), context,
                                    title: "");
                                subCategoryBloc?.add(
                                    OnClickSubCategoriesLoaderEvent(
                                        isReqToShowLoader: false));
                              }
                            },
                            child: wishlistIcon(context, data?.isInWishlist),
                          )),
                      Positioned(
                        right: 0,
                        top: AppSizes.spacingWide * 2,
                        child: InkWell(
                          onTap: () {
                            if (isLogin == true) {
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: true));
                              subCategoryBloc?.add(AddToCompareSubCategoryEvent(
                                  data?.id ?? "",
                                  ""));
                            } else {
                              ShowMessage.warningNotification(StringConstants.pleaseLogin.localized(), context, title: "");
                            }
                          },
                          child: compareIcon(context),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
