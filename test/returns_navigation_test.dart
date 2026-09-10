import 'dart:async';

import 'package:bagisto_flutter/core/widgets/app_back_button.dart';
import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/returns_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/returns_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets(
    'a pending cancellation disables actions and ignores duplicate requests',
    (tester) async {
      final gate = Completer<void>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });
      final repository = _ReturnsRepository(
        returns: [_solvedReturn],
        cancelGate: gate.future,
      );
      await _openReturns(tester, repository);
      await tester.tap(find.text('Cancel Request'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final cancelButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Cancel Request'),
      );
      final viewButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'View'),
      );
      expect(cancelButton.onPressed, isNull);
      expect(viewButton.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      tester
          .element(find.byType(ReturnsPage))
          .read<ReturnsBloc>()
          .add(const CancelListedReturn(15));
      await tester.pump();
      expect(repository.cancelCalls, 1);
      gate.complete();
      await tester.pumpAndSettle();
      expect(find.text('Canceled'), findsOneWidget);
      expect(find.text('Cancel Request'), findsNothing);
    },
  );

  testWidgets('View opens a solved return and Cancel asks for confirmation', (
    tester,
  ) async {
    final repository = _ReturnsRepository(returns: [_solvedReturn]);
    await _openReturns(tester, repository);
    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    expect(find.text('Return #15'), findsOneWidget);
    expect(find.text('Reopen Request'), findsNothing);
    await _goBack(tester);
    await tester.tap(find.text('Cancel Request'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Solved'), findsOneWidget);
    expect(repository.cancelCalls, 0);
  });

  testWidgets(
    'canceling a solved return updates the list and enables the allowed reopen flow',
    (tester) async {
      final repository = _ReturnsRepository(returns: [_solvedReturn]);
      await _openReturns(tester, repository);
      await tester.tap(find.text('Cancel Request'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      expect(find.text('Canceled'), findsOneWidget);
      expect(find.text('Cancel Request'), findsNothing);
      expect(find.text('1 Return'), findsOneWidget);
      expect(repository.cancelCalls, 1);
      await tester.tap(find.text('View'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reopen Request'));
      await tester.pumpAndSettle();
      expect(find.text('Pending'), findsOneWidget);
      await _goBack(tester);
      expect(find.text('Pending'), findsOneWidget);
    },
  );

  testWidgets(
    'a rejected list cancellation preserves the return and shows the error',
    (tester) async {
      final repository = _ReturnsRepository(
        returns: [_solvedReturn],
        rejectCancel: true,
      );
      await _openReturns(tester, repository);
      await tester.tap(find.text('Cancel Request'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Solved'), findsOneWidget);
      expect(find.text('Canceled'), findsNothing);
      expect(find.text('Cancel Request'), findsOneWidget);
    },
  );

  for (final initiallyEmpty in [true, false]) {
    testWidgets(
      'creating a return refreshes the ${initiallyEmpty ? 'empty' : 'existing'} list without adding another list route',
      (tester) async {
        final repository = _ReturnsRepository(
          returns: initiallyEmpty ? [] : [_pendingReturn],
        );
        await _openReturns(tester, repository);

        if (initiallyEmpty) {
          await tester.tap(
            find.widgetWithText(ElevatedButton, 'Return Request'),
          );
        } else {
          await tester.tap(find.byTooltip('Return Request'));
        }
        await tester.pumpAndSettle();
        await tester.tap(find.text('#10042'));
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('New returned item'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(DropdownButton<int>));
        await tester.tap(find.byType(DropdownButton<int>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Damaged').last);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Request'));
        await tester.pumpAndSettle();
        expect(find.text('Request Submitted'), findsOneWidget);
        await tester.tap(find.widgetWithText(TextButton, 'OK'));
        await tester.pumpAndSettle();

        expect(find.textContaining('New returned item'), findsOneWidget);
        expect(
          find.text(initiallyEmpty ? '1 Return' : '2 Returns'),
          findsOneWidget,
        );
        await _goBack(tester);
        expect(find.text('Account landing'), findsOneWidget);
        expect(find.byType(ReturnsPage), findsNothing);
      },
    );
  }

  testWidgets('leaving an unfinished request keeps the existing list', (
    tester,
  ) async {
    final repository = _ReturnsRepository(returns: [_pendingReturn]);
    await _openReturns(tester, repository);
    await tester.tap(find.byTooltip('Return Request'));
    await tester.pumpAndSettle();
    await _goBack(tester);
    expect(find.textContaining('Existing returned item'), findsOneWidget);
    expect(find.text('1 Return'), findsOneWidget);
    expect(find.textContaining('New returned item'), findsNothing);
    await _goBack(tester);
    expect(find.text('Account landing'), findsOneWidget);
  });

  for (final scenario in [
    (action: 'Cancel Request', initial: _pendingReturn, status: 'Canceled'),
    (action: 'Mark as Solved', initial: _pendingReturn, status: 'Solved'),
    (action: 'Reopen Request', initial: _canceledReturn, status: 'Pending'),
  ]) {
    testWidgets('${scenario.action} refreshes the status on the returns list', (
      tester,
    ) async {
      final repository = _ReturnsRepository(returns: [scenario.initial]);
      await _openReturns(tester, repository);
      await tester.tap(find.textContaining('Existing returned item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(scenario.action));
      await tester.pumpAndSettle();
      if (scenario.action != 'Reopen Request') {
        await tester.tap(find.widgetWithText(TextButton, 'OK'));
        await tester.pumpAndSettle();
      }
      expect(find.text(scenario.status), findsOneWidget);
      await _goBack(tester);
      expect(find.text(scenario.status), findsOneWidget);
      expect(find.text('1 Return'), findsOneWidget);
    });
  }

  testWidgets(
    'a rejected reopen keeps the canceled status and shows an error',
    (tester) async {
      final repository = _ReturnsRepository(
        returns: [_canceledReturn],
        rejectReopen: true,
      );
      await _openReturns(tester, repository);
      await tester.tap(find.textContaining('Existing returned item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reopen Request'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Canceled'), findsOneWidget);
      expect(find.text('Pending'), findsNothing);
      await _goBack(tester);
      expect(find.text('Canceled'), findsOneWidget);
    },
  );
}

Future<void> _openReturns(
  WidgetTester tester,
  _ReturnsRepository repository,
) async {
  await tester.binding.setSurfaceSize(const Size(430, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    RepositoryProvider<AccountRepository>.value(
      value: repository,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                const Text('Account landing'),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            ReturnsBloc(repository: repository)
                              ..add(const LoadReturns()),
                        child: const ReturnsPage(),
                      ),
                    ),
                  ),
                  child: const Text('Open returns'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open returns'));
  await tester.pumpAndSettle();
}

Future<void> _goBack(WidgetTester tester) async {
  await tester.tap(find.byType(AppBackButton));
  await tester.pumpAndSettle();
}

const _pendingReturn = CustomerReturn(
  id: 15,
  orderId: 42,
  orderIncrementId: '10042',
  statusId: 1,
  statusTitle: 'Pending',
  canClose: true,
  item: ReturnItemInfo(name: 'Existing returned item', quantity: 1),
);

const _canceledReturn = CustomerReturn(
  id: 15,
  orderId: 42,
  orderIncrementId: '10042',
  statusId: 9,
  statusTitle: 'Canceled',
  canReopen: true,
  item: ReturnItemInfo(name: 'Existing returned item', quantity: 1),
);

const _solvedReturn = CustomerReturn(
  id: 15,
  orderId: 42,
  statusId: 6,
  statusTitle: 'Solved',
  item: ReturnItemInfo(name: 'Existing returned item', quantity: 1),
);

// Keep navigation, widgets, and blocs real; replace only the remote repository.
class _ReturnsRepository extends AccountRepository {
  List<CustomerReturn> returns;
  final bool rejectReopen;
  final bool rejectCancel;
  final Future<void>? cancelGate;
  int cancelCalls = 0;

  _ReturnsRepository({
    required this.returns,
    this.rejectReopen = false,
    this.rejectCancel = false,
    this.cancelGate,
  }) : super(
         client: GraphQLClient(
           link: HttpLink('https://example.com/graphql'),
           cache: GraphQLCache(store: InMemoryStore()),
         ),
       );

  @override
  Future<
    ({
      List<CustomerReturn> returns,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerReturns({int first = 20, String? after, int? status}) async => (
    returns: List.of(returns),
    totalCount: returns.length,
    hasNextPage: false,
    endCursor: null,
  );

  @override
  Future<
    ({
      List<CustomerOrder> orders,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerOrders({int first = 20, String? after, String? status}) async => (
    orders: const [
      CustomerOrder(
        numericId: 42,
        incrementId: '10042',
        status: 'completed',
        grandTotal: 20,
      ),
    ],
    totalCount: 1,
    hasNextPage: false,
    endCursor: null,
  );

  @override
  Future<List<ReturnableItem>> getReturnableItems(int orderId) async => const [
    ReturnableItem(
      orderItemId: 81,
      name: 'New returned item',
      qtyOrdered: 1,
      forReturnQuantity: 1,
    ),
  ];

  @override
  Future<List<ReturnReason>> getReturnReasons(String resolutionType) async =>
      const [ReturnReason(id: 3, title: 'Damaged')];

  @override
  Future<CustomerReturn> createReturn({
    required int orderId,
    required int orderItemId,
    required int rmaQty,
    required String resolutionType,
    required int rmaReasonId,
    String? information,
    String? packageCondition,
  }) async {
    final created = CustomerReturn(
      id: 16,
      orderId: orderId,
      statusId: 1,
      statusTitle: 'Pending',
      canClose: true,
      item: ReturnItemInfo(name: 'New returned item', quantity: rmaQty),
    );
    returns = [created, ...returns];
    return created;
  }

  @override
  Future<CustomerReturn> getCustomerReturn(int returnId) async =>
      returns.singleWhere((r) => r.id == returnId);

  @override
  Future<List<ReturnMessage>> getReturnMessages(int returnId) async => const [];

  @override
  Future<CustomerReturn> cancelReturn(int returnId) async {
    cancelCalls++;
    if (cancelGate != null) await cancelGate;
    if (rejectCancel) {
      throw const AccountException('Cancellation is unavailable');
    }
    return _update(_canceledReturn);
  }

  @override
  Future<CustomerReturn> closeReturn(int returnId) async => _update(
    const CustomerReturn(
      id: 15,
      orderId: 42,
      statusId: 6,
      statusTitle: 'Solved',
      item: ReturnItemInfo(name: 'Existing returned item', quantity: 1),
    ),
  );

  @override
  Future<CustomerReturn> reopenReturn(int returnId) async {
    if (rejectReopen) throw const AccountException('Reopening is disabled');
    return _update(_pendingReturn);
  }

  CustomerReturn _update(CustomerReturn updated) {
    returns = [
      for (final r in returns)
        if (r.id == updated.id) updated else r,
    ];
    return updated;
  }
}
