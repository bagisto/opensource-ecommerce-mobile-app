import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/bloc/seller_register_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/pages/seller_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// The sign-up form shows what the admin put on the sign-up page.
class _Repo implements SellerAuthRepository {
  _Repo(this.fields);

  final List<SellerAttribute> fields;
  String? sentPhone;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerAttribute>> signUpAttributes() async => fields;

  @override
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async {
    sentPhone = phone;
    return 'ok';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

SellerAttribute _attr(String code, String name, {bool required = true}) =>
    SellerAttribute(code: code, name: name, type: 'text', isRequired: required);

Future<_Repo> _open(WidgetTester tester, List<SellerAttribute> fields) async {
  final repo = _Repo(fields);
  final cubit = SellerRegisterCubit(repository: repo);
  await cubit.loadAttributes();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const SellerRegisterPage()),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('Phone is not drawn when the sign-up form does not list it', (
    tester,
  ) async {
    await _open(tester, [
      _attr('name', 'Name'),
      _attr('email', 'Email'),
      _attr('slug', 'Slug'),
      _attr('business_name', 'Business Name'),
    ]);

    expect(find.text('Phone'), findsNothing);
    expect(find.text('Additional Information'), findsOneWidget);
    // The server's own words are used, not the app's.
    expect(find.text('Slug *'), findsOneWidget);
    expect(find.text('Shop URL *'), findsNothing);
    expect(find.text('Business Name *'), findsOneWidget);
  });

  testWidgets('Phone is drawn, with its required flag, when it is listed', (
    tester,
  ) async {
    await _open(tester, [
      _attr('name', 'Name'),
      _attr('email', 'Email'),
      _attr('slug', 'Slug'),
      _attr('phone', 'Phone', required: false),
    ]);
    expect(find.text('Phone'), findsOneWidget);
  });

  testWidgets('a required Phone gets its star', (tester) async {
    await _open(tester, [
      _attr('name', 'Name'),
      _attr('email', 'Email'),
      _attr('slug', 'Slug'),
      _attr('phone', 'Phone Number'),
    ]);
    expect(find.text('Phone Number *'), findsOneWidget);
  });

  testWidgets('the core fields stay when the server omits them', (
    tester,
  ) async {
    await _open(tester, const []);

    expect(find.text('Your name *'), findsOneWidget);
    expect(find.text('Email *'), findsOneWidget);
    expect(find.text('Shop URL *'), findsOneWidget);
    expect(find.text('Phone'), findsNothing);
  });

  testWidgets('extra fields follow the password, in the admin order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _open(tester, [
      // Listed out of order on purpose: position decides.
      const SellerAttribute(
        code: 'business_name',
        name: 'Business Name',
        type: 'text',
        isRequired: true,
        position: 4,
      ),
      _attr('name', 'Name'),
      const SellerAttribute(
        code: 'gst',
        name: 'GST No',
        type: 'text',
        isRequired: true,
        position: 3,
      ),
      _attr('email', 'Email'),
      _attr('slug', 'Slug'),
    ]);

    final labels = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.decoration?.labelText)
        .toList();
    expect(find.text('Additional Information'), findsOneWidget);
    expect(labels, [
      'Name *',
      'Email *',
      'Slug *',
      'Password *',
      'Confirm password *',
      'GST No *',
      'Business Name *',
    ]);
  });
}
