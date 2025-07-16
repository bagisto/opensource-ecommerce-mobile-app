/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _discountController = TextEditingController();
  CartModel? _cartDetailsModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  CartScreenBloc? cartScreenBloc;
  final List<Map<dynamic, String>> _selectedItems = [];
  int qty = 1;
  bool quantityChanged = false;

  @override
  void initState() {
    cartScreenBloc = context.read<CartScreenBloc>();
    fetchCartData();
    super.initState();
  }

  fetchCartData() {
    cartScreenBloc?.add(FetchCartDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: CommonAppBar(
          StringConstants.cart.localized(),
          index: 2,
          isInCartScreen: true,
        ),
        body: _cartScreenData(context),
      ),
    );
  }

  ///bloc method
  _cartScreenData(BuildContext context) {
    return BlocConsumer<CartScreenBloc, CartScreenBaseState>(
      listener: (BuildContext context, CartScreenBaseState state) {
        if (state is RemoveCartItemState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            ShowMessage.successNotification(
                state.removeCartProductModel?.message ?? "", context);
            GlobalData.cartCountController.sink
                .add(state.removeCartProductModel?.cart?.itemsQty ?? 0);
          }
        }
        if (state is RemoveAllCartItemState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            ShowMessage.successNotification(
                state.removeAllCartProductModel!.message ?? "", context);
            GlobalData.cartCountController.sink.add(0);
          }
        }
        if (state is AddCouponState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            ShowMessage.successNotification(
                state.baseModel?.message ?? "", context);
          }
        }
        if (state is RemoveCouponCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            ShowMessage.successNotification(
                state.baseModel?.message ?? "", context);
          }
        }
        if (state is MoveToCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            ShowMessage.successNotification(
                StringConstants.addedToWishlist.localized(), context);
          }
        }
        if (state is UpdateCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CartStatus.success) {
            quantityChanged = false;
            ShowMessage.successNotification(
                StringConstants.updateCartSuccess.localized(), context);
          }
        }
      },
      builder: (BuildContext context, CartScreenBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(
    BuildContext context,
    CartScreenBaseState state,
  ) {
    if (state is ShowLoaderCartState) {
      return const CartLoaderView();
    }
    if (state is FetchCartDataState) {
      if (state.status == CartStatus.success) {
        _cartDetailsModel = state.cartDetailsModel;
        _discountController.text = _cartDetailsModel?.couponCode ?? "";
        GlobalData.cartCountController.sink
            .add(state.cartDetailsModel?.itemsQty ?? 0);
        return _cartScreenBody(_cartDetailsModel);
      }
      if (state.status == CartStatus.fail) {
        return ErrorMessage.errorMsg(
            StringConstants.somethingWrong.localized());
      }
    }
    if (state is UpdateCartState) {
      if (state.status == CartStatus.success) {
        fetchCartData();
        if (_cartDetailsModel != null) {
          return _cartScreenBody(_cartDetailsModel!);
        }
      }
      if (state.status == CartStatus.fail) {
        return ErrorMessage.errorMsg(
            StringConstants.somethingWrong.localized());
      }
    }
    if (state is RemoveCartItemState) {
      if (state.status == CartStatus.success) {
        var productId = state.productDeletedId;
        if (_cartDetailsModel != null) {
          _cartDetailsModel!.items!
              .removeWhere((element) => element.id == productId);
          appStoragePref.setCartCount(_cartDetailsModel?.itemsCount ?? 0);
          fetchCartData();
          return _cartScreenBody(_cartDetailsModel!);
        } else {}
      }
    }
    if (state is MoveToCartState) {
      if (state.status == CartStatus.success) {
        var productId = state.id;
        appStoragePref.setCartCount(_cartDetailsModel?.itemsCount ?? 0);
        fetchCartData();
        if (_cartDetailsModel != null) {
          _cartDetailsModel?.items
              ?.removeWhere((element) => element.id == productId.toString());
          return _cartScreenBody(_cartDetailsModel!);
        } else {}
      }
    }
    if (state is RemoveAllCartItemState) {
      if (state.status == CartStatus.success) {
        if (_cartDetailsModel != null) {
          _cartDetailsModel!.items!.removeWhere(
              (element) => element.id == StringConstants.productId);
          appStoragePref.setCartCount(_cartDetailsModel?.itemsCount ?? 0);
          fetchCartData();
          return _cartScreenBody(_cartDetailsModel!);
        } else {}
      }
    }
    if (state is AddCouponState) {
      if (state.status == CartStatus.success) {
        if (_cartDetailsModel != null) {
          fetchCartData();
          return _cartScreenBody(_cartDetailsModel!);
        }
      } else if (state.status == CartStatus.fail) {
        return _cartScreenBody(_cartDetailsModel!);
      }
    }
    if (state is RemoveCouponCartState) {
      if (state.status == CartStatus.success) {
        fetchCartData();
        return _cartScreenBody(_cartDetailsModel!);
      }
    }
    return const SizedBox();
  }

  ///this method consist cart body
  _cartScreenBody(CartModel? cartDetailsModel) {
    if (cartDetailsModel?.id == null) {
      return EmptyDataView(
        assetPath: AssetConstants.emptyCart,
        message: StringConstants.emptyCartPageLabel,
        showDescription: true,
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.width / 2,
      );
    } else if (cartDetailsModel?.items?.isNotEmpty ?? false) {
      return _cartItems(cartDetailsModel!);
    } else {
      return Container(
          child: cartDetailsModel?.items?.isEmpty == true
              ? EmptyDataView(
                  assetPath: AssetConstants.emptyCart,
                  message: StringConstants.emptyCartPageLabel,
                  showDescription: true,
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 2,
                )
              : const SizedBox());
    }
  }

  ///this method will show cart items
  _cartItems(CartModel cartDetailsModel) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              onRefresh: () {
                return Future.delayed(const Duration(microseconds: 2), () {
                  fetchCartData();
                });
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spacingNormal),
                  child: Column(
                    children: [
                      CartListItem(
                          cartDetailsModel: cartDetailsModel,
                          selectedItems: _selectedItems,
                          cartScreenBloc: cartScreenBloc,
                          callBack: (quantityChanged) {
                            setState(() {
                              this.quantityChanged = quantityChanged;
                            });
                          }),
                      const SizedBox(height: AppSizes.spacingSmall),
                      ApplyCouponView(
                        discountController: _discountController,
                        cartScreenBloc: cartScreenBloc,
                        cartDetailsModel: _cartDetailsModel,
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),
                      ButtonView(
                        selectedItems: _selectedItems,
                        cartScreenBloc: cartScreenBloc,
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),
                      PriceDetailView(
                        cartDetailsModel: cartDetailsModel,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ProceedView(
            cartDetailsModel: cartDetailsModel,
            quantityChanged: quantityChanged,
            cartScreenBloc: cartScreenBloc,
          )
        ],
      ),
    );
  }
}
