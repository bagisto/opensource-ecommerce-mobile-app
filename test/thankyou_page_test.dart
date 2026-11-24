import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/store_config/store_config_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/checkout/presentation/pages/thankyou_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  @override
  final AuthState state = const AuthUnauthenticated();

  _FakeAuthBloc();

  @override
  Stream<AuthState> get stream => const Stream<AuthState>.empty();

  @override
  Future<void> close() async {}
}

class _FakeStoreConfigRepo extends StoreConfigRepository {
  _FakeStoreConfigRepo()
      : super(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );
}

void main() {
  Widget buildSubject({
    required StoreConfig config,
    String? orderId,
    String? orderIncrementId,
  }) {
    final cubit = StoreConfigCubit(repository: _FakeStoreConfigRepo());
    cubit.emit(config);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
          BlocProvider<StoreConfigCubit>.value(value: cubit),
        ],
        child: ThankyouPage(
          orderId: orderId,
          orderIncrementId: orderIncrementId,
        ),
      ),
    );
  }

  group('ThankyouPage order number display', () {
    testWidgets('renders formatted order number with # when admin config is present', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          config: const StoreConfig(
            orderNumberPrefix: 'Prefix',
            orderNumberLength: 5,
            orderNumberSuffix: 'Suffix',
          ),
          orderId: '41',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your order No. #Prefix00041Suffix'), findsOneWidget);
    });

    testWidgets('renders plain order number with # when admin config is null', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          config: const StoreConfig(
            orderNumberPrefix: null,
            orderNumberLength: null,
            orderNumberSuffix: null,
          ),
          orderId: '41',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your order No. #41'), findsOneWidget);
    });

    testWidgets('renders single # if raw orderIncrementId carries #', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          config: const StoreConfig(
            orderNumberPrefix: 'Prefix',
            orderNumberLength: 5,
            orderNumberSuffix: 'Suffix',
          ),
          orderId: '41',
          orderIncrementId: '#Prefix00041Suffix',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your order No. #Prefix00041Suffix'), findsOneWidget);
      expect(find.textContaining('##'), findsNothing);
    });
  });
}
