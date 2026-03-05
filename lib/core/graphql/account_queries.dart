// GraphQL queries for Account Dashboard
// APIs: Customer Profile, Customer Addresses, Product Reviews
//
// Note: Orders and Wishlist queries are NOT available in the
// Bagisto demo storefront GraphQL schema. The dashboard gracefully
// shows empty states for those sections.

class AccountQueries {
  /// Get customer profile
  /// Actual API query: readCustomerProfile(id: ID!)
  /// Returns: CustomerProfile type
  static const String getCustomerProfile = r'''
    query getCustomerProfile {
      readCustomerProfile {
        id
        firstName
        lastName
        email
        dateOfBirth
        gender
        phone
        status
        subscribedToNewsLetter
        isVerified
        image
      }
    }
  ''';

  /// Get customer addresses (cursor-based pagination)
  /// Actual API query: getCustomerAddresses
  /// Returns: GetCustomerAddressesCursorConnection
  static const String getCustomerAddresses = r'''
    query getCustomerAddresses($first: Int, $after: String) {
      getCustomerAddresses(first: $first, after: $after) {
        edges {
          node {
            id
            _id
            addressType
            firstName
            lastName
            email
            companyName
            vatId
            address
            city
            state
            country
            postcode
            phone
            defaultAddress
            useForShipping
            createdAt
            updatedAt
            name
          }
        }
        pageInfo {
          hasNextPage
          endCursor
        }
        totalCount
      }
    }
  ''';

  /// Get product reviews (cursor-based pagination)
  /// Actual API query: productReviews
  /// Returns: ProductReviewCursorConnection
  /// Note: Pass productId to fetch reviews for a specific product.
  static const String getProductReviews = r'''
    query productReviews($first: Int, $after: String, $productId: Int) {
      productReviews(first: $first, after: $after, product_id: $productId) {
        edges {
          node {
            id
            _id
            name
            title
            rating
            comment
            status
            createdAt
            updatedAt
          }
          cursor
        }
        pageInfo {
          hasNextPage
          endCursor
        }
        totalCount
      }
    }
  ''';

  /// Get customer reviews (cursor-based pagination) with product data.
  /// Bagisto API query: customerReviews(first: Int, after: String)
  /// Returns review with nested product (name, sku, type, images) for UI display.
  static const String getCustomerReviews = r'''
    query getCustomerReviews($first: Int, $after: String) {
      customerReviews(first: $first, after: $after) {
        edges {
          cursor
          node {
            id
            _id
            title
            comment
            rating
            status
            name
            product {
              id
              _id
              sku
              type
              name
              baseImageUrl
              images {
                edges {
                  node {
                    path
                  }
                }
              }
            }
            customer {
              id
              _id
            }
            createdAt
            updatedAt
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  // ─── Address Mutations ───

  /// Set address as default using createAddUpdateCustomerAddress mutation.
  /// The Bagisto API uses the same mutation for create/update with addressId + defaultAddress.
  /// Note: This requires the full address data, so we use createAddUpdateCustomerAddress
  /// with addressId and defaultAddress: true.
  static const String setDefaultAddress = r'''
    mutation setDefaultAddress($input: createAddUpdateCustomerAddressInput!) {
      createAddUpdateCustomerAddress(input: $input) {
        addUpdateCustomerAddress {
          id
          addressId
          firstName
          lastName
          email
          phone
          address1
          address2
          country
          state
          city
          postcode
          useForShipping
          defaultAddress
        }
      }
    }
  ''';

  /// Delete customer address
  /// Bagisto API mutation: createDeleteCustomerAddress(input: createDeleteCustomerAddressInput!)
  static const String deleteCustomerAddress = r'''
    mutation createDeleteCustomerAddress($input: createDeleteCustomerAddressInput!) {
      createDeleteCustomerAddress(input: $input) {
        deleteCustomerAddress {
          status
          message
        }
      }
    }
  ''';

  /// Add/update a customer address
  /// Discovered via schema introspection on api-demo.bagisto.com:
  ///   mutation: createAddUpdateCustomerAddress
  ///   input type: createAddUpdateCustomerAddressInput
  ///   Fields: addressId (Int, optional — omit for create),
  ///           firstName, lastName, email, phone, address1, address2,
  ///           country, state, city, postcode,
  ///           useForShipping (Boolean), defaultAddress (Boolean)
  static const String createAddUpdateCustomerAddress = r'''
    mutation createAddUpdateCustomerAddress($input: createAddUpdateCustomerAddressInput!) {
      createAddUpdateCustomerAddress(input: $input) {
        addUpdateCustomerAddress {
          id
          addressId
          firstName
          lastName
          email
          phone
          address1
          address2
          country
          state
          city
          postcode
          useForShipping
          defaultAddress
        }
      }
    }
  ''';

  // ─── Profile Mutations ───

  /// Update customer profile
  /// Bagisto API mutation: updateCustomerProfile
  /// Input: firstName, lastName, phone, gender, dateOfBirth, subscribedToNewsLetter
  static const String updateCustomerProfile = r'''
    mutation createCustomerProfileUpdate($input: createCustomerProfileUpdateInput!) {
      createCustomerProfileUpdate(input: $input) {
        customerProfileUpdate {
          id
        }
      }
    }
  ''';

  /// Change customer email — requires current password for verification
  /// Bagisto API mutation: updateCustomerProfile with email + currentPassword
  static const String changeCustomerEmail = r'''
    mutation createCustomerProfileUpdate($input: createCustomerProfileUpdateInput!) {
      createCustomerProfileUpdate(input: $input) {
        customerProfileUpdate {
          id
        }
      }
    }
  ''';

  /// Change customer password — requires current + new password
  /// Bagisto API mutation: updateCustomerProfile with password fields
  static const String changeCustomerPassword = r'''
    mutation createCustomerProfileUpdate($input: createCustomerProfileUpdateInput!) {
      createCustomerProfileUpdate(input: $input) {
        customerProfileUpdate {
          id
        }
      }
    }
  ''';

  /// Delete customer account — requires current password for verification
  /// Bagisto API mutation: deleteCustomerAccount
  static const String deleteCustomerAccount = r'''
    mutation createCustomerProfileDelete($input: createCustomerProfileDeleteInput!) {
      createCustomerProfileDelete(input: $input) {
        customerProfileDelete {
          success
          message
        }
      }
    }
  ''';

  /// Get available countries for address form (cursor-paginated).
  /// Bagisto API: countries(first: Int, after: String)
  /// Returns: CountryCursorConnection { edges { node { ... } } }
  /// We request first=260 to get all countries in one call.
  static const String getCountries = r'''
    query countries($first: Int) {
      countries(first: $first) {
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

  /// Get states/provinces for a specific country (cursor-paginated).
  /// Bagisto API: countryStates(countryId: Int!, first: Int)
  /// Returns: CountryStateCursorConnection { edges { node { ... } } }
  /// We request first=200 to get all states in one call.
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

  // ─── Wishlist Queries & Mutations ───

  /// Get wishlists (cursor-paginated).
  /// Bagisto API: wishlists(first: Int, after: String)
  /// Returns: WishlistCursorConnection { edges { node { ... } }, pageInfo, totalCount }
  static const String getWishlists = r'''
    query GetAllWishlists($first: Int, $after: String) {
      wishlists(first: $first, after: $after) {
        edges {
          cursor
          node {
            id
            _id
            product {
              id
              _id
              name
              price
              sku
              type
              description
              baseImageUrl
              urlKey
            }
            customer {
              id
              email
            }
            channel {
              id
              code
              translation {
                name
              }
            }
            createdAt
            updatedAt
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Delete a wishlist item.
  /// Bagisto API mutation: deleteWishlist(input: deleteWishlistInput!)
  static const String deleteWishlist = r'''
    mutation DeleteWishlist($input: deleteWishlistInput!) {
      deleteWishlist(input: $input) {
        wishlist {
          id
          _id
        }
      }
    }
  ''';

  /// Move a wishlist item to cart.
  /// Bagisto API mutation: moveWishlistToCart(input: moveWishlistToCartInput!)
  static const String moveWishlistToCart = r'''
    mutation MoveWishlistToCart($input: moveWishlistToCartInput!) {
      moveWishlistToCart(input: $input) {
        wishlistToCart {
          message
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Compare Items
  // ──────────────────────────────────────────────

  /// Get compare items (cursor-paginated).
  /// Bagisto API query: compareItems(first: Int, after: String)
  /// Returns: CompareItemCursorConnection
  static const String getCompareItems = r'''
    query GetCompareItems($first: Int, $after: String) {
      compareItems(first: $first, after: $after) {
        edges {
          cursor
          node {
            id
            _id
            product {
              id
              name
              description
              price
              baseImageUrl
              urlKey
            }
            customer {
              id
              email
              firstName
              lastName
            }
            createdAt
            updatedAt
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Delete a single compare item.
  /// Bagisto API mutation: deleteCompareItem(input: deleteCompareItemInput!)
  static const String deleteCompareItem = r'''
    mutation DeleteCompareItem($id: ID!) {
      deleteCompareItem(input: {id: $id}) {
        compareItem {
          id
          product {
            sku
            type
            createdAt
          }
        }
      }
    }
  ''';

  /// Delete all compare items.
  /// Bagisto API mutation: createDeleteAllCompareItems(input: {})
  static const String deleteAllCompareItems = r'''
    mutation createDeleteAllCompareItems {
      createDeleteAllCompareItems(input: {}) {
        deleteAllCompareItems {
          message
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Create Wishlist
  // ──────────────────────────────────────────────

  /// Add product to wishlist.
  /// Bagisto API mutation: createWishlist(input: createWishlistInput!)
  static const String createWishlist = r'''
    mutation CreateWishlist($input: createWishlistInput!) {
      createWishlist(input: $input) {
        wishlist {
          id
          _id
          product {
            id
            name
            price
          }
          createdAt
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Create Compare Item
  // ──────────────────────────────────────────────

  /// Add product to compare list.
  /// Bagisto API mutation: createCompareItem(input: createCompareItemInput!)
  static const String createCompareItem = r'''
    mutation CreateCompareItem($input: createCompareItemInput!) {
      createCompareItem(input: $input) {
        compareItem {
          id
          _id
          createdAt
          updatedAt
          product {
            id
          }
          customer {
            id
          }
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Customer Orders
  // ──────────────────────────────────────────────

  /// Get customer orders (cursor-based pagination).
  /// Bagisto API query: customerOrders(first: Int, after: String, status: String)
  /// Returns: CustomerOrderCursorConnection
  static const String getCustomerOrders = r'''
    query getCustomerOrders($first: Int, $after: String, $status: String) {
      customerOrders(first: $first, after: $after, status: $status) {
        edges {
          cursor
          node {
            id
            _id
            incrementId
            status
            channelName
            customerEmail
            customerFirstName
            customerLastName
            totalItemCount
            totalQtyOrdered
            grandTotal
            baseGrandTotal
            subTotal
            taxAmount
            discountAmount
            shippingAmount
            shippingTitle
            couponCode
            orderCurrencyCode
            baseCurrencyCode
            createdAt
            updatedAt
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Get a single customer order detail by ID.
  /// Bagisto API query: customerOrder(id: ID!)
  /// The id is the IRI format (e.g. "/api/shop/customer-orders/1").
  /// Note: The Bagisto storefront schema only exposes flat scalar fields
  /// on CustomerOrder — no nested items/addresses/payment/invoices/shipments.
  static const String getCustomerOrder = r'''
    query getCustomerOrder($id: ID!) {
      customerOrder(id: $id) {
        incrementId
        status
        channelName
        customerEmail
        customerFirstName
        customerLastName
        shippingMethod
        shippingTitle
        couponCode
        totalItemCount
        totalQtyOrdered
        grandTotal
        baseGrandTotal
        grandTotalInvoiced
        grandTotalRefunded
        subTotal
        baseSubTotal
        taxAmount
        baseTaxAmount
        discountAmount
        baseDiscountAmount
        shippingAmount
        baseShippingAmount
        baseCurrencyCode
        channelCurrencyCode
        orderCurrencyCode
        payment {
          id
          methodTitle
        }
        items {
          edges {
            node {
              id
              sku
              name
              qtyOrdered
              qtyShipped
              qtyInvoiced
              qtyCanceled
              qtyRefunded
            }
          }
        }
        addresses {
          edges {
            node {
              id
              _id
              addressType
              parentAddressId
              customerId
              cartId
              orderId
              name
              firstName
              lastName
              companyName
              address
              city
              state
              country
              postcode
              useForShipping
              email
              phone
              gender
              vatId
              defaultAddress
              createdAt
              updatedAt
            }
          }
        }
        createdAt
        updatedAt
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Create Product Review
  // ──────────────────────────────────────────────

  /// Create a product review.
  /// Bagisto API mutation: createProductReview(input: createProductReviewInput!)
  /// Required: productId, title, comment, rating, name
  /// Optional: email, status, attachments, clientMutationId
  static const String createProductReview = r'''
    mutation createProductReview($input: createProductReviewInput!) {
      createProductReview(input: $input) {
        productReview {
          id
          _id
          name
          title
          rating
          comment
          status
          createdAt
          updatedAt
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Customer Invoices
  // ──────────────────────────────────────────────

  /// Get customer invoices with items (cursor-based pagination).
  /// Bagisto API query: customerInvoices(first: Int, after: String, orderId: Int, state: String)
  /// Returns: CustomerInvoiceCursorConnection with items
  static const String getCustomerInvoices = r'''
    query getCustomerInvoices($first: Int, $after: String, $orderId: Int, $state: String) {
      customerInvoices(first: $first, after: $after, orderId: $orderId, state: $state) {
        edges {
          cursor
          node {
            _id
            incrementId
            state
            totalQty
            orderCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            shippingAmount
            baseShippingAmount
            taxAmount
            baseTaxAmount
            discountAmount
            baseDiscountAmount
            baseCurrencyCode
            orderCurrencyCode
            transactionId
            createdAt
            updatedAt
            items {
              edges {
                node {
                  id
                  _id
                  sku
                  parentId
                  name
                  price
                  qty
                  total
                  basePrice
                  description
                  baseTotal
                  taxAmount
                  baseTaxAmount
                  discountPercent
                  discountAmount
                  baseDiscountAmount
                  priceInclTax
                  basePriceInclTax
                  totalInclTax
                  baseTotalInclTax
                  productId
                  productType
                  orderItemId
                  invoiceId
                  createdAt
                  updatedAt
                }
              }
            }
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Get a single customer invoice detail by ID with items.
  /// Bagisto API query: customerInvoice(id: ID!)
  /// The id is the IRI format (e.g. "/api/shop/customer-invoices/1").
  static const String getCustomerInvoice = r'''
    query getCustomerInvoice($id: ID!) {
      customerInvoice(id: $id) {
        _id
        incrementId
        state
        totalQty
        emailSent
        grandTotal
        baseGrandTotal
        downloadUrl
        subTotal
        baseSubTotal
        shippingAmount
        baseShippingAmount
        taxAmount
        baseTaxAmount
        discountAmount
        baseDiscountAmount
        shippingTaxAmount
        baseShippingTaxAmount
        subTotalInclTax
        baseSubTotalInclTax
        shippingAmountInclTax
        baseShippingAmountInclTax
        baseCurrencyCode
        channelCurrencyCode
        orderCurrencyCode
        transactionId
        reminders
        nextReminderAt
        createdAt
        updatedAt
        items {
          edges {
            node {
              id
              _id
              sku
              name
              qty
              price
              total
              basePrice
              description
              baseTotal
              taxAmount
              baseTaxAmount
              discountPercent
              discountAmount
              baseDiscountAmount
              priceInclTax
              basePriceInclTax
              totalInclTax
              baseTotalInclTax
              productId
              productType
              orderItemId
              invoiceId
              createdAt
              updatedAt
            }
          }
        }
      }
    }
  ''';

  // ──────────────────────────────────────────────
  // Reorder
  // ──────────────────────────────────────────────

  /// Reorder an existing order.
  /// Bagisto API mutation: createReorderOrder(input: reorderOrderInput!)
  /// Required: orderId (Int)
  /// Returns: success, message, orderId, itemsAddedCount
 static const String reorderOrder = r'''
mutation createReorderOrder($input: createReorderOrderInput!) {
  createReorderOrder(input: $input) {
    reorderOrder {
      success
      message
      orderId
      itemsAddedCount
    }
  }
}
''';

  // ──────────────────────────────────────────────
  // Customer Shipments
  // ──────────────────────────────────────────────

  /// Get customer order shipments (cursor-based pagination).
  /// Bagisto API query: customerOrderShipments(orderId: Int!)
  /// Returns: CustomerOrderShipmentCursorConnection with items
  static const String getCustomerOrderShipments = r'''
    query getOrderShipments($orderId: Int!) {
      customerOrderShipments(orderId: $orderId) {
        edges {
          node {
            id
            _id
            status
            trackNumber
            carrierTitle
            totalQty
            createdAt
            items {
              edges {
                node {
                  id
                  name
                  sku
                  qty
                }
              }
            }
            shippingNumber
          }
        }
        totalCount
      }
    }
  ''';

  /// Get a single customer order shipment detail by ID.
  /// Bagisto API query: customerOrderShipment(id: Int!)
  /// Returns: Shipment with items
  static const String getCustomerOrderShipment = r'''
    query getOrderShipment($id: Int!) {
      customerOrderShipment(id: $id) {
        id
        _id
        status
        trackNumber
        carrierTitle
        totalQty
        createdAt
        items {
          edges {
            node {
              id
              name
              sku
              qty
            }
          }
        }
        shippingNumber
      }
    }
  ''';

  /// Get available locales for language selection
  /// Actual API query: locales
  /// Returns: LocalesCursorConnection with available languages/locales
  static const String getLocales = r'''
    query getLocales {
      locales {
        edges {
          node {
            id
            _id
            code
            name
            direction
          }
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  ''';

  /// Get customer downloadable products (cursor-based pagination)
  /// Bagisto API query: customerDownloadableProducts(first: Int, after: String)
  /// Returns: DownloadableProductCursorConnection with product details
  static const String getCustomerDownloadableProducts = r'''
    query getCustomerDownloadableProducts($first: Int, $after: String) {
      customerDownloadableProducts(first: $first, after: $after) {
        edges {
          cursor
          node {
            _id
            productName
            name
            fileName
            type
            downloadBought
            downloadUsed
            downloadCanceled
            status
            remainingDownloads
            order {
              _id
              incrementId
              status
            }
            createdAt
            updatedAt
          }
        }
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Get CMS pages list
  /// Bagisto API query: pages
  /// Returns: PagesCursorConnection with page details including translations
  static const String getCmsPages = r'''
    query getCmsPages {
      pages {
        edges {
          node {
            id
            _id
            layout
            createdAt
            updatedAt
            translation {
              id
              _id
              pageTitle
              urlKey
              htmlContent
              metaTitle
              metaDescription
              metaKeywords
              locale
            }
          }
        }
      }
    }
  ''';

  /// Create contact us submission
  /// Bagisto API mutation: createContactUs
  /// Returns: ContactUsResponse with success and message
  static const String createContactUs = r'''
    mutation createContactUs($input: createContactUsInput!) {
      createContactUs(input: $input) {
        contactUs {
          success
          message
        }
      }
    }
  ''';
}
