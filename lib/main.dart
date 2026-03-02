import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/graphql/graphql_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/wishlist/wishlist_cubit.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  try {
    await initHiveForFlutter();
  } catch (e) {
    debugPrint('Hive init failed (using in-memory cache): $e');
  }

  runApp(BagistoApp(prefs: prefs));
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
            BlocProvider(
              create: (_) => ThemeCubit()..initialize(prefs),
            ),
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
            BlocProvider(
              create: (_) => WishlistCubit()..loadWishlist(),
            ),
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
///  • On logout → fires [OnUserLoggedOut] which clears the user's cart and
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
            debugPrint('🔄 Auth→Cart sync: user already logged in — firing OnUserLoggedIn');
            cartBloc.add(OnUserLoggedIn(authToken: authState.token));
            context.read<WishlistCubit>().loadWishlist();
            return;
          }
        }

        if (authState is AuthAuthenticated) {
          // User just logged in — sync the cart
          if (!_wasAuthenticated || _lastAuthToken != authState.token) {
            debugPrint('🔄 Auth→Cart sync: user logged in — firing OnUserLoggedIn');
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
            debugPrint('🔄 Auth→Cart sync: auth loading after login — firing OnUserLoggedOut');
            cartBloc.add(const OnUserLoggedOut());
            context.read<WishlistCubit>().clearWishlist();
            _logoutSyncTriggered = true;
          }
        } else if (authState is AuthUnauthenticated) {
          // User just logged out — reset the cart
          if (_wasAuthenticated && !_logoutSyncTriggered) {
            debugPrint('🔄 Auth→Cart sync: user logged out — firing OnUserLoggedOut');
            cartBloc.add(const OnUserLoggedOut());
            context.read<WishlistCubit>().clearWishlist();
          }
          _wasAuthenticated = false;
          _lastAuthToken = null;
          _logoutSyncTriggered = false;
        }
      },
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Bagisto Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: SplashScreen(
              nextScreen: MainShell(key: MainShell.navigatorKey),
            ),
          );
        },
      ),
    );
  }
}
