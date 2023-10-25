import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/sign_in_model/social_login_model.dart';
import '../bloc/sign_in_bloc.dart';
import '../events/fetch_sign_in_event.dart';
import 'dart:io';

class SocialLogin extends StatelessWidget {
  final SignInBloc? bloc;

  const SocialLogin(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.normalFontSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///Google Login
          GestureDetector(
              onTap: () async {
                var result = await socialSignIn.handleGoogleSignIn(context);
                if (result != null) {
                  var socialLoginModel = SocialLoginModel.empty();
                  socialLoginModel.id = result.id;
                  socialLoginModel.email = result.email;
                  socialLoginModel.firstName = result.displayName ?? "";
                  socialLoginModel.lastName = "";
                  socialLoginModel.isSocial = 1;
                  String fullName = result.displayName ?? "";
                  var names = fullName.split(' ');
                  String firstName = names[0];
                  String lastName = names[1];
                  bloc?.add(SocialLoginEvent(
                      email: result.email,
                      firstName: firstName,
                      lastName: lastName,
                      phone: ""));
                }
              },
              child: SizedBox(
                height: AppSizes.itemHeight,
                width: AppSizes.itemHeight,
                child: Image.asset("assets/images/google.png"),
              )),
          const SizedBox(width: AppSizes.normalFontSize),

          ///Apple login
          if (Platform.isIOS)
            GestureDetector(
                onTap: () async {
                  const platform = MethodChannel("com.webkul.bagisto/channel");
                  var result = await platform.invokeMethod("appleSignin");
                  if (result != null) {
                    // bloc?.add(const LoadingEvent());
                    var request = SocialLoginModel(
                        firstName: result["firstname"],
                        lastName: result["lastname"] ?? result["firstname"],
                        email: result["email"],
                        id: result['id'],
                        photoUrl: '',
                        serverAuthCode: result['id'],
                        authProvider: "GMAIL");

                    bloc?.add(SocialLoginEvent(
                      email: request.email,
                      firstName: request.firstName,
                      lastName: request.lastName,
                    ));
                  }
                },
                child: SizedBox(
                    child: SizedBox(
                  height: 34,
                  width: 34,
                  child: Image.asset(
                      (Theme.of(context).brightness == Brightness.light)
                          ? "assets/images/apple_icon.png"
                          : "assets/images/apple_icon_dark.png"),
                ))),

          if (Platform.isIOS) const SizedBox(width: AppSizes.normalFontSize),

          //Facebook Login
          GestureDetector(
              onTap: () async {
                var result = await socialSignIn.handleFacebookSignIn(context);
                var profile = await socialSignIn.facebookLogin.getUserProfile();
                if (result?.status == FacebookLoginStatus.success) {
                  debugPrint("TEST LOG======${result.toString()}");
                  var email = await socialSignIn.facebookLogin.getUserEmail();
                  var socialLoginModel = SocialLoginModel.empty();
                  socialLoginModel.id = result?.accessToken?.token ?? "";
                  socialLoginModel.email = email;
                  socialLoginModel.firstName = profile?.firstName ?? "";
                  socialLoginModel.lastName =
                      profile?.lastName ?? (profile?.firstName ?? "");
                  bloc?.add(SocialLoginEvent(
                      email: email,
                      firstName: profile?.firstName ?? "",
                      lastName: profile?.lastName ?? "",
                      phone: ""));
                }
                socialSignIn.signOut();
              },
              child: SizedBox(
                height: AppSizes.itemHeight,
                width: AppSizes.itemHeight,
                child: Image.asset("assets/images/facebook.png"),
              ))
        ],
      ),
    );
  }
}

class SocialSignIn {
  final _googleSignin = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  AuthProvider provider = AuthProvider.none;

  Future<GoogleSignInAccount?> handleGoogleSignIn(BuildContext context) async {
    try {
      var data = await _googleSignin.signIn();
      provider = AuthProvider.gmail;
      return data;
    } on PlatformException catch (error) {
      debugPrint(error.code);
    }
    return null;
  }

  Future<FacebookLoginResult?> handleFacebookSignIn(
      BuildContext context) async {
    try {
      var result = await facebookLogin.logIn(permissions: [
        FacebookPermission.email,
      ]);
      if ((await facebookLogin.isLoggedIn)) {}
      provider = AuthProvider.facebook;
      return result;
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowMessage.showNotification(error.toString(), "", Colors.yellow,
            const Icon(Icons.warning_amber));
      });
      return null;
    }
  }

  void signOut() async {
    switch (provider) {
      case AuthProvider.facebook:
        // facebookLogin.logOut();
        break;
      case AuthProvider.gmail:
        _googleSignin.signOut();
        break;
      default:
        break;
    }
  }
}

enum AuthProvider { facebook, gmail, none }

final socialSignIn = SocialSignIn();
