import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/review_entry.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'store_config_fakes.dart';

class _SeededAuthBloc extends AuthBloc {
  _SeededAuthBloc(AuthState seeded)
    : super(
        repository: AuthRepository(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      ) {
    emit(seeded);
  }
}

const _product = ProductModel(
  id: '/api/shop/products/16',
  numericId: 16,
  type: 'simple',
  name: 'Analog Watch',
  price: 201,
  formattedPrice: r'$201.00',
  isSaleable: true,
);

Future<void> _pump(
  WidgetTester tester, {
  required Map<String, dynamic> config,
  required bool loggedIn,
}) async {
  final cubit = seededStoreConfigCubit(config);
  final auth = _SeededAuthBloc(
    loggedIn ? const AuthAuthenticated(token: 't') : const AuthUnauthenticated(),
  );
  addTearDown(cubit.close);
  addTearDown(auth.close);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider<AuthBloc>.value(value: auth),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProductInfoSection(product: _product),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Finder get _addReview =>
    find.textContaining('Add Review', findRichText: true);

void main() {
  group('reviewEntryFor', () {
    test('logged-in customer follows customerReviewEnabled', () {
      expect(
        reviewEntryFor(const StoreConfig(), isLoggedIn: true),
        ReviewEntry.write,
      );
      expect(
        reviewEntryFor(
          const StoreConfig(customerReviewEnabled: false),
          isLoggedIn: true,
        ),
        ReviewEntry.hidden,
      );
    });

    test('guest writes, signs in, or sees nothing', () {
      expect(
        reviewEntryFor(const StoreConfig(), isLoggedIn: false),
        ReviewEntry.write,
      );
      expect(
        reviewEntryFor(
          const StoreConfig(guestReviewEnabled: false),
          isLoggedIn: false,
        ),
        ReviewEntry.login,
      );
      expect(
        reviewEntryFor(
          const StoreConfig(
            guestReviewEnabled: false,
            customerReviewEnabled: false,
          ),
          isLoggedIn: false,
        ),
        ReviewEntry.hidden,
      );
    });
  });

  testWidgets('Add Review is hidden for customers when reviews are off', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const {'customerReviewEnabled': false},
      loggedIn: true,
    );

    expect(_addReview, findsNothing);
  });

  testWidgets('guest Add Review opens login when guest reviews are off', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const {'guestReviewEnabled': false},
      loggedIn: false,
    );

    await tester.tap(_addReview);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
