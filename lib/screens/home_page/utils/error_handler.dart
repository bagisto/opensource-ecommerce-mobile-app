
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

///method will call when there is error on homepage
 homePageError(String error, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(StringConstants.internetIssue.localized()),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  ShowMessage.warningNotification(StringConstants.closeApp.localized(), context);
                  Future.delayed(const Duration(seconds: 2), () {
                    // exit(0);
                  });
                  // exit(0);
                },
                child: Text(StringConstants.ok.localized())),
          ],
        );
      });
}