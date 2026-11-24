import 'package:bagisto_flutter/features/account/presentation/bloc/contact_us_cubit.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/contact_us_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestContactUsCubit extends ContactUsCubit {
  _TestContactUsCubit(ContactUsState initialState) {
    emit(initialState);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildWidget({ContactUsCubit? cubit}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ContactUsCubit>.value(
          value: cubit ?? _TestContactUsCubit(const ContactUsState()),
          child: const ContactUsPage(),
        ),
      ),
    );
  }

  testWidgets(
    'marks Name, Email and the message as required, but never the phone number',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final plainTexts = richTexts.map((rt) => rt.text.toPlainText()).toList();

      expect(plainTexts.any((t) => t.contains('Name *')), isTrue);
      expect(plainTexts.any((t) => t.contains('Email *')), isTrue);
      expect(plainTexts.any((t) => t.contains('What’s on your mind? *')), isTrue);
      // The storefront leaves the phone optional, so it carries no asterisk.
      expect(plainTexts.any((t) => t.contains('Phone Number *')), isFalse);
      expect(plainTexts.any((t) => t.contains('Phone Number')), isTrue);
    },
  );

  testWidgets(
    'submitting shows the spinner below the button, with the label unchanged',
    (WidgetTester tester) async {
      final cubit = _TestContactUsCubit(
        const ContactUsState(isSubmitting: true),
      );

      await tester.pumpWidget(buildWidget(cubit: cubit));
      await tester.pump();

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // The storefront keeps the label steady and puts the spinner underneath,
      // rather than swapping the label out for it.
      expect(
        find.descendant(
          of: buttonFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
      expect(
        find.descendant(of: buttonFinder, matching: find.text('Submit')),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
