import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/category/data/models/product_model.dart';
import '../../features/home/data/models/home_models.dart';
import '../graphql/queries.dart';

class RecentlyViewedProductsService {
  RecentlyViewedProductsService._();

  static const _prefsKey = 'recently_viewed_products';
  static const _maxItems = 12;
  static const _trackKey = 'settings_track_recently_viewed';

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static bool _isTrackingEnabled(SharedPreferences prefs) {
    return prefs.getBool(_trackKey) ?? true;
  }

  static Future<List<HomeProduct>> getRecentProducts() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isTrackingEnabled(prefs)) return const <HomeProduct>[];
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const <HomeProduct>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <HomeProduct>[];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(HomeProduct.fromJson)
          .where(
            (product) => product.name.isNotEmpty && product.urlKey.isNotEmpty,
          )
          .toList();
    } catch (_) {
      return const <HomeProduct>[];
    }
  }

  static Future<void> trackProduct(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isTrackingEnabled(prefs)) return;

    final numericId =
        product.numericId ?? int.tryParse(product.id.split('/').last);
    final name = product.name?.trim() ?? '';
    final urlKey = product.urlKey?.trim() ?? '';

    if (numericId == null || numericId <= 0 || name.isEmpty || urlKey.isEmpty) {
      return;
    }

    final current = await getRecentProducts();
    final firstBooking = product.bookingProducts.isEmpty
        ? null
        : product.bookingProducts.first;
    final recentProduct = HomeProduct(
      id: product.id,
      numericId: numericId,
      sku: product.sku ?? '',
      type: product.type ?? 'simple',
      bookingType: product.bookingType,
      name: name,
      urlKey: urlKey,
      baseImageUrl: product.baseImageUrl,
      price: product.price ?? 0,
      minimumPrice: product.minimumPrice,
      maximumPrice: product.maximumPrice,
      regularMinimumPrice: product.regularMinimumPrice,
      formattedRegularMinimumPrice: product.formattedRegularMinimumPrice,
      regularMaximumPrice: product.regularMaximumPrice,
      formattedRegularMaximumPrice: product.formattedRegularMaximumPrice,
      specialPrice: product.specialPrice,
      formattedPrice: product.formattedPrice,
      formattedMinimumPrice: product.formattedMinimumPrice,
      formattedSpecialPrice: product.formattedSpecialPrice,
      isSaleable: product.isSaleable ?? true,
      isNew: product.isNew ?? false,
      startingPrice: firstBooking?.startingPrice,
      formattedStartingPrice: firstBooking?.formattedStartingPrice,
      startingRegularPrice: firstBooking?.startingRegularPrice,
      formattedStartingRegularPrice:
          firstBooking?.formattedStartingRegularPrice,
      averageRating: product.averageRating,
      reviewCount: product.reviewCount,
    );

    final updated = <HomeProduct>[
      recentProduct,
      ...current.where(
        (item) =>
            item.numericId != recentProduct.numericId &&
            item.urlKey != recentProduct.urlKey,
      ),
    ].take(_maxItems).toList();

    await prefs.setString(
      _prefsKey,
      jsonEncode(updated.map((product) => product.toJson()).toList()),
    );
    changes.value++;
  }

  /// Drops any cached entry the server no longer considers active or that no
  /// longer exists. A network failure on a given item keeps it as-is --
  /// connectivity hiccups should never silently wipe someone's history.
  static Future<List<HomeProduct>> pruneInactive(GraphQLClient client) async {
    final current = await getRecentProducts();
    if (current.isEmpty) return current;

    // Indexed rather than appended-on-completion, so the newest-first order
    // survives concurrent requests finishing in an arbitrary sequence.
    final keep = List<bool>.filled(current.length, true);
    await Future.wait(
      current.asMap().entries.map((entry) async {
        final index = entry.key;
        final product = entry.value;
        try {
          final result = await client.query(
            QueryOptions(
              document: gql(ProductQueries.getProductStatusByUrlKey),
              variables: {'urlKey': product.urlKey},
              fetchPolicy: FetchPolicy.networkOnly,
            ),
          );

          if (result.hasException) return; // couldn't confirm -- keep it

          final data = result.data?['product'] as Map<String, dynamic>?;
          if (data == null) {
            keep[index] = false; // deleted -- drop it
            return;
          }

          final status = data['status'];
          final active =
              status == true ||
              status == 'true' ||
              status == 1 ||
              status == '1';
          keep[index] = active;
        } catch (_) {
          // couldn't confirm -- keep it
        }
      }),
    );

    final survivors = [
      for (var i = 0; i < current.length; i++)
        if (keep[i]) current[i],
    ];

    if (survivors.length != current.length) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKey,
        jsonEncode(survivors.map((product) => product.toJson()).toList()),
      );
      changes.value++;
    }
    return survivors;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    changes.value++;
  }
}
