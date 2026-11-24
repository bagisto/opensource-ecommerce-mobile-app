import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/models/seller_settings.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/pages/seller_permissions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A slice of the live tree: `sellerAclPermissions` returns eighty-one of
/// these, four levels deep, with the key carrying the ancestry.
const _permissions = <SellerPermission>[
  (key: 'dashboard', name: 'Dashboard', level: 0),
  (key: 'catalog', name: 'Catalog', level: 0),
  (key: 'catalog.products', name: 'Products', level: 1),
  (key: 'catalog.products.edit', name: 'Edit', level: 2),
  (key: 'catalog.products.delete', name: 'Delete', level: 2),
  (key: 'catalog.products.barcode', name: 'Product Barcode', level: 2),
  (key: 'catalog.products.barcode.print', name: 'Print', level: 3),
];

Future<Set<String>?> _pick(
  WidgetTester tester,
  Set<String> selected,
  Future<void> Function(WidgetTester tester) act,
) async {
  Set<String>? result;

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await Navigator.of(context).push<Set<String>>(
              MaterialPageRoute(
                builder: (_) => SellerPermissionsPage(
                  permissions: _permissions,
                  selected: selected,
                ),
              ),
            );
          },
          child: const Text('open'),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await act(tester);
  await tester.tap(find.byKey(const Key('sellerPermissionsDone')));
  await tester.pumpAndSettle();

  return result;
}

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key('sellerPermission_$key')));
  await tester.pump();
}

void main() {
  testWidgets('it shows the whole tree with what the role already grants', (
    tester,
  ) async {
    await _pick(tester, {'dashboard'}, (tester) async {
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Product Barcode'), findsOneWidget);

      final dashboard = tester.widget<Checkbox>(
        find.byKey(const Key('sellerPermission_dashboard')),
      );
      expect(dashboard.value, isTrue);
    });
  });

  testWidgets('ticking a child also ticks every parent above it', (
    tester,
  ) async {
    // The server walks up the tree, so a child granted without its parents is
    // never reached — the picker sends the whole branch or the grant is a lie.
    final chosen = await _pick(tester, const {}, (tester) async {
      await _tap(tester, 'catalog.products.barcode.print');
    });

    expect(chosen, {
      'catalog.products.barcode.print',
      'catalog.products.barcode',
      'catalog.products',
      'catalog',
    });
  });

  testWidgets('unticking a parent drops everything beneath it', (tester) async {
    final chosen = await _pick(
      tester,
      const {
        'catalog',
        'catalog.products',
        'catalog.products.edit',
        'catalog.products.delete',
        'dashboard',
      },
      (tester) async {
        await _tap(tester, 'catalog.products');
      },
    );

    // Catalog itself stays: it was granted in its own right.
    expect(chosen, {'catalog', 'dashboard'});
  });

  testWidgets('search keeps a match inside its branch', (tester) async {
    await _pick(tester, const {}, (tester) async {
      await tester.enterText(
        find.byKey(const Key('sellerPermissionsSearch')),
        'print',
      );
      await tester.pumpAndSettle();

      expect(find.text('Print'), findsOneWidget);
      // Its ancestors come along, or the row floats with no context.
      expect(find.text('Product Barcode'), findsOneWidget);
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
    });
  });

  testWidgets('the count reflects what is ticked', (tester) async {
    await _pick(tester, const {'dashboard'}, (tester) async {
      expect(find.text('1 selected'), findsOneWidget);

      await _tap(tester, 'catalog.products.edit');
      await tester.pump();

      // Edit plus the two parents it needed.
      expect(find.text('4 selected'), findsOneWidget);
    });
  });

  testWidgets(
    'ticking a parent heading automatically ticks all its sub-headings',
    (tester) async {
      final chosen = await _pick(tester, const {}, (tester) async {
        await _tap(tester, 'catalog');
      });

      expect(chosen, {
        'catalog',
        'catalog.products',
        'catalog.products.edit',
        'catalog.products.delete',
        'catalog.products.barcode',
        'catalog.products.barcode.print',
      });
    },
  );

  testWidgets(
    'ticking a mid-level heading ticks its descendants and its parent',
    (tester) async {
      final chosen = await _pick(tester, const {}, (tester) async {
        await _tap(tester, 'catalog.products');
      });

      expect(chosen, {
        'catalog',
        'catalog.products',
        'catalog.products.edit',
        'catalog.products.delete',
        'catalog.products.barcode',
        'catalog.products.barcode.print',
      });
    },
  );
}

