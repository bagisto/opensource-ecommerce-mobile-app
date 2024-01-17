/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_bloc.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_detail_state.dart';
import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import '../../../utils/index.dart';
import '../../home_page/utils/fetch_shared_pref_helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

String? customerUserName;
bool isLoggedIn = false;
List<String>? genderValues = [];
int currentGenderValue = 0;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final dobController = TextEditingController();
final emailController = TextEditingController();
final currentPasswordController = TextEditingController();
final deleteAccountPassword = TextEditingController();
final newPasswordController = TextEditingController();
final confirmNewPasswordController = TextEditingController();
final phoneController = TextEditingController();
AccountInfoDetails? _accountInfoDetails;
AccountUpdate? _accountUpdate;
bool isLoad = true;
String? base64string;
AccountInfoBloc? accountInfoBloc;

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class _AccountScreenState extends State<AccountScreen>
    with EmailValidator, PhoneNumberValidator {

  @override
  void initState() {
    isLoad = true;
    currentPasswordController.text = "";
    newPasswordController.text = "";
    confirmNewPasswordController.text = "";
    accountInfoBloc = context.read<AccountInfoBloc>();
    accountInfoBloc?.add(AccountInfoDetailsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(StringConstants.accountInfo.localized()),
          ),
          body: _profileBloc(context),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 2.0,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  _onPressSaveButton();
                },
                child: Text(StringConstants.save.localized().toUpperCase(),
                  style: TextStyle(
                      fontSize: AppSizes.spacingLarge,
                      color: MobikulTheme.primaryColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Profile BLOC CONTAINER///
  _profileBloc(BuildContext context) {
    return BlocConsumer<AccountInfoBloc, AccountInfoBaseState>(
      listener: (BuildContext context, AccountInfoBaseState state) {
        if (state is AccountInfoUpdateState) {
          if (state.status == AccountStatus.fail) {
            ShowMessage.errorNotification(StringConstants.invalidData.localized(),context);
          } else if (state.status == AccountStatus.success) {
            if (state.accountUpdate?.status == true) {
              ShowMessage.successNotification(
                  state.accountUpdate?.message ?? "", context);

              Future.delayed(const Duration(seconds: 2)).then((value) {
                _updateSharedPreferences(_accountUpdate!);
                Navigator.pop(context, true);
              });
            } else {
              Navigator.of(context).pop();
              ShowMessage.errorNotification(
                  state.accountUpdate?.success ?? "",context);
            }
          }
        } else if (state is AccountInfoDeleteState) {
          if (state.status == AccountStatus.fail) {
            ShowMessage.errorNotification(state.successMsg ?? "", context);
          } else if (state.status == AccountStatus.success) {
            if (state.baseModel?.status == true) {
              ShowMessage.successNotification(
                  state.baseModel?.success ?? "", context);
              Navigator.pop(context);
              HomePageRepositoryImp().callLogoutApi().then((response) async {
                Navigator.pop(context);
                Future.delayed(const Duration(seconds: 2)).then((value) async {
                  if (true) {
                    await SharedPreferenceHelper.onUserLogout();
                    _fetchSharedPreferenceData();
                  }
                  return Navigator.pushReplacementNamed(context, home);
                });
              });
            } else {
              Navigator.pop(context);
              Navigator.of(context).pop();
              ShowMessage.warningNotification(
                  state.baseModel?.success ?? "", context);
            }
          }
        }
      },
      builder: (BuildContext context, AccountInfoBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///Profile UI METHODS///
  Widget buildUI(BuildContext context, AccountInfoBaseState state) {
    if (state is AccountInfoDetailState) {
      if ((state.status == AccountStatus.success)) {
        if (isLoad) {
          isLoad = false;
          _accountInfoDetails = state.accountInfoDetails;
          firstNameController.text = _accountInfoDetails?.data?.firstName ?? "";
          lastNameController.text = _accountInfoDetails?.data?.lastName ?? "";
          dobController.text = _accountInfoDetails?.data?.dateOfBirth ?? "";
          phoneController.text = _accountInfoDetails?.data?.phone ?? "";
          emailController.text = _accountInfoDetails?.data?.email ?? "";
        }
      }
      if (state.status == AccountStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "error");
      }
    }
    if (state is AccountInfoUpdateState) {
      if (state.status == AccountStatus.success) {
        _accountUpdate = state.accountUpdate;

        if (_accountUpdate != null) {
          _updateSharedPreferences(_accountUpdate!);
        }
      }
      if (state.status == AccountStatus.fail) {}
    }
    if (state is AccountInfoDeleteState) {
      if (state.status == AccountStatus.success) {}
      if (state.status == AccountStatus.fail) {}
    }

    if (state is InitialAccountState) {
      return const AccountLoaderView();
    }

    return ProfileDetailView(
      formKey: _formKey,
    );
  }

  _fetchSharedPreferenceData() {
    getCustomerLoggedInPrefValue().then((isLogged) {
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            customerUserName = value;
            isLoggedIn = isLogged;
          });
        });
      } else {
        setState(() {
          customerUserName = StringConstants.welcomeGuest.localized();
          isLoggedIn = isLogged;
        });
      }
    });
  }

  ///this method will call on press save button
  _onPressSaveButton() {
    if (_formKey.currentState!.validate()) {
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
                    const SizedBox(
                      height: AppSizes.spacingMedium,
                    ),
                    CircularProgressIndicatorClass.circularProgressIndicator(
                        context),
                    const SizedBox(height: AppSizes.spacingWide),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          StringConstants.processWaitingMsg.localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.spacingMedium,
                    ),
                  ],
                ),
              ),
            );
          });
      accountInfoBloc?.add(AccountInfoUpdateEvent(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: genderValues?[currentGenderValue],
          email: emailController.text,
          dob: dobController.text,
          phone: phoneController.text,
          password: newPasswordController.text,
          confirmPassword: confirmNewPasswordController.text,
          oldPassword: currentPasswordController.text,
          avatar: base64string ?? ""));
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pop(context);
      });
    }
  }

  ///this method will update the changes in the save shared preference data
  Future _updateSharedPreferences(AccountUpdate accountUpdate) async {
    await SharedPreferenceHelper.setCustomerLoggedIn(true);
    await SharedPreferenceHelper.setCustomerName(
        accountUpdate.data?.name ?? "");
    await SharedPreferenceHelper.setCustomerImage(
        accountUpdate.data?.imageUrl ?? "");
    await SharedPreferenceHelper.setCustomerEmail(
        accountUpdate.data?.email ?? "");
    return true;
  }
}
