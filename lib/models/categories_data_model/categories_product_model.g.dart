// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesProductModel _$CategoriesProductModelFromJson(
        Map<String, dynamic> json) =>
    CategoriesProductModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error']
      ..paginatorInfo = json['paginatorInfo'] == null
          ? null
          : PaginatorInfo.fromJson(
              json['paginatorInfo'] as Map<String, dynamic>);

Map<String, dynamic> _$CategoriesProductModelToJson(
        CategoriesProductModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'paginatorInfo': instance.paginatorInfo,
      'data': instance.data,
    };

PaginatorInfo _$PaginatorInfoFromJson(Map<String, dynamic> json) =>
    PaginatorInfo(
      count: json['count'] as int?,
      currentPage: json['currentPage'] as int?,
      lastPage: json['lastPage'] as int?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$PaginatorInfoToJson(PaginatorInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'total': instance.total,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      type: json['type'] as String?,
      isInWishlist: json['isInWishlist'] as bool?,
      attributeFamilyId: json['attributeFamilyId'],
      priceHtml: json['priceHtml'] == null
          ? null
          : PriceHtml.fromJson(json['priceHtml'] as Map<String, dynamic>),
      sku: json['sku'] as String?,
      productFlats: (json['productFlats'] as List<dynamic>?)
          ?.map((e) => ProductFlats.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => Inventories.fromJson(e as Map<String, dynamic>))
          .toList(),
      cacheBaseImage: json['cacheBaseImage'] == null
          ? null
          : CacheBaseImage.fromJson(
              json['cacheBaseImage'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'isInWishlist': instance.isInWishlist,
      'attributeFamilyId': instance.attributeFamilyId,
      'priceHtml': instance.priceHtml,
      'sku': instance.sku,
      'productFlats': instance.productFlats,
      'categories': instance.categories,
      'inventories': instance.inventories,
      'cacheBaseImage': instance.cacheBaseImage,
      'images': instance.images,
      'reviews': instance.reviews,
      'cart': instance.cart,
    };

PriceHtml _$PriceHtmlFromJson(Map<String, dynamic> json) => PriceHtml(
      id: json['id'] as String?,
      type: json['type'] as String?,
      html: json['html'] as String?,
      regular: json['regular'] as String?,
      special: json['special'] as String?,
    );

Map<String, dynamic> _$PriceHtmlToJson(PriceHtml instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'html': instance.html,
      'regular': instance.regular,
      'special': instance.special,
    };

ProductFlats _$ProductFlatsFromJson(Map<String, dynamic> json) => ProductFlats(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      productNumber: json['productNumber'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      urlKey: json['urlKey'] as String?,
      isNew: json['new'] as bool?,
      featured: json['featured'] as bool?,
      status: json['status'] as bool?,
      visibleIndividually: json['visibleIndividually'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      color: json['color'] as int?,
      colorLabel: json['colorLabel'] as String?,
      size: json['size'] as int?,
      sizeLabel: json['sizeLabel'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      productId: json['productId'] as String?,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      metaTitle: json['metaTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      metaDescription: json['metaDescription'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => Variants.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ProductFlatsToJson(ProductFlats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'productNumber': instance.productNumber,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'urlKey': instance.urlKey,
      'new': instance.isNew,
      'featured': instance.featured,
      'status': instance.status,
      'visibleIndividually': instance.visibleIndividually,
      'price': instance.price,
      'weight': instance.weight,
      'color': instance.color,
      'colorLabel': instance.colorLabel,
      'size': instance.size,
      'sizeLabel': instance.sizeLabel,
      'locale': instance.locale,
      'channel': instance.channel,
      'productId': instance.productId,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'metaTitle': instance.metaTitle,
      'metaKeywords': instance.metaKeywords,
      'metaDescription': instance.metaDescription,
      'width': instance.width,
      'height': instance.height,
      'variants': instance.variants,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Variants _$VariantsFromJson(Map<String, dynamic> json) => Variants(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      urlKey: json['urlKey'] as String?,
      status: json['status'] as bool?,
      price: json['price'] as int?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      productId: json['productId'] as String?,
      parentId: json['parentId'],
    );

Map<String, dynamic> _$VariantsToJson(Variants instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'urlKey': instance.urlKey,
      'status': instance.status,
      'price': instance.price,
      'locale': instance.locale,
      'channel': instance.channel,
      'productId': instance.productId,
      'parentId': instance.parentId,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      urlPath: json['urlPath'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metaTitle: json['metaTitle'] as String?,
      metaDescription: json['metaDescription'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      position: json['position'] as int?,
      status: json['status'] as bool?,
      displayMode: json['displayMode'] as String?,
      parentId: json['parentId'] as String?,
      filterableAttributes: (json['filterableAttributes'] as List<dynamic>?)
          ?.map((e) => FilterableAttributes.fromJson(e as Map<String, dynamic>))
          .toList(),
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'slug': instance.slug,
      'urlPath': instance.urlPath,
      'imageUrl': instance.imageUrl,
      'metaTitle': instance.metaTitle,
      'metaDescription': instance.metaDescription,
      'metaKeywords': instance.metaKeywords,
      'position': instance.position,
      'status': instance.status,
      'displayMode': instance.displayMode,
      'parentId': instance.parentId,
      'filterableAttributes': instance.filterableAttributes,
      'translations': instance.translations,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

FilterableAttributes _$FilterableAttributesFromJson(
        Map<String, dynamic> json) =>
    FilterableAttributes(
      id: json['id'] as String?,
      adminName: json['adminName'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      position: json['position'] as int?,
    );

Map<String, dynamic> _$FilterableAttributesToJson(
        FilterableAttributes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminName': instance.adminName,
      'code': instance.code,
      'type': instance.type,
      'position': instance.position,
    };

Translations _$TranslationsFromJson(Map<String, dynamic> json) => Translations(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      localeId: json['localeId'] as String?,
      locale: json['locale'] as String?,
    );

Map<String, dynamic> _$TranslationsToJson(Translations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'localeId': instance.localeId,
      'locale': instance.locale,
    };

Inventories _$InventoriesFromJson(Map<String, dynamic> json) => Inventories(
      id: json['id'] as String?,
      qty: json['qty'] as int?,
      productId: json['productId'] as String?,
      inventorySourceId: json['inventorySourceId'] as String?,
      vendorId: json['vendorId'] as int?,
    );

Map<String, dynamic> _$InventoriesToJson(Inventories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'productId': instance.productId,
      'inventorySourceId': instance.inventorySourceId,
      'vendorId': instance.vendorId,
    };

CacheBaseImage _$CacheBaseImageFromJson(Map<String, dynamic> json) =>
    CacheBaseImage(
      smallImageUrl: json['smallImageUrl'] as String?,
      mediumImageUrl: json['mediumImageUrl'] as String?,
      largeImageUrl: json['largeImageUrl'] as String?,
      originalImageUrl: json['originalImageUrl'] as String?,
    );

Map<String, dynamic> _$CacheBaseImageToJson(CacheBaseImage instance) =>
    <String, dynamic>{
      'smallImageUrl': instance.smallImageUrl,
      'mediumImageUrl': instance.mediumImageUrl,
      'largeImageUrl': instance.largeImageUrl,
      'originalImageUrl': instance.originalImageUrl,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: json['id'] as String?,
      type: json['type'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'path': instance.path,
      'url': instance.url,
      'productId': instance.productId,
    };

Reviews _$ReviewsFromJson(Map<String, dynamic> json) => Reviews(
      id: json['id'] as String?,
      title: json['title'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      productId: json['productId'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'rating': instance.rating,
      'comment': instance.comment,
      'status': instance.status,
      'productId': instance.productId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
