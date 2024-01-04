// import 'package:bagisto_app_demo/data_model/sign_in_model/social_login_model.dart';
// import 'package:bagisto_app_demo/screens/sign_in/bloc/sign_in_bloc.dart';
// import 'package:bagisto_app_demo/screens/sign_in/bloc/fetch_sign_in_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:bagisto_app_demo/utils/index.dart';
// import 'dart:io';
//
// class SocialLogin extends StatelessWidget {
//   final SignInBloc? bloc;
//
//   const SocialLogin(this.bloc, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(AppSizes.spacingMedium),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ///Google Login
//           GestureDetector(
//               onTap: () async {
//                 var result = await socialSignIn.handleGoogleSignIn(context);
//                 debugPrint("TEST_LOG==> result ==> $result");
//                 if (result != null) {
//                   var socialLoginModel = SocialLoginModel.empty();
//                   socialLoginModel.id = result.id;
//                   socialLoginModel.email = result.email ;
//                   socialLoginModel.firstName = result.displayName ?? "";
//                   socialLoginModel.lastName = "";
//                   socialLoginModel.isSocial = 1;
//                   String fullName = result.displayName ?? "";
//                   var names = fullName.split(' ');
//                   String firstName = names[0];
//                   String lastName = names[1];
//                   bloc?.add(SocialLoginEvent(
//                       email: result.email,
//                       firstName: firstName,
//                       lastName: lastName,
//                       phone: ""));
//                 }
//               },
//               child: SizedBox(
//                 height: AppSizes.itemHeight,
//                 width: AppSizes.itemHeight,
//                 child: Image.asset("assets/images/google.png"),
//               )),
//           const SizedBox(width: AppSizes.spacingMedium),
//
//           ///Apple login
//           if (Platform.isIOS)
//             GestureDetector(
//                 onTap: () async {
//                   const platform = MethodChannel("com.webkul.bagisto/channel");
//                   var result = await platform.invokeMethod("appleSignin");
//                   if (result != null) {
//                     // bloc?.add(const LoadingEvent());
//                     var request = SocialLoginModel(
//                         firstName: result["firstname"],
//                         lastName: result["lastname"] ?? result["firstname"],
//                         email: result["email"],
//                         id: result['id'],
//                         photoUrl: '',
//                         serverAuthCode: result['id'],
//                         authProvider: "GMAIL");
//
//                     bloc?.add(SocialLoginEvent(
//                       email: request.email,
//                       firstName: request.firstName,
//                       lastName: request.lastName,
//                     ));
//                     // bloc?.emit(LoadingState());
//                   }
//                 },
//                 child: SizedBox(
//                     child: SizedBox(
//                   height: 34,
//                   width: 34,
//                   child: Image.asset(
//                       (Theme.of(context).brightness == Brightness.light)
//                           ? "assets/images/apple_icon.png"
//                           : "assets/images/apple_icon_dark.png"),
//                 ))),
//
//           if (Platform.isIOS) const SizedBox(width: AppSizes.spacingMedium),
//
//           //Facebook Login
//           GestureDetector(
//               onTap: () async {
//                 print("TEST LOG");
//                 var result = await socialSignIn.handleFacebookSignIn(context);
//                 var profile = await socialSignIn.facebookLogin.getUserProfile();
//                 if (result?.status == FacebookLoginStatus.success) {
//                   debugPrint("TEST LOG======${result.toString()}");
//                   var email = await socialSignIn.facebookLogin.getUserEmail();
//                   var socialLoginModel = SocialLoginModel.empty();
//                   socialLoginModel.id = result?.accessToken?.token ?? "";
//                   socialLoginModel.email = email;
//                   socialLoginModel.firstName = profile?.firstName ?? "";
//                   socialLoginModel.lastName =
//                       profile?.lastName ?? (profile?.firstName ?? "");
//                   bloc?.add(SocialLoginEvent(
//                       email: email,
//                       firstName: profile?.firstName ?? "",
//                       lastName: profile?.lastName ?? "",
//                       phone: ""));
//                 }
//                 socialSignIn.signOut();
//               },
//               child: SizedBox(
//                 height: AppSizes.itemHeight,
//                 width: AppSizes.itemHeight,
//                 child: Image.asset("assets/images/facebook.png"),
//               ))
//         ],
//       ),
//     );
//   }
// }
//
// class SocialSignIn {
//   final _googleSignin = GoogleSignIn();
//   final facebookLogin = FacebookLogin();
//   AuthProvider provider = AuthProvider.none;
//
//   Future<GoogleSignInAccount?> handleGoogleSignIn(BuildContext context) async {
//     try {
//       var data = await _googleSignin.signIn();
//       provider = AuthProvider.gmail;
//       debugPrint("TEST_LOG==> displayName ==> ${data?.displayName}");
//       debugPrint("TEST_LOG==> displayName ==> ${data?.serverAuthCode}");
//       return data;
//     } on PlatformException catch (error) {
//       // print(error.code)
//       debugPrint("TEST_LOG==> error.code ==> ${error.code}");
//       debugPrint("TEST_LOG==> error ==> $error");
//     }
//     return null;
//   }
//
//   Future<FacebookLoginResult?> handleFacebookSignIn(
//       BuildContext context) async {
//     try {
//       var result = await facebookLogin.logIn(permissions: [
//         FacebookPermission.email,
//       ]);
//       print(result.status);
//       print(await facebookLogin.accessToken);
//       if ((await facebookLogin.isLoggedIn)) {
//         print(await facebookLogin.getUserEmail());
//       }
//       provider = AuthProvider.facebook;
//       return result;
//     } catch (error, stk) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ShowMessage.warningNotification(error.toString(),context);
//       });
//       print(stk);
//       return null;
//     }
//   }
//
//   void signOut() async {
//     switch (provider) {
//       case AuthProvider.facebook:
//         // facebookLogin.logOut();
//         break;
//       case AuthProvider.gmail:
//         _googleSignin.signOut();
//         break;
//       default:
//         break;
//     }
//   }
// }
//
// enum AuthProvider { facebook, gmail, none }
//
// final socialSignIn = SocialSignIn();
