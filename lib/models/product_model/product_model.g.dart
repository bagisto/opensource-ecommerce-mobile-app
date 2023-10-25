// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      cartCount: json['cartCount'] as int?,
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'cartCount': instance.cartCount,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
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
      inStock: json['in_stock'] as bool?,
      isSaved: json['isSaved'] as bool?,
      isWishlisted: json['is_wishlisted'] as bool?,
      isItemInCart: json['isItemInCart'] as bool?,
      showQuantityChanger: json['showQuantityChanger'] as bool?,
      cartCount: json['cartCount'] as int?,
      groupedProducts: (json['grouped_products'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadableLinks: (json['downloadable_links'] as List<dynamic>?)
          ?.map((e) => DownloadableProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadableSamples: (json['downloadable_samples'] as List<dynamic>?)
          ?.map((e) => DownloadableProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      customOptions: (json['super_attributes'] as List<dynamic>?)
          ?.map((e) => CustomOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => Variants.fromJson(e as Map<String, dynamic>))
          .toList(),
      bundleOption: json['bundle_options'] == null
          ? null
          : Bundles.fromJson(json['bundle_options'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
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
      'in_stock': instance.inStock,
      'isSaved': instance.isSaved,
      'is_wishlisted': instance.isWishlisted,
      'isItemInCart': instance.isItemInCart,
      'showQuantityChanger': instance.showQuantityChanger,
      'cartCount': instance.cartCount,
      'grouped_products': instance.groupedProducts,
      'downloadable_links': instance.downloadableLinks,
      'downloadable_samples': instance.downloadableSamples,
      'variants': instance.variants,
      'super_attributes': instance.customOptions,
      'bundle_options': instance.bundleOption,
    };

Bundles _$BundlesFromJson(Map<String, dynamic> json) => Bundles(
      bundleOptions: (json['options'] as List<dynamic>?)
          ?.map((e) => BundleOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundlesToJson(Bundles instance) => <String, dynamic>{
      'options': instance.bundleOptions,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: json['id'] as int?,
      path: json['path'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'url': instance.url,
    };

Reviews _$ReviewsFromJson(Map<String, dynamic> json) => Reviews(
      total: json['total'] as int?,
      totalRating: json['total_rating'],
      averageRating: json['average_rating'],
      percentage: json['percentage'],
    );

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'total': instance.total,
      'total_rating': instance.totalRating,
      'average_rating': instance.averageRating,
      'percentage': instance.percentage,
    };

DownloadableProduct _$DownloadableProductFromJson(Map<String, dynamic> json) =>
    DownloadableProduct(
      id: json['id'] as int?,
      url: json['url'] as String?,
      file: json['file'] as String?,
      fileName: json['file_name'] as String?,
      downloads: json['downloads'] as int?,
      price: json['price'] as String?,
      productId: json['product_id'] as int?,
      fileUrl: json['file_url'] as String?,
      title: json['title'] as String?,
      sampleFileUrl: json['sample_file_url'] as String?,
      sampleDownloadUrl: json['sample_download_url'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
    );

Map<String, dynamic> _$DownloadableProductToJson(
        DownloadableProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'file': instance.file,
      'file_name': instance.fileName,
      'downloads': instance.downloads,
      'price': instance.price,
      'product_id': instance.productId,
      'file_url': instance.fileUrl,
      'title': instance.title,
      'sample_file_url': instance.sampleFileUrl,
      'sample_download_url': instance.sampleDownloadUrl,
      'downloadUrl': instance.downloadUrl,
    };

Variants _$VariantsFromJson(Map<String, dynamic> json) => Variants(
      id: json['id'] as int?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      parentId: json['parentId'] as int?,
      attributeFamilyId: json['attributeFamilyId'],
      additional: json['additional'] as String?,
      price: json['price'] as String?,
      shortDescription: json['shortDescription'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      urlKey: json['urlKey'] as String?,
      new1: json['new1'] as String?,
      featured: json['featured'],
      visibleIndividually: json['visibleIndividually'] as String?,
      status: json['status'] as int?,
      map: json['map'] as Map<String, dynamic>?,
      guestCheckout: json['guestCheckout'] as String?,
      productNumber: json['productNumber'] as String?,
      messageOnTshirt: json['messageOnTshirt'] as int?,
      metaTitle: json['metaTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      metaDescription: json['metaDescription'] as String?,
      specialPrice: json['specialPrice'] as String?,
      specialPriceFrom: json['specialPriceFrom'] as String?,
      specialPriceTo: json['specialPriceTo'] as String?,
      length: json['length'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      weight: json['weight'] as String?,
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => Inventories.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerGroupPrices: (json['customerGroupPrices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attributeFamily: json['attributeFamily'] == null
          ? null
          : AttributeFamily.fromJson(
              json['attributeFamily'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VariantsToJson(Variants instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'parentId': instance.parentId,
      'attributeFamilyId': instance.attributeFamilyId,
      'additional': instance.additional,
      'price': instance.price,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'name': instance.name,
      'urlKey': instance.urlKey,
      'new1': instance.new1,
      'featured': instance.featured,
      'visibleIndividually': instance.visibleIndividually,
      'status': instance.status,
      'guestCheckout': instance.guestCheckout,
      'productNumber': instance.productNumber,
      'messageOnTshirt': instance.messageOnTshirt,
      'metaTitle': instance.metaTitle,
      'metaKeywords': instance.metaKeywords,
      'metaDescription': instance.metaDescription,
      'specialPrice': instance.specialPrice,
      'specialPriceFrom': instance.specialPriceFrom,
      'specialPriceTo': instance.specialPriceTo,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'weight': instance.weight,
      'inventories': instance.inventories,
      'customerGroupPrices': instance.customerGroupPrices,
      'attributeFamily': instance.attributeFamily,
      'map': instance.map,
    };

Inventories _$InventoriesFromJson(Map<String, dynamic> json) => Inventories(
      id: json['id'] as int?,
      qty: json['qty'] as int?,
      productId: json['productId'] as int?,
      inventorySourceId: json['inventorySourceId'] as int?,
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

AttributeFamily _$AttributeFamilyFromJson(Map<String, dynamic> json) =>
    AttributeFamily(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      status: json['status'] as int?,
      isUserDefined: json['isUserDefined'] as int?,
    );

Map<String, dynamic> _$AttributeFamilyToJson(AttributeFamily instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'status': instance.status,
      'isUserDefined': instance.isUserDefined,
    };

CustomOptions _$CustomOptionsFromJson(Map<String, dynamic> json) =>
    CustomOptions(
      id: json['id'] as int?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      swatchType: json['swatchType'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CustomOptionsToJson(CustomOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'name': instance.name,
      'swatchType': instance.swatchType,
      'options': instance.options,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: json['id'] as int?,
      adminName: json['adminName'] as String?,
      label: json['label'] as String?,
      swatchValue: json['swatchValue'] as String?,
    )..isSelect = json['isSelect'] as bool;

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'adminName': instance.adminName,
      'label': instance.label,
      'swatchValue': instance.swatchValue,
      'isSelect': instance.isSelect,
    };

BundleOptions _$BundleOptionsFromJson(Map<String, dynamic> json) =>
    BundleOptions(
      id: json['id'] as int?,
      label: json['label'] as String?,
      type: json['type'] as String?,
      isRequired: json['isRequired'] as int?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sortOrder'] as int?,
    );

Map<String, dynamic> _$BundleOptionsToJson(BundleOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'isRequired': instance.isRequired,
      'products': instance.products,
      'sortOrder': instance.sortOrder,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      id: json['id'] as int?,
      qty: json['qty'] as int?,
      price: json['price'] == null
          ? null
          : Price.fromJson(json['price'] as Map<String, dynamic>),
      name: json['name'] as String?,
      productId: json['productId'] as int?,
      isDefault: json['isDefault'] as int?,
      sortOrder: json['sortOrder'] as int?,
      inStock: json['inStock'] as bool?,
      inventory: json['inventory'] as int?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'price': instance.price,
      'name': instance.name,
      'productId': instance.productId,
      'isDefault': instance.isDefault,
      'sortOrder': instance.sortOrder,
      'inStock': instance.inStock,
      'inventory': instance.inventory,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      regularPrice: json['regularPrice'] == null
          ? null
          : RegularPrice.fromJson(json['regularPrice'] as Map<String, dynamic>),
      finalPrice: json['finalPrice'] == null
          ? null
          : RegularPrice.fromJson(json['finalPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'regularPrice': instance.regularPrice,
      'finalPrice': instance.finalPrice,
    };

RegularPrice _$RegularPriceFromJson(Map<String, dynamic> json) => RegularPrice(
      price: json['price'] as String?,
      formatedPrice: json['formatedPrice'] as String?,
    );

Map<String, dynamic> _$RegularPriceToJson(RegularPrice instance) =>
    <String, dynamic>{
      'price': instance.price,
      'formatedPrice': instance.formatedPrice,
    };
