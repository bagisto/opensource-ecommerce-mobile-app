import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/returns/data/models/shop_return.dart';
import 'package:bagisto_flutter/marketplace/features/returns/data/repository/shop_returns_repository.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/bloc/shop_returns_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/pages/shop_return_create_page.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/pages/shop_returns_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Raising a request when the shopper did not come from an order.
///
/// The storefront's own form starts by asking which order, and only the
/// server knows which orders are still eligible — the return window, the
/// order's status and what has already gone back are all applied there.
class _Returns implements ShopReturnsRepository {
  _Returns({this.orders = const [], this.itemsByOrder = const {}});

  /// What `returnableOrders` answers, before the repository's own filtering.
  final List<ShopReturnableOrder> orders;

  /// The lines each order still allows, keyed by order id.
  final Map<int, List<ShopReturnableItem>> itemsByOrder;

  /// Thrown by the orders read, for the refusal path.
  Object? ordersFailure;

  final asked = <String>[];
  final sent = <Map<String, Object?>>[];

  @override
  Future<List<ShopReturnableOrder>> returnableOrders({
    String? incrementId,
  }) async {
    asked.add('orders:$incrementId');
    if (ordersFailure != null) throw ordersFailure!;

    // The real repository drops what the server reports nothing returnable
    // on, so the fake does the same — the filter is the behaviour under test.
    return [
      for (final order in orders)
        if (order.isReturnable) order,
    ];
  }

  /// This shopper has no requests yet: the list's empty state is where the
  /// way into the form matters most.
  @override
  Future<ShopReturnPage> returns({
    int first = 20,
    String? after,
    int? status,
  }) async => const ShopReturnPage();

  @override
  Future<List<ShopReturnableItem>> returnableItems(int orderId) async {
    asked.add('returnable:$orderId');
    return itemsByOrder[orderId] ?? const [];
  }

  @override
  Future<List<ShopReturnReason>> reasons(String resolutionType) async {
    asked.add('reasons:$resolutionType');
    return const [ShopReturnReason(id: 1, title: 'Manufacturer Defect')];
  }

  @override
  Future<ShopReturn> createReturn({
    required int orderId,
    required int orderItemId,
    required int quantity,
    required String resolutionType,
    required int reasonId,
    String? information,
    String? packageCondition,
  }) async {
    sent.add({
      'orderId': orderId,
      'orderItemId': orderItemId,
      'rmaQty': quantity,
      'resolutionType': resolutionType,
      'rmaReasonId': reasonId,
    });

    return const ShopReturn(id: 7, iri: '/api/shop/returns/7');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

ShopReturnableOrder _order({
  int id = 1,
  String incrementId = 'PW-1',
  String status = 'completed',
  int returnableQty = 2,
}) {
  return ShopReturnableOrder(
    id: id,
    iri: '/api/shop/customer-orders/$id',
    incrementId: incrementId,
    status: status,
    qtyOrdered: 2,
    returnableQty: returnableQty,
  );
}

ShopReturnableItem _item({int orderItemId = 9, int forReturn = 2}) {
  return ShopReturnableItem(
    orderItemId: orderItemId,
    name: 'RMA demo shirt',
    qtyOrdered: 2,
    forReturnQuantity: forReturn,
  );
}

Future<ShopReturnFormCubit> _pumpForm(
  WidgetTester tester,
  _Returns repository, {
  int? orderId,
}) async {
  final cubit = ShopReturnFormCubit(repository: repository, orderId: orderId);
  await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: const ShopReturnCreatePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

/// Brings a field into view before touching it: the form is longer than the
/// test viewport, and a widget that is built but off-screen cannot be tapped.
Future<void> _reveal(WidgetTester tester, Key key) async {
  await tester.dragUntilVisible(
    find.byKey(key),
    find.byType(ListView),
    const Offset(0, -120),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the form opens on the order picker when it was given no order', (
    tester,
  ) async {
    final repo = _Returns(
      orders: [
        _order(),
        _order(id: 2, incrementId: 'PW-2'),
      ],
    );
    await _pumpForm(tester, repo);

    expect(find.byKey(const Key('shopReturnOrder_1')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnOrder_2')), findsOneWidget);
    // Nothing about the request is asked before the order it is against.
    expect(find.byKey(const Key('shopReturnSubmit')), findsNothing);
    expect(repo.asked, ['orders:null']);
  });

  testWidgets('only orders the server still allows are offered', (
    tester,
  ) async {
    // The server reports what is left; an order with nothing returnable
    // cannot be the subject of a request and the create mutation refuses it.
    final repo = _Returns(orders: [_order(), _order(id: 2, returnableQty: 0)]);
    await _pumpForm(tester, repo);

    expect(find.byKey(const Key('shopReturnOrder_1')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnOrder_2')), findsNothing);
  });

  testWidgets('no eligible order says so, and can be asked again', (
    tester,
  ) async {
    final repo = _Returns();
    await _pumpForm(tester, repo);

    expect(find.byKey(const Key('shopReturnNoEligibleOrders')), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopReturnOrdersRetry')));
    await tester.pumpAndSettle();

    expect(repo.asked.where((call) => call == 'orders:null').length, 2);
  });

  testWidgets('picking an order carries it into the request that is sent', (
    tester,
  ) async {
    final repo = _Returns(
      orders: [
        _order(),
        _order(id: 2, incrementId: 'PW-2'),
      ],
      itemsByOrder: {
        2: [_item()],
      },
    );
    await _pumpForm(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnOrder_2')));
    await tester.pumpAndSettle();

    // The order's own lines and the reasons for the default resolution.
    expect(repo.asked, contains('returnable:2'));
    expect(repo.asked, contains('reasons:return'));
    expect(find.byKey(const Key('shopReturnItem_9')), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopReturnItem_9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopReturnReasonPicker')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manufacturer Defect').last);
    await tester.pumpAndSettle();
    await _reveal(tester, const Key('shopReturnAgreement'));
    await tester.tap(find.byKey(const Key('shopReturnAgreement')));
    await tester.pumpAndSettle();
    await _reveal(tester, const Key('shopReturnSubmit'));
    await tester.tap(find.byKey(const Key('shopReturnSubmit')));
    await tester.pumpAndSettle();

    expect(repo.sent.single['orderId'], 2);
    expect(repo.sent.single['orderItemId'], 9);
  });

  testWidgets('the picked order is shown and may be changed', (tester) async {
    final repo = _Returns(
      orders: [
        _order(),
        _order(id: 2, incrementId: 'PW-2'),
      ],
      itemsByOrder: {
        1: [_item()],
      },
    );
    await _pumpForm(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnOrder_1')));
    await tester.pumpAndSettle();

    expect(find.text('Order #PW-1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopReturnChangeOrder')));
    await tester.pumpAndSettle();

    // Back to the picker, on what was already read rather than a fresh call.
    expect(find.byKey(const Key('shopReturnOrder_2')), findsOneWidget);
    expect(repo.asked.where((call) => call == 'orders:null').length, 1);
  });

  testWidgets('a line picked on one order does not follow to another', (
    tester,
  ) async {
    // The ids belong to the order they came from: one left behind would be
    // sent against an order it is not part of, and the server would refuse it.
    final repo = _Returns(
      orders: [
        _order(),
        _order(id: 2, incrementId: 'PW-2'),
      ],
      itemsByOrder: {
        1: [_item()],
        2: [_item(orderItemId: 11)],
      },
    );
    await _pumpForm(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnOrder_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopReturnItem_9')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('shopReturnChangeOrder')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopReturnOrder_2')));
    await tester.pumpAndSettle();

    // The new order's line is offered, and nothing is selected yet: the
    // policy check is reached before anything can be sent.
    expect(find.byKey(const Key('shopReturnItem_11')), findsOneWidget);
    await _reveal(tester, const Key('shopReturnSubmit'));
    await tester.tap(find.byKey(const Key('shopReturnSubmit')));
    await tester.pumpAndSettle();

    expect(repo.sent, isEmpty);
    expect(find.byKey(const Key('shopReturnFormError')), findsOneWidget);
  });

  testWidgets('a form opened on one order skips the picker', (tester) async {
    // From that order's own page: there is nothing to pick from.
    final repo = _Returns(
      itemsByOrder: {
        9: [_item()],
      },
    );
    await _pumpForm(tester, repo, orderId: 9);

    expect(find.byKey(const Key('shopReturnItem_9')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnChangeOrder')), findsNothing);
    expect(repo.asked, isNot(contains('orders:null')));
  });

  testWidgets('an order with nothing left offers another order', (
    tester,
  ) async {
    final repo = _Returns(orders: [_order(id: 2, incrementId: 'PW-2')]);
    await _pumpForm(tester, repo, orderId: 9);

    expect(find.byKey(const Key('shopReturnNothingEligible')), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopReturnChooseAnotherOrder')));
    await tester.pumpAndSettle();

    // The picker had not been read — the form was opened straight on an
    // order — so it is read now rather than showing an empty list.
    expect(repo.asked, contains('orders:null'));
    expect(find.byKey(const Key('shopReturnOrder_2')), findsOneWidget);
  });

  test(
    'a request cannot be raised twice while the first is in flight',
    () async {
      final repo = _Returns(
        itemsByOrder: {
          9: [_item()],
        },
      );
      final cubit = ShopReturnFormCubit(repository: repo, orderId: 9);
      addTearDown(cubit.close);
      await cubit.load();

      await Future.wait([
        cubit.submit(orderItemId: 9, quantity: 1, reasonId: 1),
        cubit.submit(orderItemId: 9, quantity: 1, reasonId: 1),
      ]);

      expect(repo.sent.length, 1);
    },
  );

  test('a request with no order behind it is not sent', () async {
    final repo = _Returns(orders: [_order()]);
    final cubit = ShopReturnFormCubit(repository: repo);
    addTearDown(cubit.close);
    await cubit.load();

    final created = await cubit.submit(
      orderItemId: 9,
      quantity: 1,
      reasonId: 1,
    );

    expect(created, isNull);
    expect(repo.sent, isEmpty);
  });

  testWidgets('the list offers a way to raise a request', (tester) async {
    var raised = 0;
    await _pumpList(tester, _Returns(), onCreateRequest: (_) => raised++);

    await tester.tap(find.byKey(const Key('shopReturnsCreate')));
    await tester.pumpAndSettle();
    expect(raised, 1);

    // A shopper with no requests yet is the one looking for the way in.
    await tester.tap(find.byKey(const Key('shopReturnsCreateEmpty')));
    await tester.pumpAndSettle();
    expect(raised, 2);
  });

  testWidgets('a signed-out shopper is not offered the form', (tester) async {
    await _pumpList(
      tester,
      _Returns(),
      isSignedIn: false,
      onCreateRequest: (_) {},
    );

    expect(find.byKey(const Key('shopReturnsCreate')), findsNothing);
    expect(find.byKey(const Key('shopReturnsSignIn')), findsOneWidget);
  });

  testWidgets('a screen that wires nothing shows no create action', (
    tester,
  ) async {
    await _pumpList(tester, _Returns());

    expect(find.byKey(const Key('shopReturnsCreate')), findsNothing);
    expect(find.byKey(const Key('shopReturnsCreateEmpty')), findsNothing);
  });

  test('a request that cannot be addressed is not offered withdrawal', () {
    // No number and no IRI: there is nothing to send the mutation to, so the
    // row must not offer an action that could only fail.
    expect(const ShopReturn(id: 0).canCancel, isFalse);
    expect(
      const ShopReturn(id: 0, iri: '/api/shop/returns/4').canCancel,
      isTrue,
    );
    expect(const ShopReturn(id: 4).canCancel, isTrue);
    expect(const ShopReturn(id: 4, statusId: 9).canCancel, isFalse);
  });
}

/// The list's own way into the form.
///
/// A shopper reaches a return from their list of requests as well as from an
/// order, and the form asks which order itself.
Future<void> _pumpList(
  WidgetTester tester,
  _Returns repository, {
  bool isSignedIn = true,
  void Function(BuildContext context)? onCreateRequest,
}) async {
  final cubit = ShopReturnsCubit(
    repository: repository,
    isSignedIn: isSignedIn,
  );
  await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: ShopReturnsPage(
          isSignedIn: isSignedIn,
          onCreateRequest: onCreateRequest,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
