import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/ui/seller_ui.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/models/seller_settings.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/repository/seller_settings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/bloc/seller_settings_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/pages/seller_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Adding a role through the screen a seller actually taps.
///
/// The sheet's save reported nothing when it failed and the screen was left
/// with a dead button, so these drive the widgets rather than the cubit.
class _Repo implements SellerSettingsRepository {
  _Repo({this.roleFailure});

  /// What the server says when the role is refused.
  final Object? roleFailure;

  List<SellerRole> stored = const [];
  SellerRole? saved;

  @override
  GraphQLClient get client => throw UnimplementedError();

  static PaginatedResult<T> _page<T>(List<T> items) => PaginatedResult<T>(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<SellerSettings> settings() async => const SellerSettings();

  @override
  Future<SellerSettings> updateSettings({
    String? preferredLocale,
    bool? emailNotifications,
  }) async => const SellerSettings();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<PaginatedResult<SellerUser>> users({
    int page = 1,
    String? search,
  }) async => _page(const <SellerUser>[]);

  @override
  Future<void> createUser(SellerUserDraft draft) async {}

  @override
  Future<void> updateUser(SellerUserDraft draft) async {}

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<PaginatedResult<SellerRole>> roles({
    int page = 1,
    String? search,
  }) async => _page(stored);

  @override
  Future<void> createRole(SellerRole role) async {
    if (roleFailure != null) throw roleFailure!;
    saved = role;
    stored = [...stored, role];
  }

  @override
  Future<void> updateRole(SellerRole role) async {
    if (roleFailure != null) throw roleFailure!;
    saved = role;
  }

  @override
  Future<void> deleteRole(int id) async {}

  @override
  Future<List<SellerPermission>> aclPermissions() async => const [
    (key: 'dashboard', name: 'Dashboard', level: 0),
    (key: 'catalog', name: 'Catalog', level: 0),
    (key: 'catalog.products', name: 'Products', level: 1),
  ];

  @override
  Future<SellerAccountHealth> accountHealth() async =>
      throw const SellerApiException('no', SellerApiFailure.forbidden);

  @override
  Future<SellerAccountHealth> refreshAccountHealth() async =>
      throw UnimplementedError();
}

Future<SellerSettingsCubit> _openRoles(WidgetTester tester, _Repo repo) async {
  final cubit = SellerSettingsCubit(repository: repo);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: const SellerSettingsPage(initialTab: 2),
      ),
    ),
  );

  await cubit.load();
  await tester.pumpAndSettle();
  return cubit;
}

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('sellerSettingsAddRole')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a custom role saves what was ticked', (tester) async {
    final repo = _Repo();
    await _openRoles(tester, repo);
    await _openSheet(tester);

    await tester.enterText(find.byKey(const Key('sellerRoleName')), 'Packers');
    await tester.tap(find.byKey(const Key('sellerRoleGrantsAll')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sellerRoleChoosePermissions')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('sellerPermission_catalog.products')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('sellerPermissionsDone')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sellerRoleSaveSheet')));
    await tester.pumpAndSettle();

    expect(repo.saved?.name, 'Packers');
    expect(repo.saved?.permissionType, 'custom');
    expect(repo.saved?.permissions, ['catalog.products', 'catalog']);
    // The sheet closes on success, or the seller cannot tell it worked.
    expect(find.byKey(const Key('sellerRoleSaveSheet')), findsNothing);
  });

  testWidgets('a refused save says why and leaves the sheet open', (
    tester,
  ) async {
    final repo = _Repo(
      roleFailure: const SellerApiException(
        'The name has already been taken.',
        SellerApiFailure.validation,
      ),
    );
    await _openRoles(tester, repo);
    await _openSheet(tester);

    await tester.enterText(find.byKey(const Key('sellerRoleName')), 'test');
    await tester.tap(find.byKey(const Key('sellerRoleSaveSheet')));
    await tester.pumpAndSettle();

    expect(find.text('The name has already been taken.'), findsOneWidget);
    expect(find.byKey(const Key('sellerRoleSaveSheet')), findsOneWidget);
  });

  testWidgets('a save that breaks on something else still frees the button', (
    tester,
  ) async {
    // The server sends numbers as strings and nulls where a list belongs, so
    // a parse can blow up outside SellerApiException. A screen that leaves
    // its save disabled forever is the worst possible answer to that.
    final repo = _Repo(roleFailure: TypeError());
    await _openRoles(tester, repo);
    await _openSheet(tester);

    await tester.enterText(find.byKey(const Key('sellerRoleName')), 'Packers');
    await tester.tap(find.byKey(const Key('sellerRoleSaveSheet')));
    await tester.pumpAndSettle();

    final button = tester.widget<SellerBusyButton>(
      find.byKey(const Key('sellerRoleSaveSheet')),
    );
    expect(button.busy, isFalse, reason: 'the save must not stay disabled');
  });

  testWidgets('an empty name is refused before the request goes out', (
    tester,
  ) async {
    final repo = _Repo();
    await _openRoles(tester, repo);
    await _openSheet(tester);

    await tester.tap(find.byKey(const Key('sellerRoleSaveSheet')));
    await tester.pumpAndSettle();

    expect(repo.saved, isNull);
    expect(find.byKey(const Key('sellerRoleSaveSheet')), findsOneWidget);
  });
}
