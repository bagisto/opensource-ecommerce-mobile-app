import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_attribute_families_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// A family just created in admin has no product yet, so it could only ever
/// come from the seller's own family list.
class _Answers {
  _Answers(this.data);

  final Map<String, dynamic> data;

  GraphQLClient get client {
    final link = Link.function((request, [forward]) async* {
      yield Response(data: data, response: const {}, context: const Context());
    });

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }
}

void main() {
  test(
    'every family the seller API lists is offered, lowest id first',
    () async {
      final answers = _Answers({
        'sellerAttributeFamilies': [
          {'_id': 2, 'code': 'aman', 'name': 'aman'},
          {'_id': 1, 'code': 'default', 'name': 'Default'},
        ],
      });

      final families = await SellerAttributeFamiliesRepository(
        client: answers.client,
      ).load();

      expect(families.map((f) => f.id), [1, 2]);
      expect(families.map((f) => f.name), ['Default', 'aman']);
    },
  );

  test('a family with no name is shown by its code', () async {
    final answers = _Answers({
      'sellerAttributeFamilies': [
        {'_id': 3, 'code': 'summer', 'name': ''},
        {'_id': 4, 'code': null, 'name': null},
      ],
    });

    final families = await SellerAttributeFamiliesRepository(
      client: answers.client,
    ).load();

    expect(families.map((f) => f.name), ['summer', '4']);
  });

  test('an empty list is an empty result, not an error', () async {
    final answers = _Answers({'sellerAttributeFamilies': const <dynamic>[]});

    final families = await SellerAttributeFamiliesRepository(
      client: answers.client,
    ).load();

    expect(families, isEmpty);
  });
}
