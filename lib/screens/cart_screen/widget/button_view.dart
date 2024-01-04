
import 'package:bagisto_app_demo/utils/route_constants.dart';
import '../cart_index.dart';

class ButtonView extends StatelessWidget {
  final CartScreenBloc? cartScreenBloc;
  final List<Map<dynamic, String>> selectedItems;

  const ButtonView({Key? key, this.cartScreenBloc, required this.selectedItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge, vertical: AppSizes.spacingSmall),
          child: SizedBox(
            height: AppSizes.spacingWide*2,
            child:  MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.spacingNormal)),
                side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              elevation: 0.0,
              height: AppSizes.buttonHeight,
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              textColor: Theme.of(context).colorScheme.onBackground,
              onPressed: () {
                Navigator.pushReplacementNamed(context, home);
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.spacingLarge,
                  ),
                  Text(
                    StringConstants.continueShopping.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: SizedBox(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.spacingNormal)),
                side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              elevation: 0.0,
              height: AppSizes.buttonHeight,
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              textColor: Theme.of(context).colorScheme.onBackground,
              onPressed: () {
                _onPressAllRemove(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Icon(
                    Icons.delete_forever,
                    color:Theme.of(context).colorScheme.onBackground,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.spacingLarge,
                  ),
                  Text(
                    StringConstants.emptyCart.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: SizedBox(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.spacingNormal)),
                side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              elevation: 0.0,
              height: AppSizes.buttonHeight,
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              textColor: Theme.of(context).colorScheme.onBackground,
              onPressed: () {
                cartScreenBloc?.add(UpdateCartEvent(selectedItems));
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Icon(
                    Icons.update,
                    color:Theme.of(context).colorScheme.onBackground,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.spacingLarge,
                  ),
                  Text(
                    StringConstants.updateCart.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onPressAllRemove(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            StringConstants.deleteAllItemWarning.localized(),
          ),
          actions: [
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
                  cartScreenBloc?.add(RemoveAllCartItemEvent());
                },
                child: Text(StringConstants.yes.localized(),
                style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }
}
