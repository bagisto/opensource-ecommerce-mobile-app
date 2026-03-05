/// GraphQL queries for the Bagisto category & catalog API
/// Ported from: nextjs-commerce-main/src/graphql/catelog/
library;

class CategoryQueries {
  /// GET_TREE_CATEGORIES – fetches hierarchical category tree
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Category.ts
  static const String getTreeCategories = r'''
    query treeCategories($parentId: Int) {
      treeCategories(parentId: $parentId) {
        id
        _id
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

  /// GET_HOME_CATEGORIES – flat list with logo
  /// Source: nextjs-commerce/src/graphql/catelog/queries/HomeCategories.ts
  static const String getHomeCategories = r'''
    query Categories {
      categories {
        edges {
          node {
            id
            _id
            logoUrl
            position
            translation {
              name
              slug
              id
              _id
            }
          }
        }
      }
    }
  ''';
}

class ProductQueries {
  /// Product core fragment fields
  static const String _productCoreFragment = r'''
    fragment ProductCore on Product {
      id
      _id
      sku
      type
      name
      price
      urlKey
      baseImageUrl
      minimumPrice
      specialPrice
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
      urlKey
      type
      baseImageUrl
      price
      minimumPrice
      specialPrice
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
          }
        }
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
      name
      urlKey
      description
      shortDescription
      price
      baseImageUrl
      minimumPrice
      specialPrice
      isSaleable
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
      superAttributes {
        edges {
          node {
            id
            code
            adminName
            options {
              edges {
                node {
                  id
                  _id
                  adminName
                  swatchValue
                  swatchValueUrl
                  translation {
                    label
                  }
                }
              }
            }
          }
        }
      }
      variants {
        edges {
          node {
            id
            _id
            sku
            name
            price
            specialPrice
            baseImageUrl
            isSaleable
            color
            size
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
            createdAt
          }
        }
      }
      relatedProducts {
        edges {
          node {
            id
            _id
            sku
            name
            urlKey
            type
            baseImageUrl
            price
            minimumPrice
            specialPrice
            isSaleable
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

  /// GET_PRODUCT_BY_URL_KEY – single product detail
  /// Source: nextjs-commerce/src/graphql/catelog/queries/Product.ts
  static String getProductByUrlKey =
      '''
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

/// Cart GraphQL mutations
/// Source: nextjs-commerce/src/graphql/cart/mutations/
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

  /// ADD_PRODUCT_TO_CART – add a product to cart
  /// Source: nextjs-commerce/src/graphql/cart/mutations/AddProductToCart.ts
  static const String addProductToCart = r'''
    mutation CreateAddProductInCart(
      $cartId: Int
      $productId: Int!
      $quantity: Int!
    ) {
      createAddProductInCart(
        input: {
          cartId: $cartId
          productId: $productId
          quantity: $quantity
        }
      ) {
        addProductInCart {
          id
          cartToken
          subtotal
          itemsCount
          taxAmount
          shippingAmount
          grandTotal
          discountAmount
          couponCode
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
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
          isGuest
          itemsQty
        }
      }
    }
  ''';

  /// GET_CART_ITEM – read the current cart
  /// Source: nextjs-commerce/src/graphql/cart/mutations/GetCartItem.ts
  static const String getCart = r'''
    mutation GetCartItem {
      createReadCart(input: {}) {
        readCart {
          id
          itemsCount
          taxAmount
          grandTotal
          shippingAmount
          subtotal
          discountAmount
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
          shippingAmount
          subtotal
          grandTotal
          discountAmount
          couponCode
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
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
          shippingAmount
          subtotal
          grandTotal
          discountAmount
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
          subtotal
          grandTotal
          taxAmount
          shippingAmount
          itemsQty
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
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
          subtotal
          grandTotal
          taxAmount
          shippingAmount
          itemsQty
          items {
            edges {
              node {
                id
                cartId
                productId
                name
                price
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
          subtotal
          shippingAmount
          grandTotal
          discountAmount
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
