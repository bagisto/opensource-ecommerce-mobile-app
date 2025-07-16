
import 'package:json_annotation/json_annotation.dart';
import '../screens/home_page/data_model/new_product_data.dart';

part 'core_configs_model.g.dart';

@JsonSerializable()
class CoreConfigsModel {
  CoreConfigs? coreConfigs;

  CoreConfigsModel({
    this.coreConfigs,
  });

  factory CoreConfigsModel.fromJson(Map<String, dynamic> json) => _$CoreConfigsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoreConfigsModelToJson(this);
}

@JsonSerializable()
class CoreConfigs {
  PaginatorInfo? paginatorInfo;
  List<ConfigModel>? data;

  CoreConfigs({
    this.paginatorInfo,
    this.data,
  });

  factory CoreConfigs.fromJson(Map<String, dynamic> json) => _$CoreConfigsFromJson(json);

  Map<String, dynamic> toJson() => _$CoreConfigsToJson(this);
}

@JsonSerializable()
class ConfigModel {
  String? id;
  String? code;
  String? value;
  String? channelCode;
  String? localeCode;

  ConfigModel({
    this.id,
    this.code,
    this.value,
    this.channelCode,
    this.localeCode,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => _$ConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigModelToJson(this);
}

