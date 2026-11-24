@Tags(['live'])
library;

import 'dart:io';

import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/repository/seller_aftersales_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/data/repository/seller_catalogue_tools_repository.dart';
import 'package:bagisto_flutter/marketplace/features/communications/data/repository/seller_communication_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/plans/data/repository/seller_plan_repository.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_marketing.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_bulk_ops_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_marketing_repository.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/repository/seller_earnings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/repository/seller_order_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/repository/seller_settings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercises the real seller API with the app's own repositories.
///
/// Skipped by default because it needs the marketplace host to be reachable.
/// Run it with:
///
///   SELLER_EMAIL=... SELLER_PASSWORD=... flutter test --tags live \
///     test/marketplace_live_smoke_test.dart
void main() {
  final email = Platform.environment['SELLER_EMAIL'];
  final password = Platform.environment['SELLER_PASSWORD'];
  final credentialsMissing = email == null || password == null;

  // flutter_test installs an HttpOverrides that answers every request with 400.
  // This test is the one place that must reach the real server.
  setUpAll(() => HttpOverrides.global = null);

  test(
    'signs in, then reads profile, permissions, dashboard and products',
    () async {
      final authRepository = SellerAuthRepository(
        client: GraphQLClientProvider.buildSellerClient(),
      );

      final login = await authRepository.login(
        email: email!,
        password: password!,
      );
      expect(login.token, isNotNull);

      final client = GraphQLClientProvider.buildSellerClient(
        token: login.token,
      );

      final profile = await SellerAccountRepository(client: client).profile();
      expect(profile.email, email);

      final permissions = await SellerAccountRepository(
        client: client,
      ).permissions();
      expect(permissions.keys, isNotEmpty);

      final dashboard = await SellerDashboardRepository(client: client).load();
      expect(dashboard.dateRange, isNotEmpty);

      final products = SellerProductRepository(client: client);
      final page = await products.list();
      expect(
        page.items,
        isNotEmpty,
        reason: 'run tool/marketplace_seed/seed.sh',
      );
      expect(page.totalCount, greaterThan(0));

      // The IRI the listing returned must work verbatim on the detail call.
      final detail = await products.detail(page.items.first.iri);
      expect(detail.sku, page.items.first.sku);
      expect(detail.productId, page.items.first.productId);

      final filtered = await products.list(
        filters: SellerProductFilters(search: page.items.first.sku),
      );
      expect(filtered.items.map((item) => item.sku), contains(detail.sku));

      // Write round-trip: create a throwaway product, fill it in, delete it.
      // The catalogue must end the test exactly as it started.
      final startingCount = page.totalCount;
      final sku = 'smoke-${DateTime.now().millisecondsSinceEpoch}';

      final created = await products.create(
        type: 'simple',
        attributeFamilyId: 1,
        sku: sku,
      );
      expect(created.sku, sku);

      final loaded = await products.detail(created.iri);
      final updated = await products.update(
        SellerProductDraft.fromDetail(
          loaded,
        ).copyWith(name: 'Live smoke product', price: 42.5),
      );
      expect(updated.name, 'Live smoke product');
      expect(updated.price, 42.5);

      await products.delete(created.iri);

      final afterDelete = await products.list();
      expect(afterDelete.totalCount, startingCount);
      expect(afterDelete.items.map((item) => item.sku), isNot(contains(sku)));

      // Orders: read the real order the storefront placed, and the carriers
      // the shipment form depends on.
      final orders = SellerOrderRepository(client: client);
      final orderPage = await orders.list();
      expect(orderPage.totalCount, greaterThan(0));

      final orderDetail = await orders.detail(orderPage.items.first.id);
      expect(orderDetail.items, isNotEmpty);
      expect(
        orderDetail.summary.incrementId,
        orderPage.items.first.incrementId,
      );

      final carriers = await orders.carriers();
      expect(carriers, isNotEmpty);
      expect(carriers.map((carrier) => carrier.code), contains('manual'));

      // Earnings: the money summary, the payout history, and one report in
      // both shapes.
      final earnings = SellerEarningsRepository(client: client);

      final payouts = await earnings.statistics();
      expect(payouts.currency, isNotEmpty);
      expect(payouts.formattedRemainingPayout, isNotEmpty);
      // Commission plus the seller's share is the whole sale, to the cent.
      expect(
        payouts.totalSellerSale + payouts.totalCommission,
        closeTo(payouts.totalSale, 0.01),
      );

      // Empty is a valid answer here: payouts are the admin's move.
      await earnings.transactions();

      final reportTypes = await earnings.reportTypes();
      expect(reportTypes, isNotEmpty);
      expect(reportTypes.map((type) => type.type), contains('total-sales'));

      final graph = await earnings.report(type: 'total-sales');
      expect(graph.headline, isNotNull);
      expect(graph.overTime, isNotEmpty);

      final table = await earnings.report(type: 'total-sales', format: 'table');
      expect(table.columns, isNotEmpty);
      expect(table.records, isNotEmpty);
      expect(table.exportUrl, isNotNull);

      // Catalogue tools: what the seller could sell, barcodes, Magic AI.
      final tools = SellerCatalogueToolsRepository(client: client);

      final assignable = await tools.assignableProducts();
      expect(assignable.items, isNotEmpty);
      // These carry core product ids, which is what assigning wants.
      expect(assignable.items.first.productId, greaterThan(0));

      final existing = await products.list();
      final catalogueId = existing.items.first.iri.numericId;

      final generated = await tools.generateBarcode(
        catalogueId,
        type: 'code128',
      );
      expect(generated.isGenerated, isTrue);
      expect(generated.type, 'code128');
      // The inline PNG is what the app draws; the stored image is an SVG.
      expect(generated.image, startsWith('data:image/png;base64,'));

      final reread = await tools.barcode(catalogueId);
      expect(reread.value, generated.value);

      final batch = await tools.generateBarcodes([catalogueId]);
      expect(batch.requested, 1);
      expect(batch.results.single.didGenerate, isTrue);

      final printed = await tools.printBarcodes([catalogueId]);
      expect(printed.printable, 1);
      expect(printed.downloadUrl, isNotNull);

      // Magic AI may be switched off marketplace-wide; either answer is
      // valid, but the context must say which.
      final magicAi = await tools.magicAiContext(catalogueId);
      expect(magicAi.productId, greaterThan(0));
      if (!magicAi.enabled) expect(magicAi.disabledReason, isNotNull);

      // After-sales: returns, bookings, customers and reviews.
      final afterSales = SellerAfterSalesRepository(client: client);

      final statuses = await afterSales.returnStatuses();
      expect(statuses, isNotEmpty);
      // Two statuses carry side effects, and the app confirms before either.
      expect(statuses.any((status) => status.refunds), isTrue);
      expect(statuses.any((status) => status.cancels), isTrue);
      expect(statuses.first.color, startsWith('#'));

      // No returns or bookings need exist; the shape is what matters.
      await afterSales.returns();
      await afterSales.bookings();

      final buyers = await afterSales.customers();
      expect(buyers.items, isNotEmpty, reason: 'a demo order must exist');
      expect(buyers.items.first.orderCount, greaterThan(0));

      await afterSales.productReviews();

      final shopReviews = await afterSales.shopReviews();
      expect(shopReviews.items, isNotEmpty, reason: 'seed a shop review');
      expect(shopReviews.items.first.rating, inInclusiveRange(1, 5));
      expect(shopReviews.items.first.productId, isNull);

      // Marketing: a catalog rule round-trip, and the campaigns on offer.
      final marketing = SellerMarketingRepository(client: client);

      final rule = await marketing.createProductDiscount(
        SellerProductDiscount(
          id: 0,
          name: 'Smoke discount $sku',
          status: false,
          actionType: SellerDiscountAction.byPercent,
          discountAmount: 5,
          channels: const [1],
          customerGroups: const [1, 2, 3],
        ),
      );
      expect(rule.id, greaterThan(0));
      expect(rule.amountLabel, '5%');

      final rules = await marketing.productDiscounts();
      expect(rules.items.map((item) => item.id), contains(rule.id));

      await marketing.deleteProductDiscount(rule.id);

      final campaigns = await marketing.joinableDiscounts();
      expect(campaigns.totalCount, greaterThanOrEqualTo(0));

      // A cart rule with a fixed code, then a copy of it, then both gone.
      final deal = await marketing.createCheckoutDeal(
        SellerCheckoutDeal(
          id: 0,
          name: 'Smoke deal $sku',
          status: false,
          actionType: SellerDiscountAction.byFixed,
          discountAmount: 25,
          needsCoupon: true,
          couponCode: 'SMOKE${DateTime.now().millisecondsSinceEpoch}',
          channels: const [1],
          customerGroups: const [1, 2, 3],
        ),
      );
      expect(deal.couponCode, isNotNull);

      final copy = await marketing.copyCheckoutDeal(deal.id);
      expect(copy.name, startsWith('Copy of'));
      // A copy always arrives switched off, whatever the original was.
      expect(copy.status, isFalse);

      await marketing.deleteCheckoutDeal(copy.id);
      await marketing.deleteCheckoutDeal(deal.id);

      // Bulk saves: these inline their payload, so this is the check that the
      // workaround still matches the server.
      final bulk = SellerBulkOpsRepository(client: client);
      final stockSources = await SellerInventorySourceRepository(
        client: client,
      ).list();
      expect(stockSources.items, isNotEmpty);
      final target = existing.items.firstWhere(
        (item) => item.productId != null,
      );
      final coreId = target.productId!;

      final priced = await bulk.savePrices([
        SellerPriceEdit(productId: coreId, price: target.price ?? 10),
      ]);
      expect(priced.saved, 1);
      expect(priced.results.single.didSave, isTrue);

      final stocked = await bulk.saveStock([
        SellerStockEdit(
          productId: coreId,
          quantities: {stockSources.items.first.id: target.quantity ?? 0},
        ),
      ]);
      expect(stocked.saved, 1);

      // Bulk upload: the job list and the starter spreadsheets.
      await bulk.imports();

      final samples = await bulk.importSamples();
      expect(samples, isNotEmpty);
      expect(samples.first.csvUrl, isNotNull);

      // Settings, staff, roles and the account-health scorecard.
      final settingsRepository = SellerSettingsRepository(client: client);

      final settings = await settingsRepository.settings();
      expect(settings.availableLocales, isNotEmpty);
      expect(settings.currency, isNotNull);

      // A seller with no staff is normal; the shape is what matters.
      await settingsRepository.users();
      await settingsRepository.roles();

      final health = await settingsRepository.accountHealth();
      expect(health.metrics, isNotEmpty);
      expect(health.metrics.first.status, isNotNull);

      // The buyer side goes through the shop endpoint with the storefront
      // key, not the seller endpoint.
      final shop = ShopMarketplaceRepository(
        client: GraphQLClientProvider.buildClient(),
      );

      final directory = await shop.sellers();
      expect(directory.items, isNotEmpty);

      // The seller signed in above, seen from the shop side.
      final mine = directory.items.firstWhere(
        (candidate) => candidate.businessName == profile.businessName,
        orElse: () => directory.items.first,
      );

      final shopPage = await shop.seller(mine.slug);
      expect(shopPage.slug, mine.slug);
      expect(shopPage.businessName, isNotEmpty);

      final shopProducts = await shop.sellerProducts(slug: mine.slug);
      expect(shopProducts.totalCount, greaterThanOrEqualTo(0));

      await shop.sellerReviews(slug: mine.slug);

      final reasons = await shop.flagReasons(type: 'seller');
      expect(reasons, isNotEmpty);
      expect(reasons.first.type, 'seller');

      // The seller's inbox: one thread with the admin, one per customer.
      final inbox = SellerCommunicationRepository(client: client);

      final adminThread = await inbox.adminThread();
      expect(adminThread.messages, isNotNull);

      // No customers may have written yet; the shape is what matters.
      await inbox.customerThreads();

      // Courier collections, and the plan the marketplace puts this seller on.
      final plans = SellerPlanRepository(client: client);
      await plans.pickups();

      // Subscriptions can be switched off marketplace-wide, which is a state
      // to report rather than a failure.
      try {
        await plans.plans();
      } on SellerApiException catch (error) {
        expect(SellerPlanRepository.isSubscriptionsDisabled(error), isTrue);
      }
    },
    skip: credentialsMissing
        ? 'set SELLER_EMAIL and SELLER_PASSWORD to run the live smoke test'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
