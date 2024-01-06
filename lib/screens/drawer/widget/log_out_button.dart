import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import '../../../data_model/account_models/account_info_details.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/show_message.dart';
import '../../home_page/bloc/home_page_repository.dart';

// ignore: must_be_immutable
class LogoutButton extends StatefulWidget {
  AccountInfoDetails? customerDetails;
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
        textColor: Theme.of(context).colorScheme.background,
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
            color: Theme.of(context).colorScheme.background
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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
              color: Theme.of(context).appBarTheme.backgroundColor,
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
      ShowMessage.successNotification(response?.success ?? "", context);
      if (true) {
        await SharedPreferenceHelper.onUserLogout();
        widget.fetchSharedPreferenceData();
      }
    });
  }
}
