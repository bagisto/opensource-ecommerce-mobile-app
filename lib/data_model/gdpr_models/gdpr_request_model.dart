import 'package:json_annotation/json_annotation.dart';
part 'gdpr_request_model.g.dart';

@JsonSerializable()
class GdprRequestModel {
  @JsonKey(name: "__typename")
  final String? typename;
  @JsonKey(name: "paginatorInfo")
  final PaginatorInfo? paginatorInfo;
  @JsonKey(name: "data")
  final List<Datum>? data;
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "responseStatus")
  final bool? responseStatus;

  GdprRequestModel({
    this.typename,
    this.paginatorInfo,
    this.data,
    this.status,
    this.responseStatus,
  });

  factory GdprRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GdprRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GdprRequestModelToJson(this);
}

@JsonSerializable()
class Datum {
  @JsonKey(name: "__typename")
  final String? typename;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "customerId")
  final String? customerId;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "revokedAt")
  final dynamic revokedAt;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  Datum({
    this.typename,
    this.id,
    this.customerId,
    this.email,
    this.status,
    this.type,
    this.message,
    this.revokedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class PaginatorInfo {
  @JsonKey(name: "__typename")
  final String? typename;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "currentPage")
  final int? currentPage;
  @JsonKey(name: "lastPage")
  final int? lastPage;
  @JsonKey(name: "total")
  final int? total;

  PaginatorInfo({
    this.typename,
    this.count,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatorInfoToJson(this);
}
