import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:bagisto_app_demo/widgets/wishlist_compare_widget.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/check_internet_connection.dart';
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

class NewProductView extends StatefulWidget {
  final List<NewProducts>? model;
  final String title;
  final bool? isLogin;
  final bool isRecentProduct;

  const NewProductView(
      {Key? key, this.model, required this.title, this.isLogin, this.isRecentProduct = false})
      : super(key: key);

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
      margin: const EdgeInsets.symmetric(vertical: AppSizes.size8),
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(AppSizes.size8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.size12),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: _controller,
                itemCount: widget.model?.length ?? 0,
                itemBuilder: (context, index) {
                  NewProducts? val = widget.model?[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, productScreen,
                          arguments: PassProductData(
                              title: widget.model?[index].name ?? "",
                              urlKey: widget.model?[index].urlKey,
                              productId:
                                  int.parse(widget.model?[index].id ?? "")));
                    },
                    child: SizedBox(
                      width: AppSizes.screenWidth / 1.8,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                (widget.model?[index].url != null ||
                                        ((widget.model?[index].images
                                                        ?.length ??
                                                    0) >
                                                0 &&
                                            (widget.model?[index].images ??
                                                    [])
                                                .isNotEmpty))
                                    ? ImageView(
                                        url: widget.model?[index].images?[0]
                                                .url ??
                                            widget.model?[index].url ??
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
                                (widget.model?[index].isInSale ?? false)
                                    ? Positioned(
                                        left: AppSizes.spacingNormal,
                                        top: AppSizes.spacingNormal,
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
                                                StringConstants.sale.localized(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ))
                                    : ((widget.model?[index].productFlats?[0]
                                                    .isNew ??
                                                true) ||
                                            (widget.model?[index].isNew ??
                                                false))
                                        ? Positioned(
                                            left: AppSizes.spacingSmall,
                                            top: AppSizes.spacingSmall,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius
                                                    .all(Radius.circular(
                                                        AppSizes
                                                            .spacingLarge)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                  left:
                                                      AppSizes.spacingNormal,
                                                  right:
                                                      AppSizes.spacingNormal,
                                                  top: AppSizes.spacingSmall /
                                                      2,
                                                  bottom:
                                                      AppSizes.spacingSmall,
                                                ),
                                                child: Text(
                                                  StringConstants.statusNew.localized(),
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
                                if(widget.isRecentProduct == false) Positioned(
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
                                              if (widget.model?[index]
                                                      .isInWishlist ??
                                                  false) {
                                                homepageBloc?.add(
                                                  RemoveWishlistItemEvent(
                                                    widget.model?[index].id ??
                                                        "",
                                                    widget.model?[index],
                                                  ),
                                                );
                                              } else {
                                                homepageBloc?.add(
                                                  FetchAddWishlistHomepageEvent(
                                                    widget.model?[index].id ??
                                                        "",
                                                    widget.model?[index],
                                                  ),
                                                );
                                              }
                                            } else {
                                              ShowMessage.warningNotification(
                                                  StringConstants.pleaseLogin.localized(),
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
                                      child: wishlistIcon(context,
                                          widget.model?[index].isInWishlist)),
                                ),
                                if(widget.isRecentProduct == false) Positioned(
                                  right: 8.0,
                                  top: 45,
                                  child: InkWell(
                                      onTap: () {
                                        checkInternetConnection()
                                            .then((value) {
                                          if (value) {
                                            if (widget.isLogin ?? false){
                                              homepageBloc?.add(
                                                  OnClickLoaderEvent(
                                                      isReqToShowLoader: true));
                                              homepageBloc?.add(
                                                AddToCompareHomepageEvent(
                                                  widget.model?[index]
                                                      .id ??
                                                      widget.model?[index].productId ?? "",
                                                  "",
                                                ),
                                              );
                                            }
                                            else {
                                              ShowMessage.warningNotification(
                                                  StringConstants.pleaseLogin.localized(),
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
                                        widget.model?[index].productFlats
                                                ?.firstWhereOrNull((element) =>
                                                    element.locale ==
                                                    GlobalData.locale)
                                                ?.name ??
                                            widget.model?[index].name ??
                                            "",
                                        context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spacingLarge),
                            
                            PriceWidgetHtml(priceHtml: widget.isRecentProduct ? (val?.price ?? "") : val?.priceHtml?.priceHtml ?? ""),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: CommonWidgets().appButton(
                                  context,
                                  StringConstants.addToCart.localized(),
                                  MediaQuery.of(context).size.width, () {
                                checkInternetConnection().then((value) {
                                  if (value) {
                                    homepageBloc?.add(OnClickLoaderEvent(
                                        isReqToShowLoader: true));
                                    if ((widget.model?[index].priceHtml
                                                ?.type) ==
                                            StringConstants.simple ||
                                        widget.model?[index].type ==
                                            StringConstants.simple || widget.model?[index].type == StringConstants.virtual) {
                                      homepageEvent(
                                          widget.model?[index],
                                          HomePageAction.addToCart,
                                          widget.isLogin,
                                          homepageBloc,
                                          context);
                                    } else {
                                      ShowMessage.warningNotification(
                                          StringConstants.addOptions
                                              .localized(),context);
                                      homepageBloc?.add(OnClickLoaderEvent(
                                          isReqToShowLoader: false));
                                    }
                                  } else {
                                    ShowMessage.errorNotification(
                                        StringConstants.internetIssue
                                            .localized(),context);
                                  }
                                });
                              }),
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
