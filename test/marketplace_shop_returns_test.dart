import 'dart:async';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/returns/data/models/shop_return.dart';
import 'package:bagisto_flutter/marketplace/features/returns/data/repository/shop_returns_repository.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/bloc/shop_returns_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/pages/shop_return_create_page.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/pages/shop_return_detail_page.dart';
import 'package:bagisto_flutter/marketplace/features/returns/presentation/pages/shop_returns_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns and cancellations, from the shopper's side.
///
/// The shapes here are the live server's, which differ from the published
/// docs in two places checked against the schema: the create input takes
/// `rmaQty` and `rmaReasonId`, and a request carries one `item`, not `items`.
class _Returns implements ShopReturnsRepository {
  _Returns({
    this.rows = const [],
    this.detail,
    this.thread = const [],
    this.items = const [],
    this.nextPage = const [],
    this.hasNextPage = false,
  });

  final List<ShopReturn> rows;
  final ShopReturn? detail;
  List<ShopReturnMessage> thread;
  final List<ShopReturnableItem> items;

  /// What a cursor read answers, and whether the first page says there is one.
  final List<ShopReturn> nextPage;
  final bool hasNextPage;

  /// Held open to keep one call in flight while the test does something else.
  Completer<void>? pageGate;
  Completer<void>? cancelGate;

  /// Thrown by [cancelReturn], for the refusal path.
  Object? cancelFailure;

  final asked = <String>[];
  final sent = <Map<String, Object?>>[];
  int detailReads = 0;

  @override
  Future<ShopReturnPage> returns({
    int first = 20,
    String? after,
    int? status,
  }) async {
    if (after != null) {
      asked.add('returns:after=$after');
      if (pageGate != null) await pageGate!.future;
      return ShopReturnPage(
        returns: nextPage,
        totalCount: rows.length + nextPage.length,
      );
    }

    asked.add('returns:status=$status');
    return ShopReturnPage(
      returns: rows,
      totalCount: rows.length,
      endCursor: hasNextPage ? 'cursor-1' : null,
      hasNextPage: hasNextPage,
    );
  }

  @override
  Future<ShopReturn> returnDetail(String iri) async {
    detailReads++;
    asked.add('detail:$iri');
    return detail ?? rows.first;
  }

  @override
  Future<List<ShopReturnMessage>> messages(int returnId) async => thread;

  @override
  Future<List<ShopReturnReason>> reasons(String resolutionType) async {
    asked.add('reasons:$resolutionType');
    return resolutionType == 'cancel_items'
        ? const [ShopReturnReason(id: 9, title: 'Changed my mind')]
        : const [ShopReturnReason(id: 1, title: 'Manufacturer Defect')];
  }

  @override
  Future<List<ShopReturnableItem>> returnableItems(int orderId) async {
    asked.add('returnable:$orderId');
    return items;
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
      'information': information,
      'packageCondition': packageCondition,
    });

    return const ShopReturn(id: 7, iri: '/api/shop/returns/7');
  }

  @override
  Future<void> cancelReturn(String iri) async {
    asked.add('cancel:$iri');
    if (cancelGate != null) await cancelGate!.future;
    if (cancelFailure != null) throw cancelFailure!;
  }

  @override
  Future<void> closeReturn(String iri) async => asked.add('close:$iri');

  @override
  Future<void> reopenReturn(String iri) async => asked.add('reopen:$iri');

  @override
  Future<ShopReturnMessage> sendMessage({
    required int returnId,
    required String message,
    String? attachment,
    String? attachmentName,
  }) async {
    asked.add('message:$returnId:$message');
    thread = [
      ...thread,
      ShopReturnMessage(id: thread.length + 1, message: message),
    ];
    return thread.last;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

ShopReturn _request({
  int id = 1,
  String status = 'Pending Review',
  int statusId = 1,
  bool canClose = false,
  bool canReopen = false,
  bool isExpired = false,
  int messagesCount = 0,
  List<String> images = const [],
}) {
  return ShopReturn(
    id: id,
    iri: '/api/shop/returns/$id',
    orderIncrementId: 'PW-3C3N69QQ',
    statusId: statusId,
    statusTitle: status,
    statusColor: 'blue',
    canClose: canClose,
    canReopen: canReopen,
    isExpired: isExpired,
    messagesCount: messagesCount,
    images: images,
    item: const ShopReturnItem(
      orderItemId: 1,
      name: 'Playwright item',
      quantity: 1,
      resolution: 'refund',
      reason: 'Manufacturer Defect',
    ),
    createdAt: '2026-08-13T19:49:38+05:30',
  );
}

Future<ShopReturnsCubit> _pumpList(
  WidgetTester tester,
  _Returns repository, {
  bool isSignedIn = true,
  void Function(BuildContext context, ShopReturn request)? onOpenRequest,
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
          onOpenRequest: onOpenRequest,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

Future<ShopReturnDetailCubit> _pumpDetail(
  WidgetTester tester,
  _Returns repository,
) async {
  final cubit = ShopReturnDetailCubit(
    repository: repository,
    iri: '/api/shop/returns/1',
  );
  await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: const ShopReturnDetailPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

Future<void> _pumpForm(WidgetTester tester, _Returns repository) async {
  final cubit = ShopReturnFormCubit(repository: repository, orderId: 9);
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
}

/// Brings a field into view before touching it.
///
/// The form is longer than the test viewport, and a widget that is built but
/// off-screen cannot be tapped.
Future<void> _reveal(WidgetTester tester, Key key) async {
  await tester.dragUntilVisible(
    find.byKey(key),
    find.byType(ListView),
    const Offset(0, -120),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the list shows the shopper their requests', (tester) async {
    final repo = _Returns(rows: [_request(messagesCount: 2)]);
    await _pumpList(tester, repo);

    expect(find.byKey(const Key('shopReturn_1')), findsOneWidget);
    expect(find.text('Playwright item'), findsOneWidget);
    expect(find.text('Pending Review'), findsOneWidget);
    expect(find.text('Manufacturer Defect'), findsOneWidget);
  });

  testWidgets('a signed-out shopper is asked to sign in, not refused', (
    tester,
  ) async {
    // These are the shopper's own requests, so the endpoint answers only the
    // storefront key with "Unauthorized." Printing the server's word over a
    // Retry that can only fail again is what the messages screen used to do.
    final repo = _Returns(rows: [_request()]);
    await _pumpList(tester, repo, isSignedIn: false);

    expect(find.byKey(const Key('shopReturnsSignIn')), findsOneWidget);
    expect(repo.asked, isEmpty);
  });

  testWidgets('the actions offered are the ones the server allows', (
    tester,
  ) async {
    // canClose and canReopen are resolved by the detail and nowhere else —
    // the listing leaves them null — so they are read, never inferred from
    // the status title.
    final repo = _Returns(detail: _request(canClose: true));
    await _pumpDetail(tester, repo);

    expect(find.byKey(const Key('shopReturnClose')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnCancel')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnReopen')), findsNothing);
  });

  testWidgets('a settled request offers nothing to do', (tester) async {
    final repo = _Returns(
      detail: _request(status: 'Refunded', statusId: 5, isExpired: true),
    );
    await _pumpDetail(tester, repo);

    expect(find.byKey(const Key('shopReturnClose')), findsNothing);
    expect(find.byKey(const Key('shopReturnReopen')), findsNothing);
    expect(find.byKey(const Key('shopReturnExpired')), findsOneWidget);
  });

  testWidgets('a message is sent and the thread re-read', (tester) async {
    final repo = _Returns(detail: _request());
    await _pumpDetail(tester, repo);

    await tester.enterText(
      find.byKey(const Key('shopReturnMessageBox')),
      'Any update please?',
    );
    await tester.tap(find.byKey(const Key('shopReturnMessageSend')));
    await tester.pumpAndSettle();

    expect(repo.asked, contains('message:1:Any update please?'));
    // Re-read afterwards, so the message appears in the order the server kept.
    expect(repo.detailReads, greaterThan(1));
    expect(find.text('Any update please?'), findsOneWidget);
  });

  testWidgets('an order with nothing eligible says so', (tester) async {
    // The server decides: the window, what has already gone back and the
    // product types the operator allows. Checked live — this is the same
    // answer the storefront's own form gives.
    await _pumpForm(tester, _Returns());

    expect(find.byKey(const Key('shopReturnNothingEligible')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnSubmit')), findsNothing);
  });

  testWidgets('the request carries the names the server takes', (tester) async {
    final repo = _Returns(
      items: const [
        ShopReturnableItem(
          orderItemId: 9,
          name: 'RMA demo shirt',
          qtyOrdered: 2,
          forReturnQuantity: 2,
          forCancelQuantity: 0,
        ),
      ],
    );
    await _pumpForm(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnItem_9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopReturnQtyMore')));
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

    expect(repo.sent.single, {
      'orderId': 9,
      'orderItemId': 9,
      'rmaQty': 2,
      'resolutionType': 'return',
      'rmaReasonId': 1,
      'information': '',
      'packageCondition': null,
    });
  });

  testWidgets('the policy has to be accepted before anything is sent', (
    tester,
  ) async {
    final repo = _Returns(
      items: const [
        ShopReturnableItem(orderItemId: 9, name: 'Shirt', forReturnQuantity: 1),
      ],
    );
    await _pumpForm(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnItem_9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopReturnReasonPicker')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manufacturer Defect').last);
    await tester.pumpAndSettle();
    await _reveal(tester, const Key('shopReturnSubmit'));
    await tester.tap(find.byKey(const Key('shopReturnSubmit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shopReturnFormError')), findsOneWidget);
    expect(repo.sent, isEmpty);
  });

  testWidgets('cancelling an item is offered its own lines and reasons', (
    tester,
  ) async {
    // A shipped line can be returned but no longer cancelled, and the two
    // resolutions carry separate reason lists on the server.
    final repo = _Returns(
      items: const [
        ShopReturnableItem(
          orderItemId: 9,
          name: 'Shipped shirt',
          forReturnQuantity: 1,
          forCancelQuantity: 0,
        ),
        ShopReturnableItem(
          orderItemId: 10,
          name: 'Unshipped mug',
          forReturnQuantity: 0,
          forCancelQuantity: 1,
        ),
      ],
    );
    await _pumpForm(tester, repo);

    expect(find.byKey(const Key('shopReturnItem_9')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnItem_10')), findsNothing);

    await tester.tap(find.text('The item cancelled'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shopReturnItem_10')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnItem_9')), findsNothing);
    expect(repo.asked, contains('reasons:cancel_items'));
  });

  testWidgets('a row can be opened or withdrawn without opening it', (
    tester,
  ) async {
    final repo = _Returns(rows: [_request()]);
    var opened = 0;
    await _pumpList(tester, repo, onOpenRequest: (_, _) => opened++);

    await tester.tap(find.byKey(const Key('shopReturnView_1')));
    await tester.pumpAndSettle();
    expect(opened, 1);

    await tester.tap(find.byKey(const Key('shopReturnCancel_1')));
    await tester.pumpAndSettle();

    // Withdrawal cannot be undone from the app, so it is asked about first.
    expect(find.byKey(const Key('shopReturnsCancelConfirm')), findsOneWidget);
    expect(repo.asked, isNot(contains('cancel:/api/shop/returns/1')));

    await tester.tap(find.byKey(const Key('shopReturnsCancelConfirm')));
    await tester.pumpAndSettle();

    expect(repo.asked, contains('cancel:/api/shop/returns/1'));
    // Re-read afterwards: the new status is the marketplace's to decide.
    expect(repo.asked.where((call) => call == 'returns:status=null').length, 2);
    expect(find.text('Request withdrawn'), findsOneWidget);
  });

  testWidgets('declining the question sends nothing', (tester) async {
    final repo = _Returns(rows: [_request()]);
    await _pumpList(tester, repo);

    await tester.tap(find.byKey(const Key('shopReturnCancel_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();

    expect(repo.asked, isNot(contains('cancel:/api/shop/returns/1')));
  });

  testWidgets('a request already withdrawn is not offered it again', (
    tester,
  ) async {
    // The cancelled status keeps the fixed id 9 while its title is an
    // operator's editable label, so the id decides.
    final repo = _Returns(
      rows: [_request(status: 'Request Cancelled', statusId: 9)],
    );
    await _pumpList(tester, repo, onOpenRequest: (_, _) {});

    expect(find.byKey(const Key('shopReturnView_1')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnCancel_1')), findsNothing);
  });

  test('a withdrawal in flight cannot be sent a second time', () async {
    final repo = _Returns(rows: [_request()])..cancelGate = Completer<void>();
    final cubit = ShopReturnsCubit(repository: repo);
    addTearDown(cubit.close);
    await cubit.load();

    final first = cubit.cancelRequest(cubit.state.returns.single);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.isCanceling(1), isTrue);

    // The row is already working, so the second tap is refused here rather
    // than by the server.
    expect(await cubit.cancelRequest(cubit.state.returns.single), isFalse);
    expect(repo.asked.where((call) => call.startsWith('cancel:')).length, 1);

    repo.cancelGate!.complete();
    expect(await first, isTrue);
    expect(cubit.state.isCanceling(1), isFalse);
  });

  test(
    'a refused withdrawal leaves the list in place with its reason',
    () async {
      final repo = _Returns(rows: [_request()])
        ..cancelFailure = Exception('Return could not be cancelled');
      final cubit = ShopReturnsCubit(repository: repo);
      addTearDown(cubit.close);
      await cubit.load();

      expect(await cubit.cancelRequest(cubit.state.returns.single), isFalse);

      expect(cubit.state.status, ShopReturnsStatus.ready);
      expect(cubit.state.returns, hasLength(1));
      expect(cubit.state.errorMessage, isNotNull);
      // Off the working set, so the row can simply be tried again.
      expect(cubit.state.isCanceling(1), isFalse);
    },
  );

  test('a page that lands after a refresh is dropped, not appended', () async {
    final repo = _Returns(
      rows: [_request()],
      nextPage: [_request(id: 2)],
      hasNextPage: true,
    )..pageGate = Completer<void>();
    final cubit = ShopReturnsCubit(repository: repo);
    addTearDown(cubit.close);
    await cubit.load();

    final page = cubit.loadMore();
    await Future<void>.delayed(Duration.zero);
    await cubit.load();

    repo.pageGate!.complete();
    await page;

    // The second page belongs to the sequence the refresh threw away.
    expect(cubit.state.returns.map((row) => row.id), [1]);
    expect(cubit.state.isLoadingMore, isFalse);
    expect(cubit.state.hasNextPage, isTrue);
  });

  testWidgets('what was sent with a request is shown on it', (tester) async {
    final repo = _Returns(
      detail: _request(images: const ['https://example.test/box.jpg']),
      thread: const [
        ShopReturnMessage(
          id: 4,
          message: 'Here is the box',
          attachmentUrl: 'https://example.test/note.jpg',
        ),
      ],
    );
    await _pumpDetail(tester, repo);

    expect(find.byKey(const Key('shopReturnImages')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnImage_0')), findsOneWidget);
    expect(find.byKey(const Key('shopReturnAttachment_4')), findsOneWidget);
  });
}
