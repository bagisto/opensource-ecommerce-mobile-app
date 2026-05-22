import 'dart:async';

import 'package:bagisto_flutter/features/checkout/data/models/checkout_model.dart';
import 'package:bagisto_flutter/features/checkout/data/repository/checkout_repository.dart';
import 'package:bagisto_flutter/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:bagisto_flutter/features/checkout/presentation/helpers/checkout_address_sheet_helpers.dart';
import 'package:bagisto_flutter/features/checkout/presentation/widgets/checkout_address_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  test(
    'findNewlyAddedSelectableAddress resolves the new saved address from customer ids',
    () {
      const existingAddress = CheckoutAddress(
        id: 'cust-1',
        firstName: 'Paul',
        lastName: 'Doe',
      );
      const anotherAddress = CheckoutAddress(
        id: 'cust-2',
        firstName: 'Sujal',
        lastName: 'Gorivale',
      );
      const newAddress = CheckoutAddress(
        id: 'cust-3',
        firstName: 'Jitendra',
        lastName: 'Office',
      );

      final result = findNewlyAddedSelectableAddress(
        previousCustomerIds: const {'cust-1', 'cust-2'},
        refreshedCustomerIds: const ['cust-1', 'cust-2', 'cust-3'],
        refreshedAddresses: const [existingAddress, anotherAddress, newAddress],
      );

      expect(result?.id, 'cust-3');
    },
  );

  test('findNewlyAddedCheckoutAddress returns the first new address by id', () {
    const existingAddress = CheckoutAddress(
      id: 'addr-1',
      firstName: 'Paul',
      lastName: 'Doe',
    );
    const newAddress = CheckoutAddress(
      id: 'addr-2',
      firstName: 'Jitendra',
      lastName: 'Office',
    );

    final result = findNewlyAddedCheckoutAddress(
      previousIds: const {'addr-1'},
      refreshedAddresses: const [existingAddress, newAddress],
    );

    expect(result?.id, 'addr-2');
  });

  test(
    'RefreshSavedAddresses loads customer fallback addresses when checkout addresses are empty',
    () async {
      final repository = _FakeCheckoutRepository(
        checkoutAddresses: const [],
        customerAddresses: const [
          CheckoutAddress(
            id: 'cust-1',
            firstName: 'Fallback',
            lastName: 'Address',
          ),
        ],
      );
      final bloc = _SeededCheckoutBloc(repository: repository)
        ..seedState(
          const CheckoutState(
            isGuest: false,
            addresses: [
              CheckoutAddress(
                id: 'stale-1',
                firstName: 'Old',
                lastName: 'Address',
              ),
            ],
          ),
        );
      final completer = Completer<List<CheckoutAddress>>();

      final emission = expectLater(
        bloc.stream,
        emits(
          isA<CheckoutState>().having(
            (state) => state.addresses.single.id,
            'refreshed address id',
            'cust-1',
          ),
        ),
      );

      bloc.add(RefreshSavedAddresses(completer: completer));

      await emission;
      expect((await completer.future).single.id, 'cust-1');
      await bloc.close();
    },
  );

  test(
    'SelectSavedAddress includes separate shipping fields when shipping differs from billing',
    () async {
      final repository = _FakeCheckoutRepository(
        checkoutAddresses: const [],
        customerAddresses: const [],
        shippingRates: const [],
      );
      final bloc = _SeededCheckoutBloc(repository: repository)
        ..seedState(const CheckoutState(isGuest: false, isVirtualOnly: false));

      const billingAddress = CheckoutAddress(
        id: 'bill-1',
        firstName: 'Billing',
        lastName: 'User',
        address: 'Billing Street',
        city: 'Noida',
        state: 'UP',
        country: 'IN',
        postcode: '201001',
        phone: '1111111111',
      );
      const shippingAddress = CheckoutAddress(
        id: 'ship-1',
        firstName: 'Shipping',
        lastName: 'User',
        address: 'Shipping Street',
        city: 'Mumbai',
        state: 'MH',
        country: 'IN',
        postcode: '400001',
        phone: '9999999999',
      );

      final emission = expectLater(
        bloc.stream,
        emitsThrough(
          isA<CheckoutState>().having(
            (state) => state.selectedAddress?.id,
            'selected billing address id',
            'bill-1',
          ),
        ),
      );

      bloc.add(
        const SelectSavedAddress(
          address: billingAddress,
          useForShipping: false,
          shippingAddress: shippingAddress,
        ),
      );

      await emission;
      expect(repository.lastSavedInput?['useForShipping'], isFalse);
      expect(repository.lastSavedInput?['shippingFirstName'], 'Shipping');
      expect(repository.lastSavedInput?['shippingCity'], 'Mumbai');
      await bloc.close();
    },
  );

  test(
    'SaveCheckoutAddressEvent saves first manual checkout address to the address book when requested',
    () async {
      final repository = _FakeCheckoutRepository(
        checkoutAddresses: const [],
        customerAddresses: const [],
        shippingRates: const [],
      );
      final bloc = _SeededCheckoutBloc(repository: repository)
        ..seedState(const CheckoutState(isGuest: false, isVirtualOnly: false));

      final emission = expectLater(
        bloc.stream,
        emitsThrough(
          isA<CheckoutState>()
              .having(
                (state) => state.addressConfirmed,
                'address confirmed',
                isTrue,
              )
              .having(
                (state) => state.addresses.single.id,
                'saved address id',
                'cust-1',
              ),
        ),
      );

      bloc.add(
        const SaveCheckoutAddressEvent(
          input: {
            'billingFirstName': 'First',
            'billingLastName': 'Customer',
            'billingEmail': 'first@example.com',
            'billingAddress': 'Street 1',
            'billingCity': 'Noida',
            'billingCountry': 'IN',
            'billingState': 'UP',
            'billingPostcode': '201301',
            'billingPhoneNumber': '9999999999',
            'useForShipping': true,
          },
          saveToAddressBook: true,
        ),
      );

      await emission;
      expect(repository.lastCreatedCustomerAddressInput?['firstName'], 'First');
      expect(
        repository.lastCreatedCustomerAddressInput?['defaultAddress'],
        isTrue,
      );
      expect(
        repository.lastCreatedCustomerAddressInput?['useForShipping'],
        isTrue,
      );
      await bloc.close();
    },
  );

  testWidgets(
    'CheckoutAddressSelectionSheet shows Add New Address and calls callbacks',
    (WidgetTester tester) async {
      CheckoutAddress? tappedAddress;
      var addTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckoutAddressSelectionSheet(
              title: 'Select Shipping Address',
              addButtonLabel: 'Add New Address',
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
              selectedAddressId: 'addr-1',
              onAddressSelected: (address) => tappedAddress = address,
              onAddNewAddress: () => addTapped = true,
              addressTypeLabelBuilder: (_) => 'Home',
              phoneLabelBuilder: (phone) => 'Phone: $phone',
            ),
          ),
        ),
      );

      expect(find.text('Add New Address'), findsOneWidget);

      await tester.tap(find.text('Paul Doe'));
      await tester.pump();

      await tester.tap(find.text('Add New Address'));
      await tester.pump();

      expect(tappedAddress?.id, 'addr-1');
      expect(addTapped, isTrue);
    },
  );
}

class _SeededCheckoutBloc extends CheckoutBloc {
  _SeededCheckoutBloc({required super.repository});

  void seedState(CheckoutState state) {
    emit(state);
  }
}

class _FakeCheckoutRepository extends CheckoutRepository {
  final List<CheckoutAddress> checkoutAddresses;
  final List<CheckoutAddress> _initialCustomerAddresses;
  final List<ShippingRate> shippingRates;
  Map<String, dynamic>? lastSavedInput;
  Map<String, dynamic>? lastCreatedCustomerAddressInput;
  late final List<CheckoutAddress> _customerAddresses;

  _FakeCheckoutRepository({
    required this.checkoutAddresses,
    required List<CheckoutAddress> customerAddresses,
    this.shippingRates = const [],
  }) : _initialCustomerAddresses = customerAddresses,
       super(
         client: GraphQLClient(
           link: HttpLink('https://example.com/graphql'),
           cache: GraphQLCache(store: InMemoryStore()),
         ),
       ) {
    _customerAddresses = List<CheckoutAddress>.from(_initialCustomerAddresses);
  }

  List<CheckoutAddress> get customerAddresses => _customerAddresses;

  @override
  Future<List<CheckoutAddress>> getCheckoutAddresses() async =>
      checkoutAddresses;

  @override
  Future<List<CheckoutAddress>> getCustomerAddresses() async =>
      customerAddresses;

  @override
  Future<CheckoutAddressResponse> saveCheckoutAddress(
    Map<String, dynamic> input,
  ) async {
    lastSavedInput = Map<String, dynamic>.from(input);
    return const CheckoutAddressResponse(
      success: true,
      cartToken: 'cart-token-1',
    );
  }

  @override
  Future<List<ShippingRate>> getShippingRates({String? queryToken}) async =>
      shippingRates;

  @override
  Future<void> saveCustomerAddressFromCheckout(
    Map<String, dynamic> checkoutInput, {
    bool defaultAddress = false,
  }) async {
    lastCreatedCustomerAddressInput = {
      'firstName': checkoutInput['billingFirstName'],
      'lastName': checkoutInput['billingLastName'],
      'email': checkoutInput['billingEmail'],
      'address': checkoutInput['billingAddress'],
      'city': checkoutInput['billingCity'],
      'state': checkoutInput['billingState'],
      'country': checkoutInput['billingCountry'],
      'postcode': checkoutInput['billingPostcode'],
      'phone': checkoutInput['billingPhoneNumber'],
      'defaultAddress': defaultAddress,
      'useForShipping': checkoutInput['useForShipping'] == true,
    };

    _customerAddresses.add(
      CheckoutAddress(
        id: 'cust-${_customerAddresses.length + 1}',
        addressType: 'home',
        firstName: checkoutInput['billingFirstName']?.toString() ?? '',
        lastName: checkoutInput['billingLastName']?.toString() ?? '',
        address: checkoutInput['billingAddress']?.toString() ?? '',
        city: checkoutInput['billingCity']?.toString() ?? '',
        state: checkoutInput['billingState']?.toString(),
        country: checkoutInput['billingCountry']?.toString(),
        postcode: checkoutInput['billingPostcode']?.toString(),
        email: checkoutInput['billingEmail']?.toString(),
        phone: checkoutInput['billingPhoneNumber']?.toString(),
        defaultAddress: defaultAddress,
        useForShipping: checkoutInput['useForShipping'] == true,
      ),
    );
  }
}
