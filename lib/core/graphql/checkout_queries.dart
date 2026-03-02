/// GraphQL queries and mutations for Bagisto checkout flow
/// Based on the actual Bagisto Headless Commerce GraphQL schema

class CheckoutQueries {
  /// Get saved checkout addresses (billing & shipping)
  static const String getCheckoutAddresses = r'''
    query collectionGetCheckoutAddresses {
      collectionGetCheckoutAddresses {
        edges {
          node {
            id
            addressType
            firstName
            lastName
            companyName
            address
            city
            state
            country
            postcode
            email
            phone
            defaultAddress
            useForShipping
          }
        }
      }
    }
  ''';

  /// Get available shipping rates
  static const String getShippingRates = r'''
    query CheckoutShippingRates{
      collectionShippingRates{
        id
        code
        label
        description
        method
        methodTitle
        price
        formattedPrice
        basePrice
        baseFormattedPrice
        carrier
        carrierTitle
      }
    }
  ''';

  /// Get available payment methods
  static const String getPaymentMethods = r'''
    query CheckoutPaymentMethods {
      collectionPaymentMethods {
        id
        method
        title
        description
        icon
        isAllowed
      }
    }
  ''';

  /// Get all available countries (for address form dropdowns)
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/queries/get-countries.html
  static const String getCountries = r'''
    query countries {
      countries(first: 250) {
        edges {
          node {
            id
            _id
            code
            name
          }
        }
      }
    }
  ''';

  /// Get states/provinces for a specific country
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/queries/get-country-state.html
  /// Returns CountryStateCursorConnection — requires edges/node wrapper
  static const String getCountryStates = r'''
    query countryStates($countryId: Int!, $first: Int) {
      countryStates(countryId: $countryId, first: $first) {
        edges {
          node {
            id
            _id
            code
            defaultName
            countryId
            countryCode
          }
        }
      }
    }
  ''';

  /// Alternative query using country code
  static const String getCountryStatesByCode = r'''
    query countryStatesByCode($countryCode: String!, $first: Int) {
      countryStates(countryCode: $countryCode, first: $first) {
        edges {
          node {
            id
            _id
            code
            defaultName
            countryId
            countryCode
          }
        }
      }
    }
  ''';
}

class CheckoutMutations {
  /// Save checkout address (billing + optional shipping)
  static const String createCheckoutAddress = r'''
    mutation createCheckoutAddress($input: createCheckoutAddressInput!) {
      createCheckoutAddress(input: $input) {
        checkoutAddress {
          success
          message
          id
          cartToken
        }
      }
    }
  ''';

  /// Save selected shipping method
  static const String createCheckoutShippingMethod = r'''
    mutation createCheckoutShippingMethod($input: createCheckoutShippingMethodInput!) {
      createCheckoutShippingMethod(input: $input) {
        checkoutShippingMethod {
          success
          id
          message
        }
      }
    }
  ''';

  /// Save selected payment method
  static const String createCheckoutPaymentMethod = r'''
    mutation createCheckoutPaymentMethod($input: createCheckoutPaymentMethodInput!) {
      createCheckoutPaymentMethod(input: $input) {
        checkoutPaymentMethod {
          success
          message
          paymentGatewayUrl
          paymentData
        }
      }
    }
  ''';

  /// Place order
  static const String createCheckoutOrder = r'''
    mutation createCheckoutOrder {
      createCheckoutOrder(input: {}) {
        checkoutOrder {
          id
          orderId
          orderIncrementId
          success
          message
        }
      }
    }
  ''';

  /// Apply coupon code
  static const String createApplyCoupon = r'''
    mutation createApplyCoupon($input: createApplyCouponInput!) {
      createApplyCoupon(input: $input) {
        applyCoupon {
          success
          message
          couponCode
          discountAmount
          formattedDiscountAmount
          grandTotal
          formattedGrandTotal
          subtotal
          formattedSubtotal
          taxAmount
          formattedTaxAmount
          shippingAmount
          formattedShippingAmount
        }
      }
    }
  ''';

  /// Remove coupon code
  static const String createRemoveCoupon = r'''
    mutation createRemoveCoupon($input: createRemoveCouponInput!) {
      createRemoveCoupon(input: $input) {
        removeCoupon {
          success
          message
          couponCode
          discountAmount
          formattedDiscountAmount
          grandTotal
          formattedGrandTotal
          subtotal
          formattedSubtotal
          taxAmount
          formattedTaxAmount
          shippingAmount
          formattedShippingAmount
        }
      }
    }
  ''';
}
