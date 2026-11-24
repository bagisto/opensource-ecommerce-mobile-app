import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:bagisto_flutter/core/marketplace_status/guest_review_cubit.dart';
import 'package:bagisto_flutter/core/marketplace_status/marketplace_status_cubit.dart';
import 'package:bagisto_flutter/core/navigation/app_navigator.dart';
import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/category_bloc.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:bagisto_flutter/features/category/presentation/pages/category_products_grid_page.dart';
import 'package:bagisto_flutter/features/home/presentation/pages/home_page.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/category_carousel.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A section as the API sends it, with the admin's `sortOrder` and options.
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

HomeCategory _homeCategory(
  int id,
  String name, {
  bool hasChildren = false,
}) => HomeCategory(
  id: '/api/shop/categories/$id',
  numericId: id,
  name: name,
  slug: name.toLowerCase(),
  position: id,
  status: '1',
  hasChildren: hasChildren,
);

CategoryModel _tabCategory(
  int id,
  String name, {
  List<CategoryModel> children = const [],
}) => CategoryModel(
  id: '/api/shop/categories/$id',
  numericId: id,
  position: id,
  status: '1',
  translation: CategoryTranslation(name: name, slug: name.toLowerCase()),
  children: children,
);

GraphQLClient _dummyClient() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);

/// Serves the sections it is given and answers each carousel's category
/// request from a flat tree, recording the `parent_id`/`limit` it was asked
/// for so the test can prove every carousel is fetched on its own filters.
class _FakeHomeRepository extends HomeRepository {
  _FakeHomeRepository(this.sections) : super(client: _dummyClient());

  final List<ThemeCustomization> sections;
  final List<int?> requestedParentIds = [];

  @override
  Future<List<ThemeCustomization>> fetchSections({String? locale}) async =>
      sections;

  @override
  Future<List<ThemeCustomization>> fetchThemeCustomizations() async => sections;

  @override
  Future<List<HomeCategory>> fetchHomeCategories({
    int? parentId,
    int? limit,
  }) async {
    final effectiveParent = parentId ?? 1;
    requestedParentIds.add(effectiveParent);
    final byParent = {
      1: [
        _homeCategory(2, 'Men', hasChildren: true),
        _homeCategory(3, 'Women'),
      ],
      2: [_homeCategory(4, 'Shirts')],
    };
    final categories = byParent[effectiveParent] ?? const <HomeCategory>[];
    return limit == null ? categories : categories.take(limit).toList();
  }
}

/// Knows one top-level category, `Furniture`, which has a sub-category — the
/// shape a banner link has to resolve against.
class _FakeCategoryRepository extends CategoryRepository {
  _FakeCategoryRepository() : super(client: _dummyClient());

  List<CategoryModel> get _topLevel => [
    _tabCategory(
      23,
      'Furniture',
      children: [_tabCategory(19, 'Plastic Sofa')],
    ),
  ];

  @override
  Future<List<CategoryModel>> getCategoryTabCategories({
    FetchPolicy? fetchPolicy,
  }) async => _topLevel;

  /// The Categories tab loads through this one; stubbed so switching to the
  /// tab never reaches the network.
  @override
  Future<List<CategoryModel>> getTreeCategories({
    int? parentId,
    FetchPolicy? fetchPolicy,
  }) async => parentId == null ? _topLevel : const [];

  @override
  Future<PaginatedProducts> getFilterProducts({
    required String filter,
    String? sortKey,
    bool? reverse,
    int? first,
    int? last,
    String? after,
    String? before,
    bool useCacheFirst = false,
  }) async => const PaginatedProducts(
    totalCount: 0,
    pageInfo: PageInfo(),
    products: [],
  );
}

class _SeededHomeBloc extends HomeBloc {
  _SeededHomeBloc({required super.repository});

  void seedState(HomeState state) => emit(state);
}

Future<List<int>> _pumpHome(
  WidgetTester tester, {
  required HomeState state,
  required CategoryRepository categoryRepository,
}) async {
  final switchedTabs = <int>[];
  final client = GraphQLClientProvider.buildClient();
  final bloc = _SeededHomeBloc(repository: HomeRepository(client: client))
    ..seedState(state);
  addTearDown(bloc.close);

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>.value(
          value: categoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>.value(value: bloc),
          BlocProvider<CategoryBloc>(
            create: (_) => CategoryBloc(repository: categoryRepository),
          ),
          BlocProvider<CartBloc>(
            create: (_) => CartBloc(repository: CartRepository(client: client)),
          ),
          BlocProvider<WishlistCubit>(create: (_) => WishlistCubit()),
          BlocProvider<MarketplaceStatusCubit>(
            create: (_) => MarketplaceStatusCubit(),
          ),
          BlocProvider<GuestReviewCubit>(create: (_) => GuestReviewCubit()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppNavigator(
            switchToTab: switchedTabs.add,
            currentTab: () => AppNavigator.homeTab,
            child: const HomePage(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return switchedTabs;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('category carousels follow their own admin filters', () {
    test('every carousel is fetched with its own parent_id', () async {
      final repository = _FakeHomeRepository([
        _section(
          id: '/api/shop/theme-customizations/1',
          type: 'category_carousel',
          name: 'Top Categories',
          sortOrder: 1,
          options: '{"filters":{"parent_id":1}}',
        ),
        _section(
          id: '/api/shop/theme-customizations/2',
          type: 'category_carousel',
          name: 'Menswear',
          sortOrder: 2,
          options: '{"filters":{"parent_id":2}}',
        ),
      ]);
      final bloc = HomeBloc(repository: repository);
      addTearDown(bloc.close);

      bloc.add(const LoadHome());
      final loaded = await bloc.stream.firstWhere(
        (s) => s.status == HomeStatus.loaded,
      );

      expect(repository.requestedParentIds, [1, 2]);
      expect(
        loaded
            .categorySections['/api/shop/theme-customizations/1']!
            .map((c) => c.name),
        ['Men', 'Women'],
      );
      expect(
        loaded
            .categorySections['/api/shop/theme-customizations/2']!
            .map((c) => c.name),
        ['Shirts'],
        reason: 'the second carousel must not reuse the first one\'s filters',
      );
      // Flattened union, de-duplicated by id, for link resolution.
      expect(loaded.categories.map((c) => c.name), [
        'Men',
        'Women',
        'Shirts',
      ]);
    });

    test('a carousel without a parent_id falls back to the root children',
        () async {
      final repository = _FakeHomeRepository([
        _section(
          id: '/api/shop/theme-customizations/1',
          type: 'category_carousel',
          name: 'Categories',
          sortOrder: 1,
          options: '{"filters":[]}',
        ),
      ]);
      final bloc = HomeBloc(repository: repository);
      addTearDown(bloc.close);

      bloc.add(const LoadHome());
      final loaded = await bloc.stream.firstWhere(
        (s) => s.status == HomeStatus.loaded,
      );

      expect(repository.requestedParentIds, [1]);
      expect(loaded.categories.map((c) => c.name), ['Men', 'Women']);
    });

    testWidgets('each carousel renders the categories fetched for it', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const topId = '/api/shop/theme-customizations/1';
      const menswearId = '/api/shop/theme-customizations/2';

      await _pumpHome(
        tester,
        categoryRepository: _FakeCategoryRepository(),
        state: HomeState(
          status: HomeStatus.loaded,
          customizations: [
            _section(
              id: topId,
              type: 'category_carousel',
              name: 'Top Categories',
              sortOrder: 1,
            ),
            _section(
              id: menswearId,
              type: 'category_carousel',
              name: 'Menswear',
              sortOrder: 2,
            ),
          ],
          categorySections: {
            topId: [_homeCategory(2, 'Men', hasChildren: true)],
            menswearId: [_homeCategory(4, 'Shirts')],
          },
          categories: [
            _homeCategory(2, 'Men', hasChildren: true),
            _homeCategory(4, 'Shirts'),
          ],
        ),
      );

      expect(find.byType(CategoryCarousel), findsNWidgets(2));
      expect(find.text('Men'), findsOneWidget);
      expect(find.text('Shirts'), findsOneWidget);
    });

    testWidgets(
      'tapping a category in carousel navigates to CategoryProductsGridPage directly',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 4000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await _pumpHome(
          tester,
          categoryRepository: _FakeCategoryRepository(),
          state: HomeState(
            status: HomeStatus.loaded,
            customizations: [
              _section(
                id: '/api/shop/theme-customizations/1',
                type: 'category_carousel',
                name: 'Categories',
                sortOrder: 1,
              ),
            ],
            categorySections: {
              '/api/shop/theme-customizations/1': [
                _homeCategory(1, 'Root', hasChildren: true),
                _homeCategory(2, 'random'),
              ],
            },
            categories: [
              _homeCategory(1, 'Root', hasChildren: true),
              _homeCategory(2, 'random'),
            ],
          ),
        );

        await tester.tap(find.text('Root'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(CategoryProductsGridPage), findsOneWidget);
        expect(find.text('Root'), findsWidgets);
      },
    );
  });

  group('homepage banner links', () {
    testWidgets(
      'a banner linking to a category with sub-categories opens the '
      'Categories tab',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 4000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final switchedTabs = await _pumpHome(
          tester,
          categoryRepository: _FakeCategoryRepository(),
          state: HomeState(
            status: HomeStatus.loaded,
            customizations: [
              _section(
                id: '/api/shop/theme-customizations/4',
                type: 'image_carousel',
                name: 'Banners',
                sortOrder: 1,
                // The slug is not in the carousel categories, so it has to be
                // resolved through the Categories tab lookup.
                options:
                    '{"images":[{"image":"/storage/banner.webp",'
                    '"link":"https://shop.test/categories/furniture"}]}',
              ),
            ],
          ),
        );

        await tester.tap(find.byKey(const ValueKey('home_banner_0')));
        await tester.pump();
        await tester.pump();

        expect(
          switchedTabs,
          [AppNavigator.categoriesTab],
          reason:
              'a top-level category with children belongs in the Categories '
              'tab, not in a bare product grid',
        );
      },
    );

    testWidgets('a banner with no link is not tappable', (tester) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final switchedTabs = await _pumpHome(
        tester,
        categoryRepository: _FakeCategoryRepository(),
        state: HomeState(
          status: HomeStatus.loaded,
          customizations: [
            _section(
              id: '/api/shop/theme-customizations/4',
              type: 'image_carousel',
              name: 'Banners',
              sortOrder: 1,
              options:
                  '{"images":[{"image":"/storage/banner.webp","link":""}]}',
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(const ValueKey('home_banner_0')));
      await tester.pump();

      expect(switchedTabs, isEmpty);
    });
  });
}
