#### This changelog consists the bug & security fixes and new features being included in the releases listed below

# CHANGELOG for v2.5.1

## **v2.5.1 (14th of October, 2026)** - *Release*

* [Enhancement] Added EU contract withdrawal: logged-in customers can withdraw from an order on the order detail page, and guests can submit a withdrawal from the account screen, when it is enabled in the admin.
* [Enhancement] Added a "Request a Return" button on the order detail page for orders that are eligible for a return.
* [Enhancement] Added a Refunds tab on the order detail page with the refunded items and the order totals, including the amount paid, refunded, and due.
* [Enhancement] Added the Services Content and Footer Links homepage sections from the theme settings.
* [Enhancement] Added pull-to-refresh to the profile, account dashboard, orders, wishlist, reviews, and downloadable products screens.
* [Enhancement] Showed the category description on the Categories tab.
* [Enhancement] Showed the store logo configured for the channel in the admin.
* [Enhancement] Homepage banner and content links now open the linked category or product.
* [Enhancement] Tapping a category on the homepage opens the Categories tab when it has sub-categories, and its product list otherwise.
* [Improvement] Matched the Contact Us form to the storefront: the same fields, labels, placeholders, and required fields, with the phone number optional.
* [Improvement] Applied the storefront phone number rule (digits with an optional leading +) to contact, address, checkout, and profile forms instead of a fixed 10-digit limit.
* [Improvement] Phone and gender are now required on the edit profile form.
* [Improvement] Out-of-stock products now show a disabled Add to Cart and Buy Now on the product page.
* [Improvement] Discounted products now show the original price with a strikethrough, including configurable products, bundles, and catalog price rules.
* [Improvement] Logged-in orders now use the customer's account email.
* [Improvement] Suspended customers can browse the store but can no longer check out.
* [Improvement] Guests are asked to sign in before checkout when a product in the cart does not allow guest checkout.
* [Improvement] Booking products now grey out dates with no available slots, show "Cancellation Not Allowed" and "View on Map" where relevant, and no longer show availability details the storefront does not show.
* [Improvement] Order details now show a note when a booking in the order cannot be canceled, and show refunded and canceled quantities for each item.
* [Improvement] Error messages now say which step failed instead of a generic "Something went wrong".
* [Improvement] Language and currency lists refresh from the store when the settings sheet opens; a language without app translations falls back to English.
* [Fixed] Fixed the homepage showing outdated content after changes in the admin, and sorted homepage sections in the order set in the admin.
* [Fixed] Fixed homepage product carousels saved without filters not appearing.
* [Fixed] Fixed the homepage category carousel showing the wrong categories, including sub-categories shown as top-level categories.
* [Fixed] Fixed shipment details not loading on the order detail page.
* [Fixed] Fixed the return request flow so only eligible orders and items can be selected.
* [Fixed] Fixed the cart badge not updating right after Reorder.
* [Fixed] Fixed a failed order cancellation hiding the order; the reason is now shown instead.
* [Fixed] Fixed the coupon code being cleared from the input box while it is being applied.
* [Fixed] Fixed booking quantities showing as "N/A" in the cart and at checkout.
* [Fixed] Fixed add to cart reporting success when the requested booking quantity is not available.
* [Fixed] Fixed account deletion and the loading of states by country code, which were failing because of invalid requests.
* [Fixed] Fixed a crash when the API returns numeric IDs or positions as text.
* [Known Limitation] Some admin settings are not available through the Bagisto GraphQL API yet, so the app cannot follow them: wishlist, compare, image search, Buy Now, and social share toggles, cart summary mode, cart page toggle, redirect after login, reviewer name censoring, and the header and mini cart offer texts. These will be supported once the API exposes them.
* [Known Limitation] The Refunds tab combines all refunds on an order, because the API does not yet list individual refunds or adjustment amounts.

# CHANGELOG for v2.5.0

## **v2.5.0 (18th of September, 2026)** - *Release*

* [Enhancement] Implemented review attachments: Users can now pick photos and videos (with preview and thumbnails) when adding a product review.
* [Enhancement] Added a media strip to review cards on the product page to display uploaded photos and play videos.
* [Enhancement] Displayed the short description on every product detail page.
* [Enhancement] Added required field indicators (asterisks) to the Contact Us form.
* [Fixed] Fixed the checkout page where saving an address to the address book caused a GraphQL error.
* [Fixed] Fixed the product detail page to show only its own approved reviews instead of mixing reviews from other products.
* [Fixed] Hid categories that are disabled in the admin backend from showing up in the app.
* [Fixed] Fixed the category page layout, banner display, and empty category data handling.
* [Fixed] Fixed the keyboard interaction on the Add Review screen so it dismisses when tapping outside fields but stays open while scrolling.
* [Fixed] Fixed review video uploads to properly convert iOS video formats (.mov, .m4v) to .mp4.
* [Fixed] Fixed the custom back button icon, padding, and spacing issues across pages.
* [Fixed] Fixed the review section to properly show or hide the nickname based on the flow.

# CHANGELOG for v2.4.9

## **v2.4.9 (10th of September, 2026)** - *Release*

* [Enhancement] Added "View" and "Cancel Request" actions to the returns list, with cancellation confirmation, loading feedback, and translated action labels.
* [Fixed] Fixed loading returnable items and submitting or cancelling return requests by aligning GraphQL queries and mutations with the Bagisto API.
* [Fixed] Fixed the returns list not refreshing after creating a request or returning from the detail screen after cancelling, reopening, or marking a request as solved.
* [Fixed] Prevented outdated responses from skipping return list items or replacing refreshed data when loading more requests overlaps with a refresh.
* [Fixed] Fixed duplicate returns list screens after submitting a request, so Back returns directly to the account page.
* [Fixed] Allowed cancellation of solved returns in line with the API and storefront, while preventing cancellation of requests that are already cancelled.
* [Improvement] Prevented duplicate cancellation submissions and kept the returns list available when cancellation fails, with an error message and the option to retry.

# CHANGELOG for v2.4.8

## **v2.4.8 (4th of September, 2026)** - *Release*

* [Enhancement] Added RMA (returns) support: customers can view their return requests, open a request detail with status, item information, attachments, and a two-way message thread with the store, and cancel, reopen, or mark a return as solved.
* [Enhancement] Added a "Create Request" flow for returns that starts by selecting an order, then choosing the item, resolution (return or cancel items), quantity, reason, package condition, and additional information before submitting.
* [Enhancement] Added order cancellation from the order detail screen for orders that are still pending or processing, with a confirmation prompt and live status update after cancelling.
* [Fixed] Fixed adding and editing account addresses by removing the `useForShipping` field that the API no longer returns, which was causing the save to fail.
* [Fixed] Fixed placing an order at checkout by removing the `orderIncrementId` field that the API no longer returns for the create-order response.
* [Known Limitation] Return image uploads and message attachments are not supported yet because the Bagisto GraphQL API handles file uploads only over REST. Once GraphQL support is available, these will be implemented as well.

# CHANGELOG for v2.4.7

## **v2.4.7 (14th of August, 2026)** - *Release*

* [Fixed] Fixed the app getting stuck on the launch screen at startup by making Firebase Cloud Messaging setup non-blocking, so the first screen renders even when notifications are unavailable or a placeholder Firebase configuration is used.
* [Improvement] Locked the app to its own typography scale and made it ignore the device system font-size setting, keeping layouts consistent and preventing text overflow.
* [Improvement] Applied minor stability and UI refinements across account, address, checkout, home, search, and product screens.

# CHANGELOG for v2.4.6

## **v2.4.6 (6th of July, 2026)** - *Release*

* [Enhancement] Added product customizable options support on product detail pages, including dynamic controls for text, textarea, checkbox, radio, select, multiselect, date, datetime, and time options.
* [Improvement] Improved add-to-cart handling so supported customizable options are included across simple, configurable, grouped, bundle, downloadable, and booking product flows.
* [Known Limitation] The File customizable option type is not supported yet because the Bagisto API does not currently support it for mobile app implementation. Once Bagisto API support is available, this option type will be implemented as well.

# CHANGELOG for v2.4.5

## **v2.4.5 (26th of May, 2026)** - *Release*

* [Improvement] Improved account address state handling for countries without predefined states and preserved saved state values while editing addresses.
* [Improvement] Simplified account address management with a single "Set as Default" flow and improved dashboard/address book refresh after add or edit actions.
* [Improvement] Improved checkout saved-address synchronization, including refreshed address selection flows, separate billing and shipping selection handling, and interaction blocking while placing orders.
* [Fixed] Fixed account default address updates by sending the full payload expected by the API.
* [Fixed] Fixed checkout address book saving so separate billing and shipping addresses are preserved when they are different.
* [Fixed] Fixed checkout address selection UI by removing address type badges and preserving separate shipping selections after manual address entry.

# CHANGELOG for v2.4.4

## **v2.4.4 (22nd of May, 2026)** - *Release*

* [Improvement] Improved checkout address selection with dedicated billing and shipping address handling from the checkout sheet.
* [Improvement] Added support to create a new address directly from checkout and auto-select it after saving.
* [Improvement] Added support to save the first manually entered checkout address to the customer address book.
* [Fixed] Fixed order list pagination so loading more orders continues with the correct cursor.
* [Fixed] Fixed cart move-to-wishlist behavior when a product is already present in the wishlist.
* [Fixed] Fixed order and invoice product "More info" handling for selected options.
* [Fixed] Fixed account address refresh behavior after address updates and corrected home banner image cropping.

# CHANGELOG for v2.4.3

## **v2.4.3 (10th of April, 2026)** - *Release*

* [Improvement] Fixed bugs to improve overall stability and performance

# CHANGELOG for v2.4.2

## **v2.4.2 (8th of April, 2026)** - *Release*

* [Improvement] Fixed bugs to improve overall stability and performance

# CHANGELOG for v2.4.1

## **v2.4.1 (7th of April, 2026)** - *Release*

* [Improvement] Fixed bugs to improve overall stability and performance.

# CHANGELOG for v2.4.0

## **v2.4.0 (6th of April, 2026)** - *Release*

# CHANGELOG for v2.4.0

* [Enhancement] Full-screen product image viewer with zoom and swipe support.
* [Enhancement] In-app update alerts for the latest app versions.
* [Enhancement] Added support for multiple languages.
* [Enhancement] Booking product support added.
* [Enhancement] Added support for downloadable and grouped products.
* [Enhancement] Multi-currency support added.
* [Enhancement] Push notifications added.
* [Improvement] Fixed bugs to improve overall stability and performance.

# CHANGELOG for v2.3.9

## **v2.3.9 (20th of Feb, 2026)** - *Release*

# CHANGELOG for v2.3.9

* [Enhancement] Ui Updates And Bug Fixes
* [Improvement] Optimized GraphQL queries across the project to improve data retrieval performance.
* [Improvement] Optimized overall user experience
* [Compatibility] Compatibility with Xcode 26.3.
* [Compatibility] Compatibility with Flutter Version 3.38.9

# CHANGELOG for v2.3.2

## **v2.3.2 (28th of July, 2025)** - *Release*

# CHANGELOG for v2.3.2

* [Enhancement] Features as per Bagisto v2.3.6.
* [Improvement] Optimized GraphQL queries across the project to improve data retrieval performance.
* [Improvement] Optimized overall user experience
* [Compatibility] Compatibility with Xcode 16.3.
* [Compatibility] Compatibility with Flutter Version 3.32.5.

# CHANGELOG for v2.3.0

## **v2.3.0 (22nd of July, 2025)** - *Release*

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

#### This changelog consists the bug & security fixes and new features being included in the releases listed below

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
