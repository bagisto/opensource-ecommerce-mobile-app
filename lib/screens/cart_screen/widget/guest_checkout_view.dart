/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import '../utils/cart_index.dart';

class GuestCheckoutView extends StatelessWidget {
  final CartModel cartDetailsModel;
  final CartScreenBloc? cartScreenBloc;

  const GuestCheckoutView(
      {Key? key, required this.cartDetailsModel, required this.cartScreenBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSizes.spacingLarge),
        Text(
          StringConstants.checkoutAs.localized().toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: AppSizes.spacingWide*4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium +2, horizontal: AppSizes.spacingMedium),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.spacingNormal)),
                    elevation: AppSizes.spacingSmall,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width / 2.3,
                    color: Theme.of(context).colorScheme.onBackground,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pushNamed(context, signUp, arguments: false);
                    },
                    child: Text(
                      StringConstants.signUpLabel.localized().toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    )),
              ),
            ),
            SizedBox(
              height: AppSizes.spacingWide*4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical:AppSizes.spacingMedium +2, horizontal: AppSizes.spacingMedium),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    elevation: AppSizes.spacingSmall,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width / 2.3,
                    color: Theme.of(context).colorScheme.onBackground,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.of(context).pushNamed(signIn);
                    },
                    child: Text(
                      StringConstants.signIn.localized().toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    )),
              ),
            ),
          ],
        ),
        checkDownloadable(cartDetailsModel.items) == false ? SizedBox(
          height: AppSizes.spacingWide*4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:AppSizes.spacingMedium +2, horizontal: AppSizes.spacingMedium),
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: AppSizes.spacingSmall,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width / 1,
                color: Theme.of(context).colorScheme.onBackground,
                textColor: Theme.of(context).colorScheme.background,
                onPressed: () {
                  bool downloadable = checkVirtualDownloadable(cartDetailsModel.items);
                  Navigator.pushNamed(context, checkoutScreen,
                      arguments: CartNavigationData(
                          total: cartDetailsModel.formattedPrice?.grandTotal
                                  .toString() ??
                              "0",
                          cartDetailsModel: cartDetailsModel,
                          cartScreenBloc: cartScreenBloc,
                          isDownloadable: downloadable));
                },
                child: Text(
                  StringConstants.guestCheckoutLabel.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.background),
                )),
          ),
        ):const SizedBox.shrink(),
      ],
    );
  }
}
