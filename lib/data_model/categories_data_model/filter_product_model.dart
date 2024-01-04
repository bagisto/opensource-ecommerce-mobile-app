import 'package:json_annotation/json_annotation.dart';

import '../graphql_base_model.dart';
part 'filter_product_model.g.dart';

@JsonSerializable()
class GetFilterAttribute extends GraphQlBaseModel{
  double? minPrice;
  double? maxPrice;
  List<FilterAttribute>? filterAttributes;
  List<SortOrder>? sortOrders;
  List<FilterData>? filterData;

  GetFilterAttribute({
     this.minPrice,
     this.maxPrice,
     this.filterAttributes,
     this.sortOrders, this.filterData,
  });

  factory GetFilterAttribute.fromJson(Map<String, dynamic> json) =>
      _$GetFilterAttributeFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$GetFilterAttributeToJson(this);
}

@JsonSerializable()
class FilterData {
  String? key;
  List<String>? value;

  FilterData({this.key, this.value});

  factory FilterData.fromJson(Map<String, dynamic> json) =>
      _$FilterDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FilterDataToJson(this);
}

@JsonSerializable()
class FilterAttribute {
  String? id;
  String? code;
  String? adminName;
  String? type;
  List<Option>? options;

  FilterAttribute({
     this.id,
     this.code,
     this.adminName,
     this.type,
     this.options,
  });

  factory FilterAttribute.fromJson(Map<String, dynamic> json) =>
      _$FilterAttributeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FilterAttributeToJson(this);
}
@JsonSerializable()
class Option {
  String? id;
  String? adminName;
  String? swatchValue;
  int? sortOrder;
  bool? isNew;
  List<Translation>? translations;

  Option({
     this.id,
     this.adminName,
    this.swatchValue,
    this.sortOrder,
    this.isNew,
    this.translations,
  });
  factory Option.fromJson(Map<String, dynamic> json) =>
      _$OptionFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OptionToJson(this);
}
@JsonSerializable()
class Translation {
  String? id;
  String? label;
  String? locale;
  Translation({this.label,this.locale,this.id});

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationToJson(this);
}
@JsonSerializable()
class SortOrder {
  String? key;
  String? label;
  String? value;
  String? title;
  String? sort;
  String? order;
  String? position;

  SortOrder({
     this.key,
     this.label,
     this.value, this.title, this.sort, this.order, this.position
  });

  factory SortOrder.fromJson(Map<String, dynamic> json) =>
      _$SortOrderFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SortOrderToJson(this);
}
@JsonSerializable()
class Value {
  String? sort;
  String? order;

  Value({
     this.sort,
     this.order,
  });

  factory Value.fromJson(Map<String, dynamic> json) =>
      _$ValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ValueToJson(this);
}

