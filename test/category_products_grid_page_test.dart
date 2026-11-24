import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/filter_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/pages/category_products_grid_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'centers the empty-state text when no category products are returned',
    (WidgetTester tester) async {
      final repository = _EmptyCategoryRepository();
      final cartBloc = _TestCartBloc();
      final wishlistCubit = _TestWishlistCubit();

      await tester.pumpWidget(
        RepositoryProvider<CategoryRepository>.value(
          value: repository,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CartBloc>.value(value: cartBloc),
              BlocProvider<WishlistCubit>.value(value: wishlistCubit),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const CategoryProductsGridPage(
                categoryId: 1,
                categoryName: 'Root',
                categorySlug: 'root',
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text('No products found'));
      final subtitle = tester.widget<Text>(
        find.text('Try adjusting your filters or search criteria'),
      );

      expect(title.textAlign, TextAlign.center);
      expect(subtitle.textAlign, TextAlign.center);
    },
  );
}

class _EmptyCategoryRepository extends CategoryRepository {
  _EmptyCategoryRepository() : super(client: _dummyClient());

  @override
  Future<List<FilterAttribute>> getCategoryAttributeFilters({
    String categorySlug = '',
    int first = 50,
  }) async {
    return const <FilterAttribute>[];
  }

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
  }) async {
    return const PaginatedProducts(
      totalCount: 0,
      pageInfo: PageInfo(),
      products: <ProductModel>[],
    );
  }
}

class _TestWishlistCubit extends WishlistCubit {
  @override
  Future<void> refreshWishlist() async {
    emit(const WishlistCubitState(isLoaded: true));
  }
}

class _TestCartBloc extends CartBloc {
  _TestCartBloc()
    : super(
        repository: CartRepository(
          client: _dummyClient(),
        ),
      ) {
    emit(
      const CartState(
        status: CartStatus.loaded,
      ),
    );
  }
}

GraphQLClient _dummyClient() {
  return GraphQLClient(
    link: Link.function((request, [forward]) => const Stream.empty()),
    cache: GraphQLCache(store: InMemoryStore()),
  );
}
