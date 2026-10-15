import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_reviews_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'store_config_fakes.dart';

const _product = ProductModel(
  id: '/api/shop/products/16',
  numericId: 16,
  type: 'simple',
  name: 'Analog Watch',
  price: 201,
  isSaleable: true,
  reviews: [
    ProductReview(id: '1', rating: 5, name: 'Paul Doe', comment: 'Nice'),
  ],
);

Future<void> _pump(WidgetTester tester, StoreConfigCubit config) async {
  addTearDown(config.close);
  final auth = AuthBloc(
    repository: AuthRepository(
      client: GraphQLClient(
        link: HttpLink('https://example.com/graphql'),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    ),
  );
  addTearDown(auth.close);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: config),
        BlocProvider.value(value: auth),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProductReviewsSection(product: _product),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  test('censored names match the storefront format', () {
    expect(censoredReviewerName('H h Bukv'), 'H h B***');
    expect(censoredReviewerName('Paul Doe'), 'Paul D***');
    expect(censoredReviewerName('Paul'), 'P***');
    expect(censoredReviewerName('  '), '');
  });

  testWidgets('reviewer name shows as Censored when admin censors names', (
    tester,
  ) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {'reviewerNameCensored': true}),
    );

    // Same as the storefront: last word reduced to its first letter.
    expect(find.text('— Paul D***'), findsOneWidget);
    expect(find.textContaining('Paul Doe'), findsNothing);
  });

  testWidgets('reviewer name shows when censoring is off', (tester) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {'reviewerNameCensored': false}),
    );

    expect(find.text('— Paul Doe'), findsOneWidget);
  });
}
