import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/features/category/data/models/filter_model.dart';
import 'package:bagisto_flutter/features/category/presentation/widgets/filter_bottom_sheet.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FilterBottomSheet renders color swatches based on color names', (
    WidgetTester tester,
  ) async {
    final colorAttr = FilterAttribute(
      id: 'attr-color',
      code: 'color',
      adminName: 'Color',
      type: 'select',
      options: [
        FilterOption(id: '1', adminName: 'Red', swatchValue: null),
        FilterOption(id: '2', adminName: 'Green', swatchValue: null),
        FilterOption(id: '3', adminName: 'White', swatchValue: null),
      ],
    );

    final selected = <String, Set<String>>{
      'color': {'1', '3'}, // Red and White selected
    };

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FilterBottomSheet(
            filterAttributes: [colorAttr],
            activeFilters: selected,
            onApply: () {},
            onClearAll: () {},
            onToggle: (attr, opt) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify option labels are present
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('White'), findsOneWidget);

    // Find the swatch containers
    final containers = tester.widgetList<Container>(find.byType(Container)).where((c) {
      final decoration = c.decoration;
      if (decoration is BoxDecoration) {
        return decoration.shape == BoxShape.circle &&
            c.constraints?.maxWidth == 44;
      }
      return false;
    }).toList();

    expect(containers.length, 3);

    // Container 1: Red -> Color(0xFFE53935)
    final redDecoration = containers[0].decoration as BoxDecoration;
    expect(redDecoration.color, const Color(0xFFE53935));

    // Container 2: Green -> Color(0xFF43A047)
    final greenDecoration = containers[1].decoration as BoxDecoration;
    expect(greenDecoration.color, const Color(0xFF43A047));

    // Container 3: White -> Color(0xFFFFFFFF)
    final whiteDecoration = containers[2].decoration as BoxDecoration;
    expect(whiteDecoration.color, const Color(0xFFFFFFFF));

    // Check checkmark icons:
    // Red is selected (luminance <= 0.65) -> icon color white
    // White is selected (luminance > 0.65) -> icon color Colors.black87
    final icons = tester.widgetList<Icon>(find.byIcon(Icons.check)).toList();
    expect(icons.length, 2);

    expect(icons[0].color, AppColors.white);
    expect(icons[1].color, Colors.black87);
  });
}
