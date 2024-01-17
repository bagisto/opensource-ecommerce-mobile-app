import 'package:bagisto_app_demo/screens/account/bloc/account_info_bloc.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_details_event.dart';
import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:flutter/cupertino.dart';
import '../../../utils/index.dart';

class ChangeEmailAndPassword extends StatefulWidget {
  const ChangeEmailAndPassword({Key? key}) : super(key: key);

  @override
  State<ChangeEmailAndPassword> createState() => _ChangeEmailAndPasswordState();
}

class _ChangeEmailAndPasswordState extends State<ChangeEmailAndPassword>
    with EmailValidator {
  bool _changeEmail = false;
  bool _showCurrentPassword = false;
  bool _isChangePassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    _isChangePassword = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _changeEmail = !_changeEmail;
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.email,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    StringConstants.changeEmail.localized(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ]),
        _changeEmail
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonWidgets().getTextField(
                  context,
                  emailController,
                  StringConstants.signInEmailHint.localized(),
                  label: StringConstants.signInEmailLabel.localized(),
                  isRequired: true,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.signInWithEmail.localized();
                    } else if (!isValidEmail(email)) {
                      return StringConstants.validEmailLabel.localized();
                    }
                    return null;
                  },
                  validLabel: StringConstants.validEmailLabel.localized(),
                ),
              )
            : const Center(),
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isChangePassword = !_isChangePassword;
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    StringConstants.changePassword.localized(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isChangePassword
              ? Column(
                  children: [
                    CommonWidgets().getTextField(
                      context,
                      currentPasswordController,
                      StringConstants.enterCurrentPassword.localized(),
                      label: StringConstants.currentPassword.localized(),
                      validator: (password) {
                        if (password!.trim().isEmpty) {
                          return StringConstants.fillCurrentPassword.localized();
                        } else if (password.trim().length < 6) {
                          return StringConstants.currentPasswordWarning.localized();
                        }
                        return null;
                      },
                      validLabel: StringConstants.currentPasswordWarning,
                      showPassword: _showCurrentPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          setState(() {
                            _showCurrentPassword = !_showCurrentPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CommonWidgets().getTextField(context, newPasswordController,
                        StringConstants.enterNewPassword.localized(),
                        label: StringConstants.newPassword.localized(),
                        validator: (password) {
                      if (password!.trim().isEmpty) {
                        return StringConstants.fillNewPassword.localized();
                      } else if (password.trim().length < 6) {
                        return StringConstants.newPasswordWarning.localized();
                      }
                      return null;
                    },
                        validLabel: StringConstants.newPasswordWarning.localized(),
                        showPassword: _showNewPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          },
                        )),
                    const SizedBox(height: 20.0),
                    CommonWidgets().getTextField(
                        context,
                        confirmNewPasswordController,
                        StringConstants.confirmPasswordHint.localized(),
                        label: StringConstants.confirmPassword.localized(),
                        validator: (confirmPassword) {
                      if (confirmPassword!.trim().isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.confirmPassword.localized();
                      } else if (confirmPassword.trim().length < 6) {
                        return StringConstants.validPasswordLabel.localized();
                      } else if (confirmPassword.trim() !=
                          newPasswordController.text.trim()) {
                        return StringConstants.matchPassword.localized();
                      }
                      return null;
                    },
                        validLabel: StringConstants.validPasswordLabel.localized(),
                        showPassword: _showConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        )),
                  ],
                )
              : const Center(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
          child: GestureDetector(
            onTap: () {
              _onPressDeleteAccount();
            },
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  StringConstants.deleteAccount.localized(),
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _onPressDeleteAccount() {
    deleteAccountPassword.text = "";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title:
              Text(
                StringConstants.deleteAccount.localized()
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  StringConstants.deleteAccountMsg.localized()),
              const SizedBox(height: AppSizes.spacingWide),
              CommonWidgets().getTextField(
                context,
                deleteAccountPassword,
                StringConstants.enterCurrentPassword.localized(),
                label: StringConstants.currentPassword.localized(),
                showPassword: false,
              ),
            ],
          ),
          actions: <Widget>[
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
                  if (deleteAccountPassword.text != "" &&
                      deleteAccountPassword.text.isNotEmpty) {
                    _onPressYesDeleteAccount();
                  } else {
                    ShowMessage.warningNotification(
                        StringConstants.validPasswordLabel.localized(),context);
                  }
                },
                child: Text(
                    StringConstants.yes.localized(),style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }

  _onPressYesDeleteAccount() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: AppSizes.spacingMedium,
                ),
                CircularProgressIndicatorClass.circularProgressIndicator(
                    context),
                const SizedBox(height:AppSizes.spacingWide),
                const SizedBox(
                  height: AppSizes.spacingMedium,
                ),
              ],
            ),
          );
        });
    AccountInfoBloc accountInfoBloc = context.read<AccountInfoBloc>();
    if (deleteAccountPassword.text.isNotEmpty) {
      accountInfoBloc.add(AccountInfoDeleteEvent(
        password: deleteAccountPassword.text,
      ));
    }
  }
}
