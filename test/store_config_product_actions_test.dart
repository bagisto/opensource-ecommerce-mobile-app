import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/product/presentation/bloc/product_detail_bloc.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_attributes_section.dart';
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
);

class _SeededProductBloc extends ProductDetailBloc {
  _SeededProductBloc()
    : super(
        repository: CategoryRepository(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      ) {
    emit(
      const ProductDetailState(
        status: ProductDetailStatus.loaded,
        product: _product,
      ),
    );
  }
}

Future<void> _pump(WidgetTester tester, StoreConfigCubit config) async {
  addTearDown(config.close);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: config),
        BlocProvider<ProductDetailBloc>(create: (_) => _SeededProductBloc()),
        BlocProvider(create: (_) => WishlistCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProductAttributesSection(product: _product),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('Share is hidden when social share is off in admin', (
    tester,
  ) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {'socialShareEnabled': false}),
    );

    expect(find.text('Share'), findsNothing);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Compare'), findsOneWidget);
  });

  testWidgets('Share shows when social share is on', (tester) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {'socialShareEnabled': true}),
    );

    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('action row hides when wishlist, compare and share are off', (
    tester,
  ) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {
        'socialShareEnabled': false,
        'wishlistEnabled': false,
        'compareEnabled': false,
      }),
    );

    expect(find.text('Share'), findsNothing);
    expect(find.text('Wishlist'), findsNothing);
    expect(find.text('Compare'), findsNothing);
  });
}
