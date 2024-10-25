/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

class MutationsData {
  String homeCategories({int id = 1}) {
    return """
    query homeCategories {
    homeCategories( 
        input: [
            {
                key: "id",
                value: "$id",
            }
        ])
        {
        id
       
        position
        logoPath
        logoUrl
        status
        displayMode
        parentId
        bannerPath
        bannerUrl
        name
        slug
        urlPath
        description
        metaTitle
        metaDescription
        metaKeywords
        localeId
        createdAt
        updatedAt
        filterableAttributes {
            id
            adminName
            code
            type
            position
        }
        children {
            id
            name
            description
            slug
            urlPath
            logoPath
            logoUrl
            bannerPath
            bannerUrl
            metaTitle
            metaDescription
            metaKeywords
            position
            status
            displayMode
            parentId
        }
      }
    }""";
  }

  String homeCategoriesFilters({List<Map<String, dynamic>>? filters}) {
    return """
    query homeCategories {
    homeCategories(input: $filters)
        {
        id
        position
        logoPath
        logoUrl
        status
        displayMode
        parentId

        bannerPath
        bannerUrl
        name
        slug
        urlPath
        description
        metaTitle
        metaDescription
        metaKeywords
        localeId
        createdAt
        updatedAt
        filterableAttributes {
            id
            adminName
            code
            type
            position
        }
        children {
            id
            name
            description
            slug
            urlPath
            logoPath
            logoUrl
            bannerPath
            bannerUrl
            metaTitle
            metaDescription
            metaKeywords
            position
            status
            displayMode
            parentId
        }
      }
    }""";
  }

  getLanguageCurrencyList() {
    return """
    query getDefaultChannel {
      getDefaultChannel {
          id
          code
          name
          description
          theme
          hostname
          defaultLocaleId
          baseCurrencyId
          rootCategoryId
          logoUrl
          faviconUrl
          maintenanceModeText
          allowedIps
          isMaintenanceOn
          defaultLocale {
              id
              name
              code
              direction
              createdAt
              updatedAt
          }
          locales {
              id
              name
              code
              direction
              createdAt
              updatedAt
          }
          baseCurrency {
              id
              name
              code
              symbol
              createdAt
              updatedAt
              exchangeRate {
                  id
                  targetCurrency
                  rate
                  createdAt
                  updatedAt
                  currency {
                      id
                  }
              }
          }
          currencies {
              id
              name
              code
              symbol
              createdAt
              updatedAt
              exchangeRate {
                  id
                  targetCurrency
                  rate
                  createdAt
                  updatedAt
                  currency {
                      id
                  }
              }
          }
          rootCategory {
              id
              name
              description
              slug
              urlPath
              logoPath
              logoUrl
              bannerPath
              bannerUrl
              metaTitle
              metaDescription
              metaKeywords
              position
              status
              displayMode
              parentId

              localeId
              createdAt
              updatedAt
          }
          inventorySources {
              id
              code
              name
              description
              contactName
              contactEmail
              contactNumber
              contactFax
              country
              state
              city
              street
              postcode
              priority
              latitude
              longitude
              status
          }
          rootCategory {
              id
      
              name
              slug
              position
              logoPath
              logoUrl
              status
              displayMode
             
              parentId
              
              bannerPath
              bannerUrl
              urlPath
              description
              metaTitle
              metaDescription
              metaKeywords
              localeId
              createdAt
              updatedAt
              filterableAttributes {
                  id
                  code
                  adminName
                  type
                  validation
                  position
                  isFilterable
                  options {
                      id
                      adminName
                      swatchValue
                      sortOrder
                      attributeId
                      isNew
                      isDelete
                      position
                      translations {
                          id
                          locale
                          label
                          attributeOptionId
                      }
                  }
              }
             
          }
      }
    }""";
  }

  String themeCustomizationData() {
    return """
    query themeCustomization {
    themeCustomization {
        id 
        channelId
        type
        name
        sortOrder
        status
        
        translations {
            localeCode
            options {
                css
                html
                title
                column_1 {
                    url
                    title
                    sortOrder
                }
                column_2 {
                    url
                    title
                    sortOrder
                }
                column_3 {
                    url
                    title
                    sortOrder
                }
                images {
                    link
                    image
                    imageUrl
                }
                filters {
                    key
                    value
                }
            }
        }
      }
    }""";
  }

  String getCmsPagesData({int first = 11, int page = 1}) {
    return """
    query cmsPages {
      cmsPages (
          first:$first
          page: $page
      ){
          paginatorInfo {
            count
            currentPage
            lastPage
            total
          }
          data {
              id
              layout
              createdAt
              updatedAt
              translations {
                  id
                  urlKey
                  metaDescription
                  metaTitle
                  pageTitle
                  metaKeywords
                  htmlContent
                  locale
                  cmsPageId
              }
              channels {
                  id
                  code
                  name
                  description
                  theme
                  hostname
                  defaultLocaleId
                  baseCurrencyId
                  rootCategoryId
                  locales {
                      id
                      name
                      code
                      direction
                  }
                  inventorySources {
                      id
                      code
                      name
                      description
                      contactName
                      contactEmail
                      contactNumber
                      contactFax
                      country
                      state
                      city
                      street
                      postcode
                      priority
                      latitude
                      longitude
                      status
                  }
                  logoUrl
                  faviconUrl
              }
          }
      }
    }""";
  }


  String addToCart({
    int? quantity,
    String? productId,
    List? downloadableLinks,
    List? groupedParams,
    List? bundleParams,
    List? configurableParams,
    var configurableId,
  }) {
    return """
    mutation addItemToCart {
      addItemToCart(input: {
        productId: $productId
        quantity: $quantity
     
        # Only use while adding configurable product to cart
       selectedConfigurableOption : $configurableId
        superAttribute:$configurableParams
    
        # Only use while adding grouped product to cart
        qty:$groupedParams
       

        # Only use while adding downloadable product to cart
        links: $downloadableLinks

        # Only use while adding bundled product to cart
        bundleOptions: $bundleParams
      }) {
        success
        message
        cart {
            id
            itemsCount
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
         
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt 
        }
      }
    }""";
  }

  String addToWishlist({
    String? id,
  }) {
    return """
    mutation addToWishlist {
        addToWishlist(
            productId: $id
        ) {
            success
           message
        }
    }""";
  }
  String removeFromWishlist({
    String? id,
  }) {
    return """
   mutation removeFromWishlist {
    removeFromWishlist (
        productId: $id
    ) {
        success
        message
    }
}""";
  }
  String contactUsApi({
    String? name,
    String?  email,
    String?  phone,
    String? describe
  }) {
    return """
 mutation contactUs {
contactUs (input: {
name: "$name"
email: "$email"
contact: "$phone"
message: "$describe"
}) {
success
message
}
}""";
  }

  String customerLogout() {
    return """
    mutation customerLogout{
      customerLogout {
     success
       message
      }
    }""";
  }

  String addToCompare({
    String? id,
  }) {
    return """
    mutation addToCompare {
      addToCompare(
          productId: $id
      ) {
        success
        message
        compareProduct {
            id
            productId
            customerId
            createdAt
            updatedAt
            customer {
                id
                firstName
                lastName
                name
                gender
                dateOfBirth
                email
                phone
                password
                apiToken
                customerGroupId
                subscribedToNewsLetter
                isVerified
                token
                notes {
                    id
                    customerId
                    note
                    customerNotified
                    createdAt
                    updatedAt
                }
                status
                createdAt
                updatedAt
            }
            cart {
                id
                customerEmail
                customerFirstName
                customerLastName
                shippingMethod
                couponCode
                isGift
                itemsCount
                itemsQty
            }
        }
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
        }
    }
    }""";
  }


  String getCustomerData() {
    return """
    query accountInfo {
        accountInfo {
                id
            firstName
            lastName
            name
            gender
            dateOfBirth
            email
            phone
            image
            imageUrl
            status
            password
            apiToken
            customerGroupId
            channelId
            subscribedToNewsLetter
            isVerified
            isSuspended
            token
            rememberToken
            createdAt
            updatedAt
        }
    }""";
  }

  String getCmsPageDetails(String id) {
    return """
    query cmsPage {
      cmsPage(id: $id) {
        id
        layout
        createdAt
        updatedAt
        translations {
          id
          urlKey
          metaDescription
          metaTitle
          pageTitle
          metaKeywords
          htmlContent
          locale
          cmsPageId
        }
        channels {
          id
          code
          name
          description
          theme
          hostname
          defaultLocaleId
          baseCurrencyId
          rootCategoryId
          locales {
            id
            name
            code
            direction
          }
          inventorySources {
            id
            code
            name
            description
            contactName
            contactEmail
            contactNumber
            contactFax
            country
            state
            city
            street
            postcode
            priority
            latitude
            longitude
            status
          }
          logoUrl
          faviconUrl
        }
      }
    }""";
  }


  String getFilterAttributes(String categorySlug) {
    return """
    query getFilterAttribute {
      getFilterAttribute(categorySlug: "$categorySlug") {
            minPrice
            maxPrice
            filterData {
                key
                value
            }
            filterAttributes {
                id
                code
                adminName
                type
                options {
                    id
                    adminName
                    swatchValue
                    sortOrder
                    isNew
                    translations {
                        id
                        label
                        locale
                    }
                }
            }
            sortOrders {
                key
                title
                value
                sort
                order
                position
            }
        }
    }""";
  }

  String cartDetails() {
    return """
   
    query cartDetail {
        cartDetail {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
       
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt
            appliedTaxRates {
            taxName
            totalAmount
        }
            items {
                additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
                id
                quantity
                sku
                type
                name
                appliedTaxRate
                couponCode
                weight
                totalWeight
                baseTotalWeight
                price
                basePrice
                total
                baseTotal
                taxPercent
                taxAmount
                baseTaxAmount
                discountPercent
                discountAmount
                baseDiscountAmount
                
                parentId
                productId
                cartId
                taxCategoryId
                customPrice
                appliedCartRuleIds
                createdAt
                updatedAt
                product {
                    id
                    type
                    attributeFamilyId
                    sku
                    urlKey
                    parentId
                  
                    variants {
                        id
                        type
                        attributeFamilyId
                        sku
                        parentId
                    }
                    parent {
                        id
                        type
                        attributeFamilyId
                        sku
                        parentId
                    }
                    attributeFamily {
                        id
                        code
                        name
                        status
                        isUserDefined
                    }
                    attributeValues {
                        id
                        productId
                        attributeId
                        locale
                        channel
                        textValue
                        booleanValue
                        integerValue
                        floatValue
                        dateTimeValue
                        dateValue
                        jsonValue
                        attribute {
                            id
                            code
                            adminName
                            type
                        }
                    }
                    superAttributes {
                        id
                        code
                        adminName
                        type
                        position
                    }
                    categories {
                        id
                        name
                        description
                        slug
                        urlPath
                        logoPath
                        bannerPath
                        metaTitle
                        metaDescription
                        metaKeywords
                        position
                        status
                        displayMode
                        parentId
                        filterableAttributes {
                            id
                            adminName
                            code
                            type
                            position
                        }
                       
                        createdAt
                        updatedAt
                    }
                    inventories {
                        id
                        qty
                        productId
                        inventorySourceId
                        vendorId
                        inventorySource {
                            id
                            code
                            name
                            description
                            contactName
                            contactEmail
                            contactNumber
                            contactFax
                            country
                            state
                            city
                            street
                            postcode
                            priority
                            latitude
                            longitude
                            status
                        }
                    }
                    images {
                        id
                        type
                        path
                        url
                        productId
                    }
                    orderedInventories {
                        id
                        qty
                        productId
                        channelId
                    }
                    reviews {
                        id
                        title
                        rating
                        comment
                        status
                        productId
                        customerId
                        createdAt
                        updatedAt
                    }
                    groupedProducts {
                        id
                        qty
                        sortOrder
                        productId
                        associatedProductId
                        associatedProduct {
                            id
                            name
                            type
                            attributeFamilyId
                            sku
                            parentId
                        }
                    }
                    downloadableSamples {
                        id
                        url
                        file
                        fileName
                        type
                        sortOrder
                        productId
                        createdAt
                        updatedAt
                        translations {
                            id
                            locale
                            title
                            productDownloadableSampleId
                        }
                    }
                    downloadableLinks {
                        id
                        title
                        price
                        url
                        file
                        fileName
                        type
                        sampleUrl
                        sampleFile
                        sampleFileName
                        sampleType
                        sortOrder
                        productId
                        downloads
                        translations {
                            id
                            locale
                            title
                            productDownloadableLinkId
                        }
                    }
                    bundleOptions {
                        id
                        type
                        isRequired
                        sortOrder
                        productId
                        bundleOptionProducts {
                            id
                            qty
                            isUserDefined
                            sortOrder
                            isDefault
                            productBundleOptionId
                            productId
                        }
                        translations {
                            id
                            locale
                            label
                            productBundleOptionId
                        }
                    }
                    customerGroupPrices {
                        id
                        qty
                        valueType
                        value
                        productId
                        customerGroupId
                        createdAt
                        updatedAt
                    }
                }
                formattedPrice {
                    price
                    basePrice
                    total
                    baseTotal
                    taxAmount
                    baseTaxAmount
                    discountAmount
                    baseDiscountAmount
                }
            }
            formattedPrice {
                grandTotal
                baseGrandTotal
                subTotal
                baseSubTotal
                taxTotal
                baseTaxTotal
                discount
                discountAmount
                baseDiscount
                discountedSubTotal
                baseDiscountedSubTotal
            }
        }
    }
   
   
   """;
  }

  String updateItemToCart({List<Map<dynamic, String>>? items}) {
    return """
    mutation updateItemToCart {
    updateItemToCart(input: {
        qty: $items
    }) {
        success
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt 
        }
      }
    }""";
  }

  String removeFromCart(int id) {
    return """
    mutation removeCartItem {
    removeCartItem(id: $id) {
        success
        message
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
       
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt 
        }
      }
    }""";
  }

  String applyCoupon(String coupon) {
    return """
    mutation applyCoupon {
    applyCoupon(input: {
        code: "$coupon"
    }) {
        success
        message
        
      }
    }""";
  }

  String removeCoupon() {
    return '''
    mutation removeCoupon {
      removeCoupon {
      success
      message
      }
    }''';
  }

  String moveCartToWishlist(int id) {
    return """
    mutation moveToWishlist {
    moveToWishlist(id: $id) {
      success
      message
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
            
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt 
        }
      }
    }""";
  }

  String removeAllCartItem() {
    return """
    mutation removeAllCartItem {
        removeAllCartItem {
            success
            message
        }
    } """;
  }

  String allProductsList({List<Map<String, dynamic>>? filters, int page = 1, int limit = 15}) {
    filters?.add({
      "key": '"page"',
      "value": '"$page"'
    });
    filters?.add({
      "key": '"limit"',
      "value": '"$limit"'
    });

    return """
    query allProducts {
	  allProducts(
        input: $filters) { 
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        } data {
            id
            type
            isInWishlist
            isInSale
            isSaleable
            attributeFamilyId
            name
            shareURL
            urlKey
            description
            additionalData {
                id
                code
                label
                value
                admin_name
                type
            }
            priceHtml {
                id
                type
                priceHtml
                priceWithoutHtml
                minPrice
                regularPrice
                formattedRegularPrice
                finalPrice
                formattedFinalPrice
                currencyCode
                bundlePrice {
                    finalPriceFrom
                    formattedFinalPriceFrom
                    regularPriceFrom
                    formattedRegularPriceFrom
                    finalPriceTo
                    formattedFinalPriceTo
                    regularPriceTo
                    formattedRegularPriceTo
                }
            }
            configutableData {
            chooseText
            attributes {
                id
                code
                label
                swatchType
                options {
                    id
                    label
                    swatchType
                    swatchValue
                }
            }
            index {
                id
                attributeOptionIds {
                    attributeId
                    attributeCode
                    attributeOptionId
                }
            }
            variantPrices {
                id
                regularPrice {
                    price
                    formatedPrice
                }
                finalPrice {
                    price
                    formatedPrice
                }
            }
            variantImages {
                id
                images {
                    smallImageUrl
                    mediumImageUrl
                    largeImageUrl
                    originalImageUrl
                }
            }
            variantVideos {
                id
                videos
            }
            regularPrice {
                formatedPrice
                price
            }
          }
            sku
            parentId
            variants {
                id
                type
                attributeFamilyId
                sku
                parentId
            }
            parent {
                id
                type
                attributeFamilyId
                sku
                parentId
            }
            attributeFamily {
                id
                code
                name
                status
                isUserDefined
            }
            attributeValues {
                id
                productId
                attributeId
                locale
                channel
                textValue
                booleanValue
                integerValue
                floatValue
                dateTimeValue
                dateValue
                jsonValue
                attribute {
                    id
                    code
                    adminName
                    type
                }
            }
            superAttributes {
                id
                code
                adminName
                type
                position
            }
            categories {
                id
                name
                description
                slug
                logoPath
                bannerPath
                metaTitle
                metaDescription
                metaKeywords
                position
                status
                displayMode
                parentId
                filterableAttributes {
                    id
                    adminName
                    code
                    type
                    position
                }
                
                createdAt
                updatedAt
            }
            inventories {
                id
                qty
                productId
                inventorySourceId
                vendorId
                inventorySource {
                    id
                    code
                    name
                    description
                    contactName
                    contactEmail
                    contactNumber
                    contactFax
                    country
                    state
                    city
                    street
                    postcode
                    priority
                    latitude
                    longitude
                    status
                }
            }
            images {
                id
                type
                path
                url
                productId
            }
            videos {
                id
                type
                path
                url
                productId
            }
            orderedInventories {
                id
                qty
                productId
                channelId
            }
            averageRating
            percentageRating
            reviews {
                id
                title
                rating
                comment
                status
                productId
                customerId
            
                createdAt
                updatedAt
            }
            groupedProducts {
                id
                qty
                sortOrder
                productId
                associatedProductId
                associatedProduct {
                    id
                    name
                    type
                    attributeFamilyId
                    sku
                    priceHtml {
                        id
                        type
                        priceHtml
                        priceWithoutHtml
                        minPrice
                        regularPrice
                        formattedRegularPrice
                        finalPrice
                        formattedFinalPrice
                        currencyCode
                    }
                    parentId
                }
            }
            downloadableSamples {
                id
                url
                fileUrl
                file
                fileName
                type
                sortOrder
                productId
                createdAt
                updatedAt
                translations {
                    id
                    locale
                    title
                    productDownloadableSampleId
                }
            }
            downloadableLinks {
                id
                title
                price
                url
                fileUrl
                file
                fileName
                type
                sampleUrl
                sampleFile
                sampleFileUrl
                sampleFileName
                sampleType
                sortOrder
                productId
                downloads
                translations {
                    id
                    locale
                    title
                    productDownloadableLinkId
                }
            }
            bundleOptions {
                id
                type
                isRequired
                sortOrder
                productId
                bundleOptionProducts {
                    id
                    qty
                    isUserDefined
                    sortOrder
                    isDefault
                    productBundleOptionId
                    productId
                    product {
                     sku
                     name
                     id
                     priceHtml {
                            id
                            type
                            priceHtml
                            priceWithoutHtml
                            minPrice
                            regularPrice
                            formattedRegularPrice
                            finalPrice
                            formattedFinalPrice
                            currencyCode
                            bundlePrice {
                                finalPriceFrom
                                formattedFinalPriceFrom
                                regularPriceFrom
                                formattedRegularPriceFrom
                                finalPriceTo
                                formattedFinalPriceTo
                                regularPriceTo
                                formattedRegularPriceTo
                            }
                        }
                }
                }
                translations {
                    id
                    locale
                    label
                    productBundleOptionId
                }
            }
            customerGroupPrices {
                id
                qty
                valueType
                value
                productId
                customerGroupId
                createdAt
                updatedAt
            }
        }
      }
    }

    """;
  }

  String wishlistData({int page = 1}) {
    return """
     query wishlists {
    wishlists(input: {

    } page: $page) {
        data {
            id
            channelId
            productId
            customerId
            
            
            movedToCart
            shared
            
            createdAt
            updatedAt
            customer {
                id
                firstName
                lastName
                name
                gender
                dateOfBirth
                email
                phone
                password
                apiToken
                customerGroupId
                subscribedToNewsLetter
                isVerified
                token
                
                status
                createdAt
                updatedAt
            }
            product {
            isSaleable
                id
                type
                attributeFamilyId
                sku
                name
                urlKey
                parentId
                createdAt
                updatedAt
                priceHtml {
                priceWithoutHtml
                minPrice
                priceHtml
                regularPrice
                formattedRegularPrice
                finalPrice
                formattedFinalPrice
                currencyCode
                bundlePrice {
                    finalPriceFrom
                    formattedFinalPriceFrom
                    regularPriceFrom
                    formattedRegularPriceFrom
                    finalPriceTo
                    formattedFinalPriceTo
                    regularPriceTo
                    formattedRegularPriceTo
                  }
                }
                images {
                    path
                    url
                    productId
                }
            }
            channel {
                id
                code
                name
                description
                theme
                hostname
                defaultLocaleId
                baseCurrencyId
                rootCategoryId
                logoUrl
                faviconUrl
                
            }
         
        }
      }
    }
""";
  }

  String moveToCartFromWishlist(int id, String quantity) {
    return """
    mutation moveToCart {
    moveToCart(id: $id
        quantity: $quantity
    ) {
        success
        wishlist {
            id
            channelId
            productId
            customerId
              additional {
                key
                value
            }
            movedToCart
            shared
            createdAt
            updatedAt
            product {
                id
                type
                attributeFamilyId
                sku
                urlKey
                parentId
                createdAt
                updatedAt
              
            }
        }
      }
    }""";
  }

  String removeAllWishlistProducts() {
    return """
    mutation removeAllWishlists {
    removeAllWishlists {
    message
        success
      }
    }""";
  }

  String getSocialLoginResponse(
      {String? phone,
        String? firstName,
        String? lastName,
        String? email,
        String? signUpType}) {
    return """
    mutation customerSocialSignUp {
    customerSocialSignUp(input: {
        phone: $phone
        firstName: $firstName
        lastName: $lastName
        email: $email
        signUpType: $signUpType
    }) {
        status
        success
        accessToken
        tokenType
        expiresIn
        customer {
            id
            firstName
            lastName
            name
            gender
            dateOfBirth
            email
            phone
            password
            apiToken
            customerGroupId
            subscribedToNewsLetter
            isVerified
            token
            notes
            status
            createdAt
            updatedAt
        }
    }
}""";
  }

  String customerLogin({
    String? email,
    String? password,
    bool? remember,
  }) {
    return """
    mutation customerLogin {
      customerLogin(
        input: { email: "$email", password: "$password", remember: $remember }
      ) {
        message
        success
        accessToken
        customer {
          id
          firstName
          lastName
          name
          gender
          dateOfBirth
          email
          imageUrl
          phone
          password
          token
          status
        }
      }
    }""";
  }

  String customerRegister({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? subscribedToNewsLetter
  }) {
    return """
    mutation customerSignUp {
     customerSignUp(
        input: {
          firstName: "$firstName"
          lastName: "$lastName"
          email: "$email"
          password: "$password"
          passwordConfirmation: "$confirmPassword"
          subscribedToNewsLetter:    $subscribedToNewsLetter
        }
      ) {
        message
        success
        accessToken
        tokenType
        expiresIn
        customer {
            id
            firstName
            lastName
            name
            gender
            dateOfBirth
            email
            phone
            password
            apiToken
            customerGroupId
            isVerified
            token
        
            status
            createdAt
            updatedAt
        }
    }
}""";
  }

  String forgotPassword({
    String? email,
  }) {
    return """
    mutation forgotPassword {
    forgotPassword (
        email: "$email"
    ) {
        success
        message
    }
}""";
  }

  String updateAccount({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? phone,
    String? oldPassword,
    String? password,
    String? confirmPassword,
    String? avatar,
    bool? subscribedToNewsLetter
  }) {
    return """
      mutation updateAccount {
        updateAccount(
          input: {
            firstName: "$firstName"
            lastName: "$lastName"
            email: "$email"
            gender: ${gender?.toUpperCase()}
            uploadType: BASE64
            imageUrl: "data:image/png;base64,$avatar"
            dateOfBirth: "$dateOfBirth"
            phone: "$phone"
            currentPassword: "$oldPassword"
            newPassword: "$password"
            newPasswordConfirmation: "$confirmPassword"
            newsletterSubscriber: $subscribedToNewsLetter
          }
        ) {
          success
          message
          customer{
            id
            firstName
            lastName
            name
            gender
            dateOfBirth
            email
            phone
            password
            apiToken
            customerGroupId
            subscribedToNewsLetter
            isVerified
            token
          
            imageUrl
            status
            createdAt
            updatedAt
          }
        }
      }""";
  }

  String deleteAccount({
    String? password,
  }) {
    return """
    mutation deleteAccount{
          deleteAccount(
            password: "$password"
          ) {
              success
              message
          }
      }""";
  }

  String getReviewList(int page) {
    return """
    query reviewsList {
      reviewsList(
        input: {}
        page: $page
        first: 10
        ){
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
         data {
            id
            title
            rating
            comment
            status
            createdAt
            updatedAt
            productId
            customerId
        
            customer {
                id
                firstName
                lastName
                name
                gender
                dateOfBirth
                email
                phone
                image
                imageUrl
                status
                password
                apiToken
                customerGroupId
                subscribedToNewsLetter
                isVerified
                isSuspended
                token
                rememberToken
                createdAt
                updatedAt
                customerGroup {
                    id
                    code
                    name
                    isUserDefined
                    createdAt
                    updatedAt
                }
            }
            product {
                id
                type
                attributeFamilyId
                sku
                name
                urlKey
                parentId
                createdAt
                updatedAt
                images{
                    url
                }
               
            }
          }
        }
    }""";
  }

  String cancelOrder(int id) {
    return """
    mutation cancelCustomerOrder {
      cancelCustomerOrder(id: $id) {
       success
        message
        
      }
    }""";
  }

  String getOrderDetail(int id) {
    return """ 
    query orderDetail {
    orderDetail(id: $id) {
        id
        incrementId
        status
        channelName
        isGuest
        customerEmail
        customerFirstName
        customerLastName
     
        shippingMethod
        shippingTitle
        shippingDescription
        couponCode
        isGift
        totalItemCount
        totalQtyOrdered
        baseCurrencyCode
        channelCurrencyCode
        orderCurrencyCode
        grandTotal
        baseGrandTotal
        grandTotalInvoiced
        baseGrandTotalInvoiced
        grandTotalRefunded
        baseGrandTotalRefunded
        subTotal
        baseSubTotal
        subTotalInvoiced
        baseSubTotalInvoiced
        subTotalRefunded
        baseSubTotalRefunded
        discountPercent
        discountAmount
        baseDiscountAmount
        discountInvoiced
        baseDiscountInvoiced
        discountRefunded
        baseDiscountRefunded
        taxAmount
        baseTaxAmount
        taxAmountInvoiced
        baseTaxAmountInvoiced
        taxAmountRefunded
        baseTaxAmountRefunded
        shippingAmount
        baseShippingAmount
        shippingInvoiced
        baseShippingInvoiced
        shippingRefunded
        baseShippingRefunded
        customerId
        customerType
        channelId
        channelType
        cartId
        appliedCartRuleIds
        shippingDiscountAmount
        baseShippingDiscountAmount
        createdAt
        updatedAt
        billingAddress {
            id
            customerId
            cartId
            orderId
            firstName
            lastName
            gender
            companyName
            address
            postcode
            city
            state
            country
            email
            phone
            vatId
            defaultAddress
        }
        shippingAddress {
            id
            customerId
            cartId
            orderId
            firstName
            lastName
            gender
            companyName
            address
            postcode
            city
            state
            country
            email
            phone
            vatId
            defaultAddress
        }
        items {
            id
            sku
            type
            name
            couponCode
            weight
            totalWeight
            qtyOrdered
            qtyShipped
            qtyInvoiced
            qtyCanceled
            qtyRefunded
            price
            basePrice
            total
            baseTotal
            totalInvoiced
            baseTotalInvoiced
            amountRefunded
            baseAmountRefunded
            discountPercent
            discountAmount
            baseDiscountAmount
            discountInvoiced
            baseDiscountInvoiced
            discountRefunded
            baseDiscountRefunded
            taxPercent
            taxAmount
            baseTaxAmount
            taxAmountInvoiced
            baseTaxAmountInvoiced
            taxAmountRefunded
            baseTaxAmountRefunded
            productId
            productType
            orderId
            parentId
            additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
            createdAt
            updatedAt
            formattedPrice {
                price
                basePrice
                total
                baseTotal
                totalInvoiced
                baseTotalInvoiced
                amountRefunded
                baseAmountRefunded
                discountAmount
                baseDiscountAmount
                discountInvoiced
                baseDiscountInvoiced
                discountRefunded
                baseDiscountRefunded
                taxAmount
                baseTaxAmount
                taxAmountInvoiced
                baseTaxAmountInvoiced
                taxAmountRefunded
                baseTaxAmountRefunded
             
            }
            product {
                id
                type
                attributeFamilyId
                sku
                urlKey
                parentId
                createdAt
                updatedAt
                images {
                    id
                    type
                    path
                    url
                    productId
                }
            }
            child {
                id
                sku
                type
                name
                couponCode
                weight
                totalWeight
                qtyOrdered
                qtyShipped
                qtyInvoiced
                qtyCanceled
                qtyRefunded
                price
                basePrice
                total
                baseTotal
                totalInvoiced
                baseTotalInvoiced
            }
           
            shipmentItems {
                id
                name
                description
                sku
                qty
                weight
                price
                basePrice
                total
                baseTotal
                productId
                productType
                orderItemId
                shipmentId
            }
            refundItems {
                id
                name
                description
                sku
                qty
                price
                basePrice
                total
                baseTotal
                taxAmount
                baseTaxAmount
                discountPercent
                discountAmount
                baseDiscountAmount
                productId
                productType
                orderItemId
                refundId
                parentId
            }
        }
        shipments {
            id
            status
            totalQty
            totalWeight
            carrierCode
            carrierTitle
            trackNumber
            emailSent
            customerId
            customerType
            orderId
            orderAddressId
            createdAt
            updatedAt
        }
        invoices {
            id
            incrementId
            state
            emailSent
            totalQty
            baseCurrencyCode
            channelCurrencyCode
            orderCurrencyCode
            subTotal
            baseSubTotal
            grandTotal
            baseGrandTotal
            shippingAmount
            baseShippingAmount
            taxAmount
            baseTaxAmount
            discountAmount
            baseDiscountAmount
            orderId
            
            createdAt
            updatedAt
        }
        payment {
            id
            method
            methodTitle
        }
        formattedPrice {
            grandTotal
            baseGrandTotal
            grandTotalInvoiced
            baseGrandTotalInvoiced
            grandTotalRefunded
            baseGrandTotalRefunded
            subTotal
            baseSubTotal
            subTotalInvoiced
            baseSubTotalInvoiced
            subTotalRefunded
            discountAmount
            baseDiscountAmount
            discountInvoiced
            baseDiscountInvoiced
            discountRefunded
            baseDiscountRefunded
            taxAmount
            baseTaxAmount
            taxAmountInvoiced
            baseTaxAmountInvoiced
            taxAmountRefunded
            baseTaxAmountRefunded
            shippingAmount
            baseShippingAmount
            shippingInvoiced
            baseShippingInvoiced
            shippingRefunded
            baseShippingRefunded
        }
    }
} """;
  }

  String removeReview(int id) {
    return """
    mutation deleteReview {
      deleteReview(id: $id) {
        status
        message
        reviews {
            id
            title
            rating
            comment
            status
            createdAt
            updatedAt
            productId
            customerId
            customerName
            product {
                id
                type
                attributeFamilyId
                sku
                parentId
                createdAt
                updatedAt
                productFlats {
                    id
                    sku
                    name
                    description
                    shortDescription
                    urlKey
                    new
                    featured
                    status
                    visibleIndividually
                    thumbnail
                    price
                    cost
                    specialPrice
                    specialPriceFrom
                    specialPriceTo
                    weight
                    color
                    colorLabel
                    size
                    sizeLabel
                    locale
                    channel
                    productId
                    parentId
                    minPrice
                    maxPrice
                    metaTitle
                    metaKeywords
                    metaDescription
                    width
                    height
                    depth
                    createdAt
                    updatedAt
                }
            }
        }
      }
    }""";
  }

  String getOrderList({
    String id = '',
    String startDate = '',
    String endDate = '',
    String? status ='',
    double? total,
    int? page,
    bool? isFilterApply

  }) {
  final inputString = """ 
  ${id.isNotEmpty ? 'id: $id,' : ''}
        ${startDate.isNotEmpty ? 'orderDateFrom: "$startDate",' : ''}
         ${endDate.isNotEmpty ? 'orderDateTo: "$endDate",' : ''}
      ${status!.isNotEmpty ? 'status: "$status"' : ''}
      
  """;
   return """
   
   query ordersList {
    ordersList (
        page: 1
        first: 10
        input: {
         $inputString
        }
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
            id
            incrementId
            status
            channelName
            isGuest
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            shippingTitle
            shippingDescription
            couponCode
            isGift
            totalItemCount
            totalQtyOrdered
            baseCurrencyCode
            channelCurrencyCode
            orderCurrencyCode
            grandTotal
            baseGrandTotal
            grandTotalInvoiced
            baseGrandTotalInvoiced
            grandTotalRefunded
            baseGrandTotalRefunded
            subTotal
            baseSubTotal
            subTotalInvoiced
            baseSubTotalInvoiced
            subTotalRefunded
            baseSubTotalRefunded
            discountPercent
            discountAmount
            baseDiscountAmount
            discountInvoiced
            baseDiscountInvoiced
            discountRefunded
            baseDiscountRefunded
            taxAmount
            baseTaxAmount
            taxAmountInvoiced
            baseTaxAmountInvoiced
            taxAmountRefunded
            baseTaxAmountRefunded
            shippingAmount
            baseShippingAmount
            shippingInvoiced
            baseShippingInvoiced
            shippingRefunded
            baseShippingRefunded
            shippingDiscountAmount
            baseShippingDiscountAmount
            shippingTaxAmount
            baseShippingTaxAmount
            shippingTaxRefunded
            baseShippingTaxRefunded
            subTotalInclTax
            baseSubTotalInclTax
            shippingAmountInclTax
            baseShippingAmountInclTax
            customerId
            customerType
            channelId
            channelType
            cartId
            appliedCartRuleIds
            createdAt
            updatedAt
            billingAddress {
                id
                customerId
                cartId
                orderId
                firstName
                lastName
                gender
                companyName
                address
                postcode
                city
                state
                country
                email
                phone
                vatId
                defaultAddress
            }
            shippingAddress {
                id
                customerId
                cartId
                orderId
                firstName
                lastName
                gender
                companyName
                address
                postcode
                city
                state
                country
                email
                phone
                vatId
                defaultAddress
            }
            items {
                id
                sku
                type
                name
                couponCode
                weight
                totalWeight
                qtyOrdered
                qtyShipped
                qtyInvoiced
                qtyCanceled
                qtyRefunded
                price
                basePrice
                total
                baseTotal
                totalInvoiced
                baseTotalInvoiced
                amountRefunded
                baseAmountRefunded
                discountPercent
                discountAmount
                baseDiscountAmount
                discountInvoiced
                baseDiscountInvoiced
                discountRefunded
                baseDiscountRefunded
                taxPercent
                taxAmount
                baseTaxAmount
                taxAmountInvoiced
                baseTaxAmountInvoiced
                taxAmountRefunded
                baseTaxAmountRefunded
                priceInclTax
                basePriceInclTax
                totalInclTax
                baseTotalInclTax
                productId
                productType
                orderId
                parentId
                             additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
                createdAt
                updatedAt
                product {
                    id
                    type
                    attributeFamilyId
                    sku
                    parentId
                    createdAt
                    updatedAt
                }
                child {
                    id
                    sku
                    type
                    name
                    couponCode
                    weight
                    totalWeight
                    qtyOrdered
                    qtyShipped
                    qtyInvoiced
                    qtyCanceled
                    qtyRefunded
                    price
                    basePrice
                    total
                    baseTotal
                    totalInvoiced
                    baseTotalInvoiced
                }
                invoiceItems {
                    id
                    sku
                    name
                    description
                    qty
                    price
                    basePrice
                    total
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
                    parentId
                }
                shipmentItems {
                    id
                    name
                    description
                    sku
                    qty
                    weight
                    price
                    basePrice
                    total
                    baseTotal
                    priceInclTax
                    basePriceInclTax
                    productId
                    productType
                    orderItemId
                    shipmentId
                }
                refundItems {
                    id
                    name
                    description
                    sku
                    qty
                    price
                    basePrice
                    total
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
                    refundId
                    parentId
                }
            }
            shipments {
                id
                status
                totalQty
                totalWeight
                carrierCode
                carrierTitle
                trackNumber
                emailSent
                customerId
                customerType
                orderId
                orderAddressId
                createdAt
                updatedAt
            }
            payment {
                id
                method
                methodTitle
            }
            formattedPrice {
                grandTotal
                baseGrandTotal
                grandTotalInvoiced
                baseGrandTotalInvoiced
                grandTotalRefunded
                baseGrandTotalRefunded
                subTotal
                baseSubTotal
                subTotalInvoiced
                baseSubTotalInvoiced
                subTotalRefunded
                discountAmount
                baseDiscountAmount
                discountInvoiced
                baseDiscountInvoiced
                discountRefunded
                baseDiscountRefunded
                taxAmount
                baseTaxAmount
                taxAmountInvoiced
                baseTaxAmountInvoiced
                taxAmountRefunded
                baseTaxAmountRefunded
                shippingAmount
                baseShippingAmount
                shippingInvoiced
                baseShippingInvoiced
                shippingRefunded
                baseShippingRefunded
                shippingDiscountAmount
                baseShippingDiscountAmount
                shippingTaxAmount
                baseShippingTaxAmount
                shippingTaxRefunded
                baseShippingTaxRefunded
                subTotalInclTax
                baseSubTotalInclTax
                shippingAmountInclTax
                baseShippingAmountInclTax
            }
        }
    }
}
   
   
   """;
  }

  String getAddressList(){
    int first =11;
    int page =1;
    return """
    query addresses {
    addresses (
        first:$first
        page: $page
        input: {
          
        }
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data { 
            id
            addressType
            parentAddressId
            customerId
            cartId
            orderId
            firstName
            lastName
            gender
            companyName
            address
            city
            state
            stateName
            country
            countryName
            postcode
            email
            phone
            vatId
            defaultAddress
            useForShipping
            createdAt
            updatedAt
        }
    }
}""";
  }

  String deleteAddress(String? id){
    return """
    mutation deleteAddress {
    deleteAddress(id: $id) {
        success
        message
      }
    }""";
  }

  String createNewAddress({
    String? companyName,
    String? firstName,
    String? lastName,
    String? address,
    String? address2,
    String? country,
    String? state,
    String? city,
    String? postCode,
    String? phone,
    String? vatId,
    String? email,
    bool? isDefault,

  }){
    return """
    mutation createAddress {
    createAddress(input: {
     
        email: "$email",
       
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address: "$address $address2"
        country: "$country"
        state: "$state"
        city: "$city"
        postcode: "$postCode"
        phone: "$phone"
        vatId: "$vatId"
        defaultAddress: $isDefault
    }) {
      success
      message
      }
    }""";
  }

  String updateAddress({
    int? id,
    String? companyName,
    String? firstName,
    String? lastName,
    String? address,
    String? address2,
    String? country,
    String? state,
    String? city,
    String? postCode,
    String? phone,
    String? vatId,
    String? email
  }){
    return """
    mutation updateAddress {
    updateAddress(id: $id, input: {
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address: "$address"
        country: "$country"
        state: "$state"
        city: "$city"
        email: "$email"
        postcode: "$postCode"
        phone: "$phone"
        vatId: "$vatId"
    }) {
       success
       message
       
      }
    }""";
  }

  String getCountryStateList(){
    return """
    query countries {
    countries {
        id
        code
        name
        translations {
            id
            locale
            name
            countryId
        }
        states {
            id
            countryCode
            code
            defaultName
            countryId
            translations {
                id
                locale
                defaultName
                countryStateId
            }
        }
      }
    }""";
  }

  String paymentMethods({String? shippingMethod}){
    return """
    query paymentMethods {
    paymentMethods(input: {
        shippingMethod: "$shippingMethod"
    }) {
         
        message
        paymentMethods {
            method
            methodTitle
            description
            sort
        }
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            formattedPrice {
            grandTotal
          }
        }
      }
    }""";
  }

  String savePaymentAndReview({String? paymentMethod}){
    return """
    mutation savePayment {
    savePayment(input: {
            method: "$paymentMethod"
           
    }) {
        
        jumpToSection
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
            
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt
            appliedTaxRates {
            taxName
            totalAmount
        }
            items {
                id
                quantity
                appliedTaxRate
                formattedPrice {
                price
                total
              }
                sku
                type
                name
                couponCode
                weight
                totalWeight
                baseTotalWeight
                price
                basePrice
                total
                baseTotal
                taxPercent
                taxAmount
                baseTaxAmount
                discountPercent
                discountAmount
                baseDiscountAmount
                # additional {
                #     productId
                # }
                parentId
                productId
                cartId
                taxCategoryId
                customPrice
                appliedCartRuleIds
                createdAt
                updatedAt
                product {
                    id
                    type
                    attributeFamilyId
                    sku
                    parentId
                    images {
                    url
                  }
                }
            }
            formattedPrice {
                grandTotal
                baseGrandTotal
                subTotal
                baseSubTotal
                taxTotal
                baseTaxTotal
                discount
                discountAmount
                baseDiscount
                discountedSubTotal
                baseDiscountedSubTotal
            }
            shippingAddress {
                id
                addressType
                customerId
                cartId
                orderId
                firstName
                lastName
                gender
                companyName
                address
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
               
                createdAt
                updatedAt
            }
            billingAddress {
                id
                addressType
                customerId
                cartId
                orderId
                firstName
                lastName
                gender
                companyName
                address
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
              
                createdAt
                updatedAt
            }
            selectedShippingRate {
                id
                carrier
                carrierTitle
                method
                methodTitle
                methodDescription
                price
                basePrice
                discountAmount
                baseDiscountAmount
                cartAddressId
                createdAt
                updatedAt
                formattedPrice {
                    price
                    basePrice
                }
            }
            payment {
                id
                method
                methodTitle
                cartId
                createdAt
                updatedAt
            }
        }
      }
    }""";
  }

  String placeOrder(){
    return """
    mutation placeOrder {
    placeOrder {
        success
        redirectUrl
        selectedMethod
        order {
            id
            customerEmail
            customerFirstName
            customerLastName
        }
      }
    }""";
  }

  String checkoutSaveAddress(
      String? billingCompanyName,
      String? billingFirstName,
      String? billingLastName,
      String? billingAddress,
      String? billingEmail,
      String? billingAddress2,
      String? billingCountry,
      String? billingState,
      String? billingCity,
      String? billingPostCode,
      String? billingPhone,
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingEmail,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone,
      int customerId,
      {int? billingId = 0, shippingId = 0, bool useForShipping = true}
      ){
    return """
    mutation saveCheckoutAddresses  {
    saveCheckoutAddresses (
            input: {
        billing: {
        defaultAddress : false
        companyName: "$billingCompanyName"
        firstName: "$billingFirstName"
        lastName: "$billingLastName"
        email: "$billingEmail"
        address: "$billingAddress $billingAddress2"
        city: "$billingCity"
        country: "$billingCountry"
        state: "$billingState"
        postcode: "$billingPostCode"
        phone: "$billingPhone"
        useForShipping: $useForShipping,
        defaultAddress: false,
        saveAddress: false
        },
        shipping: {  
        defaultAddress : false
        companyName: "$shippingCompanyName"
        firstName: "$shippingFirstName"
        lastName: "$shippingLastName"
        email: "$shippingEmail"
        address: "$shippingAddress $shippingAddress2"
        city: "$shippingCity"
        country: "$shippingCountry"
        state: "$shippingState"
        postcode: "$shippingPostCode"
        phone: "$shippingPhone"
        }   
    
}
    ) {
        message
        shippingMethods {
            title
            methods {
                code
                label
                price
                formattedPrice
                basePrice
                formattedBasePrice
            }
        }
        paymentMethods {
            method
            methodTitle
            description
            sort
        }
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            formattedPrice {
            grandTotal
            }
        }
        jumpToSection
    }
}
    
    
    
    
    
    
    """;
  }

  String getCompareProducts({int page = 1}){
    return """
   query compareProducts {
    compareProducts (
        page: $page
        first: 10
        input: {
            
        }
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
        
            id
            productId
            customerId
            createdAt
            updatedAt
            product {
            images {
                        id
                        type
                        path
                        url
                        productId
                    } 
                    isSaleable
                id
                sku 
                type
                isInWishlist
                id
                sku
                name
                description
                shortDescription
                urlKey
                new
                featured
                status
                visibleIndividually
                priceHtml {
                    id
                    type
                    priceHtml
                    priceWithoutHtml
                    minPrice
                    regularPrice
                    formattedRegularPrice
                    finalPrice
                    formattedFinalPrice
                    currencyCode
                    bundlePrice {
                        finalPriceFrom
                        formattedFinalPriceFrom
                        regularPriceFrom
                        formattedRegularPriceFrom
                        finalPriceTo
                        formattedFinalPriceTo
                        regularPriceTo
                        formattedRegularPriceTo
                    }
                }
            }
            customer {
                id
                firstName
                lastName
                name
                gender
                dateOfBirth
                email
                phone
                password
                apiToken
                customerGroupId
                subscribedToNewsLetter
                isVerified
                token
                notes {
                    id
                    customerId
                    note
                    customerNotified
                    createdAt
                    updatedAt
                }
                status
                createdAt
                updatedAt
            }
            cart {
                id
                customerEmail
                customerFirstName
                customerLastName
                shippingMethod
                couponCode
                isGift
                itemsCount
                itemsQty
            }
        }
    }
}""";
  }

  String removeAllCompareProducts() {
    return """
    mutation removeAllCompareProducts {
      removeAllCompareProducts {
        message
        success
      }
    }""";
  }

  String removeFromCompare({
    int? id,
  }) {
    return """
    mutation removeFromCompareProduct {
      removeFromCompareProduct(
        productId: $id
      ) {
        message
        success
      }
    }""";
  }

  String addReview(String name, String title, int rating, String comment, int productId, List<Map<String, String>> attachments){
    return """
    mutation createReview {
    createReview(input: {
        name: "$name"
        title: "$title"
        rating: $rating
        comment: "$comment"
        productId: $productId
        attachments : $attachments
    }) {message
        success
        review {
            id
            title
            rating
            comment
            status
            createdAt
            updatedAt
            productId
            customerId
          
            product {
                id
                type
                attributeFamilyId
                sku
                parentId
                createdAt
                updatedAt
               
            }

        }
    }
  }""";
  }

  String downloadableProductsCustomer(int page, int limit,
  {
    String title = "",
    String status = "",
    String orderId = "",
    String orderDateFrom = "",
    String orderDateTo = ""
  }) {

    final inputString = """ 
        ${title.isNotEmpty ? 'name: "$title"' : ''}
        ${orderDateFrom.isNotEmpty ? 'purchaseDateFrom: "$orderDateFrom" ' : ''}
        ${orderDateTo.isNotEmpty ? 'purchaseDateTo: "$orderDateTo" ' : ''}
        ${status.isNotEmpty ? 'status: $status' : ''}
        ${orderId.isNotEmpty ? 'orderId: $orderId' : ''}
      """;

    return """
    query downloadableLinkPurchases {
    downloadableLinkPurchases (
    page: $page
    first: $limit
    input: {
      $inputString
    }
    ) {
    paginatorInfo {
    count
    currentPage
    lastPage
    total
    }
    data {
    id
    productName
    name
    url
    file
    fileName
    type
    downloadBought
    downloadUsed
    status
    customerId
    orderId
    orderItemId
    createdAt
    updatedAt
    customer {
    id
    firstName
    lastName
    name
    gender
    dateOfBirth
    email
    phone
    password
    apiToken
    customerGroupId
    subscribedToNewsLetter
    isVerified
    token
    notes {
    id
    customerId
    note
    customerNotified
    createdAt
    updatedAt
    customer {
    id
    }
    }
    status
    }
    order {
    id
    incrementId
    status
    channelName
    isGuest
    customerEmail
    customerFirstName
    customerLastName
    shippingMethod
    shippingTitle
    shippingDescription
    couponCode
    isGift
    totalItemCount
    totalQtyOrdered
    baseCurrencyCode
    channelCurrencyCode
    orderCurrencyCode
    grandTotal
    baseGrandTotal
    grandTotalInvoiced
    baseGrandTotalInvoiced
    grandTotalRefunded
    baseGrandTotalRefunded
    subTotal
    baseSubTotal
    subTotalInvoiced
    baseSubTotalInvoiced
    subTotalRefunded
    baseSubTotalRefunded
    discountPercent
    discountAmount
    baseDiscountAmount
    discountInvoiced
    baseDiscountInvoiced
    discountRefunded
    baseDiscountRefunded
    taxAmount
    baseTaxAmount
    taxAmountInvoiced
    baseTaxAmountInvoiced
    taxAmountRefunded
    baseTaxAmountRefunded
    shippingAmount
    baseShippingAmount
    shippingInvoiced
    baseShippingInvoiced
    shippingRefunded
    baseShippingRefunded
    customerId
    customerType
    channelId
    channelType
    cartId
    appliedCartRuleIds
    shippingDiscountAmount
    baseShippingDiscountAmount
    createdAt
    updatedAt
    }
    orderItem {
    id
    sku
    type
    name
    couponCode
    weight
    totalWeight
    qtyOrdered
    qtyShipped
    qtyInvoiced
    qtyCanceled
    qtyRefunded
    price
    basePrice
    total
    baseTotal
    product {
    id
    sku
    type
    name
    shortDescription
    description
    urlKey
    shareURL
    new
    featured
    status
    guestCheckout
    visibleIndividually
    images {
    id
    type
    path
    url
    }
    cacheGalleryImages {
    smallImageUrl
    mediumImageUrl
    largeImageUrl
    originalImageUrl
    }
    }
    }
    }
    }
    }
    """;
  }
  String downloadProductQuery(int id) {
    return """
    mutation downloadLink {
    downloadLink (
    id: $id
    ) {
    success
    string
    download {
    id
    productName
    name
    url
    file
    fileName
    type
    downloadBought
    downloadUsed
    status
    customerId
    orderId
    orderItemId
    createdAt
    updatedAt
    }
    }
    }""";
  }
  String downloadProduct(int id) {
    return """
    query downloadableLinkPurchase {
    downloadableLinkPurchase (id: "$id") {
        id
        productName
        name
        url
        file
        fileName
        type
        downloadBought
        downloadUsed
        status
        customerId
        orderId
        orderItemId
        createdAt
        updatedAt
        customer {
            id
            firstName
            lastName
            name
            gender
            dateOfBirth
            email
            phone
            password
            apiToken
            customerGroupId
            subscribedToNewsLetter
            isVerified
            token
            notes {
                id
                customerId
                note
                customerNotified
                createdAt
                updatedAt
                customer {
                    id
                }
            }
            status
        }
        order {
            id
            incrementId
            status
            channelName
            isGuest
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            shippingTitle
            shippingDescription
            couponCode
            isGift
            totalItemCount
            totalQtyOrdered
            baseCurrencyCode
            channelCurrencyCode
            orderCurrencyCode
            grandTotal
            baseGrandTotal
            grandTotalInvoiced
            baseGrandTotalInvoiced
            grandTotalRefunded
            baseGrandTotalRefunded
            subTotal
            baseSubTotal
            subTotalInvoiced
            baseSubTotalInvoiced
            subTotalRefunded
            baseSubTotalRefunded
            discountPercent
            discountAmount
            baseDiscountAmount
            discountInvoiced
            baseDiscountInvoiced
            discountRefunded
            baseDiscountRefunded
            taxAmount
            baseTaxAmount
            taxAmountInvoiced
            baseTaxAmountInvoiced
            taxAmountRefunded
            baseTaxAmountRefunded
            shippingAmount
            baseShippingAmount
            shippingInvoiced
            baseShippingInvoiced
            shippingRefunded
            baseShippingRefunded
            customerId
            customerType
            channelId
            channelType
            cartId
            appliedCartRuleIds
            shippingDiscountAmount
            baseShippingDiscountAmount
            createdAt
            updatedAt
        }
        orderItem {
            id
            sku
            type
            name
            couponCode
            weight
            totalWeight
            qtyOrdered
            qtyShipped
            qtyInvoiced
            qtyCanceled
            qtyRefunded
            price
            basePrice
            total
            baseTotal
        }
    }
}""";
  }
  String getInvoicesList(int orderId) {return """
    query viewInvoices {
    viewInvoices (
        page: 1
        first: 10
        input: {
          orderId: $orderId
        }
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
            id
            incrementId
            state
            emailSent
            totalQty
            baseCurrencyCode
            channelCurrencyCode
            orderCurrencyCode
            subTotal
            baseSubTotal
            grandTotal
            baseGrandTotal
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
            orderId
            createdAt
            updatedAt
            transactionId
             formattedPrice{
            subTotal
            taxAmount
            grandTotal
           shippingAmount
          }
            items {
                id
                sku
                name
                description
                qty
                price
                basePrice
                total
                baseTotal
                taxAmount
                baseTaxAmount
                productId
                productType
                orderItemId
                invoiceId
                parentId
                additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
                discountPercent
                discountAmount
                baseDiscountAmount
                priceInclTax
                basePriceInclTax
                totalInclTax
                baseTotalInclTax
                createdAt
                updatedAt 
             formattedPrice
            {
              total
              price
              taxAmount
              baseTotal
            }

                orderItem {
                    id
                    sku
                    type
                    name
                    couponCode
                    weight
                    totalWeight
                    qtyOrdered
                    qtyShipped
                    qtyInvoiced
                    qtyCanceled
                    qtyRefunded
                    price
                    basePrice
                    total
                    baseTotal
                    totalInvoiced
                    baseTotalInvoiced
                    amountRefunded
                    baseAmountRefunded
                    discountPercent
                    discountAmount
                    baseDiscountAmount
                    discountInvoiced
                    baseDiscountInvoiced
                    discountRefunded
                    baseDiscountRefunded
                    taxPercent
                    taxAmount
                    baseTaxAmount
                    taxAmountInvoiced
                    baseTaxAmountInvoiced
                    taxAmountRefunded
                    baseTaxAmountRefunded
                    priceInclTax
                    basePriceInclTax
                    totalInclTax
                    baseTotalInclTax
                    productId
                    productType
                    orderId
                    parentId
                    additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
                    createdAt
                    updatedAt
                }
                product {
                    id
                    type
                    attributeFamilyId
                    sku
                    parentId
                    createdAt
                    updatedAt
                }
            }
        }
    }
}""";}

  String getShipmentsList(int orderId)
  {
    return """
    
    query viewShipments {
    viewShipments (
        page: 1
        first: 10
        input: {
           orderId: $orderId
        }
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
            id
            status
            totalQty
            totalWeight
            carrierCode
            carrierTitle
            trackNumber
            emailSent
            customerId
            customerType
            orderId
            orderAddressId
            createdAt
            updatedAt
            inventorySourceId
            inventorySourceName
            order {
                id
                incrementId
                status
                channelName
                isGuest
                customerEmail
                customerFirstName
                customerLastName
                shippingMethod
                shippingTitle
                shippingDescription
                couponCode
                isGift
                totalItemCount
                totalQtyOrdered
                baseCurrencyCode
                channelCurrencyCode
                orderCurrencyCode
                grandTotal
                baseGrandTotal
                grandTotalInvoiced
                baseGrandTotalInvoiced
                grandTotalRefunded
                baseGrandTotalRefunded
                subTotal
                baseSubTotal
                subTotalInvoiced
                baseSubTotalInvoiced
                subTotalRefunded
                baseSubTotalRefunded
                discountPercent
                discountAmount
                baseDiscountAmount
                discountInvoiced
                baseDiscountInvoiced
                discountRefunded
                baseDiscountRefunded
                taxAmount
                baseTaxAmount
                taxAmountInvoiced
                baseTaxAmountInvoiced
                taxAmountRefunded
                baseTaxAmountRefunded
                shippingAmount
                baseShippingAmount
                shippingInvoiced
                baseShippingInvoiced
                shippingRefunded
                baseShippingRefunded
                shippingDiscountAmount
                baseShippingDiscountAmount
                shippingTaxAmount
                baseShippingTaxAmount
                shippingTaxRefunded
                baseShippingTaxRefunded
                subTotalInclTax
                baseSubTotalInclTax
                shippingAmountInclTax
                baseShippingAmountInclTax
                customerId
                customerType
                channelId
                channelType
                cartId
                appliedCartRuleIds
                createdAt
                updatedAt
            }
            items {
                id
                name
                description
                sku
                qty
                weight
                price
                basePrice
                total
                baseTotal
                priceInclTax
                basePriceInclTax
                productId
                productType
                orderItemId
                shipmentId
                additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
                createdAt
                updatedAt
            }
            inventorySource {
                id
                code
                name
                description
                contactName
                contactEmail
                contactNumber
                contactFax
                country
                state
                city
                street
                postcode
                priority
                latitude
                longitude
            }
            customer {
                id
                firstName
                lastName
                name
                gender
                dateOfBirth
                email
                phone
                password
                apiToken
                customerGroupId
                subscribedToNewsLetter
                isVerified
                token
                notes {
                    id
                    customerId
                    note
                    customerNotified
                    createdAt
                    updatedAt
                    customer {
                        id
                    }
                }
                status
                customerGroup {
                    id
                    name
                    code
                    isUserDefined
                    createdAt
                    updatedAt
                }
                createdAt
                updatedAt
            }
        }
    }
}
    
    """;}

  String getRefundList(int orderId)
  {
    return """
    query viewRefunds {
    viewRefunds(
        page: 1
        first: 10
        input: {
        # id: 1
         orderId: $orderId
        # quantity: 2
        # adjustmentRefund: 1.22
        # adjustmentFee: 3.45
        # shippingAmount: 47.50
        # taxAmount: 1.13
        # discountAmount: 1.45
        # grandTotal: 5.35
        # baseGrandTotal: 5.35
        # refundDate: "2021-02-12 20:36:26"
    }) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
        id
        incrementId
        state
        emailSent
        totalQty
        baseCurrencyCode
        channelCurrencyCode
        orderCurrencyCode
        adjustmentRefund
        baseAdjustmentRefund
        adjustmentFee
        baseAdjustmentFee
        subTotal
        baseSubTotal
        grandTotal
        baseGrandTotal
        shippingAmount
        baseShippingAmount
        taxAmount
        baseTaxAmount
        discountPercent
        discountAmount
        baseDiscountAmount
        orderId
        createdAt
        updatedAt
        formattedPrice
        {
          subTotal
          adjustmentRefund
          adjustmentFee
          grandTotal
          shippingAmount
        }
        items {
            id
            name
            description
            sku
            qty
            price
            basePrice
            total
            baseTotal
            taxAmount
            baseTaxAmount
            discountPercent
            discountAmount
            baseDiscountAmount
            productId
            productType
            orderItemId
            refundId
            parentId
             additional {
                selectedConfigurableOption
                superAttribute {
                attributeId
                optionId
                }
                attributes {
                optionId
                optionLabel
                attributeCode
                attributeName
                }
                }
            createdAt
            updatedAt
            formattedPrice
            {
              total
              price
              taxAmount
              baseTotal
            }
        }
        order {
            id
            incrementId
            status
            channelName
            isGuest
            customerEmail
            customerFirstName
            customerLastName
        
            shippingMethod
            shippingTitle
            shippingDescription
            couponCode
            isGift
            totalItemCount
            totalQtyOrdered
            baseCurrencyCode
            channelCurrencyCode
            orderCurrencyCode
            grandTotal
            baseGrandTotal
            grandTotalInvoiced
            baseGrandTotalInvoiced
            grandTotalRefunded
            baseGrandTotalRefunded
            subTotal
            baseSubTotal
            subTotalInvoiced
            baseSubTotalInvoiced
            subTotalRefunded
            baseSubTotalRefunded
            discountPercent
            discountAmount
            baseDiscountAmount
            discountInvoiced
            baseDiscountInvoiced
            discountRefunded
            baseDiscountRefunded
            taxAmount
            baseTaxAmount
            taxAmountInvoiced
            baseTaxAmountInvoiced
            taxAmountRefunded
            baseTaxAmountRefunded
            shippingAmount
            baseShippingAmount
            shippingInvoiced
            baseShippingInvoiced
            shippingRefunded
            baseShippingRefunded
            customerId
            customerType
            channelId
            channelType
            cartId
            appliedCartRuleIds
            shippingDiscountAmount
            baseShippingDiscountAmount
            createdAt
            updatedAt
        }
        }
    }
  }""";}

  String reOrderCustomerOrder(String? orderId){
    return """
    mutation reorder {
    reorder (
        id: $orderId
    ) {
        success
        message
        cart {
            id
            customerEmail
            customerFirstName
            customerLastName
            shippingMethod
            couponCode
            isGift
            itemsCount
            itemsQty
            exchangeRate
            globalCurrencyCode
            baseCurrencyCode
            channelCurrencyCode
            cartCurrencyCode
            grandTotal
            baseGrandTotal
            subTotal
            baseSubTotal
            taxTotal
            baseTaxTotal
            discountAmount
            baseDiscountAmount
            checkoutMethod
            isGuest
            isActive
            appliedCartRuleIds
            customerId
            channelId
            createdAt
            updatedAt
            formattedPrice {
                grandTotal
                baseGrandTotal
                subTotal
                baseSubTotal
                taxTotal
                baseTaxTotal
                discount
                baseDiscount
                discountedSubTotal
                baseDiscountedSubTotal
            }
            items {
                id
                quantity
                sku
                type
                name
                couponCode
                weight
                totalWeight
                baseTotalWeight
                price
                basePrice
                customPrice
                total
                baseTotal
                taxPercent
                taxAmount
                baseTaxAmount
                discountPercent
                discountAmount
                baseDiscountAmount
                parentId
                productId
                cartId
                taxCategoryId
                appliedCartRuleIds
                createdAt
                updatedAt
                formattedPrice {
                    price
                    basePrice
                    customPrice
                    total
                    baseTotal
                    taxAmount
                    baseTaxAmount
                    discountAmount
                    baseDiscountAmount
                }
            }
            allItems  {
                id
                quantity
                sku
                type
                name
                couponCode
                weight
                totalWeight
                baseTotalWeight
                price
                basePrice
                customPrice
                total
                baseTotal
                taxPercent
                taxAmount
                baseTaxAmount
                discountPercent
                discountAmount
                baseDiscountAmount
                parentId
                productId
                cartId
                taxCategoryId
                appliedCartRuleIds
                createdAt
                updatedAt
                formattedPrice {
                    price
                    basePrice
                    customPrice
                    total
                    baseTotal
                    taxAmount
                    baseTaxAmount
                    discountAmount
                    baseDiscountAmount
                }
            }
            selectedShippingRate {
                id
                carrier
                carrierTitle
                method
                methodTitle
                methodDescription
                price
                basePrice
                discountAmount
                baseDiscountAmount
                isCalculateTax
                cartAddressId
                createdAt
                updatedAt
                shippingAddress {
                    id
                }
                formattedPrice { 
                    price
                    basePrice
                }
            }
            payment {
                id
                method
                methodTitle
                cartId
                createdAt
                updatedAt
            }
        }
    }
}
    """;
  }

  String setDefaultAddress(String id){
    return """
    mutation setDefaultAddress {
    setDefaultAddress (
        id: $id
    ) {
        success
        message
        address {
            id
            addressType
            parentAddressId
            customerId
            cartId
            orderId
            firstName
            lastName
            gender
            companyName
            address
            city
            state
            country
            postcode
            email
            phone
            vatId
            defaultAddress
            useForShipping
            createdAt
            updatedAt
        }
    }
}
    """;
  }


  String subscribeNewsletter(String email){
    return """
    mutation subscribe {
    subscribe (email: "$email") {
        success
        message
    }
    }
    """;
  }

  String downloadSample(String type, String id){
    return """
    mutation downloadSample {
    downloadSample (input: {
        type: "$type"
        id: $id
      }) {
        success
        string
    }
    }
    """;
  }

}

