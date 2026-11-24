import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/models/seller_inventory_source.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/presentation/bloc/seller_inventory_sources_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/presentation/pages/seller_inventory_sources_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _RecordingLink {
  _RecordingLink({this.data, this.errors = const []});

  final Map<String, dynamic>? data;
  final List<String> errors;
  Map<String, dynamic>? lastVariables;

  GraphQLClient get client {
    final link = Link.function((request, [forward]) async* {
      lastVariables = request.variables;
      yield Response(
        data: data,
        errors: errors
            .map((message) => GraphQLError(message: message))
            .toList(),
        response: const {},
        context: const Context(),
      );
    });

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }
}

/// Shape copied from a live `sellerInventorySources` response.
const _liveSource = {
  'id': '/theme/api-4.9/public/api/seller/inventory-sources/5',
  '_id': 5,
  'code': 'vendor_38_default',
  'name': 'Default',
  'description': 'Seeded',
  'contactName': 'Demo Contact',
  'contactEmail': 'warehouse@example.com',
  'contactNumber': '9876543210',
  'street': 'Plot 42',
  'country': 'IN',
  'state': 'UP',
  'city': 'Noida',
  'postcode': '201301',
  'priority': 1,
  'status': true,
  'productsCount': 7,
};

class _FakeRepository implements SellerInventorySourceRepository {
  _FakeRepository({this.sources = const [], this.failWith});

  List<SellerInventorySource> sources;
  final SellerApiException? failWith;
  SellerInventorySourceInput? lastInput;
  SellerIri? deleted;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<PaginatedResult<SellerInventorySource>> list({
    int page = 1,
    String? search,
    int? status,
  }) async => PaginatedResult<SellerInventorySource>(
    items: sources,
    totalCount: sources.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<SellerInventorySource> create(SellerInventorySourceInput input) async {
    if (failWith != null) throw failWith!;
    lastInput = input;
    final created = SellerInventorySource(
      iri: const SellerIri('/api/seller/inventory-sources/9'),
      id: 9,
      code: input.code,
      name: input.name,
      status: input.status,
    );
    sources = [...sources, created];
    return created;
  }

  @override
  Future<SellerInventorySource> update(
    SellerIri iri,
    SellerInventorySourceInput input,
  ) async {
    if (failWith != null) throw failWith!;
    lastInput = input;
    return SellerInventorySource(
      iri: iri,
      id: iri.numericId,
      code: input.code,
      name: input.name,
      status: input.status,
    );
  }

  @override
  Future<void> delete(SellerIri iri) async {
    if (failWith != null) throw failWith!;
    deleted = iri;
    sources = sources.where((source) => source.iri != iri).toList();
  }
}

void main() {
  group('repository', () {
    test('list maps the location, its stock count and status', () async {
      final link = _RecordingLink(
        data: {
          'sellerInventorySources': {
            'collection': [_liveSource],
            'paginationInfo': {'totalCount': 1, 'lastPage': 1},
          },
        },
      );
      final repository = SellerInventorySourceRepository(client: link.client);

      final page = await repository.list();
      final source = page.items.single;

      expect(source.id, 5);
      expect(source.code, 'vendor_38_default');
      expect(source.productsCount, 7);
      expect(source.status, isTrue);
      expect(source.shortAddress, 'Noida, UP, IN');
    });

    test('create sends every field the server requires', () async {
      final link = _RecordingLink(
        data: {
          'createSellerInventorySource': {'sellerInventorySource': _liveSource},
        },
      );
      final repository = SellerInventorySourceRepository(client: link.client);

      await repository.create(
        const SellerInventorySourceInput(
          code: 'warehouse_north',
          name: 'North Warehouse',
          contactName: 'Ravi',
          contactEmail: 'north@example.com',
          contactNumber: '999',
          street: 'Plot 1',
          country: 'IN',
          state: 'UP',
          city: 'Noida',
          postcode: '201301',
          priority: 2,
        ),
      );

      final input = link.lastVariables?['input'] as Map<String, dynamic>;
      expect(input['code'], 'warehouse_north');
      expect(input['city'], 'Noida');
      expect(input['priority'], 2);
      expect(input['status'], true);
    });

    test('update carries the IRI alongside the fields', () async {
      final link = _RecordingLink(
        data: {
          'updateSellerInventorySource': {'sellerInventorySource': _liveSource},
        },
      );
      final repository = SellerInventorySourceRepository(client: link.client);

      await repository.update(
        const SellerIri('/theme/api-4.9/public/api/seller/inventory-sources/5'),
        const SellerInventorySourceInput(code: 'c', name: 'Renamed'),
      );

      final input = link.lastVariables?['input'] as Map<String, dynamic>;
      expect(
        input['id'],
        '/theme/api-4.9/public/api/seller/inventory-sources/5',
      );
      expect(input['name'], 'Renamed');
    });

    test(
      'deleting the last active location surfaces the server message',
      () async {
        final link = _RecordingLink(
          errors: const ['The last active inventory source cannot be deleted.'],
        );
        final repository = SellerInventorySourceRepository(client: link.client);

        await expectLater(
          repository.delete(const SellerIri('/api/seller/inventory-sources/5')),
          throwsA(
            isA<SellerApiException>().having(
              (e) => e.message,
              'message',
              'The last active inventory source cannot be deleted.',
            ),
          ),
        );
      },
    );
  });

  group('cubit', () {
    test('load fills the list', () async {
      final cubit = SellerInventorySourcesCubit(
        repository: _FakeRepository(
          sources: [SellerInventorySource.fromJson(_liveSource)],
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerInventorySourcesStatus.loaded);
      expect(cubit.state.sources.single.name, 'Default');
    });

    test('creating reloads and reports success', () async {
      final repository = _FakeRepository();
      final cubit = SellerInventorySourcesCubit(repository: repository);

      final ok = await cubit.create(
        const SellerInventorySourceInput(code: 'north', name: 'North'),
      );

      expect(ok, isTrue);
      expect(repository.lastInput?.code, 'north');
      expect(cubit.state.sources.single.name, 'North');
      expect(cubit.state.lastActionAt, isNotNull);
    });

    test('a refused delete keeps the list and shows the reason', () async {
      final cubit = SellerInventorySourcesCubit(
        repository: _FakeRepository(
          sources: [SellerInventorySource.fromJson(_liveSource)],
          failWith: const SellerApiException(
            'The last active inventory source cannot be deleted.',
            SellerApiFailure.validation,
          ),
        ),
      );
      await cubit.load();

      final ok = await cubit.delete(
        const SellerIri('/api/seller/inventory-sources/5'),
      );

      expect(ok, isFalse);
      expect(
        cubit.state.errorMessage,
        'The last active inventory source cannot be deleted.',
      );
      expect(cubit.state.sources, hasLength(1));
    });

    testWidgets('renders Active and Inactive status badges', (tester) async {
      final activeSource = SellerInventorySource.fromJson(_liveSource);
      final inactiveSource = SellerInventorySource.fromJson({
        ..._liveSource,
        'id': '/theme/api-4.9/public/api/seller/inventory-sources/6',
        '_id': 6,
        'code': 'vendor_38_backup',
        'name': 'Backup',
        'status': false,
      });

      final cubit = SellerInventorySourcesCubit(
        repository: _FakeRepository(sources: [activeSource, inactiveSource]),
      );
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<SellerInventorySourcesCubit>.value(
            value: cubit,
            child: const SellerInventorySourcesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('does not show how many products a location holds', (
      tester,
    ) async {
      // _liveSource carries productsCount: 7.
      final cubit = SellerInventorySourcesCubit(
        repository: _FakeRepository(
          sources: [SellerInventorySource.fromJson(_liveSource)],
        ),
      );
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<SellerInventorySourcesCubit>.value(
            value: cubit,
            child: const SellerInventorySourcesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('products'), findsNothing);
      expect(
        find.byKey(const Key('sellerStockLocationPriorityValue')),
        findsOneWidget,
      );
      expect(find.textContaining('Detroit'), findsNothing);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });
  });
}
