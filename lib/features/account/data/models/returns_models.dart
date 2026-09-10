import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../../../../core/constants/api_constants.dart';

// Data models for the Returns (RMA) feature.
// API reference: https://api-docs.bagisto.com/api/graphql-api/shop/returns/

final String _baseUrl = Uri.parse(bagistoEndpoint).origin;

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

/// The `item` and `images` fields come back as JSON scalars — either
/// already-decoded structures or JSON-encoded strings depending on the
/// backend serializer. Normalize both cases.
dynamic _decodeJsonScalar(dynamic value) {
  if (value is String && value.isNotEmpty) {
    try {
      return jsonDecode(value);
    } catch (_) {
      return value;
    }
  }
  return value;
}

/// Formatted date: "8 Oct 2025" (same style as CustomerOrder.formattedDate)
String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final date = DateTime.parse(raw);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  } catch (_) {
    return raw;
  }
}

// ─── Return Item Info (item snapshot inside a return) ───

class ReturnItemInfo extends Equatable {
  final int? id;
  final int? orderItemId;
  final String? sku;
  final String name;
  final int quantity;
  final String? resolution;
  final int? reasonId;
  final String? reason;
  final int? variantId;

  const ReturnItemInfo({
    this.id,
    this.orderItemId,
    this.sku,
    required this.name,
    this.quantity = 0,
    this.resolution,
    this.reasonId,
    this.reason,
    this.variantId,
  });

  factory ReturnItemInfo.fromJson(Map<String, dynamic> json) {
    return ReturnItemInfo(
      id: _parseInt(json['id']),
      orderItemId: _parseInt(json['order_item_id'] ?? json['orderItemId']),
      sku: json['sku']?.toString(),
      name: json['name']?.toString() ?? '',
      quantity: _parseInt(json['quantity'] ?? json['qty']) ?? 0,
      resolution: json['resolution']?.toString(),
      reasonId: _parseInt(json['reason_id'] ?? json['reasonId']),
      reason: json['reason']?.toString(),
      variantId: _parseInt(json['variant_id'] ?? json['variantId']),
    );
  }

  /// Display label for the resolution type
  bool get isCancelResolution =>
      (resolution ?? '').toLowerCase() == 'cancel_items';

  @override
  List<Object?> get props => [
    id,
    orderItemId,
    sku,
    name,
    quantity,
    resolution,
    reasonId,
    reason,
    variantId,
  ];
}

// ─── Return Image ───

class ReturnImage extends Equatable {
  final int? id;
  final String? path;
  final String? url;

  const ReturnImage({this.id, this.path, this.url});

  factory ReturnImage.fromJson(Map<String, dynamic> json) {
    String? url = json['url']?.toString();
    final path = json['path']?.toString();
    if ((url == null || url.isEmpty) && path != null && path.isNotEmpty) {
      url = path.startsWith('http')
          ? path
          : '$_baseUrl/storage/${path.startsWith('/') ? path.substring(1) : path}';
    }
    return ReturnImage(id: _parseInt(json['id']), path: path, url: url);
  }

  @override
  List<Object?> get props => [id, path, url];
}

// ─── Customer Return (list node + detail) ───

class CustomerReturn extends Equatable {
  final int? id;
  final int? orderId;
  final String? orderIncrementId;
  final int? statusId;
  final String statusTitle;
  final String? statusColor;
  final String? packageCondition;
  final String? information;
  final bool canClose;
  final bool canReopen;
  final bool isExpired;
  final ReturnItemInfo? item;
  final List<ReturnImage> images;
  final int messagesCount;
  final String? createdAt;
  final String? updatedAt;

  const CustomerReturn({
    this.id,
    this.orderId,
    this.orderIncrementId,
    this.statusId,
    this.statusTitle = 'Pending',
    this.statusColor,
    this.packageCondition,
    this.information,
    this.canClose = false,
    this.canReopen = false,
    this.isExpired = false,
    this.item,
    this.images = const [],
    this.messagesCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerReturn.fromJson(Map<String, dynamic> json) {
    ReturnItemInfo? item;
    final rawItem = _decodeJsonScalar(json['item']);
    if (rawItem is Map) {
      item = ReturnItemInfo.fromJson(Map<String, dynamic>.from(rawItem));
    } else if (rawItem is List && rawItem.isNotEmpty && rawItem.first is Map) {
      item = ReturnItemInfo.fromJson(
        Map<String, dynamic>.from(rawItem.first as Map),
      );
    }

    final images = <ReturnImage>[];
    final rawImages = _decodeJsonScalar(json['images']);
    if (rawImages is List) {
      for (final entry in rawImages) {
        if (entry is Map) {
          images.add(ReturnImage.fromJson(Map<String, dynamic>.from(entry)));
        } else if (entry is String && entry.isNotEmpty) {
          images.add(ReturnImage.fromJson({'path': entry}));
        }
      }
    }

    return CustomerReturn(
      id: _parseInt(json['_id'] ?? json['id']),
      orderId: _parseInt(json['orderId']),
      orderIncrementId: json['orderIncrementId']?.toString(),
      statusId: _parseInt(json['statusId']),
      statusTitle: json['statusTitle']?.toString() ?? 'Pending',
      statusColor: json['statusColor']?.toString(),
      packageCondition: json['packageCondition']?.toString(),
      information: json['information']?.toString(),
      canClose: json['canClose'] == true,
      canReopen: json['canReopen'] == true,
      isExpired: json['isExpired'] == true,
      item: item,
      images: images,
      messagesCount: _parseInt(json['messagesCount']) ?? 0,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  /// Return number formatted as #12
  String get returnNumber => '#${id ?? 0}';

  /// Order number formatted as #100000001
  String get orderNumber =>
      orderIncrementId != null && orderIncrementId!.isNotEmpty
      ? '#$orderIncrementId'
      : '#${orderId ?? 0}';

  /// Formatted date: "8 Oct 2025"
  String get formattedDate => _formatDate(createdAt);

  /// Whether the display status describes a completed or rejected return.
  bool get isTerminal {
    switch (statusTitle.toLowerCase()) {
      case 'canceled':
      case 'cancelled':
      case 'declined':
      case 'rejected':
      case 'solved':
      case 'closed':
        return true;
      default:
        return false;
    }
  }

  /// The cancellation API permits requests that are not already canceled.
  /// Prefer the fixed canceled status ID because display labels are editable.
  bool get canCancel {
    if (id == null) return false;
    if (statusId != null) return statusId != 9;
    return !const {
      'canceled',
      'cancelled',
      'request canceled',
      'request cancelled',
    }.contains(statusTitle.trim().toLowerCase());
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderIncrementId,
    statusId,
    statusTitle,
    statusColor,
    packageCondition,
    information,
    canClose,
    canReopen,
    isExpired,
    item,
    images,
    messagesCount,
    createdAt,
    updatedAt,
  ];
}

// ─── Returnable Item (order item eligible for return) ───

class ReturnableItem extends Equatable {
  final int? orderItemId;
  final int? productId;
  final String? sku;
  final String name;
  final String? type;
  final String? urlKey;
  final double price;
  final String? baseImageUrl;
  final int qtyOrdered;
  final int currentQuantity;
  final int forReturnQuantity;
  final int forCancelQuantity;
  final int rmaQuantity;
  final int? rmaReturnPeriod;

  const ReturnableItem({
    this.orderItemId,
    this.productId,
    this.sku,
    required this.name,
    this.type,
    this.urlKey,
    this.price = 0,
    this.baseImageUrl,
    this.qtyOrdered = 0,
    this.currentQuantity = 0,
    this.forReturnQuantity = 0,
    this.forCancelQuantity = 0,
    this.rmaQuantity = 0,
    this.rmaReturnPeriod,
  });

  factory ReturnableItem.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['baseImageUrl']?.toString();
    if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = '$_baseUrl$imageUrl';
    }
    return ReturnableItem(
      orderItemId: _parseInt(json['orderItemId']),
      productId: _parseInt(json['productId']),
      sku: json['sku']?.toString(),
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString(),
      urlKey: json['urlKey']?.toString(),
      price: _parseDouble(json['price']) ?? 0,
      baseImageUrl: imageUrl,
      qtyOrdered: _parseInt(json['qtyOrdered']) ?? 0,
      currentQuantity: _parseInt(json['currentQuantity']) ?? 0,
      forReturnQuantity: _parseInt(json['forReturnQuantity']) ?? 0,
      forCancelQuantity: _parseInt(json['forCancelQuantity']) ?? 0,
      rmaQuantity: _parseInt(json['rmaQuantity']) ?? 0,
      rmaReturnPeriod: _parseInt(json['rmaReturnPeriod']),
    );
  }

  /// Max quantity for the given resolution type
  int maxQuantityFor(String resolutionType) =>
      resolutionType == 'cancel_items' ? forCancelQuantity : forReturnQuantity;

  @override
  List<Object?> get props => [
    orderItemId,
    productId,
    sku,
    name,
    type,
    urlKey,
    price,
    baseImageUrl,
    qtyOrdered,
    currentQuantity,
    forReturnQuantity,
    forCancelQuantity,
    rmaQuantity,
    rmaReturnPeriod,
  ];
}

// ─── Return Reason ───

class ReturnReason extends Equatable {
  final int id;
  final String title;
  final int position;

  const ReturnReason({required this.id, required this.title, this.position = 0});

  factory ReturnReason.fromJson(Map<String, dynamic> json) {
    return ReturnReason(
      id: _parseInt(json['_id'] ?? json['id']) ?? 0,
      title: json['title']?.toString() ?? '',
      position: _parseInt(json['position']) ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, title, position];
}

// ─── Return Message ───

class ReturnMessage extends Equatable {
  final int? id;
  final int? rmaId;
  final String message;
  final bool isAdmin;
  final String? attachment;
  final String? attachmentUrl;
  final String? createdAt;

  const ReturnMessage({
    this.id,
    this.rmaId,
    required this.message,
    this.isAdmin = false,
    this.attachment,
    this.attachmentUrl,
    this.createdAt,
  });

  factory ReturnMessage.fromJson(Map<String, dynamic> json) {
    return ReturnMessage(
      id: _parseInt(json['_id'] ?? json['id']),
      rmaId: _parseInt(json['rmaId']),
      message: json['message']?.toString() ?? '',
      isAdmin: json['isAdmin'] == true,
      attachment: json['attachment']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  /// Formatted date: "8 Oct 2025"
  String get formattedDate => _formatDate(createdAt);

  @override
  List<Object?> get props => [
    id,
    rmaId,
    message,
    isAdmin,
    attachment,
    attachmentUrl,
    createdAt,
  ];
}
