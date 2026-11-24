// Booking products on the product detail page: days without slots are greyed
// out in the date picker, "Cancellation Not Allowed" and "View on Map" show
// where the API says so, and nothing is shown when it does not.
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/product/presentation/bloc/product_detail_bloc.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_booking_options_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ProductModel _bookingProduct(Map<String, dynamic> booking) =>
    ProductModel.fromJson({
      'id': '/api/shop/products/7',
      '_id': 7,
      'name': 'Spa Session',
      'type': 'booking',
      'bookingProducts': {
        'edges': [
          {
            'node': {'id': '1', ...booking},
          },
        ],
      },
    });

Widget _wrap(ProductModel product) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: BlocProvider(
    create: (_) => ProductDetailBloc(
      repository: CategoryRepository(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      ),
    ),
    child: Scaffold(
      body: SingleChildScrollView(
        child: ProductBookingOptionsSection(product: product),
      ),
    ),
  ),
);

/// An appointment booking with slots on Fridays only (weekday 5).
const _fridaysOnly = {
  'type': 'appointment',
  'appointmentSlot': {
    'sameSlotAllDays': '0',
    'slots': {
      '5': [
        {'from': '10:00', 'to': '11:00'},
      ],
    },
  },
};

void main() {
  testWidgets('days without slots are greyed out in the date picker', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_bookingProduct(Map.of(_fridaysOnly))));

    // The empty date field shows the format hint until a date is picked.
    await tester.tap(find.text('YYYY-MM-DD'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<DatePickerDialog>(
      find.byType(DatePickerDialog),
    );
    final predicate = dialog.selectableDayPredicate;

    expect(predicate, isNotNull, reason: 'picker must grey out empty days');
    // 2026-10-16 is a Friday, 2026-10-15 a Thursday.
    expect(predicate!(DateTime(2026, 10, 16)), isTrue);
    expect(predicate(DateTime(2026, 10, 15)), isFalse);
    expect(predicate(DateTime(2026, 10, 17)), isFalse);
  });

  testWidgets('"Cancellation Not Allowed" shows only when cancellation is off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(_bookingProduct({..._fridaysOnly, 'allowCancellation': '0'})),
    );
    expect(find.text('Cancellation Not Allowed'), findsOneWidget);

    await tester.pumpWidget(
      _wrap(_bookingProduct({..._fridaysOnly, 'allowCancellation': '1'})),
    );
    expect(find.text('Cancellation Not Allowed'), findsNothing);

    // Field absent from the API: say nothing either way.
    await tester.pumpWidget(_wrap(_bookingProduct(Map.of(_fridaysOnly))));
    expect(find.text('Cancellation Not Allowed'), findsNothing);
  });

  testWidgets('"View on Map" shows only with a location', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _bookingProduct({..._fridaysOnly, 'location': 'Pune, Maharashtra'}),
      ),
    );
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Pune, Maharashtra'), findsOneWidget);
    expect(find.text('View on Map'), findsOneWidget);

    await tester.pumpWidget(
      _wrap(_bookingProduct({..._fridaysOnly, 'location': '   '})),
    );
    expect(find.text('View on Map'), findsNothing);
    expect(find.text('Location'), findsNothing);
  });

  testWidgets('event bookings show the location row with a map link', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        _bookingProduct({
          'type': 'event',
          'location': 'Mumbai',
          'availableFrom': '2026-11-01 10:00:00',
          'availableTo': '2026-11-02 18:00:00',
        }),
      ),
    );

    expect(find.text('Mumbai'), findsOneWidget);
    expect(find.text('View on Map'), findsOneWidget);
  });
}
