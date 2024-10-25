/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:io';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class NoInternetError extends StatelessWidget {
  const NoInternetError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _noInternetError(StringConstants.internetIssue.localized(),context);
  }
  _noInternetError(String error,BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(error),

            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    ShowMessage.showNotification(StringConstants.warning.localized(), StringConstants.closeApp.localized(),
                        Colors.yellow, const Icon(Icons.warning_amber));
                    Future.delayed(const Duration(seconds: 2), () {
                      exit(0);
                    });
                  },
                  child: Text(
                      StringConstants.ok.localized(),style: Theme.of(context).textTheme.bodyMedium,)),
            ],
          );
        });
  }
}
