
import 'package:bagisto_app_demo/screens/sign_up/utils/index.dart';
import '../../../data_model/app_route_arguments.dart';
import '../cart_index.dart';
import '../util/check_downlodable.dart';
import 'guest_checkout_view.dart';

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
            vertical: AppSizes.spacingNormal, horizontal: 10.0),
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
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
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () async {
                  var isUser =
                      await SharedPreferenceHelper.getCustomerLoggedIn();
                  if (quantityChanged) {
                    ShowMessage.warningNotification(
                        StringConstants.updateCartWarning.localized(),context);
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
                    color: Theme.of(context).colorScheme.primary
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
