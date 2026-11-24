import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:bagisto_flutter/core/marketplace_status/guest_review_cubit.dart';
import 'package:bagisto_flutter/core/marketplace_status/marketplace_status_cubit.dart';
import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:bagisto_flutter/features/home/presentation/pages/home_page.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/category_carousel.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/footer_links_section.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/services_content_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A section as the API sends it, with the admin's `sortOrder`.
ThemeCustomization _section({
  required String id,
  required String type,
  required String name,
  required int sortOrder,
  String options = '{}',
}) => ThemeCustomization.fromJson({
  'id': id,
  'type': type,
  'name': name,
  'status': '1',
  'sortOrder': sortOrder,
  'translations': {
    'edges': [
      {
        'node': {'locale': 'en', 'options': options},
      },
    ],
  },
});

const String _servicesOptions =
    '{"services":[{"title":"Free Shipping","description":"On all orders",'
    '"service_icon":"icon-truck"}]}';

const String _footerOptions =
    '{"title":"Footer Links","column_1":[{"title":"About Us",'
    '"url":"http://localhost/page/about-us"}],"column_2":[]}';

HomeCategory _category(int id, String name) => HomeCategory.fromJson({
  'id': '/api/shop/categories/$id',
  '_id': id,
  'status': '1',
  'translations': {
    'edges': [
      {
        'node': {'locale': 'en', 'name': name, 'slug': name.toLowerCase()},
      },
    ],
  },
});

/// Pumps the home page with [customizations] already loaded, then returns the
/// vertical offset of each rendered section widget type.
Future<void> _pumpHome(
  WidgetTester tester,
  List<ThemeCustomization> customizations,
) async {
  final client = GraphQLClientProvider.buildClient();
  final bloc = _SeededHomeBloc(repository: HomeRepository(client: client))
    ..seedState(
      HomeState(
        status: HomeStatus.loaded,
        customizations: customizations,
        categories: [_category(2, 'Men'), _category(3, 'Women')],
      ),
    );

  addTearDown(bloc.close);

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(client: client),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>.value(value: bloc),
          BlocProvider<CartBloc>(
            create: (_) => CartBloc(repository: CartRepository(client: client)),
          ),
          BlocProvider<WishlistCubit>(create: (_) => WishlistCubit()),
          BlocProvider<MarketplaceStatusCubit>(
            create: (_) => MarketplaceStatusCubit(),
          ),
          BlocProvider<GuestReviewCubit>(create: (_) => GuestReviewCubit()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePage(),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('sections render in the admin sortOrder the API returned', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHome(tester, [
      _section(
        id: '/api/shop/theme-customizations/1',
        type: 'services_content',
        name: 'Services',
        sortOrder: 1,
        options: _servicesOptions,
      ),
      _section(
        id: '/api/shop/theme-customizations/2',
        type: 'category_carousel',
        name: 'Categories',
        sortOrder: 2,
      ),
    ]);

    final services = tester.getTopLeft(find.byType(ServicesContentSection)).dy;
    final categories = tester.getTopLeft(find.byType(CategoryCarousel)).dy;
    expect(
      services,
      lessThan(categories),
      reason: 'the first section in sortOrder must render first',
    );
  });

  testWidgets('reordering the sections in admin reorders the home page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Same two sections, with the category carousel configured first. Nothing
    // may hoist it or the product sections out of this order.
    await _pumpHome(tester, [
      _section(
        id: '/api/shop/theme-customizations/2',
        type: 'category_carousel',
        name: 'Categories',
        sortOrder: 1,
      ),
      _section(
        id: '/api/shop/theme-customizations/1',
        type: 'services_content',
        name: 'Services',
        sortOrder: 2,
        options: _servicesOptions,
      ),
    ]);

    final categories = tester.getTopLeft(find.byType(CategoryCarousel)).dy;
    final services = tester.getTopLeft(find.byType(ServicesContentSection)).dy;
    expect(categories, lessThan(services));
  });

  testWidgets('footer links render at the very bottom, after every section', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Footer links are configured first, yet belong at the bottom like the
    // storefront footer.
    await _pumpHome(tester, [
      _section(
        id: '/api/shop/theme-customizations/3',
        type: 'footer_links',
        name: 'Footer Links',
        sortOrder: 1,
        options: _footerOptions,
      ),
      _section(
        id: '/api/shop/theme-customizations/1',
        type: 'services_content',
        name: 'Services',
        sortOrder: 2,
        options: _servicesOptions,
      ),
    ]);

    expect(find.byType(FooterLinksSection), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
    final footer = tester.getTopLeft(find.byType(FooterLinksSection)).dy;
    final services = tester.getTopLeft(find.byType(ServicesContentSection)).dy;
    expect(footer, greaterThan(services));
  });
}

class _SeededHomeBloc extends HomeBloc {
  _SeededHomeBloc({required super.repository});

  void seedState(HomeState state) {
    emit(state);
  }
}
