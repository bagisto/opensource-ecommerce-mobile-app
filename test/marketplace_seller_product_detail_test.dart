import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_detail_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_product_detail_page.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_product_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeProductRepository implements SellerProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
  _FakeProductRepository({this.product, this.failWith});

  final SellerProductDetail? product;
  final SellerApiException? failWith;
  SellerIri? requestedIri;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProductDetail> detail(SellerIri iri) async {
    requestedIri = iri;
    if (failWith != null) throw failWith!;
    return product!;
  }

  @override
  Future<PaginatedResult<SellerProductListItem>> list({
    int page = 1,
    SellerProductFilters filters = const SellerProductFilters(),
  }) => throw UnimplementedError();

  @override
  Future<SellerProductListItem> create({
    required String type,
    required int attributeFamilyId,
    required String sku,
    bool isDraft = false,
    List<Map<String, dynamic>>? superAttributes,
  }) => throw UnimplementedError();

  @override
  Future<SellerProductDetail> update(SellerProductDraft draft) =>
      throw UnimplementedError();

  @override
  Future<void> delete(SellerIri iri) => throw UnimplementedError();

  @override
  Future<SellerProductDeleteBatch> deleteBatch(List<int> catalogueIds) =>
      throw UnimplementedError();

  @override
  Future<List<SellerProductCategoryNode>> assignableCategories() =>
      throw UnimplementedError();

  Future<List<SellerProductListItem>> variantsOf(String parentSku) =>
      throw UnimplementedError();
}

const _detail = SellerProductDetail(
  iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
  productId: 65,
  sku: 'demo-sneaker',
  name: 'Runner Sneakers',
  type: 'simple',
  status: 1,
  price: 74,
  quantity: 60,
  approvalState: 'pending',
  stocks: [
    SellerProductStock(
      sourceId: 5,
      sourceCode: 'vendor_38_default',
      sourceName: 'Default',
      qty: 60,
    ),
  ],
);

class _StubDetailCubit extends Cubit<SellerProductDetailState>
    implements SellerProductDetailCubit {
  _StubDetailCubit(super.initialState);

  @override
  SellerProductRepository get repository => throw UnimplementedError();

  @override
  SellerIri get iri => const SellerIri('/api/seller/products/50');

  @override
  Future<void> load() async {}
}

Widget _wrap(_StubDetailCubit cubit) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<SellerProductDetailCubit>.value(
      value: cubit,
      child: const SellerProductDetailPage(),
    ),
  );
}

void main() {
  group('SellerProductDetailCubit', () {
    test('load fetches the product for the IRI it was given', () async {
      final repository = _FakeProductRepository(product: _detail);
      final cubit = SellerProductDetailCubit(
        repository: repository,
        iri: const SellerIri('/theme/api-4.9/public/api/seller/products/50'),
      );

      await cubit.load();

      expect(
        repository.requestedIri?.value,
        '/theme/api-4.9/public/api/seller/products/50',
      );
      expect(cubit.state.status, SellerProductDetailStatus.loaded);
      expect(cubit.state.product?.name, 'Runner Sneakers');
    });

    test('a missing product surfaces the server message', () async {
      final cubit = SellerProductDetailCubit(
        repository: _FakeProductRepository(
          failWith: const SellerApiException(
            'Resource not found.',
            SellerApiFailure.notFound,
          ),
        ),
        iri: const SellerIri('/api/seller/products/999'),
      );

      await cubit.load();

      expect(cubit.state.status, SellerProductDetailStatus.failed);
      expect(cubit.state.errorMessage, 'Resource not found.');
    });
  });

  group('SellerProductDetailPage', () {
    testWidgets('renders identity, badges and stock by source', (tester) async {
      final cubit = _StubDetailCubit(
        const SellerProductDetailState(
          status: SellerProductDetailStatus.loaded,
          product: _detail,
        ),
      );

      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();

      expect(find.text('Runner Sneakers'), findsOneWidget);
      expect(find.text('demo-sneaker'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Enabled'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.byType(SellerProductImagePlaceholder), findsOneWidget);
    });

    testWidgets('shows the rejection reason when the admin turned it down', (
      tester,
    ) async {
      final cubit = _StubDetailCubit(
        const SellerProductDetailState(
          status: SellerProductDetailStatus.loaded,
          product: SellerProductDetail(
            iri: SellerIri('/api/seller/products/50'),
            productId: 65,
            sku: 'demo-sneaker',
            name: 'Runner Sneakers',
            type: 'simple',
            approvalState: 'rejected',
            rejectionReason: 'Images are too small.',
          ),
        ),
      );

      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();

      expect(find.text('Rejected'), findsOneWidget);
      expect(find.text('Images are too small.'), findsOneWidget);
    });

    testWidgets(
      'strips HTML <p> tags from attributes like Short Description and Description',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final cubit = _StubDetailCubit(
          const SellerProductDetailState(
            status: SellerProductDetailStatus.loaded,
            product: SellerProductDetail(
              iri: SellerIri('/api/seller/products/50'),
              productId: 65,
              sku: 'demo-sneaker',
              name: 'Runner Sneakers',
              type: 'simple',
              attributes: [
                SellerProductAttributeValue(
                  code: 'short_description',
                  name: 'Short Description',
                  type: 'textarea',
                  value: '<p>dsasd</p>',
                ),
                SellerProductAttributeValue(
                  code: 'description',
                  name: 'Description',
                  type: 'textarea',
                  value: '<p>sadsad</p>',
                ),
              ],
            ),
          ),
        );

        await tester.pumpWidget(_wrap(cubit));
        await tester.pump();

        expect(find.text('Short Description'), findsOneWidget);
        expect(find.text('dsasd'), findsOneWidget);
        expect(find.text('Description'), findsWidgets);
        expect(find.text('sadsad'), findsOneWidget);
        expect(find.textContaining('<p>'), findsNothing);
        expect(find.textContaining('</p>'), findsNothing);
      },
    );

    testWidgets('shows 0.00 for unadded price as web does', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = _StubDetailCubit(
        const SellerProductDetailState(
          status: SellerProductDetailStatus.loaded,
          product: SellerProductDetail(
            iri: SellerIri('/api/seller/products/50'),
            productId: 65,
            sku: 'demo-sneaker',
            name: 'Runner Sneakers',
            type: 'simple',
            price: null,
          ),
        ),
      );

      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();

      expect(find.text('0.00'), findsNWidgets(2));
    });
  });
}
