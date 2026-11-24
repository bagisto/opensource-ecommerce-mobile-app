import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_configurable_attributes_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_create_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Stands in for the family fetch.
///
/// The picker used to show a spinner whenever the list was empty, so a refused
/// fetch and a family carrying nothing both read as "still loading" and the
/// seller waited on a request that had already finished.
class _Attributes implements SellerConfigurableAttributesRepository {
  _Attributes({this.result, this.failure});

  final List<SellerConfigurableAttribute>? result;
  final Object? failure;

  final requestedFamilies = <int>[];

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  GraphQLClient? get sellerClient => throw UnimplementedError();

  @override
  Future<List<SellerConfigurableAttribute>> load() async => result ?? const [];

  @override
  Future<List<SellerConfigurableAttribute>> forFamily(int familyId) async {
    requestedFamilies.add(familyId);
    if (failure != null) throw failure!;
    return result ?? const [];
  }
}

class _Products implements SellerProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final _colour = SellerConfigurableAttribute(
  code: 'color',
  name: 'Color',
  options: const [
    SellerProductCategoryRef(id: '1', name: 'Red'),
    SellerProductCategoryRef(id: '2', name: 'Green'),
  ],
);

void main() {
  test('the family it asks for is the one the seller picked', () async {
    final attributes = _Attributes(result: [_colour]);
    final cubit = SellerProductCreateCubit(
      repository: _Products(),
      attributes: attributes,
    );

    await cubit.loadConfigurableAttributes(3);

    expect(attributes.requestedFamilies, [3]);
    expect(cubit.state.configurableAttributes.single.name, 'Color');
    expect(cubit.state.attributesStatus, SellerAttributesStatus.loaded);
  });

  test('changing the family fetches again', () async {
    // Each family carries its own attributes, so the set on offer cannot be
    // read once and kept.
    final attributes = _Attributes(result: [_colour]);
    final cubit = SellerProductCreateCubit(
      repository: _Products(),
      attributes: attributes,
    );

    await cubit.loadConfigurableAttributes(1);
    await cubit.loadConfigurableAttributes(1);
    await cubit.loadConfigurableAttributes(2);

    expect(attributes.requestedFamilies, [1, 2]);
  });

  test('a refused fetch is reported, not left spinning', () async {
    final cubit = SellerProductCreateCubit(
      repository: _Products(),
      attributes: _Attributes(
        failure: const SellerApiException('no', SellerApiFailure.forbidden),
      ),
    );

    await cubit.loadConfigurableAttributes(1);

    expect(cubit.state.attributesStatus, SellerAttributesStatus.failed);
    expect(cubit.state.configurableAttributes, isEmpty);
  });

  test('anything else that breaks is reported too', () async {
    // The server sends numbers as strings, so a parse can fail outside
    // SellerApiException; that used to leave the spinner running.
    final cubit = SellerProductCreateCubit(
      repository: _Products(),
      attributes: _Attributes(failure: TypeError()),
    );

    await cubit.loadConfigurableAttributes(1);

    expect(cubit.state.attributesStatus, SellerAttributesStatus.failed);
  });

  test('a family carrying nothing reads as loaded, not loading', () async {
    final cubit = SellerProductCreateCubit(
      repository: _Products(),
      attributes: _Attributes(result: const []),
    );

    await cubit.loadConfigurableAttributes(1);

    expect(cubit.state.attributesStatus, SellerAttributesStatus.loaded);
    expect(cubit.state.configurableAttributes, isEmpty);
  });

  test('no repository at all is a failure, not a wait', () async {
    final cubit = SellerProductCreateCubit(repository: _Products());

    await cubit.loadConfigurableAttributes(1);

    expect(cubit.state.attributesStatus, SellerAttributesStatus.failed);
  });
}
