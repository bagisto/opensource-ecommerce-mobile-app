import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_customizable_option.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_customizable_options_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestableWidget({
  required List<SellerCustomizableOption> initial,
  required ValueChanged<List<SellerCustomizableOption>> onChanged,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: Scaffold(
      body: SingleChildScrollView(
        child: SellerCustomizableOptionsEditor(
          initial: initial,
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders empty state and opens option dialog', (tester) async {
    await tester.pumpWidget(
      _buildTestableWidget(
        initial: const [],
        onChanged: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CUSTOMIZABLE ITEM'), findsOneWidget);
    expect(find.byKey(const Key('sellerCustomizableAdd')), findsOneWidget);
    expect(find.byKey(const Key('sellerCustomizableAddEmpty')), findsOneWidget);

    // Open Add Option dialog
    await tester.tap(find.byKey(const Key('sellerCustomizableAddEmpty')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sellerCustomizableTitle')), findsOneWidget);
    expect(find.text('Title *'), findsOneWidget);
    expect(find.text('Type *'), findsOneWidget);
    expect(find.text('Is Required *'), findsOneWidget);

    // For default 'select' (choice type), no max characters or price fields
    expect(find.byKey(const Key('sellerCustomizableMaxCharacters')), findsNothing);
    expect(find.byKey(const Key('sellerCustomizablePrice')), findsNothing);
    expect(find.byKey(const Key('sellerCustomizableExtensions')), findsNothing);
  });

  testWidgets('shows Title required validation when saving empty title', (tester) async {
    await tester.pumpWidget(
      _buildTestableWidget(
        initial: const [],
        onChanged: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sellerCustomizableAdd')));
    await tester.pumpAndSettle();

    // Tap Save without entering title
    await tester.tap(find.byKey(const Key('sellerCustomizableSave')));
    await tester.pumpAndSettle();

    expect(find.text('The Title field is required.'), findsOneWidget);
  });

  testWidgets('dynamically shows Max Characters * and Price * for text type and validates', (tester) async {
    List<SellerCustomizableOption> updated = [];
    await tester.pumpWidget(
      _buildTestableWidget(
        initial: const [],
        onChanged: (val) => updated = val,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sellerCustomizableAdd')));
    await tester.pumpAndSettle();

    // Select 'Text' from dropdown
    await tester.tap(find.byKey(const Key('sellerCustomizableType_select')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Text').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sellerCustomizableMaxCharacters')), findsOneWidget);
    expect(find.text('Max Characters *'), findsOneWidget);
    expect(find.byKey(const Key('sellerCustomizablePrice')), findsOneWidget);
    expect(find.text('Price *'), findsOneWidget);

    // Enter title only
    await tester.enterText(find.byKey(const Key('sellerCustomizableTitle')), 'Custom Note');
    await tester.tap(find.byKey(const Key('sellerCustomizableSave')));
    await tester.pumpAndSettle();

    // Max characters is required
    expect(find.text('The Max Characters field is required.'), findsOneWidget);

    // Enter max characters
    await tester.enterText(find.byKey(const Key('sellerCustomizableMaxCharacters')), '50');
    await tester.tap(find.byKey(const Key('sellerCustomizableSave')));
    await tester.pumpAndSettle();

    // Modal closed and option added
    expect(find.text('1. Custom Note - Text *'), findsOneWidget);
    // Non-choice options do not show Max characters detail row on the card (matching web)
    expect(find.textContaining('Max characters'), findsNothing);
    expect(find.text(r'$0.00'), findsOneWidget);
    expect(updated, hasLength(1));
    expect(updated.first.label, 'Custom Note');
    expect(updated.first.type, 'text');
    expect(updated.first.maxCharacters, 50);
  });

  testWidgets('choice options allow adding and editing choices via _ChoiceDialog', (tester) async {
    List<SellerCustomizableOption> updated = [];
    const initialOption = SellerCustomizableOption(
      id: 1,
      label: 'Size',
      type: 'select',
      isRequired: true,
      prices: [],
    );

    await tester.pumpWidget(
      _buildTestableWidget(
        initial: const [initialOption],
        onChanged: (val) => updated = val,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1. Size - Select *'), findsOneWidget);
    expect(find.byKey(const Key('sellerCustomizableAddChoice_0')), findsOneWidget);

    // Open Choice Dialog
    await tester.tap(find.byKey(const Key('sellerCustomizableAddChoice_0')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sellerCustomizableChoiceLabel')), findsOneWidget);
    expect(find.text('Label *'), findsOneWidget);
    expect(find.byKey(const Key('sellerCustomizableChoicePrice')), findsOneWidget);
    expect(find.text('Price *'), findsOneWidget);

    // Validate empty choice label
    await tester.tap(find.byKey(const Key('sellerCustomizableChoiceSave')));
    await tester.pumpAndSettle();
    expect(find.text('The Label field is required.'), findsOneWidget);

    // Fill choice details and save
    await tester.enterText(find.byKey(const Key('sellerCustomizableChoiceLabel')), 'Large');
    await tester.enterText(find.byKey(const Key('sellerCustomizableChoicePrice')), '15.00');
    await tester.tap(find.byKey(const Key('sellerCustomizableChoiceSave')));
    await tester.pumpAndSettle();

    // Choice row is now rendered
    expect(find.text('Large'), findsOneWidget);
    expect(find.text(r'$15.00'), findsOneWidget);
    expect(updated, hasLength(1));
    expect(updated.first.prices, hasLength(1));
    expect(updated.first.prices.first.label, 'Large');
    expect(updated.first.prices.first.price, 15.00);

    // Edit choice
    await tester.tap(find.byKey(const Key('sellerCustomizableEditChoice_0_0')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('sellerCustomizableChoiceLabel')), 'Extra Large');
    await tester.tap(find.byKey(const Key('sellerCustomizableChoiceSave')));
    await tester.pumpAndSettle();

    expect(find.text('Extra Large'), findsOneWidget);
    expect(updated.first.prices.first.label, 'Extra Large');

    // Delete choice
    await tester.tap(find.byKey(const Key('sellerCustomizableDeleteChoice_0_0')));
    await tester.pumpAndSettle();

    expect(find.text('Extra Large'), findsNothing);
    expect(updated.first.prices, isEmpty);
  });
}
