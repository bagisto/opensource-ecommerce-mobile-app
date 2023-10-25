import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

import '../../../../configuration/app_global_data.dart';
class CartListItem extends StatelessWidget {
  final CartModel cartDetailsModel;
  final CartScreenBloc? cartScreenBloc;
  final List<Map<dynamic,String>> selectedItems;
  final Function(
  bool quantityChanged)? callBack;

  const CartListItem({Key? key, required this.cartDetailsModel, this.cartScreenBloc, required this.selectedItems, this.callBack}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartDetailsModel.items!.length,
      itemBuilder: (BuildContext context, int itemIndex) {
        var productFlats = cartDetailsModel.items![itemIndex].product?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

        preCacheProductPage( int.parse(cartDetailsModel.items![itemIndex].product?.id??""));
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductPage,
                arguments: PassProductData(
                    title: productFlats?.name ?? '',
                    productId: int.parse(cartDetailsModel.items![itemIndex].product?.id??"")));
          },
          child: Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: NormalPadding,
                            horizontal: NormalPadding),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ((cartDetailsModel.items?[itemIndex].product?.images ?? []).isNotEmpty)?
                            ImageView(
                              url: (cartDetailsModel.items?[itemIndex].product
                                  ?.images?[0].url ??
                                  ""),
                            ):ImageView(
                              url: (imageUrl),
                              height: MediaQuery.of(context)
                                  .size
                                  .width / 2.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding:
                        const EdgeInsets.all(NormalPadding),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  productFlats?.name ?? '',
                                  style: const TextStyle(
                                      fontSize:
                                      AppSizes.normalFontSize,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            cartDetailsModel.items![itemIndex].additional?.attributes!=null ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:cartDetailsModel.items![itemIndex].additional?.attributes?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text("${cartDetailsModel.items![itemIndex].additional?.attributes?[index].attributeName} - ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          Text("${cartDetailsModel.items![itemIndex].additional?.attributes?[index].optionLabel}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.grey)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.spacingTiny,
                                      ),
                                    ],
                                  );
                                }):Container(),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  cartDetailsModel.items![itemIndex].formattedPrice?.price.
                                  toString()  ?? '34e333',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "CartPageSubtotalLabel"
                                      .localized(),
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    /* color: Colors.grey*/),
                                ),
                                Text(
                                  cartDetailsModel.items![itemIndex].formattedPrice?.total.toString()??"",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            StatefulBuilder(builder: (context, changeState) {
                              return QuantityView(
                                qty: cartDetailsModel.items![itemIndex].quantity?.toString() ?? "",
                                callBack: (val) {
                                  changeState(() {
                                    cartDetailsModel.items![itemIndex].quantity = val;
                                    var quantityChanged = true;
                                    callBack!(quantityChanged);
                                  });
                                  _itemChange(
                                      {
                                        "cartItemId": cartDetailsModel.items![itemIndex].id.toString(),
                                        "quantity":   cartDetailsModel.items![itemIndex].quantity.toString()
                                      }, true );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CommonWidgets().divider(),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      elevation: 0.0,
                      onPressed: () {
                        getCustomerLoggedInPrefValue().then((isLogged) {
                          if (isLogged) {
                            cartScreenBloc?.add(
                                MoveToCartEvent(int.parse(cartDetailsModel.items?[itemIndex].id??""))
                            );
                          } else {
                            ShowMessage.showNotification(
                                "pleaseLogin".localized(),
                                "",
                                Colors.yellow,
                                const Icon(Icons.warning_amber));
                          }});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: NormalPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              size: 18,
                            ),
                            Text( "  "+ "MoveToWishList".localized(),style: TextStyle(color:  Theme.of(context)
                                .colorScheme
                                .onPrimary,),)
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      elevation: 0.0,
                      onPressed: () {
                        _onPressRemove(cartDetailsModel, itemIndex,context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: NormalPadding),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              size: 18,
                            ),
                            Text( "  "+ "CartPageRemoveItemLabel"
                                .localized(),style: TextStyle(color:  Theme.of(context)
                                .colorScheme
                                .onPrimary,),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _itemChange(Map<dynamic,String> itemValue, bool isSelected) {
    if (isSelected) {
      selectedItems.add(itemValue);
    } else {
      selectedItems.remove(itemValue);
    }
  }
  _onPressRemove(CartModel cartDetailsModel, int itemIndex,BuildContext context ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "deleteItemWarning".localized(),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "ButtonLabelNO".localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  cartScreenBloc?.add(RemoveCartItemEvent(
                      cartItemId:int.parse (cartDetailsModel.items![itemIndex].id??"")));
                },
                child: Text("ButtonLabelYes".localized()))
          ],
        );
      },
    );
  }
}
