// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddWishListModel _$AddWishListModelFromJson(Map<String, dynamic> json) =>
    AddWishListModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    )
      ..success = json['success'] as String?
      ..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$AddWishListModelToJson(AddWishListModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
      'data': instance.data,
      'message': instance.message,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      priceHtml: json['priceHtml'] == null
          ? null
          : PriceHtml.fromJson(json['priceHtml'] as Map<String, dynamic>),
      price: json['price'],
      formatedPrice: json['formatedPrice'] as String?,
      shortDescription: json['shortDescription'] as String?,
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseImage: json['baseImage'] == null
          ? null
          : BaseImage.fromJson(json['baseImage'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      inStock: json['inStock'] as bool?,
      isSaved: json['isSaved'] as bool?,
      isInWishlist: json['isInWishlist'] as bool?,
      isItemInCart: json['isItemInCart'] as bool?,
      showQuantityChanger: json['showQuantityChanger'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'name': instance.name,
      'urlKey': instance.urlKey,
      'priceHtml': instance.priceHtml,
      'price': instance.price,
      'formatedPrice': instance.formatedPrice,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'images': instance.images,
      'baseImage': instance.baseImage,
      'reviews': instance.reviews,
      'inStock': instance.inStock,
      'isSaved': instance.isSaved,
      'isInWishlist': instance.isInWishlist,
      'isItemInCart': instance.isItemInCart,
      'showQuantityChanger': instance.showQuantityChanger,
    };

PriceHtml _$PriceHtmlFromJson(Map<String, dynamic> json) => PriceHtml(
      regular: json['regular'] as String?,
    );

Map<String, dynamic> _$PriceHtmlToJson(PriceHtml instance) => <String, dynamic>{
      'regular': instance.regular,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: json['id'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
      originalImageUrl: json['originalImageUrl'] as String?,
      smallImageUrl: json['smallImageUrl'] as String?,
      mediumImageUrl: json['mediumImageUrl'] as String?,
      largeImageUrl: json['largeImageUrl'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'url': instance.url,
      'originalImageUrl': instance.originalImageUrl,
      'smallImageUrl': instance.smallImageUrl,
      'mediumImageUrl': instance.mediumImageUrl,
      'largeImageUrl': instance.largeImageUrl,
    };

BaseImage _$BaseImageFromJson(Map<String, dynamic> json) => BaseImage(
      smallImageUrl: json['smallImageUrl'] as String?,
      mediumImageUrl: json['mediumImageUrl'] as String?,
      largeImageUrl: json['largeImageUrl'] as String?,
      originalImageUrl: json['originalImageUrl'] as String?,
    );

Map<String, dynamic> _$BaseImageToJson(BaseImage instance) => <String, dynamic>{
      'smallImageUrl': instance.smallImageUrl,
      'mediumImageUrl': instance.mediumImageUrl,
      'largeImageUrl': instance.largeImageUrl,
      'originalImageUrl': instance.originalImageUrl,
    };

Reviews _$ReviewsFromJson(Map<String, dynamic> json) => Reviews(
      id: json['id'] as String?,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      productId: json['productId'] as String?,
      rating: json['rating'] as int?,
    );

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'comment': instance.comment,
      'status': instance.status,
      'productId': instance.productId,
      'rating': instance.rating,
    };
