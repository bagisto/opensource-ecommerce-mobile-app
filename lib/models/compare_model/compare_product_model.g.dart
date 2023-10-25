// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompareProductsData _$CompareProductsDataFromJson(Map<String, dynamic> json) =>
    CompareProductsData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CompareProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompareProductsDataToJson(
        CompareProductsData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

CompareProducts _$CompareProductsFromJson(Map<String, dynamic> json) =>
    CompareProducts(
      id: json['id'] as String?,
      productFlatId: json['productFlatId'] as String?,
      customerId: json['customerId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      productFlat: json['productFlat'] == null
          ? null
          : ProductFlat.fromJson(json['productFlat'] as Map<String, dynamic>),
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompareProductsToJson(CompareProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productFlatId': instance.productFlatId,
      'customerId': instance.customerId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'productFlat': instance.productFlat,
      'cart': instance.cart,
    };

ProductFlat _$ProductFlatFromJson(Map<String, dynamic> json) => ProductFlat(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      urlKey: json['urlKey'] as String?,
      newProduct: json['new'] as bool?,
      featured: json['featured'] as bool?,
      status: json['status'] as bool?,
      visibleIndividually: json['visibleIndividually'] as bool?,
      thumbnail: json['thumbnail'] as String?,
      price: json['price'],
      cost: json['cost'],
      specialPrice: json['specialPrice'],
      specialPriceFrom: json['specialPriceFrom'],
      specialPriceTo: json['specialPriceTo'],
      weight: json['weight'],
      color: json['color'] as int?,
      colorLabel: json['colorLabel'] as String?,
      size: json['size'] as int?,
      sizeLabel: json['sizeLabel'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      productId: json['productId'] as String?,
      parentId: json['parentId'] as String?,
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      metaTitle: json['metaTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      metaDescription: json['metaDescription'] as String?,
      width: json['width'],
      height: json['height'],
      depth: json['depth'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ProductFlatToJson(ProductFlat instance) =>
    <String, dynamic>{
      'product': instance.product,
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'urlKey': instance.urlKey,
      'new': instance.newProduct,
      'featured': instance.featured,
      'status': instance.status,
      'visibleIndividually': instance.visibleIndividually,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'cost': instance.cost,
      'specialPrice': instance.specialPrice,
      'specialPriceFrom': instance.specialPriceFrom,
      'specialPriceTo': instance.specialPriceTo,
      'weight': instance.weight,
      'color': instance.color,
      'colorLabel': instance.colorLabel,
      'size': instance.size,
      'sizeLabel': instance.sizeLabel,
      'locale': instance.locale,
      'channel': instance.channel,
      'productId': instance.productId,
      'parentId': instance.parentId,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'metaTitle': instance.metaTitle,
      'metaKeywords': instance.metaKeywords,
      'metaDescription': instance.metaDescription,
      'width': instance.width,
      'height': instance.height,
      'depth': instance.depth,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
