import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/models/seller_aftersales.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/repository/seller_aftersales_repository.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/bloc/seller_aftersales_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/pages/seller_bookings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Filtering the diary.
///
/// The panel's booking grid filters by booking, order, product, quantity and
/// a date window, and `sellerBookings` takes all of them — verified live, each
/// one narrowing the count on its own. The app asked for none of them: the
/// only narrowing was the list's range bar, and the calendar overwrote that on
/// every week change. `id` and `qty` are the two the endpoint would not take
/// until the server added them.
class _Bookings implements SellerAfterSalesRepository {
  final asked = <Map<String, Object?>>[];

  @override
  Future<PaginatedResult<SellerBooking>> bookings({
    int page = 1,
    String? from,
    String? to,
    int? orderId,
    int? productId,
    int? id,
    int? qty,
  }) async {
    asked.add({
      'from': from,
      'to': to,
      'orderId': orderId,
      'productId': productId,
      'id': id,
      'qty': qty,
    });

    return PaginatedResult(
      items: [
        SellerBooking.fromJson(const {
          'id': 1,
          'from': '2026-08-24T10:00:00+05:30',
          'to': '2026-08-24T11:00:00+05:30',
          'qty': 2,
          'productName': 'Studio Session — 1 Hour',
          'orderIncrementId': '8',
          'customerEmail': 'zed@example.com',
        }),
      ],
      totalCount: 1,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerBookingsCubit> _pump(WidgetTester tester, _Bookings repo) async {
  final cubit = SellerBookingsCubit(repository: repo);
  await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const SellerBookingsPage()),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

void main() {
  test('every filter the endpoint takes reaches it', () async {
    final repo = _Bookings();
    final cubit = SellerBookingsCubit(repository: repo);
    addTearDown(cubit.close);

    await cubit.applyFilters(
      from: '2026-08-01',
      to: '2026-08-31',
      orderId: 8,
      productId: 142,
      id: 1,
      qty: 2,
    );

    expect(repo.asked.last, {
      'from': '2026-08-01',
      'to': '2026-08-31',
      'orderId': 8,
      'productId': 142,
      'id': 1,
      'qty': 2,
    });
    expect(cubit.hasFilters, isTrue);
  });

  test('applying nothing clears what was there', () async {
    final repo = _Bookings();
    final cubit = SellerBookingsCubit(repository: repo);
    addTearDown(cubit.close);

    await cubit.applyFilters(orderId: 8);
    await cubit.applyFilters();

    expect(repo.asked.last, {
      'from': null,
      'to': null,
      'orderId': null,
      'productId': null,
      'id': null,
      'qty': null,
    });
    expect(cubit.hasFilters, isFalse);
  });

  testWidgets('the screen offers the filters', (tester) async {
    final repo = _Bookings();
    await _pump(tester, repo);

    await tester.tap(find.byKey(const Key('sellerBookingsFilters')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sellerBookingsFilterOrder')),
      '8',
    );
    await tester.tap(find.byKey(const Key('sellerBookingsWindowMonth')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerBookingsFilterApply')));
    await tester.pumpAndSettle();

    final asked = repo.asked.last;
    expect(asked['orderId'], 8);
    expect(asked['from'], isNotNull);
    expect(asked['to'], isNotNull);
  });

  testWidgets('date fields are visible above the booking filter actions', (
    tester,
  ) async {
    final repo = _Bookings();
    await _pump(tester, repo);

    await tester.tap(find.byKey(const Key('sellerBookingsFilters')));
    await tester.pumpAndSettle();

    final from = find.byKey(const Key('sellerBookingsFilterFromDate'));
    final to = find.byKey(const Key('sellerBookingsFilterToDate'));
    final clear = find.byKey(const Key('sellerBookingsFilterClear'));

    expect(from, findsOneWidget);
    expect(to, findsOneWidget);
    expect(tester.getTopLeft(from).dy, lessThan(tester.getTopLeft(clear).dy));
    expect(tester.getTopLeft(to).dy, lessThan(tester.getTopLeft(clear).dy));
  });

  testWidgets('clearing goes back to everything', (tester) async {
    final repo = _Bookings();
    final cubit = await _pump(tester, repo);

    await tester.tap(find.byKey(const Key('sellerBookingsFilters')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('sellerBookingsFilterProduct')),
      '142',
    );
    await tester.tap(find.byKey(const Key('sellerBookingsFilterApply')));
    await tester.pumpAndSettle();
    expect(cubit.hasFilters, isTrue);

    await tester.tap(find.byKey(const Key('sellerBookingsFilters')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerBookingsFilterClear')));
    await tester.pumpAndSettle();

    expect(cubit.hasFilters, isFalse);
    expect(repo.asked.last['productId'], isNull);
  });
}
