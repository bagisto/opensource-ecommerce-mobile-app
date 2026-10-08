import 'dart:convert';
import 'dart:developer' as developer;

import '../../../account/data/models/review_attachment.dart';

/// Product model matching Bagisto GraphQL schema
/// Derived from: nextjs-commerce/src/graphql/catelog/fragments/Product.ts
///               nextjs-commerce/src/types/category/type.ts
class ProductModel {
  final String id;
  final int? numericId; // _id field from API
  final int? qty;
  final String? sku;
  final String? type;
  final String? name;
  final String? urlKey;
  final String? description;
  final String? shortDescription;
  final double? price;
  final String? formattedPrice;
  final String? baseImageUrl;
  final double? minimumPrice;
  final String? formattedMinimumPrice;
  final double? specialPrice;
  final String? formattedSpecialPrice;
  final bool? isSaleable;
  final String? color;
  final String? size;
  final String? brand;
  final double? maximumPrice;
  final String? formattedMaximumPrice;
  final double? regularMinimumPrice;
  final double? regularMaximumPrice;
  final String? formattedRegularMinimumPrice;
  final String? formattedRegularMaximumPrice;
  final bool? guestCheckout;
  final String? superAttributeOptionsJson;
  final String? combinationsJson;
  final List<AttributeValueItem> attributeValues;
  final List<ProductCategory> categories;
  final List<ProductImage> images;
  final List<SuperAttribute> superAttributes;
  final List<ProductVariant> variants;
  final List<ProductReview> reviews;
  final List<ProductModel> relatedProducts;
  final List<DownloadableLink> downloadableLinks;
  final List<DownloadableSample> downloadableSamples;
  final List<GroupedProductItem> groupedProducts;
  final List<BundleOption> bundleOptions;
  final List<BookingProductData> bookingProducts;
  final List<ProductCustomizableOption> customizableOptions;

  const ProductModel({
    required this.id,
    this.numericId,
    this.qty,
    this.sku,
    this.type,
    this.name,
    this.urlKey,
    this.description,
    this.shortDescription,
    this.price,
    this.formattedPrice,
    this.baseImageUrl,
    this.minimumPrice,
    this.formattedMinimumPrice,
    this.specialPrice,
    this.formattedSpecialPrice,
    this.isSaleable,
    this.color,
    this.size,
    this.brand,
    this.maximumPrice,
    this.formattedMaximumPrice,
    this.regularMinimumPrice,
    this.regularMaximumPrice,
    this.formattedRegularMinimumPrice,
    this.formattedRegularMaximumPrice,
    this.guestCheckout,
    this.superAttributeOptionsJson,
    this.combinationsJson,
    this.attributeValues = const [],
    this.categories = const [],
    this.images = const [],
    this.superAttributes = const [],
    this.variants = const [],
    this.reviews = const [],
    this.relatedProducts = const [],
    this.downloadableLinks = const [],
    this.downloadableSamples = const [],
    this.groupedProducts = const [],
    this.bundleOptions = const [],
    this.bookingProducts = const [],
    this.customizableOptions = const [],
  });

  /// Whether the API reports a lower final price than the regular one
  /// (`minimumPrice` below `regularMinimumPrice`). Covers special prices,
  /// catalog rules and configurable/bundle products.
  bool get _hasRegularPriceDiscount =>
      regularMinimumPrice != null &&
      minimumPrice != null &&
      minimumPrice! > 0 &&
      minimumPrice! < regularMinimumPrice!;

  /// Calculate discount percentage
  int? get discountPercent {
    if (_hasRegularPriceDiscount) {
      final discount =
          ((regularMinimumPrice! - minimumPrice!) / regularMinimumPrice! * 100)
              .round();
      return discount > 0 ? discount : null;
    }
    if (specialPrice != null &&
        specialPrice! > 0 &&
        price != null &&
        price! > 0 &&
        specialPrice! < price!) {
      final discount = ((price! - specialPrice!) / price! * 100).round();
      return discount > 0 ? discount : null;
    }
    return null;
  }

  /// Get display price (special > minimum > regular)
  double get displayPrice {
    if (specialPrice != null && specialPrice! > 0) return specialPrice!;
    return minimumPrice ?? price ?? 0;
  }

  String get formattedDisplayPrice {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        (formattedSpecialPrice?.isNotEmpty ?? false)) {
      return formattedSpecialPrice!;
    }
    if (minimumPrice != null &&
        minimumPrice! > 0 &&
        (formattedMinimumPrice?.isNotEmpty ?? false)) {
      return formattedMinimumPrice!;
    }
    if (formattedPrice?.isNotEmpty ?? false) {
      return formattedPrice!;
    }
    return '';
  }

  /// Get original price (for strikethrough) — only if there's a real discount
  double? get originalPrice {
    if (_hasRegularPriceDiscount) return regularMinimumPrice;
    if (specialPrice != null &&
        specialPrice! > 0 &&
        price != null &&
        specialPrice! < price!) {
      return price;
    }
    return null;
  }

  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    if (_hasRegularPriceDiscount &&
        (formattedRegularMinimumPrice?.isNotEmpty ?? false)) {
      return formattedRegularMinimumPrice;
    }
    if (formattedPrice?.isNotEmpty ?? false) {
      return formattedPrice;
    }
    return null;
  }

  /// Average rating
  double get averageRating {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(0, (acc, r) => acc + r.rating);
    return sum / reviews.length;
  }

  /// All image URLs (from images edges, fallback to baseImageUrl)
  List<String> get allImageUrls {
    if (images.isNotEmpty) {
      return images
          .where((img) => img.publicPath != null && img.publicPath!.isNotEmpty)
          .map((img) => img.publicPath!)
          .toList();
    }
    if (baseImageUrl != null && baseImageUrl!.isNotEmpty) {
      return [baseImageUrl!];
    }
    return [];
  }

  /// Total review count
  int get reviewCount => reviews.length;

  /// Whether this is a configurable product
  bool get isConfigurable => type == 'configurable';

  /// Whether this is a virtual product
  bool get isVirtual => type == 'virtual';

  /// Whether this is a downloadable product
  bool get isDownloadable => type == 'downloadable';

  /// Whether this is a grouped product
  bool get isGrouped => type == 'grouped';

  /// Whether this is a bundle product
  bool get isBundle => type == 'bundle';

  /// Whether this is a booking product
  bool get isBooking => type == 'booking';

  /// Build configurable attributes from API data.
  /// Prefers `superAttributeOptions` JSON (new API) and falls back to
  /// deriving options from variants + superAttributes (legacy API).
  List<ConfigurableAttribute> get configurableAttributes {
    if (!isConfigurable) return [];

    // ── New API: parse superAttributeOptions JSON string ──
    if (superAttributeOptionsJson != null &&
        superAttributeOptionsJson!.isNotEmpty) {
      try {
        final List<dynamic> parsed = jsonDecode(superAttributeOptionsJson!);
        developer.log(
          'configurableAttributes: parsed ${parsed.length} attributes from superAttributeOptions',
          name: 'ProductModel',
        );
        final attrs = <ConfigurableAttribute>[];
        for (final attr in parsed) {
          final code = attr['code']?.toString() ?? '';
          final label = attr['label']?.toString() ?? code;
          final rawOptions = attr['options'] as List<dynamic>? ?? [];
          final options = rawOptions.map((opt) {
            final optLabel = opt['label']?.toString() ?? '';
            return ConfigurableOption(
              value: optLabel,
              optionId: opt['id'],
              swatchColor: code == 'color' ? _colorNameToHex(optLabel) : null,
            );
          }).toList();

          if (options.isNotEmpty) {
            attrs.add(
              ConfigurableAttribute(
                code: code,
                label: code == 'size' ? 'Select Size' : label,
                attributeId: _parseInt(attr['id']),
                options: options,
              ),
            );
          }
        }
        if (attrs.isNotEmpty) return attrs;
      } catch (e) {
        developer.log(
          'configurableAttributes: failed to parse superAttributeOptions: $e',
          name: 'ProductModel',
        );
      }
    }

    // ── Legacy: derive from superAttributes + variants ──
    if (variants.isEmpty) return [];

    final attrs = <ConfigurableAttribute>[];
    final declaredCodes = superAttributes
        .map((a) => a.code)
        .whereType<String>()
        .toList();

    for (final code in declaredCodes) {
      final values = <String>{};
      for (final variant in variants) {
        final value = variant.getAttributeValue(code);
        if (value != null && value.isNotEmpty) {
          values.add(value);
        }
      }

      if (values.isEmpty) continue;

      final superAttr = superAttributes.firstWhere((a) => a.code == code);
      final label = code == 'size'
          ? 'Select Size'
          : (superAttr.adminName ?? code);

      final options = values.map((v) {
        return ConfigurableOption(
          value: v,
          swatchColor: code == 'color' ? _colorNameToHex(v) : null,
        );
      }).toList();

      attrs.add(
        ConfigurableAttribute(code: code, label: label, options: options),
      );
    }

    return attrs;
  }

  /// Find a variant matching the selected attributes
  ProductVariant? findVariant(Map<String, String> selectedAttributes) {
    if (variants.isEmpty || selectedAttributes.isEmpty) return null;

    for (final variant in variants) {
      bool matches = true;
      for (final entry in selectedAttributes.entries) {
        final variantValue = variant.getAttributeValue(entry.key);
        if (variantValue != entry.value) {
          matches = false;
          break;
        }
      }
      if (matches) return variant;
    }
    return null;
  }

  /// Get available selection IDs for an attribute given current selections.
  /// Uses combinations JSON (new API) or variant data (legacy).
  /// Returns a set of selectionId strings (option IDs or labels).
  Set<String> getAvailableValues(
    String attributeCode,
    Map<String, String> otherSelections,
  ) {
    // ── New API: use combinations ──
    if (combinationsJson != null && combinationsJson!.isNotEmpty) {
      return _getAvailableFromCombinations(attributeCode, otherSelections);
    }

    // ── Legacy: use variants ──
    final available = <String>{};
    for (final variant in variants) {
      bool matchesOthers = true;
      for (final entry in otherSelections.entries) {
        if (entry.key == attributeCode) continue;
        final variantValue = variant.getAttributeValue(entry.key);
        if (variantValue != entry.value) {
          matchesOthers = false;
          break;
        }
      }
      if (matchesOthers) {
        final val = variant.getAttributeValue(attributeCode);
        if (val != null && val.isNotEmpty) {
          available.add(val);
        }
      }
    }
    return available;
  }

  Set<String> _getAvailableFromCombinations(
    String attributeCode,
    Map<String, String> otherSelections,
  ) {
    try {
      final Map<String, dynamic> combos = jsonDecode(combinationsJson!);
      final available = <String>{};

      for (final combo in combos.values) {
        final attrs = combo as Map<String, dynamic>;
        bool matchesOthers = true;

        for (final sel in otherSelections.entries) {
          if (sel.key == attributeCode) continue;
          if (attrs[sel.key]?.toString() != sel.value) {
            matchesOthers = false;
            break;
          }
        }

        if (matchesOthers) {
          final val = attrs[attributeCode];
          if (val != null) available.add(val.toString());
        }
      }
      return available;
    } catch (_) {
      return {};
    }
  }

  /// Get the combination entry for a variant ID.
  /// Returns e.g. {"color": 2, "size": 8} for variant 11.
  Map<String, dynamic>? getCombinationForVariant(int variantId) {
    if (combinationsJson == null) return null;
    try {
      final Map<String, dynamic> combos = jsonDecode(combinationsJson!);
      final entry = combos[variantId.toString()];
      if (entry is Map<String, dynamic>) return entry;
    } catch (_) {}
    return null;
  }

  /// Find variant ID from combinations JSON using selected option IDs.
  /// [selectedOptionIds] maps attribute code -> option ID string.
  /// Returns the variant numeric ID if a match is found.
  int? findVariantIdFromCombinations(Map<String, String> selectedOptionIds) {
    if (combinationsJson == null || selectedOptionIds.isEmpty) return null;
    try {
      final Map<String, dynamic> combos = jsonDecode(combinationsJson!);
      for (final entry in combos.entries) {
        final attrs = entry.value as Map<String, dynamic>;
        if (attrs.length != selectedOptionIds.length) continue;

        bool matches = true;
        for (final sel in selectedOptionIds.entries) {
          if (attrs[sel.key]?.toString() != sel.value) {
            matches = false;
            break;
          }
        }
        if (matches) return int.tryParse(entry.key);
      }
    } catch (_) {}
    return null;
  }

  /// Find a variant by its numeric ID (from combinations lookup).
  /// Parses the trailing number from the variant's "/api/shop/products/2420" ID.
  ProductVariant? findVariantById(int variantId) {
    if (variants.isEmpty) return null;
    for (final variant in variants) {
      final vid = variant.numericId ?? int.tryParse(variant.id.split('/').last);
      if (vid == variantId) return variant;
    }
    return null;
  }

  /// Resolve the numeric attribute ID for a configurable attribute code.
  int? getConfigurableAttributeId(String attributeCode) {
    for (final attribute in configurableAttributes) {
      if (attribute.code == attributeCode) {
        return attribute.attributeId;
      }
    }
    return null;
  }

  /// Map color name to hex for swatch rendering
  static String? _colorNameToHex(String name) {
    final map = {
      'red': '#FF0000',
      'green': '#00FF00',
      'yellow': '#FFFF00',
      'black': '#000000',
      'white': '#FFFFFF',
      'blue': '#0000FF',
      'orange': '#FFA500',
      'ash grey': '#B2BEB5',
      'palatinate purple': '#682860',
      'dark lava': '#483C32',
      'charcoal': '#36454F',
      'lavender grey': '#C4C3D0',
      'pink': '#FFC0CB',
      'brown': '#8B4513',
      'navy': '#000080',
      'grey': '#808080',
      'gray': '#808080',
      'beige': '#F5F5DC',
      'maroon': '#800000',
      'teal': '#008080',
      'coral': '#FF7F50',
      'ivory': '#FFFFF0',
    };
    return map[name.toLowerCase()];
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Debug: log raw fields from API
    developer.log(
      'ProductModel[${json['name']}] type=${json['type']} '
      'superAttributeOptions=${json['superAttributeOptions']?.runtimeType} '
      'combinations=${json['combinations']?.runtimeType} '
      'variants=${json['variants'] != null ? 'present' : 'null'}',
      name: 'ProductModel',
    );

    return ProductModel(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      qty: _parseInt(json['qty']),
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      price: _parseDouble(json['price']),
      formattedPrice: json['formattedPrice'] as String?,
      baseImageUrl: json['baseImageUrl'] as String?,
      minimumPrice: _parseDouble(json['minimumPrice']),
      formattedMinimumPrice: json['formattedMinimumPrice'] as String?,
      specialPrice: _parseSpecialPrice(json['specialPrice']),
      formattedSpecialPrice: json['formattedSpecialPrice'] as String?,
      isSaleable: _parseBool(json['isSaleable']),
      color: json['color'] as String?,
      size: json['size'] as String?,
      brand: json['brand'] as String?,
      maximumPrice: _parseDouble(json['maximumPrice']),
      formattedMaximumPrice: json['formattedMaximumPrice'] as String?,
      regularMinimumPrice: _parseDouble(json['regularMinimumPrice']),
      regularMaximumPrice: _parseDouble(json['regularMaximumPrice']),
      formattedRegularMinimumPrice:
          json['formattedRegularMinimumPrice'] as String?,
      formattedRegularMaximumPrice:
          json['formattedRegularMaximumPrice'] as String?,
      guestCheckout: _parseBool(json['guestCheckout']),
      superAttributeOptionsJson: _toJsonString(json['superAttributeOptions']),
      combinationsJson: _toJsonString(json['combinations']),
      attributeValues: _parseAttributeValues(json['attributeValues']),
      categories: _parseCategories(json['categories']),
      images: _parseImages(json['images']),
      superAttributes: _parseSuperAttributes(json['superAttributes']),
      variants: _parseVariants(json['variants']),
      reviews: _parseReviews(json['reviews']),
      relatedProducts: _parseRelatedProducts(json['relatedProducts']),
      downloadableLinks: _parseDownloadableLinks(json['downloadableLinks']),
      downloadableSamples: _parseDownloadableSamples(
        json['downloadableSamples'],
      ),
      groupedProducts: _parseGroupedProducts(json['groupedProducts']),
      bundleOptions: _parseBundleOptions(json['bundleOptions']),
      bookingProducts: _parseBookingProducts(json['bookingProducts']),
      customizableOptions: _parseCustomizableOptions(
        json['customizableOptions'],
      ),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Normalize a value that may be a JSON string, List, or Map into a JSON string.
  /// Handles GraphQL clients that auto-parse JSON scalar fields.
  static String? _toJsonString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isNotEmpty ? value : null;
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
  }

  /// Parse specialPrice — treat "0" or 0 as null (no special price)
  static double? _parseSpecialPrice(dynamic value) {
    final parsed = _parseDouble(value);
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  /// Parse isSaleable which comes as String "1"/"0" from API
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    if (value is int) return value == 1;
    return null;
  }

  static List<ProductVariant> _parseVariants(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => ProductVariant.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<ProductReview> _parseReviews(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => ProductReview.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<ProductImage> _parseImages(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => ProductImage.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<SuperAttribute> _parseSuperAttributes(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => SuperAttribute.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<AttributeValueItem> _parseAttributeValues(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) => AttributeValueItem.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }

  static List<ProductCategory> _parseCategories(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => ProductCategory.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<ProductModel> _parseRelatedProducts(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => ProductModel.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<DownloadableLink> _parseDownloadableLinks(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) => DownloadableLink.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }

  static List<DownloadableSample> _parseDownloadableSamples(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) => DownloadableSample.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }

  static List<GroupedProductItem> _parseGroupedProducts(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) => GroupedProductItem.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }

  static List<BundleOption> _parseBundleOptions(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => BundleOption.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static List<BookingProductData> _parseBookingProducts(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) => BookingProductData.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }

  static List<ProductCustomizableOption> _parseCustomizableOptions(
    dynamic json,
  ) {
    if (json == null) return [];

    if (json is Map<String, dynamic>) {
      final edges = json['edges'] as List<dynamic>?;
      if (edges != null) {
        return edges
            .map(
              (e) => ProductCustomizableOption.fromJson(
                e['node'] as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      final values = json['data'] as List<dynamic>?;
      if (values != null) {
        return values
            .whereType<Map<String, dynamic>>()
            .map(ProductCustomizableOption.fromJson)
            .toList();
      }
    }

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(ProductCustomizableOption.fromJson)
          .toList();
    }

    return [];
  }
}

class ProductCustomizableOption {
  final String id;
  final int? numericId;
  final String? type;
  final bool isRequired;
  final int? maxCharacters;
  final String? supportedFileExtensions;
  final int? sortOrder;
  final String? label;
  final List<ProductCustomizableOptionPrice> prices;

  const ProductCustomizableOption({
    required this.id,
    this.numericId,
    this.type,
    this.isRequired = false,
    this.maxCharacters,
    this.supportedFileExtensions,
    this.sortOrder,
    this.label,
    this.prices = const [],
  });

  factory ProductCustomizableOption.fromJson(Map<String, dynamic> json) {
    final translation = json['translation'] as Map<String, dynamic>?;
    return ProductCustomizableOption(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      type: json['type']?.toString(),
      isRequired:
          ProductModel._parseBool(json['isRequired'] ?? json['is_required']) ??
          false,
      maxCharacters: ProductModel._parseInt(
        json['maxCharacters'] ?? json['max_characters'],
      ),
      supportedFileExtensions:
          (json['supportedFileExtensions'] ?? json['supported_file_extensions'])
              ?.toString(),
      sortOrder: ProductModel._parseInt(
        json['sortOrder'] ?? json['sort_order'],
      ),
      label: json['label']?.toString() ?? translation?['label']?.toString(),
      prices: _parsePrices(
        json['customizableOptionPrices'] ??
            json['customizable_option_prices'] ??
            json['prices'],
      ),
    );
  }

  String get normalizedType => (type ?? '').toLowerCase().trim();

  bool get hasChoicePrices =>
      normalizedType == 'checkbox' ||
      normalizedType == 'radio' ||
      normalizedType == 'select' ||
      normalizedType == 'multiselect';

  bool get isMultiValue =>
      normalizedType == 'checkbox' || normalizedType == 'multiselect';

  String get displayLabel => (label?.isNotEmpty ?? false) ? label! : 'Option';

  ProductCustomizableOptionPrice? get singlePriceOption =>
      prices.isNotEmpty ? prices.first : null;

  List<String> get supportedFileExtensionList {
    final rawValue = supportedFileExtensions?.trim();
    if (rawValue == null || rawValue.isEmpty) return const [];

    final values = <String>[];
    for (final item in rawValue.split(',')) {
      final extension = item.trim().replaceFirst('.', '').toLowerCase();
      if (extension.isNotEmpty && !values.contains(extension)) {
        values.add(extension);
      }
    }

    return values;
  }

  bool allowsFileName(String fileName) {
    final allowedExtensions = supportedFileExtensionList;
    if (allowedExtensions.isEmpty) return true;

    final index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) return false;

    final extension = fileName.substring(index + 1).toLowerCase();
    return allowedExtensions.contains(extension);
  }

  static List<ProductCustomizableOptionPrice> _parsePrices(dynamic json) {
    if (json == null) return [];

    if (json is Map<String, dynamic>) {
      final edges = json['edges'] as List<dynamic>?;
      if (edges != null) {
        return edges
            .map(
              (e) => ProductCustomizableOptionPrice.fromJson(
                e['node'] as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      final values = json['data'] as List<dynamic>?;
      if (values != null) {
        return values
            .whereType<Map<String, dynamic>>()
            .map(ProductCustomizableOptionPrice.fromJson)
            .toList();
      }
    }

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(ProductCustomizableOptionPrice.fromJson)
          .toList();
    }

    return [];
  }
}

class ProductCustomizableOptionPrice {
  final String id;
  final int? numericId;
  final String? label;
  final double? price;
  final String? formattedPrice;
  final int? sortOrder;

  const ProductCustomizableOptionPrice({
    required this.id,
    this.numericId,
    this.label,
    this.price,
    this.formattedPrice,
    this.sortOrder,
  });

  factory ProductCustomizableOptionPrice.fromJson(Map<String, dynamic> json) {
    return ProductCustomizableOptionPrice(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      label: json['label']?.toString(),
      price: ProductModel._parseDouble(json['price']),
      formattedPrice: json['formattedPrice']?.toString(),
      sortOrder: ProductModel._parseInt(
        json['sortOrder'] ?? json['sort_order'],
      ),
    );
  }

  String get displayLabel {
    final name = label?.trim() ?? '';
    final priceLabel = formattedPrice?.trim() ?? '';
    if (name.isEmpty) return priceLabel;
    if (priceLabel.isEmpty) return name;
    return '$name + $priceLabel';
  }
}

class GroupedProductItem {
  final String id;
  final int? qty;
  final int? sortOrder;
  final ProductModel? associatedProduct;

  const GroupedProductItem({
    required this.id,
    this.qty,
    this.sortOrder,
    this.associatedProduct,
  });

  factory GroupedProductItem.fromJson(Map<String, dynamic> json) {
    final associated = json['associatedProduct'] as Map<String, dynamic>?;
    return GroupedProductItem(
      id: json['id']?.toString() ?? '',
      qty: ProductModel._parseInt(json['qty']),
      sortOrder: ProductModel._parseInt(json['sortOrder']),
      associatedProduct: associated != null
          ? ProductModel.fromJson(associated)
          : null,
    );
  }
}

class BundleOption {
  final String id;
  final String? type;
  final bool isRequired;
  final int? sortOrder;
  final String? label;
  final List<BundleOptionProduct> bundleOptionProducts;

  const BundleOption({
    required this.id,
    this.type,
    this.isRequired = false,
    this.sortOrder,
    this.label,
    this.bundleOptionProducts = const [],
  });

  factory BundleOption.fromJson(Map<String, dynamic> json) {
    final translation = json['translation'] as Map<String, dynamic>?;
    return BundleOption(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String?,
      isRequired: ProductModel._parseBool(json['isRequired']) ?? false,
      sortOrder: ProductModel._parseInt(json['sortOrder']),
      label: translation?['label'] as String?,
      bundleOptionProducts: _parseBundleOptionProducts(
        json['bundleOptionProducts'],
      ),
    );
  }

  static List<BundleOptionProduct> _parseBundleOptionProducts(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map(
          (e) =>
              BundleOptionProduct.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
  }
}

class BundleOptionProduct {
  final String id;
  final int? qty;
  final bool isDefault;
  final bool isUserDefined;
  final int? sortOrder;
  final ProductModel? product;

  const BundleOptionProduct({
    required this.id,
    this.qty,
    this.isDefault = false,
    this.isUserDefined = false,
    this.sortOrder,
    this.product,
  });

  factory BundleOptionProduct.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>?;
    return BundleOptionProduct(
      id: json['id']?.toString() ?? '',
      qty: ProductModel._parseInt(json['qty']),
      isDefault: ProductModel._parseBool(json['isDefault']) ?? false,
      isUserDefined: ProductModel._parseBool(json['isUserDefined']) ?? false,
      sortOrder: ProductModel._parseInt(json['sortOrder']),
      product: productJson != null ? ProductModel.fromJson(productJson) : null,
    );
  }
}

class BookingProductData {
  final String id;
  final int? numericId;
  final String? type;
  final int qty;
  final String? location;
  final bool showLocation;

  /// Whether a booked slot can be canceled; null when the API omits it.
  final bool? allowCancellation;
  final String? availableFrom;
  final String? availableTo;
  final BookingSlotData? defaultSlot;
  final BookingSlotData? appointmentSlot;
  final BookingSlotData? rentalSlot;
  final BookingSlotData? tableSlot;
  final List<BookingEventTicket> eventTickets;

  const BookingProductData({
    required this.id,
    this.numericId,
    this.type,
    this.qty = 1,
    this.location,
    this.showLocation = false,
    this.allowCancellation,
    this.availableFrom,
    this.availableTo,
    this.defaultSlot,
    this.appointmentSlot,
    this.rentalSlot,
    this.tableSlot,
    this.eventTickets = const [],
  });

  factory BookingProductData.fromJson(Map<String, dynamic> json) {
    return BookingProductData(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      type: json['type']?.toString(),
      qty: ProductModel._parseInt(json['qty']) ?? 1,
      location: json['location']?.toString(),
      showLocation: ProductModel._parseBool(json['showLocation']) ?? false,
      allowCancellation: ProductModel._parseBool(json['allowCancellation']),
      availableFrom: json['availableFrom']?.toString(),
      availableTo: json['availableTo']?.toString(),
      defaultSlot: BookingSlotData.fromDynamic(json['defaultSlot']),
      appointmentSlot: BookingSlotData.fromDynamic(json['appointmentSlot']),
      rentalSlot: BookingSlotData.fromDynamic(json['rentalSlot']),
      tableSlot: BookingSlotData.fromDynamic(json['tableSlot']),
      eventTickets: BookingEventTicket.parseList(json['eventTickets']),
    );
  }

  BookingSlotData? get activeSlot {
    switch ((type ?? '').toLowerCase().trim()) {
      case 'default':
        return defaultSlot;
      case 'appointment':
        return appointmentSlot;
      case 'rental':
        return rentalSlot;
      case 'table':
        return tableSlot;
      default:
        return null;
    }
  }

  /// Weekdays that have booking slots, in Bagisto's numbering
  /// (0 = Sunday … 6 = Saturday). Null when every day in the availability
  /// window can be booked, or the slot data is not understood.
  Set<int>? get bookableWeekdays {
    final slot = activeSlot;
    if (slot == null) return null;
    final raw = BookingSlotData.decodeSlots(slot.slots);

    // Per-day slots: {"0": [...], "1": [...], ...}.
    if (raw is Map) {
      return {
        for (final entry in raw.entries)
          if (entry.value is List && (entry.value as List).isNotEmpty)
            ?int.tryParse('${entry.key}'),
      };
    }

    if (raw is! List) return null;

    // Per-day slots as a list indexed by weekday: [[...], [], ...].
    if (raw.isNotEmpty && raw.every((day) => day is List)) {
      return {
        for (var day = 0; day < raw.length && day < 7; day++)
          if ((raw[day] as List).isNotEmpty) day,
      };
    }

    // Default "one" booking: ranges from from_day to to_day.
    final ranges = raw.whereType<Map>().where(
      (s) => s['from_day'] != null && s['to_day'] != null,
    );
    if (ranges.isNotEmpty) {
      final days = <int>{};
      for (final range in ranges) {
        final from = int.tryParse('${range['from_day']}');
        final to = int.tryParse('${range['to_day']}');
        if (from == null || to == null) continue;
        for (var day = from; ; day = (day + 1) % 7) {
          days.add(day);
          if (day == to || days.length == 7) break;
        }
      }
      return days;
    }

    // Same slots every day.
    return raw.isEmpty ? <int>{} : null;
  }

  /// Whether [date]'s weekday has booking slots.
  bool isBookableOn(DateTime date) =>
      bookableWeekdays?.contains(date.weekday % 7) ?? true;
}

class BookingSlotData {
  final String? id;
  final int? numericId;
  final int? bookingProductId;
  final String? bookingType;
  final int? duration;
  final int? breakTime;
  final String? rentingType;
  final double? dailyPrice;
  final double? hourlyPrice;
  final dynamic slots;

  const BookingSlotData({
    this.id,
    this.numericId,
    this.bookingProductId,
    this.bookingType,
    this.duration,
    this.breakTime,
    this.rentingType,
    this.dailyPrice,
    this.hourlyPrice,
    this.slots,
  });

  factory BookingSlotData.fromJson(Map<String, dynamic> json) {
    return BookingSlotData(
      id: json['id']?.toString(),
      numericId: ProductModel._parseInt(json['_id']),
      bookingProductId: ProductModel._parseInt(json['bookingProductId']),
      bookingType: json['bookingType']?.toString(),
      duration: ProductModel._parseInt(json['duration']),
      breakTime: ProductModel._parseInt(json['breakTime']),
      rentingType: json['rentingType']?.toString(),
      dailyPrice: ProductModel._parseDouble(json['dailyPrice']),
      hourlyPrice: ProductModel._parseDouble(json['hourlyPrice']),
      slots: json['slots'],
    );
  }

  /// Slot JSON arrives as a string or already decoded; returns the decoded
  /// value, or null when it cannot be read.
  static dynamic decodeSlots(dynamic source) {
    if (source is String) {
      try {
        return jsonDecode(source);
      } catch (_) {
        return null;
      }
    }
    return source;
  }

  static BookingSlotData? fromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return BookingSlotData.fromJson(value);
    }
    return null;
  }

  List<String> slotRanges() {
    return _extractSlotRanges(slots);
  }

  int get resolvedBookingId =>
      bookingProductId ?? numericId ?? int.tryParse(id ?? '') ?? 0;

  static List<String> _extractSlotRanges(dynamic source) {
    if (source == null) return const [];

    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty) return const [];
      try {
        final decoded = jsonDecode(trimmed);
        return _extractSlotRanges(decoded);
      } catch (_) {
        return trimmed
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    if (source is List) {
      final values = <String>[];
      for (final item in source) {
        values.addAll(_extractSlotRanges(item));
      }
      return values.toSet().toList();
    }

    if (source is Map) {
      if (source.containsKey('from') && source.containsKey('to')) {
        final from = source['from']?.toString();
        final to = source['to']?.toString();
        if ((from ?? '').isNotEmpty && (to ?? '').isNotEmpty) {
          return ['${from!} - ${to!}'];
        }
      }

      final values = <String>[];
      for (final entryValue in source.values) {
        values.addAll(_extractSlotRanges(entryValue));
      }
      return values.toSet().toList();
    }

    return const [];
  }
}

class BookingSlotOption {
  final int slotId;
  final String label;
  final String? from;
  final String? to;
  final String? time;
  final String? timestamp;
  final int? qty;

  const BookingSlotOption({
    required this.slotId,
    required this.label,
    this.from,
    this.to,
    this.time,
    this.timestamp,
    this.qty,
  });

  factory BookingSlotOption.fromStandardJson(Map<String, dynamic> json) {
    final from = json['from']?.toString().trim();
    final to = json['to']?.toString().trim();
    return BookingSlotOption(
      slotId: ProductModel._parseInt(json['slotId']) ?? 0,
      from: from,
      to: to,
      timestamp: json['timestamp']?.toString(),
      qty: ProductModel._parseInt(json['qty']),
      label: [
        if ((from ?? '').isNotEmpty) from,
        if ((to ?? '').isNotEmpty) to,
      ].join(' - '),
    );
  }

  static List<BookingSlotOption> fromRentalSummaryJson(
    Map<String, dynamic> json,
  ) {
    final slotId = ProductModel._parseInt(json['slotId']) ?? 0;
    final time = json['time']?.toString().trim();
    final slots = BookingSlotData._extractSlotRanges(json['slots']);
    final labels = slots.isNotEmpty
        ? slots
        : <String>[(time ?? '').isNotEmpty ? time! : 'Slot $slotId'];

    return labels
        .map(
          (label) =>
              BookingSlotOption(slotId: slotId, time: time, label: label),
        )
        .toList();
  }
}

class BookingEventTicket {
  final String id;
  final int? numericId;
  final int? bookingProductId;
  final double? price;
  final String? formattedPrice;
  final int qty;
  final double? specialPrice;
  final String? formattedSpecialPrice;
  final String? name;
  final String? description;

  const BookingEventTicket({
    required this.id,
    this.numericId,
    this.bookingProductId,
    this.price,
    this.formattedPrice,
    this.qty = 0,
    this.specialPrice,
    this.formattedSpecialPrice,
    this.name,
    this.description,
  });

  factory BookingEventTicket.fromJson(Map<String, dynamic> json) {
    final translation = json['translation'] as Map<String, dynamic>?;
    return BookingEventTicket(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      bookingProductId: ProductModel._parseInt(json['bookingProductId']),
      price: ProductModel._parseDouble(json['price']),
      formattedPrice: json['formattedPrice'] as String?,
      qty: ProductModel._parseInt(json['qty']) ?? 0,
      specialPrice: ProductModel._parseSpecialPrice(json['specialPrice']),
      formattedSpecialPrice: json['formattedSpecialPrice'] as String?,
      name: json['name']?.toString() ?? translation?['name']?.toString(),
      description:
          json['description']?.toString() ??
          translation?['description']?.toString(),
    );
  }

  static List<BookingEventTicket> parseList(dynamic json) {
    if (json == null) return const [];

    if (json is Map<String, dynamic>) {
      final edges = json['edges'] as List<dynamic>?;
      if (edges == null) return const [];
      return edges
          .map(
            (e) =>
                BookingEventTicket.fromJson(e['node'] as Map<String, dynamic>),
          )
          .toList();
    }

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(BookingEventTicket.fromJson)
          .toList();
    }

    return const [];
  }

  int get resolvedId => bookingProductId ?? numericId ?? int.tryParse(id) ?? 0;

  String get displayPriceLabel {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        (formattedSpecialPrice?.isNotEmpty ?? false)) {
      return formattedSpecialPrice!;
    }
    if (formattedPrice?.isNotEmpty ?? false) {
      return formattedPrice!;
    }
    return '';
  }

  String? get originalPriceLabel {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        price != null &&
        specialPrice! < price! &&
        (formattedPrice?.isNotEmpty ?? false)) {
      return formattedPrice;
    }
    return null;
  }
}

class ProductVariant {
  final String id;
  final int? numericId;
  final String? sku;
  final String? name;
  final double? price;
  final String? formattedPrice;
  final double? specialPrice;
  final String? formattedSpecialPrice;
  final String? baseImageUrl;
  final String? isSaleable;
  final String? color;
  final String? size;

  /// Attribute values from new API (code -> label, e.g. "color" -> "Blue")
  final Map<String, String> attributeValuesMap;

  const ProductVariant({
    required this.id,
    this.numericId,
    this.sku,
    this.name,
    this.price,
    this.formattedPrice,
    this.specialPrice,
    this.formattedSpecialPrice,
    this.baseImageUrl,
    this.isSaleable,
    this.color,
    this.size,
    this.attributeValuesMap = const {},
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    // Parse attributeValues edges into a code -> value map
    final attrMap = <String, String>{};
    final attrValues = json['attributeValues'];
    if (attrValues != null) {
      final edges = attrValues['edges'] as List<dynamic>?;
      if (edges != null) {
        for (final edge in edges) {
          final node = edge['node'] as Map<String, dynamic>?;
          if (node == null) continue;
          final value = node['value']?.toString();
          final attribute = node['attribute'] as Map<String, dynamic>?;
          final code = attribute?['code']?.toString();
          if (code != null &&
              code.isNotEmpty &&
              value != null &&
              value.isNotEmpty) {
            attrMap[code] = value;
          }
        }
      }
    }

    return ProductVariant(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      price: ProductModel._parseDouble(json['price']),
      formattedPrice: json['formattedPrice'] as String?,
      specialPrice: ProductModel._parseSpecialPrice(json['specialPrice']),
      formattedSpecialPrice: json['formattedSpecialPrice'] as String?,
      baseImageUrl: json['baseImageUrl'] as String?,
      isSaleable: json['isSaleable'] as String?,
      color: json['color'] as String? ?? attrMap['color'],
      size: json['size'] as String? ?? attrMap['size'],
      attributeValuesMap: attrMap,
    );
  }

  /// Get attribute value by code (e.g. 'color' -> 'Blue')
  /// Checks new attributeValuesMap first, falls back to legacy fields.
  String? getAttributeValue(String code) {
    if (attributeValuesMap.containsKey(code)) {
      return attributeValuesMap[code];
    }
    switch (code) {
      case 'color':
        return color;
      case 'size':
        return size;
      default:
        return null;
    }
  }

  /// Display price for this variant
  double get displayPrice {
    if (specialPrice != null && specialPrice! > 0) return specialPrice!;
    return price ?? 0;
  }

  double? get originalPrice {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        price != null &&
        specialPrice! < price!) {
      return price;
    }
    return null;
  }

  String get displayPriceLabel {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        (formattedSpecialPrice?.isNotEmpty ?? false)) {
      return formattedSpecialPrice!;
    }
    if (formattedPrice?.isNotEmpty ?? false) {
      return formattedPrice!;
    }
    return '';
  }

  String? get originalPriceLabel {
    if (originalPrice == null) return null;
    if (formattedPrice?.isNotEmpty ?? false) {
      return formattedPrice;
    }
    return null;
  }
}

class ProductReview {
  final String id;
  final double rating;
  final String? name;
  final String? title;
  final String? comment;
  final String? createdAt;
  final List<ReviewAttachment> attachments;

  const ProductReview({
    required this.id,
    required this.rating,
    this.name,
    this.title,
    this.comment,
    this.createdAt,
    this.attachments = const [],
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id']?.toString() ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as double? ?? 0),
      name: json['name'] as String?,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] as String?,
      attachments: ReviewAttachment.parseList(json['attachments']),
    );
  }

  /// Get label for rating value (Very Good, Good, Average, Bad, Very Bad)
  String get ratingLabel {
    if (rating >= 4.5) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 2.5) return 'Average';
    if (rating >= 1.5) return 'Bad';
    return 'Very Bad';
  }
}

/// Product image from images cursor connection
class ProductImage {
  final String id;
  final int? numericId;
  final String? type;
  final String path;
  final String? publicPath;
  final String? position;

  const ProductImage({
    required this.id,
    this.numericId,
    this.type,
    required this.path,
    this.publicPath,
    this.position,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      type: json['type'] as String?,
      path: json['path'] as String? ?? '',
      publicPath: json['publicPath'] as String?,
      position: json['position'] as String?,
    );
  }
}

/// Super attribute (e.g., size, color) with options
class SuperAttribute {
  final String id;
  final int? numericId;
  final String? code;
  final String? adminName;
  final List<AttributeOption> options;

  const SuperAttribute({
    required this.id,
    this.numericId,
    this.code,
    this.adminName,
    this.options = const [],
  });

  factory SuperAttribute.fromJson(Map<String, dynamic> json) {
    return SuperAttribute(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      code: json['code'] as String?,
      adminName: json['adminName'] as String?,
      options: _parseOptions(json['options']),
    );
  }

  static List<AttributeOption> _parseOptions(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => AttributeOption.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }
}

/// Attribute option (e.g., "XS", "Red", etc.)
class AttributeOption {
  final String id;
  final int? numericId;
  final String? adminName;
  final String? swatchValue;
  final String? swatchValueUrl;
  final String? label; // from translation

  const AttributeOption({
    required this.id,
    this.numericId,
    this.adminName,
    this.swatchValue,
    this.swatchValueUrl,
    this.label,
  });

  factory AttributeOption.fromJson(Map<String, dynamic> json) {
    String? label;
    final translation = json['translation'];
    if (translation != null && translation is Map<String, dynamic>) {
      label = translation['label'] as String?;
    }
    return AttributeOption(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      adminName: json['adminName'] as String?,
      swatchValue: json['swatchValue'] as String?,
      swatchValueUrl: json['swatchValueUrl'] as String?,
      label: label ?? json['adminName'] as String?,
    );
  }

  /// Check if this is a color swatch (has hex value)
  bool get isColorSwatch =>
      swatchValue != null &&
      swatchValue!.isNotEmpty &&
      swatchValue!.startsWith('#');
}

/// Configurable attribute from superAttributeOptions or legacy superAttributes
class ConfigurableAttribute {
  final String code; // e.g. "color", "size"
  final String label; // e.g. "Color", "Select Size"
  final int?
  attributeId; // attribute ID from superAttributeOptions (for cart payload)
  final List<ConfigurableOption> options;

  const ConfigurableAttribute({
    required this.code,
    required this.label,
    this.attributeId,
    this.options = const [],
  });
}

/// An option for a configurable attribute
class ConfigurableOption {
  final String value; // option label: "Blue", "S"
  final dynamic optionId; // API option id (int) for use with combinations
  final String? swatchColor; // hex color for color swatches
  final bool isAvailable;

  const ConfigurableOption({
    required this.value,
    this.optionId,
    this.swatchColor,
    this.isAvailable = true,
  });

  /// Selection identifier — option ID when available (new API), label otherwise (legacy)
  String get selectionId => optionId?.toString() ?? value;
}

/// Attribute value from product-level attributeValues field
class AttributeValueItem {
  final String? value;
  final String? attributeCode;
  final String? attributeAdminName;

  const AttributeValueItem({
    this.value,
    this.attributeCode,
    this.attributeAdminName,
  });

  factory AttributeValueItem.fromJson(Map<String, dynamic> json) {
    final attribute = json['attribute'] as Map<String, dynamic>?;
    return AttributeValueItem(
      value: json['value']?.toString(),
      attributeCode: attribute?['code']?.toString(),
      attributeAdminName: attribute?['adminName']?.toString(),
    );
  }
}

/// Product category
class ProductCategory {
  final String id;
  final String? name;

  const ProductCategory({required this.id, this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    final translation = json['translation'] as Map<String, dynamic>?;
    return ProductCategory(
      id: json['id']?.toString() ?? '',
      name: translation?['name'] as String?,
    );
  }
}

/// Pagination info model matching GraphQL pageInfo
class PageInfo {
  final String? startCursor;
  final String? endCursor;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PageInfo({
    this.startCursor,
    this.endCursor,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      startCursor: json['startCursor'] as String?,
      endCursor: json['endCursor'] as String?,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

/// Paginated products response
class PaginatedProducts {
  final int totalCount;
  final PageInfo pageInfo;
  final List<ProductModel> products;

  const PaginatedProducts({
    required this.totalCount,
    required this.pageInfo,
    required this.products,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final data = json['products'] as Map<String, dynamic>;
    final edges = data['edges'] as List<dynamic>? ?? [];

    return PaginatedProducts(
      totalCount: data['totalCount'] as int? ?? 0,
      pageInfo: PageInfo.fromJson(data['pageInfo'] as Map<String, dynamic>),
      products: edges
          .map((e) => ProductModel.fromJson(e['node'] as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DownloadableLink {
  final String id;
  final int? numericId;
  final String? type;
  final double? price;
  final String? formattedPrice;
  final int? downloads;
  final int? sortOrder;
  final String? fileUrl;
  final String? sampleFileUrl;
  final String? title;

  const DownloadableLink({
    required this.id,
    this.numericId,
    this.type,
    this.price,
    this.formattedPrice,
    this.downloads,
    this.sortOrder,
    this.fileUrl,
    this.sampleFileUrl,
    this.title,
  });

  factory DownloadableLink.fromJson(Map<String, dynamic> json) {
    String? title;
    final translation = json['translation'];
    if (translation != null && translation is Map<String, dynamic>) {
      title = translation['title'] as String?;
    }

    return DownloadableLink(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      type: json['type'] as String?,
      price: ProductModel._parseDouble(json['price']),
      formattedPrice: json['formattedPrice'] as String?,
      downloads: json['downloads'] as int?,
      sortOrder: json['sortOrder'] as int?,
      fileUrl: json['fileUrl'] as String?,
      sampleFileUrl: json['sampleFileUrl'] as String?,
      title: title,
    );
  }

  String? get displayPriceLabel {
    if (price != null && price! > 0 && (formattedPrice?.isNotEmpty ?? false)) {
      return formattedPrice;
    }
    return null;
  }
}

class DownloadableSample {
  final String id;
  final int? numericId;
  final String? type;
  final String? fileUrl;
  final int? sortOrder;
  final String? title;

  const DownloadableSample({
    required this.id,
    this.numericId,
    this.type,
    this.fileUrl,
    this.sortOrder,
    this.title,
  });

  factory DownloadableSample.fromJson(Map<String, dynamic> json) {
    String? title;
    final translation = json['translation'];
    if (translation != null && translation is Map<String, dynamic>) {
      title = translation['title'] as String?;
    }

    return DownloadableSample(
      id: json['id']?.toString() ?? '',
      numericId: ProductModel._parseInt(json['_id']),
      type: json['type'] as String?,
      fileUrl: json['fileUrl'] as String?,
      sortOrder: json['sortOrder'] as int?,
      title: title,
    );
  }
}
