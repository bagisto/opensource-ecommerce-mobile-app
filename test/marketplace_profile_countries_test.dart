import 'dart:async';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/graphql/seller_account.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_country.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/pages/seller_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final _countries = [
  SellerCountry.fromJson({
    'code': 'US',
    'name': 'United States',
    'states': [
      {'code': 'CO', 'name': 'Colorado'},
      {'code': 'CA', 'name': 'California'},
    ],
  }),
  SellerCountry.fromJson({
    'code': 'IN',
    'name': 'India',
    'states': [
      {'code': 'MH', 'name': 'Maharashtra'},
    ],
  }),
  SellerCountry.fromJson({'code': 'SG', 'name': 'Singapore', 'states': []}),
];

class _Repository implements SellerAccountRepository {
  _Repository({String country = 'US', String state = 'Colorado'}) {
    values = {
      'business_name': 'Shop',
      'city': 'Denver',
      'country': country,
      'state': state,
    };
  }
  late Map<String, String> values;
  final saves = <Map<String, dynamic>>[];
  int countryRequests = 0;
  bool failCountries = false;
  bool failSave = false;
  List<SellerCountry> countryData = _countries;
  Completer<List<SellerCountry>>? pending;
  @override
  Future<SellerProfile> profile() async => SellerProfile.fromJson({
    'name': 'Seller',
    'email': 'seller@example.com',
    'isApproved': true,
    'profileAttributes': [
      for (final entry in values.entries)
        {
          'code': entry.key,
          'name': entry.key,
          'type': 'text',
          'value': entry.value,
        },
    ],
  });
  @override
  Future<List<SellerCountry>> countries() async {
    countryRequests++;
    if (failCountries) throw StateError('Countries unavailable');
    return pending == null ? countryData : pending!.future;
  }

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async {
    saves.add(Map.of(input));
    if (failSave) throw StateError('Save failed');
    for (final entry in input.entries) {
      values[entry.key == 'businessName' ? 'business_name' : entry.key] = entry
          .value
          .toString();
    }
    return profile();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerProfileCubit> _pump(
  WidgetTester tester,
  _Repository repository,
) async {
  final cubit = SellerProfileCubit(repository: repository);
  addTearDown(cubit.close);
  await cubit.load();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const SellerProfilePage()),
    ),
  );
  await tester.pump();
  await tester.tap(find.text('Address'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
  return cubit;
}

Finder _field(String code) => find.byKey(Key('sellerProfileField_$code'));
Future<void> _select(WidgetTester tester, String code, String label) async {
  await tester.tap(_field(code));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _save(WidgetTester tester) async {
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
      .removeCurrentSnackBar();
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('sellerProfileSave')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'empty country list preserves editable fallback and allows retry',
    (tester) async {
      final repository = _Repository()..countryData = [];
      await _pump(tester, repository);
      expect(
        tester.widget<TextField>(_field('state')).controller!.text,
        'Colorado',
      );
      expect(
        find.byKey(const Key('sellerProfileCountriesRetry')),
        findsOneWidget,
      );
      await tester.enterText(_field('city'), 'Boston');
      await _save(tester);
      expect(repository.saves.single, {'city': 'Boston'});
    },
  );

  testWidgets('unknown state for known country is not silently dropped', (
    tester,
  ) async {
    final repository = _Repository(state: 'Legacy region');
    await _pump(tester, repository);
    expect(find.text('Legacy region'), findsOneWidget);
    await _save(tester);
    expect(repository.saves, isEmpty);
  });

  testWidgets('selecting the existing country keeps the legacy state', (
    tester,
  ) async {
    final repository = _Repository(country: 'United States');
    await _pump(tester, repository);
    await _select(tester, 'country', 'United States');
    expect(find.text('Colorado'), findsOneWidget);
    await _save(tester);
    expect(repository.saves, isEmpty);
  });

  testWidgets('country change without a state is blocked: state is required', (
    tester,
  ) async {
    final repository = _Repository();
    await _pump(tester, repository);
    await _select(tester, 'country', 'India');
    await _save(tester);
    expect(repository.saves, isEmpty);
    expect(find.text('This field is required'), findsOneWidget);
    await _select(tester, 'state', 'Maharashtra');
    await _save(tester);
    expect(repository.saves.single, {'country': 'IN', 'state': 'MH'});
  });

  testWidgets('failed save and retry keep selected values', (tester) async {
    final repository = _Repository()..failSave = true;
    final cubit = await _pump(tester, repository);
    await _select(tester, 'country', 'India');
    await _select(tester, 'state', 'Maharashtra');
    await _save(tester);
    expect(cubit.state.status, SellerProfileStatus.failed);
    expect(find.text('India'), findsOneWidget);
    expect(find.text('Maharashtra'), findsOneWidget);
    repository.failSave = false;
    await _save(tester);
    expect(repository.saves, [
      {'country': 'IN', 'state': 'MH'},
      {'country': 'IN', 'state': 'MH'},
    ]);
  });

  for (final width in [320.0, 390.0, 1024.0]) {
    testWidgets('address dropdowns fit width $width', (tester) async {
      tester.view.physicalSize = Size(width, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _pump(tester, _Repository());
      await _select(tester, 'country', 'India');
      await _select(tester, 'state', 'Maharashtra');
      for (final code in ['country', 'state']) {
        final bounds = tester.getRect(_field(code));
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(width));
      }
      expect(tester.takeException(), isNull);
    });
  }

  test('countries query maps nested state names and codes', () async {
    final link = Link.function((request, [forward]) async* {
      expect(request.operation.document, gql(SellerAccountDocuments.countries));
      expect(request.variables, isEmpty);
      yield Response(
        data: {
          'sellerCountries': [
            {
              'code': 'US',
              'name': 'United States',
              'states': [
                {'code': 'CO', 'name': 'Colorado'},
              ],
            },
          ],
        },
        response: const {},
      );
    });
    final repository = SellerAccountRepository(
      client: GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: link,
      ),
    );
    final countries = await repository.countries();
    expect(countries.single.code, 'US');
    expect(countries.single.states.single.code, 'CO');
    expect(countries.single.states.single.name, 'Colorado');
  });

  for (final value in ['Colorado', 'CO']) {
    testWidgets('preselects $value without rewriting untouched values', (
      tester,
    ) async {
      final repository = _Repository(state: value);
      await _pump(tester, repository);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Colorado'), findsOneWidget);
      await _save(tester);
      expect(repository.saves, isEmpty);
      await tester.enterText(_field('city'), 'Boston');
      await _save(tester);
      expect(repository.saves.single, {'city': 'Boston'});
      await _save(tester);
      expect(repository.saves, hasLength(1));
    });
  }

  testWidgets('changing country clears old state and sends selected codes', (
    tester,
  ) async {
    final repository = _Repository();
    await _pump(tester, repository);
    await _select(tester, 'country', 'India');
    expect(find.text('Colorado'), findsNothing);
    await _select(tester, 'state', 'Maharashtra');
    await _save(tester);
    expect(repository.saves.single, {'country': 'IN', 'state': 'MH'});
    expect(repository.countryRequests, 1);
  });

  testWidgets('changing only the state sends only its code', (tester) async {
    final repository = _Repository();
    await _pump(tester, repository);
    await _select(tester, 'state', 'California');
    await _save(tester);
    expect(repository.saves.single, {'state': 'CA'});
  });

  testWidgets('countries without states allow manual state entry', (
    tester,
  ) async {
    final repository = _Repository();
    await _pump(tester, repository);
    await _select(tester, 'country', 'Singapore');
    expect(tester.widget<TextField>(_field('state')).controller!.text, isEmpty);
    await tester.enterText(_field('state'), 'Central');
    await _save(tester);
    expect(repository.saves.single, {'country': 'SG', 'state': 'Central'});
  });

  testWidgets('unknown saved country and state are preserved', (tester) async {
    final repository = _Repository(country: 'XX', state: 'Legacy region');
    await _pump(tester, repository);
    expect(find.text('XX'), findsOneWidget);
    expect(
      tester.widget<TextField>(_field('state')).controller!.text,
      'Legacy region',
    );
    await _save(tester);
    expect(repository.saves, isEmpty);
  });

  testWidgets(
    'country load failure allows other edits and retry preserves them',
    (tester) async {
      final repository = _Repository()..failCountries = true;
      final cubit = await _pump(tester, repository);
      expect(cubit.state.status, SellerProfileStatus.loaded);
      expect(
        tester.widget<TextField>(_field('country')).controller!.text,
        'US',
      );
      await tester.enterText(_field('city'), 'Boston');
      repository.failCountries = false;
      await tester.tap(find.byKey(const Key('sellerProfileCountriesRetry')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(_field('city')).controller!.text,
        'Boston',
      );
      expect(find.text('United States'), findsOneWidget);
      await _save(tester);
      expect(repository.saves.single, {'city': 'Boston'});
      expect(repository.countryRequests, 2);
    },
  );

  testWidgets('country loading does not block profile or overwrite edits', (
    tester,
  ) async {
    final repository = _Repository()
      ..pending = Completer<List<SellerCountry>>();
    final cubit = await _pump(tester, repository);
    expect(cubit.state.status, SellerProfileStatus.loaded);
    await tester.enterText(_field('city'), 'Boston');
    await tester.tap(find.byKey(const Key('sellerProfileSave')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(repository.saves.single, {'city': 'Boston'});
    repository.pending!.complete(_countries);
    await tester.pumpAndSettle();
    expect(find.text('United States'), findsOneWidget);
    expect(tester.widget<TextField>(_field('city')).controller!.text, 'Boston');
  });

  test('country completion after leaving profile is ignored', () async {
    final repository = _Repository()
      ..pending = Completer<List<SellerCountry>>();
    final cubit = SellerProfileCubit(repository: repository);
    await cubit.load();
    await cubit.close();
    repository.pending!.complete(_countries);
    await Future<void>.delayed(Duration.zero);
  });
}
