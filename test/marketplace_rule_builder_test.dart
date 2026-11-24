import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_marketing.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_marketing_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_marketing_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_discount_editor_page.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_join_detail_page.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/widgets/seller_discount_condition_row.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_marketing_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// The rule editor, built the way the panel builds its own.
///
/// The app offered five attributes, every operator on all of them and a
/// free-text value, sent a fixed set of channels and customer groups over
/// whatever the panel had chosen, and never showed a deal's conditions at all
/// — so saving a deal written in the panel emptied them.

/// What the server lists, in the shape `sellerProductDiscountOptions` returns.
const _optionsPayload = {
  'channels': [
    {'id': 1, 'code': 'default', 'label': 'Default'},
  ],
  'customerGroups': [
    {'id': 1, 'code': 'guest', 'label': 'Guest'},
    {'id': 2, 'code': 'general', 'label': 'General'},
    {'id': 3, 'code': 'wholesale', 'label': 'Wholesale'},
  ],
  'actionTypes': [
    {'value': 'by_percent', 'label': 'Percentage of product price'},
    {'value': 'by_fixed', 'label': 'Fixed amount off product price'},
  ],
  'conditionTypes': [
    {'value': 1, 'label': 'All Conditions Are True'},
    {'value': 2, 'label': 'Any Condition Is True'},
  ],
  'conditionAttributes': [
    {
      'key': 'product',
      'label': 'Product attribute',
      'children': [
        {
          'key': 'product|category_ids',
          'label': 'Categories',
          'type': 'multiselect',
          'operators': [
            {'operator': '{}', 'label': 'Contains'},
            {'operator': '!{}', 'label': 'Does not contain'},
          ],
          'options': [
            {'value': 1, 'label': 'Root'},
            {'value': 4, 'label': 'Mugs'},
          ],
        },
        {
          'key': 'product|new',
          'label': 'New',
          'type': 'boolean',
          'operators': [
            {'operator': '==', 'label': 'Is equal to'},
            {'operator': '!=', 'label': 'Is not equal to'},
          ],
        },
        {
          'key': 'product|price',
          'label': 'Price',
          'type': 'price',
          'operators': [
            {'operator': '==', 'label': 'Is equal to'},
            {'operator': '>=', 'label': 'Equals or greater than'},
          ],
        },
      ],
    },
  ],
};

/// What a checkout deal's conditions are written against.
///
/// A separate query on the server, and a separate set: a deal matches the
/// basket, so it is offered the cart's attributes and never the catalogue's.
const _dealOptionsPayload = {
  'conditionAttributes': [
    {
      'key': 'cart',
      'label': 'Cart attribute',
      'children': [
        {
          'key': 'cart|base_sub_total',
          'label': 'Subtotal',
          'type': 'price',
          'operators': [
            {'operator': '>=', 'label': 'Equals or greater than'},
          ],
        },
        {
          'key': 'cart|payment_method',
          'label': 'Payment Method',
          'type': 'select',
          'operators': [
            {'operator': '==', 'label': 'Is equal to'},
          ],
          'options': [
            {'value': 'cashondelivery', 'label': 'Cash On Delivery'},
          ],
        },
      ],
    },
  ],
};

class _Marketing implements SellerMarketingRepository {
  _Marketing({this.joinable});

  final List<SellerProductDiscount> discounts = const [];
  final List<SellerCheckoutDeal> deals = const [];
  final SellerJoinableDiscount? joinable;

  Map<String, dynamic>? savedDiscount;
  Map<String, dynamic>? savedDeal;
  int? readJoinable;

  static PaginatedResult<T> _page<T>(List<T> items) => PaginatedResult<T>(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<PaginatedResult<SellerProductDiscount>> productDiscounts({
    int page = 1,
    String? search,
    int? status,
  }) async => _page(discounts);

  @override
  Future<PaginatedResult<SellerJoinableDiscount>> joinableDiscounts({
    int page = 1,
    String? search,
    int? status,
    String? participation,
  }) async => _page([?joinable]);

  @override
  Future<PaginatedResult<SellerCheckoutDeal>> checkoutDeals({
    int page = 1,
    String? search,
    int? status,
    int? couponType,
  }) async => _page(deals);

  @override
  Future<SellerRuleOptions> ruleOptions() async =>
      SellerRuleOptions.fromJson(_optionsPayload);

  @override
  Future<SellerRuleOptions> dealOptions() async =>
      SellerRuleOptions.fromJson(_dealOptionsPayload);

  @override
  Future<SellerJoinableDiscount> joinableDiscount(int id) async {
    readJoinable = id;
    return joinable!;
  }

  @override
  Future<SellerProductDiscount> createProductDiscount(
    SellerProductDiscount discount,
  ) async {
    savedDiscount = discount.toInput();
    return discount;
  }

  @override
  Future<SellerProductDiscount> updateProductDiscount(
    SellerProductDiscount discount,
  ) async {
    savedDiscount = discount.toInput();
    return discount;
  }

  @override
  Future<SellerCheckoutDeal> createCheckoutDeal(SellerCheckoutDeal deal) async {
    savedDeal = deal.toInput();
    return deal;
  }

  @override
  Future<SellerCheckoutDeal> updateCheckoutDeal(SellerCheckoutDeal deal) async {
    savedDeal = deal.toInput();
    return deal;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerMarketingCubit> _open(
  WidgetTester tester,
  _Marketing repository, {
  SellerProductDiscount? discount,
  SellerCheckoutDeal? deal,
}) async {
  final cubit = SellerMarketingCubit(repository: repository);
  await cubit.load();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => deal != null || discount == null && deal == null
              ? openDealEditor(context, cubit: cubit, deal: deal)
              : openDiscountEditor(context, cubit: cubit, discount: discount),
          child: const Text('open'),
        ),
      ),
    ),
  );
  return cubit;
}

/// Opens the catalogue-rule editor on [discount], or on a new rule.
Future<SellerMarketingCubit> _openDiscount(
  WidgetTester tester,
  _Marketing repository, {
  SellerProductDiscount? discount,
}) async {
  final cubit = SellerMarketingCubit(repository: repository);
  await cubit.load();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () =>
              openDiscountEditor(context, cubit: cubit, discount: discount),
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return cubit;
}

/// The editor is one long form, so most of it starts off-screen.
Future<void> _tap(WidgetTester tester, Key key) async {
  // A lazy list builds a row only once it is near the screen, so scroll until
  // it exists; the discount form builds everything, so then bring it on-screen.
  if (find.byKey(key).evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      find.byKey(key),
      240,
      scrollable: find.byType(Scrollable).first,
    );
  }
  // A field still holding focus scrolls itself back into view on the next
  // frame, undoing the scroll below.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump();
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

/// A session that never signs in — the marketing screen only reads the
/// operator's switches off it, and an unknown session leaves them all on.
class _NoAuth implements SellerAuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  testWidgets('condition fields use dark theme surfaces', (tester) async {
    final options = SellerRuleOptions.fromJson(_optionsPayload);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SellerDiscountConditionRow(
            condition: const SellerDiscountCondition(
              attribute: 'product|new',
              operator: '==',
              value: '0',
            ),
            groups: options.conditionGroups,
            onChanged: (_) {},
            onRemoved: () {},
          ),
        ),
      ),
    );

    for (final field in tester.widgetList<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    )) {
      expect(field.decoration.filled, isTrue);
      expect(field.decoration.fillColor, AppColors.neutral900);
      expect(field.decoration.enabledBorder, isA<OutlineInputBorder>());
    }
  });

  testWidgets('the attributes are the server\'s, grouped as it groups them', (
    tester,
  ) async {
    await _openDiscount(tester, _Marketing());

    await _tap(tester, const Key('sellerRuleConditionAdd'));

    await _tap(tester, const Key('sellerRuleConditionAttribute'));

    // The group heading, and the attributes under it.
    expect(find.text('PRODUCT ATTRIBUTE'), findsOneWidget);
    expect(find.text('Categories'), findsWidgets);
    expect(find.text('Price'), findsWidgets);
    // A catalogue rule matches products only; the cart group belongs to deals.
    expect(find.text('CART ATTRIBUTE'), findsNothing);
  });

  testWidgets('the operators are the ones that attribute takes', (
    tester,
  ) async {
    // Every operator used to be offered for every attribute, so a seller
    // could write "Categories greater than 4" and the rule matched nothing.
    await _openDiscount(tester, _Marketing());

    await _tap(tester, const Key('sellerRuleConditionAdd'));
    await _tap(tester, const Key('sellerRuleConditionAttribute'));
    await tester.tap(find.text('Categories').last);
    await tester.pumpAndSettle();

    await _tap(tester, const Key('sellerRuleConditionOperator'));

    expect(find.text('Contains'), findsWidgets);
    expect(find.text('Does not contain'), findsWidgets);
    expect(find.text('Equals or greater than'), findsNothing);
  });

  testWidgets('a category value is picked from the list, not typed', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    await tester.enterText(find.byKey(const Key('sellerRuleName')), 'Monsoon');
    await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '10');
    await _tap(tester, const Key('sellerRuleConditionAdd'));
    await _tap(tester, const Key('sellerRuleConditionAttribute'));
    await tester.tap(find.text('Categories').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerRuleValueOption_4')));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('Mugs'), findsOneWidget);

    await _tap(tester, const Key('sellerRuleSave'));

    final conditions = repository.savedDiscount!['conditions'] as List;
    expect(conditions.single, {
      'attribute': 'product|category_ids',
      'operator': '{}',
      'value': '4',
    });
  });

  testWidgets(
    'a new rule starts on every channel and group, as the panel does',
    (tester) async {
      final repository = _Marketing();
      await _openDiscount(tester, repository);

      await tester.enterText(
        find.byKey(const Key('sellerRuleName')),
        'Monsoon',
      );
      await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '10');
      await _tap(tester, const Key('sellerRuleSave'));

      expect(repository.savedDiscount!['channels'], [1]);
      expect(repository.savedDiscount!['customerGroups'], [1, 2, 3]);
    },
  );

  testWidgets('the groups a rule already has are the ones shown, and kept', (
    tester,
  ) async {
    // A fixed 1 / 1,2,3 used to be sent on every save, so a rule the panel
    // had limited to Wholesale came back applying to everyone.
    final repository = _Marketing();
    await _openDiscount(
      tester,
      repository,
      discount: const SellerProductDiscount(
        id: 28,
        name: 'Wholesale only',
        discountAmount: 10,
        channels: [1],
        customerGroups: [3],
      ),
    );

    await _tap(tester, const Key('sellerRuleSave'));

    expect(repository.savedDiscount!['customerGroups'], [3]);
  });

  testWidgets('a rule nobody would see is refused before the request', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(
      tester,
      repository,
      discount: const SellerProductDiscount(
        id: 28,
        name: 'Wholesale only',
        discountAmount: 10,
        channels: [1],
        customerGroups: [3],
      ),
    );

    // Customer groups are a dropdown of tags: open it, then untick Wholesale.
    await _tap(tester, const Key('sellerRuleGroupField'));
    await _tap(tester, const Key('sellerRuleGroup_3'));
    await _tap(tester, const Key('sellerRuleSave'));

    expect(find.byKey(const Key('sellerRuleAudienceError')), findsOneWidget);
    expect(repository.savedDiscount, isNull);
  });

  testWidgets('the discount form carries the panel\'s headings, in its order', (
    tester,
  ) async {
    await _openDiscount(tester, _Marketing());

    expect(find.text('Create Product Discount'), findsOneWidget);
    expect(
      find.text('How would you like to discount these products?'),
      findsOneWidget,
    );
    expect(find.text('Percentage off the price'), findsOneWidget);
    expect(find.text('Fixed amount off the price'), findsOneWidget);
    expect(find.text('Discount Amount *'), findsOneWidget);
    expect(find.text('What should this discount be called?'), findsOneWidget);
    expect(find.text('Name *'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Settings'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('When should it run?'), findsOneWidget);
    expect(find.text('Which products should it match?'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Stop Further Rules'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
  });

  testWidgets('priority starts at 0 and the type cards pick the action', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    await tester.enterText(find.byKey(const Key('sellerRuleName')), 'Monsoon');
    await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '5');
    await _tap(tester, const Key('sellerRuleAction_by_fixed'));
    await _tap(tester, const Key('sellerRuleSave'));

    expect(repository.savedDiscount!['sortOrder'], 0);
    expect(repository.savedDiscount!['actionType'], 'by_fixed');
  });

  testWidgets('a missing name or amount is named instead of failing silently', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    await _tap(tester, const Key('sellerRuleSave'));

    expect(find.text('The Name field is required'), findsOneWidget);
    expect(find.text('The Discount Amount field is required'), findsOneWidget);
    expect(repository.savedDiscount, isNull);
  });

  testWidgets('a percentage over 100 and a backwards date range are refused', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    await tester.enterText(find.byKey(const Key('sellerRuleName')), 'Monsoon');
    await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '150');
    await _tap(tester, const Key('sellerRuleSave'));

    expect(find.text('A percentage cannot be more than 100'), findsOneWidget);
    expect(repository.savedDiscount, isNull);
  });

  testWidgets('a condition row with no attribute is not saved', (tester) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    await tester.enterText(find.byKey(const Key('sellerRuleName')), 'Monsoon');
    await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '10');
    await _tap(tester, const Key('sellerRuleConditionAdd'));
    await _tap(tester, const Key('sellerRuleSave'));

    expect(repository.savedDiscount!['conditions'], isEmpty);
  });

  testWidgets('channels and groups are tags in a dropdown with a search', (
    tester,
  ) async {
    final repository = _Marketing();
    await _openDiscount(tester, repository);

    // Everything starts chosen, shown as tags.
    expect(find.byKey(const Key('sellerRuleChannelTag_1')), findsOneWidget);
    expect(find.byKey(const Key('sellerRuleGroupTag_2')), findsOneWidget);
    expect(find.byKey(const Key('sellerRuleGroup_2')), findsNothing);

    // Opening it lists the groups; search narrows them.
    await _tap(tester, const Key('sellerRuleGroupField'));
    expect(find.byKey(const Key('sellerRuleGroup_2')), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('sellerRuleGroupSearch')),
      'whole',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sellerRuleGroup_3')), findsOneWidget);
    expect(find.byKey(const Key('sellerRuleGroup_2')), findsNothing);

    // A tag's cross removes that group.
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('sellerRuleGroupTag_1')),
        matching: find.byIcon(Icons.clear),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sellerRuleGroupTag_1')), findsNothing);

    await tester.enterText(find.byKey(const Key('sellerRuleName')), 'Monsoon');
    await tester.enterText(find.byKey(const Key('sellerRuleAmount')), '10');
    await _tap(tester, const Key('sellerRuleSave'));

    expect(repository.savedDiscount!['customerGroups'], [2, 3]);
  });

  testWidgets('a deal keeps the conditions it was written with', (
    tester,
  ) async {
    // The editor never showed a deal's conditions, and the save replaces the
    // whole set, so every edit of a deal emptied them.
    final repository = _Marketing();
    final cubit = await _open(
      tester,
      repository,
      deal: const SellerCheckoutDeal(
        id: 41,
        name: 'Autumn cart deal',
        discountAmount: 5,
        channels: [1],
        customerGroups: [1, 2, 3],
        conditions: [
          SellerDiscountCondition(
            attribute: 'cart|base_sub_total',
            operator: '>=',
            value: '500',
          ),
        ],
      ),
    );
    addTearDown(cubit.close);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // On screen, under the cart heading the server sends for a deal.
    await tester.scrollUntilVisible(
      find.byKey(const Key('sellerRuleCondition_0')),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Subtotal'), findsOneWidget);

    await _tap(tester, const Key('sellerRuleSave'));

    expect((repository.savedDeal!['conditions'] as List).single, {
      'attribute': 'cart|base_sub_total',
      'operator': '>=',
      'value': '500',
    });
  });

  testWidgets('the join tab is named the way the panel names it', (
    tester,
  ) async {
    // It read "Marketplace campaigns", so a seller looking for the panel's
    // "Join Product Discounts" could not find it and reported it missing.
    final repository = _Marketing(
      joinable: const SellerJoinableDiscount(
        id: 14,
        name: 'Marketplace Autumn Sale',
        discountAmount: 10,
        participation: 'approved',
        enrolled: true,
      ),
    );
    final cubit = SellerMarketingCubit(repository: repository);
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: BlocProvider.value(
            value: SellerSessionCubit(
              authRepository: _NoAuth(),
              accountRepositoryBuilder: (_) => throw UnimplementedError(),
            ),
            child: const SellerMarketingPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Join product discounts'), findsOneWidget);
    expect(find.text('Marketplace campaigns'), findsNothing);

    await tester.tap(find.text('Join product discounts'));
    await tester.pumpAndSettle();
    expect(find.text('Marketplace Autumn Sale'), findsOneWidget);
  });

  testWidgets('the join screen shows the terms, read from the server', (
    tester,
  ) async {
    final repository = _Marketing(
      joinable: const SellerJoinableDiscount(
        id: 14,
        name: 'Marketplace Autumn Sale',
        description: 'Admin-run promotion sellers may opt into.',
        discountAmount: 10,
        participation: 'approved',
        enrolled: true,
        sortOrder: 0,
        channels: [1],
        customerGroups: [1, 2, 3],
        conditions: [
          SellerDiscountCondition(
            attribute: 'product|category_ids',
            operator: '{}',
            value: '4',
          ),
        ],
      ),
    );
    final cubit = SellerMarketingCubit(repository: repository);
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => openJoinDetail(
              context,
              cubit: cubit,
              campaign: cubit.state.joinable.single,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(repository.readJoinable, 14);
    expect(find.text('Marketplace Autumn Sale'), findsWidgets);
    expect(find.text('Approved'), findsOneWidget);
    // The conditions read as words, not as ids: "Categories / Contains Mugs".
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Contains Mugs'), findsOneWidget);
    // Who it applies to, by name — further down the page.
    await tester.scrollUntilVisible(
      find.byKey(const Key('sellerJoinDetailLeave')),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Guest, General, Wholesale'), findsOneWidget);
    // Already in it, so the way out is what is offered.
    expect(find.byKey(const Key('sellerJoinDetailLeave')), findsOneWidget);
  });
  testWidgets('a deal is offered cart attributes, a discount catalogue ones', (
    tester,
  ) async {
    // Both editors read the product-discount options, which carry `product|*`
    // only, so a deal's real conditions -- payment method, shipping method,
    // country -- had to be typed by hand and a typo produced a deal that
    // never applied. The server publishes the cart set separately now.
    final repository = _Marketing();
    final cubit = await _open(
      tester,
      repository,
      deal: const SellerCheckoutDeal(
        id: 42,
        name: 'Pay on delivery',
        discountAmount: 5,
        channels: [1],
        customerGroups: [1, 2, 3],
      ),
    );
    addTearDown(cubit.close);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await _tap(tester, const Key('sellerRuleConditionAdd'));
    await _tap(tester, const Key('sellerRuleConditionAttribute'));

    // The basket's attributes, and none of the catalogue's.
    expect(find.text('CART ATTRIBUTE'), findsOneWidget);
    expect(find.text('Payment Method'), findsWidgets);
    expect(find.text('Subtotal'), findsWidgets);
    expect(find.text('PRODUCT ATTRIBUTE'), findsNothing);
    expect(find.text('Categories'), findsNothing);
  });
}
