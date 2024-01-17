import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:bagisto_app_demo/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../../widgets/image_view.dart';
import '../../../../widgets/show_message.dart';
import '../../../home_page/utils/route_argument_helper.dart';
import '../../bloc/wishlist_bloc.dart';
import '../../bloc/fetch_wishlist_event.dart';
import '../../data_model/wishlist_model.dart';

// ignore: must_be_immutable
class WishlistItemList extends StatelessWidget {
  WishListData? model;
  bool isLoading;
  WishListBloc? wishListBloc;

  WishlistItemList(
      {Key? key,
      required this.model,
      required this.isLoading,
      this.wishListBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: model?.data?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: (MediaQuery.of(context).size.height / 3) + 160,
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productScreen,
                    arguments: PassProductData(
                        title: model?.data?[index].product?.name ?? "",
                        urlKey: model?.data?[index].product?.urlKey,
                        productId:
                            int.parse(model?.data?[index].product?.id ?? "")));
              },
              child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(children: [
                        ImageView(
                          url: (model?.data?[index].product?.images ?? []).isNotEmpty
                              ? model?.data![index].product?.images![0].url ?? ""
                              : "",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              wishListBloc?.add(OnClickWishListLoaderEvent(
                                  isReqToShowLoader: true));
                              wishListBloc?.add(FetchDeleteAddItemEvent(
                                  model?.data![index].productId));
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: AppSizes.spacingWide, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                model?.data?[index].product?.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      PriceWidgetHtml(priceHtml: model?.data?[index].product?.priceHtml?.priceHtml ?? ""),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CommonWidgets().appButton(
                            context,
                            StringConstants.addToCart.localized(),
                            MediaQuery.of(context).size.width, () {
                          if (model?.data?[index].product?.type ==
                              StringConstants.simple || model?.data?[index].product?.type == StringConstants.virtual) {
                            wishListBloc?.add(OnClickWishListLoaderEvent(
                                isReqToShowLoader: true));

                            wishListBloc?.add(AddToCartWishlistEvent(
                              model?.data![index].id,
                            ));
                          } else {
                            ShowMessage.showNotification(
                                StringConstants.warning.localized(),
                                StringConstants.addOptions.localized(),
                                Colors.yellow,
                                const Icon(Icons.warning_amber));
                          }
                        }),
                      )
                    ],
                  )),
            );
          },
        ),
        if (isLoading)
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
