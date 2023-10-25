/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, implementation_imports, deprecated_member_use

import 'dart:async';

import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/email_validator.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/screens/sign_in/view/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../configuration/app_global_data.dart';
import '../../../routes/route_constants.dart';
import '../../recent_product/database.dart';
import '../../recent_product/recent_product_entity.dart';
import '../bloc/sign_in_bloc.dart';
import '../events/fetch_sign_in_event.dart';
import '../state/fetch_sign_in_state.dart';
import '../state/sign_in_base_state.dart';
import 'package:local_auth/local_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with EmailValidator {
  SignInModel? _signInModel;
  final _signInFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final passwordController = TextEditingController(text: "tom123");
  final emailController = TextEditingController(text: "tom@example.com");
  String passwordValue = "";
  String emailValue = "";
  bool showPassword = false;
  SignInBloc? signInBloc;
  late BuildContext mcontext;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String? successMsg;

  @override
  void initState() {
    signInBloc = context.read<SignInBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:  Scaffold(
        appBar: AppBar(
          title: CommonWidgets.getHeadingText(
              "SignInWithEmailLabel".localized(), context),
          centerTitle: false,
        ),
        body:  _signInBloc(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    signInBloc?.close();
    super.dispose();
  }

  ///Sign in Bloc Container
  _signInBloc(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInBaseState>(
      listener: (BuildContext context, SignInBaseState state) {
        mcontext = context;
        if (state is FetchSignInState) {
          if (state.status == SignInStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == SignInStatus.success) {
            _signInModel = state.signInModel;
            successMsg = state.successMsg;
            if (_signInModel?.data != null) {
              Future.delayed(const Duration(seconds: 3)).then((value) async {
                await SharedPreferenceHelper.setCustomerLoggedIn(true);
                await SharedPreferenceHelper.setCustomerName(
                    _signInModel?.data!.name ?? "");
                await SharedPreferenceHelper.setCustomerEmail(
                    _signInModel?.data!.email ?? "");
                await SharedPreferenceHelper.setCustomerToken(
                    _signInModel?.token ?? "");
                await SharedPreferenceHelper.setCustomerId(
                    int.parse(_signInModel?.data!.id ?? ""));
                checkFingerprint();
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        } else if (state is SocialLoginState) {
          if (state.status == SignInStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == SignInStatus.success) {
            _signInModel = state.signInModel;
            successMsg = state.successMsg;
            if (_signInModel?.data != null) {
              Future.delayed(const Duration(seconds: 3)).then((value) async {
                await SharedPreferenceHelper.setCustomerLoggedIn(true);
                await SharedPreferenceHelper.setCustomerName(
                    _signInModel?.data!.name ?? "");
                await SharedPreferenceHelper.setCustomerEmail(
                    _signInModel?.data!.email ?? "");
                await SharedPreferenceHelper.setCustomerToken(
                    _signInModel?.token ?? "");
                await SharedPreferenceHelper.setCustomerId(
                    int.parse(_signInModel?.data!.id ?? ""));
                checkFingerprint();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Home, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
      builder: (BuildContext context, SignInBaseState state) {
        return _form();
      },
    );
  }

  ///login ui form
  _form() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.widgetSidePadding),
            child: Form(
              key: _signInFormKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets().getTextField(
                      context,
                      emailController,
                      "SignInEmailLabel".localized(),
                      "SignInEmailHint".localized(),
                      "PleaseFillLabel".localized() +
                          "SignInEmailLabel".localized(), validator: (email) {
                    if (email!.isEmpty) {
                      return "PleaseLabel".localized() +
                          "SignInEmailHint".localized().toLowerCase();
                    } else if (!isValidEmail(email)) {
                      return "ValidEmailLabel".localized();
                    }
                    return null;
                  },
                      validLabel: "ValidEmailLabel".localized(),
                      emailValue: emailValue),
                  CommonWidgets()
                      .getTextFieldHeight(AppSizes.widgetSidePadding),
                  CommonWidgets().getTextField(
                      context,
                      passwordController,
                      "SignInPasswordLabel".localized(),
                      "SignInPasswordHint".localized(),
                      "PleaseFillLabel".localized() +
                          "SignInPasswordLabel".localized(),
                      validator: (password) {
                    if (password!.isEmpty) {
                      return "PleaseLabel".localized() +
                          "SignInPasswordHint".localized().toLowerCase();
                    } else if (password.length < 6) {
                      return "ValidPasswordLabel".localized();
                    }
                    return null;
                  },
                      validLabel: "ValidPasswordLabel".localized(),
                      emailValue: passwordValue,
                      showPassword: showPassword,
                      iconButton: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                  CommonWidgets().textButton("forgetPassword?".localized(), () {
                    Navigator.pushNamed(context, ForgetPassword);
                  }),
                  CommonWidgets().getTextFieldHeight(10.0),
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    elevation: 0.0,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.background,
                    textColor: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      _onPressSignInButton();
                    },
                    child: Text(
                      "SignInButtonLabel".localized().toUpperCase(),
                      style: const TextStyle(
                          fontSize: AppSizes.normalFontSize,
                          color: Colors.white),
                    ),
                  ),
                  CommonWidgets().getTextFieldHeight(15.0),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    elevation: 0.0,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pushNamed(context, SignUp);
                    },
                    child: Text(
                      "createAccount".localized().toUpperCase(),
                      style: TextStyle(
                        fontSize: AppSizes.normalFontSize,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  CommonWidgets().getTextFieldHeight(
                    AppSizes.widgetHeight,
                  ),
                  if ((appStoragePref.getFingerPrintUser() ?? "").isNotEmpty)
                    Center(
                      child: InkWell(
                        child: LottieBuilder.asset(
                          "assets/lottie/finger_print.json",
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          startAuthentication(false);
                        },
                      ),
                    ),
                  Center(child: SocialLogin(signInBloc)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///on press sign in button
  _onPressSignInButton() {
    if (_signInFormKey.currentState!.validate()) {
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
      signInBloc?.add(FetchSignInEvent(
          email: emailController.text, password: passwordController.text));
    }
  }

  /// Fingerprint Login
  final LocalAuthentication auth = LocalAuthentication(); //----Initialization
  void checkFingerprint() {
    auth.isDeviceSupported().then((value) {
      if (value &&
          ((appStoragePref.getFingerPrintUser() ?? "").isEmpty ||
              (emailController.text).toString() !=
                  (appStoragePref.getFingerPrintUser() ?? ""))) {
        showFingerprintDialog();
      } else {
        (_signInModel?.data != null)
            ? ShowMessage.showNotification(
                _signInModel?.success ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline))
            : ShowMessage.showNotification(
                successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
        Navigator.of(mcontext)
            .pushNamedAndRemoveUntil(Home, (Route<dynamic> route) => false);
      }
    });
  }

  void showFingerprintDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("FingerPrint".localized()),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MobikulTheme.accentColor),
                  onPressed: () {
                    _signInModel?.data != null
                        ? ShowMessage.showNotification(
                            _signInModel?.success ?? "",
                            "",
                            const Color.fromRGBO(140, 194, 74, 5),
                            const Icon(Icons.check_circle_outline))
                        : ShowMessage.showNotification(
                            successMsg ?? "",
                            "",
                            const Color.fromRGBO(140, 194, 74, 5),
                            const Icon(Icons.check_circle_outline));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Home, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    "ButtonLabelCancel".localized(),
                    style: const TextStyle(color: Colors.white),
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MobikulTheme.accentColor),
                  onPressed: () {
                    startAuthentication(true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ButtonLabelOk".localized(),
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }

  void startAuthentication(bool alreadyLogin) async {
    auth.isDeviceSupported().then((value) async {
      if (value) {
        bool didAuthenticate = await auth.authenticate(
            localizedReason: "FingerPrintLogin".localized());
        if (didAuthenticate) {
          if (alreadyLogin) {
            appStoragePref.setFingerPrintUser(emailController.text);
            appStoragePref.setFingerPrintPassword(passwordController.text);
            _signInModel?.data != null
                ? ShowMessage.showNotification(
                    _signInModel?.success ?? "",
                    "",
                    const Color.fromRGBO(140, 194, 74, 5),
                    const Icon(Icons.check_circle_outline))
                : ShowMessage.showNotification(
                    successMsg ?? "",
                    "",
                    const Color.fromRGBO(140, 194, 74, 5),
                    const Icon(Icons.check_circle_outline));
            Navigator.of(mcontext)
                .pushNamedAndRemoveUntil(Home, (Route<dynamic> route) => false);
          } else {
            _onPressSignInButton();
            Navigator.of(mcontext)
                .pushNamedAndRemoveUntil(Home, (Route<dynamic> route) => false);
          }
        } else {
          ShowMessage.showNotification(
              "Failed",
              "AuthenticationFailed".localized(),
              Colors.red,
              const Icon(Icons.cancel_outlined));
        }
      } else {
        ShowMessage.showNotification(
            "Failed",
            "AuthenticationFailed".localized(),
            Colors.red,
            const Icon(Icons.cancel_outlined));
      }
    });
  }
}
