import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/invoice_detail_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('invoice item uses More info flow for selected options', (
    WidgetTester tester,
  ) async {
    const order = OrderDetail(
      incrementId: '2470',
      status: 'processing',
      grandTotal: 4037,
      subTotal: 4017,
      shippingAmount: 20,
      orderCurrencyCode: 'USD',
      items: [
        OrderItem(
          name: 'Royal Luxe Leather Sofa',
          sku: 'SOFA-001',
          qtyOrdered: 1,
          qtyShipped: 0,
          qtyInvoiced: 1,
          price: 4000,
          total: 4000,
          additional: {
            'attributes': {
              'size': {
                'option_id': 6,
                'option_label': 'S',
                'attribute_name': 'Size',
              },
              'color': {
                'option_id': 3,
                'option_label': 'Yellow',
                'attribute_name': 'Color',
              },
            },
          },
        ),
      ],
    );

    const invoice = OrderInvoice(
      incrementId: '638',
      state: 'processing',
      grandTotal: 4037,
      subTotal: 4017,
      shippingAmount: 20,
      items: [
        OrderInvoiceItem(
          name: 'Royal Luxe Leather Sofa',
          sku: 'SOFA-001',
          qty: 1,
          price: 4000,
          total: 4000,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const InvoiceDetailPage(invoice: invoice, order: order),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('More info'), findsOneWidget);
    expect(find.textContaining('option_label'), findsNothing);
    expect(find.text('Size'), findsNothing);
    expect(find.text('S'), findsNothing);
    expect(find.text('Color'), findsNothing);
    expect(find.text('Yellow'), findsNothing);

    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();

    expect(find.text('Size'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Yellow'), findsOneWidget);
  });
}
