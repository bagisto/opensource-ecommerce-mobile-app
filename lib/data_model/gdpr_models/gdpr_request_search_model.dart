import 'package:json_annotation/json_annotation.dart';
part 'gdpr_request_search_model.g.dart';

@JsonSerializable()
class GdprSearchModal {
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
  final String? revokedAt;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "responseStatus")
  final bool? responseStatus;

  GdprSearchModal({
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
    this.responseStatus,
  });

  factory GdprSearchModal.fromJson(Map<String, dynamic> json) =>
      _$GdprSearchModalFromJson(json);

  Map<String, dynamic> toJson() => _$GdprSearchModalToJson(this);
}
