import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/pages/seller_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Saving the profile once showed a white page: the update mutation did not
/// ask for `profileAttributes`, so the profile it returned carried no fields,
/// the tab list came back empty, and a TabBar with no tabs throws. The data
/// had been written, so reopening the screen looked fine and hid the fault.
class _FakeRepository implements SellerAccountRepository {
  _FakeRepository({required this.loaded, required this.afterSave});

  final SellerProfile loaded;

  /// What the update mutation answers with — the shape that caused the crash.
  final SellerProfile afterSave;
  Map<String, dynamic>? sent;

  @override
  Future<SellerProfile> profile() async => loaded;

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async {
    sent = input;
    return afterSave;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

SellerProfile _profile({required bool withFields}) {
  return SellerProfile.fromJson({
    'name': 'Ashif',
    'email': 'seller@example.com',
    'businessName': 'Acme Store',
    if (withFields)
      'profileAttributes': const [
        {
          'code': 'business_name',
          'name': 'Business name',
          'type': 'text',
          'value': 'Acme Store',
        },
        {'code': 'city', 'name': 'City', 'type': 'text', 'value': 'Pune'},
      ],
  });
}

Future<void> _pump(WidgetTester tester, _FakeRepository repository) async {
  final cubit = SellerProfileCubit(repository: repository);
  await cubit.load();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const SellerProfilePage()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Brings the business-name field into view.
///
/// The logo and banner pickers sit above it on the first tab, so in a list
/// that only builds what is on screen the field is no longer reachable by key
/// without scrolling to it first.
Future<void> _revealBusinessName(WidgetTester tester) async {
  await tester.dragUntilVisible(
    find.byKey(const Key('sellerProfileField_business_name')),
    find.byType(ListView).first,
    const Offset(0, -160),
  );
}

void main() {
  testWidgets(
    'a save whose response drops the fields does not blank the page',
    (tester) async {
      // Exactly the old bug: loaded with fields, saved without them.
      final repository = _FakeRepository(
        loaded: _profile(withFields: true),
        afterSave: _profile(withFields: false),
      );
      await _pump(tester, repository);

      expect(find.byType(TabBar), findsOneWidget);

      await _revealBusinessName(tester);
      await tester.enterText(
        find.byKey(const Key('sellerProfileField_business_name')),
        'Acme Store Two',
      );
      await tester.tap(find.byKey(const Key('sellerProfileSave')));
      await tester.pumpAndSettle();

      // The page survives, and says why it has nothing to show.
      expect(tester.takeException(), isNull);
      expect(find.byType(SellerProfilePage), findsOneWidget);
    },
  );

  testWidgets('a save sends only the field that changed', (tester) async {
    final repository = _FakeRepository(
      loaded: _profile(withFields: true),
      afterSave: _profile(withFields: true),
    );
    await _pump(tester, repository);

    await _revealBusinessName(tester);
    await tester.enterText(
      find.byKey(const Key('sellerProfileField_business_name')),
      'Acme Store Two',
    );
    await tester.tap(find.byKey(const Key('sellerProfileSave')));
    await tester.pumpAndSettle();

    // Only the edited field: the untouched ones are not rewritten.
    expect(repository.sent, {'businessName': 'Acme Store Two'});
  });

  testWidgets('pressing save twice sends nothing the second time', (
    tester,
  ) async {
    final repository = _FakeRepository(
      loaded: _profile(withFields: true),
      afterSave: _profile(withFields: true),
    );
    await _pump(tester, repository);

    await _revealBusinessName(tester);
    await tester.enterText(
      find.byKey(const Key('sellerProfileField_business_name')),
      'Acme Store Two',
    );
    await tester.tap(find.byKey(const Key('sellerProfileSave')));
    await tester.pumpAndSettle();
    repository.sent = null;

    await tester.tap(find.byKey(const Key('sellerProfileSave')));
    await tester.pumpAndSettle();

    // Re-seeded from the response, so there is nothing left to write.
    expect(repository.sent, isNull);
  });
}
