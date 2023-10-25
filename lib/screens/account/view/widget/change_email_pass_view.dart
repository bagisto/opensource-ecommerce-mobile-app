import 'package:bagisto_app_demo/screens/account/view/widget/account_index.dart';
import 'package:flutter/cupertino.dart';
import '../account_screen.dart';

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
            child: InkWell(
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
                    "ChangeEmail".localized(),
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
                  "SignInEmailLabel".localized(),
                  "SignInEmailHint".localized(),
                  "PleaseFillLabel".localized() +
                      "SignInEmailLabel".localized(),
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "PleaseFillLabel".localized() +
                          "SignInEmailLabel".localized();
                    } else if (!isValidEmail(email)) {
                      return "ValidEmailLabel".localized();
                    }
                    return null;
                  },
                  validLabel: "ValidEmailLabel".localized(),
                ),
              )
            : const Center(),
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
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
                    "ChangePassword".localized(),
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
                      "CurrentPassword".localized(),
                      "EnterCurrentPassword".localized(),
                      "PleaseFillLabel".localized() +
                          "CurrentPassword".localized(),
                      validator: (password) {
                        if (password!.trim().isEmpty) {
                          return "FillCurrentPassword".localized();
                        } else if (password.trim().length < 6) {
                          return "CurrentPasswordWarning".localized();
                        }
                        return null;
                      },
                      validLabel: "CurrentPasswordWarning",
                      showPassword: _showCurrentPassword,
                      iconButton: IconButton(
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
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        newPasswordController,
                        "NewPassword".localized(),
                        "EnterNewPassword".localized(),
                        "PleaseFillLabel".localized() +
                            "NewPassword".localized(), validator: (password) {
                      if (password!.trim().isEmpty) {
                        return "FillNewPassword".localized();
                      } else if (password.trim().length < 6) {
                        return "NewPasswordWarning".localized();
                      }
                      return null;
                    },
                        validLabel: "NewPasswordWarning".localized(),
                        showPassword: _showNewPassword,
                        iconButton: IconButton(
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
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        confirmNewPasswordController,
                        "ConfirmPasswordLabel".localized(),
                        "ConfirmPasswordHint".localized(),
                        "PleaseFillLabel".localized() +
                            "ConfirmPasswordLabel".localized(),
                        validator: (confirmPassword) {
                      if (confirmPassword!.trim().isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "ConfirmPasswordLabel".localized();
                      } else if (confirmPassword.trim().length < 6) {
                        return "ValidPasswordLabel".localized();
                      } else if (confirmPassword.trim() !=
                          newPasswordController.text.trim()) {
                        return "MatchPassword".localized();
                      }
                      return null;
                    },
                        validLabel: "ValidPasswordLabel".localized(),
                        showPassword: _showConfirmPassword,
                        iconButton: IconButton(
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
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
          child: InkWell(
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
                  width: 8,
                ),
                Text(
                  "deleteAccount".localized(),
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
          title: Column(
            children: [
              Text(
                "deleteAccountMsg".localized(),
              ),
              const SizedBox(
                height: 12,
              ),
              CommonWidgets().getTextField(
                context,
                deleteAccountPassword,
                "CurrentPassword".localized(),
                "EnterCurrentPassword".localized(),
                "PleaseFillLabel".localized() + "CurrentPassword".localized(),
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
                "ButtonLabelNO".localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  if (deleteAccountPassword.text != "" &&
                      deleteAccountPassword.text.isNotEmpty) {
                    _onPressYesDeleteAccount();
                  } else {
                    ShowMessage.showNotification(
                        "FillCurrentPassword".localized(),
                        "",
                        Colors.yellow,
                        const Icon(Icons.warning_amber));
                  }
                },
                child: Text(/*ButtonLabelYes*/
                    "ButtonLabelYes".localized()))
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
            backgroundColor: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(AppSizes.widgetSidePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: AppSizes.normalHeight,
                  ),
                  CircularProgressIndicatorClass.circularProgressIndicator(
                      context),
                  const SizedBox(
                    height: AppSizes.widgetHeight,
                  ),
                  const SizedBox(
                    height: AppSizes.normalHeight,
                  ),
                ],
              ),
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
