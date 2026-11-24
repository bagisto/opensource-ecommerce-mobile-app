import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/models/seller_inventory_source.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Saving a product that has variations.
///
/// Parent fields and variants travel on one request, as the panel sends them.
/// The server writes the variants only when a parent field is there beside
/// them — see marketplace_type_payload_anchor_test.dart.
const _iri = SellerIri('/theme/api-4.9/public/api/seller/products/170');

SellerProductDetail _parent(List<SellerProductVariant> variants) =>
    SellerProductDetail(
      iri: _iri,
      productId: 192,
      sku: 'cycyyv6778',
      name: 'Cycyyv 6778',
      type: 'configurable',
      status: 1,
      variants: variants,
    );

SellerProductVariant _variant(int id, {double? price}) => SellerProductVariant(
  variantId: id,
  listingId: id + 100,
  sku: 'cycyyv6778-variant-$id',
  name: 'Variant $id',
  price: price,
);

class _Products implements SellerProductRepository {
  _Products({required this.variants});

  /// The variations the product itself reports.
  final List<SellerProductVariant> variants;

  final updates = <Map<String, dynamic>>[];

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProductDetail> detail(SellerIri iri) async => _parent(variants);

  @override
  Future<List<SellerProductCategoryNode>> assignableCategories() async =>
      const [];

  @override
  Future<SellerProductDetail> update(SellerProductDraft draft) async {
    updates.add(draft.toInput());
    return _parent(variants);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Inventory implements SellerInventorySourceRepository {
  @override
  Future<PaginatedResult<SellerInventorySource>> list({
    int page = 1,
    String? search,
    int? status,
  }) async => const PaginatedResult<SellerInventorySource>(
    items: [],
    totalCount: 0,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerProductEditorCubit> _open(_Products products) async {
  final cubit = SellerProductEditorCubit(
    iri: _iri,
    productRepository: products,
    inventoryRepository: _Inventory(),
  );
  await cubit.load();
  return cubit;
}

void main() {
  test('the variants travel with the parent, on one request', () async {
    final products = _Products(variants: [_variant(1), _variant(2)]);
    final cubit = await _open(products);

    cubit.setVariants({
      1: const SellerVariantEdit(variantId: 1, price: 100),
      2: const SellerVariantEdit(variantId: 2, price: 120),
    });
    cubit.edit((draft) => draft.copyWith(description: 'ihic'));

    expect(await cubit.save(), isTrue);
    expect(products.updates, hasLength(1));

    final sent = products.updates.single;
    expect(sent['description'], 'ihic');
    expect((sent['variants'] as List), hasLength(2));
  });

  test('a variant-only save still reaches the server', () async {
    // `{id, variants}` is answered OK and written nowhere, so the payload
    // carries the SKU the product already has.
    final products = _Products(variants: [_variant(1, price: 100)]);
    final cubit = await _open(products);

    cubit.setVariants({1: const SellerVariantEdit(variantId: 1, price: 150)});

    expect(await cubit.save(), isTrue);
    expect(products.updates.single['sku'], 'cycyyv6778');
    expect(products.updates.single['variants'], hasLength(1));
  });

  test('a priced set of variations saves the parent straight away', () async {
    final products = _Products(
      variants: [_variant(1, price: 100), _variant(2, price: 120)],
    );
    final cubit = await _open(products);

    cubit.edit((draft) => draft.copyWith(description: 'ihic'));

    expect(await cubit.save(), isTrue);
    expect(products.updates.single['description'], 'ihic');
  });

  test('an empty bundle option is sent, not refused', () async {
    // 2.4.9 used to answer "Each bundle option needs at least one product" and
    // drop every other edit on the form with it, so the app blocked the save.
    // The server dropped that validation on 2026-08-19 — an option with no
    // products is stored — and the block went with it, or a seller could never
    // put an option on the form before filling it.
    final products = _Products(variants: const []);
    final cubit = await _open(products);

    cubit.setBundleOptions(const [SellerBundleOption(label: 'Choose a bag')]);

    expect(await cubit.save(), isTrue);
    final sent = products.updates.single['bundleOptions'] as List;
    expect(sent.single['products'], isEmpty);
  });

  test(
    'the variations come from the product, not a catalogue search',
    () async {
      // They used to be found by searching the catalogue for "<sku>-variant-",
      // one request a page and another for every row's options. The product
      // reports them itself now, labelled.
      final products = _Products(variants: [_variant(1, price: 100)]);
      final cubit = await _open(products);

      expect(cubit.state.variants.single.sku, 'cycyyv6778-variant-1');
      expect(cubit.state.variants.single.variantId, 1);
    },
  );
}
