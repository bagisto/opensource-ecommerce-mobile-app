// Data models for Account Dashboard
// Covers: Customer Profile, Addresses, Orders, Wishlist, Reviews

// ─── Customer Profile ───

class CustomerProfile {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? dateOfBirth;
  final String? gender;
  final String? phone;
  final String? imageUrl;
  final bool? status;
  final bool subscribedToNewsLetter;
  final bool isVerified;

  const CustomerProfile({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.imageUrl,
    this.status,
    this.subscribedToNewsLetter = false,
    this.isVerified = false,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id']?.toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString(),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString(),
      status: _parseBool(json['status']),
      subscribedToNewsLetter: _parseBool(json['subscribedToNewsLetter']),
      isVerified: _parseBool(json['isVerified']),
    );
  }

  String get displayName => '$firstName $lastName'.trim();

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Creates a copy of this profile with the given fields replaced.
  CustomerProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? phone,
    String? imageUrl,
    bool? status,
    bool? subscribedToNewsLetter,
    bool? isVerified,
  }) {
    return CustomerProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      subscribedToNewsLetter:
          subscribedToNewsLetter ?? this.subscribedToNewsLetter,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

// ─── Customer Address ───

class CustomerAddress {
  final String? id;

  /// Numeric ID (`_id` / `addressId`) needed by the update mutation.
  final int? numericId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? companyName;
  final String? vatId;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String? phone;
  final bool isDefault;
  final bool useForShipping;
  final String? addressType;
  final String? createdAt;

  const CustomerAddress({
    this.id,
    this.numericId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.companyName,
    this.vatId,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    this.phone,
    this.isDefault = false,
    this.useForShipping = false,
    this.addressType,
    this.createdAt,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    // address can be a list or a string
    String addressStr = '';
    final rawAddress = json['address'];
    if (rawAddress is List) {
      addressStr = rawAddress.join(', ');
    } else if (rawAddress is String) {
      addressStr = rawAddress;
    } else {
      addressStr = json['address1']?.toString() ?? '';
    }

    // Parse numeric ID from `_id` or `addressId`
    int? numId;
    final rawNumId = json['_id'] ?? json['addressId'];
    if (rawNumId is int) {
      numId = rawNumId;
    } else if (rawNumId != null) {
      numId = int.tryParse(rawNumId.toString());
    }

    return CustomerAddress(
      id: json['id']?.toString(),
      numericId: numId,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString(),
      companyName: json['companyName']?.toString(),
      vatId: json['vatId']?.toString(),
      address: addressStr,
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      zipCode:
          json['postcode']?.toString() ?? json['zipCode']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['phoneNumber']?.toString(),
      isDefault: _parseBool(
        json['defaultAddress'] ?? json['defaultBilling'] ?? json['isDefault'],
      ),
      useForShipping: _parseBool(
        json['useForShipping'] ?? json['defaultShipping'],
      ),
      addressType: json['addressType']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  String get fullName {
    final name = '$firstName $lastName'.trim();
    if (companyName != null && companyName!.isNotEmpty) {
      return '$name ($companyName)';
    }
    return name;
  }

  String get formattedAddress {
    final parts = <String>[];
    if (address.isNotEmpty) parts.add(address);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    if (zipCode.isNotEmpty) parts.add(zipCode);
    return parts.join(', ');
  }

  /// Creates a copy of this address with the given fields replaced.
  CustomerAddress copyWith({
    String? id,
    int? numericId,
    String? firstName,
    String? lastName,
    String? email,
    String? companyName,
    String? vatId,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? phone,
    bool? isDefault,
    bool? useForShipping,
    String? addressType,
    String? createdAt,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      numericId: numericId ?? this.numericId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      vatId: vatId ?? this.vatId,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      useForShipping: useForShipping ?? this.useForShipping,
      addressType: addressType ?? this.addressType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ─── Order (for Recent Orders section) ───

class RecentOrder {
  final String? id;
  final int? incrementId;
  final String status;
  final String? createdAt;
  final double grandTotal;
  final String? currencyCode;
  final int itemCount;
  final String? baseImageUrl;

  const RecentOrder({
    this.id,
    this.incrementId,
    required this.status,
    this.createdAt,
    required this.grandTotal,
    this.currencyCode,
    this.itemCount = 0,
    this.baseImageUrl,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    // Parse item count from items edges
    int count = 0;
    final items = json['items'];
    if (items is Map && items['edges'] is List) {
      count = (items['edges'] as List).length;
    } else if (items is List) {
      count = items.length;
    }

    // Parse grand total
    double total = 0;
    final rawTotal = json['grandTotal'] ?? json['grand_total'];
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal) ?? 0;
    }

    // Get first item image
    String? imageUrl;
    if (items is Map && items['edges'] is List) {
      final edges = items['edges'] as List;
      if (edges.isNotEmpty) {
        final node = edges.first['node'] ?? edges.first;
        final product = node['product'];
        if (product is Map) {
          imageUrl = product['baseImageUrl']?.toString();
        }
      }
    }

    return RecentOrder(
      id: json['id']?.toString(),
      incrementId: _parseInt(json['incrementId']),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['createdAt']?.toString(),
      grandTotal: total,
      currencyCode: json['orderCurrencyCode']?.toString(),
      itemCount: count,
      baseImageUrl: imageUrl,
    );
  }

  String get orderNumber {
    if (incrementId != null) {
      return '#${incrementId.toString().padLeft(8, '0')}';
    }
    return '#${id ?? '0'}';
  }

  String get formattedTotal {
    final symbol = currencyCode == 'INR' ? '₹' : '\$';
    return '$symbol${grandTotal.toStringAsFixed(2)}';
  }

  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }
}

// ─── Wishlist Item ───

class WishlistItem {
  final String? id; // IRI e.g. /api/shop/wishlists/69
  final int? numericId; // _id numeric (wishlist item)
  final int? productNumericId; // product _id numeric
  final String name;
  final String? sku;
  final String? type;
  final double price;
  final double? specialPrice;
  final String? priceHtml;
  final String? baseImageUrl;
  final String? urlKey;
  final String? createdAt;
  int quantity;

  WishlistItem({
    this.id,
    this.numericId,
    this.productNumericId,
    required this.name,
    this.sku,
    this.type,
    required this.price,
    this.specialPrice,
    this.priceHtml,
    this.baseImageUrl,
    this.urlKey,
    this.createdAt,
    this.quantity = 1,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? json;

    // Parse price from priceHtml or direct fields
    double parsedPrice = 0;
    double? parsedSpecialPrice;
    String? priceHtmlStr;

    final priceHtmlData = product['priceHtml'];
    if (priceHtmlData != null && priceHtmlData is Map<String, dynamic>) {
      priceHtmlStr = priceHtmlData['html']?.toString();
      final regular = priceHtmlData['regular'];
      final special = priceHtmlData['special'];
      if (regular != null) {
        final regStr = regular.toString().replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(regStr) ?? 0;
      }
      if (special != null && special.toString().isNotEmpty) {
        final specStr = special.toString().replaceAll(RegExp(r'[^\d.]'), '');
        parsedSpecialPrice = double.tryParse(specStr);
      }
    }

    // Fallback to direct price fields
    if (parsedPrice == 0) {
      final rawPrice = product['price'] ?? product['minimumPrice'];
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else if (rawPrice is String) {
        final cleaned = rawPrice.replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(cleaned) ?? 0;
      }
    }

    // Parse image URL
    String? imageUrl;
    final cacheBase = product['cacheBaseImage'];
    if (cacheBase != null && cacheBase is Map<String, dynamic>) {
      imageUrl =
          cacheBase['mediumImageUrl']?.toString() ??
          cacheBase['smallImageUrl']?.toString() ??
          cacheBase['originalImageUrl']?.toString();
    }
    if (imageUrl == null || imageUrl.isEmpty) {
      final images = product['images'];
      if (images is List && images.isNotEmpty) {
        imageUrl = images[0]['url']?.toString();
      }
    }
    if (imageUrl == null || imageUrl.isEmpty) {
      imageUrl = product['baseImageUrl']?.toString();
    }

    // Extract product numeric ID from product._id
    int? productNumId;
    if (product['_id'] is int) {
      productNumId = product['_id'] as int;
    } else if (product['_id'] != null) {
      productNumId = int.tryParse(product['_id'].toString());
    }
    // Fallback: parse from product IRI (e.g. /api/products/123)
    if (productNumId == null && product['id'] != null) {
      final parts = product['id'].toString().split('/');
      if (parts.isNotEmpty) {
        productNumId = int.tryParse(parts.last);
      }
    }

    return WishlistItem(
      id: json['id']?.toString(),
      numericId: json['_id'] is int
          ? json['_id'] as int
          : int.tryParse(json['_id']?.toString() ?? ''),
      productNumericId: productNumId,
      name: product['name']?.toString() ?? '',
      sku: product['sku']?.toString(),
      type: product['type']?.toString(),
      price: parsedPrice,
      specialPrice: parsedSpecialPrice,
      priceHtml: priceHtmlStr,
      baseImageUrl: imageUrl,
      urlKey: product['urlKey']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String? get formattedSpecialPrice =>
      specialPrice != null ? '\$${specialPrice!.toStringAsFixed(2)}' : null;
}

// ─── Product Review ───

class ProductReview {
  final String? id;
  final int? productId; // numeric product _id for API calls
  final String name;
  final String title;
  final int rating;
  final String comment;
  final dynamic status; // Can be String ("pending") or int (1/0) from API
  final String? createdAt;
  final String? productName;
  final String? productImageUrl;

  const ProductReview({
    this.id,
    this.productId,
    required this.name,
    required this.title,
    required this.rating,
    required this.comment,
    this.status = 'pending',
    this.createdAt,
    this.productName,
    this.productImageUrl,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    // Extract product info if nested product object exists.
    String? pName;
    String? pImage;
    int? pId;
    final product = json['product'];
    if (product is Map<String, dynamic>) {
      // Product name & id
      pName = product['name']?.toString();
      pId = _parseInt(product['_id']);

      // 1. Prefer baseImageUrl (full URL from API)
      pImage = product['baseImageUrl']?.toString();

      // 2. Fallback: images cursor connection (edges/node/path)
      if (pImage == null || pImage.isEmpty) {
        final images = product['images'];
        if (images is Map<String, dynamic>) {
          final edges = images['edges'] as List?;
          if (edges != null && edges.isNotEmpty) {
            final path = (edges.first['node'] as Map?)?['path']?.toString();
            if (path != null && path.isNotEmpty) {
              pImage = path.startsWith('http')
                  ? path
                  : 'https://nextjs.bagisto.com/storage/$path';
            }
          }
        } else if (images is List && images.isNotEmpty) {
          // Legacy flat list format
          pImage = images.first['url']?.toString() ??
              images.first['path']?.toString();
        }
      }

      // Ensure relative paths get full URL
      if (pImage != null && pImage.startsWith('/')) {
        pImage = 'https://nextjs.bagisto.com$pImage';
      }
    }

    return ProductReview(
      id: json['id']?.toString(),
      productId: pId,
      name: json['name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      rating: _parseInt(json['rating']) ?? 0,
      comment: json['comment']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['createdAt']?.toString(),
      productName: pName,
      productImageUrl: pImage,
    );
  }

  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }

  String get ratingLabel {
    if (rating >= 4) return 'Excellent';
    if (rating >= 3) return 'Average';
    if (rating >= 2) return 'Below Average';
    return 'Poor';
  }

  /// Convert status to String, handling both string and numeric values
  String get _statusString {
    if (status is String) return status.toString();
    if (status is int) {
      // Handle numeric status codes: 1=approved, 0=pending, etc.
      return status == 1 ? 'approved' : 'pending';
    }
    return 'pending';
  }

  String get statusLabel {
    final statusStr = _statusString.toLowerCase();
    switch (statusStr) {
      case 'approved':
      case '1':
        return 'Approved';
      case 'pending':
      case '0':
        return 'Pending Review';
      case 'rejected':
      case '-1':
        return 'Rejected';
      case 'published':
        return 'Published';
      default:
        return statusStr.isNotEmpty
            ? statusStr[0].toUpperCase() + statusStr.substring(1)
            : 'Pending';
    }
  }

  bool get isApproved {
    final statusStr = _statusString.toLowerCase();
    return statusStr == 'approved' || statusStr == '1';
  }

  bool get isPending {
    final statusStr = _statusString.toLowerCase();
    return statusStr == 'pending' || statusStr == '0';
  }
}

// ─── Customer Order (full order model) ───

class CustomerOrder {
  final String? id;
  final int? numericId;
  final String? incrementId;
  final String status;
  final String? channelName;
  final String? customerEmail;
  final String? customerFirstName;
  final String? customerLastName;
  final int totalItemCount;
  final int totalQtyOrdered;
  final double grandTotal;
  final double subTotal;
  final double? taxAmount;
  final double? discountAmount;
  final double? shippingAmount;
  final String? shippingTitle;
  final String? couponCode;
  final String? orderCurrencyCode;
  final String? baseCurrencyCode;
  final String? createdAt;
  final String? updatedAt;
  final String? baseImageUrl;

  const CustomerOrder({
    this.id,
    this.numericId,
    this.incrementId,
    required this.status,
    this.channelName,
    this.customerEmail,
    this.customerFirstName,
    this.customerLastName,
    this.totalItemCount = 0,
    this.totalQtyOrdered = 0,
    required this.grandTotal,
    this.subTotal = 0,
    this.taxAmount,
    this.discountAmount,
    this.shippingAmount,
    this.shippingTitle,
    this.couponCode,
    this.orderCurrencyCode,
    this.baseCurrencyCode,
    this.createdAt,
    this.updatedAt,
    this.baseImageUrl,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    // Parse grand total
    double total = 0;
    final rawTotal = json['grandTotal'] ?? json['grand_total'];
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal) ?? 0;
    }

    // Parse sub total
    double sub = 0;
    final rawSub = json['subTotal'] ?? json['sub_total'];
    if (rawSub is num) {
      sub = rawSub.toDouble();
    } else if (rawSub is String) {
      sub = double.tryParse(rawSub) ?? 0;
    }

    // Get first item image if available
    String? imageUrl;
    final items = json['items'];
    if (items is Map && items['edges'] is List) {
      final edges = items['edges'] as List;
      if (edges.isNotEmpty) {
        final node = edges.first['node'] ?? edges.first;
        final product = node['product'];
        if (product is Map) {
          imageUrl = product['baseImageUrl']?.toString();
        }
      }
    }

    return CustomerOrder(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      incrementId: json['incrementId']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      channelName: json['channelName']?.toString(),
      customerEmail: json['customerEmail']?.toString(),
      customerFirstName: json['customerFirstName']?.toString(),
      customerLastName: json['customerLastName']?.toString(),
      totalItemCount: _parseInt(json['totalItemCount']) ?? 0,
      totalQtyOrdered: _parseInt(json['totalQtyOrdered']) ?? 0,
      grandTotal: total,
      subTotal: sub,
      taxAmount: _parseDouble(json['taxAmount']),
      discountAmount: _parseDouble(json['discountAmount']),
      shippingAmount: _parseDouble(json['shippingAmount']),
      shippingTitle: json['shippingTitle']?.toString(),
      couponCode: json['couponCode']?.toString(),
      orderCurrencyCode: json['orderCurrencyCode']?.toString(),
      baseCurrencyCode: json['baseCurrencyCode']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      baseImageUrl: imageUrl,
    );
  }

  /// Order number formatted as #00003845
  String get orderNumber {
    if (incrementId != null && incrementId!.isNotEmpty) {
      return '#$incrementId';
    }
    if (numericId != null) {
      return '#${numericId.toString().padLeft(8, '0')}';
    }
    return '#${id ?? '0'}';
  }

  /// Formatted grand total with currency symbol
  String get formattedTotal {
    final code = orderCurrencyCode ?? baseCurrencyCode ?? 'USD';
    final symbol = code == 'INR' ? '\u20B9' : '\$';
    return '$symbol${grandTotal.toStringAsFixed(2)}';
  }

  /// Formatted date: "8 Oct 2025"
  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }

  /// Status display label (capitalized)
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'canceled':
      case 'cancelled':
        return 'Cancel';
      case 'closed':
        return 'Closed';
      case 'fraud':
        return 'Fraud';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }
}

// ─── Downloadable Product ───

class DownloadableProduct {
  final int? id;
  final String? productName;
  final String name;
  final String fileName;
  final String? type;
  final int? downloadBought;
  final int? downloadUsed;
  final int? downloadCanceled;
  final String? status;
  final int? remainingDownloads;
  final OrderInfo? order;
  final String? createdAt;
  final String? updatedAt;

  const DownloadableProduct({
    this.id,
    this.productName,
    required this.name,
    required this.fileName,
    this.type,
    this.downloadBought,
    this.downloadUsed,
    this.downloadCanceled,
    this.status,
    this.remainingDownloads,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory DownloadableProduct.fromJson(Map<String, dynamic> json) {
    // Parse order info if available
    OrderInfo? orderInfo;
    final orderData = json['order'];
    if (orderData is Map<String, dynamic>) {
      orderInfo = OrderInfo.fromJson(orderData);
    }

    return DownloadableProduct(
      id: _parseInt(json['_id']),
      productName: json['productName']?.toString(),
      name: json['name']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      type: json['type']?.toString(),
      downloadBought: _parseInt(json['downloadBought']),
      downloadUsed: _parseInt(json['downloadUsed']),
      downloadCanceled: _parseInt(json['downloadCanceled']),
      status: json['status']?.toString(),
      remainingDownloads: _parseInt(json['remainingDownloads']),
      order: orderInfo,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  /// Format remaining downloads
  String get remainingDownloadsLabel {
    if (remainingDownloads == null || remainingDownloads! < 0) {
      return 'Unlimited';
    }
    return remainingDownloads.toString();
  }

  /// Check if downloads are still available
  bool get canDownload {
    if (remainingDownloads == null) return true;
    if (remainingDownloads! < 0) return true;
    return remainingDownloads! > 0;
  }

  /// Formatted date: "8 Oct 2025"
  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }

  /// Status display label
  String get statusLabel {
    if (status == null) return 'Pending';
    switch (status!.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'pending':
        return 'Pending';
      case 'expired':
        return 'Expired';
      case 'inactive':
        return 'Inactive';
      default:
        return status![0].toUpperCase() + status!.substring(1);
    }
  }
}

/// Order information for downloadable product
class OrderInfo {
  final int? id;
  final String? incrementId;
  final String? status;

  const OrderInfo({
    this.id,
    this.incrementId,
    this.status,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      id: _parseInt(json['_id']),
      incrementId: json['incrementId']?.toString(),
      status: json['status']?.toString(),
    );
  }

  /// Formatted order number
  String get orderNumber {
    if (incrementId != null && incrementId!.isNotEmpty) {
      return '#$incrementId';
    }
    if (id != null) {
      return '#${id.toString().padLeft(8, '0')}';
    }
    return '#0';
  }
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

// ─── Compare Item ───

class CompareItem {
  final String id; // IRI e.g. /api/shop/compare-items/606
  final int numericId; // _id
  final String productName;
  final String? sku;
  final String? type;
  final double price;
  final double? specialPrice;
  final String? baseImageUrl;
  final String? description;
  final String? shortDescription;
  final String? urlKey;
  final double? averageRating;
  final int? reviewCount;
  final String? createdAt;

  /// Arbitrary product attributes for the comparison table.
  /// Keys = attribute label (e.g. "Activity", "Seller").
  final Map<String, String> attributes;

  const CompareItem({
    required this.id,
    required this.numericId,
    required this.productName,
    this.sku,
    this.type,
    required this.price,
    this.specialPrice,
    this.baseImageUrl,
    this.description,
    this.shortDescription,
    this.urlKey,
    this.averageRating,
    this.reviewCount,
    this.createdAt,
    this.attributes = const {},
  });

  factory CompareItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? json;

    // ── Price parsing ──
    double parsedPrice = 0;
    double? parsedSpecialPrice;

    final priceHtmlData = product['priceHtml'];
    if (priceHtmlData != null && priceHtmlData is Map<String, dynamic>) {
      final regular = priceHtmlData['regular'];
      final special = priceHtmlData['special'];
      if (regular != null) {
        final regStr = regular.toString().replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(regStr) ?? 0;
      }
      if (special != null && special.toString().isNotEmpty) {
        final specStr = special.toString().replaceAll(RegExp(r'[^\d.]'), '');
        parsedSpecialPrice = double.tryParse(specStr);
      }
    }

    // Fallback
    if (parsedPrice == 0) {
      final rawPrice = product['price'] ?? product['minimumPrice'];
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else if (rawPrice is String) {
        final cleaned = rawPrice.replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(cleaned) ?? 0;
      }
    }

    // ── Image parsing ──
    String? imageUrl;
    final cacheBase = product['cacheBaseImage'];
    if (cacheBase != null && cacheBase is Map<String, dynamic>) {
      imageUrl =
          cacheBase['mediumImageUrl']?.toString() ??
          cacheBase['smallImageUrl']?.toString() ??
          cacheBase['originalImageUrl']?.toString();
    }
    if (imageUrl == null || imageUrl.isEmpty) {
      final images = product['images'];
      if (images is List && images.isNotEmpty) {
        imageUrl = images[0]['url']?.toString();
      }
    }
    if (imageUrl == null || imageUrl.isEmpty) {
      imageUrl = product['baseImageUrl']?.toString();
    }

    // ── Average rating ──
    double? avgRating;
    final rawRating = product['averageRating'] ?? product['rating'];
    if (rawRating is num) {
      avgRating = rawRating.toDouble();
    } else if (rawRating is String) {
      avgRating = double.tryParse(rawRating);
    }

    // ── Review count ──
    int? reviewCnt;
    final rawReviews = product['reviewCount'] ?? product['totalReviews'];
    if (rawReviews != null) {
      reviewCnt = _parseInt(rawReviews);
    }

    // ── Attributes (custom product attributes) ──
    final attrs = <String, String>{};
    final attrList = product['additionalData'] ?? product['attributes'];
    if (attrList is List) {
      for (final attr in attrList) {
        if (attr is Map<String, dynamic>) {
          final label = attr['label']?.toString() ?? attr['code']?.toString();
          final value = attr['value']?.toString();
          if (label != null && value != null) {
            attrs[label] = value;
          }
        }
      }
    }

    return CompareItem(
      id: json['id']?.toString() ?? '',
      numericId: json['_id'] is int
          ? json['_id'] as int
          : int.tryParse(json['_id']?.toString() ?? '0') ?? 0,
      productName: product['name']?.toString() ?? '',
      sku: product['sku']?.toString(),
      type: product['type']?.toString(),
      price: parsedPrice,
      specialPrice: parsedSpecialPrice,
      baseImageUrl: imageUrl,
      description: product['description']?.toString(),
      shortDescription: product['shortDescription']?.toString(),
      urlKey: product['urlKey']?.toString(),
      averageRating: avgRating,
      reviewCount: reviewCnt,
      createdAt: json['createdAt']?.toString(),
      attributes: attrs,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String? get formattedSpecialPrice =>
      specialPrice != null ? '\$${specialPrice!.toStringAsFixed(2)}' : null;
}

// ─── Helpers ───

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value == 'true' || value == '1';
  return false;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

// ─── Country (for address form dropdowns) ───

class Country {
  final String id;

  /// Numeric ID — required by the `countryStates(countryId: Int!)` query.
  final int numericId;
  final String code;
  final String name;

  const Country({
    required this.id,
    required this.numericId,
    required this.code,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id'] ?? json['numericId']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => name;
}

// ─── CountryState (provinces / states within a country) ───

class CountryState {
  final String id;
  final String code;
  final String name;
  final String? countryId;
  final String? countryCode;

  const CountryState({
    required this.id,
    required this.code,
    required this.name,
    this.countryId,
    this.countryCode,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['defaultName']?.toString() ?? json['name']?.toString() ?? '',
      countryId: json['countryId']?.toString(),
      countryCode: json['countryCode']?.toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryState &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => name;
}

// ─── Order Detail (single order with items, addresses, payment etc.) ───

/// A single item within an order.
class OrderItem {
  final String? id;
  final int? numericId;
  final String name;
  final String? sku;
  final String? type;
  final int qtyOrdered;
  final int qtyShipped;
  final int qtyInvoiced;
  final int qtyCanceled;
  final int qtyRefunded;
  final double price;
  final double total;
  final double? totalInvoiced;
  final double? amountRefunded;
  final double? discountAmount;
  final double? discountPercent;
  final double? taxAmount;
  final double? taxPercent;
  final double? weight;
  final String? productImageUrl;
  final String? productName;
  final String? productUrlKey;
  final int? productId;
  final Map<String, dynamic>? additional;

  const OrderItem({
    this.id,
    this.numericId,
    required this.name,
    this.sku,
    this.type,
    this.qtyOrdered = 0,
    this.qtyShipped = 0,
    this.qtyInvoiced = 0,
    this.qtyCanceled = 0,
    this.qtyRefunded = 0,
    this.price = 0,
    this.total = 0,
    this.totalInvoiced,
    this.amountRefunded,
    this.discountAmount,
    this.discountPercent,
    this.taxAmount,
    this.taxPercent,
    this.weight,
    this.productImageUrl,
    this.productName,
    this.productUrlKey,
    this.productId,
    this.additional,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Extract product image
    String? imageUrl;
    final product = json['product'];
    if (product is Map<String, dynamic>) {
      final cache = product['cacheBaseImage'];
      if (cache is Map) {
        var rawImageUrl =
            cache['smallImageUrl']?.toString() ??
            cache['mediumImageUrl']?.toString() ??
            cache['originalImageUrl']?.toString();

        if (rawImageUrl != null && rawImageUrl.startsWith('/')) {
          const base = "https://nextjs.bagisto.com";
          imageUrl = "$base$rawImageUrl";
        } else {
          imageUrl = rawImageUrl;
        }
      }
      if (imageUrl == null) {
        final images = product['images'];
        if (images is List && images.isNotEmpty) {
          imageUrl = images.first['url']?.toString();
        }
      }
    }

    // Parse additional (might be JSON string or map)
    Map<String, dynamic>? additionalMap;
    final rawAdditional = json['additional'];
    if (rawAdditional is Map<String, dynamic>) {
      additionalMap = rawAdditional;
    }

    return OrderItem(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      type: json['type']?.toString(),
      qtyOrdered: _parseInt(json['qtyOrdered']) ?? 0,
      qtyShipped: _parseInt(json['qtyShipped']) ?? 0,
      qtyInvoiced: _parseInt(json['qtyInvoiced']) ?? 0,
      qtyCanceled: _parseInt(json['qtyCanceled']) ?? 0,
      qtyRefunded: _parseInt(json['qtyRefunded']) ?? 0,
      price: _parseDouble(json['price']) ?? 0,
      total: _parseDouble(json['total']) ?? 0,
      totalInvoiced: _parseDouble(json['totalInvoiced']),
      amountRefunded: _parseDouble(json['amountRefunded']),
      discountAmount: _parseDouble(json['discountAmount']),
      discountPercent: _parseDouble(json['discountPercent']),
      taxAmount: _parseDouble(json['taxAmount']),
      taxPercent: _parseDouble(json['taxPercent']),
      weight: _parseDouble(json['weight']),
      productImageUrl: imageUrl,
      productName: product is Map ? product['name']?.toString() : null,
      productUrlKey: product is Map ? product['urlKey']?.toString() : null,
      productId: product is Map ? _parseInt(product['_id']) : null,
      additional: additionalMap,
    );
  }
}

/// Address within an order (billing or shipping).
class OrderAddress {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postcode;
  final String? phone;
  final String? email;

  const OrderAddress({
    this.id,
    this.firstName,
    this.lastName,
    this.companyName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.phone,
    this.email,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      id: json['id']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      companyName: json['companyName']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      postcode: json['postcode']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }

  /// Full name: "John Doe"
  String get fullName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isNotEmpty ? parts.join(' ') : 'N/A';
  }

  /// Full formatted address multiline
  String get formattedAddress {
    final lines = <String>[];
    if (address != null && address!.isNotEmpty) lines.add(address!);
    final cityStateLine = <String>[];
    if (city != null && city!.isNotEmpty) cityStateLine.add(city!);
    if (state != null && state!.isNotEmpty) cityStateLine.add(state!);
    if (postcode != null && postcode!.isNotEmpty) cityStateLine.add(postcode!);
    if (cityStateLine.isNotEmpty) lines.add(cityStateLine.join(', '));
    if (country != null && country!.isNotEmpty) lines.add(country!);
    return lines.join('\n');
  }
}

/// Payment info within an order.
class OrderPayment {
  final String? id;
  final String? method;
  final String? methodTitle;

  const OrderPayment({this.id, this.method, this.methodTitle});

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id']?.toString(),
      method: json['method']?.toString(),
      methodTitle: json['methodTitle']?.toString(),
    );
  }
}

/// Invoice record within an order.
class OrderInvoice {
  final String? id;
  final int? numericId;
  final String? incrementId;
  final String? state;
  final double grandTotal;
  final double subTotal;
  final double? taxAmount;
  final double? shippingAmount;
  final double? discountAmount;
  final String? createdAt;
  final String? downloadUrl;
  final List<OrderInvoiceItem> items;

  const OrderInvoice({
    this.id,
    this.numericId,
    this.incrementId,
    this.state,
    this.grandTotal = 0,
    this.subTotal = 0,
    this.taxAmount,
    this.shippingAmount,
    this.discountAmount,
    this.createdAt,
    this.downloadUrl,
    this.items = const [],
  });

  factory OrderInvoice.fromJson(Map<String, dynamic> json) {
    List<OrderInvoiceItem> items = [];
    final rawItems = json['items'];
    if (rawItems is Map && rawItems['edges'] is List) {
      items = (rawItems['edges'] as List)
          .map(
            (e) => OrderInvoiceItem.fromJson(
              (e['node'] ?? e) as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return OrderInvoice(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      incrementId: json['incrementId']?.toString(),
      state: json['state']?.toString(),
      grandTotal: _parseDouble(json['grandTotal']) ?? 0,
      subTotal: _parseDouble(json['subTotal']) ?? 0,
      taxAmount: _parseDouble(json['taxAmount']),
      shippingAmount: _parseDouble(json['shippingAmount']),
      discountAmount: _parseDouble(json['discountAmount']),
      createdAt: json['createdAt']?.toString(),
      downloadUrl: json['downloadUrl']?.toString(),
      items: items,
    );
  }

  /// Invoice number formatted
  String get invoiceNumber {
    if (incrementId != null && incrementId!.isNotEmpty) return '#$incrementId';
    if (numericId != null) return '#$numericId';
    return '#${id ?? '0'}';
  }

  /// Formatted date: "8 Oct 2025"
  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }
}

/// Individual item within an invoice.
class OrderInvoiceItem {
  final String? id;
  final int? numericId;
  final String name;
  final String? sku;
  final int qty;
  final double price;
  final double total;
  final double? basePrice;
  final String? description;
  final double? baseTotal;
  final double? taxAmount;
  final double? baseTaxAmount;
  final double? discountPercent;
  final double? discountAmount;
  final double? baseDiscountAmount;
  final double? priceInclTax;
  final double? basePriceInclTax;
  final double? totalInclTax;
  final double? baseTotalInclTax;
  final int? productId;
  final String? productType;
  final int? orderItemId;
  final int? invoiceId;
  final String? parentId;
  final String? createdAt;
  final String? updatedAt;

  const OrderInvoiceItem({
    this.id,
    this.numericId,
    required this.name,
    this.sku,
    this.qty = 0,
    this.price = 0,
    this.total = 0,
    this.basePrice,
    this.description,
    this.baseTotal,
    this.taxAmount,
    this.baseTaxAmount,
    this.discountPercent,
    this.discountAmount,
    this.baseDiscountAmount,
    this.priceInclTax,
    this.basePriceInclTax,
    this.totalInclTax,
    this.baseTotalInclTax,
    this.productId,
    this.productType,
    this.orderItemId,
    this.invoiceId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderInvoiceItem.fromJson(Map<String, dynamic> json) {
    return OrderInvoiceItem(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      qty: _parseInt(json['qty']) ?? 0,
      price: _parseDouble(json['price']) ?? 0,
      total: _parseDouble(json['total']) ?? 0,
      basePrice: _parseDouble(json['basePrice']),
      description: json['description']?.toString(),
      baseTotal: _parseDouble(json['baseTotal']),
      taxAmount: _parseDouble(json['taxAmount']),
      baseTaxAmount: _parseDouble(json['baseTaxAmount']),
      discountPercent: _parseDouble(json['discountPercent']),
      discountAmount: _parseDouble(json['discountAmount']),
      baseDiscountAmount: _parseDouble(json['baseDiscountAmount']),
      priceInclTax: _parseDouble(json['priceInclTax']),
      basePriceInclTax: _parseDouble(json['basePriceInclTax']),
      totalInclTax: _parseDouble(json['totalInclTax']),
      baseTotalInclTax: _parseDouble(json['baseTotalInclTax']),
      productId: _parseInt(json['productId']),
      productType: json['productType']?.toString(),
      orderItemId: _parseInt(json['orderItemId']),
      invoiceId: _parseInt(json['invoiceId']),
      parentId: json['parentId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

/// Shipment record within an order.
class OrderShipment {
  final String? id;
  final int? numericId;
  final String? status;
  final int totalQty;
  final double? totalWeight;
  final String? carrierCode;
  final String? carrierTitle;
  final String? trackNumber;
  final String? shippingNumber;
  final String? createdAt;
  final List<OrderShipmentItem> items;

  const OrderShipment({
    this.id,
    this.numericId,
    this.status,
    this.totalQty = 0,
    this.totalWeight,
    this.carrierCode,
    this.carrierTitle,
    this.trackNumber,
    this.shippingNumber,
    this.createdAt,
    this.items = const [],
  });

  factory OrderShipment.fromJson(Map<String, dynamic> json) {
    List<OrderShipmentItem> items = [];
    final rawItems = json['items'];
    if (rawItems is Map && rawItems['edges'] is List) {
      items = (rawItems['edges'] as List)
          .map(
            (e) => OrderShipmentItem.fromJson(
              (e['node'] ?? e) as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return OrderShipment(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      status: json['status']?.toString(),
      totalQty: _parseInt(json['totalQty']) ?? 0,
      totalWeight: _parseDouble(json['totalWeight']),
      carrierCode: json['carrierCode']?.toString(),
      carrierTitle: json['carrierTitle']?.toString(),
      trackNumber: json['trackNumber']?.toString(),
      shippingNumber: json['shippingNumber']?.toString(),
      createdAt: json['createdAt']?.toString(),
      items: items,
    );
  }

  /// Formatted shipment number like "#000000003"
  String get shipmentNumber {
    if (numericId != null) {
      return '#${numericId.toString().padLeft(9, '0')}';
    }
    return id ?? '';
  }

  /// Formatted date: "8 Oct 2025"
  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }
}

/// Individual item within a shipment.
class OrderShipmentItem {
  final String? id;
  final String name;
  final String? sku;
  final int qty;
  final double? weight;

  const OrderShipmentItem({
    this.id,
    required this.name,
    this.sku,
    this.qty = 0,
    this.weight,
  });

  factory OrderShipmentItem.fromJson(Map<String, dynamic> json) {
    return OrderShipmentItem(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      qty: _parseInt(json['qty']) ?? 0,
      weight: _parseDouble(json['weight']),
    );
  }
}

/// Full order detail model (single order with all nested data).
class OrderDetail {
  final String? id;
  final int? numericId;
  final String? incrementId;
  final String status;
  final String? channelName;
  final String? customerEmail;
  final String? customerFirstName;
  final String? customerLastName;
  final int totalItemCount;
  final int totalQtyOrdered;
  final double grandTotal;
  final double? baseGrandTotal;
  final double? grandTotalInvoiced;
  final double? grandTotalRefunded;
  final double subTotal;
  final double? taxAmount;
  final double? discountAmount;
  final double? shippingAmount;
  final String? shippingTitle;
  final String? shippingMethod;
  final String? couponCode;
  final String? orderCurrencyCode;
  final String? baseCurrencyCode;
  final String? createdAt;
  final String? updatedAt;
  final List<OrderItem> items;
  final OrderAddress? billingAddress;
  final OrderAddress? shippingAddress;
  final OrderPayment? payment;
  final List<OrderInvoice> invoices;
  final List<OrderShipment> shipments;

  const OrderDetail({
    this.id,
    this.numericId,
    this.incrementId,
    required this.status,
    this.channelName,
    this.customerEmail,
    this.customerFirstName,
    this.customerLastName,
    this.totalItemCount = 0,
    this.totalQtyOrdered = 0,
    required this.grandTotal,
    this.baseGrandTotal,
    this.grandTotalInvoiced,
    this.grandTotalRefunded,
    this.subTotal = 0,
    this.taxAmount,
    this.discountAmount,
    this.shippingAmount,
    this.shippingTitle,
    this.shippingMethod,
    this.couponCode,
    this.orderCurrencyCode,
    this.baseCurrencyCode,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
    this.billingAddress,
    this.shippingAddress,
    this.payment,
    this.invoices = const [],
    this.shipments = const [],
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    // Parse grand total
    double total = 0;
    final rawTotal = json['grandTotal'];
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal) ?? 0;
    }

    // Parse sub total
    double sub = 0;
    final rawSub = json['subTotal'];
    if (rawSub is num) {
      sub = rawSub.toDouble();
    } else if (rawSub is String) {
      sub = double.tryParse(rawSub) ?? 0;
    }

    // Parse items from edges
    List<OrderItem> items = [];
    final rawItems = json['items'];
    if (rawItems is Map && rawItems['edges'] is List) {
      items = (rawItems['edges'] as List)
          .map(
            (e) => OrderItem.fromJson((e['node'] ?? e) as Map<String, dynamic>),
          )
          .toList();
    } else if (rawItems is List) {
      items = rawItems
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse addresses from edges
    OrderAddress? billing;
    OrderAddress? shipping;
    final rawAddresses = json['addresses'];
    if (rawAddresses is Map && rawAddresses['edges'] is List) {
      final addressEdges = rawAddresses['edges'] as List;
      for (var edge in addressEdges) {
        final node = (edge['node'] ?? edge) as Map<String, dynamic>;
        final type = node['addressType']?.toString().toLowerCase() ?? '';
        final addr = OrderAddress.fromJson(node);

        if (type.contains('billing')) {
          billing = addr;
        } else if (type.contains('shipping')) {
          shipping = addr;
        }
      }
    } else if (json['billingAddress'] is Map<String, dynamic>) {
      // Fallback for flat structure if needed
      billing = OrderAddress.fromJson(json['billingAddress']);
      if (json['shippingAddress'] is Map<String, dynamic>) {
        shipping = OrderAddress.fromJson(json['shippingAddress']);
      }
    }

    // Parse payment
    OrderPayment? payment;
    if (json['payment'] is Map<String, dynamic>) {
      payment = OrderPayment.fromJson(json['payment']);
    }

    // Parse invoices
    List<OrderInvoice> invoices = [];
    final rawInvoices = json['invoices'];
    if (rawInvoices is Map && rawInvoices['edges'] is List) {
      invoices = (rawInvoices['edges'] as List)
          .map(
            (e) =>
                OrderInvoice.fromJson((e['node'] ?? e) as Map<String, dynamic>),
          )
          .toList();
    }

    // Parse shipments
    List<OrderShipment> shipments = [];
    final rawShipments = json['shipments'];
    if (rawShipments is Map && rawShipments['edges'] is List) {
      shipments = (rawShipments['edges'] as List)
          .map(
            (e) => OrderShipment.fromJson(
              (e['node'] ?? e) as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return OrderDetail(
      id: json['id']?.toString(),
      numericId: _parseInt(json['_id']),
      incrementId: json['incrementId']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      channelName: json['channelName']?.toString(),
      customerEmail: json['customerEmail']?.toString(),
      customerFirstName: json['customerFirstName']?.toString(),
      customerLastName: json['customerLastName']?.toString(),
      totalItemCount: _parseInt(json['totalItemCount']) ?? 0,
      totalQtyOrdered: _parseInt(json['totalQtyOrdered']) ?? 0,
      grandTotal: total,
      baseGrandTotal: _parseDouble(json['baseGrandTotal']),
      grandTotalInvoiced: _parseDouble(json['grandTotalInvoiced']),
      grandTotalRefunded: _parseDouble(json['grandTotalRefunded']),
      subTotal: sub,
      taxAmount: _parseDouble(json['taxAmount']),
      discountAmount: _parseDouble(json['discountAmount']),
      shippingAmount: _parseDouble(json['shippingAmount']),
      shippingTitle: json['shippingTitle']?.toString(),
      shippingMethod: json['shippingMethod']?.toString(),
      couponCode: json['couponCode']?.toString(),
      orderCurrencyCode: json['orderCurrencyCode']?.toString(),
      baseCurrencyCode: json['baseCurrencyCode']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      items: items,
      billingAddress: billing,
      shippingAddress: shipping,
      payment: payment,
      invoices: invoices,
      shipments: shipments,
    );
  }

  /// Order number formatted as #00003845
  String get orderNumber {
    if (incrementId != null && incrementId!.isNotEmpty) return '#$incrementId';
    if (numericId != null) return '#${numericId.toString().padLeft(8, '0')}';
    return '#${id ?? '0'}';
  }

  /// Currency symbol
  String get currencySymbol {
    final code = orderCurrencyCode ?? baseCurrencyCode ?? 'USD';
    return code == 'INR' ? '\u20B9' : '\$';
  }

  /// Format a monetary amount with currency
  String formatAmount(double? amount) {
    if (amount == null) return '${currencySymbol}0.00';
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  /// Formatted grand total
  String get formattedTotal => formatAmount(grandTotal);

  /// Formatted date: "8 Oct 2025"
  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
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
      return createdAt ?? '';
    }
  }

  /// Status display label (capitalized)
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'canceled':
      case 'cancelled':
        return 'Cancel';
      case 'closed':
        return 'Closed';
      case 'fraud':
        return 'Fraud';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  /// Total paid (grandTotalInvoiced)
  double get totalPaid => grandTotalInvoiced ?? 0;

  /// Total refunded
  double get totalRefunded => grandTotalRefunded ?? 0;

  /// Total due = grandTotal - totalPaid
  double get totalDue {
    final due = grandTotal - totalPaid;
    return due < 0 ? 0 : due;
  }
}
// ─── CMS Pages ───

/// CMS Page Translation (language-specific content)
class CmsPageTranslation {
  final String? id;
  final int? numericId;
  final String pageTitle;
  final String urlKey;
  final String htmlContent;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final String locale;

  const CmsPageTranslation({
    this.id,
    this.numericId,
    required this.pageTitle,
    required this.urlKey,
    required this.htmlContent,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    required this.locale,
  });

  factory CmsPageTranslation.fromJson(Map<String, dynamic> json) {
    return CmsPageTranslation(
      id: json['id']?.toString(),
      numericId: json['_id'] is int ? json['_id'] : int.tryParse(json['_id']?.toString() ?? ''),
      pageTitle: json['pageTitle']?.toString() ?? '',
      urlKey: json['urlKey']?.toString() ?? '',
      htmlContent: json['htmlContent']?.toString() ?? '',
      metaTitle: json['metaTitle']?.toString(),
      metaDescription: json['metaDescription']?.toString(),
      metaKeywords: json['metaKeywords']?.toString(),
      locale: json['locale']?.toString() ?? 'en',
    );
  }
}

/// CMS Page (contains translations for different languages)
class CmsPage {
  final String? id;
  final int? numericId;
  final String? layout;
  final String? createdAt;
  final String? updatedAt;
  final CmsPageTranslation translation;

  const CmsPage({
    this.id,
    this.numericId,
    this.layout,
    this.createdAt,
    this.updatedAt,
    required this.translation,
  });

  /// Display title from translation
  String get displayTitle => translation.pageTitle;

  /// Page ID for navigation
  String get pageId => numericId?.toString() ?? id ?? '';

  factory CmsPage.fromJson(Map<String, dynamic> json) {
    // Handle translation as either a single object or within edges
    Map<String, dynamic> translationData = {};
    
    if (json['translation'] is Map) {
      translationData = json['translation'];
    }

    return CmsPage(
      id: json['id']?.toString(),
      numericId: json['_id'] is int ? json['_id'] : int.tryParse(json['_id']?.toString() ?? ''),
      layout: json['layout']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      translation: CmsPageTranslation.fromJson(translationData),
    );
  }

  /// Creates a copy with replaced fields
  CmsPage copyWith({
    String? id,
    int? numericId,
    String? layout,
    String? createdAt,
    String? updatedAt,
    CmsPageTranslation? translation,
  }) {
    return CmsPage(
      id: id ?? this.id,
      numericId: numericId ?? this.numericId,
      layout: layout ?? this.layout,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translation: translation ?? this.translation,
    );
  }
}

// ─── Contact Us ───

/// Contact Us submission model
class ContactUsSubmission {
  final String name;
  final String email;
  final String contact;
  final String message;

  const ContactUsSubmission({
    required this.name,
    required this.email,
    required this.contact,
    required this.message,
  });

  /// Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'message': message,
    };
  }
}

/// Contact Us response from API
class ContactUsResponse {
  final bool success;
  final String message;

  const ContactUsResponse({
    required this.success,
    required this.message,
  });

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? 'Unknown response',
    );
  }
}
