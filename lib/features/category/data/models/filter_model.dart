// Filter attribute model for product filtering.
//
// Supports both the legacy single-attribute API (`attribute(id:)`)
// and the dynamic `categoryAttributeFilters` API which returns
// all filterable attributes for a category, including price range.

class FilterAttribute {
  final String id;
  final int? numericId; // _id from API
  final String code;
  final String adminName;
  final String? type; // e.g. "select", "price", "text", "boolean"
  final String? swatchType; // e.g. "dropdown", "color", "image", "text"
  final String? validation;
  final int? position;
  final bool isFilterable;
  final bool isConfigurable;
  final double? maxPrice;
  final double? minPrice;
  final String? translatedName; // from translations
  final List<FilterOption> options;

  const FilterAttribute({
    required this.id,
    this.numericId,
    required this.code,
    required this.adminName,
    this.type,
    this.swatchType,
    this.validation,
    this.position,
    this.isFilterable = false,
    this.isConfigurable = false,
    this.maxPrice,
    this.minPrice,
    this.translatedName,
    this.options = const [],
  });

  /// Whether this attribute represents a price range filter
  bool get isPriceFilter => code == 'price' || type == 'price';

  /// Display name: translated name → adminName → capitalized code
  String get displayName {
    if (translatedName != null && translatedName!.isNotEmpty) {
      return translatedName!;
    }
    if (adminName.isNotEmpty) return adminName;
    if (code.isEmpty) return code;
    return '${code[0].toUpperCase()}${code.substring(1)}';
  }

  /// Parse from the legacy `attribute(id:)` response
  factory FilterAttribute.fromJson(Map<String, dynamic> json) {
    final optionEdges =
        json['options']?['edges'] as List<dynamic>? ?? [];

    return FilterAttribute(
      id: json['id']?.toString() ?? '',
      code: json['code'] as String? ?? '',
      adminName: (json['code'] as String? ?? '').toUpperCase(),
      options: optionEdges.map((edge) {
        final node = edge['node'] as Map<String, dynamic>;
        return FilterOption.fromJson(node);
      }).toList(),
    );
  }

  /// Parse from the `categoryAttributeFilters` API response node
  factory FilterAttribute.fromCategoryFilterJson(Map<String, dynamic> json) {
    final optionEdges =
        json['options']?['edges'] as List<dynamic>? ?? [];

    // Extract translated name
    String? translatedName;
    final translationEdges =
        json['translations']?['edges'] as List<dynamic>?;
    if (translationEdges != null && translationEdges.isNotEmpty) {
      final firstTranslation =
          translationEdges.first['node'] as Map<String, dynamic>?;
      translatedName = firstTranslation?['name'] as String?;
    }

    return FilterAttribute(
      id: json['id']?.toString() ?? '',
      numericId: json['_id'] as int?,
      code: json['code'] as String? ?? '',
      adminName: json['adminName'] as String? ?? '',
      type: json['type'] as String?,
      swatchType: json['swatchType'] as String?,
      validation: json['validation'] as String?,
      position: json['position'] as int?,
      isFilterable: json['isFilterable'] == true,
      isConfigurable: json['isConfigurable'] == true,
      maxPrice: _parseDouble(json['maxPrice']),
      minPrice: _parseDouble(json['minPrice']),
      translatedName: translatedName,
      options: optionEdges.map((edge) {
        final node = edge['node'] as Map<String, dynamic>;
        return FilterOption.fromCategoryFilterJson(node);
      }).toList(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class FilterOption {
  final String id;
  final int? numericId; // _id from API
  final String adminName;
  final String? label;
  final int? sortOrder;
  final String? swatchValue;
  final String? swatchValueUrl;

  const FilterOption({
    required this.id,
    this.numericId,
    required this.adminName,
    this.label,
    this.sortOrder,
    this.swatchValue,
    this.swatchValueUrl,
  });

  /// Parse from the legacy `attribute(id:)` response
  factory FilterOption.fromJson(Map<String, dynamic> json) {
    String? label;
    final translations = json['translations']?['edges'] as List<dynamic>?;
    if (translations != null && translations.isNotEmpty) {
      final firstTranslation =
          translations.first['node'] as Map<String, dynamic>?;
      label = firstTranslation?['label'] as String?;
    }

    return FilterOption(
      id: json['id']?.toString() ?? '',
      adminName: json['adminName'] as String? ?? '',
      label: label,
    );
  }

  /// Parse from the `categoryAttributeFilters` option node
  factory FilterOption.fromCategoryFilterJson(Map<String, dynamic> json) {
    // Try direct translation first, then translations edges
    String? label;
    final directTranslation = json['translation'] as Map<String, dynamic>?;
    if (directTranslation != null) {
      label = directTranslation['label'] as String?;
    }
    if (label == null || label.isEmpty) {
      final translationEdges =
          json['translations']?['edges'] as List<dynamic>?;
      if (translationEdges != null && translationEdges.isNotEmpty) {
        final firstTranslation =
            translationEdges.first['node'] as Map<String, dynamic>?;
        label = firstTranslation?['label'] as String?;
      }
    }

    return FilterOption(
      id: json['id']?.toString() ?? '',
      numericId: json['_id'] as int?,
      adminName: json['adminName'] as String? ?? '',
      label: label,
      sortOrder: json['sortOrder'] as int?,
      swatchValue: json['swatchValue'] as String?,
      swatchValueUrl: json['swatchValueUrl'] as String?,
    );
  }

  /// Extract numeric ID from IRI like "/api/admin/attribute-options/6"
  String? get numericIdFromIri {
    final match = RegExp(r'/(\d+)$').firstMatch(id);
    return match?.group(1);
  }

  /// Resolved numeric ID: use _id field if available, else extract from IRI
  String get resolvedId {
    if (numericId != null) return numericId.toString();
    return numericIdFromIri ?? id;
  }

  /// Display name: use label (translated) if available, else adminName
  String get displayName =>
      (label != null && label!.isNotEmpty) ? label! : adminName;

  /// Whether this option has a color swatch
  bool get hasColorSwatch =>
      swatchValue != null && swatchValue!.isNotEmpty;

  /// Whether this option has an image swatch
  bool get hasImageSwatch =>
      swatchValueUrl != null && swatchValueUrl!.isNotEmpty;
}

/// Sort option model
/// Maps to: SortByFields from nextjs-commerce/src/utils/constants.ts
class SortOption {
  final String key;
  final String title;
  final String sortKey;
  final bool reverse;

  const SortOption({
    required this.key,
    required this.title,
    required this.sortKey,
    required this.reverse,
  });
}

/// Predefined sort options matching Bagisto API docs
/// Sort key options: PRICE, TITLE, NEWEST, BEST_SELLING
const List<SortOption> sortByFields = [
  SortOption(
    key: 'name-asc',
    title: 'From A-Z',
    sortKey: 'TITLE',
    reverse: false,
  ),
  SortOption(
    key: 'name-desc',
    title: 'From Z-A',
    sortKey: 'TITLE',
    reverse: true,
  ),
  SortOption(
    key: 'newest',
    title: 'Newest First',
    sortKey: 'NEWEST',
    reverse: true,
  ),
  SortOption(
    key: 'oldest',
    title: 'Oldest First',
    sortKey: 'NEWEST',
    reverse: false,
  ),
  SortOption(
    key: 'price-asc',
    title: 'Cheapest First',
    sortKey: 'PRICE',
    reverse: false,
  ),
  SortOption(
    key: 'price-desc',
    title: 'Expensive First',
    sortKey: 'PRICE',
    reverse: true,
  ),
];
