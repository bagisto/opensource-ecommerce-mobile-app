import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SellerIri', () {
    test('keeps the install path prefix the server sent', () {
      const raw = '/theme/api-4.9/public/api/seller/products/26';
      final iri = SellerIri.fromJson(raw)!;

      expect(iri.value, raw);
      expect(iri.toString(), raw);
    });

    test('reads the trailing numeric id', () {
      final iri = SellerIri.fromJson('/api/seller/products/26')!;

      expect(iri.numericId, 26);
    });

    test('throws when the trailing segment is not numeric', () {
      final iri = SellerIri.fromJson('/api/seller/profile')!;

      expect(() => iri.numericId, throwsFormatException);
    });

    test('fromJson returns null for a null input', () {
      expect(SellerIri.fromJson(null), isNull);
    });
  });

  group('PaginatedResult', () {
    test('maps a collection envelope', () {
      final json = {
        'collection': [
          {'name': 'first'},
          {'name': 'second'},
        ],
        'paginationInfo': {'totalCount': 42, 'lastPage': 5, 'itemsPerPage': 10},
      };

      final result = PaginatedResult<String>.fromJson(
        json,
        (item) => item['name'] as String,
        requestedPage: 2,
      );

      expect(result.items, ['first', 'second']);
      expect(result.totalCount, 42);
      expect(result.lastPage, 5);
      expect(result.currentPage, 2);
      expect(result.hasNextPage, isTrue);
    });

    test('has no next page on the last page', () {
      final json = {
        'collection': const <dynamic>[],
        'paginationInfo': {'totalCount': 0, 'lastPage': 1},
      };

      final result = PaginatedResult<String>.fromJson(
        json,
        (item) => item['name'] as String,
        requestedPage: 1,
      );

      expect(result.items, isEmpty);
      expect(result.hasNextPage, isFalse);
    });
  });
}
