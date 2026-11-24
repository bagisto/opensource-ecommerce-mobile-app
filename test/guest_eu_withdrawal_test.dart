import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/guest_eu_withdrawal_cubit.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/guest_eu_withdrawal_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeRepository extends AccountRepository {
  _FakeRepository({this.error})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  final String? error;
  final calls = <(String, String)>[];

  @override
  Future<GuestEuWithdrawalLinkResponse> createGuestEuWithdrawal({
    required String orderIncrementId,
    required String email,
  }) async {
    calls.add((orderIncrementId, email));
    if (error != null) throw AccountException(error!);
    return const GuestEuWithdrawalLinkResponse(
      success: true,
      message:
          'If the order number and email match a guest order, we have emailed a link to withdraw from it.',
    );
  }
}

Widget _app(_FakeRepository repository) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: BlocProvider(
    create: (_) => GuestEuWithdrawalCubit(repository: repository),
    child: const GuestEuWithdrawalPage(),
  ),
);

void main() {
  testWidgets('guest submits order number and email only', (tester) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(_app(repository));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '1001');
    await tester.enterText(fields.at(1), 'guest@example.com');
    await tester.tap(find.byKey(const ValueKey('guest_eu_withdraw_submit')));
    await tester.pumpAndSettle();

    expect(repository.calls, [('1001', 'guest@example.com')]);
    expect(find.textContaining('emailed a link'), findsOneWidget);
  });

  testWidgets('order number and email are required', (tester) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(_app(repository));

    await tester.tap(find.byKey(const ValueKey('guest_eu_withdraw_submit')));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(2));
    expect(repository.calls, isEmpty);
  });

  testWidgets('server errors are shown', (tester) async {
    final repository = _FakeRepository(error: 'Order not found.');
    await tester.pumpWidget(_app(repository));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '9');
    await tester.enterText(fields.at(1), 'guest@example.com');
    await tester.tap(find.byKey(const ValueKey('guest_eu_withdraw_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Order not found.'), findsOneWidget);
  });
}
