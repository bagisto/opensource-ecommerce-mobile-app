import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/graphql/queries.dart';
import '../../../category/data/models/category_model.dart';
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
    // Read the user's preferred locale for selecting the right translation
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(LocaleCubit.localeKey) ?? 'en';

    final result = await _client.query(
      QueryOptions(
        document: gql(ThemeQueries.getThemeCustomization),
        variables: const {'first': 50},
        // Admin edits must show on the next load; cache-and-network would
        // hand back the previous response first.
        fetchPolicy: FetchPolicy.networkOnly,
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
          (e) => ThemeCustomization.fromJson(
            e['node'] as Map<String, dynamic>,
            preferredLocale: locale,
          ),
        )
        .where((tc) => tc.status)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Fetches categories for the horizontal category carousel: the active
  /// direct children of [parentId] (the carousel's `parent_id` filter),
  /// sorted by position and capped at [limit].
  Future<List<HomeCategory>> fetchHomeCategories({
    int parentId = 1,
    int? limit,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(CategoryQueries.getHomeCategories),
        variables: const {'first': 100},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to load categories: ${result.exception}');
    }

    final edges = result.data?['categories']?['edges'] as List? ?? [];
    // The `categories` query also returns disabled and nested categories.
    final categories = edges
        .map((e) => e['node'])
        .whereType<Map<String, dynamic>>()
        .where((node) => CategoryModel.isActiveStatus(node['status']))
        .where((node) {
          final parent = node['parent'] as Map<String, dynamic>?;
          return int.tryParse('${parent?['_id']}') == parentId;
        })
        .map(HomeCategory.fromJson)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    return limit != null && limit > 0
        ? categories.take(limit).toList()
        : categories;
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
        fetchPolicy: FetchPolicy.networkOnly,
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
