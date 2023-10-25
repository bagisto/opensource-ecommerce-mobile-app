// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompareScreenModel _$CompareScreenModelFromJson(Map<String, dynamic> json) =>
    CompareScreenModel(
      cartCount: json['cartCount'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CompareData.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['links'] == null
          ? null
          : Links.fromJson(json['links'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    )..addWislistData = (json['addWislistData'] as List<dynamic>?)
        ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$CompareScreenModelToJson(CompareScreenModel instance) =>
    <String, dynamic>{
      'cartCount': instance.cartCount,
      'data': instance.data,
      'links': instance.links,
      'addWislistData': instance.addWislistData,
      'meta': instance.meta,
    };

CompareData _$CompareDataFromJson(Map<String, dynamic> json) => CompareData(
      id: json['id'] as int?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CompareDataToJson(CompareData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'customer': instance.customer,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      price: json['price'],
      formatedPrice: json['formated_price'] as String?,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: json['reviews'] == null
          ? null
          : Reviews.fromJson(json['reviews'] as Map<String, dynamic>),
      inStock: json['inStock'] as bool?,
      isSaved: json['isSaved'] as bool?,
      isWishlisted: json['is_wishlisted'] as bool?,
      isItemInCart: json['isItemInCart'] as bool?,
      showQuantityChanger: json['showQuantityChanger'] as bool?,
      moreInformation: (json['moreInformation'] as List<dynamic>?)
          ?.map((e) => MoreInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'name': instance.name,
      'urlKey': instance.urlKey,
      'price': instance.price,
      'formated_price': instance.formatedPrice,
      'short_description': instance.shortDescription,
      'description': instance.description,
      'images': instance.images,
      'reviews': instance.reviews,
      'inStock': instance.inStock,
      'isSaved': instance.isSaved,
      'is_wishlisted': instance.isWishlisted,
      'isItemInCart': instance.isItemInCart,
      'showQuantityChanger': instance.showQuantityChanger,
      'moreInformation': instance.moreInformation,
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
      total: json['total'] as int?,
      totalRating: json['totalRating'] as String?,
      averageRating: json['averageRating'] as String?,
    );

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'total': instance.total,
      'totalRating': instance.totalRating,
      'averageRating': instance.averageRating,
    };

MoreInformation _$MoreInformationFromJson(Map<String, dynamic> json) =>
    MoreInformation(
      id: json['id'] as int?,
      code: json['code'] as String?,
      label: json['label'] as String?,
      adminName: json['adminName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MoreInformationToJson(MoreInformation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'label': instance.label,
      'adminName': instance.adminName,
      'type': instance.type,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as int?,
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'phone': instance.phone,
      'status': instance.status,
      'group': instance.group,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      first: json['first'] as String?,
      last: json['last'] as String?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      currentPage: json['currentPage'] as int?,
      from: json['from'] as int?,
      lastPage: json['lastPage'] as int?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => Links.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String?,
      perPage: json['perPage'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'currentPage': instance.currentPage,
      'from': instance.from,
      'lastPage': instance.lastPage,
      'links': instance.links,
      'path': instance.path,
      'perPage': instance.perPage,
      'to': instance.to,
      'total': instance.total,
    };
