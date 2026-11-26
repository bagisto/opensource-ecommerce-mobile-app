import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/edit_account_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/account_menu_page.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/edit_account_page.dart';
import 'package:bagisto_flutter/features/auth/data/models/auth_models.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/wishlist_section.dart';
import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'store_config_fakes.dart';

AuthBloc _authBloc() => AuthBloc(
  repository: AuthRepository(
    client: GraphQLClient(
      link: HttpLink('https://example.com/graphql'),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  ),
);

Future<void> _pumpMenu(WidgetTester tester, StoreConfigCubit cubit) async {
  final auth = _authBloc();
  addTearDown(auth.close);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider.value(value: auth),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AccountMenuPage(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  wishlistSectionTests();
  newsletterTests();

  testWidgets('account menu hides Wishlist and Compare when switched off', (
    tester,
  ) async {
    final cubit = seededStoreConfigCubit(const {
      'wishlistEnabled': false,
      'compareEnabled': false,
    });
    addTearDown(cubit.close);

    await _pumpMenu(tester, cubit);

    expect(find.text('My Orders'), findsOneWidget);
    expect(find.text('Wishlist'), findsNothing);
    expect(find.text('Compare Products'), findsNothing);
  });

  testWidgets('account menu keeps Wishlist and Compare by default', (
    tester,
  ) async {
    final cubit = seededStoreConfigCubit(const {});
    addTearDown(cubit.close);

    await _pumpMenu(tester, cubit);

    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Compare Products'), findsOneWidget);
  });
}

void wishlistSectionTests() {
  for (final hidden in [true, false]) {
    testWidgets(
      'dashboard wishlist section ${hidden ? 'hides' : 'shows'} '
      'when wishlistEnabled is ${hidden ? 'false' : 'missing'}',
      (tester) async {
        final cubit = seededStoreConfigCubit(
          hidden ? const {'wishlistEnabled': false} : const {},
        );
        addTearDown(cubit.close);

        await tester.pumpWidget(
          BlocProvider.value(
            value: cubit,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const Scaffold(
                body: WishlistSection(items: [], totalCount: 0),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.text('Wishlist Items (0)'),
          hidden ? findsNothing : findsOneWidget,
        );
      },
    );
  }
}

class _RecordingAuthRepository extends AuthRepository {
  _RecordingAuthRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  bool? subscribed;

  @override
  Future<Customer> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    String? deviceToken,
    bool subscribeToNewsletter = true,
  }) async {
    subscribed = subscribeToNewsletter;
    return Customer(firstName: firstName, lastName: lastName, email: email);
  }
}

void newsletterTests() {
  test('sign-up passes the newsletter choice to the API', () async {
    final repository = _RecordingAuthRepository();
    final bloc = AuthBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(
      const AuthRegisterRequested(
        firstName: 'Jo',
        lastName: 'Doe',
        email: 'jo@example.com',
        password: 'secret123',
        confirmPassword: 'secret123',
        deviceToken: 'device',
        subscribeToNewsletter: false,
      ),
    );
    await bloc.stream.firstWhere((s) => s is! AuthLoading);

    expect(repository.subscribed, isFalse);
  });

  for (final hidden in [true, false]) {
    testWidgets(
      'edit account ${hidden ? 'hides' : 'shows'} the newsletter checkbox',
      (tester) async {
        final config = seededStoreConfigCubit(
          hidden ? const {'newsletterEnabled': false} : const {},
        );
        addTearDown(config.close);
        final bloc = EditAccountBloc(
          repository: AccountRepository(
            client: GraphQLClient(
              link: HttpLink('https://example.com/graphql'),
              cache: GraphQLCache(store: InMemoryStore()),
            ),
          ),
        );
        addTearDown(bloc.close);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: config),
              BlocProvider<EditAccountBloc>.value(value: bloc),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const EditAccountPage(
                profile: CustomerProfile(
                  firstName: 'Jo',
                  lastName: 'Doe',
                  email: 'jo@example.com',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Subscribe Newsletters'),
          hidden ? findsNothing : findsOneWidget,
        );
      },
    );
  }
}
