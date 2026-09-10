// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bagisto Store';

  @override
  String get homeFailedToLoad => 'Failed to load homepage';

  @override
  String get commonUnknownError => 'Unknown error';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonTimeoutError =>
      'The server is taking too long to respond. Please check your connection and try again.';

  @override
  String get commonUnableToReachServer =>
      'Unable to reach the server. Please check your internet connection and try again.';

  @override
  String get commonNetworkError =>
      'A network error occurred. Please check your internet connection and try again.';

  @override
  String get commonProcessingError =>
      'Something went wrong while processing the data. Please try again later.';

  @override
  String get commonMissingInformation =>
      'Some required information is missing. Please fill in all required fields and try again.';

  @override
  String get commonTooManyRequests =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get commonServerError =>
      'The server encountered an error. Please try again later.';

  @override
  String get commonPermissionDenied =>
      'You don\'t have permission to perform this action.';

  @override
  String get commonSecureConnectionError =>
      'A secure connection could not be established. Please try again later.';

  @override
  String get commonCartSessionExpired =>
      'Your cart session has expired. Please try again.';

  @override
  String get commonGenericError => 'Something went wrong. Please try again.';

  @override
  String commonGenericErrorWithContext(Object context) {
    return 'Something went wrong while $context. Please try again.';
  }

  @override
  String get commonEdit => 'Edit';

  @override
  String get authInvalidCredentials =>
      'The email or password you entered is incorrect. Please try again.';

  @override
  String get authSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get authSessionInvalid =>
      'Your session is no longer valid. Please log in again.';

  @override
  String get homeFeaturedProducts => 'Featured Products';

  @override
  String get homeDefaultProducts => 'Products';

  @override
  String get homeBackToTop => 'Back to Top';

  @override
  String get homeViewCart => 'VIEW CART';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName added to cart';
  }

  @override
  String get homeLoginToManageWishlist => 'Please login to manage wishlist';

  @override
  String get homeAddedToWishlist => 'Added to wishlist';

  @override
  String get homeRemovedFromWishlist => 'Removed from wishlist';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeCollections => 'Collections';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return '$categoryName category';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% off';
  }

  @override
  String get productFailedToLoad => 'Failed to load product';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get productDetail => 'Product Detail';

  @override
  String get productDetails => 'Details';

  @override
  String get productShowLess => 'Show Less';

  @override
  String get productLoadMore => 'Load More';

  @override
  String get productMoreInformations => 'More Informations';

  @override
  String get productSku => 'SKU';

  @override
  String get productType => 'Type';

  @override
  String get productBrand => 'Brand';

  @override
  String get productColor => 'Color';

  @override
  String get productSize => 'Size';

  @override
  String get productReviews => 'Reviews';

  @override
  String get productNoReviewsYet => 'No reviews yet';

  @override
  String productRating(Object count) {
    return '$count Rating';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count Reviews';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Posted on $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Your review has been submitted!';

  @override
  String get productWriteReview => 'Write a Review';

  @override
  String get productPleaseLoginForReviews =>
      'Please login to view your reviews';

  @override
  String get productLoadMoreReviews => 'Load More Reviews';

  @override
  String get productRelatedProduct => 'Related Product';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% off';
  }

  @override
  String get productVeryGood => 'Very Good';

  @override
  String get productGood => 'Good';

  @override
  String get productAverage => 'Average';

  @override
  String get productBad => 'Bad';

  @override
  String get productVeryBad => 'Very Bad';

  @override
  String get productInStock => 'In Stock';

  @override
  String get productOutOfStock => 'Out of Stock';

  @override
  String get productQuantity => 'Quantity';

  @override
  String get productWishlistAction => 'Wishlist';

  @override
  String get productCompareAction => 'Compare';

  @override
  String get productShareAction => 'Share';

  @override
  String get productLoginToCompare => 'Please login to add to compare';

  @override
  String get productAddedToCompare => 'Added to compare';

  @override
  String get productAddToCart => 'Add to Cart';

  @override
  String get accountMoveToCart => 'Move to Cart';

  @override
  String get productBuyNow => 'Buy Now';

  @override
  String get productSelectOptionsFirst => 'Please select product options first';

  @override
  String get productBookingBookTable => 'Book a Table *';

  @override
  String get productBookingSelectDateRequired => 'Select date *';

  @override
  String get productBookingSelectSlotRequired => 'Select slot *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Special Request/Notes *';

  @override
  String get productBookingBookAppointment => 'Book an Appointment *';

  @override
  String get productBookingDateFormatHint => 'YYYY-MM-DD';

  @override
  String get productBookingFrom => 'From';

  @override
  String get productBookingTo => 'To';

  @override
  String get productBookingSelectDate => 'Select date';

  @override
  String get productBookingLocation => 'Location';

  @override
  String get productBookingSlotDuration => 'Slot Duration';

  @override
  String get productBookingAvailability => 'Availability';

  @override
  String get productBookingStartDate => 'Start Date';

  @override
  String get productBookingEndDate => 'End Date';

  @override
  String get productBookingDate => 'Date';

  @override
  String get productBookingViewOnMap => 'View on Map';

  @override
  String get productBookingEventOn => 'Event on :';

  @override
  String get productBookingBookYourTicket => 'Book Your Ticket';

  @override
  String get productBookingSlotDurationLabel => 'Slot Duration :';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count Minutes';
  }

  @override
  String get productBookingAvailableFrom => 'Available From';

  @override
  String get productBookingAvailableTo => 'Available To';

  @override
  String get productBookingSpecialRequestNotesHint => 'Special Request/Notes';

  @override
  String get productBookingChooseRentOption => 'Choose Rent Option *';

  @override
  String get productBookingDailyBasis => 'Daily Basis';

  @override
  String get productBookingHourlyBasis => 'Hourly Basis';

  @override
  String get productBookingNoDatesAvailable => 'No dates available for booking';

  @override
  String get productBookingSelectSlot => 'Select Slot';

  @override
  String get productBookingSelectDateFirst => 'Select date first';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Choose a date first to see available slots.';

  @override
  String get productBookingLoadingSlots => 'Loading slots...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Available slots are loading for the selected date.';

  @override
  String get productBookingUnableToLoadSlots => 'Unable to load slots';

  @override
  String get productBookingNoSlotsAvailable => 'No slots available';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'No slots are available for the selected date.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Select one available slot to continue.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Special request notes';

  @override
  String get productDownloadableLinks => 'Links';

  @override
  String get productDownloadableSamples => 'Samples';

  @override
  String get productDownloadSample => 'Download Sample';

  @override
  String get productDefaultName => 'Product';

  @override
  String get categoryDefaultName => 'Categories';

  @override
  String get categorySubCategories => 'Sub Categories';

  @override
  String get categorySomethingWentWrong => 'Something went wrong';

  @override
  String get categoryUnknownError => 'Unknown error';

  @override
  String categoryItemsFound(Object count) {
    return '$count Items Found';
  }

  @override
  String get categoryNoProductsFound => 'No products found';

  @override
  String get categorySort => 'Sort';

  @override
  String get categorySortByTitle => 'Sort By';

  @override
  String get categorySortAZ => 'From A-Z';

  @override
  String get categorySortZA => 'From Z-A';

  @override
  String get categorySortNewest => 'Newest First';

  @override
  String get categorySortOldest => 'Oldest First';

  @override
  String get categorySortCheapest => 'Cheapest First';

  @override
  String get categorySortExpensive => 'Expensive First';

  @override
  String get categoryFilter => 'Filter';

  @override
  String get categoryFilters => 'Filters';

  @override
  String get categoryNoFiltersAvailable => 'No filters available';

  @override
  String get categoryFiltersWillAppear =>
      'Filters will appear when available for this category';

  @override
  String get categoryApplyFilters => 'Apply Filters';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Apply Filters ($count)';
  }

  @override
  String get categoryClearAll => 'Clear All';

  @override
  String get categoryTryAdjustingFilters =>
      'Try adjusting your filters or search criteria';

  @override
  String get categoryError => 'Error';

  @override
  String get categoryLoginToManageWishlist => 'Please login to manage wishlist';

  @override
  String get categoryAddedToWishlist => 'Added to wishlist';

  @override
  String get categoryRemovedFromWishlist => 'Removed from wishlist';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Failed to update wishlist: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Cart';

  @override
  String get cartPleaseLoginWishlist => 'Please login to view wishlist';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText in the Cart';
  }

  @override
  String get cartYourCartEmpty => 'Your cart is empty';

  @override
  String get cartAddProductsHere =>
      'Add products to your cart to see them here';

  @override
  String get cartContinueShopping => 'Continue Shopping';

  @override
  String get cartUnit => 'Unit';

  @override
  String get cartUnits => 'Units';

  @override
  String get cartPleaseLoginWishlistAdd => 'Please login to add to wishlist';

  @override
  String get cartMovedToWishlist => 'Moved to wishlist';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Failed to move to wishlist: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'View More';

  @override
  String get cartViewLess => 'View Less';

  @override
  String get cartEmptyCartAction => 'Empty Cart';

  @override
  String get cartApplyCoupon => 'Apply Coupon';

  @override
  String get cartCouponCode => 'Coupon Code';

  @override
  String get cartApply => 'Apply';

  @override
  String get cartAppliedCoupon => 'Applied Coupon';

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartPriceBreak => 'Price Break';

  @override
  String get cartSubTotal => 'SubTotal';

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartDeliveryCharges => 'Delivery Charges';

  @override
  String get cartTax => 'Tax';

  @override
  String get cartGrandTotal => 'Grand Total';

  @override
  String get cartAmountToBePaid => 'Amount to be Paid';

  @override
  String get cartPayNow => 'Pay Now';

  @override
  String get cartRemoveItem => 'Remove Item';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Are you sure you want to remove \"$productName\" from your cart?';
  }

  @override
  String get cartCancel => 'Cancel';

  @override
  String get cartEmptyCartTitle => 'Empty Cart';

  @override
  String get cartEmptyCartConfirm =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get checkout => 'Checkout';

  @override
  String get checkoutBillingTo => 'Billing to';

  @override
  String get checkoutDeliveredTo => 'Delivered to';

  @override
  String get checkoutChange => 'Change';

  @override
  String get checkoutSelectBillingAddress => 'Select Billing Address';

  @override
  String get checkoutSelectShippingAddress => 'Select Shipping Address';

  @override
  String get checkoutBillingAddress => 'Billing Address';

  @override
  String get checkoutEnterAddress => 'Enter Address';

  @override
  String get checkoutFirstName => 'First Name';

  @override
  String get checkoutLastName => 'Last Name';

  @override
  String get checkoutEmail => 'Email';

  @override
  String get checkoutPhone => 'Phone';

  @override
  String get checkoutStreetAddress => 'Street Address';

  @override
  String get checkoutCountry => 'Country';

  @override
  String get checkoutState => 'State';

  @override
  String get checkoutCity => 'City';

  @override
  String get checkoutPostcode => 'Postcode';

  @override
  String get checkoutCompanyOptional => 'Company (Optional)';

  @override
  String get checkoutUseSameAddressShipping => 'Use same address for shipping?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Phone: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Office';

  @override
  String get checkoutAddressTypeHome => 'Home';

  @override
  String get checkoutAddressTypeBilling => 'Billing';

  @override
  String get checkoutAddressTypeShipping => 'Shipping';

  @override
  String get checkoutAddressTypeDefault => 'Default';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field is required';
  }

  @override
  String get checkoutSaveContinue => 'Save & Continue';

  @override
  String get checkoutYourCartEmpty => 'Your cart is empty';

  @override
  String get checkoutSelectCountry => 'Select Country';

  @override
  String get checkoutSelectState => 'Select State';

  @override
  String get checkoutCountryRequired => 'Country is required';

  @override
  String get checkoutStateRequired => 'State is required';

  @override
  String get checkoutSelectCountryFirst => 'Select country first';

  @override
  String get checkoutShippingMethod => 'Shipping Method';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Save your address to see shipping options';

  @override
  String get checkoutPaymentMethod => 'Payment Method';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Select a shipping method first';

  @override
  String get checkoutEnterCouponCode => 'Enter your coupon code';

  @override
  String get checkoutDiscountCoupon => 'Discount (Coupon)';

  @override
  String get checkoutPlaceOrder => 'Place Order';

  @override
  String get thankYouTitle => 'Thank you for your order!';

  @override
  String get thankYouSubtitle =>
      'We will email you your order details and tracking information';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Your order No. #$orderNumber';
  }

  @override
  String get thankYouViewOrder => 'View Order';

  @override
  String get thankYouContinueShopping => 'Continue Shopping';

  @override
  String get accountPleaseTryAgainLater => 'Please try again later';

  @override
  String get accountUserFallback => 'User';

  @override
  String get accountBack => 'Back';

  @override
  String get accountSettings => 'Settings';

  @override
  String get accountMyOrders => 'My Orders';

  @override
  String get accountMyDownloadableProducts => 'My Downloadable Products';

  @override
  String get accountWishlist => 'Wishlist';

  @override
  String get accountCompareProducts => 'Compare Products';

  @override
  String get accountProductReview => 'Product Review';

  @override
  String get accountAddressBook => 'Address Book';

  @override
  String get accountEditAccount => 'Edit Account';

  @override
  String get accountLogout => 'Logout';

  @override
  String get accountLogoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get accountNoCountriesAvailable =>
      'No countries available. Please try again.';

  @override
  String get accountPleaseSelectCountry => 'Please select a country';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Please select or enter a state';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'Address updated successfully';

  @override
  String get accountAddressAddedSuccessfully => 'Address added successfully';

  @override
  String get accountGoBack => 'Go back';

  @override
  String get accountEditAddress => 'Edit Address';

  @override
  String get accountAddNewAddress => 'Add New Address';

  @override
  String get accountFirstNameRequired => 'First name is required';

  @override
  String get accountLastNameRequired => 'Last name is required';

  @override
  String get accountEnterValidEmail => 'Enter a valid email';

  @override
  String get accountCompanyName => 'Company Name';

  @override
  String get accountVatId => 'VAT id';

  @override
  String get accountStreetAddressRequired => 'Street address is required';

  @override
  String get accountCityRequired => 'City is required';

  @override
  String get accountZipPostcode => 'Zip/Postcode';

  @override
  String get accountZipPostcodeRequired => 'Zip/Postcode is required';

  @override
  String get accountTelephone => 'Telephone';

  @override
  String get accountPhoneNumberRequired => 'Phone number is required';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Change default billing address';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Change default shipping address';

  @override
  String get accountUpdateAddress => 'Update Address';

  @override
  String get accountSaveToAddressBook => 'Save to Address Book';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Please log in to write a review';

  @override
  String get accountPleaseSelectRating => 'Please select a rating';

  @override
  String get accountAddReview => 'Add Review';

  @override
  String get accountReviewSubmitted => 'Review submitted!';

  @override
  String get accountNickName => 'Nick Name';

  @override
  String get accountEnterYourName => 'Enter your name';

  @override
  String get accountNameRequired => 'Name is required';

  @override
  String get accountSummary => 'Summary';

  @override
  String get accountReviewSummaryHint => 'Brief summary of your review';

  @override
  String get accountSummaryRequired => 'Summary is required';

  @override
  String get accountReview => 'Review';

  @override
  String get accountDetailedReviewHint => 'Write your detailed review here';

  @override
  String get accountReviewRequired => 'Review is required';

  @override
  String get accountRating => 'Rating';

  @override
  String get accountSubmitReview => 'Submit Review';

  @override
  String get accountCouldNotLoadAddresses => 'Could not load addresses';

  @override
  String get accountPleaseTryAgain => 'Please try again';

  @override
  String get accountNoAddressesSaved => 'No addresses saved';

  @override
  String get accountAddAddressToGetStarted =>
      'Add a new address to get started';

  @override
  String get accountSelectAddress => 'Select Address';

  @override
  String get accountSetAsDefault => 'Set as Default';

  @override
  String get accountAddressTypeHome => 'Home';

  @override
  String get accountAddressTypeOffice => 'Office';

  @override
  String get accountAddressTypeCustomer => 'Customer';

  @override
  String get accountNoProductsToCompare => 'No Products to Compare';

  @override
  String get accountAddProductsToCompareHint =>
      'Add products to compare from the product detail page.';

  @override
  String get accountProducts => 'Products';

  @override
  String get accountDescription => 'Description';

  @override
  String get accountShortDescription => 'Short Description';

  @override
  String get accountActivity => 'Activity';

  @override
  String get accountSeller => 'Seller';

  @override
  String get accountNotAvailable => 'N/A';

  @override
  String get accountMessageSentSuccessfully => 'Message sent successfully!';

  @override
  String get accountAnErrorOccurred => 'An error occurred';

  @override
  String get accountContactUs => 'Contact Us';

  @override
  String get accountName => 'Name';

  @override
  String get accountEnterYourEmail => 'Enter your email';

  @override
  String get accountContact => 'Contact';

  @override
  String get accountEnterYourPhoneNumber => 'Enter your phone number';

  @override
  String get accountMessage => 'Message';

  @override
  String get accountEnterYourMessage => 'Enter your message';

  @override
  String get accountSendMessage => 'Send Message';

  @override
  String get accountNameFieldEmpty => 'Name field cannot be empty';

  @override
  String get accountNameMinChars => 'Name must be at least 2 characters';

  @override
  String get accountEmailFieldEmpty => 'Email field cannot be empty';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get accountContactNumberEmpty => 'Contact number cannot be empty';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Please enter a valid contact number';

  @override
  String get accountMessageFieldEmpty => 'Message field cannot be empty';

  @override
  String get accountMessageMinChars => 'Message must be at least 10 characters';

  @override
  String get accountDownloadableProducts => 'Downloadable Products';

  @override
  String get accountNoDownloadsYet => 'No Downloads Yet';

  @override
  String get accountDownloadsEmptyDescription =>
      'Your downloaded products will appear here.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total Products';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value left';
  }

  @override
  String get accountDownload => 'Download';

  @override
  String accountFileName(Object fileName) {
    return 'File: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Your download will start shortly. Check your downloads folder.';

  @override
  String get accountClose => 'Close';

  @override
  String get accountOrders => 'Orders';

  @override
  String get accountNoOrdersYet => 'No Orders Yet';

  @override
  String get accountOrdersEmptyDescription =>
      'Your orders will appear here once you make a purchase.';

  @override
  String get accountOrderSingular => 'Order';

  @override
  String get accountOrderPlural => 'Orders';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Items $count)';
  }

  @override
  String get accountOrderAndReturn => 'Order and Return';

  @override
  String get accountTrackOrder => 'Track Order';

  @override
  String get accountReturnPolicy => 'Return Policy';

  @override
  String get accountReturnRequest => 'Return Request';

  @override
  String get accountMyReturns => 'My Returns';

  @override
  String get accountReturns => 'Returns';

  @override
  String get accountReturnSingular => 'Return';

  @override
  String get accountReturnPlural => 'Returns';

  @override
  String get accountNoReturnsYet => 'No Returns Yet';

  @override
  String get accountReturnsEmptyDescription =>
      'Your return requests will appear here.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Return $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Order $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Qty: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Max: $count';
  }

  @override
  String get accountReturnResolution => 'Resolution';

  @override
  String get accountReturnResolutionReturn => 'Return';

  @override
  String get accountReturnResolutionCancel => 'Cancel Items';

  @override
  String get accountReturnReason => 'Reason';

  @override
  String get accountReturnSelectReason => 'Select a reason';

  @override
  String get accountReturnPackageCondition => 'Package Condition';

  @override
  String get accountReturnPackageConditionHint =>
      'e.g. opened, sealed, damaged box';

  @override
  String get accountReturnAdditionalInfo => 'Additional Information';

  @override
  String get accountReturnAdditionalInfoHint => 'Describe the issue (optional)';

  @override
  String get accountReturnAgreement => 'I agree with the return policy terms';

  @override
  String get accountReturnAgreementRequired =>
      'Please accept the return policy terms';

  @override
  String get accountReturnSubmit => 'Submit Request';

  @override
  String get accountReturnCreatedTitle => 'Request Submitted';

  @override
  String get accountReturnCreatedMessage =>
      'Your return request has been submitted successfully.';

  @override
  String get accountReturnSelectItem => 'Select Item';

  @override
  String get accountReturnNoReturnableItems => 'No Returnable Items';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'This order has no items eligible for return or cancellation.';

  @override
  String get accountReturnViewAction => 'View';

  @override
  String get accountReturnCancelAction => 'Cancel Request';

  @override
  String get accountReturnCloseAction => 'Mark as Solved';

  @override
  String get accountReturnReopenAction => 'Reopen Request';

  @override
  String get accountReturnCancelConfirmation =>
      'Are you sure you want to cancel this return request?';

  @override
  String get accountReturnCloseConfirmation =>
      'Mark this return request as solved?';

  @override
  String get accountReturnMessages => 'Messages';

  @override
  String get accountReturnNoMessages => 'No messages yet.';

  @override
  String get accountReturnMessageHint => 'Write a message…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Return status updated to $status';
  }

  @override
  String get accountReturnExpired => 'Return window expired';

  @override
  String get accountReturnInformation => 'Information';

  @override
  String get accountReturnSelectOrder => 'Select an order';

  @override
  String get accountReturnChangeOrder => 'Change';

  @override
  String get accountReturnChooseAnotherOrder => 'Choose another order';

  @override
  String get accountNotifications => 'Notifications';

  @override
  String get accountPrivacy => 'Privacy';

  @override
  String get accountAccount => 'Account';

  @override
  String get accountPreferences => 'Preferences';

  @override
  String get accountLanguage => 'Language';

  @override
  String get accountNoLanguagesAvailable => 'No languages available';

  @override
  String get accountCurrency => 'Currency';

  @override
  String get accountOthers => 'Others';

  @override
  String get accountNoPagesAvailable => 'No pages available';

  @override
  String get accountProductReviews => 'Product Reviews';

  @override
  String get accountMyReviews => 'My Reviews';

  @override
  String get accountNoReviewsYet => 'No Reviews Yet';

  @override
  String get accountReviewsEmptyDescription =>
      'Your product reviews will appear here.';

  @override
  String get accountReviewSingular => 'Review';

  @override
  String get accountReviewPlural => 'Reviews';

  @override
  String accountPostedOn(Object date) {
    return 'Posted on $date';
  }

  @override
  String get accountCloseSettings => 'Close settings';

  @override
  String get accountChangeTheme => 'Change Theme';

  @override
  String get accountAllNotifications => 'All Notifications';

  @override
  String get accountOffers => 'Offers';

  @override
  String get accountOfflineData => 'Offline Data';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Track and Show Recently viewed products';

  @override
  String get accountShowSearchTag => 'Show Search Tag';

  @override
  String get accountTryAgain => 'Try Again';

  @override
  String get accountYourWishlistEmpty => 'Your wishlist is empty';

  @override
  String get accountWishlistEmptyDescription =>
      'Browse products and add them to your wishlist';

  @override
  String get accountItemSingular => 'Item';

  @override
  String get accountItemPlural => 'Items';

  @override
  String accountStartingAt(Object price) {
    return 'Starting at $price';
  }

  @override
  String get accountAboutThisPage => 'About this page';

  @override
  String accountPageId(Object id) {
    return 'Page ID: $id';
  }

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabCategories => 'Categories';

  @override
  String get mainTabCart => 'Cart';

  @override
  String get mainTabAccount => 'Account';

  @override
  String get authLoginSuccess => 'Welcome! Successfully logged in.';

  @override
  String get authWelcomeBack => 'Welcome back!';

  @override
  String get authLoginToAccount => 'Login to your account';

  @override
  String get authEmailAddress => 'Email Address';

  @override
  String get authEnterYourEmail => 'Enter your email';

  @override
  String get authPleaseEnterEmail => 'Please enter your email';

  @override
  String get authPleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get authPassword => 'Password';

  @override
  String get authEnterYourPassword => 'Enter your password';

  @override
  String get authPleaseEnterPassword => 'Please enter your password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authForgotPasswordTitle => 'Forgot Password?';

  @override
  String get authLogin => 'Login';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authAccountCreatedSuccess => 'Account created successfully!';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignupGetStarted => 'Sign up to get started';

  @override
  String get authFirstNameHint => 'First name';

  @override
  String get authLastNameHint => 'Last name';

  @override
  String get authRequired => 'Required';

  @override
  String get authCreatePasswordHint => 'Create a password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Confirm your password';

  @override
  String get authPleaseConfirmPassword => 'Please confirm your password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authAlreadyHaveAccountPrompt => 'Already have an account? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get authNiceToSeeYouHere => 'Nice to see you here';

  @override
  String get accountEditTitle => 'Account Edit';

  @override
  String get accountFirstNameRequiredLabel => 'First Name *';

  @override
  String get accountLastNameRequiredLabel => 'Last Name *';

  @override
  String get accountChangeEmail => 'Change Email';

  @override
  String get accountChangePassword => 'Change Password';

  @override
  String get accountDeleteAccount => 'Delete Account';

  @override
  String get accountGender => 'Gender';

  @override
  String get accountSelectGender => 'Select Gender';

  @override
  String get accountDob => 'DOB';

  @override
  String get monthJanShort => 'Jan';

  @override
  String get monthFebShort => 'Feb';

  @override
  String get monthMarShort => 'Mar';

  @override
  String get monthAprShort => 'Apr';

  @override
  String get monthMayShort => 'May';

  @override
  String get monthJunShort => 'Jun';

  @override
  String get monthJulShort => 'Jul';

  @override
  String get monthAugShort => 'Aug';

  @override
  String get monthSepShort => 'Sep';

  @override
  String get monthOctShort => 'Oct';

  @override
  String get monthNovShort => 'Nov';

  @override
  String get monthDecShort => 'Dec';

  @override
  String get accountSubscribeNewsletters => 'Subscribe Newsletters';

  @override
  String get accountSaveProfile => 'Save Profile';

  @override
  String get accountNewEmail => 'New Email';

  @override
  String get accountEmailRequired => 'Email is required';

  @override
  String get accountCurrentPassword => 'Current Password';

  @override
  String get accountPasswordRequired => 'Password is required';

  @override
  String get accountChange => 'Change';

  @override
  String get accountCurrentPasswordRequired => 'Current password is required';

  @override
  String get accountNewPassword => 'New Password';

  @override
  String get accountConfirmPassword => 'Confirm Password';

  @override
  String get accountDeleteWarning =>
      'This action is permanent and cannot be undone. All your data will be deleted.';

  @override
  String get accountEnterYourPassword => 'Enter your password';

  @override
  String get accountDelete => 'Delete';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Male';

  @override
  String get accountGenderFemale => 'Female';

  @override
  String get accountGenderOther => 'Other';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Orders $number';
  }

  @override
  String get accountReorderSuccessful => 'Reorder Successful';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count items added to your cart.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Go to Cart';

  @override
  String get accountFailedToLoadOrderDetails => 'Failed to load order details';

  @override
  String get accountDetails => 'Details';

  @override
  String get accountInvoices => 'Invoices';

  @override
  String get accountShipments => 'Shipments';

  @override
  String accountPlacedOn(Object date) {
    return 'Placed on $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count Item(s) Ordered';
  }

  @override
  String get accountBillingAddress => 'Billing Address';

  @override
  String get accountShippingAddress => 'Shipping Address';

  @override
  String get accountShippingMethod => 'Shipping Method';

  @override
  String get accountPaymentMethod => 'Payment Method';

  @override
  String get accountNoInvoicesForOrder => 'No invoices for this order';

  @override
  String accountInvoicedCount(int count) {
    return '$count Invoiced';
  }

  @override
  String get accountNoShipmentsForOrder => 'No shipments for this order';

  @override
  String get accountReorder => 'Reorder';

  @override
  String get accountCancelOrder => 'Cancel Order';

  @override
  String get accountCancelOrderConfirmation =>
      'Are you sure you want to cancel this order? This cannot be undone.';

  @override
  String get accountMoreInfo => 'More info';

  @override
  String get accountOrderedQty => 'Ordered Qty';

  @override
  String get accountShipped => 'Shipped';

  @override
  String get accountInvoiced => 'Invoiced';

  @override
  String get accountUnitPrice => 'Unit Price';

  @override
  String get accountSubTotalWithSpace => 'Sub Total';

  @override
  String get accountTotalPaid => 'Total Paid';

  @override
  String get accountTotalRefunded => 'Total Refunded';

  @override
  String get accountTotalDue => 'Total Due';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Invoice $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Shipment $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Failed to load invoice details';

  @override
  String get accountInvoiceStatus => 'Invoice Status';

  @override
  String get accountInvoiceDate => 'Invoice Date';

  @override
  String get accountOrderId => 'Order ID';

  @override
  String get accountOrderDate => 'Order Date';

  @override
  String get accountOrderStatus => 'Order Status';

  @override
  String get accountChannel => 'Channel';

  @override
  String get accountDefault => 'Default';

  @override
  String get accountStatusPaid => 'Paid';

  @override
  String get accountStatusPending => 'Pending';

  @override
  String get accountStatusPendingPayment => 'Pending Payment';

  @override
  String get accountStatusOverdue => 'Overdue';

  @override
  String get accountStatusRefunded => 'Refunded';

  @override
  String get accountShippedQty => 'Shipped Qty';

  @override
  String get accountInvoicedQty => 'Invoiced Qty';

  @override
  String get accountUnitPriceWithColon => 'Unit Price:';

  @override
  String get accountSubTotalWithColon => 'Sub Total:';

  @override
  String get accountDownloadInvoice => 'Download Invoice';

  @override
  String get accountInvoice => 'Invoice';

  @override
  String get accountRecentOrders => 'Recent Orders';

  @override
  String get accountNoRecentOrders => 'No recent orders';

  @override
  String get accountStatusProcessing => 'Processing';

  @override
  String get accountStatusCompleted => 'Completed';

  @override
  String get accountStatusCancelled => 'Cancelled';

  @override
  String get accountStatusClosed => 'Closed';

  @override
  String get accountStatusUnknown => 'Unknown';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Wishlist Items ($count)';
  }

  @override
  String get accountNoWishlistItems => 'No wishlist items';

  @override
  String get accountDefaultAddresses => 'Default Addresses';

  @override
  String get accountNoProductReviewsYet => 'No product reviews yet';

  @override
  String get searchFailedTitle => 'Search failed';

  @override
  String get searchHint => 'Search products';

  @override
  String get searchImageSearch => 'Image Search';

  @override
  String get searchRecentSearches => 'Recent Searches';

  @override
  String get searchClearAll => 'Clear All';

  @override
  String get searchTopCategories => 'Top Categories';

  @override
  String searchResultsFound(int count) {
    return '$count results found';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% off';
  }

  @override
  String get searchNoProductsFound => 'No products found';

  @override
  String get searchTryDifferentTerm => 'Try searching with a different term';

  @override
  String get searchSpeechNotAvailable => 'Speech recognition is not available';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Failed to start voice input: $error';
  }

  @override
  String get searchMicrophonePermissionDenied => 'Microphone permission denied';

  @override
  String get searchRetake => 'Retake';

  @override
  String get searchSearch => 'Search';

  @override
  String get searchTryAgain => 'Try Again';

  @override
  String get searchRecognizedObjects => 'Recognized Objects';

  @override
  String get searchResult => 'Result:';

  @override
  String get searchFailedToCaptureImage => 'Failed to capture image';

  @override
  String searchProcessing(int progress) {
    return 'Processing... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Opening camera...';

  @override
  String get searchFailedToProcessImage => 'Failed to process image';

  @override
  String get homeRecentlyViewedProducts => 'Recently Viewed Products';

  @override
  String accountItemsCount(int count) {
    return '$count Item(s)';
  }

  @override
  String get accountTrack => 'Track';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Tracking $trackNumber via $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Unknown carrier';

  @override
  String get accountTrackingNumber => 'Tracking Number';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Shipped Qty : $qty';
  }
}
