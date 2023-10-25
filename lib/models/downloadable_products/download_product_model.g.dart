// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
      data: json['data'] == null
          ? null
          : DownloadLinkModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'data': instance.data,
    };

DownloadLinkModel _$DownloadLinkModelFromJson(Map<String, dynamic> json) =>
    DownloadLinkModel(
      downloadLink: json['downloadLink'] == null
          ? null
          : DownloadLink.fromJson(json['downloadLink'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DownloadLinkModelToJson(DownloadLinkModel instance) =>
    <String, dynamic>{
      'downloadLink': instance.downloadLink,
    };

DownloadLink _$DownloadLinkFromJson(Map<String, dynamic> json) => DownloadLink(
      string: json['string'] as String?,
      download: json['download'] == null
          ? null
          : Download.fromJson(json['download'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$DownloadLinkToJson(DownloadLink instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'string': instance.string,
      'download': instance.download,
    };

Download _$DownloadFromJson(Map<String, dynamic> json) => Download(
      id: json['id'] as String?,
      productName: json['productName'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      file: json['file'] as String?,
      fileName: json['fileName'] as String?,
      type: json['type'] as String?,
      downloadBought: json['downloadBought'] as int?,
      downloadUsed: json['downloadUsed'] as int?,
      status: json['status'] as bool?,
      customerId: json['customerId'] as String?,
      orderId: json['orderId'] as String?,
      orderItemId: json['orderItemId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$DownloadToJson(Download instance) => <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'name': instance.name,
      'url': instance.url,
      'file': instance.file,
      'fileName': instance.fileName,
      'type': instance.type,
      'downloadBought': instance.downloadBought,
      'downloadUsed': instance.downloadUsed,
      'status': instance.status,
      'customerId': instance.customerId,
      'orderId': instance.orderId,
      'orderItemId': instance.orderItemId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
