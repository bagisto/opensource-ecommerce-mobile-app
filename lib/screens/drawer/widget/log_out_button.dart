/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';


// ignore: must_be_immutable
class LogoutButton extends StatefulWidget {
  AccountInfoModel? customerDetails;
  final dynamic fetchSharedPreferenceData;
  LogoutButton({Key? key, this.customerDetails, this.fetchSharedPreferenceData})
      : super(key: key);

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
        color: Theme.of(context).colorScheme.onBackground,
        elevation: 0.0,
        textColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        onPressed: () {
          checkInternetConnection().then((value) {
            if (value) {
              _onPressedLogout();
            } else {
              ShowMessage.errorNotification(StringConstants.internetIssue.localized(), context);
            }
          });
        },
        child: Text(
          StringConstants.logOutTitle.localized().toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
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
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            StringConstants.logOutTitle.localized(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Text(
            StringConstants.logOutWarningMsg.localized(),
            style: Theme.of(context).textTheme.bodyMedium,
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
                  widget.customerDetails = null;
                  _onPressConfirmLogout();
                },
                child: Text(StringConstants.yes.localized(),
                  style: Theme.of(context).textTheme.bodyMedium)),
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
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.all(AppSizes.spacingWide),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height:AppSizes.spacingMedium),
                  const Loader(),
                  const SizedBox(height:AppSizes.spacingWide),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Center(
                      child: Text(StringConstants.processWaitingMsg.localized(),
                        softWrap: true,
                      ),
                    ),
                  ),
                  const SizedBox(height:AppSizes.spacingMedium),
                ],
              ),
            ),
          );
        });
    HomePageRepositoryImp().callLogoutApi().then((response) async {
      Navigator.pop(context);
      Navigator.pop(context);
      ShowMessage.successNotification(response?.message ?? "", context);
      if (true) {
        appStoragePref.onUserLogout();
        widget.fetchSharedPreferenceData();
      }
    });
  }
}
