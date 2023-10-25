import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.sidePadding,
                  ),
                  Text(
                    "ContinueShopping".localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            child: ElevatedButton(
              onPressed: () {
                _onPressAllRemove(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.sidePadding,
                  ),
                  Text(
                    "emptyCart".localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            child: ElevatedButton(
              onPressed: () {
                cartScreenBloc?.add(UpdateCartEvent(selectedItems));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(
                    width: AppSizes.sidePadding,
                  ),
                  Text(
                    "UpdateCart".localized().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            "deleteAllItemWarning".localized(),
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
                  cartScreenBloc?.add(RemoveAllCartItemEvent());
                },
                child: Text("ButtonLabelYes".localized()))
          ],
        );
      },
    );
  }
}
