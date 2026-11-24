import 'dart:convert';
import 'dart:developer' as developer;
import 'package:equatable/equatable.dart';
import '../../../../core/currency/product_price_display.dart';

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
    // The API may return locale codes in upper case (e.g. `AR`).
    final wantedLocale = preferredLocale.toLowerCase();
    final translationNodes = <Map<String, dynamic>>[];
    final currentTranslation = json['translation'];
    if (currentTranslation is Map) {
      translationNodes.add(Map<String, dynamic>.from(currentTranslation));
    }
    final translations = json['translations']?['edges'] as List? ?? [];
    for (final edge in translations) {
      final node = edge['node'] as Map<String, dynamic>? ?? {};
      translationNodes.add(node);
    }
    for (final node in translationNodes) {
      final locale = (node['locale'] as String? ?? '').toLowerCase();

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

      if (locale == wantedLocale) {
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
      status:
          json['status'] == true ||
          json['status'] == 'true' ||
          json['status'] == 1 ||
          json['status'] == '1',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      options: options,
    );
  }

  /// The section's configured filters.
  ///
  /// A section saved with no filters comes back as an empty JSON list rather
  /// than an object, so a bare cast to a map throws and the section silently
  /// disappears. Anything that is not a map reads as "no filters".
  Map<String, dynamic> get filters {
    final raw = options['filters'];
    return raw is Map ? Map<String, dynamic>.from(raw) : const {};
  }

  /// Heading shown on the storefront: the section's `options.title`, or its
  /// admin name when no title is set.
  String get title {
    final optionTitle = options['title']?.toString().trim() ?? '';
    return optionTitle.isNotEmpty ? optionTitle : name;
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
  final String? bannerUrl;
  final String? description;
  final int position;
  final String? status;
  final String? displayMode;

  /// Whether the category has active sub-categories. Tapping it then opens
  /// the Categories tab instead of the product list.
  final bool hasChildren;

  const HomeCategory({
    required this.id,
    this.numericId,
    required this.name,
    required this.slug,
    this.logoUrl,
    this.bannerUrl,
    this.description,
    required this.position,
    this.status,
    this.displayMode,
    this.hasChildren = false,
  });

  bool get isActive => status != '0' && status != 'false';

  String get plainDescription => (description ?? '')
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r' (?=[,.;:!?])'), '')
      .trim();

  factory HomeCategory.fromJson(
    Map<String, dynamic> json, {
    bool hasChildren = false,
  }) {
    final translation = json['translation'] as Map<String, dynamic>? ?? {};
    return HomeCategory(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      name: translation['name'] as String? ?? '',
      slug: translation['slug'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      description: translation['description'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString(),
      displayMode: json['displayMode'] as String?,
      hasChildren: hasChildren,
    );
  }

  @override
  List<Object?> get props => [
    id,
    numericId,
    name,
    slug,
    logoUrl,
    bannerUrl,
    description,
    position,
    status,
    displayMode,
    hasChildren,
  ];
}

/// A product for homepage product carousels.
class HomeProduct extends Equatable {
  final String id;
  final int? numericId;
  final String sku;
  final String type;
  final String? bookingType;
  final String name;
  final String urlKey;
  final String? baseImageUrl;
  final double price;
  final double? minimumPrice;
  final double? specialPrice;
  final String? formattedPrice;
  final String? formattedMinimumPrice;
  final String? formattedSpecialPrice;

  /// Maximum prices (for bundle price ranges)
  final double? maximumPrice;
  final String? formattedMaximumPrice;

  /// Lowest price before discounts (`regularMinimumPrice`).
  final double? regularMinimumPrice;
  final String? formattedRegularMinimumPrice;

  /// Regular maximum price before discounts
  final double? regularMaximumPrice;
  final String? formattedRegularMaximumPrice;

  /// Starting prices (for booking event/rental products)
  final double? startingPrice;
  final String? formattedStartingPrice;
  final double? startingRegularPrice;
  final String? formattedStartingRegularPrice;

  final bool isSaleable;
  final bool isNew;
  final bool isFeatured;
  final double averageRating;
  final int reviewCount;
  final int reviewStarCount;

  const HomeProduct({
    required this.id,
    this.numericId,
    required this.sku,
    required this.type,
    this.bookingType,
    required this.name,
    required this.urlKey,
    this.baseImageUrl,
    required this.price,
    this.minimumPrice,
    this.specialPrice,
    this.formattedPrice,
    this.formattedMinimumPrice,
    this.formattedSpecialPrice,
    this.maximumPrice,
    this.formattedMaximumPrice,
    this.regularMinimumPrice,
    this.formattedRegularMinimumPrice,
    this.regularMaximumPrice,
    this.formattedRegularMaximumPrice,
    this.startingPrice,
    this.formattedStartingPrice,
    this.startingRegularPrice,
    this.formattedStartingRegularPrice,
    required this.isSaleable,
    this.isNew = false,
    this.isFeatured = false,
    this.averageRating = 0,
    this.reviewCount = 0,
    this.reviewStarCount = 0,
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
    final rawReviewCount =
        json['reviews']?['totalCount'] ?? json['reviewCount'];
    final fallbackReviewCount = rawReviewCount is num
        ? rawReviewCount.toInt()
        : int.tryParse(rawReviewCount?.toString() ?? '') ?? ratings.length;
    final starCount = ratings.isNotEmpty
        ? ratings.fold<int>(0, (sum, rating) => sum + rating.round())
        : (fallbackRating * fallbackReviewCount).round();

    final rawNew = json['new'] ?? json['is_new'] ?? json['isNew'];
    final parsedNew =
        rawNew == true || rawNew == '1' || rawNew == 1 || rawNew == 'true';

    final rawFeatured =
        json['featured'] ?? json['is_featured'] ?? json['isFeatured'];
    final parsedFeatured =
        rawFeatured == true ||
        rawFeatured == '1' ||
        rawFeatured == 1 ||
        rawFeatured == 'true';

    // Parse first booking product node if available
    final bookingEdges = json['bookingProducts']?['edges'] as List? ?? [];
    Map<String, dynamic>? firstBookingNode;
    if (bookingEdges.isNotEmpty && bookingEdges.first is Map) {
      firstBookingNode = (bookingEdges.first['node'] as Map<String, dynamic>?);
    }

    return HomeProduct(
      id: json['id']?.toString() ?? '',
      numericId: numId,
      sku: json['sku'] as String? ?? '',
      type: json['type'] as String? ?? 'simple',
      bookingType: json['bookingType']?.toString(),
      name: json['name'] as String? ?? '',
      urlKey: json['urlKey'] as String? ?? '',
      baseImageUrl: json['baseImageUrl'] as String?,
      price: _toDouble(json['price']),
      minimumPrice: json['minimumPrice'] != null
          ? _toDouble(json['minimumPrice'])
          : null,
      specialPrice: parsedSpecialPrice,
      formattedPrice: json['formattedPrice'] as String?,
      formattedMinimumPrice: json['formattedMinimumPrice'] as String?,
      formattedSpecialPrice: json['formattedSpecialPrice'] as String?,
      maximumPrice: json['maximumPrice'] != null
          ? _toDouble(json['maximumPrice'])
          : null,
      formattedMaximumPrice: json['formattedMaximumPrice'] as String?,
      regularMinimumPrice: json['regularMinimumPrice'] != null
          ? _toDouble(json['regularMinimumPrice'])
          : null,
      formattedRegularMinimumPrice:
          json['formattedRegularMinimumPrice'] as String?,
      regularMaximumPrice: json['regularMaximumPrice'] != null
          ? _toDouble(json['regularMaximumPrice'])
          : null,
      formattedRegularMaximumPrice:
          json['formattedRegularMaximumPrice'] as String?,
      startingPrice:
          firstBookingNode != null && firstBookingNode['startingPrice'] != null
          ? _toDouble(firstBookingNode['startingPrice'])
          : json['startingPrice'] != null
          ? _toDouble(json['startingPrice'])
          : null,
      formattedStartingPrice:
          firstBookingNode?['formattedStartingPrice'] as String? ??
          json['formattedStartingPrice'] as String?,
      startingRegularPrice:
          firstBookingNode != null &&
              firstBookingNode['startingRegularPrice'] != null
          ? _toDouble(firstBookingNode['startingRegularPrice'])
          : json['startingRegularPrice'] != null
          ? _toDouble(json['startingRegularPrice'])
          : null,
      formattedStartingRegularPrice:
          firstBookingNode?['formattedStartingRegularPrice'] as String? ??
          json['formattedStartingRegularPrice'] as String?,
      isSaleable:
          json['isSaleable'] == true ||
          json['isSaleable'] == '1' ||
          json['isSaleable'] == 1,
      isNew: parsedNew,
      isFeatured: parsedFeatured,
      averageRating: avgRating,
      reviewCount: fallbackReviewCount,
      reviewStarCount: starCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': numericId,
      'sku': sku,
      'type': type,
      'bookingType': bookingType,
      'name': name,
      'urlKey': urlKey,
      'baseImageUrl': baseImageUrl,
      'price': price,
      'minimumPrice': minimumPrice,
      'specialPrice': specialPrice,
      'formattedPrice': formattedPrice,
      'formattedMinimumPrice': formattedMinimumPrice,
      'formattedSpecialPrice': formattedSpecialPrice,
      'maximumPrice': maximumPrice,
      'formattedMaximumPrice': formattedMaximumPrice,
      'regularMinimumPrice': regularMinimumPrice,
      'formattedRegularMinimumPrice': formattedRegularMinimumPrice,
      'regularMaximumPrice': regularMaximumPrice,
      'formattedRegularMaximumPrice': formattedRegularMaximumPrice,
      'startingPrice': startingPrice,
      'formattedStartingPrice': formattedStartingPrice,
      'startingRegularPrice': startingRegularPrice,
      'formattedStartingRegularPrice': formattedStartingRegularPrice,
      'isSaleable': isSaleable,
      'isNew': isNew,
      'isFeatured': isFeatured,
      'new': isNew ? '1' : '0',
      'featured': isFeatured ? '1' : '0',
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'reviewStarCount': reviewStarCount,
    };
  }

  /// Calculates presentation price, prefix label, and strikethrough price
  /// strictly following Bagisto Web price rules.
  ProductPriceDisplay get priceDisplay =>
      ProductPriceDisplay.fromHomeProduct(this);

  /// Prefix label such as "Starting at", "Starting from", "As low as", or null.
  String? get priceLabelPrefix => priceDisplay.label;

  /// The effective display price: specialPrice > minimumPrice > price
  double get displayPrice {
    if (specialPrice != null && specialPrice! > 0) return specialPrice!;
    if (type == 'configurable' && minimumPrice != null && minimumPrice! > 0) {
      return minimumPrice!;
    }
    return price;
  }

  /// Whether a strikethrough price / discount exists.
  bool get hasDiscount => priceDisplay.hasDiscount;

  /// Whether product cards should show the Sale badge. Grouped products do
  /// not use a strikethrough price, but their API still reports current and
  /// regular minimum prices when one of their items is discounted.
  bool get hasSaleBadge =>
      hasDiscount ||
      (type.toLowerCase() == 'grouped' &&
          minimumPrice != null &&
          minimumPrice! > 0 &&
          regularMinimumPrice != null &&
          regularMinimumPrice! > minimumPrice!);

  /// Discount percentage (0–100).
  int get discountPercent {
    if (regularMinimumPrice != null &&
        minimumPrice != null &&
        minimumPrice! > 0 &&
        minimumPrice! < regularMinimumPrice!) {
      return (((regularMinimumPrice! - minimumPrice!) / regularMinimumPrice!) *
              100)
          .round();
    }
    if (!hasDiscount) return 0;
    if (specialPrice != null && specialPrice! > 0 && specialPrice! < price) {
      return (((price - specialPrice!) / price) * 100).round();
    }
    return 0;
  }

  /// Formatted price to display (e.g. "$150.00" or "$20.00 To $50.00" for bundle).
  String get displayPriceLabel => priceDisplay.displayPrice;

  /// Formatted strikethrough price if regular > current (null for grouped or when no discount).
  String? get originalPriceLabel => priceDisplay.strikethroughPrice;

  @override
  List<Object?> get props => [
    id,
    numericId,
    sku,
    type,
    bookingType,
    name,
    urlKey,
    baseImageUrl,
    price,
    formattedPrice,
    minimumPrice,
    formattedMinimumPrice,
    maximumPrice,
    formattedMaximumPrice,
    specialPrice,
    formattedSpecialPrice,
    regularMinimumPrice,
    formattedRegularMinimumPrice,
    regularMaximumPrice,
    formattedRegularMaximumPrice,
    startingPrice,
    formattedStartingPrice,
    startingRegularPrice,
    formattedStartingRegularPrice,
    isNew,
    isFeatured,
    averageRating,
    reviewCount,
    reviewStarCount,
  ];
}

/// An image entry inside an image_carousel customization.
class BannerImage extends Equatable {
  final String imageUrl;
  final String link;
  final String? title;

  const BannerImage({required this.imageUrl, this.link = '', this.title});

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      imageUrl: json['image'] as String? ?? '',
      link: json['link'] as String? ?? '',
      title: json['title'] as String?,
    );
  }

  /// Category or product slug the banner links to: the last path segment of
  /// [link], which may be a bare slug (`fashion`) or a full storefront URL.
  /// Null when the banner has no link.
  String? get linkSlug => homeLinkSlug(link);

  /// Build full URL from relative path
  String fullImageUrl(String baseUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = imageUrl.startsWith('/')
        ? imageUrl.substring(1)
        : imageUrl;
    return '$cleanBase/$cleanPath';
  }

  @override
  List<Object?> get props => [imageUrl, link, title];
}

/// Category or product slug an admin-configured home link points to: the
/// last path segment of [link], which may be a bare slug (`fashion`) or a
/// full storefront URL. Null when there is no usable segment, or when [link]
/// is a hash-based URL (e.g. `#`, `#formal-wear-men`, `/#...`), which does
/// not navigate on web.
String? homeLinkSlug(String link) {
  final trimmed = link.trim();
  if (trimmed.isEmpty) return null;

  // Hash-based URLs (in-page anchors / placeholders like `#`, `#formal-wear-men`, `/#`)
  // do not navigate anywhere on the web storefront.
  if (trimmed.startsWith('#') || trimmed.startsWith('/#')) {
    return null;
  }

  final uri = Uri.tryParse(trimmed);
  if (uri != null) {
    if (uri.hasFragment && (uri.path.isEmpty || uri.path == '/')) {
      return null;
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty);
    if (segments.isNotEmpty) {
      return segments.last;
    }
  }

  // Bare slug without slashes, colons, or hashes (e.g. "fashion" or "random")
  if (!trimmed.contains('/') &&
      !trimmed.contains(':') &&
      !trimmed.contains('#')) {
    return trimmed;
  }

  return null;
}

/// One entry of a `services_content` customization (icon, title, text).
class HomeService extends Equatable {
  final String title;
  final String description;

  /// Storefront icon class, e.g. `icon-truck`.
  final String icon;

  const HomeService({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Reads `options['services']`, skipping malformed or untitled entries.
  static List<HomeService> listFromOptions(Map<String, dynamic> options) {
    final raw = options['services'] as List? ?? const [];
    return raw
        .whereType<Map>()
        .map(
          (e) => HomeService(
            title: e['title']?.toString().trim() ?? '',
            description: e['description']?.toString().trim() ?? '',
            icon: e['service_icon']?.toString() ?? '',
          ),
        )
        .where((s) => s.title.isNotEmpty)
        .toList();
  }

  @override
  List<Object?> get props => [title, description, icon];
}

/// A single link of a `footer_links` section, as configured in one of the
/// section's two columns.
class HomeFooterLink extends Equatable {
  final String title;
  final String url;

  const HomeFooterLink({required this.title, required this.url});

  /// Reads `options['column_1']` and `options['column_2']` in that order,
  /// skipping malformed entries and entries missing a title or a url. The
  /// returned list always has one entry per column, possibly empty.
  static List<List<HomeFooterLink>> columnsFromOptions(
    Map<String, dynamic> options,
  ) {
    return const ['column_1', 'column_2'].map((key) {
      // A column saved empty can come back as something other than a list,
      // which a bare cast would throw on, taking the whole section down.
      final raw = options[key];
      final entries = raw is List ? raw : const [];
      return entries
          .whereType<Map>()
          .map(
            (entry) => HomeFooterLink(
              title: entry['title']?.toString().trim() ?? '',
              url: entry['url']?.toString().trim() ?? '',
            ),
          )
          .where((link) => link.title.isNotEmpty && link.url.isNotEmpty)
          .toList();
    }).toList();
  }

  /// Absolute `http(s)` URL to open for this link, or `''` when the configured
  /// url cannot be opened.
  ///
  /// Admin saves these against whatever host the panel ran on, so a link
  /// pointing at `localhost` is rewritten onto [publicBaseUrl] (which may
  /// include an install subpath, e.g. `.../mp-app/public`). Relative urls are
  /// resolved against the same base. Anything that is not `http`/`https`
  /// (`javascript:`, `mailto:`, ...) is rejected.
  String resolveUrl(String publicBaseUrl) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.path.isEmpty) return '';
    if (uri.hasScheme && uri.scheme != 'http' && uri.scheme != 'https') {
      return '';
    }

    final isLocalhost =
        uri.host == 'localhost' || uri.host == '127.0.0.1' || uri.host == '::1';
    if (uri.hasScheme && !isLocalhost) return uri.toString();

    // `Uri.resolve` drops the last path segment of a base without a trailing
    // slash, which would strip the install subpath.
    final base = Uri.tryParse(
      publicBaseUrl.endsWith('/') ? publicBaseUrl : '$publicBaseUrl/',
    );
    if (base == null) return '';

    final path = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
    return base
        .resolve(path)
        .replace(
          query: uri.hasQuery ? uri.query : null,
          fragment: uri.hasFragment ? uri.fragment : null,
        )
        .toString();
  }

  @override
  List<Object?> get props => [title, url];
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

/// An id or position the API may send as a number or as text.
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
