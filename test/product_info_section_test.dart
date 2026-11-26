import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Widget _wrap(ProductModel product) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // The rating row shows "Add Review" for signed-in users via AuthBloc.
  home: BlocProvider(
    create: (_) => AuthBloc(
      repository: AuthRepository(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      ),
    ),
    child: Scaffold(
      body: SingleChildScrollView(child: ProductInfoSection(product: product)),
    ),
  ),
);

ProductModel _product({String type = 'simple', String? shortDescription}) =>
    ProductModel(
      id: '/api/shop/products/16',
      type: type,
      name: 'Analog Watch',
      price: 201,
      formattedPrice: r'$201.00',
      isSaleable: true,
      shortDescription: shortDescription,
    );

Finder _text(String text) => find.textContaining(text, findRichText: true);

void main() {
  testWidgets('shows short description for a simple product', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _product(
          shortDescription: '<p>Elevate your style with this watch.</p>',
        ),
      ),
    );

    expect(_text('Elevate your style with this watch.'), findsOneWidget);
  });

  testWidgets('short description sits between price and stock', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(_product(shortDescription: '<p>Short summary</p>')),
    );

    final priceY = tester.getTopLeft(_text(r'$201.00').first).dy;
    final descriptionY = tester.getTopLeft(_text('Short summary')).dy;
    final stockY = tester.getTopLeft(_text('In Stock')).dy;

    expect(descriptionY, greaterThan(priceY));
    expect(stockY, greaterThan(descriptionY));
  });

  testWidgets('renders HTML lists and entities', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _product(
          shortDescription:
              '<ul>\r\n<li><p>Men&rsquo;s Backpack &amp; Bag</p></li>\r\n'
              '<li><p>Second item</p></li>\r\n</ul>',
        ),
      ),
    );

    expect(_text('Men’s Backpack & Bag'), findsOneWidget);
    expect(_text('Second item'), findsOneWidget);
    expect(_text('&rsquo;'), findsNothing);
  });

  testWidgets('hides empty or tag-only short description', (tester) async {
    for (final value in [null, '', '  ', '<p></p>', '<p>&nbsp;</p>']) {
      await tester.pumpWidget(_wrap(_product(shortDescription: value)));

      expect(
        find.byKey(const ValueKey('product_short_description')),
        findsNothing,
        reason: 'value: $value',
      );
    }
  });
}
