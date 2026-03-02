import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/queries.dart';
import '../models/category_model.dart';
import '../models/filter_model.dart';
import '../models/product_model.dart';

class CategoryRepository {
  final GraphQLClient client;

  CategoryRepository({required this.client});

  /// Fetch tree categories (hierarchical)
  /// Maps to: GET_TREE_CATEGORIES from nextjs-commerce
  Future<List<CategoryModel>> getTreeCategories({int? parentId}) async {
    final Map<String, dynamic> variables = {};
    if (parentId != null) {
      variables['parentId'] = parentId;
    }

    final result = await client.query(
      QueryOptions(
        document: gql(CategoryQueries.getTreeCategories),
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['treeCategories'] as List<dynamic>?;
    if (data == null) return [];

    return data
        .map((json) => CategoryModel.fromTreeJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch flat home categories
  /// Maps to: GET_HOME_CATEGORIES from nextjs-commerce
  Future<List<CategoryModel>> getHomeCategories() async {
    final result = await client.query(
      QueryOptions(
        document: gql(CategoryQueries.getHomeCategories),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final edges = result.data?['categories']?['edges'] as List<dynamic>? ?? [];

    return edges
        .map(
          (edge) => CategoryModel.fromHomeCategoryJson(
            edge['node'] as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetch products with pagination & filters
  /// Maps to: GET_PRODUCTS from nextjs-commerce
  Future<PaginatedProducts> getProducts({
    String? query,
    String? sortKey,
    bool? reverse,
    int? first,
    int? last,
    String? after,
    String? before,
    String? channel,
    String? locale,
    String? filter,
  }) async {
    final Map<String, dynamic> variables = {};
    if (query != null) variables['query'] = query;
    if (sortKey != null) variables['sortKey'] = sortKey;
    if (reverse != null) variables['reverse'] = reverse;
    if (first != null) variables['first'] = first;
    if (last != null) variables['last'] = last;
    if (after != null) variables['after'] = after;
    if (before != null) variables['before'] = before;
    if (channel != null) variables['channel'] = channel;
    if (locale != null) variables['locale'] = locale;
    if (filter != null) variables['filter'] = filter;

    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getProducts),
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return PaginatedProducts.fromJson(result.data!);
  }

  /// Fetch products filtered by category
  /// Maps to: GET_FILTER_PRODUCTS from nextjs-commerce
  /// [useCacheFirst] - if true, returns cached data immediately without network request
  ///                 (use for initial display, then call again with false for fresh data)
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
    final Map<String, dynamic> variables = {'filter': filter};
    if (sortKey != null) variables['sortKey'] = sortKey;
    if (reverse != null) variables['reverse'] = reverse;
    if (first != null) variables['first'] = first;
    if (last != null) variables['last'] = last;
    if (after != null) variables['after'] = after;
    if (before != null) variables['before'] = before;

    debugPrint('[CategoryRepo] getFilterProducts variables=$variables, useCacheFirst=$useCacheFirst');

    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getFilterProducts),
        variables: variables,
        fetchPolicy: useCacheFirst ? FetchPolicy.cacheFirst : FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      debugPrint('[CategoryRepo] getFilterProducts error: ${result.exception}');
      throw result.exception!;
    }

    debugPrint(
      '[CategoryRepo] getFilterProducts totalCount=${result.data?['products']?['totalCount']}',
    );
    return PaginatedProducts.fromJson(result.data!);
  }

  /// Fetch single product by URL key
  /// Maps to: GET_PRODUCT_BY_URL_KEY from nextjs-commerce
  Future<ProductModel> getProductByUrlKey(String urlKey) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getProductByUrlKey),
        variables: {'urlKey': urlKey},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return ProductModel.fromJson(
      result.data!['product'] as Map<String, dynamic>,
    );
  }

  /// Fetch filter attribute options (legacy – single attribute by ID)
  /// Maps to: GET_FILTER_OPTIONS from nextjs-commerce
  /// Attribute IDs: color=/api/admin/attributes/23, size=24, brand=25
  Future<FilterAttribute?> getFilterOptions({
    required String attributeId,
    String locale = 'en',
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(FilterQueries.getFilterOptions),
        variables: {'id': attributeId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['attribute'] as Map<String, dynamic>?;
    if (data == null) return null;

    return FilterAttribute.fromJson(data);
  }

  /// Fetch all filterable attributes for a category dynamically.
  ///
  /// Uses the `categoryAttributeFilters` GraphQL query.
  /// [categorySlug] – the category slug (or empty string for all).
  /// Returns a list of [FilterAttribute] with options, price range, etc.
  Future<List<FilterAttribute>> getCategoryAttributeFilters({
    String categorySlug = '',
    int first = 50,
  }) async {
    debugPrint(
      '[CategoryRepo] getCategoryAttributeFilters slug="$categorySlug", first=$first',
    );

    final result = await client.query(
      QueryOptions(
        document: gql(FilterQueries.getCategoryAttributeFilters),
        variables: {'categorySlug': categorySlug, 'first': first},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      debugPrint(
        '[CategoryRepo] getCategoryAttributeFilters error: ${result.exception}',
      );
      throw result.exception!;
    }

    final edges =
        result.data?['categoryAttributeFilters']?['edges'] as List<dynamic>? ??
        [];

    final attributes = edges.map((edge) {
      final node = edge['node'] as Map<String, dynamic>;
      return FilterAttribute.fromCategoryFilterJson(node);
    }).toList();

    // Sort by position
    attributes.sort((a, b) => (a.position ?? 999).compareTo(b.position ?? 999));

    debugPrint(
      '[CategoryRepo] getCategoryAttributeFilters loaded ${attributes.length} attributes: '
      '${attributes.map((a) => "${a.code}(${a.options.length} opts, price=${a.isPriceFilter})").join(", ")}',
    );

    return attributes;
  }

  /// Fetch related products for a given product
  Future<List<ProductModel>> getRelatedProducts(
    String urlKey, {
    int first = 10,
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getRelatedProducts),
        variables: {'urlKey': urlKey, 'first': first},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final edges =
        result.data?['product']?['relatedProducts']?['edges']
            as List<dynamic>? ??
        [];
    return edges
        .map((e) => ProductModel.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }
}
