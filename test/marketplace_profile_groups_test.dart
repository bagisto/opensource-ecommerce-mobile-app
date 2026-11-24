import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/pages/seller_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// The profile form follows the admin's own groups and order, as the web
/// profile page does, instead of the app's built-in tab list.
class _Repository implements SellerAccountRepository {
  _Repository(this.value, {this.info});
  final SellerProfile value;
  final SellerShopInformation? info;

  @override
  Future<SellerProfile> profile() async => value;

  @override
  Future<SellerShopInformation?> shopInformation() async => info;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Map<String, dynamic> _attr(
  String code,
  String group,
  String label,
  int groupPosition,
  int position, {
  bool required = false,
}) => {
  'code': code,
  'name': code.toUpperCase(),
  'type': 'text',
  'value': '',
  'group': {'code': group, 'label': label},
  'groupPosition': groupPosition,
  'position': position,
  'isRequired': required,
  'isTranslatable': false,
};

Future<void> _pump(
  WidgetTester tester,
  List<Map<String, dynamic>> attributes, {
  SellerShopInformation? info,
}) async {
  final profile = SellerProfile.fromJson({
    'name': 'Atlas',
    'email': 'seller@example.com',
    'isApproved': true,
    'profileAttributes': attributes,
  });
  final cubit = SellerProfileCubit(
    repository: _Repository(profile, info: info),
  );
  addTearDown(cubit.close);
  await cubit.load();
  await tester.pump();
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
  testWidgets('tabs use the admin group labels in the admin order', (
    tester,
  ) async {
    await _pump(tester, [
      // Listed out of order on purpose: groupPosition decides.
      _attr('facebook', 'social_links', 'Social Links', 3, 1),
      _attr('name', 'general', 'General', 1, 1),
      _attr('vat_number', 'tax_details', 'Tax Details', 2, 1),
    ]);

    final labels = tester
        .widgetList<Tab>(find.byType(Tab))
        .map((tab) => tab.text)
        .toList();
    expect(labels, ['General', 'Tax Details', 'Social Links']);
  });

  testWidgets('a repeated group position keeps the order the server sent', (
    tester,
  ) async {
    await _pump(tester, [
      _attr('name', 'general', 'General', 1, 1),
      _attr('address', 'address', 'Address', 1, 1),
      _attr('return_policy', 'policies', 'Policies', 3, 1),
      _attr('min_order_amount', 'settings', 'Settings', 3, 1),
    ]);

    final labels = tester
        .widgetList<Tab>(find.byType(Tab))
        .map((tab) => tab.text)
        .toList();
    expect(labels, ['General', 'Address', 'Policies', 'Settings']);
  });

  testWidgets('fields in a group follow their position', (tester) async {
    // Tall enough that the lazy list builds every field.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _pump(tester, [
      _attr('phone', 'general', 'General', 1, 3),
      _attr('name', 'general', 'General', 1, 1),
      _attr('email', 'general', 'General', 1, 2),
    ]);

    // Field order on screen = order of the text boxes.
    final labels = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.decoration?.labelText)
        .toList();
    expect(labels, ['NAME', 'EMAIL', 'PHONE']);
  });

  testWidgets('required comes from the server, not a built-in list', (
    tester,
  ) async {
    await _pump(tester, [
      // `name` is on the old built-in list but the server says optional;
      // `vat_number` is not, but the server says required.
      _attr('name', 'general', 'General', 1, 1),
      _attr('vat_number', 'general', 'General', 1, 2, required: true),
    ]);

    final attrs = SellerProfile.fromJson({
      'name': 'x',
      'email': 'x',
      'profileAttributes': [
        _attr('name', 'general', 'General', 1, 1),
        _attr('vat_number', 'general', 'General', 1, 2, required: true),
      ],
    }).attributes;
    expect(attrs[0].isRequired, isFalse);
    expect(attrs[1].isRequired, isTrue);
  });

  testWidgets('shop information closes the first tab', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _pump(
      tester,
      [_attr('name', 'general', 'General', 1, 1)],
      info: const SellerShopInformation(
        commissionText: '10%',
        restrictedCategories: [SellerShopInfoItem(key: '1', label: 'Tops')],
        productTypes: [SellerShopInfoItem(key: 'simple', label: 'Simple')],
        paymentMethods: [SellerShopInfoItem(key: 'stripe', label: 'Stripe')],
        shippingMethods: [SellerShopInfoItem(key: 'flat', label: 'Flat Rate')],
      ),
    );

    expect(find.byKey(const Key('sellerShopInformation')), findsOneWidget);
    // Below the profile fields, not above them.
    expect(
      tester.getTopLeft(find.byKey(const Key('sellerShopInformation'))).dy,
      greaterThan(tester.getTopLeft(find.byType(TextField).first).dy),
    );
    expect(
      find.text('Admin Commission 10% of total Invoiced Amount'),
      findsOneWidget,
    );
    expect(find.text('Tops'), findsOneWidget);
    expect(find.text('Stripe'), findsOneWidget);
    expect(find.text('Flat Rate'), findsOneWidget);
  });

  testWidgets('no shop information hides the box without an error', (
    tester,
  ) async {
    await _pump(tester, [_attr('name', 'general', 'General', 1, 1)]);
    expect(find.byKey(const Key('sellerShopInformation')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
