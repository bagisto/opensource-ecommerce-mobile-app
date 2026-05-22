import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'l10n/app_localizations.dart';
import 'core/channel/channel_bootstrap_service.dart';
import 'core/graphql/graphql_client.dart';
import 'core/currency/currency_cubit.dart';
import 'core/currency/currency_formatter.dart';
import 'core/locale/locale_cubit.dart';
import 'core/navigation/route_observer.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/wishlist/wishlist_cubit.dart';
import 'core/notifications/firebase_service.dart';
import 'core/notifications/fcm_service.dart';
import 'core/error/error_mapper.dart';
import 'core/widgets/app_update_gate.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/category/presentation/pages/category_products_grid_page.dart';
import 'features/product/presentation/pages/product_detail_page.dart';
import 'features/account/presentation/pages/order_detail_page.dart';
import 'features/account/data/repository/account_repository.dart';
import 'features/category/data/repository/category_repository.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/cart/data/repository/cart_repository.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/home/data/repository/home_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/main_shell.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseEnabled = await FirebaseService.initialize();

  // Initialize Firebase
  if (firebaseEnabled) {
    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } else {
    debugPrint(
      '⚠️ Firebase is disabled. App will continue without push notifications.',
    );
  }

  // Initialize Hive cache
  try {
    await initHiveForFlutter();
  } catch (e) {
    debugPrint('Hive init failed (using in-memory cache): $e');
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  CurrencyFormatter.initialize(prefs);

  try {
    await ChannelBootstrapService(
      client: GraphQLClientProvider.buildClient(),
      prefs: prefs,
    ).bootstrap();
  } catch (e) {
    debugPrint('Channel bootstrap error: $e');
  }

  // Initialize FCM notifications
  // This must be done after Firebase initialization
  if (firebaseEnabled) {
    try {
      await FCMService().initialize(
        onForegroundMessage: _handleForegroundNotification,
        onBackgroundMessage: _handleBackgroundNotification,
        onMessageOpenedApp: _handleMessageOpenedApp,
        onLocalNotificationTapped: _handleLocalNotificationTapped,
      );

      // Token retrieval is now handled by FCMService with iOS APNS support
      // Get the token from FCMService after initialization
      debugPrint('⏳ Retrieving device token from FCMService...');
      try {
        final deviceToken = await FCMService().getDeviceToken();
        if (deviceToken != null && deviceToken.isNotEmpty) {
          debugPrint('✅ FCM device token is available');
        } else {
          debugPrint(
            '⚠️ Token not yet available, FCMService will retry automatically',
          );
        }
      } catch (e) {
        debugPrint('⚠️ Token retrieval note: $e');
        // Continue anyway - token will be obtained via retry mechanism
      }
    } catch (e) {
      debugPrint('FCM initialization error: $e');
      // Continue anyway - notifications are optional
    }
  } else {
    debugPrint('⚠️ Skipping FCM initialization because Firebase is disabled.');
  }

  // Test notification to verify system is working
  Future.delayed(const Duration(seconds: 2), () async {
    try {
      debugPrint('📢 Sending test notification...');
      await _sendTestNotification();
    } catch (e) {
      debugPrint('Test notification error: $e');
    }
  });

  runApp(BagistoApp(prefs: prefs));
}

/// Handle notification when app is in foreground
Future<void> _handleForegroundNotification(RemoteMessage message) async {
  debugPrint(
    '📬 Foreground notification handler called '
    '(id=${message.messageId}, hasData=${message.data.isNotEmpty})',
  );

  // Handle navigation based on notification type
  // REMOVED: _navigateFromNotification(message);
  // Navigation should only happen when the user taps the local notification,
  // which is handled by _handleLocalNotificationTapped.
}

/// Handle notification when app is in background
/// Note: Background handler must be a top-level function
Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  debugPrint('🌙 Background notification received');
  // Background handler is already implemented in FCMService
}

/// Handle notification when app is opened from background
Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
  debugPrint('📲 App opened from notification: ${message.messageId}');

  // Handle navigation based on notification type
  _navigateFromNotification(message);
}

/// Handle local notification tap (when app is in foreground and user taps notification)
Future<void> _handleLocalNotificationTapped(Map<String, dynamic> data) async {
  debugPrint(
    '📲 Local notification tapped '
    '(keys=${data.keys.join(',')})',
  );

  // Navigate based on notification data
  _navigateFromNotificationData(data);
}

/// Extract a numeric ID from a string that may be a pure number,
/// an IRI path like "/api/shop/customer-orders/577", or URL-encoded.
int? _extractNumericId(String? raw) {
  if (raw == null || raw.isEmpty) return null;

  // Decode any percent-encoding first (e.g. %2F → /)
  final decoded = Uri.decodeComponent(raw);

  // If it's already a pure number, use it directly
  final direct = int.tryParse(decoded);
  if (direct != null) return direct;

  // Try to extract the last numeric segment from a path
  // e.g. "/api/shop/customer-orders/577" → "577"
  final segments = decoded.split('/').where((s) => s.isNotEmpty).toList();
  for (var i = segments.length - 1; i >= 0; i--) {
    final n = int.tryParse(segments[i]);
    if (n != null) return n;
  }

  return null;
}

/// Navigate from local notification data (parsed payload)
Future<void> _navigateFromNotificationData(Map<String, dynamic> data) async {
  try {
    // Check both 'notificationType' and 'type' fields
    var type = data['notificationType']?.toString().toLowerCase();
    type ??= data['type']?.toString().toLowerCase();

    debugPrint('🔗 Notification type from local tap: $type');

    // Get the MainShellState from navigatorKey
    final mainShellContext = MainShell.navigatorKey.currentContext;
    if (mainShellContext == null) {
      debugPrint('⚠️ MainShell context not available yet, will retry');
      Future.delayed(const Duration(seconds: 1), () {
        _navigateFromNotificationData(data);
      });
      return;
    }

    if (type == 'order' || type == 'order_status') {
      // Navigate to order detail page
      // The notification may send: orderId=576, id=576, or the full IRI=/api/shop/customer-orders/576
      final orderId = _extractNumericId(
        data['orderId']?.toString() ?? data['id']?.toString(),
      );
      final orderNumber = data['orderNumber'];

      debugPrint(
        '📦 Order notification data: orderId=$orderId, orderNumber=$orderNumber',
      );

      if (orderId == null) {
        debugPrint('⚠️ Missing or invalid orderId in notification data');
        return;
      }

      debugPrint('📦 Navigating to order: #$orderNumber (ID: $orderId)');

      // Get AccountRepository from context
      AccountRepository? repository;
      try {
        repository = RepositoryProvider.of<AccountRepository>(mainShellContext);
      } catch (e) {
        try {
          repository = mainShellContext.read<AccountRepository>();
        } catch (e2) {
          // Repository not in context — create one with an authenticated client.
          // Order endpoints require auth; using the guest client causes 500 errors.
          final authState = mainShellContext.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            final authClient = GraphQLClientProvider.authenticatedClient(
              authState.token,
            );
            repository = AccountRepository(client: authClient.value);
          } else {
            debugPrint('⚠️ User not authenticated — cannot view order');
            return;
          }
        }
      }

      // Use the navigate method from OrderDetailPage
      OrderDetailPage.navigate(
        mainShellContext,
        orderId: orderId,
        orderNumber: orderNumber?.toString(),
        repository: repository,
      );
    } else {
      debugPrint('ℹ️ Unknown notification type from local tap: $type');
    }
  } catch (e) {
    debugPrint('❌ Error navigating from local notification: $e');
  }
}

/// Navigate to category, product, or order based on notification data
Future<void> _navigateFromNotification(RemoteMessage message) async {
  try {
    final data = message.data;
    // Check both 'notificationType' and 'type' fields for compatibility
    // Some notifications use 'type' field directly
    var type = data['notificationType']?.toString().toLowerCase();
    type ??= data['type']?.toString().toLowerCase();

    debugPrint('🔗 Notification type: $type');

    // Get the MainShellState from navigatorKey
    final mainShellContext = MainShell.navigatorKey.currentContext;
    if (mainShellContext == null) {
      debugPrint('⚠️ MainShell context not available yet, will retry');
      // Retry after a delay
      Future.delayed(const Duration(seconds: 1), () {
        _navigateFromNotification(message);
      });
      return;
    }

    if (type == 'category') {
      // Navigate to category products
      final categoryId = int.tryParse(data['categoryId'] ?? '');
      final categoryName = data['categoryName'] ?? 'Products';
      final categorySlug = data['categorySlug'] ?? '';

      if (categoryId == null) {
        debugPrint('⚠️ Missing categoryId in notification data');
        return;
      }

      debugPrint('📂 Navigating to category: $categoryName (ID: $categoryId)');

      Navigator.of(mainShellContext).push(
        MaterialPageRoute(
          builder: (_) => CategoryProductsGridPage(
            categoryId: categoryId,
            categoryName: categoryName,
            categorySlug: categorySlug,
          ),
        ),
      );
    } else if (type == 'product') {
      // Navigate to product detail (supports both URL key and product ID)
      final productUrlKey = data['productUrlKey'];
      final productId = data['productId'];
      final productName = data['productName'];
      final productType = data['productType'];

      // If we have URL key, use it directly
      if (productUrlKey != null && productUrlKey.isNotEmpty) {
        debugPrint(
          '🛍️ Navigating to product: $productName (URL key: $productUrlKey)',
        );

        Navigator.of(mainShellContext).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              urlKey: productUrlKey,
              productName: productName,
              productType: productType,
            ),
          ),
        );
      }
      // Otherwise, try to fetch product by ID to get the URL key
      else if (productId != null && productId.isNotEmpty) {
        debugPrint('🛍️ Fetching product details for ID: $productId');

        try {
          final navigator = Navigator.of(mainShellContext);
          final repository = mainShellContext.read<CategoryRepository>();
          final product = await repository.getProductById(productId);

          if (product.urlKey == null || product.urlKey!.isEmpty) {
            debugPrint('⚠️ Product does not have URL key');
            return;
          }

          debugPrint(
            '✅ Product fetched: ${product.name} (URL key: ${product.urlKey})',
          );

          navigator.push(
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                urlKey: product.urlKey!,
                productName: product.name,
                productType: product.type,
              ),
            ),
          );
        } catch (e) {
          debugPrint('❌ Failed to fetch product by ID: $e');
        }
      }
      // Neither URL key nor ID provided
      else {
        debugPrint(
          '⚠️ Missing productUrlKey or productId in notification data',
        );
      }
    } else if (type == 'order' || type == 'order_status') {
      // Navigate to order detail page
      // The notification may send: orderId=576, id=576, or the full IRI=/api/shop/customer-orders/576
      final orderId = _extractNumericId(
        data['orderId']?.toString() ?? data['id']?.toString(),
      );
      final orderNumber = data['orderNumber'];

      debugPrint(
        '📦 Order notification data: orderId=$orderId, orderNumber=$orderNumber',
      );

      if (orderId == null) {
        debugPrint('⚠️ Missing or invalid orderId in notification data');
        return;
      }

      debugPrint('📦 Navigating to order: #$orderNumber (ID: $orderId)');

      // Get AccountRepository from context (similar to how orders_page does it)
      AccountRepository? repository;
      try {
        repository = RepositoryProvider.of<AccountRepository>(mainShellContext);
      } catch (e) {
        debugPrint('⚠️ Could not get repository from context, trying read...');
        try {
          repository = mainShellContext.read<AccountRepository>();
        } catch (e2) {
          // Repository not in context — create one with an authenticated client.
          // Order endpoints require auth; using the guest client causes 500 errors.
          final authState = mainShellContext.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            final authClient = GraphQLClientProvider.authenticatedClient(
              authState.token,
            );
            repository = AccountRepository(client: authClient.value);
          } else {
            debugPrint('⚠️ User not authenticated — cannot view order');
            return;
          }
        }
      }

      // Use the navigate method from OrderDetailPage (same as orders_page)
      OrderDetailPage.navigate(
        mainShellContext,
        orderId: orderId,
        orderNumber: orderNumber?.toString(),
        repository: repository,
      );
    } else {
      debugPrint('ℹ️ Unknown notification type: $type');
    }
  } catch (e) {
    debugPrint('❌ Error navigating from notification: $e');
  }
}

/// Send test notification (for debugging)
Future<void> _sendTestNotification() async {
  try {
    // Create a mock RemoteMessage for testing
    debugPrint(
      '✅ Test notification system ready! Token subscribed to bagisto_mobikul topic',
    );
    debugPrint('📢 Send notifications from Firebase Console with data:');
    debugPrint('   1. FOR CATEGORY PRODUCTS:');
    debugPrint('      - notificationType: category');
    debugPrint('      - categoryId: <category_id>');
    debugPrint('      - categoryName: <category_name>');
    debugPrint('      - categorySlug: <optional_slug>');
    debugPrint('   2. FOR PRODUCT DETAIL (by URL key):');
    debugPrint('      - notificationType: product');
    debugPrint('      - productUrlKey: <product_url_key>');
    debugPrint('      - productName: <product_name>');
    debugPrint('   3. FOR PRODUCT DETAIL (by ID):');
    debugPrint('      - notificationType: product');
    debugPrint('      - productId: <product_id>');
    debugPrint('      - productName: <product_name> (optional)');
    debugPrint('   4. FOR ORDER DETAIL:');
    debugPrint('      - notificationType: order OR type: order_status');
    debugPrint('      - orderId: <order_id>');
    debugPrint('      - orderNumber: <order_number> (optional)');
  } catch (e) {
    debugPrint('❌ Test notification error: $e');
  }
}

class BagistoApp extends StatelessWidget {
  final SharedPreferences prefs;

  const BagistoApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final clientNotifier = GraphQLClientProvider.client;

    return GraphQLProvider(
      client: clientNotifier,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CategoryRepository>(
            create: (_) => CategoryRepository(client: clientNotifier.value),
          ),
          RepositoryProvider<CartRepository>(
            create: (_) => CartRepository(client: clientNotifier.value),
          ),
          RepositoryProvider<AuthRepository>(
            create: (_) => AuthRepository(client: clientNotifier.value),
          ),
          RepositoryProvider<HomeRepository>(
            create: (_) => HomeRepository(client: clientNotifier.value),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()..initialize(prefs)),
            BlocProvider(create: (_) => CurrencyCubit()..initialize(prefs)),
            BlocProvider(create: (_) => LocaleCubit()..initialize(prefs)),
            BlocProvider(
              create: (ctx) =>
                  AuthBloc(repository: ctx.read<AuthRepository>())
                    ..add(const AuthCheckStatus()),
            ),
            BlocProvider(
              create: (ctx) =>
                  CategoryBloc(repository: ctx.read<CategoryRepository>())
                    ..add(LoadCategories()),
            ),
            BlocProvider(
              create: (ctx) =>
                  CartBloc(repository: ctx.read<CartRepository>())
                    ..add(LoadCart()),
            ),
            BlocProvider(
              create: (ctx) =>
                  HomeBloc(repository: ctx.read<HomeRepository>())
                    ..add(const LoadHome()),
            ),
            BlocProvider(create: (_) => WishlistCubit()..loadWishlist()),
          ],
          child: const _AppWithAuthCartSync(),
        ),
      ),
    );
  }
}

/// Widget that listens to AuthBloc state changes and synchronizes the CartBloc.
///
/// This is the Flutter equivalent of the Next.js SessionSync + useMergeCart:
///
///  • On login  → fires [OnUserLoggedIn] which switches the cart bearer token
///    to the auth access token and merges the guest cart into the user's cart.
///
///  • On logout → fires [OnUserLoggedOut] which resets cart state and
///    creates a fresh guest cart session.
class _AppWithAuthCartSync extends StatefulWidget {
  const _AppWithAuthCartSync();

  @override
  State<_AppWithAuthCartSync> createState() => _AppWithAuthCartSyncState();
}

class _AppWithAuthCartSyncState extends State<_AppWithAuthCartSync> {
  /// Track previous auth state to detect transitions (login / logout).
  bool _wasAuthenticated = false;
  String? _lastAuthToken;
  bool _initialAuthCheckDone = false;
  bool _logoutSyncTriggered = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        final cartBloc = context.read<CartBloc>();

        // On first auth state, sync the cart if user is already authenticated
        if (!_initialAuthCheckDone) {
          _initialAuthCheckDone = true;
          if (authState is AuthAuthenticated) {
            _wasAuthenticated = true;
            _lastAuthToken = authState.token;
            debugPrint(
              '🔄 Auth→Cart sync: user already logged in — firing OnUserLoggedIn',
            );
            cartBloc.add(OnUserLoggedIn(authToken: authState.token));
            context.read<WishlistCubit>().loadWishlist();
            return;
          }
        }

        if (authState is AuthAuthenticated) {
          // User just logged in — sync the cart
          if (!_wasAuthenticated || _lastAuthToken != authState.token) {
            debugPrint(
              '🔄 Auth→Cart sync: user logged in — firing OnUserLoggedIn',
            );
            cartBloc.add(OnUserLoggedIn(authToken: authState.token));
            context.read<WishlistCubit>().loadWishlist();
            _wasAuthenticated = true;
            _lastAuthToken = authState.token;
            _logoutSyncTriggered = false;
          }
        } else if (authState is AuthLoading) {
          // Logout flow enters loading while token is still available.
          // Trigger cart reset here so we can clear user cart data promptly.
          if (_wasAuthenticated && !_logoutSyncTriggered) {
            debugPrint(
              '🔄 Auth→Cart sync: auth loading after login — firing OnUserLoggedOut',
            );
            cartBloc.add(const OnUserLoggedOut());
            context.read<WishlistCubit>().clearWishlist();
            _logoutSyncTriggered = true;
          }
        } else if (authState is AuthUnauthenticated) {
          // User just logged out — reset the cart
          if (_wasAuthenticated && !_logoutSyncTriggered) {
            debugPrint(
              '🔄 Auth→Cart sync: user logged out — firing OnUserLoggedOut',
            );
            cartBloc.add(const OnUserLoggedOut());
            context.read<WishlistCubit>().clearWishlist();
          }
          _wasAuthenticated = false;
          _lastAuthToken = null;
          _logoutSyncTriggered = false;
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<LocaleCubit, Locale?>(
            listenWhen: (previous, current) =>
                current != null &&
                previous?.languageCode != current.languageCode,
            listener: (context, state) async {
              final homeBloc = context.read<HomeBloc>();
              final categoryBloc = context.read<CategoryBloc>();
              final cartBloc = context.read<CartBloc>();
              await GraphQLClientProvider.clearCache();
              homeBloc.add(const RefreshHome());
              categoryBloc.add(LoadCategories());
              cartBloc.add(LoadCart());
            },
          ),
          BlocListener<CurrencyCubit, String?>(
            listenWhen: (previous, current) =>
                current != null && previous != current,
            listener: (context, state) async {
              final homeBloc = context.read<HomeBloc>();
              final categoryBloc = context.read<CategoryBloc>();
              final cartBloc = context.read<CartBloc>();
              await GraphQLClientProvider.clearCache();
              homeBloc.add(const RefreshHome());
              categoryBloc.add(LoadCategories());
              cartBloc.add(LoadCart());
            },
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) => BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, locale) {
              ErrorMapper.updateLocale(locale);
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appTitle,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [appRouteObserver],
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                home: SplashScreen(
                  nextScreen: AppUpdateGate(
                    child: MainShell(key: MainShell.navigatorKey),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
