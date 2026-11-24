import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/category_bloc.dart';
import 'package:bagisto_flutter/features/category/presentation/pages/category_page.dart';
import 'package:bagisto_flutter/features/category/presentation/widgets/category_banner.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// A top-level category as the admin configures it: a banner image and a
/// description entered in the rich-text editor.
const _watches = CategoryModel(
  id: '/api/shop/categories/2',
  numericId: 2,
  status: '1',
  position: 1,
  bannerUrl: 'https://example.com/storage/category/2/banner.webp',
  translation: CategoryTranslation(
    name: 'Watches',
    slug: 'watches',
    description: '<p>Dive watches&nbsp; and chronographs</p>',
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTab(WidgetTester tester) async {
    final bloc = CategoryBloc(repository: _FakeCategoryRepository())
      ..add(LoadCategories());
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<CategoryBloc>.value(
          value: bloc,
          child: const CategoryPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('the Categories tab shows the admin description', (tester) async {
    await pumpTab(tester);

    expect(find.byKey(const ValueKey('category_description')), findsOneWidget);
    // The HTML and the &nbsp; are stripped, the words survive.
    expect(find.text('Dive watches and chronographs'), findsOneWidget);
  });

  testWidgets('the banner carries the image only, never the category name', (
    tester,
  ) async {
    await pumpTab(tester);

    expect(find.byType(CategoryBanner), findsOneWidget);
    // The name belongs to the chip above the banner, not on top of it.
    expect(
      find.descendant(
        of: find.byType(CategoryBanner),
        matching: find.byType(Text),
      ),
      findsNothing,
    );
  });
}

class _FakeCategoryRepository extends CategoryRepository {
  _FakeCategoryRepository() : super(client: _dummyClient());

  @override
  Future<List<CategoryModel>> getTreeCategories({
    int? parentId,
    FetchPolicy? fetchPolicy,
  }) async => const [_watches];

  @override
  Future<List<CategoryModel>> getCategoryTabCategories({
    FetchPolicy? fetchPolicy,
  }) async => const [_watches];

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
  }) async => PaginatedProducts(
    products: const [],
    pageInfo: PageInfo(hasNextPage: false, hasPreviousPage: false),
    totalCount: 0,
  );
}

GraphQLClient _dummyClient() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);
