/// Category model matching Bagisto GraphQL schema
/// Derived from: nextjs-commerce/src/graphql/catelog/queries/Category.ts
///               nextjs-commerce/src/graphql/catelog/queries/HomeCategories.ts
class CategoryModel {
  final String id;
  final int? numericId; // _id field from API
  final int? position;
  final String? logoPath;
  final String? logoUrl;
  final String? bannerUrl;
  final String? status;
  final CategoryTranslation? translation;
  final List<CategoryModel> children;

  const CategoryModel({
    required this.id,
    this.numericId,
    this.position,
    this.logoPath,
    this.logoUrl,
    this.bannerUrl,
    this.status,
    this.translation,
    this.children = const [],
  });

  String get name => translation?.name ?? '';
  String get slug => translation?.slug ?? '';
  String get urlPath => translation?.urlPath ?? '';
  String? get imageUrl => logoUrl ?? logoPath;

  /// Category description from the admin (HTML) as plain text; empty when
  /// there is none.
  String get plainDescription => (translation?.description ?? '')
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
  bool get isActive => isActiveStatus(status);

  /// Category status from the API: "1"/1/true = active, "0"/0/false =
  /// inactive. A missing status is treated as active.
  static bool isActiveStatus(dynamic status) {
    if (status == null) return true;
    if (status is bool) return status;
    final value = status.toString().trim().toLowerCase();
    return value == '1' || value == 'true';
  }

  /// Factory for treeCategories response
  factory CategoryModel.fromTreeJson(Map<String, dynamic> json) {
    // Parse children from cursor connection format: { edges: [{ node: {...} }] }
    List<CategoryModel> childrenList = [];
    final childrenData = json['children'];
    if (childrenData != null && childrenData is Map<String, dynamic>) {
      final edges = childrenData['edges'] as List<dynamic>?;
      if (edges != null) {
        childrenList = edges
            .where((e) => e['node'] != null)
            .map((e) =>
                CategoryModel.fromTreeJson(e['node'] as Map<String, dynamic>))
            .where((child) => child.isActive)
            .toList();
      }
    }

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      position: _parseInt(json['position']),
      logoPath: json['logoPath'] as String?,
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      status: json['status']?.toString(),
      translation: json['translation'] != null
          ? CategoryTranslation.fromJson(
              json['translation'] as Map<String, dynamic>)
          : null,
      children: childrenList,
    );
  }

  /// Factory for categories (home) cursor connection response
  factory CategoryModel.fromHomeCategoryJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      logoUrl: json['logoUrl'] as String?,
      position: _parseInt(json['position']),
      status: json['status']?.toString(),
      translation: json['translation'] != null
          ? CategoryTranslation.fromJson(
              json['translation'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CategoryTranslation {
  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? urlPath;
  final String? metaTitle;

  const CategoryTranslation({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.urlPath,
    this.metaTitle,
  });

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) {
    return CategoryTranslation(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      urlPath: json['urlPath'] as String?,
      metaTitle: json['metaTitle'] as String?,
    );
  }
}


int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
