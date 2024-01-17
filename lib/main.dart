/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// must_be_immutable, void_checks

import 'dart:io';
import 'package:bagisto_app_demo/screens/home_page/data_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';
import 'package:bagisto_app_demo/utils/app_global_data.dart';
import 'package:bagisto_app_demo/utils/app_navigation.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/mobikul_theme.dart';
import 'package:bagisto_app_demo/utils/push_notifications_manager.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:bagisto_app_demo/utils/server_configuration.dart';
import 'package:bagisto_app_demo/utils/shared_preference_helper.dart';
import 'package:bagisto_app_demo/utils/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

String? token;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.toMap()}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  String selectedLanguage = "en";
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  GlobalData.selectedLanguage =
      await SharedPreferenceHelper.getCustomerLanguage();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await initHiveForFlutter();
  hiveRegisterAdapter();
  runApp(
    RestartWidget(
      child: BagistoApp(GlobalData.locale ?? selectedLanguage),
    ),
  );
}

Future<void> hiveRegisterAdapter() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  ///Home Page Model
  Hive.registerAdapter(NewProductsModelAdapter());
  Hive.registerAdapter(NewProductsAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(SellerAdapter());
  Hive.registerAdapter(SellerProductAdapter());
  Hive.registerAdapter(PriceHtmlAdapter());
  Hive.registerAdapter(ProductFlatsAdapter());
  Hive.registerAdapter(ImagesAdapter());
  Hive.registerAdapter(HomeCategoriesAdapter());
  Hive.registerAdapter(GetDrawerCategoriesDataAdapter());
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;
  static restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();
  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

class BagistoApp extends StatefulWidget {
  const BagistoApp(
    this.selectedLanguage, {Key? key,}) : super(key: key);

  final String? selectedLanguage;
  @override
  State<BagistoApp> createState() => _BagistoAppState();
}

class _BagistoAppState extends State<BagistoApp> {
  Locale? _locale;
  String appRoot = splash;

  @override
  void initState() {
    _locale = Locale(GlobalData.locale ?? defaultStoreCode);
    PushNotificationsManager.instance.setUpFirebase(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themeNotifier, child) {
        return MaterialApp(
          theme: MobikulTheme.lightTheme,
          themeMode: ThemeMode.system,
          darkTheme: MobikulTheme.darkTheme,
          initialRoute: appRoot,
          onGenerateRoute: generateRoute,
          title: "Bagisto App",
          debugShowCheckedModeBanner: false,
          supportedLocales: supportedLocale.map((e) => Locale(e)),
          localizationsDelegates: const [
            ApplicationLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocaleLanguage in supportedLocales) {
              if (supportedLocaleLanguage.languageCode ==
                      locale?.languageCode &&
                  supportedLocaleLanguage.countryCode == locale?.countryCode) {
                return supportedLocaleLanguage;
              }
            }
            return supportedLocales.first;
          },
          locale: _locale,
        );
      }),
    ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
