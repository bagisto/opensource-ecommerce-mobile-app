import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/models/seller_aftersales.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/repository/seller_aftersales_repository.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/pages/seller_reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Reviews extends Fake implements SellerAfterSalesRepository {
  final calls = <String>[];
  bool fail = false;
  bool empty = false;

  Future<PaginatedResult<SellerReview>> _fetch(String type, int page) async {
    calls.add('$type:$page');
    if (fail) {
      throw const SellerApiException(
        'Review load failed',
        SellerApiFailure.unknown,
      );
    }
    return PaginatedResult(
      items: empty
          ? []
          : [SellerReview(id: 1, rating: 5, title: '$type review')],
      totalCount: empty ? 0 : 1,
      currentPage: 1,
      lastPage: 1,
    );
  }

  @override
  Future<PaginatedResult<SellerReview>> productReviews({int page = 1}) =>
      _fetch('product', page);

  @override
  Future<PaginatedResult<SellerReview>> shopReviews({int page = 1}) =>
      _fetch('shop', page);
}

Future<void> _pumpPage(
  WidgetTester tester,
  _Reviews repository,
  int tab,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SellerReviewsPage(repository: repository, initialTab: tab),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final (tab, type, title) in [
    (0, 'product', 'Product reviews'),
    (1, 'shop', 'Shop reviews'),
  ]) {
    testWidgets('$type page shows only its selected list without tabs', (
      tester,
    ) async {
      final repository = _Reviews();
      await _pumpPage(tester, repository, tab);
      expect(find.text(title), findsOneWidget);
      expect(find.byType(TabBar), findsNothing);
      expect(find.byType(TabBarView), findsNothing);
      expect(find.text('$type review'), findsOneWidget);
      expect(repository.calls, ['$type:1']);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(repository.calls, ['$type:1']);
    });

    testWidgets('$type refresh reloads only its own endpoint', (tester) async {
      final repository = _Reviews();
      await _pumpPage(tester, repository, tab);
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      expect(repository.calls, ['$type:1', '$type:1']);
      expect(find.text('$type review'), findsOneWidget);
    });

    testWidgets('$type retry and empty state remain available', (tester) async {
      final repository = _Reviews()..fail = true;
      await _pumpPage(tester, repository, tab);
      expect(find.text('Review load failed'), findsOneWidget);
      repository
        ..fail = false
        ..empty = true;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(repository.calls, ['$type:1', '$type:1']);
      final context = tester.element(find.byType(SellerReviewsPage));
      expect(
        find.text(AppLocalizations.of(context)!.sellerReviewsEmpty),
        findsOneWidget,
      );
    });
  }
}
