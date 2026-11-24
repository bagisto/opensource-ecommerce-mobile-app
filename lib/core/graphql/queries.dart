/// GraphQL queries for the Bagisto category & catalog API
/// Ported from: nextjs-commerce-main/src/graphql/catelog/
library;

class StoreConfigQueries {
  /// Public store settings of the current channel (admin configuration).
  static const String getStoreConfig = r'''
    query storeConfig {
      storeConfig {
        id
        guestCheckoutEnabled
        cartCrossSellEnabled
        relatedProductsLimit
        upSellProductsLimit
        crossSellProductsLimit
        estimateShippingEnabled
        reorderEnabled
        minimumOrderEnabled
        minimumOrderAmount
        minimumOrderIncludesDiscount
        minimumOrderIncludesTax
        minimumOrderMessage
        customerReviewEnabled
        guestReviewEnabled
        reviewerNameCensored
        reviewSummary
        compareEnabled
        wishlistEnabled
        imageSearchEnabled
        socialShareEnabled
        socialShareProviders
        socialShareMessage
        newsletterEnabled
        buyNowButtonEnabled
        cartSummary
        cartPageEnabled
        loginRedirectTo
        miniCartEnabled
        miniCartOfferInfo
        headerOfferTitle
        headerOfferLinkTitle
        headerOfferLink
        orderNumberPrefix
        orderNumberLength
        orderNumberSuffix
        taxCartDisplayPrices
        taxCartDisplaySubtotal
        taxCartDisplayShipping
        taxCartShowBreakdown
        taxOrderDisplayPrices
        taxOrderDisplaySubtotal
        taxOrderDisplayShipping
      }
    }
  ''';

  /// Fetches the configured Bagisto channel with its locales, currencies,
  /// and defaults used during app startup.
  static const String getChannelById = r'''
    query getChannelByID($id: ID!) {
      channel(id: $id) {
        id
        _id
        code
        hostname
        theme
        timezone
        homeSeo
        logoUrl
        faviconUrl
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
        }
        currencies {
          edges {
            node {
              id
              _id
              code
              name
              symbol
            }
          }
        }
        defaultLocale {
          id
          _id
          code
          name
          direction
        }
        baseCurrency {
          id
          _id
          code
          name
          symbol
        }
      }
    }
  ''';
}

class NewsletterQueries {
  /// Subscribes an email address to the storefront newsletter -- the
  /// footer "Subscribe to stay in touch" box. Open to signed-out shoppers
  /// (storefront key only); send the customer's bearer token too when one
  /// is signed in, so the subscription links to their account.
  ///
  /// `success: true` means newly subscribed, `success: false` means the
  /// address was already on the list -- both are normal outcomes, not
  /// errors. There is no unsubscribe or "is this address subscribed"
  /// query; unsubscribe only works via an emailed token link on web.
  static const String subscribe = r'''
    mutation CreateNewsletter($input: createNewsletterInput!) {
      createNewsletter(input: $input) {
        newsletter {
          success
          message
        }
      }
    }
  ''';
}

class CategoryQueries {
  /// Records a storefront search so it shows in the admin's Search Terms.
  /// Public: the storefront key is enough, no login.
  static const String createSearchTerm = r'''
    mutation CreateShopSearchTerm($input: createShopSearchTermInput!) {
      createShopSearchTerm(input: $input) {
        shopSearchTerm {
          id
        }
      }
    }
  ''';

  /// GET_TREE_CATEGORIES – fetches hierarchical category tree
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Category.ts
  static const String getTreeCategories = r'''
    query treeCategories($parentId: Int) {
      treeCategories(parentId: $parentId) {
        id
        _id
        displayMode
        position
        logoPath
        logoUrl
        bannerUrl
        status
        translation {
          id
          name
          slug
          description
          urlPath
          metaTitle
        }
        children {
          edges {
            node {
              id
              _id
              displayMode
              position
              logoPath
              logoUrl
              bannerUrl
              status
              translation {
                id
                name
                slug
                urlPath
              }
            }
          }
        }
      }
    }
  ''';

  /// Categories tab – Bagisto `categories` (Get Categories) query.
  /// Flat, paginated list (max 100 per page) with parent and children so the
  /// app can pick top-level categories and their sub-categories.
  static const String getCategoryTabCategories = r'''
    query CategoryTabCategories($first: Int, $after: String) {
      categories(first: $first, after: $after) {
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            id
            _id
            displayMode
            position
            status
            logoUrl
            bannerUrl
            parent {
              id
              _id
            }
            translation {
              id
              name
              slug
              description
              urlPath
            }
            children {
              edges {
                node {
                  id
                  _id
                  displayMode
                  position
                  status
                  logoUrl
                  bannerUrl
                  translation {
                    id
                    name
                    slug
                    description
                    urlPath
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';

  /// GET_HOME_CATEGORIES – flat list with logo
  /// Source: nextjs-commerce/src/graphql/catelog/queries/HomeCategories.ts
  static const String getHomeCategories = r'''
    query Categories($first: Int) {
      categories(first: $first) {
        edges {
          node {
            id
            _id
            displayMode
            status
            logoUrl
            bannerUrl
            position
            parent {
              id
              _id
            }
            translation {
              name
              slug
              description
              id
              _id
            }
          }
        }
      }
    }
  ''';

  /// Single category query by ID.
  static const String getCategory = r'''
    query Category($id: ID!) {
      category(id: $id) {
        id
        _id
        displayMode
        logoUrl
        bannerUrl
        status
        position
        translation {
          id
          name
          slug
          description
          urlPath
        }
      }
    }
  ''';
}

class ProductQueries {
  /// Review media for one product, keyed by review id.
  ///
  /// The server only fills `attachments` on the top-level `productReviews`
  /// query — on the product's own embedded `reviews` connection it always
  /// answers null, whether or not a customer token is sent. So the product
  /// page asks for the media separately and merges it in by review id.
  /// Asked on its own, best effort: a server without the field still shows
  /// the reviews, just without their photos and videos.
  static const String getProductReviewAttachments = r'''
    query productReviewAttachments($productId: Int, $first: Int) {
      productReviews(first: $first, product_id: $productId) {
        edges {
          node {
            id
            _id
            attachments
            customerImageUrl
          }
        }
      }
    }
  ''';

  /// Product core fragment fields
  static const String _productCoreFragment = r'''
    fragment ProductCore on Product {
      id
      _id
      sku
      type
      bookingType
      name
      new
      featured
      price
      formattedPrice
      urlKey
      baseImageUrl
      minimumPrice
      formattedMinimumPrice
      maximumPrice
      formattedMaximumPrice
      regularMinimumPrice
      formattedRegularMinimumPrice
      regularMaximumPrice
      formattedRegularMaximumPrice
      specialPrice
      formattedSpecialPrice
      bookingProducts {
        edges {
          node {
            type
            startingPrice
            formattedStartingPrice
            startingRegularPrice
            formattedStartingRegularPrice
          }
        }
      }
      isSaleable
       reviews {
       totalCount
        edges {
          node {
            rating
            id
            name
            title
            comment
            createdAt
            customerImageUrl
          }
        }
      }
    }
  ''';

  /// Product section fragment (lightweight)
  static const String _productSectionFragment = r'''
    fragment ProductSection on Product {
      id
      _id
      sku
      name
      new
      featured
      urlKey
      type
      bookingType
      baseImageUrl
      price
      formattedPrice
      minimumPrice
      formattedMinimumPrice
      maximumPrice
      formattedMaximumPrice
      regularMinimumPrice
      formattedRegularMinimumPrice
      regularMaximumPrice
      formattedRegularMaximumPrice
      specialPrice
      formattedSpecialPrice
      bookingProducts {
        edges {
          node {
            type
            startingPrice
            formattedStartingPrice
            startingRegularPrice
            formattedStartingRegularPrice
          }
        }
      }
      isSaleable
       reviews {
       totalCount
        edges {
          node {
            rating
            id
            name
            title
            comment
            createdAt
            customerImageUrl
          }
        }
      }
    }
  ''';

  /// Product detailed common fragment (shared by all product types)
  static const String _productDetailedCommonFragment = r'''
    fragment ProductDetailedCommon on Product {
      id
      _id
      sku
      type
      bookingType
      name
      urlKey
      status
      description
      shortDescription
      price
      formattedPrice
      baseImageUrl
      minimumPrice
      formattedMinimumPrice
      specialPrice
      formattedSpecialPrice
      maximumPrice
      formattedMaximumPrice
      regularMinimumPrice
      regularMaximumPrice
      formattedRegularMinimumPrice
      formattedRegularMaximumPrice
      isSaleable
      guestCheckout
      color
      size
      brand
      images {
        edges {
          node {
            id
            _id
            path
            publicPath
            type
            position
          }
        }
      }
      reviews {
        totalCount
        edges {
          node {
            rating
            id
            name
            title
            comment
            attachments
            createdAt
            customerImageUrl
          }
        }
      }
      relatedProducts {
        edges {
          node {
            ...ProductSection
          }
        }
      }
      upSells {
        edges {
          node {
            ...ProductSection
          }
        }
      }
      customizableOptions {
        edges {
          node {
            id
            _id
            type
            isRequired
            maxCharacters
            supportedFileExtensions
            sortOrder
            translation {
              id
              locale
              label
            }
            customizableOptionPrices {
              edges {
                node {
                  id
                  _id
                  label
                  price
                  formattedPrice
                  sortOrder
                }
              }
            }
          }
        }
      }
    }
  ''';

  static const String _configurableDetailedFields = r'''
      superAttributeOptions
      combinations
      attributeValues {
        edges {
          node {
            value
            attribute {
              code
              adminName
            }
          }
        }
      }
      variants {
        edges {
          node {
            id
            name
            sku
            price
            formattedPrice
            specialPrice
            formattedSpecialPrice
            baseImageUrl
            attributeValues {
              edges {
                node {
                  value
                  attribute {
                    code
                    adminName
                  }
                }
              }
            }
          }
        }
      }
      categories {
        edges {
          node {
            id
            translation {
              name
            }
          }
        }
      }
  ''';

  static const String _downloadableDetailedFields = r'''
      downloadableLinks {
        edges {
          node {
            id
            _id
            type
            price
            formattedPrice
            downloads
            sortOrder
            fileUrl
            sampleFileUrl
            translation {
              title
            }
          }
        }
      }
      downloadableSamples {
        edges {
          node {
            id
            _id
            type
            fileUrl
            sortOrder
            translation {
              title
            }
          }
        }
      }
  ''';

  static const String _groupedDetailedFields = r'''
      groupedProducts {
        edges {
          node {
            id
            qty
            sortOrder
            associatedProduct {
              id
              name
              sku
              price
              formattedPrice
              specialPrice
              formattedSpecialPrice
              images(first: 3) {
                edges {
                  node {
                    id
                    publicPath
                  }
                }
              }
            }
          }
        }
      }
  ''';

  static const String _bundleDetailedFields = r'''
      bundleOptions {
        edges {
          node {
            id
            type
            isRequired
            sortOrder
            translation {
              label
            }
            bundleOptionProducts {
              edges {
                node {
                  id
                  qty
                  isDefault
                  isUserDefined
                  sortOrder
                  product {
                    id
                    name
                    sku
                    price
                    formattedPrice
                    images(first: 3) {
                      edges {
                        node {
                          id
                          publicPath
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
  ''';

  static const String _bookingDetailedFields = r'''
      bookingProducts {
        edges {
          node {
            id
            _id
            type
            startingPrice
            formattedStartingPrice
            startingRegularPrice
            formattedStartingRegularPrice
            qty
            location
            showLocation
            allowCancellation
            availableFrom
            availableTo
            defaultSlot {
              id
              _id
              bookingType
              duration
              breakTime
              slots
            }
            appointmentSlot {
              id
              _id
              bookingProductId
              duration
              breakTime
              sameSlotAllDays
              slots
            }
            rentalSlot {
              id
              _id
              bookingProductId
              rentingType
              dailyPrice
              hourlyPrice
              sameSlotAllDays
              slots
            }
            tableSlot {
              id
              _id
              bookingProductId
              priceType
              guestLimit
              duration
              breakTime
              preventSchedulingBefore
              sameSlotAllDays
              slots
            }
            eventTickets {
              edges {
                node {
                  id
                  _id
                  bookingProductId
                  price
                  formattedPrice
                  qty
                  specialPrice
                  formattedSpecialPrice
                  specialPriceFrom
                  specialPriceTo
                  translation {
                    locale
                    name
                    description
                  }
                }
              }
            }
          }
        }
      }
  ''';

  static String _typeSpecificDetailedFields(String? productType) {
    final normalized = (productType ?? '').toLowerCase().trim();
    switch (normalized) {
      case 'simple':
      case 'virtual':
        return '';
      case 'configurable':
      case 'variable':
        return _configurableDetailedFields;
      case 'downloadable':
        return _downloadableDetailedFields;
      case 'grouped':
        return _groupedDetailedFields;
      case 'bundle':
        return _bundleDetailedFields;
      case 'booking':
        return _bookingDetailedFields;
      default:
        // Unknown type: keep backward-compatible full payload.
        return _configurableDetailedFields +
            _downloadableDetailedFields +
            _groupedDetailedFields +
            _bundleDetailedFields +
            _bookingDetailedFields;
    }
  }

  /// Type-optimized product detail query by URL key.
  static String getProductByUrlKeyByType(String? productType) {
    final normalized = (productType ?? '').toLowerCase().trim();
    if (normalized == 'booking') {
      return getBookingProductByUrlKeyForType('default');
    }

    final typeFields = _typeSpecificDetailedFields(productType);
    return '''
    $_productSectionFragment
    $_productDetailedCommonFragment

    query GetProductByUrlKey(\$urlKey: String!) {
      product(urlKey: \$urlKey) {
        ...ProductDetailedCommon
        $typeFields
      }
    }
  ''';
  }

  static const String _bookingProductCoreFields = r'''
      id
      _id
      sku
      type
      bookingType
      name
      urlKey
      status
      description
      shortDescription
      price
      formattedPrice
      baseImageUrl
      minimumPrice
      formattedMinimumPrice
      maximumPrice
      formattedMaximumPrice
      regularMinimumPrice
      formattedRegularMinimumPrice
      regularMaximumPrice
      formattedRegularMaximumPrice
      specialPrice
      formattedSpecialPrice
      isSaleable
      images {
        edges {
          node {
            id
            _id
            path
            publicPath
            type
            position
          }
        }
      }
      reviews {
        edges {
          node {
            rating
            id
            name
            title
            comment
            attachments
            createdAt
            customerImageUrl
          }
        }
      }
  ''';

  static const String _bookingTypeProbeFields = r'''
      bookingProducts {
        edges {
          node {
            _id
            type
          }
        }
      }
  ''';

  static const String _bookingCommonNodeFields = r'''
            _id
            type
            startingPrice
            formattedStartingPrice
            startingRegularPrice
            formattedStartingRegularPrice
            qty
            location
            showLocation
            allowCancellation
            availableFrom
            availableTo
  ''';

  static String _bookingSlotFieldsForType(String bookingType) {
    switch (bookingType.toLowerCase().trim()) {
      case 'appointment':
        return r'''
            appointmentSlot {
              id
              _id
              bookingProductId
              duration
              breakTime
              sameSlotAllDays
              slots
            }
        ''';
      case 'rental':
        return r'''
            rentalSlot {
              id
              _id
              bookingProductId
              rentingType
              dailyPrice
              hourlyPrice
              sameSlotAllDays
              slots
            }
        ''';
      case 'table':
        return r'''
            tableSlot {
              id
              _id
              bookingProductId
              priceType
              guestLimit
              duration
              breakTime
              preventSchedulingBefore
              sameSlotAllDays
              slots
            }
        ''';
      case 'event':
        return r'''
            eventTickets {
              edges {
                node {
                  id
                  _id
                  bookingProductId
                  price
                  formattedPrice
                  qty
                  specialPrice
                  formattedSpecialPrice
                  specialPriceFrom
                  specialPriceTo
                  translation {
                    locale
                    name
                    description
                  }
                }
              }
            }
        ''';
      case 'default':
      default:
        return r'''
            defaultSlot {
              id
              _id
              bookingType
              duration
              breakTime
              slots
            }
        ''';
    }
  }

  static String getBookingProductTypeByUrlKey =
      '''
    query GetBookingProductTypeByUrlKey(\$urlKey: String!) {
      product(urlKey: \$urlKey) {
$_bookingTypeProbeFields
      }
    }
  ''';

  static String getBookingProductTypeById =
      '''
    query GetBookingProductTypeById(\$id: ID!) {
      product(id: \$id) {
$_bookingTypeProbeFields
      }
    }
  ''';

  static String getBookingProductByUrlKeyForType(String bookingType) {
    final slotFields = _bookingSlotFieldsForType(bookingType);
    return '''
    query GetBookingProductByUrlKeyForType(\$urlKey: String!) {
      product(urlKey: \$urlKey) {
$_bookingProductCoreFields
        bookingProducts {
          edges {
            node {
$_bookingCommonNodeFields
$slotFields
            }
          }
        }
      }
    }
  ''';
  }

  static String getBookingProductByIdForType(String bookingType) {
    final slotFields = _bookingSlotFieldsForType(bookingType);
    return '''
    query GetBookingProductByIdForType(\$id: ID!) {
      product(id: \$id) {
$_bookingProductCoreFields
        bookingProducts {
          edges {
            node {
$_bookingCommonNodeFields
$slotFields
            }
          }
        }
      }
    }
  ''';
  }

  static const String getBookingSlots = r'''
    query GetBookingSlots(
      $id: Int!
      $date: String!
    ) {
      bookingSlots(id: $id, date: $date) {
        slotId
        from
        to
        timestamp
        qty
      }
    }
  ''';

  static const String getBookingRentalHourlySlots = r'''
    query GetBookingSlotsSummary(
      $id: Int!
      $date: String!
    ) {
      bookingSlots(id: $id, date: $date) {
        slotId
        time
        slots
      }
    }
  ''';

  /// Product detailed fragment
  static const String _productDetailedFragment = r'''
    fragment ProductDetailed on Product {
      id
      _id
      sku
      type
      bookingType
      name
      new
      urlKey
      status
      description
      shortDescription
      price
      formattedPrice
      baseImageUrl
      minimumPrice
      formattedMinimumPrice
      specialPrice
      formattedSpecialPrice
      maximumPrice
      formattedMaximumPrice
      regularMinimumPrice
      regularMaximumPrice
      formattedRegularMinimumPrice
      formattedRegularMaximumPrice
      isSaleable
      guestCheckout
      color
      size
      brand
      images {
        edges {
          node {
            id
            _id
            path
            publicPath
            type
            position
          }
        }
      }
      superAttributeOptions
      combinations
      attributeValues {
        edges {
          node {
            value
            attribute {
              code
              adminName
            }
          }
        }
      }
      variants {
        edges {
          node {
            id
            name
            sku
            price
            formattedPrice
            specialPrice
            formattedSpecialPrice
            baseImageUrl
            attributeValues {
              edges {
                node {
                  value
                  attribute {
                    code
                    adminName
                  }
                }
              }
            }
          }
        }
      }
      categories {
        edges {
          node {
            id
            translation {
              name
            }
          }
        }
      }
      reviews {
        totalCount
        edges {
          node {
            rating
            id
            name
            title
            comment
            attachments
            createdAt
            customerImageUrl
          }
        }
      }
      relatedProducts {
        edges {
          node {
            ...ProductSection
          }
        }
      }
      upSells {
        edges {
          node {
            ...ProductSection
          }
        }
      }
      customizableOptions {
        edges {
          node {
            id
            _id
            type
            isRequired
            maxCharacters
            supportedFileExtensions
            sortOrder
            translation {
              id
              locale
              label
            }
            customizableOptionPrices {
              edges {
                node {
                  id
                  _id
                  label
                  price
                  formattedPrice
                  sortOrder
                }
              }
            }
          }
        }
      }
      downloadableLinks {
        edges {
          node {
            id
            _id
            type
            price
            downloads
            sortOrder
            fileUrl
            sampleFileUrl
            translation {
              title
            }
          }
        }
      }
      downloadableSamples {
        edges {
          node {
            id
            _id
            type
            fileUrl
            sortOrder
            translation {
              title
            }
          }
        }
      }
      groupedProducts {
        edges {
          node {
            id
            qty
            sortOrder
            associatedProduct {
              id
              name
              sku
              price
              specialPrice
              images(first: 3) {
                edges {
                  node {
                    id
                    publicPath
                  }
                }
              }
            }
          }
        }
      }
      bundleOptions {
        edges {
          node {
            id
            type
            isRequired
            sortOrder
            translation {
              label
            }
            bundleOptionProducts {
              edges {
                node {
                  id
                  qty
                  isDefault
                  isUserDefined
                  sortOrder
                  product {
                    id
                    name
                    sku
                    price
                    images(first: 3) {
                      edges {
                        node {
                          id
                          publicPath
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      bookingProducts {
        edges {
          node {
            id
            _id
            type
            startingPrice
            formattedStartingPrice
            startingRegularPrice
            formattedStartingRegularPrice
            qty
            location
            showLocation
            allowCancellation
            availableFrom
            availableTo
            defaultSlot {
              id
              _id
              bookingType
              duration
              breakTime
              slots
            }
            appointmentSlot {
              id
              _id
              bookingProductId
              duration
              breakTime
              sameSlotAllDays
              slots
            }
            rentalSlot {
              id
              _id
              bookingProductId
              rentingType
              dailyPrice
              hourlyPrice
              sameSlotAllDays
              slots
            }
            tableSlot {
              id
              _id
              bookingProductId
              priceType
              guestLimit
              duration
              breakTime
              preventSchedulingBefore
              sameSlotAllDays
              slots
            }
            eventTickets {
              edges {
                node {
                  id
                  _id
                  bookingProductId
                  price
                  qty
                  specialPrice
                  specialPriceFrom
                  specialPriceTo
                  translation {
                    locale
                    name
                    description
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';

  /// GET_PRODUCTS – paginated products with filtering/sorting
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Product.ts
  static String getProducts =
      '''
    $_productCoreFragment

    query GetProducts(
      \$query: String
      \$sortKey: String
      \$reverse: Boolean
      \$first: Int
      \$last: Int
      \$after: String
      \$before: String
      \$channel: String
      \$locale: String
      \$filter: String
    ) {
      products(
        query: \$query
        sortKey: \$sortKey
        reverse: \$reverse
        first: \$first
        last: \$last
        after: \$after
        before: \$before
        channel: \$channel
        locale: \$locale
        filter: \$filter
      ) {
        totalCount
        pageInfo {
          startCursor
          endCursor
          hasNextPage
          hasPreviousPage
        }
        edges {
          node {
            ...ProductCore
          }
        }
      }
    }
  ''';

  /// GET_FILTER_PRODUCTS – filtered products
  /// Source: nextjs-commerce/src/graphql/catelog/queries/ProductFilter.ts
  static String getFilterProducts =
      '''
    $_productSectionFragment

    query getProducts(
      \$filter: String
      \$sortKey: String
      \$reverse: Boolean
      \$first: Int
      \$last: Int
      \$after: String
      \$before: String
    ) {
      products(
        filter: \$filter
        sortKey: \$sortKey
        reverse: \$reverse
        first: \$first
        last: \$last
        after: \$after
        before: \$before
      ) {
        totalCount
        pageInfo {
          endCursor
          startCursor
          hasNextPage
          hasPreviousPage
        }
        edges {
          node {
            ...ProductSection
          }
        }
      }
    }
  ''';

  /// Status-only lookup -- used to re-validate cached products (e.g. Recently
  /// Viewed) without paying for the full detailed fragment.
  static const String getProductStatusByUrlKey = r'''
    query GetProductStatusByUrlKey($urlKey: String!) {
      product(urlKey: $urlKey) {
        urlKey
        status
      }
    }
  ''';

  /// GET_PRODUCT_BY_URL_KEY – single product detail
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Product.ts
  static String getProductByUrlKey =
      '''
    $_productSectionFragment
    $_productDetailedFragment

    query GetProductById(\$urlKey: String!) {
      product(urlKey: \$urlKey) {
        ...ProductDetailed
      }
    }
  ''';

  /// GET_RELATED_PRODUCTS
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Product.ts
  static String getRelatedProducts =
      '''
    $_productSectionFragment

    query GetRelatedProducts(\$urlKey: String, \$first: Int) {
      product(urlKey: \$urlKey) {
        id
        sku
        relatedProducts(first: \$first) {
          edges {
            node {
              ...ProductSection
            }
          }
        }
      }
    }
  ''';

  /// GET_PRODUCT_BY_ID – single product detail by numeric id
  static String getProductById =
      '''
    $_productSectionFragment
    $_productDetailedFragment

    query GetProductById(\$id: ID!) {
      product(id: \$id) {
        ...ProductDetailed
      }
    }
  ''';
}

class ThemeQueries {
  /// GET_THEME_CUSTOMIZATION
  /// Source: nextjs-commerce/src/graphql/theme/queries/ThemeCustomization.ts
  static const String getThemeCustomization = r'''
    query themeCustomization($first: Int) {
      themeCustomizations(first: $first) {
        edges {
          node {
            id
            type
            name
            status
            sortOrder
            translations {
              edges {
                node {
                  id
                  themeCustomizationId
                  locale
                  options
                }
              }
            }
          }
        }
      }
    }
  ''';
}

class SectionQueries {
  /// Published sections for the current channel's active theme.
  static const String getSections = r'''
    query sections($first: Int) {
      sections(first: $first) {
        edges {
          node {
            id
            _id
            type
            name
            status
            sortOrder
            translation {
              locale
              options
            }
          }
        }
      }
    }
  ''';
}

/// Cart GraphQL mutations
/// Source: nextjs-commerce/src/graphql/cart/mutations/
class CartQueries {
  /// Per-product guest checkout flag (`guest_checkout` attribute).
  static const String productGuestCheckout = r'''
    query productGuestCheckout($id: ID!) {
      product(id: $id) {
        id
        guestCheckout
      }
    }
  ''';

  /// Cross-sell products for the current cart (Bearer token).
  static const String getCartCrossSellProducts = r'''
    query CartCrossSellProducts {
      cartCrossSellProducts {
        id
        _id
        sku
        name
        type
        bookingType
        urlKey
        price
        formattedPrice
        minimumPrice
        formattedMinimumPrice
        maximumPrice
        formattedMaximumPrice
        regularMinimumPrice
        formattedRegularMinimumPrice
        regularMaximumPrice
        formattedRegularMaximumPrice
        specialPrice
        formattedSpecialPrice
        bookingProducts {
          edges {
            node {
              type
              startingPrice
              formattedStartingPrice
              startingRegularPrice
              formattedStartingRegularPrice
            }
          }
        }
        new
        featured
        isSaleable
        baseImageUrl
        reviews {
          totalCount
          edges {
            node {
              id
              rating
            }
          }
        }
      }
    }
  ''';
}

class CartMutations {
  /// CREATE_CART_TOKEN – creates a guest cart session
  /// Source: nextjs-commerce/src/graphql/cart/mutations/CreateCartToken.ts
  static const String createCartToken = r'''
    mutation CreateCart {
      createCartToken(input: {}) {
        cartToken {
          id
          cartToken
          customerId
          success
          message
          sessionToken
          isGuest
        }
      }
    }
  ''';

  /// Shared cart fields for consistent responses
  static const String _cartResultFields = r'''
          id
          cartToken
          subtotal
          formattedSubtotal
          subTotalInclTax
          formattedSubTotalInclTax
          itemsCount
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          shippingAmount
          formattedShippingAmount
          shippingAmountInclTax
          formattedShippingAmountInclTax
          appliedTaxes
          grandTotal
          formattedGrandTotal
          discountAmount
          formattedDiscountAmount
          couponCode
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                priceInclTax
                formattedPriceInclTax
                total
                formattedTotal
                totalInclTax
                formattedTotalInclTax
                taxAmount
                baseTaxAmount
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
                options
              }
            }
          }
          success
          message
          sessionToken
          isGuest
          itemsQty
  ''';

  /// ADD_SIMPLE_PRODUCT_TO_CART
  static const String addSimpleProductToCart =
      r'''
    mutation AddSimpleProductToCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
      $customizableOptions: Iterable
      $additional: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          customizableOptions: $customizableOptions
          additional: $additional
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// ADD_CONFIGURABLE_PRODUCT_TO_CART
  static const String addConfigurableProductToCart =
      r'''
    mutation AddConfigurableProductToCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
      $selectedConfigurableOption: Int!
      $superAttribute: Iterable
      $customizableOptions: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          selectedConfigurableOption: $selectedConfigurableOption
          superAttribute: $superAttribute
          customizableOptions: $customizableOptions
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// ADD_DOWNLOADABLE_PRODUCT_TO_CART
  static const String addDownloadableProductToCart =
      r'''
    mutation AddDownloadableProductToCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
      $links: Iterable
      $customizableOptions: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          links: $links
          customizableOptions: $customizableOptions
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// ADD_GROUPED_PRODUCT_TO_CART
  /// Uses JSON-string variable `groupedQty` for grouped item quantities.
  static const String addGroupedProductToCart =
      r'''
    mutation AddGroupedProductToCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
      $groupedQty: String
      $customizableOptions: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          groupedQty: $groupedQty
          customizableOptions: $customizableOptions
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// ADD_BUNDLE_PRODUCT_TO_CART
  /// Uses JSON-string variables for `bundleOptions` and `bundleOptionQty`.
  static const String addBundleProductToCart =
      r'''
    mutation AddBundleProductToCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
      $bundleOptions: String
      $bundleOptionQty: String
      $customizableOptions: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          bundleOptions: $bundleOptions
          bundleOptionQty: $bundleOptionQty
          customizableOptions: $customizableOptions
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// ADD_BOOKING_PRODUCT_TO_CART
  /// Uses JSON-string variable `booking` and optional `specialNote`.
  static const String addBookingProductToCart =
      r'''
    mutation AddBookingProductToCart(
      $cartId: Int
      $productId: Int!
      $booking: String!
      $quantity: Int
      $specialNote: String
      $customizableOptions: Iterable
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
          booking: $booking
          bookingNote: $specialNote
          customizableOptions: $customizableOptions
        }
      ) {
        addProductInCart {
''' +
      _cartResultFields +
      r'''
        }
      }
    }
  ''';

  /// Old addProductToCart (kept for compatibility)
  static const String addProductToCart = addSimpleProductToCart;

  /// GET_CART_ITEM – read the current cart
  /// Source: nextjs-commerce/src/graphql/cart/mutations/GetCartItem.ts
  static const String getCart = r'''
    mutation GetCartItem {
      createReadCart(input: {}) {
        readCart {
          id
          itemsCount
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          appliedTaxes
          grandTotal
          formattedGrandTotal
          shippingAmount
          formattedShippingAmount
          shippingAmountInclTax
          formattedShippingAmountInclTax
          subtotal
          formattedSubtotal
          subTotalInclTax
          formattedSubTotalInclTax
          discountAmount
          formattedDiscountAmount
          couponCode
          itemsQty
          isGuest
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                priceInclTax
                formattedPriceInclTax
                total
                formattedTotal
                totalInclTax
                formattedTotalInclTax
                taxAmount
                baseTaxAmount
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
                options
              }
            }
          }
        }
      }
    }
  ''';

  /// UPDATE_CART_ITEM – update item quantity
  /// Source: nextjs-commerce/src/graphql/cart/mutations/UpdateCartItems.ts
  static const String updateCartItem = r'''
    mutation UpdateCartItem(
      $cartItemId: Int!
      $quantity: Int!
    ) {
      createUpdateCartItem(
        input: {
          cartItemId: $cartItemId
          quantity: $quantity
        }
      ) {
        updateCartItem {
          id
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          shippingAmount
          formattedShippingAmount
          subtotal
          formattedSubtotal
          grandTotal
          formattedGrandTotal
          discountAmount
          formattedDiscountAmount
          couponCode
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                total
                formattedTotal
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
              }
            }
          }
          itemsQty
        }
      }
    }
  ''';

  /// REMOVE_CART_ITEM – remove an item from cart
  /// Source: nextjs-commerce/src/graphql/cart/mutations/RemoveCartItem.ts
  static const String removeCartItem = r'''
    mutation RemoveCartItem(
      $cartItemId: Int!
    ) {
      createRemoveCartItem(
        input: {
          cartItemId: $cartItemId
        }
      ) {
        removeCartItem {
          id
          cartToken
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          shippingAmount
          formattedShippingAmount
          subtotal
          formattedSubtotal
          grandTotal
          formattedGrandTotal
          discountAmount
          formattedDiscountAmount
          couponCode
          items {
            totalCount
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                total
                formattedTotal
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
              }
            }
          }
          itemsQty
        }
      }
    }
  ''';

  /// APPLY_COUPON – apply a coupon code to cart
  static const String applyCoupon = r'''
    mutation ApplyCoupon($couponCode: String!) {
      createApplyCoupon(input: { couponCode: $couponCode }) {
        applyCoupon {
          id
          success
          message
          couponCode
          discountAmount
          formattedDiscountAmount
          subtotal
          formattedSubtotal
          subTotalInclTax
          formattedSubTotalInclTax
          grandTotal
          formattedGrandTotal
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          shippingAmount
          formattedShippingAmount
          shippingAmountInclTax
          formattedShippingAmountInclTax
          appliedTaxes
          itemsQty
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                total
                formattedTotal
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
              }
            }
          }
        }
      }
    }
  ''';

  /// REMOVE_COUPON – remove applied coupon from cart
  static const String removeCoupon = r'''
    mutation RemoveCoupon {
      createRemoveCoupon(input: {}) {
        removeCoupon {
          id
          success
          message
          couponCode
          discountAmount
          formattedDiscountAmount
          subtotal
          formattedSubtotal
          subTotalInclTax
          formattedSubTotalInclTax
          grandTotal
          formattedGrandTotal
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          shippingAmount
          formattedShippingAmount
          shippingAmountInclTax
          formattedShippingAmountInclTax
          appliedTaxes
          itemsQty
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                total
                formattedTotal
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
              }
            }
          }
        }
      }
    }
  ''';

  /// MERGE_CART – merge guest cart into the logged-in user's cart.
  /// Called after login when the user had a guest cart.
  /// Source: nextjs-commerce/src/graphql/cart/mutations/CreateMergeCart.ts
  static const String mergeCart = r'''
    mutation createMergeCart($cartId: Int!) {
      createMergeCart(input: { cartId: $cartId }) {
        mergeCart {
          id
          cartToken
          taxAmount
          formattedTaxAmount
          taxTotal
          formattedTaxTotal
          subtotal
          formattedSubtotal
          shippingAmount
          formattedShippingAmount
          grandTotal
          formattedGrandTotal
          discountAmount
          formattedDiscountAmount
          couponCode
          itemsQty
          itemsCount
          isGuest
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
                formattedPrice
                total
                formattedTotal
                baseImage
                sku
                quantity
                type
                productUrlKey
                canChangeQty
              }
            }
          }
          success
          message
          sessionToken
        }
      }
    }
  ''';

  /// CREATE_ESTIMATE_SHIPPING – estimates shipping rates & tax for destination.
  /// If [shippingMethod] is passed, also selects it and recalculates totals.
  static const String createEstimateShipping =
      r'''
    mutation CreateEstimateShipping(
      $country: String!
      $state: String
      $postcode: String
      $shippingMethod: String
    ) {
      createEstimateShipping(
        input: {
          country: $country
          state: $state
          postcode: $postcode
          shippingMethod: $shippingMethod
        }
      ) {
        estimateShipping {
''' +
      _cartResultFields +
      r'''
          shippingMethods
          selectedShippingRate
        }
      }
    }
  ''';
}

class FilterQueries {
  /// GET_FILTER_OPTIONS (legacy – single attribute by ID)
  /// Source: nextjs-commerce/src/graphql/catelog/queries/ProductFilter.ts
  static const String getFilterOptions = r'''
    query FetchAttribute($id: ID!) {
      attribute(id: $id) {
        id
        code
        options {
          edges {
            node {
              id
              adminName
              translations {
                edges {
                  node {
                    id
                    label
                    locale
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';

  /// CATEGORY_ATTRIBUTE_FILTERS – dynamic filters per category
  /// Returns all filterable attributes for a given category slug,
  /// including price range, swatch info, and translated option labels.
  static const String getCategoryAttributeFilters = r'''
    query CategoryAttributeFilter($categorySlug: String, $first: Int) {
      categoryAttributeFilters(categorySlug: $categorySlug, first: $first) {
        edges {
          node {
            id
            _id
            code
            adminName
            type
            swatchType
            validation
            position
            isRequired
            isUnique
            isFilterable
            isComparable
            isConfigurable
            isUserDefined
            isVisibleOnFront
            valuePerLocale
            valuePerChannel
            defaultValue
            maxPrice
            minPrice
            validations
            translations {
              edges {
                node {
                  id
                  _id
                  attributeId
                  locale
                  name
                }
              }
            }
            options {
              edges {
                node {
                  id
                  _id
                  adminName
                  sortOrder
                  swatchValue
                  swatchValueUrl
                  translation {
                    id
                    _id
                    attributeOptionId
                    locale
                    label
                  }
                  translations {
                    edges {
                      node {
                        id
                        _id
                        attributeOptionId
                        locale
                        label
                      }
                    }
                  }
                }
              }
            }
          }
          cursor
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
}
