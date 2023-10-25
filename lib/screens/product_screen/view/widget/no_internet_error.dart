import 'dart:io';

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common_widget/show_message.dart';
class NoInternetError extends StatelessWidget {
  const NoInternetError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _noInternetError("InternetIssue".localized(),context);
  }
  _noInternetError(String error,BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(error),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    ShowMessage.showNotification("closeApp".localized(), "",
                        Colors.yellow, const Icon(Icons.warning_amber));
                    Future.delayed(const Duration(seconds: 2), () {
                      exit(0);
                    });
                  },
                  child: Text(/*ButtonLabelOk*/
                      "ButtonLabelOk".localized())),
            ],
          );
        });
  }
}
