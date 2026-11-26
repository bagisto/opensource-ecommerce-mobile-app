import 'dart:convert';
import 'dart:io';

import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/add_review_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('review_repo'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('omits attachments when none are given', () async {
    Map<String, dynamic>? sent;
    final repository = _repository((body) => sent = body);

    await repository.createProductReview(
      productId: 10,
      title: 'Nice',
      comment: 'Good',
      rating: 5,
      name: 'Ann',
    );

    final input = sent!['variables']['input'] as Map<String, dynamic>;
    expect(input.containsKey('attachments'), isFalse);
    expect(sent!['query'], contains('attachments'));
  });

  test('sends attachments as a JSON string of data URIs', () async {
    Map<String, dynamic>? sent;
    final repository = _repository((body) => sent = body);
    final photo = File('${dir.path}/p.png')..writeAsBytesSync([7, 8, 9]);

    final review = await repository.createProductReview(
      productId: 10,
      title: 'Nice',
      comment: 'Good',
      rating: 5,
      name: 'Ann',
      attachments: [photo],
    );

    final attachments = sent!['variables']['input']['attachments'];
    expect(attachments, isA<String>());
    expect(jsonDecode(attachments as String), [
      'data:image/png;base64,${base64Encode([7, 8, 9])}',
    ]);
    expect(review.attachments.single.url, 'https://x.test/p.png');
  });

  test('SubmitReview includes attachments in props', () {
    final a = SubmitReview(
      productId: 1,
      title: 't',
      comment: 'c',
      rating: 5,
      name: 'n',
      attachments: [File('/a.png')],
    );
    const b = SubmitReview(
      productId: 1,
      title: 't',
      comment: 'c',
      rating: 5,
      name: 'n',
    );

    expect(a.attachments.single.path, '/a.png');
    expect(b.attachments, isEmpty);
    expect(a == b, isFalse);
  });
}

AccountRepository _repository(void Function(Map<String, dynamic>) capture) {
  final httpClient = MockClient((request) async {
    capture(jsonDecode(request.body) as Map<String, dynamic>);
    return http.Response(
      jsonEncode({
        'data': {
          '__typename': 'Mutation',
          'createProductReview': {
            '__typename': 'createProductReviewPayload',
            'productReview': {
              '__typename': 'ProductReview',
              'id': '/api/shop/reviews/5',
              '_id': 5,
              'name': 'Ann',
              'title': 'Nice',
              'rating': 5,
              'comment': 'Good',
              'status': 'pending',
              'attachments': '[{"type":"image","url":"https://x.test/p.png"}]',
              'createdAt': '2026-09-17T10:00:00+00:00',
              'updatedAt': '2026-09-17T10:00:00+00:00',
            },
          },
        },
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });

  return AccountRepository(
    client: GraphQLClient(
      link: HttpLink('https://example.com/graphql', httpClient: httpClient),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}
