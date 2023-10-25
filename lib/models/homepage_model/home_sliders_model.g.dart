// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_sliders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeSlidersData _$HomeSlidersDataFromJson(Map<String, dynamic> json) =>
    HomeSlidersData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => HomeSliders.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeSlidersDataToJson(HomeSlidersData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      homeSliders: (json['homeSliders'] as List<dynamic>?)
          ?.map((e) => HomeSliders.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'homeSliders': instance.homeSliders,
    };

HomeSliders _$HomeSlidersFromJson(Map<String, dynamic> json) => HomeSliders(
      id: json['id'] as String?,
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String?,
      path: json['path'] as String?,
      content: json['content'] as String?,
      channelId: json['channelId'] as String?,
      locale: json['locale'] as String?,
      sliderPath: json['sliderPath'] as String?,
      imgPath: json['imgPath'] as String?,
    );

Map<String, dynamic> _$HomeSlidersToJson(HomeSliders instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'path': instance.path,
      'content': instance.content,
      'channelId': instance.channelId,
      'locale': instance.locale,
      'sliderPath': instance.sliderPath,
      'imgPath': instance.imgPath,
    };
