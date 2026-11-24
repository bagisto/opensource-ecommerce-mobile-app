import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Map<String, dynamic> json) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SellerProductCard(product: SellerProductListItem.fromJson(json)),
      ),
    ),
  );
}

void main() {
  testWidgets('the card shows what the web grid shows', (tester) async {
    await _pump(tester, {
      'id': '/api/seller/products/720',
      'productId': 750,
      'sku': 'sdsdfsfd',
      'name': 'New',
      'type': 'simple',
      'status': 1,
      'price': 334,
      'quantity': 30,
      'categoryName': 'Shirts',
      'productNumber': 'PN-9',
      'barcodeValue': '123456',
    });

    expect(find.text('New'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('30 Available'), findsOneWidget);
    expect(find.text('ID - 720'), findsOneWidget);
    expect(find.text('Shirts'), findsOneWidget);
    expect(find.text('Product Number: PN-9'), findsOneWidget);
    expect(find.text('123456'), findsOneWidget);
  });

  testWidgets('empty fields read as web does', (tester) async {
    await _pump(tester, {
      'id': '/api/seller/products/719',
      'sku': 'dssdffdfsfd',
      'name': null,
      'type': 'simple',
      'status': 0,
      'quantity': 0,
      'categoryName': ' ',
      'productNumber': null,
      'barcodeValue': null,
      'isDraft': false,
      'approvalState': 'pending',
    });

    expect(find.text('Disable'), findsOneWidget);
    expect(find.text('Waiting For Approval'), findsOneWidget);
    expect(find.text('Out Of Stock'), findsOneWidget);
    expect(find.text('N/A'), findsOneWidget);
    expect(find.text('Not Generated'), findsOneWidget);
    expect(find.text('ID - 719'), findsOneWidget);
    expect(find.text(r'$0.00'), findsOneWidget);
    expect(find.textContaining('Product Number'), findsNothing);
  });

  testWidgets('a draft shows one Draft label, not two', (tester) async {
    await _pump(tester, {
      'id': '/api/seller/products/718',
      'sku': 'dfds',
      'type': 'simple',
      'status': 0,
      'isDraft': true,
    });

    expect(find.text('Draft'), findsOneWidget);
  });
}
