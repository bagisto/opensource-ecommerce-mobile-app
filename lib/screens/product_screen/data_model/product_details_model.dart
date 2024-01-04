import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/product_model/product_screen_model.dart';

part 'product_details_model.g.dart';

@JsonSerializable()
class ProductDetailsModel extends GraphQlBaseModel {
  @JsonKey(name: "data")
  Product? product;

  ProductDetailsModel({this.product});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductDetailsModelToJson(this);
}

@JsonSerializable()
class Product {
  List<AdditionalData>? additionalData;
  String? id;
  String? type;
  String? name;
  String? attributeFamilyId;
  String? sku;
  String? parentId;
  bool? isInWishlist;
  bool? isInSale;
  @JsonKey(name: "new")
  bool? isNew;
  bool? featured;
  bool? status;
  bool? visibleIndividually;
  bool? guestCheckout;
  PriceHtml? priceHtml;
  @JsonKey(name: "configutableData")
  ConfigurableData? configurableData;
  List<ProductFlats>? productFlats;
  List<Variants>? variants;
  String? parent;
  AttributeFamily? attributeFamily;
  List<AttributeValues>? attributeValues;
  List<Attributes>? superAttributes;
  List<Categories>? categories;
  List<Inventories>? inventories;
  List<Images>? images;
  List<dynamic>? videos;
  List<dynamic>? orderedInventories;
  List<Reviews>? reviews;
  List<GroupedProducts>? groupedProducts;
  List<DownloadableProduct>? downloadableSamples;
  List<DownloadableProduct>? downloadableLinks;
  List<BundleOptions>? bundleOptions;
  List<CustomerGroupPrices>? customerGroupPrices;
  CartDetailsModel? cart;
  String? shareURL;
  String? averageRating;
  dynamic percentageRating;
  String? urlKey;
  String? description;
  String? shortDescription;

  Product(
      {this.id,
        this.type,
        this.attributeFamilyId,
        this.sku,
        this.parentId,
        this.isInWishlist,
        this.isInSale,
        this.featured,
        this.status,
        this.visibleIndividually,
        this.guestCheckout,
        this.priceHtml,
        this.configurableData,
        this.productFlats,
        this.variants,
        this.parent,
        this.attributeFamily,
        this.attributeValues,
        this.superAttributes,
        this.categories,
        this.inventories,
        this.images,
        this.videos,
        this.orderedInventories,
        this.reviews,
        this.groupedProducts,
        this.downloadableSamples,
        this.downloadableLinks,
        this.bundleOptions,
        this.customerGroupPrices,
        this.cart,
        this.percentageRating,
        this.isNew,
        this.averageRating,
        this.shareURL, this.additionalData, this.name, this.urlKey, this.description, this.shortDescription});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class PriceHtml {
  String? id;
  String? type;
  String? priceHtml;
  String? priceWithoutHtml;
  String? minPrice;
  String? regularPrice;
  String? formattedRegularPrice;
  String? finalPrice;
  String? formattedFinalPrice;
  String? currencyCode;
  BundlePrice? bundlePrice;

  PriceHtml(
      {this.id,
        this.type,
        this.priceHtml,
        this.priceWithoutHtml,
        this.minPrice,
        this.regularPrice,
        this.formattedRegularPrice,
        this.finalPrice,
        this.formattedFinalPrice,
        this.currencyCode,
        this.bundlePrice});

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
      _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() => _$PriceHtmlToJson(this);
}

@JsonSerializable()
class BundlePrice {
  String? finalPriceFrom;
  String? formattedFinalPriceFrom;
  String? regularPriceFrom;
  String? formattedRegularPriceFrom;
  String? finalPriceTo;
  String? formattedFinalPriceTo;
  String? regularPriceTo;
  String? formattedRegularPriceTo;

  BundlePrice(
      {this.finalPriceFrom,
        this.formattedFinalPriceFrom,
        this.regularPriceFrom,
        this.formattedRegularPriceFrom,
        this.finalPriceTo,
        this.formattedFinalPriceTo,
        this.regularPriceTo,
        this.formattedRegularPriceTo});

  factory BundlePrice.fromJson(Map<String, dynamic> json) =>
      _$BundlePriceFromJson(json);

  Map<String, dynamic> toJson() => _$BundlePriceToJson(this);
}

@JsonSerializable()
class CartDetailsModel {
  String? id;
  int? itemsCount;
  int? itemsQty;

  CartDetailsModel(
      {this.id, this.itemsCount, this.itemsQty});

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CartDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartDetailsModelToJson(this);
}
