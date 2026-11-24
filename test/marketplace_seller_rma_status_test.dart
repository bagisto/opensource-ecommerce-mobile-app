import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/widgets/seller_aftersales_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sellerRmaOrderStatus maps statuses correctly matching Web', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const Placeholder();
          },
        ),
      ),
    );

    // Canceled orders render "Canceled" with red badge (#dc2626)
    final (canceledLabel, canceledColor) = sellerRmaOrderStatus(
      l10n,
      'canceled',
    );
    expect(canceledLabel, l10n.sellerLblStatusCanceled);
    expect(canceledColor, '#dc2626');

    // Completed orders render "Delivered" with green badge (#16a34a)
    final (completedLabel, completedColor) = sellerRmaOrderStatus(
      l10n,
      'completed',
    );
    expect(completedLabel, l10n.sellerReturnDelivered);
    expect(completedColor, '#16a34a');

    // Pending / processing orders render "Undelivered" with gray/neutral badge (#64748b)
    final (pendingLabel, pendingColor) = sellerRmaOrderStatus(
      l10n,
      'pending',
    );
    expect(pendingLabel, l10n.sellerReturnUndelivered);
    expect(pendingColor, '#64748b');
  });
}
