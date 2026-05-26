import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/address_book_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/add_address_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('account add address form shows only one Set as Default toggle', (
    tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Set as Default'), findsOneWidget);
    expect(find.text('Change default shipping address'), findsNothing);
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets(
    'account edit address form also shows only one Set as Default toggle',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          editingAddress: const CustomerAddress(
            id: 'gid://bagisto/Address/42',
            numericId: 42,
            firstName: 'Jane',
            lastName: 'Doe',
            email: 'jane@example.com',
            address: '221B Baker Street',
            city: 'London',
            state: 'LDN',
            country: 'GB',
            zipCode: 'NW16XE',
            phone: '+441234567890',
            isDefault: true,
            useForShipping: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Set as Default'), findsOneWidget);
      expect(find.text('Change default shipping address'), findsNothing);
      expect(find.byType(Switch), findsOneWidget);
    },
  );
}

Widget _buildTestApp({CustomerAddress? editingAddress}) {
  final repository = _FakeAccountRepository();

  return RepositoryProvider<AccountRepository>.value(
    value: repository,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => AddressBookBloc(repository: repository),
        child: AddAddressPage(editingAddress: editingAddress),
      ),
    ),
  );
}

class _FakeAccountRepository extends AccountRepository {
  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<List<Country>> getCountries() async {
    return const [
      Country(id: '1', numericId: 826, code: 'GB', name: 'United Kingdom'),
    ];
  }

  @override
  Future<List<CountryState>> getCountryStates({required int countryId}) async {
    return const [];
  }
}
