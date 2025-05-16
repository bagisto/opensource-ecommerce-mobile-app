/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// must_be_immutable, void_checks

import 'dart:io';

import 'package:bagisto_app_demo/screens/home_page/data_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:bagisto_app_demo/utils/app_navigation.dart';
import 'package:bagisto_app_demo/utils/push_notifications_manager.dart';
import 'package:bagisto_app_demo/utils/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'data_model/product_model/product_screen_model.dart';

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
  await GetStorage.init("configurationStorage");
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      child: BagistoApp(GlobalData.locale),
    ),
  );
}

Future<void> hiveRegisterAdapter() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  ///Home Page Model
  Hive.registerAdapter(NewProductsModelAdapter());
  Hive.registerAdapter(NewProductsAdapter());
  Hive.registerAdapter(InventoriesAdapter());
  Hive.registerAdapter(InventorySourceAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(PriceHtmlAdapter());
  Hive.registerAdapter(ProductFlatsAdapter());
  Hive.registerAdapter(ImagesAdapter());
  Hive.registerAdapter(HomeCategoriesAdapter());
  Hive.registerAdapter(GetDrawerCategoriesDataAdapter());
}

// restarts the widget by taking a child widget to draw and assign unique key to be associated with it
class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static restartApp(BuildContext context) {
    //find the current this state object and calls the [restartApp] function to restart the whole app
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

/// BagistoApp class is the main class of the application. It is responsible for
/// initializing the app,setting up the theme, routes, and localization settings.
class BagistoApp extends StatefulWidget {
  const BagistoApp(
    this.selectedLanguage, {
    Key? key,
  }) : super(key: key);

  final String? selectedLanguage;
  @override
  State<BagistoApp> createState() => _BagistoAppState();
}

class _BagistoAppState extends State<BagistoApp> {
  Locale? _locale;
  String appRoot = splash;

  /// Initialize the app with default values like language, currency, currency symbol
  @override
  void initState() {
    GlobalData.locale = appStoragePref.getCustomerLanguage();
    GlobalData.currencyCode = appStoragePref.getCurrencyCode();
    GlobalData.currencySymbol = appStoragePref.getCurrencySymbol();
    _locale = Locale(GlobalData.locale);
    PushNotificationsManager.instance.setUpFirebase(context);
    notification();
    super.initState();
  }

  // Permission for notification
  Future<void> notification() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  /// Builds the MaterialApp widget with the specified theme, routes, and localization settings.
  /// Returns a ChangeNotifierProvider that provides a ThemeProvider to the widget tree. The
  /// ThemeProvider is used to manage the theme of the app. The MaterialApp widget is wrapped
  /// in an OverlaySupport widget to enable overlay notifications. The supportedLocales property
  /// specifies the locales that the app supports. The localeResolutionCallback property is used
  /// to resolve the locale based on the user's preferred locale. The locale property specifies the current locale of the app.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider themeNotifier, child) {
        return MaterialApp(
          theme: MobiKulTheme.lightTheme,
          themeMode: ThemeMode.system,
          darkTheme: MobiKulTheme.darkTheme,
          initialRoute: appRoot,
          onGenerateRoute: generateRoute,
          title: defaultAppTitle,
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

/// HttpOverrides class to bypass SSL certificate verification for HTTPS requests to localhost. This is useful for testing purposes when using a local server.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
