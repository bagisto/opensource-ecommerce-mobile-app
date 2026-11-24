import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Downloads on a pushed screen.
///
/// Every file the panel offers — the barcode sheet, invoice and receipt PDFs,
/// an import's own file — sits behind the seller's token, and every screen
/// offering one is a pushed route. A pushed route is a sibling of the route
/// holding the session, not a descendant, so a callback that reads the cubit
/// from inside it throws and the tap does nothing at all.
void main() {
  testWidgets('a pushed screen cannot reach the session itself', (
    tester,
  ) async {
    // The reason the barcode's Download PDF button did nothing.
    Object? thrown;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SellerSessionCubit>(
          create: (_) => SellerSessionCubit(
            authRepository: _NoAuth(),
            accountRepositoryBuilder: (_) => throw UnimplementedError(),
          ),
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (pushed) => TextButton(
                    onPressed: () {
                      try {
                        pushed.read<SellerSessionCubit>();
                      } on Object catch (error) {
                        thrown = error;
                      }
                    },
                    child: const Text('download'),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('download'));

    expect(thrown, isA<ProviderNotFoundException>());
  });

  testWidgets('the token is captured before the screen is pushed', (
    tester,
  ) async {
    // So the download carries it however deep the screen sits.
    String? sent;
    String? asked;

    final open = SellerRoutes.downloadWith(
      '107|abc',
      open: (context, {required String url, required String? token}) async {
        sent = token;
        asked = url;
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => open(context, 'http://host/barcode/pdf'),
            child: const Text('download'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('download'));

    expect(sent, '107|abc');
    expect(asked, 'http://host/barcode/pdf');
  });
}

/// The session is never signed in here; only its presence matters.
class _NoAuth implements SellerAuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
