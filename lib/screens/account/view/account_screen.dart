/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/screens/account/utils/index.dart';

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
AccountInfoModel? _accountInfoDetails;
AccountUpdate? _accountUpdate;
bool isLoad = true;
XFile? imageFile;
AccountInfoBloc? accountInfoBloc;
bool subscribeNewsletter = false;
bool isDelete = false;

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
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(StringConstants.accountInfo.localized()),
        ),
        body: _profileBloc(context),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingMedium,
              horizontal: AppSizes.spacingMedium),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacingNormal)),
            elevation: 2.0,
            height: AppSizes.buttonHeight,
            minWidth: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.onBackground,
            onPressed: () {
              _onPressSaveButton();
            },
            child: Text(
              StringConstants.save.localized().toUpperCase(),
              style: TextStyle(
                  fontSize: AppSizes.spacingLarge,
                  color: Theme.of(context).colorScheme.secondaryContainer),
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
            ShowMessage.errorNotification(
                StringConstants.invalidData.localized(), context);
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
                  state.accountUpdate?.graphqlErrors ?? "", context);
            }
          }
        } else if (state is AccountInfoDeleteState) {
          if (state.status == AccountStatus.fail) {
            Navigator.pop(context);
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == AccountStatus.success) {
            if (state.baseModel?.status == true) {
              ShowMessage.successNotification(
                  state.baseModel?.message ?? "", context);
              Navigator.pop(context);
              HomePageRepositoryImp().callLogoutApi().then((response) async {
                Navigator.pop(context);
                Future.delayed(const Duration(seconds: 2)).then((value) async {
                  if (true) {
                    appStoragePref.onUserLogout();
                    _fetchSharedPreferenceData();
                  }
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, home);
                });
              });
            } else {
              Navigator.pop(context);
              Navigator.of(context).pop();
              ShowMessage.warningNotification(
                  state.baseModel?.message ?? "", context);
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
          firstNameController.text = _accountInfoDetails?.firstName ?? "";
          lastNameController.text = _accountInfoDetails?.lastName ?? "";
          dobController.text =
              _accountInfoDetails?.dateOfBirth.toString() ?? "";
          phoneController.text = _accountInfoDetails?.phone ?? "";
          emailController.text = _accountInfoDetails?.email ?? "";
          subscribeNewsletter =
              _accountInfoDetails?.subscribedToNewsLetter ?? false;
        }
      }
      if (state.status == AccountStatus.fail) {
        return const AccountLoaderView();
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

    return SafeArea(
      child: ProfileDetailView(
        formKey: _formKey,
        subsNewsLetter: subscribeNewsletter,
        onChanged: (value) {
          setState(() {
            subscribeNewsletter = value; // Update local state
          });
        }, onDelete: (bool delete) {
          isDelete = delete;
      },
      ),
    );
  }

  _fetchSharedPreferenceData() {
    bool isLogged = appStoragePref.getCustomerLoggedIn();
    if (isLogged) {
      String value = appStoragePref.getCustomerName();
      setState(() {
        customerUserName = value;
        isLoggedIn = isLogged;
      });
    } else {
      setState(() {
        customerUserName = StringConstants.welcomeGuest.localized();
        isLoggedIn = isLogged;
      });
    }
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
                color: Theme.of(context).colorScheme.background,
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
          avatar: isDelete ? 'delete' : imageFile?.path,
          subscribedToNewsLetter: subscribeNewsletter));
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pop(context);
      });
    }
  }

  ///this method will update the changes in the save shared preference data
  _updateSharedPreferences(AccountUpdate accountUpdate) {
    appStoragePref.setCustomerLoggedIn(true);
    appStoragePref.setCustomerName(accountUpdate.data?.name ?? "");
    appStoragePref.setCustomerImage(accountUpdate.data?.imageUrl ?? "");
    appStoragePref.setCustomerEmail(accountUpdate.data?.email ?? "");
    return true;
  }
}
