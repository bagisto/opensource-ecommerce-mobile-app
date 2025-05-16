/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

/// This class contains all the graphql queries and mutations
class MutationsData {
  String homeCategoriesFilters({List<Map<String, dynamic>>? filters}) {
    return """
    query homeCategories {
    homeCategories(input: $filters)
        {
        id
        name
        slug
        description
        logoUrl
        bannerUrl
        children {
            id
            name
            slug
            logoUrl
            bannerUrl
        }
      }
    }""";
  }

  getLanguageCurrencyList() {
    return """
    query getDefaultChannel {
      getDefaultChannel {
          id
          name
          rootCategoryId
          locales {
              id
              name
              code
          }
          baseCurrency {
              id
              name
              code
          }
          currencies {
              id
              name
              code
          }
      }
    }""";
  }

  String themeCustomizationData() {
    return """
    query themeCustomization {
    themeCustomization {
        id 
        type
        name
        
        translations {
            localeCode
            options {
                css
                html
                title
                images {
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
          data {
              id
              translations {
                  id
                  pageTitle
                  locale
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
            couponCode
            itemsQty
            taxTotal
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

  String contactUsApi(
      {String? name, String? email, String? phone, String? describe}) {
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
            dateOfBirth
            email
            phone
            imageUrl
            subscribedToNewsLetter
        }
    }""";
  }

  String getCmsPageDetails(String id) {
    return """
    query cmsPage {
      cmsPage(id: $id) {
        id
        translations {
          id
          htmlContent
          locale
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
            couponCode
            itemsCount
            itemsQty
            taxTotal
            appliedTaxRates {
                taxName
                totalAmount
            }
            items {
                id
                quantity
                type
                name
                appliedTaxRate
                productId
                product {
                    id
                    type
                    sku
                    urlKey
                    parentId
                    images {
                        id
                        type
                        path
                        url
                        productId
                    }
                }
                formattedPrice {
                    price
                    total
                    taxAmount
                    discountAmount
                }
                additional
            }
            formattedPrice {
                grandTotal
                baseGrandTotal
                subTotal
                taxTotal
                discountAmount
                discountedSubTotal
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
        message
      }
    }""";
  }

  String removeFromCart(int id) {
    return """
    mutation removeCartItem {
    removeCartItem(id: $id) {
        success
        message
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

  String allProductsList(
      {List<Map<String, dynamic>>? filters, int page = 1, int limit = 15}) {
    filters?.add({"key": '"page"', "value": '"$page"'});
    filters?.add({"key": '"limit"', "value": '"$limit"'});

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
            customizableOptions {
                id
            }
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
                    formattedPrice
                }
                finalPrice {
                    price
                    formattedPrice
                }
            }
            regularPrice {
                formattedPrice
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

//todo done till here
  String wishlistData({int page = 1}) {
    return """
     query wishlists {
    wishlists(input: {

    } page: $page) {
        data {
            id
            productId
            product {
                isSaleable
                id
                type
                sku
                name
                urlKey
                parentId
                priceHtml {
                priceHtml
                finalPrice
                }
                images {
                    path
                    url
                    productId
                }
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
        message
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

//todo done
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

  //todo done
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
        tokenType
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

  String customerRegister(
      {String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? confirmPassword,
      bool? subscribedToNewsLetter,
      bool? agreement}) {
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
          agreement: $agreement
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

//todo done
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

  //todo done
  String updateAccount(
      {String? firstName,
      String? lastName,
      String? email,
      String? gender,
      String? dateOfBirth,
      String? phone,
      String? oldPassword,
      String? password,
      String? confirmPassword,
      String? avatar,
      bool? subscribedToNewsLetter}) {
    return """
      mutation updateAccount {
        updateAccount(
          input: {
            firstName: "$firstName"
            lastName: "$lastName"
            email: "$email"
            gender: ${gender?.toUpperCase()}
            # uploadType: BASE64
            # imageUrl: "data:image/png;base64,$avatar"
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

  //todo done
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

  //todo done
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
        shippingTitle
       createdAt
        billingAddress {
            id
            firstName
            lastName
            companyName
            address
            postcode
            city
            state
            country
            phone
        }
        shippingAddress {
            id
            firstName
            lastName
            companyName
            address
            postcode
            city
            state
            country
            phone
        }
        items {
            id
            sku
            type
            name
            qtyOrdered
            qtyShipped
            qtyInvoiced
            qtyCanceled
            qtyRefunded
            productId
            additional 
            formattedPrice {
                price
                total
                baseTotal
                discountAmount
                taxAmount
            }
            product {
                id
                sku
                name
                images {
                    id
                    type
                    path
                    url
                    productId
                }
            }
        }
        payment {
            id
            method
            methodTitle
        }
        formattedPrice {
            grandTotal
            subTotal
            taxAmount
            discountAmount
            shippingAmount
        }
    }
} """;
  }

  String getOrderList(
      {String id = '',
      String startDate = '',
      String endDate = '',
      String? status = '',
      double? total,
      int? page,
      bool? isFilterApply}) {
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
            status
            totalQtyOrdered
            createdAt
            formattedPrice {
                grandTotal
                subTotal
                discountAmount
                taxAmount
                shippingAmount
            }
        }
    }
}
   
   
   """;
  }

  String getAddressList() {
    int first = 11;
    int page = 1;
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

  String deleteAddress(String? id) {
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
  }) {
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

  String updateAddress(
      {int? id,
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
      String? email}) {
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

  String getCountryStateList() {
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

  String paymentMethods({String? shippingMethod}) {
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

  String savePaymentAndReview({String? paymentMethod}) {
    return """
    mutation savePayment {
    savePayment(input: {
            method: "$paymentMethod"
           
    }) {
        
        jumpToSection
        cart {
            id
            couponCode
            itemsCount
            itemsQty
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
                type
                name
                productId
                product {
                    id
                    type
                   # attributeFamilyId
                    sku
                    parentId
                    images {
                    url
                    }
                }
            }
            formattedPrice {
                grandTotal
                subTotal
                taxTotal
                discountAmount
            }
            shippingAddress {
                id
                address
                postcode
                city
                state
                country
                phone
            }
            billingAddress {
                  id
                address
                postcode
                city
                state
                country
                phone
            }
            selectedShippingRate {
                id
                methodTitle
                formattedPrice {
                    price
                    basePrice
                }
            }
            payment {
                id
                method
                methodTitle
            }
        }
      }
    }""";
  }

  String placeOrder() {
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
      {int? billingId = 0,
      shippingId = 0,
      bool useForShipping = true}) {
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

  String getCompareProducts({int page = 1}) {
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
                name
                description
                urlKey
                priceHtml {
                    id
                    priceHtml
                    finalPrice
                }
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

  String addReview(String name, String title, int rating, String comment,
      int productId, List<Map<String, String>> attachments) {
    return """
    mutation createReview {
    createReview(input: {
        name: "$name"
        title: "$title"
        rating: $rating
        comment: "$comment"
        productId: $productId
        #attachments : $attachments
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
      {String title = "",
      String status = "",
      String orderId = "",
      String orderDateFrom = "",
      String orderDateTo = ""}) {
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
            order {
                
                id
                status
            }
            orderItem {
                
                id
                name
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
        name
        status
    }
}""";
  }

  String getInvoicesList(int orderId) {
    return """
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
             formattedPrice{
            subTotal
            taxAmount
            grandTotal
           shippingAmount
          }
            items {
                id
                name
                sku
                qty
                productId
             formattedPrice
            {
              total
              price
              taxAmount
              baseTotal
            }

            product {
                id
                sku
            }
          }
        }
    }
}""";
  }

  String getShipmentsList(int orderId) {
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
            trackNumber
            items {
                id
                name
                sku
                qty
                priceInclTax
                productId
            }
        }
    }
}
    
    """;
  }

  String getRefundList(int orderId) {
    return """
    query viewRefunds {
    viewRefunds(
        page: 1
        first: 10
        input: {
         orderId: $orderId
    }) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
        id
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
            sku
            qty
            discountAmount
            productId
            formattedPrice
            {
              total
              price
              taxAmount
              baseTotal
            }
        }
        }
    }
  }""";
  }

  String reOrderCustomerOrder(String? orderId) {
    return """
    mutation reorder {
    reorder (
        id: $orderId
    ) {
        success
        message
    }
}
    """;
  }

  String setDefaultAddress(String id) {
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

  String subscribeNewsletter(String email) {
    return """
    mutation subscribe {
    subscribe (email: "$email") {
        success
        message
    }
    }
    """;
  }

  String downloadSample(String type, String id) {
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
