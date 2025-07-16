#### This changelog consists the bug & security fixes and new features being included in the releases listed below.

# CHANGELOG for v2.3.0
## **v2.3.0 (16th of July, 2025)** - *Release*

# CHANGELOG for v2.3.0
* [Enhancement] Features as per Bagisto v2.3.0.
* [Enhancement] HomePage Similar to web with respect to dynamic html content.
* [Enhancement] Booking Product Support Added
* [Enhancement] Customizable Options feature added
* [Enhancement] Paypal Support Added
* [Improvement] Optimized GraphQL queries across the project to improve data retrieval performance.
* [Compatibility] Compatibility with Xcode 16.3.
* [Compatibility] Compatibility with Flutter Version 3.32.5.


## **Bug Fixes**

[Fixed] Support For Multipart Request for file upload
[Fixed] Better Filter Support for collections


## **v2.3.0-alpha (16th of May, 2025)** - *Release*

* [Enhancement] Compatibility with Bagisto v2.3.0.
* [Enhancement] Introduced an "Agreement & Terms Policy" button on the sign-up screen.
* [Improvement] support dynamic additional key, enabling flexible data handling.
* [Improvement] Updated filterAttributes key dynamic to enabling flexible data handling.
* [Improvement] Optimized GraphQL queries across the project to improve data retrieval performance.
* [Compatibility] Compatibility with Xcode 16.3.
* [Compatibility] Compatibility with Flutter Version 3.29.3.

## **Bug Fixes**

[Fixed] Resolved customer account update failure.
[Fixed] Fixed issue with product review submission.

# CHANGELOG for v2.2.2

#### This changelog consists the bug & security fixes and new features being included in the releases listed below.

## **v2.2.2 (23rd of October 2024)** - *Release*

* [Feature] Compatible with Bagisto version 2.2.2

* [Feature] Reorder support

* [Feature] Subcategories Support

* [Feature] Default address Support

* [Feature] Same billing and shipping address support

* [Feature] Inclusive and exclusive tax support

* [Feature] Quantity option in wishlist add to cart support

* [Feature] Subscribe and unsubscribe newsletter support

* [Feature] Filter option for downloadable products support

* [Feature] Configurable product details support

* [Feature] Contact us page support

## **Bug Fixes**

* [Fixed] - Getting product in the compare page when new customer register.

* [Fixed] - Downloadable product sample file is not downloading from the product page.

* [Fixed] - Show "Please add address" warning message on the address page while checkout if address already added.

* [Fixed] - Default product and quantity should be select on the bundle product page and total amount and selected products should be visible as per selected options.

* [Fixed] - Admin added logo and banner image should visible for the category page.

* [Fixed] - Sorting from a-z or from z-a is not working properly on the catalog page.

* [Fixed] - Filter is not working properly on the catalog page.

* [Fixed] - Need to improve the warning message if user trying to register account with already registered email address.

* [Fixed] - Customer and Guest user is not able to checkout due to shipping methods not coming.

* [Fixed] - Show warning message if user send the forget password email.

* [Fixed] - Customer is not able to place order with downloadable product.

* [Fixed] - Customer is able to add configurable product to cart without selecting size on the product page.

* [Fixed] - Dark Mode issue on the search page.

* [Fixed] - #20 Compatibility with latest graphql version


## **v2.0.0 (31st of January 2024)** - *Release*

* [Feature] Compatible with Bagisto version 2.0.0

* [Feature] Push Notification

* [Feature] Multi-locale support

* [Feature] Dark Mode Supported

* [Feature] Guest Checkout

* [Feature] Multi Currency Support

* [Feature] All Type Product Supported

* [Feature] Coupons Supported

## **Bug Fixes**

* [Fixed] - Show "null review" and product name, price will hide when user refresh the product page.

* [Fixed] - Show extra products under the unselected category from admin end on the catalog category page.

* [Fixed] - User should be able to apply any price filter not multiple of 50 on the catalog product filter page.

* [Fixed] - Need to improve the text and manage space for success message when guest user save address on the address page.

* [Fixed] - Getting warning message " Null check operator user on a null value" if user use "empty spaces" as coupon code and apply on the cart page.

* [Fixed] - Need to show the message if shipping methods are not available for particular location on the shipping page.

* [Fixed] - Product price and subtotal are not visible on the payment page.

* [Fixed] - Getting empty page with message "Null check operator used on a null value" if guest user click on the "Your order id" button the order confirmation page.

* [Fixed] - Need to improve the success message when user add the review to the product.

* [Fixed] - Remove All button is not removing after remove all products from the wishlist.

* [Fixed] - Need to improve the success message when user remove the coupon code from the cart page.

* [Fixed] - Applied coupon amount value is not reflecting on the price details on the payment page.

* [Fixed] - If user place order after adding first time address on the address page then click proceed button then getting warning message.

* [Fixed] - User added review on product is not visible on the admin end.

* [Fixed] - Show wrong data at place of email field on the reviews page.

* [Fixed] - After click "Continue Shopping" button if user again visit the cart page the product is removed.

* [Fixed] - User is not able to remove the already added products on the compare product page.

* [Fixed] - Homepage refresh API is not working properly as wishlist status is not updating on the homepage.

* [Fixed] - User is not able to place order with virtual product getting "Oops server error.Please try again." on the shipping methods page.

* [Fixed] - If user click on recent products then product page is not open and recent product name is not visible on the homepage.

* [Fixed] - After order cancel user redirect to the order page then after some time orders are not visible orders page.

* [Fixed] - Add/Edit address on the address page is not updating immediately on the change address page.


## **v1.4.5 (5th of June 2023)** - *Release*

* [Feature] Compatible with Bagisto version 1.4.5

* [Feature] App Performance Enhanced

* [Feature] voice search 

* [Feature] Add Filters on Order list

* [Feature] implemented dashboard view

* [Feature] implement fingerprint login

* [Feature] implemented Product share

* [Feature] implement wishlist sharing

* [Feature] implement sorting on products

* [Feature] Address filling via google map

## **Bug Fixes**

* [Fixed] - When the user removes the coupon from the "Review and checkout" page, the Total amount should get updated.

* [Fixed] - App is not responding, The menu bar is not responding.

* [Fixed] - Orders || order quantity is not correct in app.

* [Fixed] - When the user creates a new account and opens the account information page, some already saved profile picture is visible.

* [Fixed] - Cart|| After adding the product into the cart when refreshing home page at that time cart is getting empty.

* [Fixed] - When the user set the profile image, Without clicking on the save button, Profile pic gets saved.

* [Fixed] - when user create their new account, at that time success message is not correct in app.

* [Fixed] - Category|| filters ||need to implement "apply" button in filter.

* [Fixed] - Add Address || When we add an address through the live location the text is shown in English.

* [Fixed] - guest user|| after added complete address by fetching current location,"country" is not showing correct on review and checkout page in app.


## **v1.3.3 (23rd November 2021)** - *Release*

* [Feature] Compatible with Bagisto version 1.3.3

* [Fixed] - Guest user should not be able to add product to the wishlist.

* [Fixed] - After order placed,the particular product is not visible on order page.

* [Fixed] - Cross button is not visible on Compare product page.

* [Fixed] - User click on product on catalog page that product page is not opened.

* [Fixed] - Order date is showing wrong in the order-list

* [Fixed] - User is not able to complete order from shipping page.


## **v1.3.2 (30th April 2021)** - *Release*

* [Feature] Compatible with Bagisto version 1.3.2

* [Fixed] - If user edit the address then app will add brackets with street field every time.

* [Fixed] - As a guest user-unable to add a wishlist -getting something went wrong message

* [Fixed] - Quantity increase and decrease button on product page is not working.

* [Fixed] - Not able to remove address from address book page.

* [Fixed] - Unable to show user profile information

* [Fixed] - Share button is not working on product page.

* [Fixed] - Price details are not correct and showing without a currency symbol on shopping cart page.