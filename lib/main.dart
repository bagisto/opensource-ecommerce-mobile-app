/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, void_checks

import 'package:bagisto_app_demo/Navigation/app_navigation.dart'
    as app_navigate;
import 'package:bagisto_app_demo/configuration/server_configuration.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/routes/route_constants.dart';

// ignore: depend_on_referenced_packages
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
import 'package:quick_actions/quick_actions.dart';
import 'package:upgrader/upgrader.dart';
import 'configuration/app_global_data.dart';
import 'configuration/mobikul_theme.dart';
import 'helper/shared_preference_helper.dart';
import 'helper/theme_provider.dart';
import 'models/homepage_model/new_product_data.dart';

String? token;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {

  String selectedLanguage = "en";
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  GlobalData.selectedLanguage=await SharedPreferenceHelper.getCustomerLanguage();
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
  await initHiveForFlutter();

  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
// Home Page Model
  Hive.registerAdapter(NewProductsModelAdapter());
  Hive.registerAdapter(NewProductsAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(PriceHtmlAdapter());
  Hive.registerAdapter(ProductFlatsAdapter());
  Hive.registerAdapter(ImagesAdapter());
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
      child: widget.child ?? Container(),
    );
  }
}

class BagistoApp extends StatefulWidget {
  BagistoApp(
    this.selectedLanguage, {
    Key? key,
  }) : super(key: key);
  String? selectedLanguage;

  @override
  State<BagistoApp> createState() => _BagistoAppState();
}

class _BagistoAppState extends State<BagistoApp> {
  QuickActions quickActions = const QuickActions();
  Locale? _locale;
  String appRoot = Splash;

  @override
  void initState() {
    _locale =  Locale(GlobalData.locale??defaultStoreCode);
    getToken();
    getSubscription();
    super.initState();
  }

  getToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = fcmToken;
    });
    debugPrint("Token===>$fcmToken");
  }

  getSubscription() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.isDark == 'true'
              ? MobikulTheme.darkTheme
              : MobikulTheme.mobikulTheme,
          themeMode: ThemeMode.system,
          initialRoute: appRoot,
          onGenerateRoute: app_navigate.generateRoute,
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
