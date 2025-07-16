import 'package:json_annotation/json_annotation.dart';

part 'gdpr_pdf_model.g.dart';

@JsonSerializable()
class GdprPdfModel {
  final bool? success;
  final String? string;
  final DownloadPdf? download;

  GdprPdfModel({
    this.success,
    this.string,
    this.download,
  });

  factory GdprPdfModel.fromJson(Map<String, dynamic> json) =>
      _$GdprPdfModelFromJson(json);

  Map<String, dynamic> toJson() => _$GdprPdfModelToJson(this);
}

@JsonSerializable()
class DownloadPdf {
  final String? fileName;
  final String? extension;

  DownloadPdf({
    this.fileName,
    this.extension,
  });

  factory DownloadPdf.fromJson(Map<String, dynamic> json) =>
      _$DownloadPdfFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadPdfToJson(this);
}
