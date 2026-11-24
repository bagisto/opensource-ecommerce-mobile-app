import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every document file that selects one of these lists.
const _sources = [
  'lib/marketplace/graphql/seller_aftersales.dart',
  'lib/marketplace/graphql/shop_marketplace.dart',
  'lib/marketplace/graphql/seller_communications.dart',
];

/// The return-request screen showed four schema errors instead of a request:
/// `allowedStatuses`, `images`, `additionalFields` and `messages` are lists of
/// objects, and the documents selected them bare. GraphQL rejects the whole
/// query for that, so nothing on the screen loaded.
///
/// These are checked as text because the fault was in the document itself —
/// no widget or repository was involved, and a running server is not needed to
/// catch it again.
void main() {
  final source = {
    for (final path in _sources) path: File(path).readAsStringSync(),
  };

  /// Fields that resolve to a list of objects, so each needs a sub-selection.
  const objectLists = [
    'allowedStatuses',
    'images',
    'additionalFields',
    'messages',
  ];

  for (final field in objectLists) {
    test('$field is never selected without a sub-selection', () {
      // The field followed by anything other than `{` -- which catches it
      // alone on a line and inline beside its siblings, as `sellerRma { id
      // messages }` was. A word boundary keeps `messages` from matching
      // `messagesCount`.
      final bare = RegExp(r'\b' + field + r'\b(?!\s*\{)');

      for (final entry in source.entries) {
        expect(
          bare.hasMatch(_documentsOnly(entry.value)),
          isFalse,
          reason:
              '$field is selected bare in ${entry.key}. It resolves to a '
              'list of objects, so the whole document is invalid and the '
              'screen renders nothing.',
        );
      }
    });
  }

  test('the detail query still asks for what the screen renders', () {
    // Guards the opposite mistake: dropping a list while fixing its selection.
    final rma = source['lib/marketplace/graphql/seller_aftersales.dart']!;
    for (final field in objectLists) {
      expect(
        rma.contains('$field {'),
        isTrue,
        reason: '$field is no longer requested at all',
      );
    }
  });
}

/// The GraphQL documents with the Dart around them removed.
///
/// Comments mention these field names in prose, and a comment is not a
/// selection, so matching the whole file would fail on its own documentation.
String _documentsOnly(String source) {
  return RegExp(
    r"r'''(.*?)'''",
    dotAll: true,
  ).allMatches(source).map((match) => match.group(1)!).join('\n');
}
