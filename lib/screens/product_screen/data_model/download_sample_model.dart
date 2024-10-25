import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/graphql_base_model.dart';

part 'download_sample_model.g.dart';

@JsonSerializable()
class DownloadSampleModel extends BaseModel {
  String? string;

  DownloadSampleModel({this.string});

  factory DownloadSampleModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadSampleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DownloadSampleModelToJson(this);
}