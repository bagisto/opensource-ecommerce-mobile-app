import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/queries.dart';
import '../../../category/data/models/category_model.dart';
import '../models/home_models.dart';

/// Repository that fetches all data needed for the homepage.
///
/// Uses:
///   • `SectionQueries.getSections` → homepage section layout
///   • `CategoryQueries.getHomeCategories` → category carousel
///   • `ProductQueries.getProducts` → product carousels (Featured, Hot Deals, New, etc.)
class HomeRepository {
  final GraphQLClient _client;

  HomeRepository({required GraphQLClient client}) : _client = client;

  /// Fetches published sections for the active channel theme.
  Future<List<ThemeCustomization>> fetchSections() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(SectionQueries.getSections),
        variables: const {'first': 50},
        // Admin edits must show on the next load; cache-and-network would
        // hand back the previous response first.
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to load homepage sections: ${result.exception}');
    }

    final edges = result.data?['sections']?['edges'] as List? ?? [];
    return edges
        .map(
          (e) => ThemeCustomization.fromJson(e['node'] as Map<String, dynamic>),
        )
        .where((tc) => tc.status)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Fetches categories for a category carousel: every active category, or
  /// only the direct children of [parentId] when the carousel sets a
  /// `parent_id` filter, sorted by position and capped at [limit]. Matches
  /// the storefront's `/api/categories` call.
  Future<List<HomeCategory>> fetchHomeCategories({
    int? parentId,
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
    final activeNodes = edges
        .map((e) => e['node'])
        .whereType<Map<String, dynamic>>()
        .where((node) => CategoryModel.isActiveStatus(node['status']))
        .toList();
    // Ids that are the parent of an active category.
    final parentIds = {
      for (final node in activeNodes)
        ?int.tryParse('${(node['parent'] as Map?)?['_id']}'),
    };
    final categories =
        activeNodes
            .where((node) {
              if (parentId == null) return true;
              final parent = node['parent'] as Map<String, dynamic>?;
              return int.tryParse('${parent?['_id']}') == parentId;
            })
            .map(
              (node) => HomeCategory.fromJson(
                node,
                hasChildren: parentIds.contains(
                  int.tryParse('${node['_id']}'),
                ),
              ),
            )
            .toList()
          ..sort((a, b) {
            final byPosition = a.position.compareTo(b.position);
            return byPosition != 0
                ? byPosition
                : (a.numericId ?? 0).compareTo(b.numericId ?? 0);
          });
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
