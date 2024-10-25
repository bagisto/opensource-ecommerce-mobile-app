
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/widget/guest_checkout_view.dart';

import '../utils/cart_index.dart';

class ProceedView extends StatelessWidget {
  final CartModel cartDetailsModel;
  final bool quantityChanged;
  final CartScreenBloc? cartScreenBloc;

  const ProceedView(
      {Key? key,
      required this.cartDetailsModel,
      required this.quantityChanged,
      this.cartScreenBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.spacingNormal,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spacingNormal, horizontal: AppSizes.spacingNormal),
        margin: const EdgeInsets.fromLTRB(0, AppSizes.spacingSmall, 0, 0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.cartPageAmountToBePaidLabel.localized(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    cartDetailsModel.formattedPrice?.grandTotal.toString() ?? "",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                color: Theme.of(context).colorScheme.onBackground,
                elevation: 0.0,
                textColor: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.spacingSmall),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
                onPressed: () async {
                  var isUser = appStoragePref.getCustomerLoggedIn();
                  if (quantityChanged) {
                    if(context.mounted){
                      ShowMessage.warningNotification(
                          StringConstants.updateCartWarning.localized(),context);
                    }
                  } else if (isUser) {
                    if(context.mounted) {
                      Navigator.pushNamed(context, checkoutScreen,
                        arguments: CartNavigationData(
                            total: cartDetailsModel
                                .formattedPrice?.grandTotal
                                .toString() ?? "0",
                            cartDetailsModel: cartDetailsModel,
                            cartScreenBloc: cartScreenBloc,
                            isDownloadable: checkVirtualDownloadable(cartDetailsModel.items)));
                    }
                  } else {
                    if(context.mounted){
                      showModalBottomSheet(
                          backgroundColor: Theme.of(context).cardColor,
                          context: context,
                          builder: (ctx) => GuestCheckoutView(
                            cartDetailsModel: cartDetailsModel,
                            cartScreenBloc: cartScreenBloc,
                          ));
                    }
                  }
                },
                child: Text(
                  StringConstants.proceed.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondaryContainer
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
