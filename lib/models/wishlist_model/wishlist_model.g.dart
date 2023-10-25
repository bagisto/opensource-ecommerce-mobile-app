// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishListData _$WishListDataFromJson(Map<String, dynamic> json) => WishListData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginatorInfo: json['paginatorInfo'] == null
          ? null
          : PaginatorInfo.fromJson(
              json['paginatorInfo'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$WishListDataToJson(WishListData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'paginatorInfo': instance.paginatorInfo,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      channelId: json['channelId'] as String?,
      productId: json['productId'] as String?,
      customerId: json['customerId'] as String?,
      itemOptions: json['itemOptions'] as String?,
      additional: json['additional'] as String?,
      movedToCart: json['movedToCart'] as String?,
      timeOfMoving: json['timeOfMoving'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'channelId': instance.channelId,
      'productId': instance.productId,
      'customerId': instance.customerId,
      'itemOptions': instance.itemOptions,
      'additional': instance.additional,
      'movedToCart': instance.movedToCart,
      'timeOfMoving': instance.timeOfMoving,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'customer': instance.customer,
      'product': instance.product,
      'cart': instance.cart,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      apiToken: json['apiToken'] as String?,
      customerGroupId: json['customerGroupId'] as int?,
      subscribedToNewsLetter: json['subscribedToNewsLetter'] as bool?,
      isVerified: json['isVerified'] as bool?,
      token: json['token'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'apiToken': instance.apiToken,
      'customerGroupId': instance.customerGroupId,
      'subscribedToNewsLetter': instance.subscribedToNewsLetter,
      'isVerified': instance.isVerified,
      'token': instance.token,
      'notes': instance.notes,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      priceHtml: json['priceHtml'] == null
          ? null
          : PriceHtml.fromJson(json['priceHtml'] as Map<String, dynamic>),
    )..shortDescription = json['shortDescription'] as String?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'images': instance.images,
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'type': instance.type,
      'attributeFamilyId': instance.attributeFamilyId,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'priceHtml': instance.priceHtml,
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

ProductFlats _$ProductFlatsFromJson(Map<String, dynamic> json) => ProductFlats(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      productNumber: json['productNumber'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
    );

Map<String, dynamic> _$ProductFlatsToJson(ProductFlats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'productNumber': instance.productNumber,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'locale': instance.locale,
      'channel': instance.channel,
    };

ShareWishlistData _$ShareWishlistDataFromJson(Map<String, dynamic> json) =>
    ShareWishlistData(
      isWishlistShared: json['isWishlistShared'] as bool?,
      wishlistSharedLink: json['wishlistSharedLink'] as String?,
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$ShareWishlistDataToJson(ShareWishlistData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'isWishlistShared': instance.isWishlistShared,
      'wishlistSharedLink': instance.wishlistSharedLink,
    };
