import 'dart:convert';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/plans/data/models/seller_plan.dart';
import 'package:bagisto_flutter/marketplace/features/plans/data/repository/seller_plan_repository.dart';
import 'package:bagisto_flutter/marketplace/features/plans/presentation/bloc/seller_plan_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/plans/presentation/pages/seller_plan_history_page.dart';
import 'package:bagisto_flutter/marketplace/features/plans/presentation/pages/seller_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Verbatim from the .239 seller API for a seller with no subscription: the
/// plans list answers normally while the current-subscription query answers
/// an error, because holding none is reported as a failure.
const _plansPayload = <String, dynamic>{
  'sellerPlans': [
    {
      'id': 3,
      'name': 'test plan',
      'code': 'test plan',
      'description': 'test plan',
      'price': 99,
      'formattedPrice': r'$99.00',
      'isFree': false,
      'billingCycle': 'monthly',
      'durationDays': 60,
      'maxProducts': null,
      'maxStaff': 1,
      'commissionValue': null,
      'isFeatured': false,
      'isDefault': false,
      'isCurrent': false,
      'permissionType': 'custom',
      'permissions': ['dashboard', 'profile', 'catalog', 'catalog.products'],
      'productTypes': ['1', '6'],
    },
  ],
};

/// Verbatim from the .239 seller API: the methods the operator has switched
/// on, in the order the web plan modal lists them.
const _paymentMethodsPayload = <String, dynamic>{
  'sellerShopInformation': {
    'paymentMethods': [
      {'method': 'stripe', 'title': 'Stripe'},
      {'method': 'razorpay', 'title': 'Razorpay'},
      {'method': 'paypal_standard', 'title': 'PayPal Standard'},
      {'method': 'moneytransfer', 'title': 'Money Transfer'},
    ],
  },
};

/// Verbatim from the .239 seller API for `createSellerPlanCheckout`.
const _checkoutPayload = <String, dynamic>{
  'createSellerPlanCheckout': {
    'sellerPlanCheckout': {
      'id': 20,
      'planId': 3,
      'planName': 'test plan',
      'price': 99,
      'formattedPrice': r'$99.00',
      'status': 'pending',
      'paymentMethod': 'moneytransfer',
      'checkoutUrl':
          'https://example.com/api/seller/plans/checkout/start/20'
          '?expires=1792068927&signature=a374908626',
    },
  },
};

SellerPlanRepository _repository({
  Map<String, dynamic>? data,
  Map<String, dynamic>? checkout,
  List<Map<String, dynamic>>? checkoutErrors,
  List<Map<String, dynamic>>? errors,
  void Function(String body)? onRequest,
  Duration? delay,
}) => SellerPlanRepository(
  client: GraphQLClient(
    link: HttpLink(
      'https://example.com/graphql',
      httpClient: MockClient((request) async {
        onRequest?.call(request.body);
        // A server that answers instantly hides a whole class of bug: the
        // screen never renders its loading state, so nothing that depends on
        // the widget tree surviving a reload is ever exercised.
        if (delay != null) await Future<void>.delayed(delay);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final query = body['query'].toString();

        Map<String, dynamic> answer = data ?? _plansPayload;
        if (query.contains('sellerSubscription(')) {
          return http.Response(
            jsonEncode({
              'data': {'sellerSubscription': null},
              'errors': errors ?? const [],
            }),
            200,
            headers: const {'content-type': 'application/json'},
          );
        }
        if (query.contains('sellerShopInformation')) {
          answer = _paymentMethodsPayload;
        } else if (query.contains('createSellerPlanCheckout')) {
          if (checkoutErrors != null) {
            return http.Response(
              jsonEncode({
                'data': {'createSellerPlanCheckout': null},
                'errors': checkoutErrors,
              }),
              200,
              headers: const {'content-type': 'application/json'},
            );
          }
          answer = checkout ?? _checkoutPayload;
        }

        return http.Response(
          jsonEncode({'data': answer}),
          200,
          headers: const {'content-type': 'application/json'},
        );
      }),
    ),
    cache: GraphQLCache(),
  ),
);

Future<void> _pumpPage(
  WidgetTester tester,
  SellerPlanCubit cubit, {
  Widget page = const SellerPlanPage(),
}) async {
  tester.view.physicalSize = const Size(900, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    BlocProvider<SellerPlanCubit>.value(
      value: cubit,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: page,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // The checkout page reads the stored token to put on the web view's first
  // request, so the pages under test need the store to answer.
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('plan permissions', () {
    test('a custom plan grants only the sections it lists', () {
      final plan = SellerPlan.fromJson(
        _plansPayload['sellerPlans'][0] as Map<String, dynamic>,
      );

      expect(plan.permissionType, 'custom');
      expect(plan.grants('dashboard'), isTrue);
      expect(plan.grants('profile'), isTrue);
      expect(plan.grants('catalog'), isTrue);
      // Everything the plan does not list is denied, which is what the web
      // card marks with a red cross rather than leaving out.
      expect(plan.grants('inventories'), isFalse);
      expect(plan.grants('settings'), isFalse);
      expect(plan.productTypes, ['1', '6']);
    });

    test('an all-access plan grants every section without listing them', () {
      final plan = SellerPlan.fromJson(const {
        'id': 2,
        'name': 'Everything',
        'permissionType': 'all',
        'permissions': <String>[],
      });

      expect(plan.grants('settings'), isTrue);
      expect(plan.grants('communication'), isTrue);
    });

    test('a subscription keeps the snapshot it was taken with', () {
      final held = SellerSubscription.fromJson(const {
        'id': 4,
        'planName': 'test plan',
        'permissionType': 'custom',
        'permissions': ['dashboard'],
        'productTypes': ['1'],
        'paymentMethod': 'free',
      });

      expect(held.permissions, ['dashboard']);
      expect(held.productTypes, ['1']);
      expect(held.paymentMethod, 'free');
    });
  });

  group('SellerPlanRepository', () {
    test('holding no subscription reads as none, not as a failure', () async {
      final repository = _repository(
        errors: const [
          {'message': 'You do not have an active subscription.'},
        ],
      );

      await expectLater(repository.subscription(), completion(isNull));
    });

    test('any other subscription error is still raised', () async {
      final repository = _repository(
        errors: const [
          {'message': 'Subscriptions are not enabled for this marketplace.'},
        ],
      );

      await expectLater(repository.subscription(), throwsA(isA<Object>()));
    });

    test('the payment methods come from the shop-information resource', () async {
      final bodies = <String>[];
      final repository = _repository(onRequest: bodies.add);

      final methods = await repository.paymentMethods();

      expect(bodies.last, contains('/api/seller/shop-information'));
      // The repository stays faithful to the API; narrowing to what the app
      // can carry through is the cubit's job.
      expect(methods.map((method) => method.method), [
        'stripe',
        'razorpay',
        'paypal_standard',
        'moneytransfer',
      ]);
      // The web's own wording, down to the space.
      expect(methods.last.title, 'Money Transfer');
    });

    test('checkout sends the plan and the method, and returns the url', () async {
      final bodies = <String>[];
      final repository = _repository(onRequest: bodies.add);

      final checkout = await repository.startPlanCheckout(
        planId: 3,
        paymentMethod: 'moneytransfer',
      );

      expect(bodies.last, contains('"planId":3'));
      expect(bodies.last, contains('"paymentMethod":"moneytransfer"'));
      expect(checkout.id, 20);
      expect(checkout.status, 'pending');
      expect(checkout.hasUrl, isTrue);
      expect(checkout.checkoutUrl, contains('signature='));
    });

    test('a checkout with no url is a failure, not something to open', () async {
      final repository = _repository(
        checkout: const {
          'createSellerPlanCheckout': {
            'sellerPlanCheckout': {'id': 21, 'status': 'pending'},
          },
        },
      );

      await expectLater(
        repository.startPlanCheckout(planId: 3, paymentMethod: 'stripe'),
        throwsA(isA<Object>()),
      );
    });

    test('cancel asks the cancel operation, not the resource', () async {
      final bodies = <String>[];
      final repository = _repository(
        data: const {
          'cancelSellerSubscription': {
            'sellerSubscription': {'id': 7, 'status': 'cancelled'},
          },
        },
        onRequest: bodies.add,
      );

      await repository.cancelSubscription(7);

      expect(bodies, isNotEmpty);
      expect(bodies.last, contains('/api/seller/subscription/7/cancel'));
    });
  });

  group('payment methods', () {
    test('only the two the app can carry through are offered', () {
      // Everything the .239 operator has switched on, in the order the API
      // returns it.
      const offered = [
        'stripe',
        'razorpay',
        'payu',
        'phonepe',
        'paypal_smart_button',
        'paypal_standard',
        'moneytransfer',
      ];

      expect(offered.where(SellerPaymentMethod.isSupported), [
        'paypal_standard',
        'moneytransfer',
      ]);
    });

    test('a method the operator adds is hidden until it is supported', () {
      // Nothing the app has not been built for reaches the seller.
      expect(SellerPaymentMethod.isSupported('some_new_psp'), isFalse);
    });
  });

  group('plan screen', () {
    testWidgets('the card shows what the plan does and does not unlock', (
      tester,
    ) async {
      final cubit = SellerPlanCubit(
        repository: _repository(
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();

      expect(cubit.state.status, SellerPlanStatus.loaded);
      await _pumpPage(tester, cubit);

      expect(find.byKey(const Key('sellerPlanCard_3')), findsOneWidget);
      expect(find.text('test plan'), findsOneWidget);
      // Price against duration, the three allowances, and the whole section
      // list — the web card's own content.
      expect(find.text(r'$99.00'), findsOneWidget);
      expect(find.text('60 days'), findsOneWidget);
      expect(find.text('Permissions'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNWidgets(3));
      expect(find.byIcon(Icons.close), findsNWidgets(9));
    });

    testWidgets('a paid plan asks for a payment method, as the web does', (
      tester,
    ) async {
      final bodies = <String>[];
      final cubit = SellerPlanCubit(
        repository: _repository(
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
          onRequest: bodies.add,
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await _pumpPage(tester, cubit);

      await tester.tap(find.byKey(const Key('sellerPlanCard_3')));
      await tester.pumpAndSettle();

      expect(find.text('Product Types'), findsOneWidget);
      expect(find.text('Simple'), findsOneWidget);
      expect(find.text('Virtual'), findsOneWidget);

      // Step one is the web's own: the terms gate Proceed.
      await tester.tap(find.byKey(const Key('sellerPlanTerms')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sellerPlanProceed_3')));
      await tester.pumpAndSettle();

      // Step two: only the two methods the app can carry through, with the
      // titles the API returns. Everything else the operator has switched on
      // is left out rather than shown and then failing.
      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Money Transfer'), findsOneWidget);
      expect(find.text('PayPal Standard'), findsOneWidget);
      expect(find.text('Stripe'), findsNothing);
      expect(find.text('Razorpay'), findsNothing);

      await tester.tap(find.byKey(const Key('sellerPlanPayment_moneytransfer')));
      await tester.pumpAndSettle();

      // Picking one starts the checkout with that method, and nothing else.
      final mutation = bodies.lastWhere(
        (body) => body.contains('createSellerPlanCheckout'),
      );
      expect(mutation, contains('"planId":3'));
      expect(mutation, contains('"paymentMethod":"moneytransfer"'));
      expect(mutation, isNot(contains('createSellerSubscription')));

      // Straight to Plan History — no gateway is opened for either method.
      expect(find.text('Plan History'), findsOneWidget);
    });

    testWidgets('the plan already held is buyable, and a refusal is shown', (
      tester,
    ) async {
      // What the .239 server answers when the current plan is bought again.
      const refusal = 'You are already subscribed to the test plan plan.';

      final cubit = SellerPlanCubit(
        repository: _repository(
          data: const {
            'sellerPlans': [
              {
                'id': 3,
                'name': 'test plan',
                'price': 99,
                'formattedPrice': r'$99.00',
                'isFree': false,
                'isCurrent': true,
                'permissionType': 'all',
                'permissions': <String>[],
                'productTypes': <String>[],
              },
            ],
          },
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
          checkoutErrors: const [
            {'message': refusal},
          ],
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await _pumpPage(tester, cubit);

      await tester.tap(find.byKey(const Key('sellerPlanCard_3')));
      await tester.pumpAndSettle();

      // Marked as the plan in force, and still offered — buying it again is
      // a renewal, which is what the web does.
      expect(find.text('Current plan'), findsWidgets);
      await tester.tap(find.byKey(const Key('sellerPlanTerms')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sellerPlanProceed_3')));
      await tester.pumpAndSettle();

      expect(find.text('Payment Method'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('sellerPlanPayment_paypal_standard')),
      );
      await tester.pumpAndSettle();

      // The server's own words reach the seller rather than a generic error.
      expect(find.text(refusal), findsOneWidget);
    });

    testWidgets('History is its own screen, not a tab on this one', (
      tester,
    ) async {
      final cubit = SellerPlanCubit(
        repository: _repository(
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await _pumpPage(tester, cubit);

      expect(find.text('Available Plans'), findsOneWidget);
      expect(find.byType(TabBar), findsNothing);
      expect(find.text('History'), findsNothing);

      await _pumpPage(
        tester,
        cubit,
        page: const SellerPlanHistoryPage(),
      );

      expect(find.text('Plan History'), findsOneWidget);
      expect(find.byKey(const Key('sellerPlansHistoryEmpty')), findsOneWidget);
      // No plan cards on the history screen.
      expect(find.byKey(const Key('sellerPlanCard_3')), findsNothing);
    });

    testWidgets('history carries the id and the grid status colours', (
      tester,
    ) async {
      // Verbatim from the web history grid: label-pending, label-active,
      // label-closed.
      final cubit = SellerPlanCubit(
        repository: _repository(
          data: const {
            'sellerSubscriptions': {
              'collection': [
                {
                  'id': 15,
                  'planName': 'test plan',
                  'formattedPrice': r'$99.00',
                  'status': 'pending',
                  'isActive': false,
                  'paymentMethod': 'moneytransfer',
                },
                {
                  'id': 14,
                  'planName': 'test plan',
                  'formattedPrice': r'$99.00',
                  'status': 'active',
                  'isActive': true,
                },
                {
                  'id': 2,
                  'planName': 'fdsfsd',
                  'formattedPrice': r'$0.00',
                  'status': 'expired',
                  'isActive': false,
                },
              ],
              'paginationInfo': {'totalCount': 3, 'lastPage': 1},
            },
          },
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await _pumpPage(tester, cubit, page: const SellerPlanHistoryPage());

      expect(find.text('#15'), findsOneWidget);
      expect(find.text('#14'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);

      Color colourOf(String label) {
        final text = tester.widget<Text>(find.text(label));
        return text.style!.color!;
      }

      expect(colourOf('Active'), const Color(0xFF00A63E));
      expect(colourOf('Pending'), const Color(0xFFF59E0B));
      expect(colourOf('Expired'), const Color(0xFFFB2C36));
    });

    testWidgets('a free plan proceeds only once the terms are agreed', (
      tester,
    ) async {
      final cubit = SellerPlanCubit(
        repository: _repository(
          data: const {
            'sellerPlans': [
              {
                'id': 1,
                'name': 'Starter',
                'price': 0,
                'formattedPrice': r'$0.00',
                'isFree': true,
                'durationDays': 60,
                'maxProducts': 1,
                'maxStaff': 1,
                'permissionType': 'all',
                'permissions': <String>[],
                'productTypes': <String>[],
              },
            ],
          },
          errors: const [
            {'message': 'You do not have an active subscription.'},
          ],
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await _pumpPage(tester, cubit);

      await tester.tap(find.byKey(const Key('sellerPlanCard_1')));
      await tester.pumpAndSettle();

      expect(find.text('No Product Types'), findsOneWidget);
      final proceed = find.byKey(const Key('sellerPlanProceed_1'));
      expect(
        tester.widget<FilledButton>(
          find.descendant(of: proceed, matching: find.byType(FilledButton)),
        ).onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('sellerPlanTerms')));
      await tester.pumpAndSettle();

      expect(
        tester.widget<FilledButton>(
          find.descendant(of: proceed, matching: find.byType(FilledButton)),
        ).onPressed,
        isNotNull,
      );
    });
  });
}
