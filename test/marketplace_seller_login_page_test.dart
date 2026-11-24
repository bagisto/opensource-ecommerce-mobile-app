import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/pages/seller_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingSessionCubit extends Cubit<SellerSessionState>
    implements SellerSessionCubit {
  _RecordingSessionCubit([super.initialState = const SellerSessionState()]);

  String? capturedEmail;
  String? capturedPassword;

  void emitState(SellerSessionState state) => emit(state);

  @override
  Future<void> signIn({required String email, required String password}) async {
    capturedEmail = email;
    capturedPassword = password;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrap(Widget child, _RecordingSessionCubit cubit) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<SellerSessionCubit>.value(value: cubit, child: child),
  );
}

void main() {
  testWidgets('seller credentials are prefilled', (tester) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    expect(find.text('seller1@example.com'), findsOneWidget);
    final passwordField = tester.widget<TextFormField>(
      find.byKey(const Key('sellerLoginPassword')),
    );
    expect(passwordField.controller?.text, 'admin123');
  });

  testWidgets('empty fields block submission and show validation', (
    tester,
  ) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    await tester.enterText(find.byKey(const Key('sellerLoginEmail')), '');
    await tester.enterText(find.byKey(const Key('sellerLoginPassword')), '');
    await tester.tap(find.byKey(const Key('sellerLoginSubmit')));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(cubit.capturedEmail, isNull);
  });

  testWidgets('valid credentials reach the session cubit', (tester) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    await tester.enterText(
      find.byKey(const Key('sellerLoginEmail')),
      'seller@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('sellerLoginPassword')),
      'seller123',
    );
    await tester.tap(find.byKey(const Key('sellerLoginSubmit')));
    await tester.pumpAndSettle();

    expect(cubit.capturedEmail, 'seller@example.com');
    expect(cubit.capturedPassword, 'seller123');
  });

  testWidgets('failed login shows the session error snackbar', (tester) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    cubit.emitState(
      const SellerSessionState(
        status: SellerSessionStatus.failed,
        errorMessage: 'Invalid credentials',
      ),
    );
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);
  });
}
