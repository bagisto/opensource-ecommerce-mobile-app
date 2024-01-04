// import 'dart:convert';
//
// import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
//
// import '../../../data_model/product_model/product_screen_model.dart';
// import 'package:json_annotation/json_annotation.dart';
// part 'new_product_data.g.dart';
//
// @JsonSerializable()
// class AllProductsModel extends GraphQlBaseModel{
//   @JsonKey(name: "data")
//   List<AllProducts>? allProducts;
//
//   AllProductsModel({this.allProducts});
//
//   factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
//       _$AllProductsModelFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$AllProductsModelToJson(this);
// }
//
// @JsonSerializable()
// class AllProducts {
//   String? id;
//   String? type;
//   bool? isInWishlist;
//   String? attributeFamilyId;
//   List<AdditionalData>? additionalData;
//   PriceHtml? priceHtml;
//   String? sku;
//   Null? parentId;
//   List<ProductFlats>? productFlats;
//   List<Variants>? variants;
//   Null? parent;
//   AttributeFamily? attributeFamily;
//   List<AttributeValues>? attributeValues;
//   List<Attributes>? superAttributes;
//   List<Categories>? categories;
//   List<Inventories>? inventories;
//   List<Images>? images;
//   List<Null>? videos;
//   List<Null>? orderedInventories;
//   List<Null>? reviews;
//   List<GroupedProducts>? groupedProducts;
//   List<DownloadableProduct>? downloadableSamples;
//   List<DownloadableProduct>? downloadableLinks;
//   List<Null>? bundleOptions;
//   List<Null>? customerGroupPrices;
//
//   AllProducts({this.id, this.type, this.isInWishlist, this.attributeFamilyId, this.additionalData, this.priceHtml, this.sku, this.parentId, this.productFlats, this.variants, this.parent, this.attributeFamily, this.attributeValues, this.superAttributes, this.categories, this.inventories, this.images, this.videos, this.orderedInventories, this.reviews, this.groupedProducts, this.downloadableSamples, this.downloadableLinks, this.bundleOptions, this.customerGroupPrices});
//
//   factory AllProducts.fromJson(Map<String, dynamic> json) =>
//       _$PriceHtmlFromJson(json);
//
//   Map<String, dynamic> toJson() =>
//       _$PriceHtmlToJson(this);
// }
//
// @JsonSerializable()
// class PriceHtml {
//   String? id;
//   String? type;
//   String? html;
//   String? regular;
//   String? special;
//   String? minPrice;
//   String? priceHtml;
//   String? priceWithoutHtml;
//   String? regularPrice;
//   String? formattedRegularPrice;
//   String? finalPrice;
//   String? formattedFinalPrice;
//   String? currencyCode;
//   BundlePrice? bundlePrice;
//
//   PriceHtml({this.id, this.type, this.html, this.regular, this.special, this.finalPrice, this.formattedFinalPrice,
//     this.regularPrice, this.priceWithoutHtml, this.priceHtml, this.minPrice, this.formattedRegularPrice,
//     this.currencyCode, this.bundlePrice});
//
//   factory PriceHtml.fromJson(Map<String, dynamic> json) =>
//       _$PriceHtmlFromJson(json);
//
//   Map<String, dynamic> toJson() =>
//       _$PriceHtmlToJson(this);
// }
//
//
// @JsonSerializable()
// class BundlePrice {
//   String? finalPriceFrom;
//   String? formattedFinalPriceFrom;
//   String? regularPriceFrom;
//   String? formattedRegularPriceFrom;
//   String? finalPriceTo;
//   String? formattedFinalPriceTo;
//   String? regularPriceTo;
//   String? formattedRegularPriceTo;
//
//   BundlePrice({this.finalPriceFrom, this.formattedFinalPriceFrom, this.regularPriceFrom, this.formattedRegularPriceFrom, this.finalPriceTo, this.formattedFinalPriceTo, this.regularPriceTo, this.formattedRegularPriceTo});
//
//   factory BundlePrice.fromJson(Map<String, dynamic> json) => _$BundlePriceFromJson(json);
//
//   Map<String, dynamic> toJson() => _$BundlePriceToJson(this);
// }