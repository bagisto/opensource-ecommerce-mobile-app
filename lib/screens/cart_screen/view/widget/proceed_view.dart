import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';
import 'guest_checkout_view.dart';

class ProceedView extends StatelessWidget {
  final CartModel cartDetailsModel;
  final bool quantityChanged ;
  final CartScreenBloc? cartScreenBloc;



  const ProceedView({Key? key, required this.cartDetailsModel, required this.quantityChanged, this.cartScreenBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.normalPadding, horizontal: 10.0),
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
                    "CartPageAmountToBePaidLabel".localized(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    cartDetailsModel.formattedPrice?.grandTotal
                        .toString() ??
                        "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                color: Theme.of(context).colorScheme.background,
                elevation: 0.0,
                textColor: Theme.of(context).colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () async {
                  var isUser =
                  await SharedPreferenceHelper.getCustomerLoggedIn();
                  if (quantityChanged) {
                    ShowMessage.showNotification(
                        "UpdateCartWarning".localized(),
                        "",
                        Colors.yellow,
                        const Icon(Icons.warning_amber));
                  } else if (isUser) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, Checkout,
                        arguments: CartNavigationData(
                            total: cartDetailsModel
                                .formattedPrice?.grandTotal
                                .toString() ??
                                "233",
                            cartDetailsModel: cartDetailsModel,
                            cartScreenBloc: cartScreenBloc,
                            isDownloadable: checkDownloadable(cartDetailsModel.items)));
                  } else {
                    // ignore: use_build_context_synchronously
                    showModalBottomSheet(
                        backgroundColor: Theme.of(context).cardColor,
                        context: context,
                        builder: (ctx) => FractionallySizedBox(
                            heightFactor: 0.6,
                            child: GuestCheckoutView(
                              cartDetailsModel: cartDetailsModel,
                              cartScreenBloc: cartScreenBloc,
                            )));
                  }
                },
                child: Text(
                  "Proceed".localized().toUpperCase(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: MobikulTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool checkDownloadable(List<Items>? items) {
    for (Items product in (items ?? [])) {
      if (product.type?.toLowerCase() != "downloadable".toLowerCase()) {
        return false;
      }
    }
    return true;
  }
}
