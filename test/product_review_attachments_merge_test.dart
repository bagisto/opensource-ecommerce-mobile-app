import 'dart:convert';

import 'package:bagisto_flutter/features/account/data/models/review_attachment.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Verbatim from the live server: `attachments` comes back as a JSON *string*,
/// and only on the top-level `productReviews` query — the product's own
/// `reviews` connection answers null for the very same review.
const _liveAttachments =
    '[{"type":"image","url":"http://192.168.15.239/theme/api-4.9/public/storage/review/17/6ad08c8f2fc2c.png"},'
    '{"type":"video","url":"http://192.168.15.239/theme/api-4.9/public/storage/review/17/6ad08c8f3292f.quicktime"}]';

CategoryRepository _repository(Map<String, dynamic> payload) =>
    CategoryRepository(
      client: GraphQLClient(
        link: HttpLink(
          'https://example.com/graphql',
          httpClient: MockClient(
            (_) async => http.Response(
              jsonEncode({'data': payload}),
              200,
              headers: {'content-type': 'application/json'},
            ),
          ),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

Map<String, dynamic> _payload(Object? attachments) => {
  '__typename': 'Query',
  'productReviews': {
    '__typename': 'ProductReviewCursorConnection',
    'edges': [
      {
        '__typename': 'ProductReviewEdge',
        'node': {
          '__typename': 'ProductReview',
          // This query spells the IRI with the install prefix; the product's
          // own reviews connection spells the same review '/api/shop/reviews/17'.
          'id': '/theme/api-4.9/public/api/shop/reviews/17',
          '_id': 17,
          'attachments': attachments,
        },
      },
    ],
  },
};

void main() {
  test('the media is read from the JSON string the server sends', () async {
    final byId = await _repository(
      _payload(_liveAttachments),
    ).getProductReviewAttachments(681);

    // Reachable by whichever id spelling the review on screen carries — the
    // product query's short IRI, this query's prefixed one, or a bare number.
    for (final id in [
      '/api/shop/reviews/17',
      '/theme/api-4.9/public/api/shop/reviews/17',
      '17',
      17,
    ]) {
      final attachments = byId[reviewIdKey(id)];
      expect(attachments, isNotNull, reason: 'no media matched for id $id');
      expect(attachments!.length, 2);
      expect(attachments.first.type, ReviewAttachmentType.image);
      expect(attachments.last.type, ReviewAttachmentType.video);
      expect(attachments.first.url, endsWith('6ad08c8f2fc2c.png'));
    }
  });

  test('a review the server sends no media for is left out', () async {
    final byId = await _repository(
      _payload(null),
    ).getProductReviewAttachments(681);

    expect(byId, isEmpty);
  });

  test('an unparsable value is ignored rather than thrown', () async {
    final byId = await _repository(
      _payload('not json at all'),
    ).getProductReviewAttachments(681);

    expect(byId, isEmpty);
  });
}
