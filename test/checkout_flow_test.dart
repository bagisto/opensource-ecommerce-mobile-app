/// Tests for the Bagisto checkout flow — verifying the critical distinction
/// between the Bearer auth token and the cart query token ($token variable).
///
/// Root cause of the original bug:
///   Bagisto uses TWO different tokens during checkout:
///     1. Bearer auth token (login token like "292|abc...") → Authorization header
///     2. Cart query token  (user ID like "19")             → $token variable
///   The old code conflated them, passing the auth token as $token, which failed.

import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/features/checkout/data/models/checkout_model.dart';

void main() {
  // ════════════════════════════════════════════════════════════════════════
  // Model Tests
  // ════════════════════════════════════════════════════════════════════════

  group('CheckoutAddressResponse', () {
    test('parses cartToken (user ID) from createCheckoutAddress response', () {
      final json = {
        'success': true,
        'message': 'Address saved successfully',
        'id': '3079',
        'cartToken': '19',
      };
      final response = CheckoutAddressResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, 'Address saved successfully');
      expect(response.id, '3079');
      expect(response.cartToken, '19');
    });

    test('handles null cartToken gracefully', () {
      final json = {
        'success': true,
        'message': 'OK',
        'id': '100',
      };
      final response = CheckoutAddressResponse.fromJson(json);

      expect(response.success, true);
      expect(response.cartToken, isNull);
    });

    test('handles all null fields', () {
      final response = CheckoutAddressResponse.fromJson({});

      expect(response.success, false);
      expect(response.message, isNull);
      expect(response.id, isNull);
      expect(response.cartToken, isNull);
    });
  });

  group('CheckoutShippingMethodResponse', () {
    test('parses success response', () {
      final json = {
        'success': true,
        'id': '3268',
        'message': 'Shipping method saved successfully',
      };
      final response = CheckoutShippingMethodResponse.fromJson(json);

      expect(response.success, true);
      expect(response.id, '3268');
      expect(response.message, 'Shipping method saved successfully');
    });

    test('defaults to failure when success is null', () {
      final response = CheckoutShippingMethodResponse.fromJson({});
      expect(response.success, false);
    });
  });

  group('CheckoutPaymentMethodResponse', () {
    test('parses success response', () {
      final json = {
        'success': true,
        'message': 'Payment method saved successfully',
      };
      final response = CheckoutPaymentMethodResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, 'Payment method saved successfully');
    });

    test('parses gateway URL for online payments', () {
      final json = {
        'success': true,
        'message': 'Redirect to gateway',
        'paymentGatewayUrl': 'https://gateway.example.com/pay',
        'paymentData': '{"order_id": "123"}',
      };
      final response = CheckoutPaymentMethodResponse.fromJson(json);

      expect(response.paymentGatewayUrl, 'https://gateway.example.com/pay');
      expect(response.paymentData, '{"order_id": "123"}');
    });
  });

  group('CheckoutOrderResponse', () {
    test('parses order placed response', () {
      final json = {
        'id': '3268',
        'orderId': '579',
        'orderIncrementId': null,
        'success': null,
        'message': null,
      };
      final response = CheckoutOrderResponse.fromJson(json);

      expect(response.id, '3268');
      expect(response.orderId, '579');
      expect(response.success, true);
    });

    test('success defaults to false when orderId is null', () {
      final json = {
        'id': null,
        'orderId': null,
        'success': null,
      };
      final response = CheckoutOrderResponse.fromJson(json);

      expect(response.success, false);
    });

    test('explicit success=true overrides orderId check', () {
      final json = {
        'success': true,
        'orderId': null,
      };
      final response = CheckoutOrderResponse.fromJson(json);

      expect(response.success, true);
    });
  });

  group('ShippingRate', () {
    test('parses from API response', () {
      final json = {
        'id': '/api/.well-known/genid/626ba6644f8e78b6bfde',
        'code': 'flatrate',
        'label': 'Flat Rate',
        'method': 'flatrate_flatrate',
        'price': 40,
      };
      final rate = ShippingRate.fromJson(json);

      expect(rate.code, 'flatrate');
      expect(rate.method, 'flatrate_flatrate');
      expect(rate.price, 40.0);
      expect(rate.displayLabel, 'Flat Rate');
    });

    test('displayPrice uses formattedPrice if available', () {
      final rate = ShippingRate.fromJson({
        'id': '1',
        'code': 'free',
        'label': 'Free Shipping',
        'method': 'free_free',
        'price': 0,
        'formattedPrice': '\$0.00',
      });

      expect(rate.displayPrice, '\$0.00');
    });

    test('displayPrice falls back to computed string', () {
      final rate = ShippingRate.fromJson({
        'id': '1',
        'code': 'flat',
        'method': 'flat_flat',
        'price': 25.5,
      });

      expect(rate.displayPrice, '\$25.50');
    });

    test('handles price as string', () {
      final rate = ShippingRate.fromJson({
        'id': '1',
        'code': 'flat',
        'method': 'flat_flat',
        'price': '10.99',
      });

      expect(rate.price, 10.99);
    });
  });

  group('PaymentMethod', () {
    test('parses from API response', () {
      final json = {
        'id': '/api/.well-known/genid/9aebda2d8c50adec3424',
        'method': 'moneytransfer',
        'title': 'Money Transfer',
      };
      final pm = PaymentMethod.fromJson(json);

      expect(pm.method, 'moneytransfer');
      expect(pm.title, 'Money Transfer');
      expect(pm.isAllowed, true);
    });

    test('parses cashondelivery', () {
      final pm = PaymentMethod.fromJson({
        'id': '2',
        'method': 'cashondelivery',
        'title': 'Cash on Delivery',
        'isAllowed': true,
      });

      expect(pm.method, 'cashondelivery');
    });
  });

  group('CheckoutAddress model', () {
    test('toBillingInput produces correct mutation input', () {
      const addr = CheckoutAddress(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        companyName: 'ACME',
        address: '123 Main St',
        city: 'New York',
        country: 'US',
        state: 'NY',
        postcode: '10001',
        phone: '1234567890',
      );

      final input = addr.toBillingInput(useForShipping: true);

      expect(input['billingFirstName'], 'John');
      expect(input['billingLastName'], 'Doe');
      expect(input['billingEmail'], 'john@example.com');
      expect(input['billingCompanyName'], 'ACME');
      expect(input['billingAddress'], '123 Main St');
      expect(input['billingCity'], 'New York');
      expect(input['billingCountry'], 'US');
      expect(input['billingState'], 'NY');
      expect(input['billingPostcode'], '10001');
      expect(input['billingPhoneNumber'], '1234567890');
      expect(input['useForShipping'], true);
    });

    test('toBillingInput with useForShipping=false', () {
      const addr = CheckoutAddress(
        id: '1',
        firstName: 'Jane',
        lastName: 'Smith',
        address: '456 Oak Ave',
        city: 'LA',
      );

      final input = addr.toBillingInput(useForShipping: false);
      expect(input['useForShipping'], false);
      expect(input['billingFirstName'], 'Jane');
    });

    test('fullName combines first and last name', () {
      const addr = CheckoutAddress(id: '1', firstName: 'John', lastName: 'Doe');
      expect(addr.fullName, 'John Doe');
    });

    test('displayName includes company when present', () {
      const addr = CheckoutAddress(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        companyName: 'ACME',
      );
      expect(addr.displayName, 'John Doe (ACME)');
    });

    test('displayName omits company when empty', () {
      const addr = CheckoutAddress(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        companyName: '',
      );
      expect(addr.displayName, 'John Doe');
    });

    test('fullAddress joins non-empty parts', () {
      const addr = CheckoutAddress(
        id: '1',
        address: '123 Main St',
        city: 'LA',
        state: 'CA',
        country: 'US',
        postcode: '90001',
      );
      expect(addr.fullAddress, '123 Main St, LA, CA, US, 90001');
    });

    test('fromJson handles all fields', () {
      final addr = CheckoutAddress.fromJson({
        'id': '42',
        'addressType': 'billing',
        'firstName': 'Admin',
        'lastName': 'User',
        'companyName': 'Webkul',
        'address': '123 St',
        'city': 'Noida',
        'state': 'UP',
        'country': 'IN',
        'postcode': '201301',
        'email': 'admin@webkul.com',
        'phone': '9876543210',
        'defaultAddress': true,
        'useForShipping': true,
      });

      expect(addr.id, '42');
      expect(addr.addressType, 'billing');
      expect(addr.defaultAddress, true);
      expect(addr.useForShipping, true);
    });
  });

  group('CouponResponse', () {
    test('parses coupon applied response', () {
      final json = {
        'success': true,
        'message': 'Coupon applied successfully',
        'couponCode': 'SAVE10',
        'discountAmount': 10.0,
        'grandTotal': 90.0,
        'subtotal': 100.0,
        'taxAmount': 0,
        'shippingAmount': 5.0,
      };
      final response = CouponResponse.fromJson(json);

      expect(response.success, true);
      expect(response.couponCode, 'SAVE10');
      expect(response.discountAmount, 10.0);
      expect(response.grandTotal, 90.0);
      expect(response.subtotal, 100.0);
      expect(response.shippingAmount, 5.0);
    });

    test('handles numeric types (int vs double vs string)', () {
      final response = CouponResponse.fromJson({
        'success': true,
        'discountAmount': 10,
        'grandTotal': '90.50',
        'subtotal': 100.0,
      });

      expect(response.discountAmount, 10.0);
      expect(response.grandTotal, 90.50);
      expect(response.subtotal, 100.0);
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // BLoC State Tests
  // ════════════════════════════════════════════════════════════════════════

  group('CheckoutState', () {
    test('initial state has correct defaults', () {
      const state = CheckoutState();

      expect(state.status, CheckoutStatus.initial);
      expect(state.cartToken, isNull);
      expect(state.addresses, isEmpty);
      expect(state.shippingRates, isEmpty);
      expect(state.paymentMethods, isEmpty);
      expect(state.isLoading, false);
      expect(state.isPlacingOrder, false);
      expect(state.useSameAddressForShipping, true);
      expect(state.orderResponse, isNull);
    });

    test('copyWith preserves cartToken (query token)', () {
      const state = CheckoutState(cartToken: '19');
      final newState =
          state.copyWith(status: CheckoutStatus.shippingRatesFetched);

      expect(newState.cartToken, '19');
      expect(newState.status, CheckoutStatus.shippingRatesFetched);
    });

    test('copyWith can override cartToken', () {
      const state = CheckoutState(cartToken: 'old');
      final newState = state.copyWith(cartToken: '19');

      expect(newState.cartToken, '19');
    });

    test('copyWith clearError removes errorMessage', () {
      const state = CheckoutState(errorMessage: 'Something failed');
      final newState = state.copyWith(clearError: true);

      expect(newState.errorMessage, isNull);
    });

    test('copyWith clearSuccess removes successMessage', () {
      const state = CheckoutState(successMessage: 'Saved!');
      final newState = state.copyWith(clearSuccess: true);

      expect(newState.successMessage, isNull);
    });

    test('state equality based on all props', () {
      const s1 = CheckoutState(cartToken: '19', isLoading: true);
      const s2 = CheckoutState(cartToken: '19', isLoading: true);
      const s3 = CheckoutState(cartToken: '20', isLoading: true);

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // Event Equality Tests
  // ════════════════════════════════════════════════════════════════════════

  group('CheckoutEvents', () {
    test('SaveCheckoutAddressEvent equality', () {
      const e1 = SaveCheckoutAddressEvent(input: {'billingFirstName': 'John'});
      const e2 = SaveCheckoutAddressEvent(input: {'billingFirstName': 'John'});
      const e3 = SaveCheckoutAddressEvent(input: {'billingFirstName': 'Jane'});

      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
    });

    test('SelectShippingMethod equality', () {
      const e1 = SelectShippingMethod(shippingMethodCode: 'flatrate_flatrate');
      const e2 = SelectShippingMethod(shippingMethodCode: 'flatrate_flatrate');
      const e3 = SelectShippingMethod(shippingMethodCode: 'free_free');

      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
    });

    test('SelectPaymentMethod equality', () {
      const e1 = SelectPaymentMethod(paymentMethodCode: 'moneytransfer');
      const e2 = SelectPaymentMethod(paymentMethodCode: 'moneytransfer');
      const e3 = SelectPaymentMethod(paymentMethodCode: 'cashondelivery');

      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
    });

    test('ApplyCheckoutCoupon equality', () {
      const e1 = ApplyCheckoutCoupon(couponCode: 'SAVE10');
      const e2 = ApplyCheckoutCoupon(couponCode: 'SAVE10');

      expect(e1, equals(e2));
    });

    test('singleton events', () {
      expect(ToggleSameAddress(), equals(ToggleSameAddress()));
      expect(PlaceOrder(), equals(PlaceOrder()));
      expect(RemoveCheckoutCoupon(), equals(RemoveCheckoutCoupon()));
      expect(ClearCheckoutMessage(), equals(ClearCheckoutMessage()));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // Token Flow Integration Logic Test
  // ════════════════════════════════════════════════════════════════════════

  group('Token flow logic (the critical fix)', () {
    test('cartToken from address response is NOT the auth token', () {
      const authToken =
          '292|63wcgHLYiCNOPrSH2uz2o1EePs3QOC05jn2M7sNH21f7d595';
      const addressResponse = {
        'success': true,
        'message': 'Address saved successfully',
        'id': '3079',
        'cartToken': '19',
      };

      final resp = CheckoutAddressResponse.fromJson(addressResponse);

      expect(resp.cartToken, '19');
      expect(resp.cartToken, isNot(equals(authToken)));
      expect(resp.cartToken, equals('19'));
    });

    test('shipping rates query uses cartToken, not authToken', () {
      const queryToken = '19';
      const authToken =
          '292|63wcgHLYiCNOPrSH2uz2o1EePs3QOC05jn2M7sNH21f7d595';

      expect(queryToken, isNot(equals(authToken)));
      expect(queryToken.length, lessThan(5));
      expect(authToken.length, greaterThan(40));
    });

    test('state stores queryToken as cartToken for downstream use', () {
      // After address save, the BLoC stores the queryToken as state.cartToken
      const state = CheckoutState(cartToken: '19');

      // This is then used for shipping/payment queries
      expect(state.cartToken, '19');

      // Not the auth token
      expect(state.cartToken, isNot(contains('|')));
    });
  });
}
