import 'dart:developer' as developer;

/// Product model matching Bagisto GraphQL schema
/// Derived from: nextjs-commerce/src/graphql/catelog/fragments/Product.ts
///               nextjs-commerce/src/types/category/type.ts
class ProductModel {
  final String id;
  final int? numericId; // _id field from API
  final String? sku;
  final String? type;
  final String? name;
  final String? urlKey;
  final String? description;
  final String? shortDescription;
  final double? price;
  final String? baseImageUrl;
  final double? minimumPrice;
  final double? specialPrice;
  final bool? isSaleable;
  final String? color;
  final String? size;
  final String? brand;
  final List<ProductImage> images;
  final List<SuperAttribute> superAttributes;
  final List<ProductVariant> variants;
  final List<ProductReview> reviews;
  final List<ProductModel> relatedProducts;

  const ProductModel({
    required this.id,
    this.numericId,
    this.sku,
    this.type,
    this.name,
    this.urlKey,
    this.description,
    this.shortDescription,
    this.price,
    this.baseImageUrl,
    this.minimumPrice,
    this.specialPrice,
    this.isSaleable,
    this.color,
    this.size,
    this.brand,
    this.images = const [],
    this.superAttributes = const [],
    this.variants = const [],
    this.reviews = const [],
    this.relatedProducts = const [],
  });

  /// Calculate discount percentage
  int? get discountPercent {
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

  /// Get original price (for strikethrough) — only if there's a real discount
  double? get originalPrice {
    if (specialPrice != null &&
        specialPrice! > 0 &&
        price != null &&
        specialPrice! < price!) {
      return price;
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

  /// Build configurable attributes from variants
  /// Since superAttributes.options returns null from the API,
  /// we derive the available options from variant data
  List<ConfigurableAttribute> get configurableAttributes {
    if (!isConfigurable || variants.isEmpty) return [];

    final attrs = <ConfigurableAttribute>[];

    // Check which super attribute codes are declared
    final declaredCodes =
        superAttributes.map((a) => a.code).whereType<String>().toList();

    // For each declared super attribute, extract unique values from variants
    for (final code in declaredCodes) {
      final values = <String>{};
      for (final variant in variants) {
        final value = variant.getAttributeValue(code);
        if (value != null && value.isNotEmpty) {
          values.add(value);
        }
      }

      if (values.isEmpty) continue;

      // Find the admin name from superAttributes
      final superAttr = superAttributes.firstWhere(
        (a) => a.code == code,
      );

      final label = code == 'size'
          ? 'Select Size'
          : (superAttr.adminName ?? code);

      final options = values.map((v) {
        return ConfigurableOption(
          value: v,
          swatchColor: code == 'color' ? _colorNameToHex(v) : null,
        );
      }).toList();

      attrs.add(ConfigurableAttribute(
        code: code,
        label: label,
        options: options,
      ));
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

  /// Get available option values for an attribute given the current selections
  /// This enables cascading: e.g. selecting "Yellow" color shows only sizes that
  /// have a Yellow variant
  Set<String> getAvailableValues(
      String attributeCode, Map<String, String> otherSelections) {
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
    // Debug: log raw price fields from API
    developer.log(
      'ProductModel[${json['name']}] price=${json['price']} '
      'specialPrice=${json['specialPrice']} (${json['specialPrice']?.runtimeType}) '
      'minimumPrice=${json['minimumPrice']}',
      name: 'ProductModel',
    );

    return ProductModel(
      id: json['id']?.toString() ?? '',
      numericId: json['_id'] as int?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      price: _parseDouble(json['price']),
      baseImageUrl: json['baseImageUrl'] as String?,
      minimumPrice: _parseDouble(json['minimumPrice']),
      specialPrice: _parseSpecialPrice(json['specialPrice']),
      isSaleable: _parseBool(json['isSaleable']),
      color: json['color'] as String?,
      size: json['size'] as String?,
      brand: json['brand'] as String?,
      images: _parseImages(json['images']),
      superAttributes: _parseSuperAttributes(json['superAttributes']),
      variants: _parseVariants(json['variants']),
      reviews: _parseReviews(json['reviews']),
      relatedProducts: _parseRelatedProducts(json['relatedProducts']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
        .map((e) =>
            SuperAttribute.fromJson(e['node'] as Map<String, dynamic>))
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
}

class ProductVariant {
  final String id;
  final int? numericId;
  final String? sku;
  final String? name;
  final double? price;
  final double? specialPrice;
  final String? baseImageUrl;
  final String? isSaleable;
  final String? color;
  final String? size;

  const ProductVariant({
    required this.id,
    this.numericId,
    this.sku,
    this.name,
    this.price,
    this.specialPrice,
    this.baseImageUrl,
    this.isSaleable,
    this.color,
    this.size,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      numericId: json['_id'] as int?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      price: ProductModel._parseDouble(json['price']),
      specialPrice: ProductModel._parseSpecialPrice(json['specialPrice']),
      baseImageUrl: json['baseImageUrl'] as String?,
      isSaleable: json['isSaleable'] as String?,
      color: json['color'] as String?,
      size: json['size'] as String?,
    );
  }

  /// Get attribute value by code (e.g. 'color' -> 'Yellow')
  String? getAttributeValue(String code) {
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
}

class ProductReview {
  final String id;
  final double rating;
  final String? name;
  final String? title;
  final String? comment;
  final String? createdAt;

  const ProductReview({
    required this.id,
    required this.rating,
    this.name,
    this.title,
    this.comment,
    this.createdAt,
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
      numericId: json['_id'] as int?,
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
  final String? code;
  final String? adminName;
  final List<AttributeOption> options;

  const SuperAttribute({
    required this.id,
    this.code,
    this.adminName,
    this.options = const [],
  });

  factory SuperAttribute.fromJson(Map<String, dynamic> json) {
    return SuperAttribute(
      id: json['id']?.toString() ?? '',
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
        .map((e) =>
            AttributeOption.fromJson(e['node'] as Map<String, dynamic>))
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
      numericId: json['_id'] as int?,
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

/// Configurable attribute derived from variants
/// Since superAttributes.options returns null, we build options from variant data
class ConfigurableAttribute {
  final String code; // e.g. "color", "size"
  final String label; // e.g. "Color", "Select Size"
  final List<ConfigurableOption> options;

  const ConfigurableAttribute({
    required this.code,
    required this.label,
    this.options = const [],
  });
}

/// An option for a configurable attribute, derived from variants
class ConfigurableOption {
  final String value; // e.g. "Yellow", "S"
  final String? swatchColor; // hex color for color swatches
  final bool isAvailable;

  const ConfigurableOption({
    required this.value,
    this.swatchColor,
    this.isAvailable = true,
  });
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
