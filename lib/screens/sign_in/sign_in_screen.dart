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
import 'package:bagisto_app_demo/data_model/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/utils/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'bloc/sign_in_bloc.dart';
import 'bloc/fetch_sign_in_event.dart';
import 'bloc/sign_in_state.dart';
import 'package:bagisto_app_demo/utils/index.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with EmailValidator {
  SignInModel? _signInModel;
  final _signInFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  String passwordValue = "";
  String emailValue = "";
  bool showPassword = false;
  SignInBloc? signInBloc;
  late BuildContext mContext;
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
        child: Scaffold(
          appBar: AppBar(
            title: Text(StringConstants.signInWithEmail.localized(),style: Theme.of(context).textTheme.titleLarge),
            centerTitle: false,
            scrolledUnderElevation: 0.0,
            elevation: 2.0,
          ),
          body: _signInBloc(context),
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
        mContext = context;
        if (state is FetchSignInState) {
          if (state.status == SignInStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == SignInStatus.success) {
            _signInModel = state.signInModel;
            successMsg = state.successMsg;
            if (_signInModel?.data != null) {
              Future.delayed(const Duration(seconds: 3)).then((value) async {
                await SharedPreferenceHelper.setCustomerLoggedIn(true);
                await SharedPreferenceHelper.setCustomerName(
                    _signInModel?.data?.name ?? "");
                await SharedPreferenceHelper.setCustomerEmail(
                    _signInModel?.data?.email ?? "");
                await SharedPreferenceHelper.setCustomerToken(
                    _signInModel?.token ?? "");
                await SharedPreferenceHelper.setCustomerId(
                    int.parse(_signInModel?.data?.id ?? ""));
                await SharedPreferenceHelper.setCustomerImage(_signInModel?.data?.imageUrl ?? "");
                checkFingerprint();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    home, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        } else if (state is SocialLoginState) {
          if (state.status == SignInStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == SignInStatus.success) {
            _signInModel = state.signInModel;
            successMsg = state.successMsg;
            if (_signInModel?.data != null) {
              Future.delayed(const Duration(seconds: 3)).then((value) async {
                await SharedPreferenceHelper.setCustomerLoggedIn(true);
                await SharedPreferenceHelper.setCustomerName(
                    _signInModel?.data?.name ?? "");
                await SharedPreferenceHelper.setCustomerEmail(
                    _signInModel?.data?.email ?? "");
                await SharedPreferenceHelper.setCustomerToken(
                    _signInModel?.token ?? "");
                await SharedPreferenceHelper.setCustomerId(
                    int.parse(_signInModel?.data?.id ?? ""));

                checkFingerprint();
                // _updateSharedPreferences(_signInModel!);
                //  Navigator.of(context).pushNamedAndRemoveUntil(Home, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
      builder: (BuildContext context, SignInBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///Sign in UI methods
  Widget buildUI(BuildContext context, SignInBaseState state) {
    if (state is FetchSignInState) {
      if (state.status == SignInStatus.success) {
        _signInModel = state.signInModel;
        if (_signInModel?.data != null) {
          // _updateSharedPreferences(_signInModel!);
        }
      }
      if (state.status == SignInStatus.fail) {}
    } else if (state is SocialLoginState) {
      if (state.status == SignInStatus.success) {
        _signInModel = state.signInModel;
        if (_signInModel?.data != null) {
          // _updateSharedPreferences(_signInModel!);
        }
      }
      if (state.status == SignInStatus.fail) {}
    }

    if (state is InitialState) {}

    return _form();
  }

  ///login ui form
  _form() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingWide),
            child: Form(
              key: _signInFormKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets().getTextField(
                      context, emailController, StringConstants.signInEmailHint.localized(),
                      label: StringConstants.signInEmailLabel.localized(),
                      isRequired: true, validator: (email) {
                    if (email!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.signInEmailLabel.localized();
                    } else if (!isValidEmail(email)) {
                      return StringConstants.validEmailLabel.localized();
                    }
                    return null;
                  },
                      validLabel: StringConstants.validEmailLabel.localized(),
                      emailValue: emailValue),
                  const SizedBox(height: AppSizes.spacingWide),
                  CommonWidgets().getTextField(context, passwordController,
                      StringConstants.signInPasswordHint.localized(),
                      label: StringConstants.signInPasswordLabel.localized(),
                      isRequired: true, validator: (password) {
                    if (password!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.signInPasswordLabel.localized();
                    } else if (password.length < 6) {
                      return StringConstants.validPasswordLabel.localized();
                    }
                    return null;
                  },
                      validLabel: StringConstants.validPasswordLabel.localized(),
                      emailValue: passwordValue,
                      showPassword: showPassword,
                      suffixIcon: IconButton(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(forgotPassword);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text("${StringConstants.forgetPassword.localized()}?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.blueAccent)),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    elevation: 0.0,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width,
                    color: MobikulTheme.accentColor,
                    textColor: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      _onPressSignInButton();
                    },
                    child: Text(
                        StringConstants.signIn.localized().toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      side: BorderSide(
                          color: MobikulTheme.accentColor),
                    ),
                    elevation: 0.0,
                    height: AppSizes.buttonHeight,
                    minWidth: MediaQuery.of(context).size.width,
                    color: MobikulTheme.primaryColor,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pushNamed(context, signUp, arguments: false);
                    },
                    child: Text(
                        StringConstants.createAnAccount.localized().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium),
                  ),
                  const SizedBox(height: AppSizes.spacingWide),
                  // Center(child: SocialLogin(signInBloc)),
                  if ((appStoragePref.getFingerPrintUser() ?? "").isNotEmpty)
                    Center(
                      child: InkWell(
                        child: LottieBuilder.asset(
                          AssetConstants.fingerPrintLoginLottie,
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          startAuthentication(false);
                        },
                      ),
                    ),
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
                  AppSizes.spacingMedium,
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
            ? ShowMessage.successNotification(
                _signInModel?.success ?? "", context)
            : ShowMessage.successNotification(successMsg ?? "", context);
        Navigator.of(mContext)
            .pushNamedAndRemoveUntil(home, (Route<dynamic> route) => false);
      }
    });
  }

  void showFingerprintDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(StringConstants.fingerPrint.localized()),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MobikulTheme.accentColor),
                  onPressed: () {
                    _signInModel?.data != null
                        ? ShowMessage.successNotification(
                            _signInModel?.success ?? "", context)
                        : ShowMessage.successNotification(
                            successMsg ?? "", context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        home, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    StringConstants.cancelLbl.localized(),
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
                    StringConstants.ok.localized(),
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
            localizedReason: StringConstants.fingerPrintLogin.localized());
        if (didAuthenticate) {
          if (alreadyLogin) {
            appStoragePref.setFingerPrintUser(emailController.text);
            appStoragePref.setFingerPrintPassword(passwordController.text);
            _signInModel?.data != null
                ? ShowMessage.successNotification(
                    _signInModel?.success ?? "", context)
                : ShowMessage.successNotification(successMsg ?? "", context);
            Navigator.of(mContext)
                .pushNamedAndRemoveUntil(home, (Route<dynamic> route) => false);
          } else {
            signInBloc?.add(FetchSignInEvent(
                email: appStoragePref.getFingerPrintUser() ?? "",
                password: appStoragePref.getFingerPrintPassword() ?? ""));
            Navigator.of(mContext)
                .pushNamedAndRemoveUntil(home, (Route<dynamic> route) => false);
          }
        } else {
          ShowMessage.errorNotification(
              StringConstants.authenticationFailed.localized(), context);
        }
      } else {
        ShowMessage.errorNotification(
            StringConstants.authenticationFailed.localized(), context);
      }
    });
  }
}
