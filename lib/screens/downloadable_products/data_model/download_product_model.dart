
import 'package:json_annotation/json_annotation.dart';

import '../../../data_model/graphql_base_model.dart';
part 'download_product_model.g.dart';


@JsonSerializable()
class DataModel{
  DownloadLinkModel? data;

  DataModel({this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return _$DataModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}

@JsonSerializable()
class DownloadLinkModel{
  DownloadLink? downloadLink;

  DownloadLinkModel({this.downloadLink});

  factory DownloadLinkModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadLinkModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DownloadLinkModelToJson(this);
}

@JsonSerializable()
class DownloadLink extends GraphQlBaseModel{
  // bool? status;
  String? string;
  Download? download;

  DownloadLink({ this.string, this.download});

  factory DownloadLink.fromJson(Map<String, dynamic> json) {
    return _$DownloadLinkFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$DownloadLinkToJson(this);
}

@JsonSerializable()
class Download {
  String? id;
  String? productName;
  String? name;
  String? url;
  String? file;
  String? fileName;
  String? type;
  int? downloadBought;
  int? downloadUsed;
  bool? status;
  String? customerId;
  String? orderId;
  String? orderItemId;
  String? createdAt;
  String? updatedAt;

  Download(
      {this.id,
        this.productName,
        this.name,
        this.url,
        this.file,
        this.fileName,
        this.type,
        this.downloadBought,
        this.downloadUsed,
        this.status,
        this.customerId,
        this.orderId,
        this.orderItemId,
        this.createdAt,
        this.updatedAt});

  factory Download.fromJson(Map<String, dynamic> json) {
    return _$DownloadFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DownloadToJson(this);
}
