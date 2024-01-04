/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagisto_app_demo/screens/sign_up/utils/index.dart';

class SignUpScreen extends StatefulWidget {
  final bool? addShopSlug;

  const SignUpScreen({Key? key, this.addShopSlug}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with EmailValidator {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  final _signUpFormKey = GlobalKey<FormState>();
  SignInModel? _signUpModel;
  SignUpBloc? signUpBloc;
  final firstNameController = TextEditingController();
  final addShopSlugController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String trueCallerEmail = "";
  String? phone,firstName,lastName;
  final bool _autoValidate = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    signUpBloc = context.read<SignUpBloc>();
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
            title: Text(StringConstants.createAnAccount.localized(),
                style: Theme.of(context).textTheme.titleLarge),
            centerTitle: false,
            scrolledUnderElevation: 0.0,
            elevation: 2.0,
          ),
          body: _signInBloc(context),
        ),
      ),
    );
  }

  ///SIGN_Up BLOC CONTAINER///
  _signInBloc(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpBaseState>(
      listener: (BuildContext context, SignUpBaseState state) {
        if (state is FetchSignUpState) {
          if (state.status == SignUpStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              Navigator.of(context).pop();
            });
          } else if (state.status == SignUpStatus.success) {
            _signUpModel = state.signUpModel;
            ShowMessage.successNotification(
                state.signUpModel?.success ?? "", context);
            if (_signUpModel?.status == true) {
              Future.delayed(const Duration(seconds: 1)).then((value) {
                _updateSharedPreferences(_signUpModel);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    home, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
      builder: (BuildContext context, SignUpBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///SIGN_UP UI METHODS///
  Widget buildUI(BuildContext context, SignUpBaseState state) {
    if (state is FetchSignUpState) {
      if (state.status == SignUpStatus.success) {
        _signUpModel = state.signUpModel;
        if (_signUpModel != null) {
          _updateSharedPreferences(_signUpModel!);
        }
        return Container();
      }
      if (state.status == SignUpStatus.fail) {
        return _form();
      }
    }
    if (state is InitialSignUpState) {
      return _form();
    }
    return _form();
  }

  ///Sign up ui form
  _form() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingMedium,
              horizontal: AppSizes.spacingMedium),
          child: Form(
            key: _signUpFormKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  firstNameController,
                  label: StringConstants.firstNameLabel.localized(),
                  StringConstants.firstNameHint.localized(),
                  isRequired: true,
                  validator: (firstName) {
                    if (firstName!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.firstNameLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  lastNameController,
                  StringConstants.lastNameHint.localized(),
                  label: StringConstants.lastNameLabel.localized(),
                  isRequired: true,
                  validator: (lastName) {
                    if (lastName!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.lastNameLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  emailController,
                  StringConstants.signInEmailHint.localized(),
                  label: StringConstants.signInEmailLabel.localized(),
                  isRequired: true,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.signInEmailLabel.localized();
                    } else if (!isValidEmail(email)) {
                      return StringConstants.signInEmailLabel.localized();
                    }
                    return null;
                  },
                  validLabel: StringConstants.validEmailLabel.localized(),
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(context, passwordController,
                    StringConstants.signInPasswordHint.localized(),
                    label: StringConstants.signInPasswordLabel.localized(),
                    isRequired: true, validator: (password) {
                  if (password!.trim().isEmpty) {
                    return StringConstants.pleaseFillLabel.localized() +
                        StringConstants.signInPasswordLabel.localized();
                  } else if (password.trim().length < 6) {
                    return StringConstants.signInPasswordLabel.localized();
                  }
                  return null;
                },
                    validLabel: StringConstants.validPasswordLabel.localized(),
                    showPassword: showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(context, confirmPasswordController,
                    StringConstants.confirmPasswordHint.localized(),
                    label: StringConstants.confirmPasswordLabel.localized(),
                    isRequired: true, validator: (confirmPassword) {
                  if (confirmPassword!.trim().isEmpty) {
                    return StringConstants.pleaseFillLabel.localized() +
                        StringConstants.confirmPasswordLabel.localized();
                  } else if (confirmPassword.trim().length < 6) {
                    return StringConstants.validPasswordLabel.localized();
                  } else if (confirmPassword.trim() !=
                      passwordController.text.trim()) {
                    return StringConstants.matchPassword.localized();
                  }
                  return null;
                },
                    validLabel: StringConstants.validPasswordLabel.localized(),
                    showPassword: showConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                    )),
                const SizedBox(height: AppSizes.spacingWide),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 6.0,
                  ),
                  child: Text(
                    StringConstants.signUpConfirmPasswordWarningMsg.localized(),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingWide),
                MaterialButton(
                  elevation: 0.0,
                  height: 48,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Theme.of(context).colorScheme.onBackground,
                  textColor: Theme.of(context).colorScheme.background,
                  onPressed: () {
                    _onPressCreateAccount();
                  },
                  child: Text(
                    StringConstants.createAccountLabel.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.background
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///on press sign up button
  _onPressCreateAccount() {
    if (_signUpFormKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                padding: const EdgeInsets.all(
                  AppSizes.spacingWide,
                ),
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

      signUpBloc?.add(FetchSignUpEvent(
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      ));
    }
  }

  /// method to update data in shared pref
  Future _updateSharedPreferences(SignInModel? signInModel) async {
    await SharedPreferenceHelper.setCustomerLoggedIn(true);
    await SharedPreferenceHelper.setCustomerName(signInModel?.data?.name ?? "");
    await SharedPreferenceHelper.setCustomerEmail(
        signInModel?.data?.email ?? "");
    await SharedPreferenceHelper.setCustomerToken(signInModel?.token ?? "");
    await SharedPreferenceHelper.setCustomerId(
        int.parse(signInModel?.data?.id ?? "2"));
    return true;
  }
}
