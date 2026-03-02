import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/queries.dart';
import '../models/home_models.dart';

/// Repository that fetches all data needed for the homepage.
///
/// Uses:
///   • `ThemeQueries.getThemeCustomization` → homepage section layout
///   • `CategoryQueries.getHomeCategories` → category carousel
///   • `ProductQueries.getProducts` → product carousels (Featured, Hot Deals, New, etc.)
class HomeRepository {
  final GraphQLClient _client;

  HomeRepository({required GraphQLClient client}) : _client = client;

  /// Fetches the theme customization entries that define homepage sections.
  Future<List<ThemeCustomization>> fetchThemeCustomizations() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(ThemeQueries.getThemeCustomization),
        variables: const {'first': 20},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception(
        'Failed to load theme customizations: ${result.exception}',
      );
    }

    final edges = result.data?['themeCustomizations']?['edges'] as List? ?? [];
    return edges
        .map(
          (e) => ThemeCustomization.fromJson(e['node'] as Map<String, dynamic>),
        )
        .where((tc) => tc.status)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Fetches categories for the horizontal category carousel.
  Future<List<HomeCategory>> fetchHomeCategories() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(CategoryQueries.getHomeCategories),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to load categories: ${result.exception}');
    }

    final edges = result.data?['categories']?['edges'] as List? ?? [];
    return edges
        .map((e) => HomeCategory.fromJson(e['node'] as Map<String, dynamic>))
        .where((c) => c.numericId != 1) // exclude root category
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  /// Fetches products with optional filter JSON and sorting.
  ///
  /// Used by product_carousel sections: Featured Products, Hot Deals,
  /// New Products, etc.
  /// Sort key options per Bagisto API: PRICE, TITLE, NEWEST, BEST_SELLING
  Future<List<HomeProduct>> fetchProducts({
    int first = 8,
    String? filter,
    String sortKey = 'NEWEST',
    bool reverse = true,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(ProductQueries.getProducts),
        variables: {
          'first': first,
          'sortKey': sortKey,
          'reverse': reverse,
          if (filter != null) 'filter': filter,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to load products: ${result.exception}');
    }

    final edges = result.data?['products']?['edges'] as List? ?? [];
    return edges
        .map((e) => HomeProduct.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }
}
