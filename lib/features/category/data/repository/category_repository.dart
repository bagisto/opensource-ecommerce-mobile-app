import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/graphql/queries.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../account/data/models/review_attachment.dart';
import '../models/category_model.dart';
import '../models/filter_model.dart';
import '../models/product_model.dart';

class CategoryRepository {
  final GraphQLClient client;

  CategoryRepository({required this.client});

  /// Tells the store what was searched, so the admin sees it under
  /// Marketing → Search Terms like a web search.
  ///
  /// Best effort: a failure here must never get in the way of the search.
  Future<void> logSearchTerm({
    required String term,
    required int results,
  }) async {
    try {
      String? locale;
      try {
        locale = (await SharedPreferences.getInstance()).getString(
          LocaleCubit.localeKey,
        );
      } catch (_) {}

      await client.mutate(
        MutationOptions(
          document: gql(CategoryQueries.createSearchTerm),
          variables: {
            'input': {
              'term': term,
              'results': results,
              'channel': channelCode,
              if (locale != null && locale.isNotEmpty) 'locale': locale,
            },
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
    } catch (e) {
      debugPrint('[CategoryRepo] logSearchTerm failed: $e');
    }
  }

  /// Fetch a single category by numeric id.
  Future<CategoryModel?> getCategory(
    int id, {
    FetchPolicy? fetchPolicy,
  }) async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(CategoryQueries.getCategory),
          variables: {'id': '/api/shop/categories/$id'},
          fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) return null;
      final data = result.data?['category'] as Map<String, dynamic>?;
      if (data == null) return null;
      return CategoryModel.fromTreeJson(data);
    } catch (e) {
      debugPrint('[CategoryRepo] getCategory failed: $e');
      return null;
    }
  }

  /// Fetch tree categories (hierarchical)
  /// Maps to: GET_TREE_CATEGORIES from nextjs-commerce
  Future<List<CategoryModel>> getTreeCategories({
    int? parentId,
    FetchPolicy? fetchPolicy,
  }) async {
    final Map<String, dynamic> variables = {};
    if (parentId != null) {
      variables['parentId'] = parentId;
    }

    final result = await client.query(
      QueryOptions(
        document: gql(CategoryQueries.getTreeCategories),
        variables: variables,
        fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['treeCategories'] as List<dynamic>?;
    if (data == null) return [];

    final categories = data
        .map((json) => CategoryModel.fromTreeJson(json as Map<String, dynamic>))
        .toList();

    // With no parentId, the API hands back the system Root category itself
    // rather than its children -- promote those children to the top level
    // instead of showing "Root" as a customer-facing category. Only applies
    // to the initial, unscoped fetch; a real parentId (drilling into an
    // actual category) is returned as-is.
    if (parentId == null) {
      final promoted = <CategoryModel>[];
      for (final category in categories) {
        if (category.isRoot) {
          promoted.addAll(category.children.where((c) => c.isActive));
        } else if (category.isActive) {
          promoted.add(category);
        }
      }
      return promoted;
    }

    return categories.where((c) => c.isActive).toList();
  }

  /// Root category of the default channel. Its children are the storefront's
  /// main categories; the root itself is never shown.
  static const int rootCategoryId = 1;

  /// Categories tab: all categories from the `categories` query, keeping
  /// active top-level ones (no parent, or parent is the root) except the
  /// root itself, sorted by position. Children come from each category.
  /// [fetchPolicy] lets a pull-to-refresh ask for `networkOnly`; the default
  /// serves the cache first, as the tab's first paint wants.
  Future<List<CategoryModel>> getCategoryTabCategories({
    FetchPolicy? fetchPolicy,
  }) async {
    final nodes = <Map<String, dynamic>>[];
    String? after;

    do {
      final result = await client.query(
        QueryOptions(
          document: gql(CategoryQueries.getCategoryTabCategories),
          variables: {'first': 100, 'after': ?after},
          fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final connection = result.data?['categories'] as Map<String, dynamic>?;
      final edges = connection?['edges'] as List<dynamic>? ?? [];
      nodes.addAll(
        edges.map((edge) => edge['node']).whereType<Map<String, dynamic>>(),
      );

      final pageInfo = connection?['pageInfo'] as Map<String, dynamic>? ?? {};
      final hasNextPage = pageInfo['hasNextPage'] == true;
      after = hasNextPage ? pageInfo['endCursor'] as String? : null;
    } while (after != null);

    final categories = <CategoryModel>[];
    for (final node in nodes) {
      final category = CategoryModel.fromTreeJson(node);
      if (!category.isActive || category.numericId == rootCategoryId) continue;

      final parentId = (node['parent'] as Map<String, dynamic>?)?['_id'];
      if (parentId != null && parentId != rootCategoryId) continue;

      categories.add(category);
    }

    categories.sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
    return categories;
  }

  /// Fetch flat home categories
  /// Maps to: GET_HOME_CATEGORIES from nextjs-commerce
  Future<List<CategoryModel>> getHomeCategories({
    FetchPolicy? fetchPolicy,
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(CategoryQueries.getHomeCategories),
        fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork,
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
        .where((category) => !category.isRoot && category.isActive)
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

    debugPrint(
      '[CategoryRepo] getFilterProducts variables=$variables, useCacheFirst=$useCacheFirst',
    );

    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getFilterProducts),
        variables: variables,
        fetchPolicy: useCacheFirst
            ? FetchPolicy.cacheFirst
            : FetchPolicy.cacheAndNetwork,
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
  Future<ProductModel> getProductByUrlKey(
    String urlKey, {
    String? productType,
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final normalizedType = (productType ?? '').toLowerCase().trim();
    if (normalizedType == 'booking') {
      final bookingType = await _resolveBookingTypeByUrlKey(urlKey);
      final query = ProductQueries.getBookingProductByUrlKeyForType(
        bookingType,
      );

      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'urlKey': urlKey},
          fetchPolicy: fetchPolicy,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final product = ProductModel.fromJson(
        result.data!['product'] as Map<String, dynamic>,
      );
      _logBookingAvailability(product, source: 'urlKey:$urlKey');
      return product;
    }

    final query = ProductQueries.getProductByUrlKeyByType(productType);

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'urlKey': urlKey},
        fetchPolicy: fetchPolicy,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final product = ProductModel.fromJson(
      result.data!['product'] as Map<String, dynamic>,
    );
    _logBookingAvailability(product, source: 'urlKey:$urlKey');
    return product;
  }

  /// Fetch single product by ID
  /// Maps to: GET_PRODUCT_BY_ID from nextjs-commerce
  Future<ProductModel> getProductById(
    String productId, {
    String? productType,
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final normalizedType = (productType ?? '').toLowerCase().trim();
    if (normalizedType == 'booking') {
      final bookingType = await _resolveBookingTypeById(productId);
      final query = ProductQueries.getBookingProductByIdForType(bookingType);

      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'id': productId},
          fetchPolicy: fetchPolicy,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final product = ProductModel.fromJson(
        result.data!['product'] as Map<String, dynamic>,
      );
      _logBookingAvailability(product, source: 'id:$productId');
      return product;
    }

    final query = ProductQueries.getProductById;

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'id': productId},
        fetchPolicy: fetchPolicy,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final product = ProductModel.fromJson(
      result.data!['product'] as Map<String, dynamic>,
    );
    _logBookingAvailability(product, source: 'id:$productId');
    return product;
  }

  Future<List<BookingSlotOption>> getBookingSlots({
    required BookingProductData booking,
    required String date,
    String? rentingType,
  }) async {
    final type = (booking.type ?? '').toLowerCase().trim();
    final normalizedRentingType = (rentingType ?? '').toLowerCase().trim();
    final bookingId = _resolveBookingSlotId(booking);

    if (bookingId <= 0) {
      throw Exception('Missing booking slot id for $type product');
    }

    final isRentalHourly =
        type == 'rental' && normalizedRentingType == 'hourly';
    final result = await client.query(
      QueryOptions(
        document: gql(
          isRentalHourly
              ? ProductQueries.getBookingRentalHourlySlots
              : ProductQueries.getBookingSlots,
        ),
        variables: {'id': bookingId, 'date': date},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final slots = result.data?['bookingSlots'] as List<dynamic>? ?? const [];

    if (isRentalHourly) {
      return slots
          .whereType<Map<String, dynamic>>()
          .expand(BookingSlotOption.fromRentalSummaryJson)
          .where((slot) => slot.label.trim().isNotEmpty)
          .toList();
    }

    return slots
        .whereType<Map<String, dynamic>>()
        .map(BookingSlotOption.fromStandardJson)
        .where((slot) => slot.label.trim().isNotEmpty)
        .toList();
  }

  Future<String> _resolveBookingTypeByUrlKey(String urlKey) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getBookingProductTypeByUrlKey),
        variables: {'urlKey': urlKey},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final product = result.data?['product'] as Map<String, dynamic>?;
    final edges = product?['bookingProducts']?['edges'] as List<dynamic>? ?? [];
    if (edges.isEmpty) return 'default';

    final node = edges.first['node'] as Map<String, dynamic>?;
    final bookingType = node?['type']?.toString().trim();
    if (bookingType == null || bookingType.isEmpty) return 'default';
    return bookingType;
  }

  Future<String> _resolveBookingTypeById(String productId) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getBookingProductTypeById),
        variables: {'id': productId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final product = result.data?['product'] as Map<String, dynamic>?;
    final edges = product?['bookingProducts']?['edges'] as List<dynamic>? ?? [];
    if (edges.isEmpty) return 'default';

    final node = edges.first['node'] as Map<String, dynamic>?;
    final bookingType = node?['type']?.toString().trim();
    if (bookingType == null || bookingType.isEmpty) return 'default';
    return bookingType;
  }

  int _resolveBookingSlotId(BookingProductData booking) {
    final type = (booking.type ?? '').toLowerCase().trim();

    switch (type) {
      case 'appointment':
      case 'rental':
      case 'table':
        return booking.activeSlot?.resolvedBookingId ?? 0;
      case 'default':
      default:
        return booking.numericId ?? int.tryParse(booking.id) ?? 0;
    }
  }

  void _logBookingAvailability(ProductModel product, {required String source}) {
    if (!product.isBooking || product.bookingProducts.isEmpty) return;

    for (final booking in product.bookingProducts) {
      debugPrint(
        '[CategoryRepo] booking availability ($source) '
        'type=${booking.type} '
        'availableFrom=${booking.availableFrom} '
        'availableTo=${booking.availableTo}',
      );
    }
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
  /// Review media for [productId], keyed by [reviewIdKey] so it matches a
  /// review however that review's own query spelled its id.
  ///
  /// See [ProductQueries.getProductReviewAttachments] for why this is a
  /// separate request rather than a field on the product.
  Future<Map<String, List<ReviewAttachment>>> getProductReviewAttachments(
    int productId, {
    int first = 50,
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProductQueries.getProductReviewAttachments),
        variables: {'productId': productId, 'first': first},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final edges =
        result.data?['productReviews']?['edges'] as List<dynamic>? ?? [];
    final byId = <String, List<ReviewAttachment>>{};
    for (final edge in edges) {
      final node = (edge as Map?)?['node'];
      if (node is! Map) continue;
      final attachments = ReviewAttachment.parseList(node['attachments']);
      if (attachments.isEmpty) continue;
      for (final raw in [node['_id'], node['id']]) {
        final key = reviewIdKey(raw);
        if (key.isNotEmpty) byId[key] = attachments;
      }
    }
    return byId;
  }

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
