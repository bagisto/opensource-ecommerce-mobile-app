// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddReviewModel _$AddReviewModelFromJson(Map<String, dynamic> json) =>
    AddReviewModel(
      success: json['success'] as String?,
      review: json['review'] == null
          ? null
          : Review.fromJson(json['review'] as Map<String, dynamic>),
    )..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$AddReviewModelToJson(AddReviewModel instance) =>
    <String, dynamic>{
      'responseStatus': instance.responseStatus,
      'success': instance.success,
      'review': instance.review,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as String?,
      title: json['title'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      productId: json['productId'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'rating': instance.rating,
      'comment': instance.comment,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'productId': instance.productId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      productFlats: (json['productFlats'] as List<dynamic>?)
          ?.map((e) => ProductFlats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributeFamilyId': instance.attributeFamilyId,
      'sku': instance.sku,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'productFlats': instance.productFlats,
    };

ProductFlats _$ProductFlatsFromJson(Map<String, dynamic> json) => ProductFlats(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      urlKey: json['urlKey'] as String?,
      featured: json['featured'] as bool?,
      status: json['status'] as bool?,
      visibleIndividually: json['visibleIndividually'] as bool?,
      price: json['price'],
      color: json['color'] as int?,
      colorLabel: json['colorLabel'] as String?,
      size: json['size'] as int?,
      sizeLabel: json['sizeLabel'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      productId: json['productId'] as String?,
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      metaTitle: json['metaTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      metaDescription: json['metaDescription'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ProductFlatsToJson(ProductFlats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'urlKey': instance.urlKey,
      'featured': instance.featured,
      'status': instance.status,
      'visibleIndividually': instance.visibleIndividually,
      'price': instance.price,
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
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
