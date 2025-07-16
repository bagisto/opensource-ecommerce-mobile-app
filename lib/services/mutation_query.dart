/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:convert';

import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';

import '../utils/app_global_data.dart';

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
                links {
                    title 
                    link
                    image
                    imageUrl
                    url
                    slug 
                    type
                    id
                }
                services {
                    title
                    description
                    serviceIcon
                }
                images {
                    imageUrl
                }
                filters {
                    key
                    value
                }
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
                  urlKey
              }
          }
      }
    }""";
  }

  String addToCart(
      {int? quantity,
      String? productId,
      List? downloadableLinks,
      List? groupedParams,
      List? bundleParams,
      List? configurableParams,
      var configurableId,
      Map<String, dynamic>? booking,
      List<Map<String, dynamic>>? customizableOptions}) {
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

        # Only use while adding booking product to cart
        booking: $booking

        # Customizable options
        customizableOptions: $customizableOptions
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
            shortDescription
            description
            customizableOptions {
                id
                label
                productId
                type
                isRequired
                maxCharacters
                supportedFileExtensions
                sortOrder
                product {
                    id
                }
                translations {
                    id
                    locale
                    label
                    productCustomizableOptionId
                }
                customizableOptionPrices {
                    id
                    isDefault
                    isUserDefined
                    label
                    price
                    productCustomizableOptionId
                    qty
                    sortOrder
                }
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
         booking {
        id
        type
        qty
        location
        showLocation
        availableEveryWeek
        availableFrom
        availableTo
        productId
        product {
          id
        }
        defaultSlot {
          id
          bookingType
          duration
          breakTime
         slotManyDays {
            to
            from
          }
          slotOneDay {
            id
            to
            from
          }
        }
        appointmentSlot {
          id
          duration
          breakTime
          sameSlotAllDays
           slotManyDays {
            to
            from
          }
          slotOneDay {
            id
            to
            from
          }
        }
        eventTickets {
          id
          price
          qty
          name
          description
          specialPrice
          specialPriceFrom
          specialPriceTo
          translations {
            locale
            name
            description
          }
        }
        rentalSlot {
          id
          rentingType
          dailyPrice
          hourlyPrice
          sameSlotAllDays
           slotManyDays {
            to
            from
          }
          slotOneDay {
            id
            to
            from
          }
        }
        tableSlot {
          id
          priceType
          guestLimit
          duration
          breakTime
          preventSchedulingBefore
          sameSlotAllDays
          slotManyDays {
            to
            from
          }
          slotOneDay {
            id
            to
            from
          }
        }
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
                priceHtml {
                priceHtml
                finalPrice
                }
                customizableOptions{
                    id
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
        input: { 
        email: "$email", 
        password: "$password", 
        remember: $remember, 
        deviceToken: "${GlobalData.fcmToken}",
        deviceName: "${GlobalData.deviceName}"
         }
      ) {
        message
        success
        accessToken
        tokenType
        customer {
          id
          name
          email
          imageUrl
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
          deviceToken: "${GlobalData.fcmToken}"
          deviceName: "${GlobalData.deviceName}"
        }
      ) {
        message
        success
        accessToken
        tokenType
        expiresIn
        customer {
            id
            name
            email
            apiToken
            token   
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
      String? oldpassword,
      String? password,
      String? confirmPassword,
      bool? subscribedToNewsLetter,
      String? imageField}) {
    final inputString = """
  ${imageField == 'delete' ? 'image: null' : ''}  
  """;

    return imageField == 'omit' || imageField == 'delete'
        ? """
      mutation updateAccount {
        updateAccount(
          input: {
            firstName: "$firstName"
            lastName: "$lastName"
            email: "$email"
            gender: ${gender?.toUpperCase()}
            dateOfBirth: "$dateOfBirth"
            phone: "$phone"
            currentPassword: "$oldpassword"
            newPassword: "$password"
            newPasswordConfirmation: "$confirmPassword"
            newsletterSubscriber: $subscribedToNewsLetter
            $inputString
          }
        ) {
          success
          message
          customer{
            id
            name
            email
            imageUrl
          }
        }
      }"""
        : json.encode({
            "query": """
      mutation updateAccount(\$input: UpdateAccountInput!) {
        updateAccount(input: \$input) {
          success
          message
          customer {
            id
            name
            email
            imageUrl
          }
        }
      }
    """,
            "variables": {
              "input": {
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "gender": gender?.toUpperCase(),
                "dateOfBirth": dateOfBirth,
                "phone": phone,
                "currentPassword": oldpassword,
                "newPassword": password,
                "newPasswordConfirmation": confirmPassword,
                "newsletterSubscriber": subscribedToNewsLetter,
                "image": null // <- placeholder for file
              }
            }
          });
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
            productId
            customer {
                id
                name
            }
            product {
                id
                sku
                name
                urlKey
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
        }
        states {
            id
            countryCode
            code
            defaultName
            translations {
                id
                locale
              
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
            grandTotal
            appliedTaxRates {
            taxName
            totalAmount
            }
            items {
                id
                quantity
                appliedTaxRate
                price
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
    String query = """
    mutation placeOrder(
  \$isPaymentCompleted: Boolean,
  \$error: Boolean,
  \$message: String,
  \$transactionId: String,
  \$paymentStatus: String,
  \$paymentType: String,
  \$paymentMethod: String,
  \$orderID: String
) {
    placeOrder(isPaymentCompleted: \$isPaymentCompleted,
    error: \$error,
    message: \$message,
    transactionId: \$transactionId,
    paymentStatus: \$paymentStatus,
    paymentType: \$paymentType,
    paymentMethod: \$paymentMethod,
    orderID: \$orderID
    ) {
        success
        redirectUrl
        order {
            id
        }
      }
    }""";
    return query;
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
                formattedPrice
            }
        }
        paymentMethods {
            method
            methodTitle
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

  String getCompareProducts() {
    return r'''
query compareProducts($page: Int!, $first: Int!) {
  compareProducts(
    page: $page
    first: $first
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
}
''';
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

  String addReview() {
    return r'''
    mutation CreateReview($input: CreateReviewInput!) {
      createReview(input: $input) {
        success
        message
        review {
          id
        }
      }
    }
  ''';
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
            downloadBought
            downloadUsed
            orderId
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
    fileName
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

  String getCoreConfigs({String code = "sales.payment_methods"}) {
    return """
    query coreConfigs {
    coreConfigs (
        first: 1000
        page: 1
        input: {
            code: "$code"
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
            code
            value
            channelCode
            localeCode
        }
      }
    }
    """;
  }

  String getSlots({required int id, required String date}) {
    return """
    query getSlots {
      getSlots (
        id: $id, # Booking Product Id
        date: "$date"
      ) {
        from
        to
        timestamp
        qty # in case Appointment
        # For Rental 
        time
        slots {
          from
          to
          fromTimestamp
          toTimestamp
          qty
        }
      }
    }
    """;
  }

  String gdprRequests(int customerId) {
    return """
    query gdprRequests {
      gdprRequests(input: { customerId: $customerId }) {
        paginatorInfo {
          count
          currentPage
          lastPage
          total
        }
        data {
          id
          customerId
          email
          status
          type
          message
          revokedAt
          createdAt
          updatedAt
        }
      }
    }
    """;
  }

  String createGdprRequestMutation = r'''
mutation CreateGdprRequest($input: GdprRequestInput!) {
  createGdprRequest(input: $input) {
    status
    message
    gdprRequest {
      id
      customerId
      email
      status
      type
      message
      revokedAt
      createdAt
      updatedAt
    }
  }
}
''';
  String revokeGdprRequest(int id) {
    return """
  mutation revokeGdprRequest {
    revokeGdprRequest(id: $id) {
      status
      message
      gdprRequest {
        id
        status
        revokedAt
      }
    }
  }
  """;
  }

  String gdprSearchRequest(int id) {
    return """
    query gdprRequest {
      gdprRequest(id: $id) {
        id
        customerId
        email
        status
        type
        message
        revokedAt
        createdAt
        updatedAt
      }
    }
    """;
  }

  String downloadGdprData() {
    return """
    mutation downloadGdprData {
      downloadGdprData {
        success
        string
        download {
          fileName
          extension
        }
      }
    }
    """;
  }
}
