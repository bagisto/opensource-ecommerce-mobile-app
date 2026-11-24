import 'package:bagisto_flutter/features/auth/domain/services/auth_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proves a signed-in session survives a restart.
///
/// The app reads the token back on launch through [AuthStorage], so if these
/// pass the persistence chain is sound and a logged-out launch means the
/// storage was empty to begin with — a fresh install, or a sign-out.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a saved token is still there on the next launch', () async {
    await AuthStorage.saveToken('token-abc');
    await AuthStorage.saveUserInfo(
      name: 'Aarav',
      email: 'aarav@example.com',
      userId: '3',
    );

    // A new launch reads through a fresh SharedPreferences handle.
    expect(await AuthStorage.getToken(), 'token-abc');
    expect(await AuthStorage.getUserName(), 'Aarav');
    expect(await AuthStorage.getUserEmail(), 'aarav@example.com');
    expect(await AuthStorage.getUserId(), '3');
    expect(await AuthStorage.isLoggedIn(), isTrue);
  });

  test('nothing stored means signed out', () async {
    expect(await AuthStorage.getToken(), isNull);
    expect(await AuthStorage.isLoggedIn(), isFalse);
  });

  test('signing out clears the token and the profile with it', () async {
    await AuthStorage.saveToken('token-abc');
    await AuthStorage.saveUserInfo(name: 'Aarav', email: 'aarav@example.com');

    await AuthStorage.clearAuth();

    expect(await AuthStorage.getToken(), isNull);
    expect(await AuthStorage.getUserName(), isNull);
    expect(await AuthStorage.getUserEmail(), isNull);
    expect(await AuthStorage.isLoggedIn(), isFalse);
  });

  test('an empty token counts as signed out, not signed in', () async {
    await AuthStorage.saveToken('');

    expect(await AuthStorage.isLoggedIn(), isFalse);
  });
}
