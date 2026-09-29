import 'dart:convert';
import 'dart:developer' as developer;
import 'package:equatable/equatable.dart';

/// Represents a theme customization entry from the Bagisto API.
/// Each node defines a section of the homepage (image_carousel, product_carousel,
/// category_carousel, etc.) along with its translated options JSON.
class ThemeCustomization extends Equatable {
  final String id;
  final String type;
  final String name;
  final bool status;
  final int sortOrder;
  final Map<String, dynamic> options;

  const ThemeCustomization({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.sortOrder,
    required this.options,
  });

  factory ThemeCustomization.fromJson(
    Map<String, dynamic> json, {
    String preferredLocale = 'en',
  }) {
    // Parse translations → find the preferred locale, fallback to 'en', then first available
    Map<String, dynamic> options = {};
    Map<String, dynamic>? enOptions;
    final translations = json['translations']?['edges'] as List? ?? [];
    for (final edge in translations) {
      final node = edge['node'] as Map<String, dynamic>? ?? {};
      final locale = node['locale'] as String? ?? '';

      Map<String, dynamic>? parsed;
      final rawOptions = node['options'];
      if (rawOptions is String) {
        try {
          parsed = jsonDecode(rawOptions) as Map<String, dynamic>;
        } catch (_) {}
      } else if (rawOptions is Map) {
        parsed = Map<String, dynamic>.from(rawOptions);
      }
      if (parsed == null || parsed.isEmpty) continue;

      if (locale == preferredLocale) {
        options = parsed;
        break; // exact match found
      } else if (locale == 'en') {
        enOptions = parsed; // keep English as fallback
      } else if (options.isEmpty) {
        options = parsed; // first available as last resort
      }
    }
    // Use English fallback if preferred locale wasn't found
    if (options.isEmpty && enOptions != null) {
      options = enOptions;
    }

    return ThemeCustomization(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] == true ||
          json['status'] == 'true' ||
          json['status'] == 1 ||
          json['status'] == '1',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      options: options,
    );
  }

  @override
  List<Object?> get props => [id, type, name, status, sortOrder];
}

/// A category for the homepage carousel (circular icons).
class HomeCategory extends Equatable {
  final String id;
  final int? numericId;
  final String name;
  final String slug;
  final String? logoUrl;
  final int position;

  const HomeCategory({
    required this.id,
    this.numericId,
    required this.name,
    required this.slug,
    this.logoUrl,
    required this.position,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    final translation = json['translation'] as Map<String, dynamic>? ?? {};
    return HomeCategory(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      name: translation['name'] as String? ?? '',
      slug: translation['slug'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, numericId, name, slug, logoUrl, position];
}

/// A product for homepage product carousels.
class HomeProduct extends Equatable {
  final String id;
  final int? numericId;
  final String sku;
  final String type;
  final String name;
  final String urlKey;
  final String? baseImageUrl;
  final double price;
  final double? minimumPrice;
  final double? specialPrice;
  final String? formattedPrice;
  final String? formattedMinimumPrice;
  final String? formattedSpecialPrice;
  final bool isSaleable;
  final double averageRating;
  final int reviewCount;

  const HomeProduct({
    required this.id,
    this.numericId,
    required this.sku,
    required this.type,
    required this.name,
    required this.urlKey,
    this.baseImageUrl,
    required this.price,
    this.minimumPrice,
    this.specialPrice,
    this.formattedPrice,
    this.formattedMinimumPrice,
    this.formattedSpecialPrice,
    required this.isSaleable,
    this.averageRating = 0,
    this.reviewCount = 0,
  });

  factory HomeProduct.fromJson(Map<String, dynamic> json) {
    // Parse numeric ID from _id field or from IRI
    int? numId;
    if (json['_id'] is int) {
      numId = json['_id'] as int;
    } else if (json['_id'] != null) {
      numId = int.tryParse(json['_id'].toString());
    }
    if (numId == null && json['id'] != null) {
      final parts = json['id'].toString().split('/');
      if (parts.isNotEmpty) numId = int.tryParse(parts.last);
    }

    // Debug: log raw price fields from API
    developer.log(
      'HomeProduct[${json['name']}] price=${json['price']} '
      'specialPrice=${json['specialPrice']} (${json['specialPrice']?.runtimeType}) '
      'minimumPrice=${json['minimumPrice']}',
      name: 'HomeProduct',
    );

    // Parse specialPrice — treat 0 as null (no discount)
    double? parsedSpecialPrice;
    if (json['specialPrice'] != null) {
      final sp = _toDouble(json['specialPrice']);
      if (sp > 0) parsedSpecialPrice = sp;
    }

    // Parse reviews for rating/count
    final reviewEdges = json['reviews']?['edges'] as List? ?? [];
    final ratings = reviewEdges
        .map((e) => _toDouble((e['node'] as Map<String, dynamic>?)?['rating']))
        .where((r) => r > 0)
        .toList();
    final fallbackRating = _toDouble(json['averageRating']);
    final avgRating = ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : fallbackRating;
    final fallbackReviewCount = (json['reviewCount'] as num?)?.toInt() ?? 0;

    return HomeProduct(
      id: json['id']?.toString() ?? '',
      numericId: numId,
      sku: json['sku'] as String? ?? '',
      type: json['type'] as String? ?? 'simple',
      name: json['name'] as String? ?? '',
      urlKey: json['urlKey'] as String? ?? '',
      baseImageUrl: json['baseImageUrl'] as String?,
      price: _toDouble(json['price']),
      minimumPrice: json['minimumPrice'] != null ? _toDouble(json['minimumPrice']) : null,
      specialPrice: parsedSpecialPrice,
      formattedPrice: json['formattedPrice'] as String?,
      formattedMinimumPrice: json['formattedMinimumPrice'] as String?,
      formattedSpecialPrice: json['formattedSpecialPrice'] as String?,
      isSaleable: json['isSaleable'] == true,
      averageRating: avgRating,
      reviewCount: ratings.isNotEmpty ? ratings.length : fallbackReviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': numericId,
      'sku': sku,
      'type': type,
      'name': name,
      'urlKey': urlKey,
      'baseImageUrl': baseImageUrl,
      'price': price,
      'minimumPrice': minimumPrice,
      'specialPrice': specialPrice,
      'formattedPrice': formattedPrice,
      'formattedMinimumPrice': formattedMinimumPrice,
      'formattedSpecialPrice': formattedSpecialPrice,
      'isSaleable': isSaleable,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }

  /// The effective display price: specialPrice > minimumPrice > price
  double get displayPrice {
    if (specialPrice != null && specialPrice! > 0) return specialPrice!;
    if (type == 'configurable' && minimumPrice != null && minimumPrice! > 0) {
      return minimumPrice!;
    }
    return price;
  }

  /// Whether a discount exists.
  bool get hasDiscount => specialPrice != null && specialPrice! > 0 && specialPrice! < price;

  /// Discount percentage (0–100).
  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((price - specialPrice!) / price) * 100).round();
  }

  String get displayPriceLabel {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        (formattedSpecialPrice?.isNotEmpty ?? false)) {
      return formattedSpecialPrice!;
    }
    if (type == 'configurable' &&
        minimumPrice != null &&
        minimumPrice! > 0 &&
        (formattedMinimumPrice?.isNotEmpty ?? false)) {
      return formattedMinimumPrice!;
    }
    return formattedPrice ?? price.toStringAsFixed(2);
  }

  String? get originalPriceLabel {
    if (hasDiscount && (formattedPrice?.isNotEmpty ?? false)) {
      return formattedPrice;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    numericId,
    sku,
    type,
    name,
    urlKey,
    baseImageUrl,
    price,
    formattedPrice,
    formattedMinimumPrice,
    formattedSpecialPrice,
    averageRating,
    reviewCount,
  ];
}

/// An image entry inside an image_carousel customization.
class BannerImage extends Equatable {
  final String imageUrl;
  final String link;
  final String? title;

  const BannerImage({
    required this.imageUrl,
    this.link = '',
    this.title,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      imageUrl: json['image'] as String? ?? '',
      link: json['link'] as String? ?? '',
      title: json['title'] as String?,
    );
  }

  /// Build full URL from relative path
  String fullImageUrl(String baseUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
    return '$cleanBase/$cleanPath';
  }

  @override
  List<Object?> get props => [imageUrl, link, title];
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
