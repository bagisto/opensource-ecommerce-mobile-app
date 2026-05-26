import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/default_addresses_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows only the resolved default address without billing or shipping labels',
    (tester) async {
      const addresses = [
        CustomerAddress(
          firstName: 'Billing',
          lastName: 'Address',
          address: 'Street 1',
          city: 'Noida',
          state: 'UP',
          country: 'IN',
          zipCode: '201301',
        ),
        CustomerAddress(
          firstName: 'Primary',
          lastName: 'User',
          address: 'Street 2',
          city: 'Delhi',
          state: 'DL',
          country: 'IN',
          zipCode: '110001',
          isDefault: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: DefaultAddressesSection(addresses: addresses),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Primary User'), findsOneWidget);
      expect(find.text('Billing Address'), findsNothing);
      expect(find.text('Shipping Address'), findsNothing);
      expect(find.text('Default'), findsAtLeastNWidgets(1));
    },
  );
}
