class MutationsData {
  String customerRegister({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return """
mutation customerRegister {
customerRegister(input: {
firstName:  "$firstName"
lastName: "$lastName"
email: "$email"
password: "$password"
passwordConfirmation: "$confirmPassword"
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
}
    """;
  }

  String customerLogin({
    String? email,
    String? password,
    bool? remember,
  }) {
    return """
      mutation customerLogin{
          customerLogin(input: {
            email: "$email"
            password: "$password"
            remember: $remember
          }){
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
      }
    """;
  }

  String forgotPassword({
    String? email,
  }) {
    return """
      mutation forgotPassword{
          forgotPassword(input: {
            email: "$email"
          }){
           status
           success
          }
      }
    """;
  }

  String shareWishlist({
    bool? shared,
  }) {
    return """
      mutation shareWishlist {
    shareWishlist(shared: $shared) {
        isWishlistShared
        wishlistSharedLink
    }
    }
    """;
  }

  String getCustomerData() {
    return """
  query accountInfo {
    accountInfo {
        status
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
            imageUrl
            status
        }     
    }
}
""";
  }

  String updateAccount({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? phone,
    String? oldpassword,
    String? password,
    String? confirmPassword,
    String? avatar,
  }) {
    return """
      mutation updateAccount{
          updateAccount(input: {
        firstName: "$firstName"
        lastName: "$lastName"
        email: "$email"
      	gender: "$gender"
      	uploadType: BASE64
        imageUrl: "data:image/png;base64,$avatar"
      	dateOfBirth: "$dateOfBirth"
        phone: "$phone"
        oldpassword: "$oldpassword"
        password: "$password"
        passwordConfirmation: "$confirmPassword"
          }) {
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
            isVerified
            imageUrl
            status
          }
      }
},
    """;
  }

  String customerLogout() {
    return """
      mutation customerLogout{
        customerLogout {
           status
           success
          }
      }
    """;
  }

  String deleteAccount({
    String? password,
  }) {
    return """
      mutation deleteAccount{
          deleteAccount(input: {
            password: "$password"
          }){
           status
           success
          }
      }
    """;
  }

  String getAddressList() {
    return """
query addresses {
    addresses {
        status
        message
        addresses {
            id            
            firstName
            lastName
            address1
            address2
            country
            countryName
            stateName
            state
            city
            postcode
            phone
            vatId
    
        }
    }
}
""";
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
  }) {
    return """
    mutation updateAddress {
    updateAddress(id: $id, input: {
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address1: "$address"
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
}
    """;
  }

  String createAddress({
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
  }) {
    return """
    mutation createAddress {
    createAddress(input: {
        companyName: "$companyName"
        firstName: "$firstName"
        lastName: "$lastName"
        address1: "$address"
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
            defaultAddress
          
       }
    }
}
    """;
  }

  String deleteAddress({
    int? id,
  }) {
    return """
     mutation deleteAddress {
    deleteAddress(id:$id) {
        status
        message
    }
}
    """;
  }

  String getOrdersList({
    String? id,
    String? startDate,
    String? endDate,
    String? status,
    double? total,
    int? page,
  }) {
    return """
query ordersList {
    ordersList(input: {
        incrementId: "$id",
        startOrderDate: "$startDate",
        endOrderDate: "$endDate",
        status: "$status",
        baseGrandTotal: $total,
    }
     first: 10,
     page: $page,
    ) {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data{
         formattedPrice {
grandTotal
baseGrandTotal
}
            id
        status
        totalQtyOrdered
        grandTotal
        baseGrandTotal
        createdAt
        }
        }
}
""";
  }

  String getOrderDetail(int id) {
    return """
query orderDetail {
    orderDetail(id: $id) {
     formattedPrice {
     subTotal
     taxAmount
     shippingAmount
     baseDiscountAmount
     grandTotal
}
        id
        incrementId
        status
        shippingTitle
        createdAt
        payment {
id
method
methodTitle
}
        billingAddress {
            firstName
            lastName
            companyName
            address1
            address2
            postcode
            city
            state
            country
            email
            phone
        }
        shippingAddress {
            firstName
            lastName
            companyName
            address1
            address2
            postcode
            city
            state
            country
            email
            phone
                    }
        items {
            name
            qtyOrdered
            qtyShipped
            qtyInvoiced
            qtyCanceled
            qtyRefunded
 
formattedPrice {
price
total
}
            product {
             images {
path
url
}
            }
        }
    }
}
""";
  }

  String wishlistData() {
    return """
query wishlists {
    wishlists(input: {
    }) {
        data{
        id
        productId
        product {
name
description
            id
            type    
                        priceHtml {
regular
special
}
            images {
path
url
}
        }
          cart {
            id
            itemsCount
        }
    }
    }
}
""";
  }

  String addToWishlist({
    int? id,
  }) {
    return """
    mutation addToWishlist {
    addToWishlist(input: {
        productId: $id
    }) {
        success
    }
}
    """;
  }

  String removeFromWishlist({
    int? id,
  }) {
    return """
   mutation removeFromWishlist {
    removeFromWishlist(input: {
        productId: $id
    }) {
        status
        success
    }
}
    """;
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

  String updateItemToCart({List<Map<dynamic, String>>? item}) {
    return """
    mutation updateItemToCart {
updateItemToCart(input: {
qty: $item
}) {
status
}
}
 """;
  }

  String moveToCart({
    int? id,
  }) {
    return """
   mutation removeFromWishlist {
    moveToCart(id: $id) {
        status
        success
    }
    }
    """;
  }

  String moveToWishlist({
    int? id,
  }) {
    return """
  mutation moveToWishlist {
moveToWishlist(id: $id ) {
status

}
}
    """;
  }

  String getDrawerCategories() {
    return """
query homeCategories  {
    homeCategories() {
        id
        name 
        description
        categoryIconUrl
        slug
        imageUrl
        children {
            id
            name
            description
            slug
            imageUrl
           
        }
       
    }
}
""";
  }

  String getCartDetails() {
    return """
query cartDetail {
    cartDetail {
        id
     couponCode
        formattedPrice {
grandTotal
subTotal
taxTotal
discount
}
        items {
            id
            quantity
            type
            name
            couponCode
            additional { 
              attributes
               { 
               optionLabel 
                attributeName
                 } }
            formattedPrice {
price
total
}
            product {
                id
                type
                attributeFamilyId
                sku
                parentId
                productFlats {
                id
                name
                locale
                }
                images {
                    url
                    path 
                }
            }
        }
    }
}""";
  }

  String getAdvertisementData() {
    return """
  query  advertisements {
           advertisements {
         advertisementFour {
image
slug
}
advertisementThree {
image
slug
}
advertisementTwo {
image
slug
}
               cart {
           id
            itemsCount
        }
}
                }
          """;
  }

  String getCartCount() {
    return """
query advertisements {
    advertisements {
     
        cart {
            id
            itemsCount
            itemsQty
        }
    }
}
          """;
  }

  String getHomepageSliders() {
    return """
 query homeSliders {
    homeSliders {
        id
        imageUrl
        title
        path
        content
        channelId
        locale
        sliderPath
        imgPath

    }
}
          """;
  }

  getNewProducts() {
    return """
      query newProducts {
        newProducts(count: 10) {
          id
          isInWishlist
          sku
           name
       shortDescription
          priceHtml {
            type
            regular
            special
          }
     
          images {
            path
            url
           
          }
          productFlats {
          id
          name
          new
          locale
          }
           reviews {
                rating
            }
        }
      }
    """;
  }

  getFeaturedProduct() {
    return """
      query featuredProducts {
        featuredProducts(count: 10) {
           id
          isInWishlist
                    sku
name
shortDescription
          priceHtml {
            regular
            type
            special
          }
      
          images {
           
            path
            url
          
          }
            productFlats {
          id
          new
          locale
          name
          }
           reviews {
                rating
             
            }
        }
      }
    """;
  }

  getCompareProducts() {
    return """
     query compareProducts {
    compareProducts(input: {
    }) {
        id
        productFlatId
        productFlat {
         product{
              id
              type
            isInWishlist
            images {
                    url
                }
            priceHtml {
regular
special
}
  averageRating
            }
            id
            sku
            name
            description
            shortDescription
        }
    cart {
            itemsCount
            }
    }
}
    """;
  }

  String removeFromCompare({
    int? id,
  }) {
    return """
  mutation removeFromCompareProduct {
    removeFromCompareProduct(input: {
        productFlatId: $id
    }) {
        status
        success
    }
}
    """;
  }

  String addToCompare({
    int? id,
  }) {
    return """
mutation addToCompare {
    addToCompare(input: {
        productFlatId: $id
    }) {
        success
    }
}
    """;
  }

  String addToCart({
    int? quantity,
    int? productId,
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
        }
    }
}
    """;
  }

  String productDetail(int id) {
    return """
    query 
 {
	product(id: $id) {
	  shareURL
	additionalData {
id
code
label
value
admin_name
type
}
        id
        type
      isInWishlist
        attributeFamilyId
        sku
        parentId
        priceHtml {
                regular
                special
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
                                                        # variantVideos {
                                                        #     id
                                                        #     videos
                                                        #     }
                                                            regularPrice {
                                                                formatedPrice
                                                                price
                                                                }
                                                                }
        productFlats {
            id
            sku
            productNumber
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
        images {
            id
            type
            path
            url
            productId
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
                product { productFlats { name } }
            }
       
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
            defaultSlot {
                id
                bookingType
                duration
                breakTime
                slots {
                    to
                    toDay
                    from
                    fromDay
                }
                bookingProductId
            }
            appointmentSlot {
                id
                duration
                breakTime
                sameSlotAllDays
                slots {
                    from
                    to
                }
                bookingProductId
            }
        }
            cart {
            id
            itemsCount
        
        
        }
    }
}
    """;
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
  ) {
    return """
    mutation saveCheckoutAddresses {
    saveCheckoutAddresses(input: {
    billingAddressId: 0
    shippingAddressId: 0
    billing: {
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
        saveAsAddress: true
    }
    shipping: {
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
        saveAsAddress: true
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
        jumpToSection
    }
}
    """;
  }

  String checkoutSaveShipping({String? shippingMethod}) {
    return """
    mutation paymentMethods {
    paymentMethods(input: {
        shippingMethod: "$shippingMethod"
    }) {
        success
        paymentMethods {
            method
            methodTitle
        }
         cart {
            id
                formattedPrice {
                grandTotal
               
       
            }
           
        }
    }
}
    """;
  }

  String saveAndReview({String? paymentMethod}) {
    return """
    mutation savePayment {
    savePayment(input: {
        payment: {
            method: "$paymentMethod"
        }
    }) {
        success
        cart {
            id
            couponCode
            formattedPrice {
grandTotal
subTotal
taxTotal
discount
}
shippingAddress {
address1
address2
postcode
city
state
country
email
phone
}
billingAddress {
address1
address2
postcode
city
state
country
email
phone
}
selectedShippingRate {
method
methodTitle
formattedPrice {
price
}
}
payment {
method
methodTitle
}
             items {
            quantity
                     formattedPrice {
price
total
}
            product {
                id
                productFlats {
                    name
                    locale
                }
                images {
                    path
                } 
            }
       
        }
        }
    }
}
    """;
  }

  String placeOrder() {
    return """
    mutation placeOrder {
    placeOrder {
        success
        redirectUrl
        order {
id
customerEmail
customerFirstName
customerLastName
}
    }
}
    """;
  }

  String getCmsData() {
    return """
  query cmsPages {
    cmsPages {
        paginatorInfo {
            count
            currentPage
            lastPage
            total
        }
        data {
            id
            translations {
                id
                pageTitle
                htmlContent
                locale
            }
        }
    }
}
  """;
  }

  getCategoriesProduct(String categorySlug, String searchQuery, String order,
      String sort, int page, List filter) {
    return """query getProductListing{
      getProductListing(
        input: {
          order:"$order",
          sort:"$sort",
          categorySlug:"$categorySlug",
          search:"$searchQuery",
          filters:$filter
        },
        first: 10,
        page: $page,
      ){
        paginatorInfo{
          count
          currentPage
          lastPage
          total
        }
        data{
          cart{
            id
            itemsCount
          }
          id
          name
          type
          isInWishlist
          priceHtml{
            id
            regular
            special
          }
          productFlats{
            id
            name
            new
            locale
          }
         
          images{
            path
            url
          }
          reviews{
           
            rating
          
          }
         
        }
      }
    }""";
  }

  applyCoupon(String couponCode) {
    return """
    mutation applyCoupon {
    applyCoupon(input: {
        code: "$couponCode"
    }) {
        success
        message
    }
}
    """;
  }

  removeCoupon() {
    return '''
mutation removeCoupon {
removeCoupon {
success
message
}
}
    ''';
  }

  getReviewList() {
    return """
    query reviewsList {
    reviewsList(input: {
    }) {
       data{
        id
        title
        rating
        comment
        productId
        createdAt
        customerName
        product {
            images{
            path
            url
            }
            productFlats {
                name
                locale
            }
        }
       }
    }
}
    """;
  }

  addReview(
      String name, String title, int rating, String comment, int productId) {
    return """
    mutation createReview {
    createReview(input: {
        name: "$name"
        title: "$title"
        rating: $rating
        comment: "$comment"
        productId: $productId
    }) {
        success 
    }
}
    """;
  }

  getLanguageCurrencyList() {
    return """
    query getDefaultChannel {
getDefaultChannel {
locales {
id
name
code
direction
createdAt
updatedAt
success
}
currencies {
id
name
code
symbol
success
}
}
}
    """;
  }

  getNotificationList() {
    return """
    query notificationList {
notificationList(
first: 10,
page: 1,
) {
paginatorInfo {
count
currentPage
lastPage
total
}
data {
id
image
imageUrl
type
productCategoryId
status
createdAt
updatedAt
translations {
id
title
content
locale
channel
pushNotificationId
}
}
}
}
    """;
  }

  getCountryStateList() {
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
}
    """;
  }

  removeFromCart(int id) {
    return """
    mutation removeCartItem {
    removeCartItem(id: $id) {
        status
        message
    }
}
    """;
  }

  socialLogin(
      {String? firstName, String? lastName, String? email, String? phone}) {
    return """
    mutation customerSocialSignUp {
customerSocialSignUp(input: {
phone: "$phone"
firstName: "$firstName"
lastName: "$lastName"
email: "$email"
signUpType: GOOGLE
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
}
    """;
  }

  removeReview(int id) {
    return """
    mutation deleteReview {
    deleteReview(id: $id) {
        status
        message
  
    }
}
    """;
  }

  removeAllCompareProducts() {
    return """
    mutation removeAllCompareProducts {
    removeAllCompareProducts {
        status
        success
    }
}
    """;
  }

  deleteAllReview() {
    return """
    mutation deleteAllReview { 
    deleteAllReview { 
    status 
    message 
    } 
    }
    """;
  }

  removeAllWishlistProducts() {
    return """
 mutation removeAllWishlists {
    removeAllWishlists {
        status
        success
    }
}
    """;
  }

  cancelOrder(int id) {
    return """
mutation cancelCustomerOrder {
    cancelCustomerOrder(id: $id) {
        status
        message
       
    }
}
    """;
  }

  getFilterProducts(String categorySlug) {
    return """
    query getFilterAttribute {
	getFilterAttribute (
         categorySlug:"$categorySlug") {
        minPrice
        maxPrice 
        filterAttributes 
        { 
        id 
        code
         adminName
          type
           options
            { 
            id
             adminName 
             swatchValue
              sortOrder
               isNew 
               translations 
               { 
               id 
               label 
               locale 
               } 
               } 
               } 
               sortOrders
                {
                 key 
                 label 
                 value 
                 { 
                 sort
                  order 
                  } 
                  }
       }
       }
    
    """;
  }

  getShipmentsList(int page, int orderId) {
    return """
   query viewShipments {
    viewShipments(input: {
        page: $page
        limit: 10
        orderId: $orderId
        # carrierTitle: "DHL"
        # trackNumber: "3333"
        # shipmentDateFrom: "2021-02-16 00:00:01"
        # shipmentDateTo: "2021-02-16 23:00:00"
        # shipmentDate: "2021-02-16 19:17:21"
    }) {
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
            productId
            productType
            orderItemId
            shipmentId
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
                images {
                    id
                    type
                    path
                    url
                    productId
                }
            }
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
            notes
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
    """;
  }

  getInvoicesList(int page, int orderId) {
    return """
    query viewInvoices {
    viewInvoices(input: {
        page: $page
        limit: 10
        # id: 1
        orderId: $orderId
        # quantity: 1
        # grandTotal: 5.35
        # baseGrandTotal: 5.35
        # invoiceDate: "2021-02-12 20:36:26"
    }) {
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
        transactionId
        items {
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
            additional
            discountPercent
            discountAmount
            baseDiscountAmount
            createdAt
            updatedAt
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
                productId
                productType
                orderId
                parentId
                additional
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
                images {
                    id
                    type
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

  getRefundList(int page, int orderId) {
    return """
      query viewRefunds {
    viewRefunds(input: {
        page: 1
        limit: 10
        orderId: 10
    }) {
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
          formattedPrice {
            grandTotal
            baseGrandTotal
            subTotal
            shippingAmount
            adjustmentRefund
            adjustmentFee
            baseAdjustmentFee
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
            additional
            createdAt
            updatedAt
            
            formattedPrice {
            price
            baseTotal
            taxAmount
            total
            }
            
            product {
                id
                type
                attributeFamilyId
                sku
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
        }
    }
}
    """;
  }

  String downloadableProductsCustomer(int page, int limit) {
    return """
   query downloadableLinkPurchases {
downloadableLinkPurchases(
input: {,
limit: $limit,
page: $page
}
){
id
productName
downloadBought
downloadUsed
orderId
createdAt
order{
id
status
}
}
}
    """;
  }

  String downloadProduct(int id) {
    return """
    mutation downloadLink {
    downloadLink(id: $id) {
        status
        string
        download {
            id
            name
            url
            file
            fileName
        }
    }
}
    """;
  }
}
