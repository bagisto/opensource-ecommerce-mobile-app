class MutationsData {
  String homeCategories({int id = 1}) {
    return """
    query homeCategories {
    homeCategories(id: $id)
        {
        id
        categoryId
        position
        logoPath
        logoUrl
        status
        displayMode
        Lft
        Rgt
        parentId
        additional
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
        categoryId
        position
        logoPath
        logoUrl
        status
        displayMode
        Lft
        Rgt
        parentId
        additional
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
              additional
              Lft
              Rgt
              categoryId
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
              categoryId
              name
              slug
              position
              logoPath
              logoUrl
              status
              displayMode
              Lft
              Rgt
              parentId
              additional
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
              translations {
                  id
                  name
                  slug
                  description
                  metaTitle
                  metaDescription
                  metaKeywords
                  category_id
                  locale
                  localeId
                  urlPath
              }
          }
      }
    }""";
  }

  String getAdvertisementData() {
    return """
    query advertisements {
    advertisements {
        advertisementFour {
          slug
          image
        }
        advertisementThree {
          slug
          image
        }
        advertisementTwo {
          slug
          image
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
        baseUrl
        translations {
           
            locale
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
        status
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
            conversionTime
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
        addToWishlist(input: {
            productId: $id
        }) {
            success
        }
    }""";
  }

  String removeFromWishlist({
    String? id,
  }) {
    return """
    mutation removeFromWishlist {
        removeFromWishlist(input: {
          productId: $id
        }) {
          status
          success
        }
    }""";
  }

  String customerLogout() {
    return """
    mutation customerLogout{
      customerLogout {
       status
       success
      }
    }""";
  }

  String addToCompare({
    String? id,
  }) {
    return """
    mutation addToCompare {
      addToCompare(input: {
          productId: $id
      }) {
          success
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
                  notes
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
            message
            status
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
                token
                status
                imageUrl
            }     
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
            conversionTime
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt
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
                        variants {
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
                            locale
                            channel
                            productId
                            parentId
                        }
                        parent {
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
                        }
                        createdAt
                        updatedAt
                    }
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
                        translations {
                            id
                            name
                            description
                            localeId
                            locale
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
                baseDiscount
                discountedSubTotal
                baseDiscountedSubTotal
            }
        }
    }""";
  }

  String updateItemToCart({List<Map<dynamic, String>>? items}) {
    return """
    mutation updateItemToCart {
    updateItemToCart(input: {
        qty: $items
    }) {
        status
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
            conversionTime
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
        status
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
            conversionTime
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
            conversionTime
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt
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
                    parentId
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
                address1
                address2
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
                additional
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
                address1
                address2
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
                additional
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
        status
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
            conversionTime
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
            status
            message
        }
    } """;
  }

  String allProductsList({List<Map<String, dynamic>>? filters, int page = 1}) {
    return """
    query allProducts {
	  allProducts(
        page: $page,
        first: 15,
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
            attributeFamilyId
            name
            shareURL
            urlKey
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
            
            sku
            parentId
            productFlats {
                id
                sku
                productNumber
                name
                description
                urlKey
                new
                featured
                shortDescription
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
                variants {
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
                    locale
                    channel
                    productId
                    parentId
                }
                parent {
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
                }
                createdAt
                updatedAt
            }
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
                translations {
                    id
                    name
                    description
                    localeId
                    locale
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
                customerName
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
    }""";
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
            itemOptions
            additional
            movedToCart
            shared
            timeOfMoving
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
                notes
                status
                createdAt
                updatedAt
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
                success
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

  String moveToCartFromWishlist(int id) {
    return """
    mutation moveToCart {
    moveToCart(id: $id) {
        status
        success
        wishlist {
            id
            channelId
            productId
            customerId
            itemOptions
            additional
            movedToCart
            shared
            timeOfMoving
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
                productFlats {
                    id
                    sku
                    productNumber
                    name
                    description
                    shortDescription
                    locale
                    channel
                }
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

  String removeAllWishlistProducts() {
    return """
    mutation removeAllWishlists {
    removeAllWishlists {
        status
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
        status
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
  }) {
    return """
    mutation customerRegister {
     customerRegister(
        input: {
          firstName: "$firstName"
          lastName: "$lastName"
          email: "$email"
          password: "$password"
          passwordConfirmation: "$confirmPassword"
        }
      ) {
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

  String forgotPassword({
    String? email,
  }) {
    return """
    mutation forgotPassword {
      forgotPassword(input: { email: "$email" }) {
        status
        success
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
  }) {
    return """
      mutation updateAccount {
        updateAccount(
          input: {
            firstName: "$firstName"
            lastName: "$lastName"
            email: "$email"
            gender: "$gender"
            uploadType: BASE64
            imageUrl: "data:image/png;base64,$avatar"
            dateOfBirth: "$dateOfBirth"
            phone: "$phone"
            oldpassword: "$oldPassword"
            password: "$password"
            passwordConfirmation: "$confirmPassword"
          }
        ) {
          status
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
            notes
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
          deleteAccount(input: {
            password: "$password"
          }) {
              status
              success
          }
      }""";
  }

  String getReviewList() {
    return """
    query reviewsList {
      reviewsList(
        input: {}){
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
            customerName
            product {
                id
                type
                attributeFamilyId
                sku
                urlKey
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

  String cancelOrder(int id) {
    return """
    mutation cancelCustomerOrder {
      cancelCustomerOrder(id: $id) {
       status
        message
        order {
            id
            incrementId
            status
            channelName
            isGuest
            customerEmail
            customerFirstName
            customerLastName
            customerCompanyName
            customerVatId
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
                address1
                address2
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
                address1
                address2
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
                additional
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
                    grantTotal
                    baseGrantTotal
                }
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
        customerCompanyName
        customerVatId
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
            address1
            address2
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
            address1
            address2
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
            additional
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
                grantTotal
                baseGrantTotal
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
            invoiceItems {
                id
                sku
                type
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
    String? id,
    String? startDate,
    String? endDate,
    String? status,
    double? total,
    int? page
  }) {
    return """
    query ordersList {
    ordersList(input: {
        incrementId: "$id"
        startOrderDate: "$startDate"
        endOrderDate: "$endDate"
        status: "$status"
        baseGrandTotal: $total
    }
    page: $page
    first: 10
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
            customerCompanyName
            customerVatId
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
                address1
                address2
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
                address1
                address2
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
                additional
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
                    type
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
      }
    }""";
  }

  String getAddressList(){
    return """
    query addresses {
    addresses {
        status
        message
        addresses {
            id
            customerId
            companyName
            firstName
            lastName
            address1
            address2
            countryName
            country
            stateName
            state
            city
            postcode
            phone
            vatId
            addressType
            defaultAddress
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
        status
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
    bool? isDefault,
  }){
    return """
    mutation createAddress {
    createAddress(input: {
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address1: "$address"
        address2: "$address2"
        country: "$country"
        state: "$state"
        city: "$city"
        postcode: "$postCode"
        phone: "$phone"
        vatId: "$vatId"
        defaultAddress: $isDefault
    }) {
      status
      message
      addresses{
            id
            customerId
            companyName
            firstName
            lastName
            address1
            address2
            country
            state
            city
            postcode
            phone
            vatId
            addressType
            defaultAddress
            createdAt
            updatedAt
      }
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
  }){
    return """
    mutation updateAddress {
    updateAddress(id: $id, input: {
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address1: "$address"
        address2: "$address2"
        country: "$country"
        state: "$state"
        city: "$city"
        postcode: "$postCode"
        phone: "$phone"
        vatId: "$vatId"
    }) {
       status
       message
       addresses {
             id
        customerId
            companyName
            firstName
            lastName
            address1
            address2
            country
            state
            city
            postcode
            phone
            vatId
            addressType
            defaultAddress
            createdAt
            updatedAt
       }
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
    mutation paymentMethods {
    paymentMethods(input: {
        shippingMethod: "$shippingMethod"
    }) {
        success
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
        payment: {
            method: "$paymentMethod"
        }
    }) {
        success
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
            conversionTime
            customerId
            channelId
            appliedCartRuleIds
            createdAt
            updatedAt
            items {
                id
                quantity
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
                address1
                address2
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
                additional
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
                address1
                address2
                postcode
                city
                state
                country
                email
                phone
                defaultAddress
                vatId
                additional
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
      {int? billingId = 0, shippingId = 0}
      ){
    return """
    mutation saveCheckoutAddresses {
    saveCheckoutAddresses(input: {
    billingAddressId: $billingId
    shippingAddressId: $shippingId
    billing: {
        customerId: $customerId
        defaultAddress : false
        companyName: "$billingCompanyName"
        firstName: "$billingFirstName"
        lastName: "$billingLastName"
        email: "$billingEmail"
        address1: "$billingAddress"
        address2: "$billingAddress2"
        city: "$billingCity"
        country: "$billingCountry"
        state: "$billingState"
        postcode: "$billingPostCode"
        phone: "$billingPhone"
        useForShipping: false
        isSaved: false
    }
    shipping: {
        customerId: $customerId
        defaultAddress : false
        companyName: "$shippingCompanyName"
        firstName: "$shippingFirstName"
        lastName: "$shippingLastName"
        email: "$shippingEmail"
        address1: "$shippingAddress"
        address2: "$shippingAddress2"
        city: "$shippingCity"
        country: "$shippingCountry"
        state: "$shippingState"
        postcode: "$shippingPostCode"
        phone: "$shippingPhone"
        isSaved: false
    }
    type: "shipping"
    }) {
        success
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
        }
        jumpToSection
      }
    }""";
  }

  String getCompareProducts({int page = 1}){
    return """
    query compareProducts {
    compareProducts(input: {
        page: $page
        limit: 10
    }) {
        id
        productId
        customerId
        createdAt
        updatedAt
        product {
            id
            type
            isInWishlist
            id
            sku
            urlKey
            name
            description
            shortDescription
            urlKey
            new
            featured
            status
            visibleIndividually
            isInSale
            averageRating
            images {
                id
                type
                path
                url
                productId
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
            notes
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
    }""";
  }

  String removeAllCompareProducts() {
    return """
    mutation removeAllCompareProducts {
      removeAllCompareProducts {
        status
        success
      }
    }""";
  }

  String removeFromCompare({
    int? id,
  }) {
    return """
    mutation removeFromCompareProduct {
      removeFromCompareProduct(input: {
        productId: $id
      }) {
        status
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
    }) {
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
            customerName
            attachments
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

  String downloadableProductsCustomer(int page, int limit) {
    return """
   query downloadableLinkPurchases {
    downloadableLinkPurchases(
      input: {,
        limit: $limit,
        page: $page
        }) {
          id
          productName
          downloadBought
          downloadUsed
          orderId
          createdAt
          order {
            id
            status
          }
        }
      }""";
  }

  String downloadProduct(int id) {
    return """
    mutation downloadLink {
      downloadLink(id: $id) {
        status
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
}
