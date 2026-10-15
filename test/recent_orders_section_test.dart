import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/order_detail_page.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/recent_orders_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('tapping a recent order opens it by database id', (
    tester,
  ) async {
    final repository = AccountRepository(
      client: GraphQLClient(
        link: HttpLink('https://example.com/graphql'),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    await tester.pumpWidget(
      RepositoryProvider.value(
        value: repository,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RecentOrdersSection(
              orders: [
                RecentOrder.fromJson(const {
                  'id': '/api/shop/customer-orders/7',
                  '_id': 7,
                  'incrementId': 2,
                  'status': 'pending',
                  'grandTotal': 10,
                }),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('#2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final page = tester.widget<OrderDetailPage>(find.byType(OrderDetailPage));
    expect(page.orderId, 7);
  });
}
