/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/email_validator.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base_model/graphql_base_model.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../configuration/app_global_data.dart';
import '../bloc/forget_password_bloc.dart';
import '../event/forget_password_fetch_event.dart';
import '../state/forget_password_base_state.dart';
import '../state/forget_password_fetch_state.dart';
import '../state/forget_password_initial_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>with EmailValidator {
  final emailController = TextEditingController();
  String emailValue = "";
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _forgetPasswordKey = GlobalKey<FormState>();
  final bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          title: CommonWidgets.getHeadingText(
              "ForgetPassword".localized(),context),
         centerTitle: false,
        ),
        body:  Directionality(
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
            ShowMessage.showNotification("Failed", state.successMsg??"",
                Colors.red, const Icon(Icons.cancel_outlined));
            Future.delayed(const Duration(seconds: 3)).then((value) {
              Navigator.of(context).pop();
            });
          } else if (state.status == ForgetPasswordStatus.success) {

            GraphQlBaseModel? baseModel=state.baseModel!;
            baseModel.error !=null?
            ShowMessage.showNotification(state.baseModel?.error,"",
                Colors.red, const Icon(Icons.cancel_outlined))
                :
            ShowMessage.showNotification(state.baseModel?.success,"",
                const Color.fromRGBO(140,194,74,5), const Icon(Icons.check_circle_outline));
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

    return Container();
  }

  /// ui form
  _form() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:AppSizes.normalHeight, horizontal: AppSizes.widgetSidePadding),
        child: Form(
          key: _forgetPasswordKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().priceText( "forgetPasswordTitle".localized()),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetSidePadding),
              CommonWidgets().getTextField(context,
                  emailController,
               "SignInEmailLabel".localized(),
            "SignInEmailHint".localized(),
                "PleaseFillLabel".localized() +
                      "SignInEmailLabel".localized(),validator: (email) {
                if (email!.isEmpty) {
                  return "PleaseFillLabel".localized()+
                      "SignInEmailLabel".localized();
                } else if (!isValidEmail(email)) {
                  return "ValidEmailLabel".localized();
                }
                return null;
              },

                  validLabel: "ValidEmailLabel".localized(),
                  emailValue: emailValue),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetSidePadding),
              MaterialButton(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    side: BorderSide(
                        width: 2
                    )),
                elevation: 0.0,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                textColor: MobikulTheme.primaryColor,
                onPressed: () {
                  _onPressButton();
                },
                child: Text(
                 "ForgetPasswordButton".localized()
                      .toUpperCase(),
                  style: const TextStyle(fontSize:AppSizes.normalFontSize),
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
                padding: const EdgeInsets.all( AppSizes.widgetSidePadding,),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height:  AppSizes.normalHeight,
                    ),
                CircularProgressIndicatorClass.circularProgressIndicator(context),
                    const SizedBox(
                      height: AppSizes.widgetSidePadding,
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
                      height: AppSizes.normalHeight,
                    ),
                  ],
                ),
              ),
            );
          });

      ForgetPasswordBloc forgetPasswordBloc = context.read<ForgetPasswordBloc>();
      forgetPasswordBloc.add(ForgetPasswordFetchEvent(
          email: emailController.text, ));


    }
  }
}
