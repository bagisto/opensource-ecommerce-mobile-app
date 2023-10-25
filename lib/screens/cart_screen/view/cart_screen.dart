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
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../configuration/app_global_data.dart';
import 'cart_index.dart';

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
    return createClient();
  }

  Widget createClient() {
    return GraphQLProvider(
      client: ValueNotifier(GraphQlApiCalling().clientToQuery()),
      child: CacheProvider(
        child: buildUI(),
      ),
    );
  }

  Widget buildUI() {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
        Navigator.pop(context, true);
            },
            child: Icon(
              Icons.arrow_back_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          centerTitle: false,
          title: CommonWidgets.getHeadingText("Cart".localized(), context),
        ),
        body:   _cartScreenData(context),
        ),

      ),
    );
  }

  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  ///bloc method
  _cartScreenData(BuildContext context) {
    return BlocConsumer<CartScreenBloc, CartScreenBaseState>(
      listener: (BuildContext context, CartScreenBaseState state) {
        if (state is RemoveCartItemState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            ShowMessage.showNotification(
                state.removeCartProductModel!.message ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is RemoveAllCartItemState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            ShowMessage.showNotification(
                state.removeAllCartProductModel!.message ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is AddCouponState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            ShowMessage.showNotification(
                state.baseModel?.message ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is RemoveCouponCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            ShowMessage.showNotification(
                state.baseModel?.message ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is MoveToCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            ShowMessage.showNotification(
                "AddedToWishlist".localized(),
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is UpdateCartState) {
          if (state.status == CartStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CartStatus.success) {
            quantityChanged = false;
            ShowMessage.showNotification(
                "UpdateCartSuccess".localized(),
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
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
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchCartDataState) {
      if (state.status == CartStatus.success) {
        _cartDetailsModel = state.cartDetailsModel;
        _discountController.text = _cartDetailsModel?.couponCode ?? "";
        return _cartScreenBody(_cartDetailsModel);
      }
      if (state.status == CartStatus.fail) {
        return ErrorMessage.errorMsg("SomethingWrong".localized());
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
        return ErrorMessage.errorMsg("SomethingWrong".localized());
      }
    }
    if (state is RemoveCartItemState) {
      if (state.status == CartStatus.success) {
        var productId = state.productDeletedId;
        if (_cartDetailsModel != null) {
          _cartDetailsModel!.items!
              .removeWhere((element) => element.id == productId);
          SharedPreferenceHelper.setCartCount(
              _cartDetailsModel?.itemsCount ?? 0);
          fetchCartData();
          return _cartScreenBody(_cartDetailsModel!);
        } else {}
      }
    }
    if (state is MoveToCartState) {
      if (state.status == CartStatus.success) {
        var productId = state.id;
        SharedPreferenceHelper.setCartCount(_cartDetailsModel?.itemsCount ?? 0);
        fetchCartData();
        if (_cartDetailsModel != null) {
          _cartDetailsModel!.items!
              .removeWhere((element) => element.id.toString() == productId.toString());
          return _cartScreenBody(_cartDetailsModel!);
        } else {}
      }
    }
    if (state is RemoveAllCartItemState) {
      if (state.status == CartStatus.success) {
        if (_cartDetailsModel != null) {
          _cartDetailsModel!.items!
              .removeWhere((element) => element.id == productId);
          SharedPreferenceHelper.setCartCount(
              _cartDetailsModel?.itemsCount ?? 0);
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
    return _cartScreenBody(_cartDetailsModel!);
  }

  ///this method consist cart body
  _cartScreenBody(CartModel? cartDetailsModel) {
    if (cartDetailsModel?.id == null) {
      return const EmptyCart();
    } else if (cartDetailsModel?.items?.isNotEmpty ?? false) {
      return _cartItems(cartDetailsModel!);
    } else {
      return Container(
          child: cartDetailsModel?.items?.isEmpty == true
              ? const EmptyCart()
              : Container());
    }
  }

  ///this method will show cart items
  _cartItems(CartModel cartDetailsModel) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(microseconds: 2), () {
                fetchCartData();
              });
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: NormalPadding),
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
                    CommonWidgets().getTextFieldHeight(AppSizes.spacingTiny),
                    ApplyCouponView(
                      discountController: _discountController,
                      cartScreenBloc: cartScreenBloc,
                      cartDetailsModel: _cartDetailsModel,
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.spacingTiny),
                    ButtonView(
                      selectedItems: _selectedItems,
                      cartScreenBloc: cartScreenBloc,
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.spacingTiny),
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
    );
  }
}
