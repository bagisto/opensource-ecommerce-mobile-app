
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, implementation_imports, deprecated_member_use

import 'dart:async';
import 'package:bagisto_app_demo/helper/badge_helper.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/screens/wishList/bloc/wishlist_bloc.dart';
import 'package:bagisto_app_demo/screens/wishList/events/delete_item_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/fetch_wishlist_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/wishlist_loader_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/addToCartWishlistEvent.dart';
import 'package:bagisto_app_demo/screens/wishList/state/delete_item_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/fetch_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/loader_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/show_loader_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/addToCartWishlistState.dart';
import 'package:bagisto_app_demo/screens/wishList/state/wishlist_base_state.dart';
import 'package:bagisto_app_demo/screens/wishList/view/wishlist_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../configuration/app_global_data.dart';
import '../../../models/wishlist_model/wishlist_model.dart';
import '../../../routes/route_constants.dart';
import 'empty_wishlist.dart';
class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishListData? mWishList;
  ShareWishlistData? share;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  final StreamController streamController = StreamController.broadcast();
  Stream get onVariableChanged => _myStreamCtrl.stream;
  Stream get onUpdate => streamController.stream;
  int?cartCount=0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  AddToCartModel? addToCartModel;
  bool  isVisible  = false;
  WishListBloc? wishListBloc;
  @override
  void initState() {
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    wishListBloc = context.read<WishListBloc>();
    wishListBloc?.add(FetchWishListEvent());
    super.initState();
  }
  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:Directionality(
          textDirection: GlobalData.contentDirection(),
          child:  Scaffold(
        appBar: AppBar(
         centerTitle: false,
          title: CommonWidgets.getHeadingText(
             "WishList".localized(),context),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: IconButton(onPressed: ()  {
                wishListBloc?.add(ShareWishlistEvent(true));
                wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: true));

              }, icon: const Icon(Icons.share)),
            ),
            StreamBuilder(
              stream: onVariableChanged,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return _cartButtonValue(0);
                }
                return  _cartButtonValue( int.tryParse(snapshot.data.toString() ) ?? 0);
              },
            ),
          ],
        ),
        body:  _setWishListData (context),

        floatingActionButton:StreamBuilder(
          stream: onUpdate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Visibility(
                visible: isVisible,
                child: FloatingActionButton(
                  onPressed: () {
                    wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: true));
                    wishListBloc?.add(RemoveAllWishlistEvent(""));
                  },
                  child: Icon(Icons.delete,color: Theme.of(context).colorScheme.onBackground,),
                ),
              );
            }
            return Visibility(
              visible: snapshot.data.toString() == "true" ? true : false,
              child: FloatingActionButton(
                onPressed: () {
                  wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: true));
                  wishListBloc?.add(RemoveAllWishlistEvent(""));
                },
                child: Icon(Icons.delete,color: Theme.of(context).colorScheme.onBackground,),
              ),
            );
          },
        )
      ),
    ));

  }

  _cartButtonValue(int count){
    return BadgeIcon(
        icon:  IconButton(
          icon: const Icon(Icons.shopping_cart),
          // color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, CartPage);
          },
        ),
        badgeCount:count);
  }

///BLOCK CONTAINER
  _setWishListData(BuildContext context) {
    return BlocConsumer<WishListBloc, WishListBaseState>(
      listener: (BuildContext context, WishListBaseState state) {
        if (state is FetchDeleteAddItemState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification("Failed", state.error??"",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification( state.successMsg??"","",
                const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
            wishListBloc?.add(FetchWishListEvent());
          }
        }
        else if (state is RemoveAllWishlistProductState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification("Failed", state.error??"",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification( state.successMsg??"","",
                const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
          }
        }
        else if (state is AddToCartWishlistState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification("Failed", state.error??"",
                  Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification( state.successMsg??"","",
                const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
            wishListBloc?.add(FetchWishListEvent());
          }
        }
        else if (state is ShareWishlistState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification("Failed", state.error??"",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {

          }
        }

      },
      buildWhen: (WishListBaseState prev, WishListBaseState current) {
        if (current is FetchDataState) {
          return true;
        }
        if (current is ShowLoaderWishListState) {
          return true;
        }
        if (current is FetchDeleteAddItemState) {
          if ((current).status == WishListStatus.success) {
            return true;
          }
        }
        if (current is RemoveAllWishlistProductState) {
          if ((current).status == WishListStatus.success) {
            return true;
          }
        }
        if (current is AddToCartWishlistState) {
          if ((current).status == WishListStatus.success){
            return true;
          }
        }
        if (current is ShareWishlistState) {
          if ((current).status == WishListStatus.success){
            return true;
          }
        }
        if(current is OnClickWishListLoaderState){
          return true;
        }
        return false;
      },
      builder: (BuildContext context, WishListBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

 ///UI METHODS
  Widget buildContainer(BuildContext context, WishListBaseState state) {
    if (state is ShowLoaderWishListState) {
      return   CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchDataState) {
      if (state.status == WishListStatus.success) {
        mWishList = state.wishListProducts;
        if((mWishList?.data?.length??0)>0) {
          streamController.add(true);
        }
      }
      if (state.status == WishListStatus.fail) {
        return ErrorMessage.errorMsg(state.error??"");
      }
    }
    if (state is ShareWishlistState) {
      if (state.status == WishListStatus.success) {
        wishListBloc?.add(OnClickWishListLoaderEvent(isReqToShowLoader: false));
        share = state.response;
        share!=null ? FlutterShare.share(
            title:  share?.wishlistSharedLink ?? "",
            text: '',
            linkUrl:share?.wishlistSharedLink ?? "",
            chooserTitle: ''):null;
      }
      if (state.status == WishListStatus.fail) {
        return ErrorMessage.errorMsg(state.error??"");
      }
    }
    if (state is FetchDeleteAddItemState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        var productId = state.producDeletedId;
        if(mWishList!=null){
          mWishList?.data!.removeWhere((element) => element.product?.id == productId);
        }
      }
    }
    if (state is RemoveAllWishlistProductState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        if (mWishList != null) {
          mWishList?.data?.clear();
          streamController.add(true);
        }
      }
    }
    if (state is AddToCartWishlistState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        var productId = state.cartProductId;
        mWishList?.data!.removeWhere((element) => element.productId == productId);
         addToCartModel=state.response!;
        SharedPreferenceHelper.setCartCount(addToCartModel?.cart?.itemsCount??2);
        _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount);
      }
    }
    if (state is OnClickWishListLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
      SharedPreferenceHelper.setCartCount(mWishList?.cartCount??2);
      _myStreamCtrl.sink.add(mWishList?.cartCount);
    }
    return _showWishList(mWishList!, context, isLoading);
  }

  ///show wishlist data
  _showWishList(WishListData wishListData, BuildContext context,bool isLoading) {
    var wishListItems = wishListData.data;
    return SingleChildScrollView(
      child: Column(
        children: [
          (wishListItems != null && wishListItems.isNotEmpty)
              ? WishlistItemList(model:wishListData, isLoading:isLoading,wishListBloc: wishListBloc,)
              : EmptyWishlist(streamController: streamController,)
        ],
      ),
    );
  }
}
