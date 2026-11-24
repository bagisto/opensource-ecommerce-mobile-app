import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_marketing_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// The category condition lists only the root, where the panel shows the whole
/// tree. The seller's own category list has the rest.
const _options = {
  'conditionAttributes': [
    {
      'key': 'product',
      'label': 'Product attribute',
      'children': [
        {
          'key': 'product|category_ids',
          'label': 'Categories',
          'type': 'multiselect',
          'operators': [
            {'operator': '{}', 'label': 'Contains'},
          ],
          'options': [
            {'value': 1, 'label': 'Root'},
          ],
        },
        {
          'key': 'product|price',
          'label': 'Price',
          'type': 'price',
          'operators': [
            {'operator': '==', 'label': 'Is equal to'},
          ],
        },
      ],
    },
  ],
};

const _categories = [
  {'id': 2, 'parentId': 1, 'name': 'Watches', 'level': 0, 'position': 2},
  {'id': 5, 'parentId': 2, 'name': 'Royal', 'level': 1, 'position': 4},
  {'id': 3, 'parentId': 1, 'name': 'Tops', 'level': 0, 'position': 3},
];

GraphQLClient _client({required bool categoriesAllowed}) {
  final link = Link.function((request, [forward]) async* {
    // The query's own name, read off its first definition.
    final dynamic definition = request.operation.document.definitions.first;
    final name = definition.name?.value as String?;

    if (name == 'SellerProductCategories') {
      if (!categoriesAllowed) {
        yield Response(
          errors: [const GraphQLError(message: 'Unauthorized.')],
          response: const {},
          context: const Context(),
        );
        return;
      }
      yield Response(
        data: const {'sellerProductCategories': _categories},
        response: const {},
        context: const Context(),
      );
      return;
    }

    yield Response(
      data: const {'sellerProductDiscountOptions': _options},
      response: const {},
      context: const Context(),
    );
  });

  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  );
}

void main() {
  test('the category condition is the whole tree, under its root', () async {
    final options = await SellerMarketingRepository(
      client: _client(categoriesAllowed: true),
    ).ruleOptions();

    final categories = options.conditionGroups.single.attributes.firstWhere(
      (attribute) => attribute.key == 'product|category_ids',
    );

    expect(
      [for (final option in categories.options) option.label],
      ['Root', 'Watches', 'Royal', 'Tops'],
    );
    expect(
      [for (final option in categories.options) option.level],
      [0, 1, 2, 1],
    );
    expect(categories.options.map((option) => option.value), [
      '1',
      '2',
      '5',
      '3',
    ]);
  });

  test('other attributes are left as the server sent them', () async {
    final options = await SellerMarketingRepository(
      client: _client(categoriesAllowed: true),
    ).ruleOptions();

    final price = options.conditionGroups.single.attributes.firstWhere(
      (attribute) => attribute.key == 'product|price',
    );

    expect(price.options, isEmpty);
  });

  test('without the category list the root alone is offered', () async {
    final options = await SellerMarketingRepository(
      client: _client(categoriesAllowed: false),
    ).ruleOptions();

    final categories = options.conditionGroups.single.attributes.firstWhere(
      (attribute) => attribute.key == 'product|category_ids',
    );

    expect([for (final option in categories.options) option.label], ['Root']);
  });
}
