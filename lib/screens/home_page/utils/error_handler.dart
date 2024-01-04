
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/show_message.dart';

///method will call when there is error on homepage
 homePageError(String error, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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