import 'package:bagisto_flutter/features/account/presentation/bloc/contact_us_cubit.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/contact_us_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('required contact fields are marked with an asterisk', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider(
            create: (_) => ContactUsCubit(),
            child: const ContactUsPage(),
          ),
        ),
      ),
    );

    // Same as the storefront: contact is optional, the rest required.
    for (final label in ['Name', 'Email', 'Message']) {
      expect(
        find.text('$label *', findRichText: true),
        findsOneWidget,
        reason: label,
      );
    }
    expect(find.text('Contact *', findRichText: true), findsNothing);
    expect(find.text('Contact', findRichText: true), findsOneWidget);
  });

  testWidgets('contact accepts any storefront-valid phone and may be empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider(
            create: (_) => ContactUsCubit(),
            child: const ContactUsPage(),
          ),
        ),
      ),
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Jo');
    await tester.enterText(fields.at(1), 'jo@example.com');
    await tester.enterText(fields.at(2), '12345');
    await tester.enterText(fields.at(3), 'Hi');

    final form = tester.state<FormState>(find.byType(Form));
    expect(form.validate(), isTrue);

    await tester.enterText(fields.at(2), '');
    expect(form.validate(), isTrue);

    await tester.enterText(fields.at(2), '12-34');
    expect(form.validate(), isFalse);
  });
}
