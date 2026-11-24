import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/store_config/store_config_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/header_offer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeStoreConfigRepository extends StoreConfigRepository {
  _FakeStoreConfigRepository()
      : super(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );
}

void main() {
  group('StoreConfig header offer parsing', () {
    test('parses headerOfferTitle, headerOfferLinkTitle, and headerOfferLink from API JSON', () {
      final config = StoreConfig.fromJson({
        'headerOfferTitle': 'Get UPTO 20% OFF on your 1st order',
        'headerOfferLinkTitle': 'SHOP NOW',
        'headerOfferLink': null,
      });

      expect(config.headerOfferTitle, 'Get UPTO 20% OFF on your 1st order');
      expect(config.headerOfferLinkTitle, 'SHOP NOW');
      expect(config.headerOfferLink, isNull);
      expect(config.hasHeaderOffer, isTrue);
    });

    test('hasHeaderOffer is false when headerOfferTitle is null or empty', () {
      final emptyConfig = StoreConfig.fromJson({
        'headerOfferTitle': '   ',
        'headerOfferLinkTitle': 'SHOP NOW',
      });
      expect(emptyConfig.hasHeaderOffer, isFalse);

      final nullConfig = StoreConfig.fromJson({});
      expect(nullConfig.hasHeaderOffer, isFalse);
    });
  });

  group('HeaderOfferBar widget', () {
    testWidgets('renders header offer title and link title when configured', (tester) async {
      final cubit = StoreConfigCubit(repository: _FakeStoreConfigRepository());
      cubit.emit(
        const StoreConfig(
          headerOfferTitle: 'Get UPTO 20% OFF on your 1st order',
          headerOfferLinkTitle: 'SHOP NOW',
        ),
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StoreConfigCubit>.value(
            value: cubit,
            child: Scaffold(
              body: HeaderOfferBar(
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('header_offer_bar')), findsOneWidget);
      expect(find.textContaining('Get UPTO 20% OFF on your 1st order'), findsOneWidget);
      expect(find.textContaining('SHOP NOW'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('header_offer_bar')));
      expect(tapped, isTrue);

      await cubit.close();
    });

    testWidgets('renders nothing when headerOfferTitle is empty', (tester) async {
      final cubit = StoreConfigCubit(repository: _FakeStoreConfigRepository());
      cubit.emit(const StoreConfig());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StoreConfigCubit>.value(
            value: cubit,
            child: const Scaffold(
              body: HeaderOfferBar(),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('header_offer_bar')), findsNothing);
      await cubit.close();
    });
  });
}
