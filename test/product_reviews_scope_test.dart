// The product detail page shows only its OWN reviews: the detail response's
// reviews connection is read off the product node (never off related or
// sibling products), and "Load more reviews" asks the API for that product id
// alone.
import 'package:bagisto_flutter/core/graphql/account_queries.dart';
import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/account/data/models/account_models.dart'
    as acct;
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/review_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Map<String, dynamic> _reviewEdge(String id, String comment) => {
  'node': {
    'id': id,
    'rating': 5,
    'name': 'Reviewer $id',
    'title': 'Title $id',
    'comment': comment,
    'createdAt': '2026-01-01',
  },
};

void main() {
  test('product detail reviews come only from the product itself', () {
    final json = <String, dynamic>{
      'id': '/api/shop/products/16',
      '_id': 16,
      'name': 'Analog Watch',
      'type': 'simple',
      'reviews': {
        'edges': [
          _reviewEdge('1', 'Mine one'),
          _reviewEdge('2', 'Mine two'),
        ],
      },
      'relatedProducts': {
        'edges': [
          {
            'node': {
              'id': '/api/shop/products/17',
              '_id': 17,
              'name': 'Other Watch',
              'type': 'simple',
              'reviews': {
                'edges': [_reviewEdge('9', 'Someone else\'s product')],
              },
            },
          },
        ],
      },
    };

    final product = ProductModel.fromJson(json);

    expect(product.reviews.map((r) => r.comment), ['Mine one', 'Mine two']);
    expect(product.reviewCount, 2);
    expect(
      product.reviews.any((r) => r.comment == 'Someone else\'s product'),
      isFalse,
    );
    // The related product keeps its own reviews on its own model.
    expect(product.relatedProducts.single.reviews.single.comment,
        'Someone else\'s product');
  });

  test('a product with no reviews of its own shows none', () {
    final product = ProductModel.fromJson({
      'id': '/api/shop/products/18',
      '_id': 18,
      'name': 'New Watch',
      'reviews': {'edges': <dynamic>[]},
    });

    expect(product.reviews, isEmpty);
    expect(product.reviewCount, 0);
    expect(product.averageRating, 0);
  });

  test('the full review list is requested for one product id only', () async {
    final repository = _FakeAccountRepository();
    final bloc = ReviewBloc(repository: repository);

    bloc.add(const LoadReviews(mode: ReviewMode.product, productId: 16));

    final state = await bloc.stream.firstWhere(
      (s) => s.status == ReviewStatus.loaded,
    );

    expect(repository.productIdCalls, [16]);
    expect(state.mode, ReviewMode.product);
    expect(state.reviews.single.comment, 'Only this product');
    await bloc.close();
  });

  test('the product reviews query filters by product id', () {
    expect(AccountQueries.getProductReviews, contains(r'$productId'));
    expect(
      AccountQueries.getProductReviews,
      contains(r'product_id: $productId'),
    );
  });

  test('booking product queries include reviews field', () {
    final byUrlKey = ProductQueries.getBookingProductByUrlKeyForType('default');
    final byId = ProductQueries.getBookingProductByIdForType('default');
    final byTypeBooking = ProductQueries.getProductByUrlKeyByType('booking');

    expect(byUrlKey, contains('reviews {'));
    expect(byId, contains('reviews {'));
    expect(byTypeBooking, contains('reviews {'));
    expect(byUrlKey, contains('rating'));
    expect(byUrlKey, contains('comment'));
  });

  test('booking product parses reviews correctly from JSON', () {
    final json = <String, dynamic>{
      'id': '/api/shop/products/46',
      '_id': 46,
      'name': 'Book product',
      'sku': 'dihuyvd',
      'type': 'booking',
      'reviews': {
        'edges': [
          _reviewEdge('15', 'best review'),
        ],
      },
    };

    final product = ProductModel.fromJson(json);

    expect(product.reviews.length, 1);
    expect(product.reviews.first.id, '15');
    expect(product.reviews.first.comment, 'best review');
    expect(product.reviews.first.rating, 5);
  });
}

class _FakeAccountRepository extends AccountRepository {
  final List<int?> productIdCalls = [];

  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<({List<acct.ProductReview> reviews, int totalCount})>
  getProductReviews({
    int first = 10,
    int? status,
    int? productId,
  }) async {
    productIdCalls.add(productId);
    return (
      reviews: const [
        acct.ProductReview(
          id: '1',
          name: 'Reviewer',
          title: 'Title',
          rating: 5,
          comment: 'Only this product',
          productId: 16,
        ),
      ],
      totalCount: 1,
    );
  }
}
