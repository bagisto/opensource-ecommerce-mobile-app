/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/wishList/utils/index.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishListData? mWishList;
  // ShareWishlistData? share;
  final StreamController wishlistController = StreamController<int>.broadcast();
  int? cartCount = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  AddToCartModel? addToCartModel;
  WishListBloc? wishListBloc;

  @override
  void initState() {
    getSharePreferenceCartCount().then((value) {
      GlobalData.cartCountController.sink.add(value);
    });

    wishListBloc = context.read<WishListBloc>();
    wishListBloc?.add(FetchWishListEvent());
    super.initState();
  }

  Future getSharePreferenceCartCount() async {
    return appStoragePref.getCartCount();
  }

  @override
  void dispose() {
    super.dispose();
    wishlistController.close();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              StringConstants.wishlist.localized(),
            ),
            actions: [
              StreamBuilder(
                stream: GlobalData.cartCountController.stream,
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
            stream: wishlistController.stream,
            builder: (context, snapshot) {
              int count = snapshot.data ?? 0;
              return Visibility(
                visible: count > 0 ? true : false,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {
                    wishListBloc?.add(
                        OnClickWishListLoaderEvent(isReqToShowLoader: true));
                    wishListBloc?.add(RemoveAllWishlistEvent(""));
                  },
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              );
            },
          )),
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
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.error ?? "",
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllWishlistProductState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.error ?? "",
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToCartWishlistState) {
          if (state.status == WishListStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.error ?? "",
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == WishListStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                Colors.green.shade400,
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
    if (state is FetchCartCountState) {
      if (state.status == WishListStatus.success) {
        if (state.cartDetails != null) {
          appStoragePref.setCartCount(state.cartDetails?.itemsQty ?? 0);
          GlobalData.cartCountController.sink
              .add(state.cartDetails?.itemsQty ?? 0);
        }
      }
    }
    if (state is FetchDataState) {
      if (state.status == WishListStatus.success) {
        mWishList = state.wishListProducts;
        wishlistController.sink.add(mWishList?.data?.length ?? 0);
        return _showWishList(mWishList, context, isLoading);
      }
      if (state.status == WishListStatus.fail) {
        return EmptyDataView();
      }
    }
    if (state is FetchDeleteAddItemState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        wishListBloc?.add(FetchWishListEvent());
        return _showWishList(mWishList, context, isLoading);
      }
    }
    if (state is RemoveAllWishlistProductState) {
      isLoading = false;
      if (state.status == WishListStatus.success) {
        if (mWishList != null) {
          mWishList?.data?.clear();
          wishlistController.sink.add(0);
          return _showWishList(mWishList, context, isLoading);
        }
      }
    }
    if (state is AddToCartWishlistState) {
      wishListBloc?.add(GetCartCountEvent());
      isLoading = false;
      if (state.status == WishListStatus.success) {
        wishListBloc?.add(FetchWishListEvent());
        addToCartModel = state.response!;
        GlobalData.cartCountController.sink
            .add(addToCartModel?.cart?.itemsQty ?? 0);
        return _showWishList(mWishList, context, isLoading);
      }
    }
    if (state is OnClickWishListLoaderState) {
      isLoading = false;
      return _showWishList(mWishList, context, isLoading);
    }
    return _showWishList(mWishList, context, isLoading);
  }

  ///show wishlist data
  _showWishList(
      WishListData? wishListData, BuildContext context, bool isLoading) {
    var wishListItems = wishListData?.data;
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
