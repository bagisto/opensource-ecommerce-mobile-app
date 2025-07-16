/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/extension.dart';
import 'package:bagisto_app_demo/utils/server_configuration.dart';

import '../utils/cart_index.dart';

class CartListItem extends StatelessWidget {
  final CartModel cartDetailsModel;
  final CartScreenBloc? cartScreenBloc;
  final List<Map<dynamic, String>> selectedItems;
  final Function(bool quantityChanged)? callBack;

  const CartListItem(
      {Key? key,
      required this.cartDetailsModel,
      this.cartScreenBloc,
      required this.selectedItems,
      this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartDetailsModel.items?.length ?? 0,
      itemBuilder: (BuildContext context, int itemIndex) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, productScreen,
                arguments: PassProductData(
                    title: cartDetailsModel.items?[itemIndex].name ?? '',
                    urlKey: cartDetailsModel.items?[itemIndex].product?.urlKey,
                    productId: int.parse(
                        cartDetailsModel.items?[itemIndex].product?.id ?? "")));
          },
          child: Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spacingNormal),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ((cartDetailsModel
                                          .items?[itemIndex].product?.images ??
                                      [])
                                  .isNotEmpty)
                              ? ImageView(
                                  url: cartDetailsModel.items?[itemIndex]
                                          .product?.images?[0].url ??
                                      "",
                                  height:
                                      MediaQuery.of(context).size.width / 3.5,
                                )
                              : ImageView(
                                  url: AssetConstants.placeHolder,
                                  height:
                                      MediaQuery.of(context).size.width / 3.5,
                                ),
                          QuantityView(
                            qty: cartDetailsModel.items?[itemIndex].quantity
                                    ?.toString() ??
                                "",
                            showTitle: false,
                            setQuantity: true,
                            callBack: (val) {
                              cartDetailsModel.items?[itemIndex].quantity = val;
                              var quantityChanged = true;
                              if (callBack != null) {
                                callBack!(quantityChanged);
                              }
                              _itemChange(
                                  {
                                    "cartItemId": cartDetailsModel
                                            .items?[itemIndex].id
                                            .toString() ??
                                        "",
                                    "quantity": cartDetailsModel
                                            .items?[itemIndex].quantity
                                            .toString() ??
                                        ""
                                  },
                                  true,
                                  cartDetailsModel.items?[itemIndex].id
                                      .toString());
                            },
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.spacingNormal,
                            AppSizes.spacingLarge,
                            AppSizes.spacingNormal,
                            AppSizes.spacingNormal),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  cartDetailsModel.items?[itemIndex].name ??
                                      cartDetailsModel.items?[itemIndex].name ??
                                      "",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            // cartDetailsModel.items?[itemIndex]
                            //             .additional?['attributes'] !=
                            getAttributesValueFromAdditional(cartDetailsModel
                                        .items?[itemIndex].additional) !=
                                    null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    // itemCount: cartDetailsModel
                                    //         .items?[itemIndex]
                                    //         .additional?['attributes']
                                    //         ?.length ??
                                    //     0,
                                    itemCount: getAttributesValueFromAdditional(
                                                cartDetailsModel
                                                    .items?[itemIndex]
                                                    .additional)
                                            ?.length ??
                                        0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final attribute = getAttributesValueFromAdditional(cartDetailsModel.items?[itemIndex].additional)?[index];
                                      final attributeType = attribute?['attribute_type'];
                                      final optionLabel = attribute?['option_label'] ?? '';
                                      final attributeName = attribute?['attribute_name'] ?? '';
                                      if (attributeType == 'file' && optionLabel.isNotEmpty) {
                                        final fileUrl = '$baseDomain/storage/$optionLabel';
                                        final fileName = optionLabel.split('/').last;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(1),
                                              ),
                                              child: Image.network(
                                                fileUrl,
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.insert_drive_file, size: 60),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${attributeName} - ${fileName}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                            ),
                                            const SizedBox(height: AppSizes.spacingSmall),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${attributeName}  - ${optionLabel}",
                                              maxLines: 2,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                            ),
                                            const SizedBox(height: AppSizes.spacingSmall),
                                          ],
                                        );
                                      }
                                    })
                                : const SizedBox(),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  cartDetailsModel.items?[itemIndex]
                                          .formattedPrice?.price
                                          .toString() ??
                                      '0',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  StringConstants.cartPageSubtotalLabel
                                      .localized(),
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold, /* color: Colors.grey*/
                                  ),
                                ),
                                Text(
                                  cartDetailsModel.items?[itemIndex]
                                          .formattedPrice?.total
                                          .toString() ??
                                      "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                  thickness: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1)),
                        ),
                        child: MaterialButton(
                          elevation: 0.0,
                          onPressed: () {
                            bool isLogged =
                                appStoragePref.getCustomerLoggedIn();
                            if (isLogged) {
                              cartScreenBloc?.add(MoveToCartEvent(int.parse(
                                  cartDetailsModel.items?[itemIndex].id ??
                                      "")));
                            } else {
                              ShowMessage.warningNotification(
                                  StringConstants.pleaseLogin.localized(),
                                  context);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: AppSizes.spacingWide,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    StringConstants.moveToWishList.localized(),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Colors.grey.shade300, width: 1)),
                        ),
                        child: MaterialButton(
                          elevation: 0.0,
                          onPressed: () {
                            _onPressRemove(
                                cartDetailsModel, itemIndex, context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: AppSizes.spacingWide,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  StringConstants.cartPageRemoveItemLabel
                                      .localized(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            ],
                          ),
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

  void _itemChange(
      Map<dynamic, String> itemValue, bool isSelected, String? id) {
    selectedItems.removeWhere((element) => element["cartItemId"] == id);
    if (isSelected) {
      selectedItems.add(itemValue);
    } else {
      selectedItems.remove(itemValue);
    }
  }

  _onPressRemove(
      CartModel cartDetailsModel, int itemIndex, BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            StringConstants.deleteItemWarning.localized(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                StringConstants.no.localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  cartScreenBloc?.add(RemoveCartItemEvent(
                      cartItemId: int.parse(
                          cartDetailsModel.items?[itemIndex].id ?? "")));
                },
                child: Text(StringConstants.yes.localized(),
                    style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }
}
