/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'dart:async';
import 'package:bagisto_app_demo/screens/wishList/view/widget/wishlist_Item_list.dart';
import 'package:bagisto_app_demo/screens/wishList/view/widget/wishlist_loader.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/assets_constants.dart';
import '../../../utils/badge_helper.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/empty_data_view.dart';
import '../../../widgets/show_message.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../bloc/fetch_wishlist_event.dart';
import '../bloc/fetch_wishlist_state.dart';
import '../bloc/wishlist_bloc.dart';
import '../data_model/wishlist_model.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishListData? mWishList;
  ShareWishlistData? share;
  final StreamController streamController = StreamController.broadcast();
  final StreamController _myStreamCtrl = StreamController.broadcast();

  Stream get onVariableChanged => _myStreamCtrl.stream;

  Stream get onUpdate => streamController.stream;
  int? cartCount = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  AddToCartModel? addToCartModel;
  final bool _isVisible = false;
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
  void dispose() {
    super.dispose();
    _myStreamCtrl.close();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(StringConstants.wishlist.localized(), style: Theme.of(context).textTheme.titleLarge),
              actions: [
                StreamBuilder(
                  stream: onVariableChanged,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _cartButtonValue(0);
                    }
                    return _cartButtonValue(
                        int.tryParse(snapshot.data.toString()) ?? 0);
                  },
                ),
              ],
            ),
            body: _setWishListData(context),
            floatingActionButton: StreamBuilder(
              stream: onUpdate,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Visibility(
                    visible: _isVisible,
                    child: FloatingActionButton(
                      onPressed: () {
                        wishListBloc?.add(OnClickWishListLoaderEvent(
                            isReqToShowLoader: true));
                        wishListBloc?.add(RemoveAllWishlistEvent(""));
                      },
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                }
                return Visibility(
                  visible: snapshot.data.toString() == "true" && (mWishList?.data ?? []).isNotEmpty ? true : false,
                  child: FloatingActionButton(
                    onPressed: () {
                      wishListBloc?.add(
                          OnClickWishListLoaderEvent(isReqToShowLoader: true));
                      wishListBloc?.add(RemoveAllWishlistEvent(""));
                    },
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  _cartButtonValue(int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: BadgeIcon(
          icon: IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.pushNamed(context, cartScreen);
            },
          ),
          badgeCount: count),
    );
  }

  ///BLOCK CONTAINER
  _setWishListData(BuildContext context) {
    return BlocConsumer<WishListBloc, WishListBaseState>(
      listener: (BuildContext context, WishListBaseState state) {
        if (state is FetchDeleteAddItemState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllWishlistProductState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToCartWishlistState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
            WishListBloc wishListBloc = context.read<WishListBloc>();
            wishListBloc.add(FetchWishListEvent());
          }
        }
      },
      builder: (BuildContext context, WishListBaseState state) {
        return SafeArea(child: buildContainer(context, state));
      },
    );
  }

  ///UI METHODS
  Widget buildContainer(BuildContext context, WishListBaseState state) {
    if (state is ShowLoaderWishListState) {
      return const WishListLoader();
    }
    if (state is FetchDataState) {
      if (state.status == WishListStatus.success) {
        mWishList = state.wishListProducts;
        if ((mWishList?.data?.length ?? 0) > 0) {
          streamController.add(true);
        }
        return _showWishList(mWishList!, context, isLoading);
      }
      if (state.status == WishListStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }
    if (state is FetchDeleteAddItemState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        var productId = state.producDeletedId;
        if (mWishList != null) {
          mWishList?.data!
              .removeWhere((element) => element.product?.id == productId);
          return _showWishList(mWishList!, context, isLoading);
        }
      }
    }
    if (state is RemoveAllWishlistProductState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        if (mWishList != null) {
          mWishList?.data?.clear();
          streamController.add(false);
          return _showWishList(mWishList!, context, isLoading);
        }
      }
    }
    if (state is AddToCartWishlistState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        var productId = state.cartProductId;
        mWishList?.data!
            .removeWhere((element) => element.productId == productId);
        addToCartModel = state.response!;
        SharedPreferenceHelper.setCartCount(
            addToCartModel?.cart?.itemsCount ?? 2);
        _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount);
        return _showWishList(mWishList!, context, isLoading);
      }
    }
    if (state is OnClickWishListLoaderState) {
      isLoading = false;
      SharedPreferenceHelper.setCartCount(mWishList?.cartCount ?? 2);
      _myStreamCtrl.sink.add(mWishList?.cartCount);
      return _showWishList(mWishList!, context, isLoading);
    }
    return const SizedBox();
  }

  ///show wishlist data
  _showWishList(
      WishListData wishListData, BuildContext context, bool isLoading) {
    var wishListItems = wishListData.data;
    return (wishListItems != null && wishListItems.isNotEmpty)
        ? WishlistItemList(
            model: wishListData,
            isLoading: isLoading,
            wishListBloc: wishListBloc,
          )
        : EmptyDataView(
            assetPath: AssetConstants.emptyWishlist,
            message: StringConstants.emptyWishList,
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.width / 2,
        showDescription: true,
        description: StringConstants.emptyWishListNoItem,
          );
  }
}
