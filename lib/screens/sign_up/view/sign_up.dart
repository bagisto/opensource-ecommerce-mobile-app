/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, deprecated_member_use
import 'dart:async';
import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/email_validator.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../routes/route_constants.dart';
import '../bloc/sign_up_bloc.dart';
import '../events/fetch_sign_up_event.dart';
import '../state/fetch_sign_up_state.dart';
import '../state/sign_up_base_state.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> with EmailValidator {
  SignInModel? _signUpModel;
  final _signUpFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  SignUpBloc? signUpBloc;
  @override
  void initState() {
    signUpBloc = context.read<SignUpBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:  Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
        appBar: AppBar(
          title: CommonWidgets.getHeadingText(
              "CreateAccountLabel".localized(), context),
          centerTitle: false,
        ),
        body:_signInBloc(context),
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
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
            Future.delayed(const Duration(seconds: 2)).then((value) {
              Navigator.of(context).pop();
            });
          } else if (state.status == SignUpStatus.success) {
            _signUpModel = state.signUpModel;
            ShowMessage.showNotification(
                state.signUpModel!.success ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
            if (_signUpModel?.status == true) {
              Future.delayed(const Duration(seconds: 1)).then((value) {
                _updateSharedPreferences(_signUpModel);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Home, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
      builder: (BuildContext context, SignUpBaseState state) {
        return _form();
      },
    );
  }
  ///Sign up ui form
  _form() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          // color: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.mediumPadding,
              horizontal: AppSizes.widgetHeight),
          child: Form(
            key: _signUpFormKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                CommonWidgets().getTextField(
                  context,
                  firstNameController,
                  "FirstNameLabel".localized(),
                  "FirstNameHint".localized(),
                  "PleaseFillLabel".localized() + "FirstNameLabel".localized(),
                  validator: (firstName) {
                    if (firstName!.isEmpty) {
                      return "PleaseLabel".localized() +
                          "FirstNameHint".localized().toLowerCase();
                    }
                    return null;
                  },
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                CommonWidgets().getTextField(
                  context,
                  lastNameController,
                  "LastNameLabel".localized(),
                  "LastNameHint".localized(),
                  "PleaseFillLabel".localized() + "LastNameLabel".localized(),
                  validator: (lastName) {
                    if (lastName!.isEmpty) {
                      return "PleaseLabel".localized() +
                          "LastNameHint".localized().toLowerCase();
                    }
                    return null;
                  },
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                CommonWidgets().getTextField(
                  context,
                  emailController,
                  "SignInEmailLabel".localized(),
                  "SignInEmailHint".localized(),
                  "PleaseFillLabel".localized() +
                      "SignInEmailLabel".localized(),
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "PleaseLabel".localized() +
                          "SignInEmailHint".localized().toLowerCase();
                    } else if (!isValidEmail(email)) {
                      return "ValidEmailLabel".localized();
                    }
                    return null;
                  },
                  validLabel: "ValidEmailLabel".localized(),
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                CommonWidgets().getTextField(
                    context,
                    passwordController,
                    "SignInPasswordLabel".localized(),
                    "SignInPasswordHint".localized(),
                    "PleaseFillLabel".localized() +
                        "SignInPasswordLabel".localized(),
                    validator: (password) {
                  if (password!.trim().isEmpty) {
                    return "PleaseLabel".localized() +
                        "SignInPasswordHint".localized().toLowerCase();
                  } else if (password.trim().length < 6) {
                    return "ValidPasswordLabel".localized();
                  }
                  return null;
                },
                    validLabel: "ValidPasswordLabel".localized(),
                    showPassword: showPassword,
                    iconButton: IconButton(
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
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                CommonWidgets().getTextField(
                    context,
                    confirmPasswordController,
                    "ConfirmPasswordLabel".localized(),
                    "ConfirmPasswordHint".localized(),
                    "PleaseFillLabel".localized() +
                        "ConfirmPasswordLabel".localized(),
                    validator: (confirmPassword) {
                  if (confirmPassword!.trim().isEmpty) {
                    return "PleaseLabel".localized() +
                        "ConfirmPasswordHint".localized().toLowerCase();
                  } else if (confirmPassword.trim().length < 6) {
                    return "ValidPasswordLabel".localized();
                  } else if (confirmPassword.trim() !=
                      passwordController.text.trim()) {
                    return "MatchPassword".localized();
                  }
                  return null;
                },
                    validLabel: "ValidPasswordLabel".localized(),
                    showPassword: showConfirmPassword,
                    iconButton: IconButton(
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
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 6.0,
                  ),
                  child: Text(
                    "SignUpConfirmPasswordWarningMsg".localized(),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: AppSizes.normalFontSize),
                  ),
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                MaterialButton(
                  elevation: 0.0,
                  height: 48,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Theme.of(context).colorScheme.background,
                  textColor: MobikulTheme.primaryColor,
                  onPressed: () {
                    _onPressCreateAccount();
                  },
                  child: Text(
                    "CreateAccountLabel".localized().toUpperCase(),
                    style: const TextStyle(fontSize: AppSizes.normalFontSize),
                  ),
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
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
                  AppSizes.widgetHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.mediumPadding,
                    ),
                    CircularProgressIndicatorClass.circularProgressIndicator(
                        context),
                    const SizedBox(
                      height: AppSizes.widgetHeight,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          "PleaseWaitProcessingRequest".localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.mediumPadding,
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
        int.parse(signInModel?.data!.id ?? "") );
    return true;
  }
}
