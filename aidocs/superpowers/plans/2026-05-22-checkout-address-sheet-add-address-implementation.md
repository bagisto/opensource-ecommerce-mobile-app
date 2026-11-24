# Checkout Address Sheet Add Address Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an `Add New Address` action to the checkout address selection sheet, refresh saved addresses after creation, and apply the new address to billing or shipping based on the `Change` action that launched the flow.

**Architecture:** Keep checkout as the source of truth for saved checkout addresses while reusing the existing account add-address form and `AddressBookBloc` create flow. Add a small checkout refresh event plus page-level helper methods so the bottom sheet can launch add-address, refresh addresses, detect the new address by ID diff, and update billing or shipping selection without reinitializing checkout.

**Tech Stack:** Flutter, Dart, `flutter_bloc`, existing `CheckoutBloc`, existing `AddressBookBloc`, widget tests with `flutter_test`

---

### Task 1: Add a failing checkout widget test for the bottom sheet action

**Files:**
- Create: `test/checkout_address_sheet_test.dart`
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
testWidgets(
  'shipping address sheet shows Add New Address action',
  (tester) async {
    final cartBloc = _TestCartBloc();
    final authBloc = _TestAuthBloc.authenticated();
    final checkoutBloc = _TestCheckoutBloc.withLoadedAddresses(
      addresses: const [
        CheckoutAddress(
          id: 'addr-1',
          firstName: 'Paul',
          lastName: 'Doe',
          address: 'New Noida',
          city: 'Noida',
          state: 'UP',
          country: 'IN',
          postcode: '201306',
          phone: '5467756767',
        ),
      ],
    );

    await tester.pumpWidget(
      _buildCheckoutHarness(
        cartBloc: cartBloc,
        authBloc: authBloc,
        checkoutBloc: checkoutBloc,
      ),
    );

    await tester.tap(find.text('Change').last);
    await tester.pumpAndSettle();

    expect(find.text('Add New Address'), findsOneWidget);
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL because the address selection sheet does not render `Add New Address`

- [ ] **Step 3: Write minimal test harness support**

```dart
Widget _buildCheckoutHarness({
  required CartBloc cartBloc,
  required AuthBloc authBloc,
  required CheckoutBloc checkoutBloc,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CartBloc>.value(value: cartBloc),
      BlocProvider<AuthBloc>.value(value: authBloc),
      BlocProvider<CheckoutBloc>.value(value: checkoutBloc),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _CheckoutPageView(),
    ),
  );
}
```

- [ ] **Step 4: Run test to verify the harness compiles**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL on missing button assertion, not on test harness setup

- [ ] **Step 5: Commit**

```bash
git add test/checkout_address_sheet_test.dart
git commit -m "test: cover checkout address sheet action"
```

### Task 2: Add checkout address refresh support in the bloc

**Files:**
- Modify: `lib/features/checkout/presentation/bloc/checkout_bloc.dart`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Write a failing bloc-oriented widget test for refresh-after-add**

```dart
testWidgets(
  'refreshing addresses after add updates checkout state list',
  (tester) async {
    final checkoutBloc = _TestCheckoutBloc.withLoadedAddresses(
      addresses: const [
        CheckoutAddress(id: 'addr-1', firstName: 'Paul', lastName: 'Doe'),
      ],
    );

    checkoutBloc.refreshedAddresses = const [
      CheckoutAddress(id: 'addr-1', firstName: 'Paul', lastName: 'Doe'),
      CheckoutAddress(id: 'addr-2', firstName: 'Jitendra', lastName: 'Office'),
    ];

    await tester.pumpWidget(_buildCheckoutHarnessWithBloc(checkoutBloc));

    checkoutBloc.add(const RefreshSavedAddresses());
    await tester.pump();

    expect(checkoutBloc.state.addresses.length, 2);
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL because `RefreshSavedAddresses` does not exist

- [ ] **Step 3: Add the minimal event and handler**

```dart
class RefreshSavedAddresses extends CheckoutEvent {
  const RefreshSavedAddresses();
}

on<RefreshSavedAddresses>(_onRefreshSavedAddresses);

Future<void> _onRefreshSavedAddresses(
  RefreshSavedAddresses event,
  Emitter<CheckoutState> emit,
) async {
  final addresses = await repository.getCheckoutAddresses();
  final customerAddresses = addresses
      .where(
        (a) =>
            a.addressType != 'cart_billing' &&
            a.addressType != 'cart_shipping',
      )
      .toList();

  emit(
    state.copyWith(
      addresses: customerAddresses.isNotEmpty
          ? customerAddresses
          : addresses,
    ),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: PASS for refresh behavior, with other new assertions still failing

- [ ] **Step 5: Commit**

```bash
git add lib/features/checkout/presentation/bloc/checkout_bloc.dart test/checkout_address_sheet_test.dart
git commit -m "feat: add checkout saved address refresh"
```

### Task 3: Add the bottom-sheet `Add New Address` action and launch flow

**Files:**
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Modify: `test/checkout_address_sheet_test.dart`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Write a failing test for tapping the new action**

```dart
testWidgets(
  'tapping Add New Address opens add address flow',
  (tester) async {
    final observer = _RecordingNavigatorObserver();

    await tester.pumpWidget(
      _buildCheckoutHarnessWithObserver(observer: observer),
    );

    await tester.tap(find.text('Change').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add New Address'));
    await tester.pumpAndSettle();

    expect(observer.pushedRouteNames, contains('add-address'));
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL because the button or launch helper is missing

- [ ] **Step 3: Add the button and helper flow**

```dart
Widget _buildAddAddressButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => _handleAddAddressFromSheet(context, isBilling: isBilling),
      child: Text(AppLocalizations.of(context)!.accountAddNewAddress),
    ),
  );
}

Future<void> _handleAddAddressFromSheet(
  BuildContext context, {
  required bool isBilling,
}) async {
  final existingIds = context
      .read<CheckoutBloc>()
      .state
      .addresses
      .map((address) => address.id)
      .toSet();

  Navigator.of(context).pop();

  final created = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      settings: const RouteSettings(name: 'add-address'),
      builder: (_) => RepositoryProvider.value(
        value: context.read<AccountRepository>(),
        child: BlocProvider(
          create: (_) => AddressBookBloc(
            repository: context.read<AccountRepository>(),
          ),
          child: const AddAddressPage(),
        ),
      ),
    ),
  );

  if (created == true && mounted) {
    await _refreshAndApplyNewAddress(
      context,
      existingIds: existingIds,
      isBilling: isBilling,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: PASS for button visibility and launch behavior

- [ ] **Step 5: Commit**

```bash
git add lib/features/checkout/presentation/pages/checkout_page.dart test/checkout_address_sheet_test.dart
git commit -m "feat: add checkout address sheet add action"
```

### Task 4: Refresh addresses, detect the new address, and apply billing or shipping selection

**Files:**
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Modify: `test/checkout_address_sheet_test.dart`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Write failing tests for billing and shipping application**

```dart
testWidgets(
  'billing add flow auto-selects the newly created billing address',
  (tester) async {
    final checkoutBloc = _TestCheckoutBloc.withLoadedAddresses(
      addresses: const [
        CheckoutAddress(id: 'addr-1', firstName: 'Paul', lastName: 'Doe'),
      ],
    )..refreshedAddresses = const [
        CheckoutAddress(id: 'addr-1', firstName: 'Paul', lastName: 'Doe'),
        CheckoutAddress(id: 'addr-2', firstName: 'Jitendra', lastName: 'Office'),
      ];

    await tester.pumpWidget(_buildCheckoutHarnessWithBloc(checkoutBloc));
    await tester.tap(find.text('Change').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add New Address'));
    await tester.pumpAndSettle();

    expect(checkoutBloc.recordedEvents.whereType<SelectSavedAddress>().single.address.id, 'addr-2');
  },
);

testWidgets(
  'shipping add flow selects the newly created shipping address locally',
  (tester) async {
    await tester.pumpWidget(_buildCheckoutHarnessWithSeparateShipping());
    await tester.tap(find.text('Change').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add New Address'));
    await tester.pumpAndSettle();

    expect(find.text('Jitendra Office'), findsOneWidget);
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL because the refresh-and-apply helper does not exist

- [ ] **Step 3: Implement the refresh-and-apply helper**

```dart
Future<void> _refreshAndApplyNewAddress(
  BuildContext context, {
  required Set<String> existingIds,
  required bool isBilling,
}) async {
  final bloc = context.read<CheckoutBloc>();
  bloc.add(const RefreshSavedAddresses());
  await Future<void>.delayed(Duration.zero);

  final refreshedAddresses = bloc.state.addresses;
  final newAddress = refreshedAddresses.firstWhere(
    (address) => !existingIds.contains(address.id),
    orElse: () => const CheckoutAddress(id: ''),
  );

  if (newAddress.id.isEmpty) {
    return;
  }

  setState(() {
    if (isBilling) {
      _selectedBillingAddress = newAddress;
    } else {
      _selectedShippingAddress = newAddress;
    }
  });

  if (isBilling) {
    bloc.add(SelectSavedAddress(address: newAddress));
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: PASS for billing and shipping add-address application behavior

- [ ] **Step 5: Commit**

```bash
git add lib/features/checkout/presentation/pages/checkout_page.dart test/checkout_address_sheet_test.dart
git commit -m "feat: apply new checkout address by action"
```

### Task 5: Verify separate-shipping checkout save still uses the selected shipping address

**Files:**
- Modify: `test/checkout_address_sheet_test.dart`
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Write a failing test for save payload composition**

```dart
testWidgets(
  'saving checkout with separate shipping uses selected shipping address fields',
  (tester) async {
    final checkoutBloc = _TestCheckoutBloc.withLoadedAddresses(
      addresses: const [
        CheckoutAddress(id: 'addr-1', firstName: 'Paul', lastName: 'Doe'),
        CheckoutAddress(
          id: 'addr-2',
          firstName: 'Jitendra',
          lastName: 'Office',
          address: 'Noida',
          city: 'Noida',
          state: 'UP',
          country: 'IN',
          postcode: '212106',
          phone: '57687687878',
        ),
      ],
    );

    await tester.pumpWidget(_buildCheckoutHarnessWithSeparateShipping(
      checkoutBloc: checkoutBloc,
    ));

    await tester.tap(find.text('Save & Continue'));
    await tester.pump();

    expect(checkoutBloc.recordedSaveInput?['shippingFirstName'], 'Jitendra');
    expect(checkoutBloc.recordedSaveInput?['shippingCity'], 'Noida');
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: FAIL if separate shipping selection is not carried through correctly

- [ ] **Step 3: Keep the save logic aligned with the chosen shipping address**

```dart
if (!useSameAddressForShipping && _selectedShippingAddress != null) {
  final sa = _selectedShippingAddress!;
  input.addAll({
    'shippingFirstName': sa.firstName,
    'shippingLastName': sa.lastName,
    'shippingEmail': sa.email ?? '',
    'shippingCompanyName': sa.companyName ?? '',
    'shippingAddress': sa.address,
    'shippingCity': sa.city,
    'shippingCountry': sa.country ?? '',
    'shippingState': sa.state ?? '',
    'shippingPostcode': sa.postcode ?? '',
    'shippingPhoneNumber': sa.phone ?? '',
  });
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: PASS for shipping payload assertion and prior sheet tests

- [ ] **Step 5: Commit**

```bash
git add lib/features/checkout/presentation/pages/checkout_page.dart test/checkout_address_sheet_test.dart
git commit -m "fix: preserve selected checkout shipping address"
```

### Task 6: Final verification and graph refresh

**Files:**
- Modify: `graphify-out/GRAPH_REPORT.md`
- Modify: `graphify-out/graph.json`
- Test: `test/checkout_address_sheet_test.dart`

- [ ] **Step 1: Run the focused widget tests**

Run: `flutter test test/checkout_address_sheet_test.dart`
Expected: PASS with all address sheet tests green

- [ ] **Step 2: Run analyze on touched files**

Run: `flutter analyze lib/features/checkout/presentation/pages/checkout_page.dart lib/features/checkout/presentation/bloc/checkout_bloc.dart test/checkout_address_sheet_test.dart`
Expected: `No issues found!`

- [ ] **Step 3: Refresh graphify output**

Run: `graphify update .`
Expected: `Code graph updated`

- [ ] **Step 4: Review diff for scope**

Run: `git diff -- lib/features/checkout/presentation/pages/checkout_page.dart lib/features/checkout/presentation/bloc/checkout_bloc.dart test/checkout_address_sheet_test.dart`
Expected: only checkout address sheet, refresh support, and tests are changed

- [ ] **Step 5: Commit**

```bash
git add lib/features/checkout/presentation/pages/checkout_page.dart lib/features/checkout/presentation/bloc/checkout_bloc.dart test/checkout_address_sheet_test.dart graphify-out/GRAPH_REPORT.md graphify-out/graph.json
git commit -m "feat: add checkout address sheet add flow"
```
