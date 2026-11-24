import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Object-typed fields must name what they select.
///
/// `stats` was selected bare. It used to be a scalar `Iterable`; the server
/// gave it a type of its own, and every import query started answering
/// `Field "stats" of type "SellerImportStats" must have a sub selection.` —
/// which reached the seller as a black toast over the bulk upload screen.
///
/// The parser cannot tell an object from a scalar, so this reads the
/// documents the app ships and checks the fields known to be object-typed are
/// never selected on their own.
void main() {
  /// Fields the seller API types as objects, and what a selection must open.
  const objectFields = <String>['stats'];

  test('an object field is never selected bare', () {
    final documents = Directory('lib/marketplace/graphql')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final offenders = <String>[];

    for (final file in documents) {
      final lines = file.readAsLinesSync();
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index];
        for (final field in objectFields) {
          // The field named with nothing after it but a line break, a closing
          // brace, or another field — never a `{`.
          final bare = RegExp('(^|[ {])$field(\\s|\$)');
          if (!bare.hasMatch(line)) continue;
          final rest = line.split(field).last.trimLeft();
          if (rest.startsWith('{')) continue;
          // The rest of the line may still open it further along.
          if (line.contains('$field {')) continue;
          offenders.add('${file.path.split('/').last}:${index + 1}  $line');
        }
      }
    }

    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
