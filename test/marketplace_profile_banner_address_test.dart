import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/pages/seller_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements SellerAccountRepository {
  _Repository(this.value);
  final SellerProfile value;

  @override
  Future<SellerProfile> profile() async => value;

  @override
  Future<SellerShopInformation?> shopInformation() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<void> _pump(WidgetTester tester, Map<String, dynamic> address) async {
  final profile = SellerProfile.fromJson({
    'name': 'Atlas Outfitters',
    'email': 'seller@example.com',
    'slug': 'atlas-outfitters',
    'isApproved': true,
    'profileAttributes': [
      {'code': 'business_name', 'name': 'Business name', 'type': 'text'},
    ],
    ...address,
  });
  final cubit = SellerProfileCubit(repository: _Repository(profile));
  addTearDown(cubit.close);
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

void main() {
  testWidgets('banner prefers the API full address instead of the slug', (
    tester,
  ) async {
    const address = '77 Granite Way, Denver, ME, 80211, (US)';
    await _pump(tester, {'fullAddress': address, 'address': 'Other street'});
    expect(find.text(address), findsOneWidget);
    expect(find.text('/atlas-outfitters'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('banner falls back to nonempty address components', (
    tester,
  ) async {
    await _pump(tester, {
      'fullAddress': '  ',
      'address': ' 77 Granite Way ',
      'city': 'Denver',
      'state': 'CO',
      'postcode': '80211',
      'country': 'US',
    });
    expect(
      find.text('77 Granite Way, Denver, CO, 80211, (US)'),
      findsOneWidget,
    );
  });

  testWidgets('partial address skips missing components', (tester) async {
    await _pump(tester, {'city': 'Denver', 'state': ' ', 'country': 'US'});
    expect(find.text('Denver, (US)'), findsOneWidget);
  });

  testWidgets('missing address hides the subtitle without restoring slug', (
    tester,
  ) async {
    await _pump(tester, {});
    expect(find.byKey(const Key('sellerProfileBannerAddress')), findsNothing);
    expect(find.text('/atlas-outfitters'), findsNothing);
    expect(find.text('Atlas Outfitters'), findsOneWidget);
  });

  for (final width in [320.0, 390.0, 1024.0]) {
    testWidgets('long address wraps at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final address =
          'Building 123, ${'LongStreetName' * 10}, Downtown, Denver, CO, 80211, (US)';
      await _pump(tester, {'fullAddress': address});
      final finder = find.byKey(const Key('sellerProfileBannerAddress'));
      expect(finder, findsOneWidget);
      final text = tester.widget<Text>(finder);
      expect(text.data, address);
      expect(text.maxLines, isNull);
      expect(text.softWrap, isTrue);
      final bounds = tester.getRect(finder);
      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.right, lessThanOrEqualTo(width));
      expect(bounds.overlaps(tester.getRect(find.text('Approved'))), isFalse);
      expect(tester.takeException(), isNull);
    });
  }
}
