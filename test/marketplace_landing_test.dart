import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/marketplace_landing_content.dart';
import 'package:bagisto_flutter/marketplace/marketplace_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The marketplace front door must open for anyone.
///
/// Before this page existed the seller panel sat behind the customer account
/// menu, so a seller who was not also a shopper could not sign in at all.
Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

/// Builds the page.
///
/// It settles immediately, which is the point: the front door makes no
/// request, so nothing on it waits on the network.
Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    _wrap(MarketplaceLandingPage(loadLive: () async => null)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the landing page offers to open a store with nobody signed in', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.byKey(const Key('marketplaceLandingSell')), findsOneWidget);
    expect(find.text('Open Store'), findsOneWidget);
  });

  testWidgets(
    'a sign-in link sits below Open Store for a visitor who already has an account',
    (tester) async {
      await _pump(tester);

      expect(find.byKey(const Key('marketplaceLandingSignIn')), findsOneWidget);
      expect(find.text('Already have an account? Sign In'), findsOneWidget);
    },
  );

  testWidgets('it says what the seller panel will do for them', (tester) async {
    await _pump(tester);

    await tester.dragUntilVisible(
      find.text('Why sell with us?'),
      find.byType(ListView),
      const Offset(0, -280),
    );

    expect(find.text('Why sell with us?'), findsOneWidget);
    expect(find.text('Orders end to end'), findsOneWidget);
  });

  testWidgets('it claims nothing it would have to fetch to know', (
    tester,
  ) async {
    await _pump(tester);

    // No seller or product count: the front door renders without a request,
    // and a number fetched for decoration is not worth a page that waits.
    expect(find.textContaining('1,000'), findsNothing);
    expect(find.textContaining('sellers'), findsNothing);
  });

  testWidgets('it also offers the shopping side', (tester) async {
    await _pump(tester);

    // Below the pitch, so the list is scrolled before looking.
    await tester.dragUntilVisible(
      find.text('Browse sellers'),
      find.byType(ListView),
      const Offset(0, -300),
    );

    expect(find.text('Browse sellers'), findsOneWidget);
    expect(find.text('Messages from sellers'), findsOneWidget);
  });

  testWidgets('no customer login is asked for anywhere on it', (tester) async {
    await _pump(tester);

    expect(find.textContaining('Login', findRichText: true), findsNothing);
    expect(find.textContaining('Sign up'), findsNothing);
  });

  testWidgets('Featured Sellers is not drawn until the server says it is on', (
    tester,
  ) async {
    await _pump(tester);
    // Nothing cached and nothing live: no section, and no spinner flash.
    expect(find.text('Our Featured Sellers'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Featured Sellers off on the server keeps the section hidden', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MarketplaceLandingPage(
          loadLive: () async => const MarketplaceLandingContent(
            featuredSellersEnabled: false,
            sellersShownPublicly: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Our Featured Sellers'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Show Publicly off hides the section even when featured is on', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MarketplaceLandingPage(
          loadLive: () async => const MarketplaceLandingContent(
            featuredSellersEnabled: true,
            sellersShownPublicly: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Our Featured Sellers'), findsNothing);
  });
}
