import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/edit_account_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/edit_account_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _RecordingBloc extends EditAccountBloc {
  _RecordingBloc()
    : super(
        repository: AccountRepository(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      );

  final saves = <SaveProfile>[];

  @override
  void add(EditAccountEvent event) {
    if (event is SaveProfile) {
      saves.add(event);
      return;
    }
    super.add(event);
  }
}

void main() {
  testWidgets('phone and gender are required before saving the profile', (
    tester,
  ) async {
    final bloc = _RecordingBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<EditAccountBloc>.value(
          value: bloc,
          child: const EditAccountPage(
            profile: CustomerProfile(
              firstName: 'Jo',
              lastName: 'Doe',
              email: 'jo@example.com',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gender *'), findsOneWidget);
    expect(find.text('Phone *'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('edit_profile_save')));
    await tester.pumpAndSettle();

    expect(find.text('Gender is required'), findsOneWidget);
    expect(find.text('Phone number is required'), findsWidgets);
    expect(bloc.saves, isEmpty);
  });
}
