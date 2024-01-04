/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/forget_password_bloc.dart';
import 'bloc/forget_password_fetch_event.dart';
import 'bloc/forget_password_fetch_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with EmailValidator {
  final emailController = TextEditingController();
  String emailValue = "";
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _forgetPasswordKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  ForgetPasswordBloc? forgetPasswordBloc;

  @override
  void initState() {
    forgetPasswordBloc = context.read<ForgetPasswordBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.forgetPassword.localized()),
          centerTitle: false,
        ),
        body:Directionality(
          textDirection: GlobalData.contentDirection(),
          child: _forgetPasswordBloc(context) ,
        ),
      ),
    );
  }

  ///forget Password in Bloc Container
  _forgetPasswordBloc(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordBaseState>(
      listener: (BuildContext context, ForgetPasswordBaseState state) {
        if (state is ForgetPasswordFetchState) {
          if (state.status == ForgetPasswordStatus.fail) {
            ShowMessage.errorNotification( state.successMsg ?? "",context);
            Future.delayed(const Duration(seconds: 3)).then((value) {
              Navigator.of(context).pop();
            });
          } else if (state.status == ForgetPasswordStatus.success) {
            debugPrint("password status --> ${state.baseModel?.toJson()}");
            GraphQlBaseModel? baseModel = state.baseModel;
            (baseModel?.error != null || baseModel?.status==false)
                ? ShowMessage.errorNotification(state.baseModel?.success ?? "",context)
                : ShowMessage.successNotification(
                    state.baseModel?.success ?? "",context);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              Navigator.of(context).pop();
            });
          }
        }
      },
      builder: (BuildContext context, ForgetPasswordBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///Sign in UI methods
  Widget buildUI(BuildContext context, ForgetPasswordBaseState state) {
    if (state is ForgetPasswordFetchState) {
      if (state.status == ForgetPasswordStatus.success) {
        return _form();
      }
      if (state.status == ForgetPasswordStatus.fail) {
        return _form();
      }
    }

    if (state is ForgetPassWordInitialState) {
      return _form();
    }

    return const SizedBox();
  }

  /// ui form
  _form() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spacingSmall,
            horizontal: AppSizes.spacingWide),
        child: Form(
          key: _forgetPasswordKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().priceText(StringConstants.forgetPasswordTitle.localized(),context),
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
                  return StringConstants.validEmailLabel.localized();
                }
                return null;
              },
                  validLabel: StringConstants.validEmailLabel.localized(),
                  emailValue: emailValue),
              const SizedBox(height: AppSizes.spacingWide),
              MaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    side: BorderSide(width: 2)),
                elevation: 0.0,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.onBackground,
                textColor: Colors.white,
                onPressed: () {
                  _onPressButton();
                },
                child: Text(
                  StringConstants.forgetPasswordButton.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.background
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///on press  button
  _onPressButton() {
    if (_forgetPasswordKey.currentState!.validate()) {
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
                    const SizedBox(
                      height: AppSizes.spacingWide,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          StringConstants.processWaitingMsg.localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                  ],
                ),
              ),
            );
          });

      forgetPasswordBloc?.add(ForgetPasswordFetchEvent(
        email: emailController.text,
      ));
    }
  }
}
