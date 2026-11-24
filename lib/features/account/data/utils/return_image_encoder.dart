import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class ReturnImageEncodingException implements Exception {
  final String message;

  const ReturnImageEncodingException(this.message);

  @override
  String toString() => message;
}

/// Encodes evidence photos using the data URI format expected by
/// `createCustomerReturn.images`.
class ReturnImageEncoder {
  ReturnImageEncoder._();

  static const int maxFileBytes = 5 * 1024 * 1024;

  static const Map<String, String> _mimeByExtension = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'gif': 'image/gif',
    'heic': 'image/heic',
    'heif': 'image/heif',
  };

  static Future<List<String>> encode(List<XFile> images) async {
    final dataUris = <String>[];

    for (final image in images) {
      if (await image.length() > maxFileBytes) {
        throw const ReturnImageEncodingException('image_too_large');
      }

      final mimeType = _mimeType(image);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        throw const ReturnImageEncodingException('unsupported_image');
      }

      final bytes = await image.readAsBytes();
      dataUris.add('data:$mimeType;base64,${base64Encode(bytes)}');
    }

    return dataUris;
  }

  static String? _mimeType(XFile image) {
    final pickedMimeType = image.mimeType;
    if (pickedMimeType != null && pickedMimeType.startsWith('image/')) {
      return pickedMimeType;
    }

    final dot = image.path.lastIndexOf('.');
    if (dot < 0 || dot == image.path.length - 1) return null;
    return _mimeByExtension[image.path.substring(dot + 1).toLowerCase()];
  }
}
