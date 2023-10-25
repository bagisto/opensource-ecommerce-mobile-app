import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../helper/shared_preference_helper.dart';
import '../../../models/account_models/account_info_details.dart';
import '../../homepage/repository/homepage_repository.dart';
// ignore: must_be_immutable
class LogoutButton extends StatefulWidget {
   final dynamic  fetchSharedPreferenceData;
    const LogoutButton({Key? key, this.fetchSharedPreferenceData}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _onPressedLogout();
      },
      title: MaterialButton(
        color: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        textColor: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        onPressed: () {
          checkInternetConnection().then((value) {
            if (value) {
              _onPressedLogout();
            } else {
              ShowMessage.showNotification("InternetIssue".localized(),
                  "", Colors.red, const Icon(Icons.cancel_outlined));
            }
          });
        },
        child: Text(
          "LogOutTitle".localized().toUpperCase(),
          style: TextStyle(
              fontSize: AppSizes.normalFontSize,
              fontWeight: FontWeight.w600,
              color: MobikulTheme.primaryColor),
        ),
      ),
    );
  }

  ///when user will press logout button
  _onPressedLogout() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "LogOutWarningMsg".localized(),
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
                  _onPressConfirmLogout();
                },
                child: Text("ButtonLabelYes".localized())),
          ],
        );
      },
    );
  }

  ///when user will click confirm logout
  _onPressConfirmLogout() {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: const EdgeInsets.all(AppSizes.widgetSidePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonWidgets().getTextFieldHeight(AppSizes.normalHeight),
                  CircularProgressIndicatorClass.circularProgressIndicator(
                      context),
                  CommonWidgets()
                      .getTextFieldHeight(AppSizes.widgetSidePadding),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Center(
                      child: Text(
                        "PleaseWaitProcessingRequest".localized(),
                        softWrap: true,
                      ),
                    ),
                  ),
                  CommonWidgets().getTextFieldHeight(AppSizes.normalHeight)
                ],
              ),
            ),
          );
        });
    HomePageRepositoryImp().callLogoutApi().then((response) async {
      Navigator.pop(context);
      Navigator.pop(context);

      ShowMessage.showNotification(
          response.success,
          "",
          const Color.fromRGBO(140, 194, 74, 5),
          const Icon(Icons.check_circle_outline));
      if (true) {
        await SharedPreferenceHelper.onUserLogout();
        widget.fetchSharedPreferenceData();
      }
    });
  }
}


