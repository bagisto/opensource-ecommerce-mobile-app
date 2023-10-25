// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertisement_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Advertisements _$AdvertisementsFromJson(Map<String, dynamic> json) =>
    Advertisements(
      advertisementFour: (json['advertisementFour'] as List<dynamic>?)
          ?.map((e) => AdvertisementSlug.fromJson(e as Map<String, dynamic>))
          .toList(),
      advertisementThree: (json['advertisementThree'] as List<dynamic>?)
          ?.map((e) => AdvertisementSlug.fromJson(e as Map<String, dynamic>))
          .toList(),
      advertisementTwo: (json['advertisementTwo'] as List<dynamic>?)
          ?.map((e) => AdvertisementSlug.fromJson(e as Map<String, dynamic>))
          .toList(),
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdvertisementsToJson(Advertisements instance) =>
    <String, dynamic>{
      'advertisementFour': instance.advertisementFour,
      'advertisementThree': instance.advertisementThree,
      'advertisementTwo': instance.advertisementTwo,
      'cart': instance.cart,
    };

AdvertisementSlug _$AdvertisementSlugFromJson(Map<String, dynamic> json) =>
    AdvertisementSlug(
      image: json['image'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$AdvertisementSlugToJson(AdvertisementSlug instance) =>
    <String, dynamic>{
      'image': instance.image,
      'slug': instance.slug,
    };
