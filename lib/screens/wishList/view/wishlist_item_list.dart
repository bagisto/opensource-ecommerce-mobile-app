// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/wishList/events/delete_item_event.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/image_view.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/string_constants.dart';
import '../../../models/wishlist_model/wishlist_model.dart';
import '../../../routes/route_constants.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/wishlist_bloc.dart';
import '../events/addToCartWishlistEvent.dart';
import '../events/wishlist_loader_event.dart';

class WishlistItemList extends StatelessWidget {
  WishListData  model;
  bool  isLoading;
  WishListBloc? wishListBloc;

  WishlistItemList({Key? key,required this.model,required this.isLoading,this.wishListBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: model.data?.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.68,
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, ProductPage,
                    arguments: PassProductData(
                        title: model.data![index].product?.name??"",
                        productId:int.parse(model.data![index].product?.id??"")));
              },
              child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                          children:[
                            (model.data![index].product?.images??[]).isNotEmpty  ? ImageView(
                              url: model.data![index].product?.images?[0].url ??
                                  "", width: MediaQuery
                                .of(context)
                                .size
                                .width ,
                              height: MediaQuery.of(context).size.height / 5,):ImageView(
                                url: "", width: MediaQuery
                                .of(context)
                                .size
                                .width ,
                                height: MediaQuery.of(context).size.height / 5),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: true));
                                  wishListBloc?.add(FetchDeleteAddItemEvent(
                                      model.data![index].productId));
                                },
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ),
                          ]
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: AppSizes.widgetHeight, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                model.data![index].product?.name??"",
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
                      Padding(
                        padding:
                        const EdgeInsets.only(top:  AppSizes.spacingTiny, left: 10, right: 10),
                        child: Text( model.data![index].product?.priceHtml?.regular??"3224",
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, left: 6, right: 6),
                        height: 30,
                        child: CommonWidgets().appButton(
                            context,
                            "AddToCart".localized(),
                            MediaQuery.of(context).size.width, () {
                          if (model.data![index].product!.type ==
                              simple){
                            wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: true));

                            wishListBloc?.add(AddToCartWishlistEvent(
                              model.data![index].id,));
                          }else {
                            ShowMessage.showNotification("addOptions".localized(),"", Colors.yellow,const Icon(Icons.warning_amber));
                          }
                        }),
                      ),
                    ],
                  )),
            );
          },
        ),
        if (isLoading)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicatorClass.circularProgressIndicator(context),
            ),
          )
      ],
    );
  }
}
