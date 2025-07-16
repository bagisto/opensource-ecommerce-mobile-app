/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  String toCssHex() {
    final r = red.toRadixString(16).padLeft(2, '0');
    final g = green.toRadixString(16).padLeft(2, '0');
    final b = blue.toRadixString(16).padLeft(2, '0');
    final a = alpha.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b$a';
  }
}

//todo there is some problem here which is not letting attributes to be fetched from additional
// Returns the attribute list or map from additional
dynamic getAttributesValueFromAdditional(dynamic additional) {
  if (additional == null) return null;

  dynamic attributes;

  if (additional is List) {
    for (var item in additional) {
      if (item is Map && item.containsKey('attributes')) {
        attributes = item['attributes'];
        break;
      }
    }
  } else if (additional is Map) {
    attributes = additional['attributes'];
  }

  if (attributes != null && (attributes is List || attributes is Map)) {
    return attributes;
  }

  return null;
}

// Returns a specific key's value from an attribute at given index
String? getAttributeKeyValueFromAdditional(
  dynamic additional,
  int attributeIndex,
  String key,
) {
  try {
    final attributes = getAttributesValueFromAdditional(additional);
    if (attributes == null) return null;

    if (attributes is List && attributes.length > attributeIndex) {
      final attribute = attributes[attributeIndex];
      if (attribute is Map && attribute.containsKey(key)) {
        return attribute[key]?.toString();
      }
    } else if (attributes is Map) {
      final attribute = attributes[attributeIndex.toString()];
      if (attribute is Map && attribute.containsKey(key)) {
        return attribute[key]?.toString();
      }
    }
  } catch (_) {}

  return null;
}

// get value form dynamic using key

dynamic getValueFromDynamic(dynamic data, String key) {
  if (data == null) return null;
  if (data is Map && data.containsKey(key)) {
    return data[key];
  } else {
    return null;
  }
}

String formatCurrency(double amount, String currencyCode) {
  final format = NumberFormat.simpleCurrency(name: currencyCode);
  return format.format(amount);
}
