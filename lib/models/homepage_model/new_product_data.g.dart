// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_product_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewProductsModelAdapter extends TypeAdapter<NewProductsModel> {
  @override
  final int typeId = 0;

  @override
  NewProductsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewProductsModel(
      data: (fields[0] as List?)?.cast<NewProducts>(),
    );
  }

  @override
  void write(BinaryWriter writer, NewProductsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewProductsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NewProductsAdapter extends TypeAdapter<NewProducts> {
  @override
  final int typeId = 1;

  @override
  NewProducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewProducts(
      type: fields[7] as String?,
      productId: fields[1] as String?,
      url: fields[8] as String?,
      id: fields[0] as String?,
      sku: fields[2] as String?,
      name: fields[3] as String?,
      description: fields[4] as String?,
      shortDescription: fields[5] as String?,
      isInWishlist: fields[10] as bool?,
      priceHtml: fields[12] as PriceHtml?,
      images: (fields[13] as List?)?.cast<Images>(),
      productFlats: (fields[15] as List?)?.cast<ProductFlats>(),
      price: fields[9] as String?,
      rating: fields[6] as String?,
      isNew: fields[11] as bool?,
    )..reviews = (fields[14] as List?)?.cast<Reviews>();
  }

  @override
  void write(BinaryWriter writer, NewProducts obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.shortDescription)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.url)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.isInWishlist)
      ..writeByte(11)
      ..write(obj.isNew)
      ..writeByte(12)
      ..write(obj.priceHtml)
      ..writeByte(13)
      ..write(obj.images)
      ..writeByte(14)
      ..write(obj.reviews)
      ..writeByte(15)
      ..write(obj.productFlats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewsAdapter extends TypeAdapter<Reviews> {
  @override
  final int typeId = 4;

  @override
  Reviews read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reviews(
      id: fields[0] as String?,
      title: fields[1] as String?,
      rating: fields[2] as int?,
      comment: fields[3] as String?,
      status: fields[4] as String?,
      productId: fields[5] as String?,
      customerId: fields[6] as String?,
      customerName: fields[7] as String?,
      createdAt: fields[8] as String?,
      updatedAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reviews obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.productId)
      ..writeByte(6)
      ..write(obj.customerId)
      ..writeByte(7)
      ..write(obj.customerName)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriceHtmlAdapter extends TypeAdapter<PriceHtml> {
  @override
  final int typeId = 2;

  @override
  PriceHtml read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceHtml(
      id: fields[0] as String?,
      type: fields[1] as String?,
      html: fields[2] as String?,
      regular: fields[3] as String?,
      special: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PriceHtml obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.html)
      ..writeByte(3)
      ..write(obj.regular)
      ..writeByte(4)
      ..write(obj.special);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceHtmlAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductFlatsAdapter extends TypeAdapter<ProductFlats> {
  @override
  final int typeId = 5;

  @override
  ProductFlats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductFlats(
      id: fields[0] as String?,
      sku: fields[1] as String?,
      name: fields[2] as String?,
      urlKey: fields[3] as String?,
      isNew: fields[4] as bool?,
      isWishListed: fields[5] as bool?,
      locale: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductFlats obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sku)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.urlKey)
      ..writeByte(4)
      ..write(obj.isNew)
      ..writeByte(5)
      ..write(obj.isWishListed)
      ..writeByte(6)
      ..write(obj.locale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFlatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImagesAdapter extends TypeAdapter<Images> {
  @override
  final int typeId = 3;

  @override
  Images read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Images(
      id: fields[0] as String?,
      type: fields[1] as String?,
      path: fields[2] as String?,
      url: fields[3] as String?,
      productId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Images obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewProductsModel _$NewProductsModelFromJson(Map<String, dynamic> json) =>
    NewProductsModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NewProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$NewProductsModelToJson(NewProductsModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

NewProducts _$NewProductsFromJson(Map<String, dynamic> json) => NewProducts(
      type: json['type'] as String?,
      productId: json['productId'] as String?,
      url: json['url'] as String?,
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      downloadableLinks: (json['downloadableLinks'] as List<dynamic>?)
          ?.map((e) => DownloadableLinks.fromJson(e as Map<String, dynamic>))
          .toList(),
      isInWishlist: json['isInWishlist'] as bool?,
      priceHtml: json['priceHtml'] == null
          ? null
          : PriceHtml.fromJson(json['priceHtml'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      productFlats: (json['productFlats'] as List<dynamic>?)
          ?.map((e) => ProductFlats.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as String?,
      rating: json['rating'] as String?,
      isNew: json['isNew'] as bool?,
    )
      ..reviews = (json['reviews'] as List<dynamic>?)
          ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
          .toList()
      ..downloadableSamples = (json['downloadableSamples'] as List<dynamic>?)
          ?.map((e) => DownloadableSamples.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$NewProductsToJson(NewProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'rating': instance.rating,
      'type': instance.type,
      'url': instance.url,
      'price': instance.price,
      'isInWishlist': instance.isInWishlist,
      'isNew': instance.isNew,
      'priceHtml': instance.priceHtml,
      'images': instance.images,
      'reviews': instance.reviews,
      'downloadableLinks': instance.downloadableLinks,
      'downloadableSamples': instance.downloadableSamples,
      'productFlats': instance.productFlats,
    };

DownloadableLinks _$DownloadableLinksFromJson(Map<String, dynamic> json) =>
    DownloadableLinks(
      id: json['id'] as String?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      url: json['url'] as String?,
      file: json['file'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      type: json['type'] as String?,
      sampleUrl: json['sampleUrl'] as String?,
      sampleFile: json['sampleFile'] as String?,
      sampleFileName: json['sampleFileName'] as String?,
      sampleType: json['sampleType'] as String?,
      sortOrder: json['sortOrder'] as int?,
      productId: json['productId'] as String?,
      downloads: json['downloads'] as int?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DownloadableLinksToJson(DownloadableLinks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'url': instance.url,
      'file': instance.file,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'type': instance.type,
      'sampleUrl': instance.sampleUrl,
      'sampleFile': instance.sampleFile,
      'sampleFileName': instance.sampleFileName,
      'sampleType': instance.sampleType,
      'sortOrder': instance.sortOrder,
      'productId': instance.productId,
      'downloads': instance.downloads,
      'translations': instance.translations,
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

DownloadableSamples _$DownloadableSamplesFromJson(Map<String, dynamic> json) =>
    DownloadableSamples(
      id: json['id'] as String?,
      url: json['url'] as String?,
      file: json['file'] as String?,
      fileName: json['fileName'] as String?,
      type: json['type'] as String?,
      fileUrl: json['fileUrl'] as String?,
    );

Map<String, dynamic> _$DownloadableSamplesToJson(
        DownloadableSamples instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'file': instance.file,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'type': instance.type,
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
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      isNew: json['new'] as bool?,
      isWishListed: json['isWishListed'] as bool?,
      locale: json['locale'] as String?,
    );

Map<String, dynamic> _$ProductFlatsToJson(ProductFlats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'urlKey': instance.urlKey,
      'new': instance.isNew,
      'isWishListed': instance.isWishListed,
      'locale': instance.locale,
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
