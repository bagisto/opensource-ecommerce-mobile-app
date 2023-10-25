// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductScreenModel _$ProductScreenModelFromJson(Map<String, dynamic> json) =>
    ProductScreenModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$ProductScreenModelToJson(ProductScreenModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      additionalData: (json['additionalData'] as List<dynamic>?)
          ?.map((e) => AdditionalData.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      priceHtml: json['priceHtml'] == null
          ? null
          : PriceHtml.fromJson(json['priceHtml'] as Map<String, dynamic>),
      type: json['type'] as String?,
      isInWishlist: json['isInWishlist'] as bool?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
      productFlats: (json['productFlats'] as List<dynamic>?)
          ?.map((e) => ProductFlats.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => Variants.fromJson(e as Map<String, dynamic>))
          .toList(),
      attributeFamily: json['attributeFamily'] == null
          ? null
          : AttributeFamily.fromJson(
              json['attributeFamily'] as Map<String, dynamic>),
      attributeValues: (json['attributeValues'] as List<dynamic>?)
          ?.map((e) => AttributeValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      superAttributes: (json['superAttributes'] as List<dynamic>?)
          ?.map((e) => Attributes.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => Inventories.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupedProducts: (json['groupedProducts'] as List<dynamic>?)
          ?.map((e) => GroupedProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadableSamples: (json['downloadableSamples'] as List<dynamic>?)
          ?.map((e) => DownloadableProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadableLinks: (json['downloadableLinks'] as List<dynamic>?)
          ?.map((e) => DownloadableProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      bundleOptions: (json['bundleOptions'] as List<dynamic>?)
          ?.map((e) => BundleOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerGroupPrices: (json['customerGroupPrices'] as List<dynamic>?)
          ?.map((e) => CustomerGroupPrices.fromJson(e as Map<String, dynamic>))
          .toList(),
      booking: json['booking'] as String?,
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      shareURL: json['shareURL'] as String?,
    )
      ..success = json['success'] as String?
      ..responseStatus = json['responseStatus'] as bool?
      ..configutableData = json['configutableData'] == null
          ? null
          : ConfigurableData.fromJson(
              json['configutableData'] as Map<String, dynamic>)
      ..averageRating = json['averageRating'] as String?
      ..percentageRating = json['percentageRating'];

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
      'shareURL': instance.shareURL,
      'additionalData': instance.additionalData,
      'priceHtml': instance.priceHtml,
      'id': instance.id,
      'type': instance.type,
      'isInWishlist': instance.isInWishlist,
      'attributeFamilyId': instance.attributeFamilyId,
      'configutableData': instance.configutableData,
      'sku': instance.sku,
      'parentId': instance.parentId,
      'productFlats': instance.productFlats,
      'variants': instance.variants,
      'attributeFamily': instance.attributeFamily,
      'attributeValues': instance.attributeValues,
      'superAttributes': instance.superAttributes,
      'categories': instance.categories,
      'inventories': instance.inventories,
      'images': instance.images,
      'reviews': instance.reviews,
      'groupedProducts': instance.groupedProducts,
      'downloadableSamples': instance.downloadableSamples,
      'downloadableLinks': instance.downloadableLinks,
      'bundleOptions': instance.bundleOptions,
      'customerGroupPrices': instance.customerGroupPrices,
      'booking': instance.booking,
      'cart': instance.cart,
      'averageRating': instance.averageRating,
      'percentageRating': instance.percentageRating,
    };

AdditionalData _$AdditionalDataFromJson(Map<String, dynamic> json) =>
    AdditionalData(
      id: json['id'] as String?,
      color: json['color'] as String?,
      label: json['label'] as String?,
      value: json['value'] as String?,
      adminName: json['adminName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AdditionalDataToJson(AdditionalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'label': instance.label,
      'value': instance.value,
      'adminName': instance.adminName,
      'type': instance.type,
    };

ProductFlats _$ProductFlatsFromJson(Map<String, dynamic> json) => ProductFlats(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      productNumber: json['productNumber'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      urlKey: json['urlKey'] as String?,
      isNew: json['new'] as bool?,
      featured: json['featured'] as bool?,
      status: json['status'] as bool?,
      visibleIndividually: json['visibleIndividually'] as bool?,
      specialPrice: json['specialPrice'],
      specialPriceFrom: json['specialPriceFrom'] as String?,
      specialPriceTo: json['specialPriceTo'] as String?,
      weight: json['weight'],
      color: json['color'] as int?,
      colorLabel: json['colorLabel'] as String?,
      size: json['size'] as int?,
      sizeLabel: json['sizeLabel'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      productId: json['productId'] as String?,
      metaTitle: json['metaTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      metaDescription: json['metaDescription'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    )..price = json['price'];

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
      'specialPrice': instance.specialPrice,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
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
      'metaTitle': instance.metaTitle,
      'metaKeywords': instance.metaKeywords,
      'metaDescription': instance.metaDescription,
      'width': instance.width,
      'height': instance.height,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

AttributeFamily _$AttributeFamilyFromJson(Map<String, dynamic> json) =>
    AttributeFamily(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      status: json['status'] as bool?,
      isUserDefined: json['isUserDefined'] as bool?,
    );

Map<String, dynamic> _$AttributeFamilyToJson(AttributeFamily instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'status': instance.status,
      'isUserDefined': instance.isUserDefined,
    };

AttributeValues _$AttributeValuesFromJson(Map<String, dynamic> json) =>
    AttributeValues(
      id: json['id'] as String?,
      productId: json['productId'] as String?,
      attributeId: json['attributeId'] as String?,
      locale: json['locale'] as String?,
      channel: json['channel'] as String?,
      textValue: json['textValue'] as String?,
      booleanValue: json['booleanValue'] as bool?,
      integerValue: json['integerValue'] as int?,
      attribute: json['attribute'] == null
          ? null
          : Attribute.fromJson(json['attribute'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttributeValuesToJson(AttributeValues instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'attributeId': instance.attributeId,
      'locale': instance.locale,
      'channel': instance.channel,
      'textValue': instance.textValue,
      'booleanValue': instance.booleanValue,
      'integerValue': instance.integerValue,
      'attribute': instance.attribute,
    };

Attribute _$AttributeFromJson(Map<String, dynamic> json) => Attribute(
      id: json['id'] as String?,
      code: json['code'] as String?,
      adminName: json['adminName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'adminName': instance.adminName,
      'type': instance.type,
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
      label: json['label'] as String?,
      description: json['description'] as String?,
      localeId: json['localeId'] as String?,
      locale: json['locale'] as String?,
      title: json['title'] as String?,
      productDownloadableLinkId: json['productDownloadableLinkId'] as String?,
      productDownloadableSampleId:
          json['productDownloadableSampleId'] as String?,
      productBundleOptionId: json['productBundleOptionId'] as String?,
    );

Map<String, dynamic> _$TranslationsToJson(Translations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'localeId': instance.localeId,
      'locale': instance.locale,
      'title': instance.title,
      'label': instance.label,
      'productDownloadableSampleId': instance.productDownloadableSampleId,
      'productDownloadableLinkId': instance.productDownloadableLinkId,
      'productBundleOptionId': instance.productBundleOptionId,
    };

Inventories _$InventoriesFromJson(Map<String, dynamic> json) => Inventories(
      id: json['id'] as String?,
      qty: json['qty'] as int?,
      productId: json['productId'] as String?,
      inventorySourceId: json['inventorySourceId'] as String?,
      vendorId: json['vendorId'] as int?,
      inventorySource: json['inventorySource'] == null
          ? null
          : InventorySource.fromJson(
              json['inventorySource'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InventoriesToJson(Inventories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'productId': instance.productId,
      'inventorySourceId': instance.inventorySourceId,
      'vendorId': instance.vendorId,
      'inventorySource': instance.inventorySource,
    };

InventorySource _$InventorySourceFromJson(Map<String, dynamic> json) =>
    InventorySource(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      contactName: json['contactName'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactNumber: json['contactNumber'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      street: json['street'] as String?,
      postcode: json['postcode'] as String?,
      priority: json['priority'] as int?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$InventorySourceToJson(InventorySource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'contactName': instance.contactName,
      'contactEmail': instance.contactEmail,
      'contactNumber': instance.contactNumber,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'street': instance.street,
      'postcode': instance.postcode,
      'priority': instance.priority,
      'status': instance.status,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: json['id'] as String?,
      type: json['type'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
      productId: json['productId'] as String?,
      smallImageUrl: json['smallImageUrl'] as String?,
      mediumImageUrl: json['mediumImageUrl'] as String?,
      largeImageUrl: json['largeImageUrl'] as String?,
      originalImageUrl: json['originalImageUrl'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'path': instance.path,
      'url': instance.url,
      'productId': instance.productId,
      'smallImageUrl': instance.smallImageUrl,
      'mediumImageUrl': instance.mediumImageUrl,
      'largeImageUrl': instance.largeImageUrl,
      'originalImageUrl': instance.originalImageUrl,
    };

CustomerGroupPrices _$CustomerGroupPricesFromJson(Map<String, dynamic> json) =>
    CustomerGroupPrices(
      id: json['id'] as String?,
      qty: json['qty'] as int?,
      valueType: json['valueType'] as String?,
      value: json['value'] as int?,
      productId: json['productId'] as String?,
      customerGroupId: json['customerGroupId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CustomerGroupPricesToJson(
        CustomerGroupPrices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'valueType': instance.valueType,
      'value': instance.value,
      'productId': instance.productId,
      'customerGroupId': instance.customerGroupId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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

Variants _$VariantsFromJson(Map<String, dynamic> json) => Variants(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
      map: json['map'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$VariantsToJson(Variants instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributeFamilyId': instance.attributeFamilyId,
      'sku': instance.sku,
      'parentId': instance.parentId,
      'map': instance.map,
    };

SuperAttributes _$SuperAttributesFromJson(Map<String, dynamic> json) =>
    SuperAttributes();

Map<String, dynamic> _$SuperAttributesToJson(SuperAttributes instance) =>
    <String, dynamic>{};

ConfigurableData _$ConfigurableDataFromJson(Map<String, dynamic> json) =>
    ConfigurableData(
      chooseText: json['chooseText'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => Attributes.fromJson(e as Map<String, dynamic>))
          .toList(),
      index: (json['index'] as List<dynamic>?)
          ?.map((e) => Index.fromJson(e as Map<String, dynamic>))
          .toList(),
      variantPrices: (json['variantPrices'] as List<dynamic>?)
          ?.map((e) => VariantPrices.fromJson(e as Map<String, dynamic>))
          .toList(),
      variantImages: (json['variantImages'] as List<dynamic>?)
          ?.map((e) => VariantImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      regularPrice: json['regularPrice'] == null
          ? null
          : RegularPrice.fromJson(json['regularPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigurableDataToJson(ConfigurableData instance) =>
    <String, dynamic>{
      'chooseText': instance.chooseText,
      'attributes': instance.attributes,
      'index': instance.index,
      'variantPrices': instance.variantPrices,
      'variantImages': instance.variantImages,
      'regularPrice': instance.regularPrice,
    };

Attributes _$AttributesFromJson(Map<String, dynamic> json) => Attributes(
      id: json['id'] as String?,
      type: json['type'] as String?,
      code: json['code'] as String?,
      label: json['label'] as String?,
      swatchType: json['swatchType'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Options.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'label': instance.label,
      'swatchType': instance.swatchType,
      'type': instance.type,
      'options': instance.options,
    };

Options _$OptionsFromJson(Map<String, dynamic> json) => Options(
      id: json['id'] as String?,
      label: json['label'] as String?,
      swatchType: json['swatchType'] as String?,
      isSelect: json['isSelect'] as bool?,
      swatchValue: json['swatchValue'] as String?,
    );

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'swatchType': instance.swatchType,
      'swatchValue': instance.swatchValue,
      'isSelect': instance.isSelect,
    };

Index _$IndexFromJson(Map<String, dynamic> json) => Index(
      id: json['id'] as String?,
      attributeOptionIds: (json['attributeOptionIds'] as List<dynamic>?)
          ?.map((e) => AttributeOptionIds.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IndexToJson(Index instance) => <String, dynamic>{
      'id': instance.id,
      'attributeOptionIds': instance.attributeOptionIds,
    };

AttributeOptionIds _$AttributeOptionIdsFromJson(Map<String, dynamic> json) =>
    AttributeOptionIds(
      attributeId: json['attributeId'] as String?,
      attributeOptionId: json['attributeOptionId'] as String?,
    );

Map<String, dynamic> _$AttributeOptionIdsToJson(AttributeOptionIds instance) =>
    <String, dynamic>{
      'attributeId': instance.attributeId,
      'attributeOptionId': instance.attributeOptionId,
    };

VariantPrices _$VariantPricesFromJson(Map<String, dynamic> json) =>
    VariantPrices(
      id: json['id'] as String?,
      regularPrice: json['regularPrice'] == null
          ? null
          : RegularPrice.fromJson(json['regularPrice'] as Map<String, dynamic>),
      finalPrice: json['finalPrice'] == null
          ? null
          : RegularPrice.fromJson(json['finalPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VariantPricesToJson(VariantPrices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'regularPrice': instance.regularPrice,
      'finalPrice': instance.finalPrice,
    };

RegularPrice _$RegularPriceFromJson(Map<String, dynamic> json) => RegularPrice(
      price: json['price'],
      formatedPrice: json['formatedPrice'] as String?,
    );

Map<String, dynamic> _$RegularPriceToJson(RegularPrice instance) =>
    <String, dynamic>{
      'price': instance.price,
      'formatedPrice': instance.formatedPrice,
    };

VariantImages _$VariantImagesFromJson(Map<String, dynamic> json) =>
    VariantImages(
      id: json['id'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VariantImagesToJson(VariantImages instance) =>
    <String, dynamic>{
      'id': instance.id,
      'images': instance.images,
    };

DownloadableProduct _$DownloadableProductFromJson(Map<String, dynamic> json) =>
    DownloadableProduct(
      id: json['id'] as String?,
      title: json['title'] as String?,
      price: json['price'] as int?,
      url: json['url'] as String?,
      file: json['file'] as String?,
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

Map<String, dynamic> _$DownloadableProductToJson(
        DownloadableProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'url': instance.url,
      'file': instance.file,
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

BundleOptions _$BundleOptionsFromJson(Map<String, dynamic> json) =>
    BundleOptions(
      id: json['id'] as String?,
      type: json['type'] as String?,
      isRequired: json['isRequired'] as bool?,
      sortOrder: json['sortOrder'] as int?,
      productId: json['productId'] as String?,
      bundleOptionProducts: (json['bundleOptionProducts'] as List<dynamic>?)
          ?.map((e) => BundleOptionProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundleOptionsToJson(BundleOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'isRequired': instance.isRequired,
      'sortOrder': instance.sortOrder,
      'productId': instance.productId,
      'bundleOptionProducts': instance.bundleOptionProducts,
      'translations': instance.translations,
    };

BundleOptionProducts _$BundleOptionProductsFromJson(
        Map<String, dynamic> json) =>
    BundleOptionProducts(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      id: json['id'] as String?,
      qty: json['qty'] as int?,
      isUserDefined: json['isUserDefined'] as bool?,
      sortOrder: json['sortOrder'] as int?,
      isDefault: json['isDefault'] as bool?,
      productBundleOptionId: json['productBundleOptionId'] as String?,
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$BundleOptionProductsToJson(
        BundleOptionProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'isUserDefined': instance.isUserDefined,
      'sortOrder': instance.sortOrder,
      'isDefault': instance.isDefault,
      'productBundleOptionId': instance.productBundleOptionId,
      'productId': instance.productId,
      'product': instance.product,
    };

GroupedProducts _$GroupedProductsFromJson(Map<String, dynamic> json) =>
    GroupedProducts(
      id: json['id'] as String?,
      qty: json['qty'] as int?,
      sortOrder: json['sortOrder'] as int?,
      productId: json['productId'] as String?,
      associatedProductId: json['associatedProductId'] as String?,
      associatedProduct: json['associatedProduct'] == null
          ? null
          : AssociatedProduct.fromJson(
              json['associatedProduct'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupedProductsToJson(GroupedProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'sortOrder': instance.sortOrder,
      'productId': instance.productId,
      'associatedProductId': instance.associatedProductId,
      'associatedProduct': instance.associatedProduct,
    };

AssociatedProduct _$AssociatedProductFromJson(Map<String, dynamic> json) =>
    AssociatedProduct(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$AssociatedProductToJson(AssociatedProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributeFamilyId': instance.attributeFamilyId,
      'sku': instance.sku,
      'parentId': instance.parentId,
    };
