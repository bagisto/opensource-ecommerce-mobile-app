import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/address_book_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/address_book_page.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/image_carousel.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  group('April 10 fixes', () {
    testWidgets(
      'address book no longer exposes a select address action',
      (tester) async {
        final repository = _FakeAccountRepository(
          addresses: const [
            CustomerAddress(
              id: '/api/shop/customer-addresses/1',
              numericId: 1,
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              address: '221B Baker Street',
              city: 'London',
              state: 'London',
              country: 'UK',
              zipCode: 'NW16XE',
              phone: '1234567890',
            ),
          ],
        );

        await tester.pumpWidget(
          _TestApp(
            child: RepositoryProvider<AccountRepository>.value(
              value: repository,
              child: BlocProvider(
                create: (_) =>
                    AddressBookBloc(repository: repository)
                      ..add(const LoadAddresses()),
                child: const AddressBookPage(),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.pump();

        expect(find.text('Select Address'), findsNothing);
      },
    );

    testWidgets(
      'image carousel uses contain fit inside an animated height wrapper',
      (tester) async {
        await tester.pumpWidget(
          const _TestApp(
            child: Scaffold(
              body: ImageCarousel(
                images: [
                  BannerImage(imageUrl: 'banners/home-sale.png'),
                ],
                baseUrl: 'https://example.com',
              ),
            ),
          ),
        );

        final image = tester.widget<Image>(
          find.descendant(
            of: find.byType(ImageCarousel),
            matching: find.byType(Image),
          ),
        );

        expect(find.byType(AnimatedSize), findsOneWidget);
        expect(image.fit, BoxFit.contain);
      },
    );
  });
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}

class _FakeAccountRepository extends AccountRepository {
  final List<CustomerAddress> addresses;

  _FakeAccountRepository({required this.addresses})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(),
        ),
      );

  @override
  Future<List<CustomerAddress>> getCustomerAddresses({int first = 10}) async {
    return addresses;
  }
}
