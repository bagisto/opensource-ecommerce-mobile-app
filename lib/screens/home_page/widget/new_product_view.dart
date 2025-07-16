/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:bagisto_app_demo/widgets/wishlist_compare_widget.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../utils/prefetching_helper.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/image_view.dart';
import '../../../widgets/show_message.dart';
import '../bloc/home_page_bloc.dart';
import '../bloc/home_page_event.dart';
import '../data_model/new_product_data.dart';
import '../utils/home_page_event.dart';
import '../utils/route_argument_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import 'view_all_button.dart';

class NewProductView extends StatefulWidget {
  final List<NewProducts>? model;
  final String title;
  final bool? isLogin;
  final bool isRecentProduct;
  final bool callPreCache;
  final List<Map<String, dynamic>>? filters;

  const NewProductView(
      {super.key,
      this.model,
      required this.title,
      this.isLogin,
      this.isRecentProduct = false,
      this.callPreCache = false,
      this.filters});

  @override
  State<NewProductView> createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView> {
  HomePageBloc? homepageBloc;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    homepageBloc = context.read<HomePageBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.all(AppSizes.spacingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (!widget.isRecentProduct)
                viewAllButton(context, callback: () {
                  Navigator.pushNamed(context, categoryScreen,
                      arguments: CategoriesArguments(
                          metaDescription: "",
                          categorySlug: "",
                          title: widget.title,
                          id: "",
                          image: "",
                          filters: widget.filters));
                })
            ],
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: _controller,
                itemCount: widget.model?.length ?? 0,
                itemBuilder: (context, index) {
                  NewProducts? val = widget.model?[index];

                  if (widget.callPreCache) {
                    // preCacheProductDetails(val?.urlKey ?? "");
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, productScreen,
                          arguments: PassProductData(
                              title: val?.name ?? "",
                              urlKey: val?.urlKey,
                              productId: int.parse(val?.id ?? "")));
                    },
                    child: SizedBox(
                      width: AppSizes.screenWidth / 1.8,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.only(
                            right: AppSizes.spacingNormal,
                            bottom: AppSizes.spacingSmall),
                        elevation: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                (val?.url != null ||
                                        ((val?.images?.length ?? 0) > 0 &&
                                            (val?.images ?? []).isNotEmpty))
                                    ? ImageView(
                                        url: val?.images?[0].url ??
                                            val?.url ??
                                            "",
                                        height: AppSizes.screenHeight * 0.25,
                                        width: AppSizes.screenWidth,
                                        fit: BoxFit.fill,
                                      )
                                    : ImageView(
                                        url: "",
                                        height: AppSizes.screenHeight * 0.25,
                                        width: AppSizes.screenWidth,
                                        fit: BoxFit.fill,
                                      ),
                                (val?.isInSale ?? false)
                                    ? Positioned(
                                        left: AppSizes.spacingSmall,
                                        top: AppSizes.spacingSmall,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: AppSizes
                                                          .spacingMedium,
                                                      vertical: AppSizes
                                                          .spacingSmall),
                                              child: Text(
                                                StringConstants.sale
                                                    .localized(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ))
                                    : ((val?.productFlats?[0].isNew ?? true) ||
                                            (val?.isNew ?? false))
                                        ? Positioned(
                                            left: AppSizes.spacingSmall,
                                            top: AppSizes.spacingSmall,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppSizes.spacingLarge)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: AppSizes
                                                            .spacingMedium,
                                                        vertical: AppSizes
                                                            .spacingSmall),
                                                child: Text(
                                                  StringConstants.statusNew
                                                      .localized(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.transparent,
                                          ),
                                if (widget.isRecentProduct == false)
                                  Positioned(
                                    right: AppSizes.spacingNormal,
                                    top: 10,
                                    child: InkWell(
                                        onTap: () {
                                          checkInternetConnection()
                                              .then((value) {
                                            if (value) {
                                              homepageBloc?.add(
                                                  OnClickLoaderEvent(
                                                      isReqToShowLoader: true));
                                              if (widget.isLogin ?? false) {
                                                if (val?.isInWishlist ??
                                                    false) {
                                                  homepageBloc?.add(
                                                    RemoveWishlistItemEvent(
                                                      val?.id ?? "",
                                                      val,
                                                    ),
                                                  );
                                                } else {
                                                  homepageBloc?.add(
                                                    FetchAddWishlistHomepageEvent(
                                                      val?.id ?? "",
                                                      val,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ShowMessage.warningNotification(
                                                    StringConstants.pleaseLogin
                                                        .localized(),
                                                    context);
                                                homepageBloc?.add(
                                                    OnClickLoaderEvent(
                                                        isReqToShowLoader:
                                                            false));
                                              }
                                            } else {
                                              ShowMessage.errorNotification(
                                                  StringConstants.internetIssue
                                                      .localized(),
                                                  context);
                                            }
                                          });
                                        },
                                        child: wishlistIcon(
                                            context, val?.isInWishlist)),
                                  ),
                                if (widget.isRecentProduct == false)
                                  Positioned(
                                    right: 8.0,
                                    top: 45,
                                    child: InkWell(
                                        onTap: () {
                                          checkInternetConnection()
                                              .then((value) {
                                            if (value) {
                                              if (widget.isLogin ?? false) {
                                                homepageBloc?.add(
                                                    OnClickLoaderEvent(
                                                        isReqToShowLoader:
                                                            true));
                                                homepageBloc?.add(
                                                  AddToCompareHomepageEvent(
                                                    val?.id ??
                                                        val?.productId ??
                                                        "",
                                                    "",
                                                  ),
                                                );
                                              } else {
                                                ShowMessage.warningNotification(
                                                    StringConstants.pleaseLogin
                                                        .localized(),
                                                    context);
                                              }
                                            } else {
                                              ShowMessage.errorNotification(
                                                  StringConstants.internetIssue
                                                      .localized(),
                                                  context);
                                            }
                                          });
                                        },
                                        child: compareIcon(context)),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppSizes.spacingNormal,
                                  ),
                                  child: SizedBox(
                                    width: AppSizes.screenWidth / 2,
                                    child: CommonWidgets().getDrawerTileText(
                                        val?.productFlats
                                                ?.firstWhereOrNull((element) =>
                                                    element.locale ==
                                                    GlobalData.locale)
                                                ?.name ??
                                            val?.name ??
                                            "",
                                        context),
                                  ),
                                ),
                              ],
                            ),
                            PriceWidgetHtml(
                                priceHtml: val?.priceHtml?.priceHtml ?? ""),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Opacity(
                                opacity: (val?.isSaleable ?? false) ? 1 : 0.3,
                                child: CommonWidgets().appButton(
                                    context,
                                    StringConstants.addToCart.localized(),
                                    MediaQuery.of(context).size.width,
                                    (val?.isSaleable ?? false)
                                        ? () {
                                            checkInternetConnection()
                                                .then((value) {
                                              if (value) {
                                                homepageBloc?.add(
                                                    OnClickLoaderEvent(
                                                        isReqToShowLoader:
                                                            true));
                                                if (((val?.priceHtml?.type) ==
                                                            StringConstants
                                                                .simple ||
                                                        val?.type ==
                                                            StringConstants
                                                                .simple ||
                                                        val?.type ==
                                                            StringConstants
                                                                .virtual) &&
                                                    ((val?.customizableOptions ??
                                                                [])
                                                            .length ==
                                                        0)) {
                                                  homepageEvent(
                                                      val,
                                                      HomePageAction.addToCart,
                                                      widget.isLogin,
                                                      homepageBloc,
                                                      context);
                                                } else {
                                                  ShowMessage
                                                      .warningNotification(
                                                          StringConstants
                                                              .addOptions
                                                              .localized(),
                                                          context);
                                                  homepageBloc?.add(
                                                      OnClickLoaderEvent(
                                                          isReqToShowLoader:
                                                              false));

                                                  Navigator.pushNamed(
                                                      context, productScreen,
                                                      arguments:
                                                          PassProductData(
                                                              title:
                                                                  val?.name ??
                                                                      "",
                                                              urlKey:
                                                                  val?.urlKey,
                                                              productId:
                                                                  int.parse(
                                                                      val?.id ??
                                                                          "")));
                                                }
                                              } else {
                                                ShowMessage.errorNotification(
                                                    StringConstants
                                                        .internetIssue
                                                        .localized(),
                                                    context);
                                              }
                                            });
                                          }
                                        : () {}),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
