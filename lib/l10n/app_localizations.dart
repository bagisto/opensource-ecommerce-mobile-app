import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bagisto Store'**
  String get appTitle;

  /// No description provided for @homeFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load homepage'**
  String get homeFailedToLoad;

  /// No description provided for @commonUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get commonUnknownError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @sellerProfileCountriesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Country and state options could not be loaded.'**
  String get sellerProfileCountriesUnavailable;

  /// No description provided for @commonTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to respond. Please check your connection and try again.'**
  String get commonTimeoutError;

  /// No description provided for @commonUnableToReachServer.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Please check your internet connection and try again.'**
  String get commonUnableToReachServer;

  /// No description provided for @commonNetworkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please check your internet connection and try again.'**
  String get commonNetworkError;

  /// No description provided for @commonProcessingError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while processing the data. Please try again later.'**
  String get commonProcessingError;

  /// No description provided for @commonMissingInformation.
  ///
  /// In en, this message translates to:
  /// **'Some required information is missing. Please fill in all required fields and try again.'**
  String get commonMissingInformation;

  /// No description provided for @commonTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get commonTooManyRequests;

  /// No description provided for @commonServerError.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an error. Please try again later.'**
  String get commonServerError;

  /// No description provided for @commonPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action.'**
  String get commonPermissionDenied;

  /// No description provided for @commonSecureConnectionError.
  ///
  /// In en, this message translates to:
  /// **'A secure connection could not be established. Please try again later.'**
  String get commonSecureConnectionError;

  /// No description provided for @commonCartSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your cart session has expired. Please try again.'**
  String get commonCartSessionExpired;

  /// No description provided for @commonGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonGenericError;

  /// No description provided for @commonGenericErrorWithContext.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while {context}. Please try again.'**
  String commonGenericErrorWithContext(Object context);

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password you entered is incorrect. Please try again.'**
  String get authInvalidCredentials;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get authSessionExpired;

  /// No description provided for @authSessionInvalid.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid. Please log in again.'**
  String get authSessionInvalid;

  /// No description provided for @homeFeaturedProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get homeFeaturedProducts;

  /// No description provided for @homeDefaultProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get homeDefaultProducts;

  /// No description provided for @homeBackToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to Top'**
  String get homeBackToTop;

  /// No description provided for @homeViewCart.
  ///
  /// In en, this message translates to:
  /// **'VIEW CART'**
  String get homeViewCart;

  /// No description provided for @homeAddedToCartMessage.
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart'**
  String homeAddedToCartMessage(Object productName);

  /// No description provided for @homeLoginToManageWishlist.
  ///
  /// In en, this message translates to:
  /// **'Please login to manage wishlist'**
  String get homeLoginToManageWishlist;

  /// No description provided for @homeAddedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to wishlist'**
  String get homeAddedToWishlist;

  /// No description provided for @homeRemovedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get homeRemovedFromWishlist;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get homeCollections;

  /// No description provided for @homeCategorySemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} category'**
  String homeCategorySemanticLabel(Object categoryName);

  /// No description provided for @homeDiscountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String homeDiscountOff(Object percent);

  /// No description provided for @productFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get productFailedToLoad;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @productDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetail;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDetails;

  /// No description provided for @productShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get productShowLess;

  /// No description provided for @productLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get productLoadMore;

  /// No description provided for @productMoreInformations.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get productMoreInformations;

  /// No description provided for @productSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get productSku;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get productType;

  /// No description provided for @productBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get productBrand;

  /// No description provided for @productColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get productColor;

  /// No description provided for @productSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get productSize;

  /// No description provided for @productReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get productReviews;

  /// No description provided for @productNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get productNoReviewsYet;

  /// No description provided for @productRating.
  ///
  /// In en, this message translates to:
  /// **'{count} Rating'**
  String productRating(Object count);

  /// No description provided for @productReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Reviews'**
  String productReviewsCount(Object count);

  /// No description provided for @productPostedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted on {day} {month} {year}'**
  String productPostedOn(Object day, Object month, Object year);

  /// No description provided for @productReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your review has been submitted!'**
  String get productReviewSubmitted;

  /// No description provided for @productWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get productWriteReview;

  /// No description provided for @productPleaseLoginForReviews.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your reviews'**
  String get productPleaseLoginForReviews;

  /// No description provided for @productLoadMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'Load More Reviews'**
  String get productLoadMoreReviews;

  /// No description provided for @productRelatedProduct.
  ///
  /// In en, this message translates to:
  /// **'Related Products'**
  String get productRelatedProduct;

  /// No description provided for @productUpsellRecommendation.
  ///
  /// In en, this message translates to:
  /// **'We found other products you might like!'**
  String get productUpsellRecommendation;

  /// No description provided for @productDiscountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String productDiscountOff(Object percent);

  /// No description provided for @productVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get productVeryGood;

  /// No description provided for @productGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get productGood;

  /// No description provided for @productAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get productAverage;

  /// No description provided for @productBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get productBad;

  /// No description provided for @productVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get productVeryBad;

  /// No description provided for @productInStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get productInStock;

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get productOutOfStock;

  /// No description provided for @productQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get productQuantity;

  /// No description provided for @productWishlistAction.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get productWishlistAction;

  /// No description provided for @productCompareAction.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get productCompareAction;

  /// No description provided for @productShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get productShareAction;

  /// No description provided for @productLoginToCompare.
  ///
  /// In en, this message translates to:
  /// **'Please login to add to compare'**
  String get productLoginToCompare;

  /// No description provided for @productAddedToCompare.
  ///
  /// In en, this message translates to:
  /// **'Added to compare'**
  String get productAddedToCompare;

  /// No description provided for @productAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get productAddToCart;

  /// No description provided for @accountMoveToCart.
  ///
  /// In en, this message translates to:
  /// **'Move to Cart'**
  String get accountMoveToCart;

  /// No description provided for @productBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get productBuyNow;

  /// No description provided for @productSelectOptionsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select product options first'**
  String get productSelectOptionsFirst;

  /// No description provided for @productBookingBookTable.
  ///
  /// In en, this message translates to:
  /// **'Book a Table *'**
  String get productBookingBookTable;

  /// No description provided for @productBookingSelectDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Select date *'**
  String get productBookingSelectDateRequired;

  /// No description provided for @productBookingSelectSlotRequired.
  ///
  /// In en, this message translates to:
  /// **'Select slot *'**
  String get productBookingSelectSlotRequired;

  /// No description provided for @productBookingSpecialRequestNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Special Request/Notes *'**
  String get productBookingSpecialRequestNotesRequired;

  /// No description provided for @productBookingBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book an Appointment *'**
  String get productBookingBookAppointment;

  /// No description provided for @productBookingDateFormatHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get productBookingDateFormatHint;

  /// No description provided for @productBookingFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get productBookingFrom;

  /// No description provided for @productBookingTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get productBookingTo;

  /// No description provided for @productBookingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get productBookingSelectDate;

  /// No description provided for @productBookingLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get productBookingLocation;

  /// No description provided for @productBookingSlotDuration.
  ///
  /// In en, this message translates to:
  /// **'Slot Duration'**
  String get productBookingSlotDuration;

  /// No description provided for @productBookingAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get productBookingAvailability;

  /// No description provided for @productBookingStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get productBookingStartDate;

  /// No description provided for @productBookingEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get productBookingEndDate;

  /// No description provided for @productBookingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get productBookingDate;

  /// No description provided for @productBookingViewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get productBookingViewOnMap;

  /// No description provided for @productBookingEventOn.
  ///
  /// In en, this message translates to:
  /// **'Event on :'**
  String get productBookingEventOn;

  /// No description provided for @productBookingBookYourTicket.
  ///
  /// In en, this message translates to:
  /// **'Book Your Ticket'**
  String get productBookingBookYourTicket;

  /// No description provided for @productBookingSlotDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Slot Duration :'**
  String get productBookingSlotDurationLabel;

  /// No description provided for @productBookingDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} Minutes'**
  String productBookingDurationMinutes(int count);

  /// No description provided for @productBookingAvailableFrom.
  ///
  /// In en, this message translates to:
  /// **'Available From'**
  String get productBookingAvailableFrom;

  /// No description provided for @productBookingAvailableTo.
  ///
  /// In en, this message translates to:
  /// **'Available To'**
  String get productBookingAvailableTo;

  /// No description provided for @productBookingSpecialRequestNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Special Request/Notes'**
  String get productBookingSpecialRequestNotesHint;

  /// No description provided for @productBookingChooseRentOption.
  ///
  /// In en, this message translates to:
  /// **'Choose Rent Option *'**
  String get productBookingChooseRentOption;

  /// No description provided for @productBookingDailyBasis.
  ///
  /// In en, this message translates to:
  /// **'Daily Basis'**
  String get productBookingDailyBasis;

  /// No description provided for @productBookingHourlyBasis.
  ///
  /// In en, this message translates to:
  /// **'Hourly Basis'**
  String get productBookingHourlyBasis;

  /// No description provided for @productBookingNoDatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No dates available for booking'**
  String get productBookingNoDatesAvailable;

  /// No description provided for @productBookingSelectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Slot'**
  String get productBookingSelectSlot;

  /// No description provided for @productBookingSelectDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Select date first'**
  String get productBookingSelectDateFirst;

  /// No description provided for @productBookingChooseDateFirstToSeeSlots.
  ///
  /// In en, this message translates to:
  /// **'Choose a date first to see available slots.'**
  String get productBookingChooseDateFirstToSeeSlots;

  /// No description provided for @productBookingLoadingSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading slots...'**
  String get productBookingLoadingSlots;

  /// No description provided for @productBookingSlotsLoadingForSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'Available slots are loading for the selected date.'**
  String get productBookingSlotsLoadingForSelectedDate;

  /// No description provided for @productBookingUnableToLoadSlots.
  ///
  /// In en, this message translates to:
  /// **'Unable to load slots'**
  String get productBookingUnableToLoadSlots;

  /// No description provided for @productBookingNoSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available'**
  String get productBookingNoSlotsAvailable;

  /// No description provided for @productBookingNoSlotsAvailableForSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'No slots are available for the selected date.'**
  String get productBookingNoSlotsAvailableForSelectedDate;

  /// No description provided for @productBookingSelectOneSlotToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select one available slot to continue.'**
  String get productBookingSelectOneSlotToContinue;

  /// No description provided for @productBookingSpecialRequestNotesLowercase.
  ///
  /// In en, this message translates to:
  /// **'Special request notes'**
  String get productBookingSpecialRequestNotesLowercase;

  /// No description provided for @productDownloadableLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get productDownloadableLinks;

  /// No description provided for @productDownloadableSamples.
  ///
  /// In en, this message translates to:
  /// **'Samples'**
  String get productDownloadableSamples;

  /// No description provided for @productDownloadSample.
  ///
  /// In en, this message translates to:
  /// **'Download Sample'**
  String get productDownloadSample;

  /// No description provided for @productDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productDefaultName;

  /// No description provided for @categoryDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoryDefaultName;

  /// No description provided for @categorySubCategories.
  ///
  /// In en, this message translates to:
  /// **'Sub Categories'**
  String get categorySubCategories;

  /// No description provided for @categorySomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get categorySomethingWentWrong;

  /// No description provided for @categoryUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get categoryUnknownError;

  /// No description provided for @categoryItemsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} Items Found'**
  String categoryItemsFound(Object count);

  /// No description provided for @categoryNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get categoryNoProductsFound;

  /// No description provided for @categoryNoCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get categoryNoCategoriesFound;

  /// No description provided for @categorySort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get categorySort;

  /// No description provided for @categorySortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get categorySortByTitle;

  /// No description provided for @categorySortAZ.
  ///
  /// In en, this message translates to:
  /// **'From A-Z'**
  String get categorySortAZ;

  /// No description provided for @categorySortZA.
  ///
  /// In en, this message translates to:
  /// **'From Z-A'**
  String get categorySortZA;

  /// No description provided for @categorySortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get categorySortNewest;

  /// No description provided for @categorySortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get categorySortOldest;

  /// No description provided for @categorySortCheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest First'**
  String get categorySortCheapest;

  /// No description provided for @categorySortExpensive.
  ///
  /// In en, this message translates to:
  /// **'Expensive First'**
  String get categorySortExpensive;

  /// No description provided for @categoryFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get categoryFilter;

  /// No description provided for @categoryFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get categoryFilters;

  /// No description provided for @categoryNoFiltersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No filters available'**
  String get categoryNoFiltersAvailable;

  /// No description provided for @categoryFiltersWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Filters will appear when available for this category'**
  String get categoryFiltersWillAppear;

  /// No description provided for @categoryApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get categoryApplyFilters;

  /// No description provided for @categoryApplyFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters ({count})'**
  String categoryApplyFiltersCount(int count);

  /// No description provided for @categoryClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get categoryClearAll;

  /// No description provided for @categoryTryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search criteria'**
  String get categoryTryAdjustingFilters;

  /// No description provided for @categoryError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get categoryError;

  /// No description provided for @categoryLoginToManageWishlist.
  ///
  /// In en, this message translates to:
  /// **'Please login to manage wishlist'**
  String get categoryLoginToManageWishlist;

  /// No description provided for @categoryAddedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to wishlist'**
  String get categoryAddedToWishlist;

  /// No description provided for @categoryRemovedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get categoryRemovedFromWishlist;

  /// No description provided for @categoryFailedToUpdateWishlist.
  ///
  /// In en, this message translates to:
  /// **'Failed to update wishlist: {error}'**
  String categoryFailedToUpdateWishlist(Object error);

  /// No description provided for @wishlistItemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed from wishlist'**
  String get wishlistItemRemoved;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cartPleaseLoginWishlist.
  ///
  /// In en, this message translates to:
  /// **'Please login to view wishlist'**
  String get cartPleaseLoginWishlist;

  /// No description provided for @cartItemsInCart.
  ///
  /// In en, this message translates to:
  /// **'{count} {itemText} in the Cart'**
  String cartItemsInCart(int count, Object itemText);

  /// No description provided for @cartYourCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartYourCartEmpty;

  /// No description provided for @cartAddProductsHere.
  ///
  /// In en, this message translates to:
  /// **'Add products to your cart to see them here'**
  String get cartAddProductsHere;

  /// No description provided for @cartContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get cartContinueShopping;

  /// No description provided for @cartUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get cartUnit;

  /// No description provided for @cartUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get cartUnits;

  /// No description provided for @cartPleaseLoginWishlistAdd.
  ///
  /// In en, this message translates to:
  /// **'Please login to add to wishlist'**
  String get cartPleaseLoginWishlistAdd;

  /// No description provided for @cartMovedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Moved to wishlist'**
  String get cartMovedToWishlist;

  /// No description provided for @cartFailedMoveWishlist.
  ///
  /// In en, this message translates to:
  /// **'Failed to move to wishlist: {error}'**
  String cartFailedMoveWishlist(Object error);

  /// No description provided for @cartAddedToCartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart successfully'**
  String get cartAddedToCartSuccess;

  /// No description provided for @productSelectDownloadLink.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one link'**
  String get productSelectDownloadLink;

  /// No description provided for @cartViewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get cartViewMore;

  /// No description provided for @cartViewLess.
  ///
  /// In en, this message translates to:
  /// **'View Less'**
  String get cartViewLess;

  /// No description provided for @cartEmptyCartAction.
  ///
  /// In en, this message translates to:
  /// **'Empty Cart'**
  String get cartEmptyCartAction;

  /// No description provided for @cartApplyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get cartApplyCoupon;

  /// No description provided for @cartCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get cartCouponCode;

  /// No description provided for @cartCouponNotFound.
  ///
  /// In en, this message translates to:
  /// **'Coupon not found'**
  String get cartCouponNotFound;

  /// No description provided for @cartApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartApply;

  /// No description provided for @cartAppliedCoupon.
  ///
  /// In en, this message translates to:
  /// **'Applied Coupon'**
  String get cartAppliedCoupon;

  /// No description provided for @cartRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemove;

  /// No description provided for @cartPriceBreak.
  ///
  /// In en, this message translates to:
  /// **'Price Break'**
  String get cartPriceBreak;

  /// No description provided for @cartSubTotal.
  ///
  /// In en, this message translates to:
  /// **'SubTotal'**
  String get cartSubTotal;

  /// No description provided for @cartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscount;

  /// No description provided for @cartDeliveryCharges.
  ///
  /// In en, this message translates to:
  /// **'Delivery Charges'**
  String get cartDeliveryCharges;

  /// No description provided for @cartTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get cartTax;

  /// No description provided for @cartTaxIncluded.
  ///
  /// In en, this message translates to:
  /// **'(included)'**
  String get cartTaxIncluded;

  /// No description provided for @cartExclTax.
  ///
  /// In en, this message translates to:
  /// **'Excl. Tax: {amount}'**
  String cartExclTax(String amount);

  /// No description provided for @cartGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get cartGrandTotal;

  /// No description provided for @cartAmountToBePaid.
  ///
  /// In en, this message translates to:
  /// **'Amount to be Paid'**
  String get cartAmountToBePaid;

  /// No description provided for @cartPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get cartPayNow;

  /// No description provided for @cartRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get cartRemoveItem;

  /// No description provided for @cartRemoveItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{productName}\" from your cart?'**
  String cartRemoveItemConfirm(Object productName);

  /// No description provided for @cartCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cartCancel;

  /// No description provided for @cartEmptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Empty Cart'**
  String get cartEmptyCartTitle;

  /// No description provided for @cartEmptyCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from your cart?'**
  String get cartEmptyCartConfirm;

  /// No description provided for @cartEstimateShippingAndTax.
  ///
  /// In en, this message translates to:
  /// **'Estimate Shipping and Tax'**
  String get cartEstimateShippingAndTax;

  /// No description provided for @cartEstimateShippingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your destination to get a shipping and tax estimate.'**
  String get cartEstimateShippingPrompt;

  /// No description provided for @cartEstimateCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get cartEstimateCountry;

  /// No description provided for @cartEstimateState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get cartEstimateState;

  /// No description provided for @cartEstimateZip.
  ///
  /// In en, this message translates to:
  /// **'Zip/Postcode'**
  String get cartEstimateZip;

  /// No description provided for @cartEstimateSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get cartEstimateSelectCountry;

  /// No description provided for @cartEstimateSelectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get cartEstimateSelectState;

  /// No description provided for @cartEstimateButton.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get cartEstimateButton;

  /// No description provided for @cartEstimateNoMethods.
  ///
  /// In en, this message translates to:
  /// **'No shipping methods available for this destination.'**
  String get cartEstimateNoMethods;

  /// No description provided for @cartMoreChoices.
  ///
  /// In en, this message translates to:
  /// **'More Choices'**
  String get cartMoreChoices;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @checkoutBillingTo.
  ///
  /// In en, this message translates to:
  /// **'Billing to'**
  String get checkoutBillingTo;

  /// No description provided for @checkoutDeliveredTo.
  ///
  /// In en, this message translates to:
  /// **'Delivered to'**
  String get checkoutDeliveredTo;

  /// No description provided for @checkoutChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get checkoutChange;

  /// No description provided for @checkoutSelectBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Billing Address'**
  String get checkoutSelectBillingAddress;

  /// No description provided for @checkoutSelectShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Shipping Address'**
  String get checkoutSelectShippingAddress;

  /// No description provided for @checkoutBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get checkoutBillingAddress;

  /// No description provided for @checkoutEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get checkoutEnterAddress;

  /// No description provided for @checkoutFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get checkoutFirstName;

  /// No description provided for @checkoutLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get checkoutLastName;

  /// No description provided for @checkoutEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get checkoutEmail;

  /// No description provided for @checkoutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get checkoutPhone;

  /// No description provided for @checkoutStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get checkoutStreetAddress;

  /// No description provided for @checkoutCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get checkoutCountry;

  /// No description provided for @checkoutState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get checkoutState;

  /// No description provided for @checkoutCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutCity;

  /// No description provided for @checkoutPostcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get checkoutPostcode;

  /// No description provided for @checkoutCompanyOptional.
  ///
  /// In en, this message translates to:
  /// **'Company (Optional)'**
  String get checkoutCompanyOptional;

  /// No description provided for @checkoutUseSameAddressShipping.
  ///
  /// In en, this message translates to:
  /// **'Use same address for shipping?'**
  String get checkoutUseSameAddressShipping;

  /// No description provided for @checkoutPhoneValue.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String checkoutPhoneValue(Object phone);

  /// No description provided for @checkoutAddressTypeOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get checkoutAddressTypeOffice;

  /// No description provided for @checkoutAddressTypeHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get checkoutAddressTypeHome;

  /// No description provided for @checkoutAddressTypeBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get checkoutAddressTypeBilling;

  /// No description provided for @checkoutAddressTypeShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkoutAddressTypeShipping;

  /// No description provided for @checkoutAddressTypeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get checkoutAddressTypeDefault;

  /// No description provided for @checkoutFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String checkoutFieldRequired(Object field);

  /// No description provided for @checkoutSaveContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get checkoutSaveContinue;

  /// No description provided for @checkoutYourCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get checkoutYourCartEmpty;

  /// No description provided for @checkoutSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get checkoutSelectCountry;

  /// No description provided for @checkoutSelectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get checkoutSelectState;

  /// No description provided for @checkoutCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get checkoutCountryRequired;

  /// No description provided for @checkoutStateRequired.
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get checkoutStateRequired;

  /// No description provided for @checkoutSelectCountryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select country first'**
  String get checkoutSelectCountryFirst;

  /// No description provided for @checkoutShippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Shipping Method'**
  String get checkoutShippingMethod;

  /// No description provided for @checkoutSaveAddressSeeShipping.
  ///
  /// In en, this message translates to:
  /// **'Save your address to see shipping options'**
  String get checkoutSaveAddressSeeShipping;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutSelectShippingMethodFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a shipping method first'**
  String get checkoutSelectShippingMethodFirst;

  /// No description provided for @checkoutEnterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your coupon code'**
  String get checkoutEnterCouponCode;

  /// No description provided for @checkoutDiscountCoupon.
  ///
  /// In en, this message translates to:
  /// **'Discount (Coupon)'**
  String get checkoutDiscountCoupon;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get checkoutPlaceOrder;

  /// No description provided for @thankYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order!'**
  String get thankYouTitle;

  /// No description provided for @thankYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will email you your order details and tracking information'**
  String get thankYouSubtitle;

  /// No description provided for @thankYouOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Your order No. {orderNumber}'**
  String thankYouOrderNumber(Object orderNumber);

  /// No description provided for @thankYouViewOrder.
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get thankYouViewOrder;

  /// No description provided for @thankYouContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get thankYouContinueShopping;

  /// No description provided for @accountPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get accountPleaseTryAgainLater;

  /// No description provided for @accountUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get accountUserFallback;

  /// No description provided for @accountBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get accountBack;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountSettings;

  /// No description provided for @accountMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get accountMyOrders;

  /// No description provided for @accountMyDownloadableProducts.
  ///
  /// In en, this message translates to:
  /// **'My Downloadable Products'**
  String get accountMyDownloadableProducts;

  /// No description provided for @accountWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get accountWishlist;

  /// No description provided for @accountCompareProducts.
  ///
  /// In en, this message translates to:
  /// **'Compare Products'**
  String get accountCompareProducts;

  /// No description provided for @accountProductReview.
  ///
  /// In en, this message translates to:
  /// **'Product Review'**
  String get accountProductReview;

  /// No description provided for @accountAddressBook.
  ///
  /// In en, this message translates to:
  /// **'Address Book'**
  String get accountAddressBook;

  /// No description provided for @accountEditAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get accountEditAccount;

  /// No description provided for @accountLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get accountLogout;

  /// No description provided for @accountLogoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get accountLogoutConfirmation;

  /// No description provided for @accountNoCountriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No countries available. Please try again.'**
  String get accountNoCountriesAvailable;

  /// No description provided for @accountPleaseSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Please select a country'**
  String get accountPleaseSelectCountry;

  /// No description provided for @accountPleaseSelectOrEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please select or enter a state'**
  String get accountPleaseSelectOrEnterState;

  /// No description provided for @accountAddressUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get accountAddressUpdatedSuccessfully;

  /// No description provided for @accountAddressAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get accountAddressAddedSuccessfully;

  /// No description provided for @accountGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get accountGoBack;

  /// No description provided for @accountEditAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get accountEditAddress;

  /// No description provided for @accountAddNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get accountAddNewAddress;

  /// No description provided for @accountFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get accountFirstNameRequired;

  /// No description provided for @accountLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get accountLastNameRequired;

  /// No description provided for @accountEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get accountEnterValidEmail;

  /// No description provided for @accountCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get accountCompanyName;

  /// No description provided for @accountVatId.
  ///
  /// In en, this message translates to:
  /// **'VAT id'**
  String get accountVatId;

  /// No description provided for @accountStreetAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get accountStreetAddressRequired;

  /// No description provided for @accountCityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get accountCityRequired;

  /// No description provided for @accountZipPostcode.
  ///
  /// In en, this message translates to:
  /// **'Zip/Postcode'**
  String get accountZipPostcode;

  /// No description provided for @accountZipPostcodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Zip/Postcode is required'**
  String get accountZipPostcodeRequired;

  /// No description provided for @accountTelephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get accountTelephone;

  /// No description provided for @accountPhoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get accountPhoneNumberRequired;

  /// No description provided for @accountChangeDefaultBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Change default billing address'**
  String get accountChangeDefaultBillingAddress;

  /// No description provided for @accountChangeDefaultShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Change default shipping address'**
  String get accountChangeDefaultShippingAddress;

  /// No description provided for @accountUpdateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get accountUpdateAddress;

  /// No description provided for @accountSaveToAddressBook.
  ///
  /// In en, this message translates to:
  /// **'Save to Address Book'**
  String get accountSaveToAddressBook;

  /// No description provided for @accountPleaseLoginToWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Please log in to write a review'**
  String get accountPleaseLoginToWriteReview;

  /// No description provided for @accountPleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get accountPleaseSelectRating;

  /// No description provided for @accountAddReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get accountAddReview;

  /// No description provided for @accountReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted!'**
  String get accountReviewSubmitted;

  /// No description provided for @accountNickName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountNickName;

  /// No description provided for @accountEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get accountEnterYourName;

  /// No description provided for @accountNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get accountNameRequired;

  /// No description provided for @accountSummary.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get accountSummary;

  /// No description provided for @accountReviewSummaryHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get accountReviewSummaryHint;

  /// No description provided for @accountSummaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get accountSummaryRequired;

  /// No description provided for @accountReview.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get accountReview;

  /// No description provided for @accountDetailedReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get accountDetailedReviewHint;

  /// No description provided for @accountReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Comment is required'**
  String get accountReviewRequired;

  /// No description provided for @accountRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get accountRating;

  /// No description provided for @accountSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get accountSubmitReview;

  /// No description provided for @accountReviewAttachmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Image/Video'**
  String get accountReviewAttachmentsLabel;

  /// No description provided for @accountReviewAddMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Photo or Video'**
  String get accountReviewAddMedia;

  /// No description provided for @accountReviewTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get accountReviewTakePhoto;

  /// No description provided for @accountReviewChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get accountReviewChooseFromGallery;

  /// No description provided for @accountReviewChooseVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose Video'**
  String get accountReviewChooseVideo;

  /// No description provided for @accountReviewRemoveAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get accountReviewRemoveAttachment;

  /// No description provided for @accountReviewAttachmentLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can attach up to 5 files'**
  String get accountReviewAttachmentLimitReached;

  /// No description provided for @accountReviewAttachmentTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large (max 5 MB)'**
  String get accountReviewAttachmentTooLarge;

  /// No description provided for @accountCouldNotLoadAddresses.
  ///
  /// In en, this message translates to:
  /// **'Could not load addresses'**
  String get accountCouldNotLoadAddresses;

  /// No description provided for @accountPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get accountPleaseTryAgain;

  /// No description provided for @accountNoAddressesSaved.
  ///
  /// In en, this message translates to:
  /// **'No addresses saved'**
  String get accountNoAddressesSaved;

  /// No description provided for @accountAddAddressToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a new address to get started'**
  String get accountAddAddressToGetStarted;

  /// No description provided for @accountSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get accountSelectAddress;

  /// No description provided for @accountSetAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get accountSetAsDefault;

  /// No description provided for @accountAddressTypeHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get accountAddressTypeHome;

  /// No description provided for @accountAddressTypeOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get accountAddressTypeOffice;

  /// No description provided for @accountAddressTypeCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get accountAddressTypeCustomer;

  /// No description provided for @accountNoProductsToCompare.
  ///
  /// In en, this message translates to:
  /// **'No Products to Compare'**
  String get accountNoProductsToCompare;

  /// No description provided for @accountAddProductsToCompareHint.
  ///
  /// In en, this message translates to:
  /// **'Add products to compare from the product detail page.'**
  String get accountAddProductsToCompareHint;

  /// No description provided for @accountProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get accountProducts;

  /// No description provided for @accountDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountDescription;

  /// No description provided for @accountShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get accountShortDescription;

  /// No description provided for @accountActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get accountActivity;

  /// No description provided for @accountSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get accountSeller;

  /// No description provided for @accountNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get accountNotAvailable;

  /// No description provided for @accountMessageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get accountMessageSentSuccessfully;

  /// No description provided for @accountAnErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get accountAnErrorOccurred;

  /// No description provided for @accountContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get accountContactUs;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountName;

  /// No description provided for @accountEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get accountEnterYourEmail;

  /// No description provided for @accountContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get accountContact;

  /// No description provided for @accountEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get accountEnterYourPhoneNumber;

  /// No description provided for @accountMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get accountMessage;

  /// No description provided for @accountEnterYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message'**
  String get accountEnterYourMessage;

  /// No description provided for @accountSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get accountSendMessage;

  /// No description provided for @accountNameFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name field cannot be empty'**
  String get accountNameFieldEmpty;

  /// No description provided for @accountNameMinChars.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get accountNameMinChars;

  /// No description provided for @accountEmailFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email field cannot be empty'**
  String get accountEmailFieldEmpty;

  /// No description provided for @accountPleaseEnterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get accountPleaseEnterValidEmailAddress;

  /// No description provided for @accountContactNumberEmpty.
  ///
  /// In en, this message translates to:
  /// **'Contact number cannot be empty'**
  String get accountContactNumberEmpty;

  /// No description provided for @accountPleaseEnterValidContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid contact number'**
  String get accountPleaseEnterValidContactNumber;

  /// No description provided for @accountMessageFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'Message field cannot be empty'**
  String get accountMessageFieldEmpty;

  /// No description provided for @accountMessageMinChars.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get accountMessageMinChars;

  /// No description provided for @accountDownloadableProducts.
  ///
  /// In en, this message translates to:
  /// **'Downloadable Products'**
  String get accountDownloadableProducts;

  /// No description provided for @accountNoDownloadsYet.
  ///
  /// In en, this message translates to:
  /// **'No Downloads Yet'**
  String get accountNoDownloadsYet;

  /// No description provided for @accountDownloadsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your downloaded products will appear here.'**
  String get accountDownloadsEmptyDescription;

  /// No description provided for @accountProductsProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} Products'**
  String accountProductsProgress(int current, int total);

  /// No description provided for @accountRemainingDownloadsLeft.
  ///
  /// In en, this message translates to:
  /// **'{value} left'**
  String accountRemainingDownloadsLeft(Object value);

  /// No description provided for @accountDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get accountDownload;

  /// No description provided for @accountFileName.
  ///
  /// In en, this message translates to:
  /// **'File: {fileName}'**
  String accountFileName(Object fileName);

  /// No description provided for @accountDownloadWillStartShortly.
  ///
  /// In en, this message translates to:
  /// **'Your download will start shortly. Check your downloads folder.'**
  String get accountDownloadWillStartShortly;

  /// No description provided for @accountClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get accountClose;

  /// No description provided for @accountOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get accountOrders;

  /// No description provided for @accountNoOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get accountNoOrdersYet;

  /// No description provided for @accountOrdersEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here once you make a purchase.'**
  String get accountOrdersEmptyDescription;

  /// No description provided for @accountOrderSingular.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get accountOrderSingular;

  /// No description provided for @accountOrderPlural.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get accountOrderPlural;

  /// No description provided for @accountOrderTotalItems.
  ///
  /// In en, this message translates to:
  /// **'{total} (Items {count})'**
  String accountOrderTotalItems(Object total, int count);

  /// No description provided for @accountOrderAndReturn.
  ///
  /// In en, this message translates to:
  /// **'Order and Return'**
  String get accountOrderAndReturn;

  /// No description provided for @accountTrackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get accountTrackOrder;

  /// No description provided for @accountReturnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return Policy'**
  String get accountReturnPolicy;

  /// No description provided for @accountReturnRequest.
  ///
  /// In en, this message translates to:
  /// **'Return Request'**
  String get accountReturnRequest;

  /// No description provided for @accountNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get accountNotifications;

  /// No description provided for @accountPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get accountPrivacy;

  /// No description provided for @accountAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountAccount;

  /// No description provided for @accountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get accountPreferences;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @accountNoLanguagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No languages available'**
  String get accountNoLanguagesAvailable;

  /// No description provided for @accountCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get accountCurrency;

  /// No description provided for @accountOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get accountOthers;

  /// No description provided for @accountNoPagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No pages available'**
  String get accountNoPagesAvailable;

  /// No description provided for @accountProductReviews.
  ///
  /// In en, this message translates to:
  /// **'Product Reviews'**
  String get accountProductReviews;

  /// No description provided for @accountMyReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get accountMyReviews;

  /// No description provided for @accountNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get accountNoReviewsYet;

  /// No description provided for @accountReviewsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your product reviews will appear here.'**
  String get accountReviewsEmptyDescription;

  /// No description provided for @accountReviewSingular.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get accountReviewSingular;

  /// No description provided for @accountReviewPlural.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get accountReviewPlural;

  /// No description provided for @accountPostedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted on {date}'**
  String accountPostedOn(Object date);

  /// No description provided for @accountCloseSettings.
  ///
  /// In en, this message translates to:
  /// **'Close settings'**
  String get accountCloseSettings;

  /// No description provided for @accountChangeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get accountChangeTheme;

  /// No description provided for @accountAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  String get accountAllNotifications;

  /// No description provided for @accountOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get accountOffers;

  /// No description provided for @accountOfflineData.
  ///
  /// In en, this message translates to:
  /// **'Offline Data'**
  String get accountOfflineData;

  /// No description provided for @accountTrackRecentlyViewedProducts.
  ///
  /// In en, this message translates to:
  /// **'Track and Show Recently viewed products'**
  String get accountTrackRecentlyViewedProducts;

  /// No description provided for @accountShowSearchTag.
  ///
  /// In en, this message translates to:
  /// **'Show Search Tag'**
  String get accountShowSearchTag;

  /// No description provided for @accountTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get accountTryAgain;

  /// No description provided for @accountYourWishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get accountYourWishlistEmpty;

  /// No description provided for @accountWishlistEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse products and add them to your wishlist'**
  String get accountWishlistEmptyDescription;

  /// No description provided for @accountItemSingular.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get accountItemSingular;

  /// No description provided for @accountItemPlural.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get accountItemPlural;

  /// No description provided for @accountStartingAt.
  ///
  /// In en, this message translates to:
  /// **'Starting at {price}'**
  String accountStartingAt(Object price);

  /// No description provided for @accountAboutThisPage.
  ///
  /// In en, this message translates to:
  /// **'About this page'**
  String get accountAboutThisPage;

  /// No description provided for @accountPageId.
  ///
  /// In en, this message translates to:
  /// **'Page ID: {id}'**
  String accountPageId(Object id);

  /// No description provided for @mainTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainTabHome;

  /// No description provided for @mainTabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get mainTabCategories;

  /// No description provided for @mainTabCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get mainTabCart;

  /// No description provided for @mainTabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get mainTabAccount;

  /// No description provided for @authLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Successfully logged in.'**
  String get authLoginSuccess;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get authWelcomeBack;

  /// No description provided for @authLoginToAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get authLoginToAccount;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailAddress;

  /// No description provided for @authEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterYourEmail;

  /// No description provided for @authPleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authPleaseEnterEmail;

  /// No description provided for @authPleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get authPleaseEnterValidEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterYourPassword;

  /// No description provided for @authPleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authPleaseEnterPassword;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordMinLength;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPasswordTitle;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccountPrompt;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authAccountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get authAccountCreatedSuccess;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authSignupGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get authSignupGetStarted;

  /// No description provided for @authFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get authFirstNameHint;

  /// No description provided for @authLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get authLastNameHint;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get authRequired;

  /// No description provided for @authCreatePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get authCreatePasswordHint;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authPleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authPleaseConfirmPassword;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authAlreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAccountPrompt;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @authNiceToSeeYouHere.
  ///
  /// In en, this message translates to:
  /// **'Nice to see you here'**
  String get authNiceToSeeYouHere;

  /// No description provided for @accountEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Edit'**
  String get accountEditTitle;

  /// No description provided for @accountFirstNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name *'**
  String get accountFirstNameRequiredLabel;

  /// No description provided for @accountLastNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name *'**
  String get accountLastNameRequiredLabel;

  /// No description provided for @accountChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get accountChangeEmail;

  /// No description provided for @accountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountChangePassword;

  /// No description provided for @accountDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountDeleteAccount;

  /// No description provided for @accountGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get accountGender;

  /// No description provided for @accountSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get accountSelectGender;

  /// No description provided for @accountDob.
  ///
  /// In en, this message translates to:
  /// **'DOB'**
  String get accountDob;

  /// No description provided for @monthJanShort.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJanShort;

  /// No description provided for @monthFebShort.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFebShort;

  /// No description provided for @monthMarShort.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMarShort;

  /// No description provided for @monthAprShort.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthAprShort;

  /// No description provided for @monthMayShort.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMayShort;

  /// No description provided for @monthJunShort.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJunShort;

  /// No description provided for @monthJulShort.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJulShort;

  /// No description provided for @monthAugShort.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAugShort;

  /// No description provided for @monthSepShort.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSepShort;

  /// No description provided for @monthOctShort.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOctShort;

  /// No description provided for @monthNovShort.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNovShort;

  /// No description provided for @monthDecShort.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDecShort;

  /// No description provided for @accountSubscribeNewsletters.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Newsletters'**
  String get accountSubscribeNewsletters;

  /// No description provided for @accountSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get accountSaveProfile;

  /// No description provided for @accountNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get accountNewEmail;

  /// No description provided for @accountEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get accountEmailRequired;

  /// No description provided for @accountCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get accountCurrentPassword;

  /// No description provided for @accountPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get accountPasswordRequired;

  /// No description provided for @accountChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get accountChange;

  /// No description provided for @accountCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get accountCurrentPasswordRequired;

  /// No description provided for @accountNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get accountNewPassword;

  /// No description provided for @accountConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get accountConfirmPassword;

  /// No description provided for @accountDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data will be deleted.'**
  String get accountDeleteWarning;

  /// No description provided for @accountEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get accountEnterYourPassword;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get accountDelete;

  /// No description provided for @accountDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get accountDeleteAddress;

  /// No description provided for @accountDeleteAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get accountDeleteAddressConfirm;

  /// No description provided for @accountGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get accountGenderMale;

  /// No description provided for @accountGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get accountGenderFemale;

  /// No description provided for @accountGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get accountGenderOther;

  /// No description provided for @accountOrdersWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Orders {number}'**
  String accountOrdersWithNumber(Object number);

  /// No description provided for @accountReorderSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Reorder Successful'**
  String get accountReorderSuccessful;

  /// No description provided for @accountReorderItemsAdded.
  ///
  /// In en, this message translates to:
  /// **'{message} \n\n{count} items added to your cart.'**
  String accountReorderItemsAdded(Object message, int count);

  /// No description provided for @accountOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get accountOk;

  /// No description provided for @accountGoToCart.
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get accountGoToCart;

  /// No description provided for @accountFailedToLoadOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details'**
  String get accountFailedToLoadOrderDetails;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get accountDetails;

  /// No description provided for @accountInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get accountInvoices;

  /// No description provided for @accountShipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get accountShipments;

  /// No description provided for @accountRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get accountRefunds;

  /// No description provided for @accountRefundSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get accountRefundSubtotal;

  /// No description provided for @accountRefundedQty.
  ///
  /// In en, this message translates to:
  /// **'Refunded Qty'**
  String get accountRefundedQty;

  /// No description provided for @accountShippingAndHandling.
  ///
  /// In en, this message translates to:
  /// **'Shipping & Handling'**
  String get accountShippingAndHandling;

  /// No description provided for @accountAdjustmentRefund.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Refund'**
  String get accountAdjustmentRefund;

  /// No description provided for @accountAdjustmentFee.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Fee'**
  String get accountAdjustmentFee;

  /// No description provided for @accountPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String accountPlacedOn(Object date);

  /// No description provided for @accountItemsOrdered.
  ///
  /// In en, this message translates to:
  /// **'{count} Item(s) Ordered'**
  String accountItemsOrdered(int count);

  /// No description provided for @accountBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get accountBillingAddress;

  /// No description provided for @accountShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get accountShippingAddress;

  /// No description provided for @accountShippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Shipping Method'**
  String get accountShippingMethod;

  /// No description provided for @accountPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get accountPaymentMethod;

  /// No description provided for @accountNoInvoicesForOrder.
  ///
  /// In en, this message translates to:
  /// **'No invoices for this order'**
  String get accountNoInvoicesForOrder;

  /// No description provided for @accountInvoicedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Invoiced'**
  String accountInvoicedCount(int count);

  /// No description provided for @accountNoShipmentsForOrder.
  ///
  /// In en, this message translates to:
  /// **'No shipments for this order'**
  String get accountNoShipmentsForOrder;

  /// No description provided for @accountReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get accountReorder;

  /// No description provided for @accountMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'More info'**
  String get accountMoreInfo;

  /// No description provided for @accountOrderedQty.
  ///
  /// In en, this message translates to:
  /// **'Ordered Qty'**
  String get accountOrderedQty;

  /// No description provided for @accountShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get accountShipped;

  /// No description provided for @accountInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Invoiced'**
  String get accountInvoiced;

  /// No description provided for @accountUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get accountUnitPrice;

  /// No description provided for @accountSubTotalWithSpace.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get accountSubTotalWithSpace;

  /// No description provided for @accountTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get accountTotalPaid;

  /// No description provided for @accountTotalRefunded.
  ///
  /// In en, this message translates to:
  /// **'Total Refunded'**
  String get accountTotalRefunded;

  /// No description provided for @accountTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Due'**
  String get accountTotalDue;

  /// No description provided for @accountInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number}'**
  String accountInvoiceNumber(Object number);

  /// No description provided for @accountShipmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Shipment {number}'**
  String accountShipmentNumber(Object number);

  /// No description provided for @accountFailedToLoadInvoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invoice details'**
  String get accountFailedToLoadInvoiceDetails;

  /// No description provided for @accountInvoiceStatus.
  ///
  /// In en, this message translates to:
  /// **'Invoice Status'**
  String get accountInvoiceStatus;

  /// No description provided for @accountInvoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get accountInvoiceDate;

  /// No description provided for @accountOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get accountOrderId;

  /// No description provided for @accountOrderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get accountOrderDate;

  /// No description provided for @accountOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get accountOrderStatus;

  /// No description provided for @accountChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get accountChannel;

  /// No description provided for @accountDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get accountDefault;

  /// No description provided for @accountStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get accountStatusPaid;

  /// No description provided for @accountStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get accountStatusPending;

  /// No description provided for @accountStatusPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get accountStatusPendingPayment;

  /// No description provided for @accountStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get accountStatusOverdue;

  /// No description provided for @accountStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get accountStatusRefunded;

  /// No description provided for @accountShippedQty.
  ///
  /// In en, this message translates to:
  /// **'Shipped Qty'**
  String get accountShippedQty;

  /// No description provided for @accountInvoicedQty.
  ///
  /// In en, this message translates to:
  /// **'Invoiced Qty'**
  String get accountInvoicedQty;

  /// No description provided for @accountUnitPriceWithColon.
  ///
  /// In en, this message translates to:
  /// **'Unit Price:'**
  String get accountUnitPriceWithColon;

  /// No description provided for @accountSubTotalWithColon.
  ///
  /// In en, this message translates to:
  /// **'Sub Total:'**
  String get accountSubTotalWithColon;

  /// No description provided for @accountDownloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get accountDownloadInvoice;

  /// No description provided for @accountInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get accountInvoice;

  /// No description provided for @accountRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get accountRecentOrders;

  /// No description provided for @accountNoRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders'**
  String get accountNoRecentOrders;

  /// No description provided for @accountStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get accountStatusProcessing;

  /// No description provided for @accountStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get accountStatusCompleted;

  /// No description provided for @accountStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get accountStatusCancelled;

  /// No description provided for @accountStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get accountStatusClosed;

  /// No description provided for @accountStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get accountStatusUnknown;

  /// No description provided for @accountWishlistItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Wishlist Items ({count})'**
  String accountWishlistItemsCount(int count);

  /// No description provided for @accountNoWishlistItems.
  ///
  /// In en, this message translates to:
  /// **'No wishlist items'**
  String get accountNoWishlistItems;

  /// No description provided for @accountDefaultAddresses.
  ///
  /// In en, this message translates to:
  /// **'Default Addresses'**
  String get accountDefaultAddresses;

  /// No description provided for @accountNoProductReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No product reviews yet'**
  String get accountNoProductReviewsYet;

  /// No description provided for @searchFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchFailedTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchHint;

  /// No description provided for @searchImageSearch.
  ///
  /// In en, this message translates to:
  /// **'Image Search'**
  String get searchImageSearch;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get searchClearAll;

  /// No description provided for @searchTopCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get searchTopCategories;

  /// No description provided for @searchResultsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String searchResultsFound(int count);

  /// No description provided for @searchDiscountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String searchDiscountOff(Object percent);

  /// No description provided for @searchNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get searchNoProductsFound;

  /// No description provided for @searchTryDifferentTerm.
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different term'**
  String get searchTryDifferentTerm;

  /// No description provided for @searchSpeechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available'**
  String get searchSpeechNotAvailable;

  /// No description provided for @searchFailedToStartVoice.
  ///
  /// In en, this message translates to:
  /// **'Failed to start voice input: {error}'**
  String searchFailedToStartVoice(Object error);

  /// No description provided for @searchMicrophonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get searchMicrophonePermissionDenied;

  /// No description provided for @searchRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get searchRetake;

  /// No description provided for @searchSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchSearch;

  /// No description provided for @searchTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get searchTryAgain;

  /// No description provided for @searchRecognizedObjects.
  ///
  /// In en, this message translates to:
  /// **'Recognized Objects'**
  String get searchRecognizedObjects;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'Result:'**
  String get searchResult;

  /// No description provided for @searchFailedToCaptureImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture image'**
  String get searchFailedToCaptureImage;

  /// No description provided for @searchProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing... {progress}%'**
  String searchProcessing(int progress);

  /// No description provided for @searchOpeningCamera.
  ///
  /// In en, this message translates to:
  /// **'Opening camera...'**
  String get searchOpeningCamera;

  /// No description provided for @searchFailedToProcessImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to process image'**
  String get searchFailedToProcessImage;

  /// No description provided for @homeRecentlyViewedProducts.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed Products'**
  String get homeRecentlyViewedProducts;

  /// No description provided for @homeNewsletterHeadline.
  ///
  /// In en, this message translates to:
  /// **'Get Ready for our Fun Newsletter!'**
  String get homeNewsletterHeadline;

  /// No description provided for @homeNewsletterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to stay in touch.'**
  String get homeNewsletterSubtitle;

  /// No description provided for @homeNewsletterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get homeNewsletterEmailHint;

  /// No description provided for @homeNewsletterSubscribeAction.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get homeNewsletterSubscribeAction;

  /// No description provided for @homeNewsletterEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get homeNewsletterEmailRequired;

  /// No description provided for @homeNewsletterEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get homeNewsletterEmailInvalid;

  /// No description provided for @homeNewsletterSubscribed.
  ///
  /// In en, this message translates to:
  /// **'You have successfully subscribed to our newsletter.'**
  String get homeNewsletterSubscribed;

  /// No description provided for @homeNewsletterAlreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'You are already subscribed to our newsletter.'**
  String get homeNewsletterAlreadySubscribed;

  /// No description provided for @homeNewsletterGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get homeNewsletterGenericError;

  /// No description provided for @accountItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Item(s)'**
  String accountItemsCount(int count);

  /// No description provided for @accountTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get accountTrack;

  /// No description provided for @accountTrackingVia.
  ///
  /// In en, this message translates to:
  /// **'Tracking {trackNumber} via {carrier}'**
  String accountTrackingVia(Object trackNumber, Object carrier);

  /// No description provided for @accountUnknownCarrier.
  ///
  /// In en, this message translates to:
  /// **'Unknown carrier'**
  String get accountUnknownCarrier;

  /// No description provided for @accountTrackingNumber.
  ///
  /// In en, this message translates to:
  /// **'Tracking Number'**
  String get accountTrackingNumber;

  /// No description provided for @accountSkuValue.
  ///
  /// In en, this message translates to:
  /// **'SKU : {sku}'**
  String accountSkuValue(Object sku);

  /// No description provided for @accountShippedQtyValue.
  ///
  /// In en, this message translates to:
  /// **'Shipped Qty : {qty}'**
  String accountShippedQtyValue(int qty);

  /// No description provided for @sellerLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller sign in'**
  String get sellerLoginTitle;

  /// No description provided for @sellerLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your shop, products and orders'**
  String get sellerLoginSubtitle;

  /// No description provided for @sellerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get sellerEmailLabel;

  /// No description provided for @sellerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get sellerPasswordLabel;

  /// No description provided for @sellerSignInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sellerSignInAction;

  /// No description provided for @sellerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get sellerEmailRequired;

  /// No description provided for @sellerPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get sellerPasswordRequired;

  /// No description provided for @sellerPendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get sellerPendingApprovalTitle;

  /// No description provided for @sellerPendingApprovalBody.
  ///
  /// In en, this message translates to:
  /// **'The marketplace admin has not approved this shop yet. You will be able to sign in once they do.'**
  String get sellerPendingApprovalBody;

  /// No description provided for @sellerSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop suspended'**
  String get sellerSuspendedTitle;

  /// No description provided for @sellerSuspendedBody.
  ///
  /// In en, this message translates to:
  /// **'This shop has been suspended by the marketplace admin.'**
  String get sellerSuspendedBody;

  /// No description provided for @accountSellOnMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Sell on marketplace'**
  String get accountSellOnMarketplace;

  /// No description provided for @sellerProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get sellerProfileTitle;

  /// No description provided for @sellerBusinessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get sellerBusinessNameLabel;

  /// No description provided for @sellerBusinessDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'About the shop'**
  String get sellerBusinessDescriptionLabel;

  /// No description provided for @sellerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get sellerPhoneLabel;

  /// No description provided for @sellerSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get sellerSaveAction;

  /// No description provided for @sellerProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get sellerProfileSaved;

  /// No description provided for @sellerProfileFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get sellerProfileFieldRequired;

  /// No description provided for @sellerProfileRequiredFieldsMissing.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get sellerProfileRequiredFieldsMissing;

  /// No description provided for @sellerProfilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get sellerProfilePhone;

  /// No description provided for @sellerProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Shop description'**
  String get sellerProfileDescription;

  /// No description provided for @sellerProfileBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get sellerProfileBusinessName;

  /// No description provided for @sellerProfileTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sellerProfileTabGeneral;

  /// No description provided for @sellerProfileTabAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get sellerProfileTabAddress;

  /// No description provided for @sellerProfileTabPolicies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get sellerProfileTabPolicies;

  /// No description provided for @sellerProfileTabSeo.
  ///
  /// In en, this message translates to:
  /// **'SEO'**
  String get sellerProfileTabSeo;

  /// No description provided for @sellerProfileTabSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get sellerProfileTabSocial;

  /// No description provided for @sellerProfileTabOther.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get sellerProfileTabOther;

  /// No description provided for @sellerShopInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Information'**
  String get sellerShopInfoTitle;

  /// No description provided for @sellerShopInfoCommission.
  ///
  /// In en, this message translates to:
  /// **'Admin commission'**
  String get sellerShopInfoCommission;

  /// No description provided for @sellerShopInfoCommissionText.
  ///
  /// In en, this message translates to:
  /// **'Admin Commission {rate} of total Invoiced Amount'**
  String sellerShopInfoCommissionText(String rate);

  /// No description provided for @sellerShopInfoRestrictedCategories.
  ///
  /// In en, this message translates to:
  /// **'Restricted categories'**
  String get sellerShopInfoRestrictedCategories;

  /// No description provided for @sellerShopInfoProductTypes.
  ///
  /// In en, this message translates to:
  /// **'Allowed product types'**
  String get sellerShopInfoProductTypes;

  /// No description provided for @sellerShopInfoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get sellerShopInfoPaymentMethods;

  /// No description provided for @sellerShopInfoShippingMethods.
  ///
  /// In en, this message translates to:
  /// **'Shipping methods'**
  String get sellerShopInfoShippingMethods;

  /// No description provided for @sellerProfileNoFields.
  ///
  /// In en, this message translates to:
  /// **'This marketplace defines no editable profile fields.'**
  String get sellerProfileNoFields;

  /// No description provided for @sellerProfileContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get sellerProfileContactName;

  /// No description provided for @sellerProfileSlug.
  ///
  /// In en, this message translates to:
  /// **'Shop URL'**
  String get sellerProfileSlug;

  /// No description provided for @sellerProfileAddress.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get sellerProfileAddress;

  /// No description provided for @sellerProfileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get sellerProfileCity;

  /// No description provided for @sellerProfileState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get sellerProfileState;

  /// No description provided for @sellerProfileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get sellerProfileCountry;

  /// No description provided for @sellerProfilePostcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get sellerProfilePostcode;

  /// No description provided for @sellerProfileReturnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return policy'**
  String get sellerProfileReturnPolicy;

  /// No description provided for @sellerProfileShippingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Shipping policy'**
  String get sellerProfileShippingPolicy;

  /// No description provided for @sellerProfilePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get sellerProfilePrivacyPolicy;

  /// No description provided for @sellerProfileMetaTitle.
  ///
  /// In en, this message translates to:
  /// **'Meta title'**
  String get sellerProfileMetaTitle;

  /// No description provided for @sellerProfileMetaKeywords.
  ///
  /// In en, this message translates to:
  /// **'Meta keywords'**
  String get sellerProfileMetaKeywords;

  /// No description provided for @sellerProfileMetaDescription.
  ///
  /// In en, this message translates to:
  /// **'Meta description'**
  String get sellerProfileMetaDescription;

  /// No description provided for @sellerProfileAnalyticsId.
  ///
  /// In en, this message translates to:
  /// **'Google Analytics ID'**
  String get sellerProfileAnalyticsId;

  /// No description provided for @sellerProfileMinOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum order amount'**
  String get sellerProfileMinOrder;

  /// No description provided for @sellerStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get sellerStatusSuspended;

  /// No description provided for @sellerDrawerSettingsGroup.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerDrawerSettingsGroup;

  /// No description provided for @sellerDrawerCatalogGroup.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get sellerDrawerCatalogGroup;

  /// No description provided for @sellerDrawerInventoriesGroup.
  ///
  /// In en, this message translates to:
  /// **'Inventories'**
  String get sellerDrawerInventoriesGroup;

  /// No description provided for @sellerDrawerPricingGroup.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get sellerDrawerPricingGroup;

  /// No description provided for @sellerDrawerSalesGroup.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sellerDrawerSalesGroup;

  /// No description provided for @sellerDrawerAllProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerDrawerAllProducts;

  /// No description provided for @sellerDrawerReportingGroup.
  ///
  /// In en, this message translates to:
  /// **'Reporting'**
  String get sellerDrawerReportingGroup;

  /// No description provided for @sellerDrawerGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sellerDrawerGeneral;

  /// No description provided for @sellerDrawerUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get sellerDrawerUsers;

  /// No description provided for @sellerDrawerRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get sellerDrawerRoles;

  /// No description provided for @sellerDrawerInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory Sources'**
  String get sellerDrawerInventory;

  /// No description provided for @sellerDrawerManageInventory.
  ///
  /// In en, this message translates to:
  /// **'Manage Inventory'**
  String get sellerDrawerManageInventory;

  /// No description provided for @sellerDrawerReportSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sellerDrawerReportSales;

  /// No description provided for @sellerDrawerReportProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerDrawerReportProducts;

  /// No description provided for @sellerDrawerReportCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerDrawerReportCustomers;

  /// No description provided for @sellerDrawerProductReviews.
  ///
  /// In en, this message translates to:
  /// **'Product reviews'**
  String get sellerDrawerProductReviews;

  /// No description provided for @sellerDrawerShopReviews.
  ///
  /// In en, this message translates to:
  /// **'Shop reviews'**
  String get sellerDrawerShopReviews;

  /// No description provided for @sellerDrawerMoreTools.
  ///
  /// In en, this message translates to:
  /// **'More tools'**
  String get sellerDrawerMoreTools;

  /// No description provided for @sellerPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller panel'**
  String get sellerPanelTitle;

  /// No description provided for @sellerTabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get sellerTabDashboard;

  /// No description provided for @sellerTabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerTabProducts;

  /// No description provided for @sellerTabOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sellerTabOrders;

  /// No description provided for @sellerStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sellerStatusApproved;

  /// No description provided for @sellerStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get sellerStatusPending;

  /// No description provided for @sellerDashboardSalesTrend.
  ///
  /// In en, this message translates to:
  /// **'Sales over time'**
  String get sellerDashboardSalesTrend;

  /// No description provided for @sellerDashboardDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get sellerDashboardDateFilter;

  /// No description provided for @sellerDashboardDefaultRange.
  ///
  /// In en, this message translates to:
  /// **'Default range'**
  String get sellerDashboardDefaultRange;

  /// No description provided for @sellerDashboardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sellerDashboardToday;

  /// No description provided for @sellerDashboardLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get sellerDashboardLast7Days;

  /// No description provided for @sellerDashboardLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get sellerDashboardLast30Days;

  /// No description provided for @sellerDashboardThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get sellerDashboardThisMonth;

  /// No description provided for @sellerDashboardLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get sellerDashboardLastMonth;

  /// No description provided for @sellerDashboardLast6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 Months'**
  String get sellerDashboardLast6Months;

  /// No description provided for @sellerDashboardThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get sellerDashboardThisYear;

  /// No description provided for @sellerDashboardLastYear.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get sellerDashboardLastYear;

  /// No description provided for @sellerDashboardCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get sellerDashboardCustomRange;

  /// No description provided for @sellerDashboardOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Orders by status'**
  String get sellerDashboardOrderStatus;

  /// No description provided for @sellerDashboardTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get sellerDashboardTopProducts;

  /// No description provided for @sellerDashboardTopCategories.
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get sellerDashboardTopCategories;

  /// No description provided for @sellerDashboardTopCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top customers'**
  String get sellerDashboardTopCustomers;

  /// No description provided for @sellerDashboardTodo.
  ///
  /// In en, this message translates to:
  /// **'Things to do'**
  String get sellerDashboardTodo;

  /// No description provided for @sellerProfileScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Score'**
  String get sellerProfileScoreTitle;

  /// No description provided for @sellerProfileScoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maximize your visibility by keeping your profile information complete.'**
  String get sellerProfileScoreSubtitle;

  /// No description provided for @sellerProfileScoreAction.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get sellerProfileScoreAction;

  /// No description provided for @sellerDashboardTodoClear.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up.'**
  String get sellerDashboardTodoClear;

  /// No description provided for @sellerDashboardTodoUnshipped.
  ///
  /// In en, this message translates to:
  /// **'Orders to ship'**
  String get sellerDashboardTodoUnshipped;

  /// No description provided for @sellerDashboardTodoLowStock.
  ///
  /// In en, this message translates to:
  /// **'Products low on stock'**
  String get sellerDashboardTodoLowStock;

  /// No description provided for @sellerDashboardTodoPending.
  ///
  /// In en, this message translates to:
  /// **'Products awaiting approval'**
  String get sellerDashboardTodoPending;

  /// No description provided for @sellerDashboardTodoMessages.
  ///
  /// In en, this message translates to:
  /// **'Unread messages'**
  String get sellerDashboardTodoMessages;

  /// No description provided for @sellerDashboardBuyerMessages.
  ///
  /// In en, this message translates to:
  /// **'Buyer Messages'**
  String get sellerDashboardBuyerMessages;

  /// No description provided for @sellerDashboardUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get sellerDashboardUnread;

  /// No description provided for @sellerDashboardReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String sellerDashboardReviewsCount(int count);

  /// No description provided for @sellerDashboardLowStock.
  ///
  /// In en, this message translates to:
  /// **'Stock Threshold'**
  String get sellerDashboardLowStock;

  /// No description provided for @sellerDashboardNoData.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show for this period'**
  String get sellerDashboardNoData;

  /// No description provided for @sellerDashboardAvgSale.
  ///
  /// In en, this message translates to:
  /// **'Average sale'**
  String get sellerDashboardAvgSale;

  /// No description provided for @sellerDashboardPaidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get sellerDashboardPaidOut;

  /// No description provided for @sellerDashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get sellerDashboardViewAll;

  /// No description provided for @sellerDashboardOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order} other{{count} orders}}'**
  String sellerDashboardOrdersCount(int count);

  /// No description provided for @sellerDashboardLeftInStock.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 left} other{{count} left}}'**
  String sellerDashboardLeftInStock(int count);

  /// No description provided for @sellerDashboardPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get sellerDashboardPerformance;

  /// No description provided for @sellerDashboardOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sellerDashboardOrders;

  /// No description provided for @sellerDashboardSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sellerDashboardSales;

  /// No description provided for @sellerDashboardCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerDashboardCustomers;

  /// No description provided for @sellerMoreCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get sellerMoreCatalogue;

  /// No description provided for @sellerMoreSelling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get sellerMoreSelling;

  /// No description provided for @sellerMoreMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get sellerMoreMoney;

  /// No description provided for @sellerMoreShop.
  ///
  /// In en, this message translates to:
  /// **'Your shop'**
  String get sellerMoreShop;

  /// No description provided for @sellerShopProfileMenu.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get sellerShopProfileMenu;

  /// No description provided for @sellerSignOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sellerSignOutAction;

  /// No description provided for @sellerRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a seller'**
  String get sellerRegisterTitle;

  /// No description provided for @sellerRegisterAction.
  ///
  /// In en, this message translates to:
  /// **'Create shop'**
  String get sellerRegisterAction;

  /// No description provided for @sellerRegisterAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get sellerRegisterAdditionalInfo;

  /// No description provided for @sellerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get sellerNameLabel;

  /// No description provided for @sellerShopUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop URL'**
  String get sellerShopUrlLabel;

  /// No description provided for @sellerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get sellerConfirmPasswordLabel;

  /// No description provided for @sellerPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get sellerPasswordMismatch;

  /// No description provided for @sellerFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get sellerFieldRequired;

  /// No description provided for @sellerForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get sellerForgotPasswordTitle;

  /// No description provided for @sellerForgotPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sellerForgotPasswordAction;

  /// No description provided for @sellerForgotPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If that email has a shop, a reset link is on its way.'**
  String get sellerForgotPasswordSent;

  /// No description provided for @sellerNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'New seller? Create a shop'**
  String get sellerNoAccountPrompt;

  /// No description provided for @sellerForgotPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get sellerForgotPasswordPrompt;

  /// No description provided for @sellerProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerProductsTitle;

  /// No description provided for @sellerProductsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or SKU'**
  String get sellerProductsSearchHint;

  /// No description provided for @sellerProductsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get sellerProductsEmpty;

  /// No description provided for @sellerProductsEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No products match these filters'**
  String get sellerProductsEmptyFiltered;

  /// No description provided for @sellerProductsFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get sellerProductsFilters;

  /// No description provided for @sellerProductStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sellerProductStatusApproved;

  /// No description provided for @sellerProductStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sellerProductStatusPending;

  /// No description provided for @sellerProductStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get sellerProductStatusRejected;

  /// No description provided for @sellerProductStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get sellerProductStatusDraft;

  /// No description provided for @sellerProductStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get sellerProductStockLabel;

  /// No description provided for @sellerProductOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get sellerProductOutOfStock;

  /// No description provided for @sellerProductsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get sellerProductsRetry;

  /// No description provided for @sellerFiltersApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get sellerFiltersApply;

  /// No description provided for @sellerFiltersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get sellerFiltersClear;

  /// No description provided for @sellerProductTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sellerProductTypeLabel;

  /// No description provided for @sellerProductStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerProductStatusLabel;

  /// No description provided for @sellerProductApprovalLabel.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get sellerProductApprovalLabel;

  /// No description provided for @sellerProductEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get sellerProductEnabled;

  /// No description provided for @sellerProductDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get sellerProductDisabled;

  /// No description provided for @sellerProductDraftsOnly.
  ///
  /// In en, this message translates to:
  /// **'Drafts only'**
  String get sellerProductDraftsOnly;

  /// No description provided for @sellerProductAnyValue.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get sellerProductAnyValue;

  /// No description provided for @sellerProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String sellerProductsCount(int count);

  /// No description provided for @sellerProductDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get sellerProductDetailTitle;

  /// No description provided for @sellerProductPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get sellerProductPricing;

  /// No description provided for @sellerProductShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get sellerProductShipping;

  /// No description provided for @sellerProductStockBySource.
  ///
  /// In en, this message translates to:
  /// **'Stock by location'**
  String get sellerProductStockBySource;

  /// No description provided for @sellerProductPendingOrderedQty.
  ///
  /// In en, this message translates to:
  /// **'Pending Ordered Qty: {count}'**
  String sellerProductPendingOrderedQty(int count);

  /// No description provided for @sellerListingCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Listing Completeness'**
  String get sellerListingCompleteness;

  /// No description provided for @sellerListingCompletenessHint.
  ///
  /// In en, this message translates to:
  /// **'A complete listing gets more visibility and sells better. Fill in the remaining details to reach 100%.'**
  String get sellerListingCompletenessHint;

  /// No description provided for @sellerGroupPriceFixed.
  ///
  /// In en, this message translates to:
  /// **'For {qty} Qty at fixed price of {value}'**
  String sellerGroupPriceFixed(Object qty, Object value);

  /// No description provided for @sellerGroupPriceDiscount.
  ///
  /// In en, this message translates to:
  /// **'For {qty} Qty at {value}% discount'**
  String sellerGroupPriceDiscount(Object qty, Object value);

  /// No description provided for @sellerGroupPriceAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get sellerGroupPriceAddNew;

  /// No description provided for @sellerGroupPriceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Customer Group Price'**
  String get sellerGroupPriceCreateTitle;

  /// No description provided for @sellerGroupPriceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer Group Price'**
  String get sellerGroupPriceEditTitle;

  /// No description provided for @sellerGroupPriceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No group prices yet. Special pricing for customers belonging to a specific group.'**
  String get sellerGroupPriceEmpty;

  /// No description provided for @sellerGroupPriceSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sellerGroupPriceSave;

  /// No description provided for @sellerGroupPriceDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A price for this group and quantity already exists. Edit that one instead, or use a different quantity.'**
  String get sellerGroupPriceDuplicate;

  /// No description provided for @sellerProductInventoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventories'**
  String get sellerProductInventoriesLabel;

  /// No description provided for @sellerProductManageStock.
  ///
  /// In en, this message translates to:
  /// **'Manage Stock'**
  String get sellerProductManageStock;

  /// No description provided for @sellerProductCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get sellerProductCategoriesLabel;

  /// No description provided for @sellerProductAttributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get sellerProductAttributes;

  /// No description provided for @sellerProductSeo.
  ///
  /// In en, this message translates to:
  /// **'SEO'**
  String get sellerProductSeo;

  /// No description provided for @sellerProductNoImages.
  ///
  /// In en, this message translates to:
  /// **'No images'**
  String get sellerProductNoImages;

  /// No description provided for @sellerProductRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason'**
  String get sellerProductRejectionReason;

  /// No description provided for @sellerProductSpecialPrice.
  ///
  /// In en, this message translates to:
  /// **'Special price'**
  String get sellerProductSpecialPrice;

  /// No description provided for @sellerProductWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get sellerProductWeight;

  /// No description provided for @sellerProductDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerProductDescription;

  /// No description provided for @sellerProductNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include product access.'**
  String get sellerProductNoPermission;

  /// No description provided for @sellerStockLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock locations'**
  String get sellerStockLocationsTitle;

  /// No description provided for @sellerStockLocationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stock locations yet'**
  String get sellerStockLocationsEmpty;

  /// No description provided for @sellerStockLocationsCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create Inventory Sources'**
  String get sellerStockLocationsCreateAction;

  /// No description provided for @sellerStockLocationsSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save Inventory Sources'**
  String get sellerStockLocationsSaveAction;

  /// No description provided for @sellerStockLocationAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Inventory Source'**
  String get sellerStockLocationAdd;

  /// No description provided for @sellerStockLocationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get sellerStockLocationEdit;

  /// No description provided for @sellerStockLocationCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get sellerStockLocationCode;

  /// No description provided for @sellerStockLocationName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sellerStockLocationName;

  /// No description provided for @sellerStockLocationContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get sellerStockLocationContactName;

  /// No description provided for @sellerStockLocationContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get sellerStockLocationContactEmail;

  /// No description provided for @sellerStockLocationContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get sellerStockLocationContactNumber;

  /// No description provided for @sellerStockLocationContactFax.
  ///
  /// In en, this message translates to:
  /// **'Contact fax'**
  String get sellerStockLocationContactFax;

  /// No description provided for @sellerStockLocationStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get sellerStockLocationStreet;

  /// No description provided for @sellerStockLocationCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get sellerStockLocationCity;

  /// No description provided for @sellerStockLocationState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get sellerStockLocationState;

  /// No description provided for @sellerStockLocationCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get sellerStockLocationCountry;

  /// No description provided for @sellerStockLocationPostcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get sellerStockLocationPostcode;

  /// No description provided for @sellerStockLocationPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sellerStockLocationPriority;

  /// No description provided for @sellerStockLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerStockLocationDescription;

  /// No description provided for @sellerStockLocationLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get sellerStockLocationLatitude;

  /// No description provided for @sellerStockLocationLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get sellerStockLocationLongitude;

  /// No description provided for @sellerStockLocationActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerStockLocationActive;

  /// No description provided for @sellerStockLocationInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get sellerStockLocationInactive;

  /// No description provided for @sellerStockLocationSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sellerStockLocationSectionGeneral;

  /// No description provided for @sellerStockLocationSectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Source Address'**
  String get sellerStockLocationSectionAddress;

  /// No description provided for @sellerStockLocationSectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerStockLocationSectionSettings;

  /// No description provided for @sellerStockLocationSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get sellerStockLocationSectionContact;

  /// No description provided for @sellerStockLocationProducts.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String sellerStockLocationProducts(int count);

  /// No description provided for @sellerStockLocationDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete location'**
  String get sellerStockLocationDelete;

  /// No description provided for @sellerStockLocationDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this stock location?'**
  String get sellerStockLocationDeleteConfirm;

  /// No description provided for @sellerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sellerCancel;

  /// No description provided for @sellerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sellerDelete;

  /// No description provided for @sellerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sellerSave;

  /// No description provided for @sellerStockLocationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Unique across the whole store'**
  String get sellerStockLocationCodeHint;

  /// No description provided for @sellerManageInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Inventory'**
  String get sellerManageInventoryTitle;

  /// No description provided for @sellerManageInventorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sellerManageInventorySearchHint;

  /// No description provided for @sellerManageInventoryResults.
  ///
  /// In en, this message translates to:
  /// **'{count} Results'**
  String sellerManageInventoryResults(int count);

  /// No description provided for @sellerManageInventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get sellerManageInventoryEmpty;

  /// No description provided for @sellerManageInventoryRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get sellerManageInventoryRetry;

  /// No description provided for @sellerManageInventoryStatusUnapproved.
  ///
  /// In en, this message translates to:
  /// **'Unapproved'**
  String get sellerManageInventoryStatusUnapproved;

  /// No description provided for @sellerManageInventoryStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerManageInventoryStatusActive;

  /// No description provided for @sellerManageInventoryStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get sellerManageInventoryStatusInactive;

  /// No description provided for @sellerManageInventorySold.
  ///
  /// In en, this message translates to:
  /// **'Sold {count}'**
  String sellerManageInventorySold(int count);

  /// No description provided for @sellerManageInventoryUndelivered.
  ///
  /// In en, this message translates to:
  /// **'Undelivered {count}'**
  String sellerManageInventoryUndelivered(int count);

  /// No description provided for @sellerManageInventoryCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled {count}'**
  String sellerManageInventoryCanceled(int count);

  /// No description provided for @sellerManageInventoryStock.
  ///
  /// In en, this message translates to:
  /// **'Stock: {count}'**
  String sellerManageInventoryStock(int count);

  /// No description provided for @sellerManageInventoryReadOnlyStock.
  ///
  /// In en, this message translates to:
  /// **'Stock is read-only with more than one stock location — edit it from the product instead.'**
  String get sellerManageInventoryReadOnlyStock;

  /// No description provided for @sellerManageInventoryUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'{count} unsaved change(s)'**
  String sellerManageInventoryUnsavedChanges(int count);

  /// No description provided for @sellerManageInventoryUnsavedHint.
  ///
  /// In en, this message translates to:
  /// **'Review your inventory edits, then save to publish them.'**
  String get sellerManageInventoryUnsavedHint;

  /// No description provided for @sellerManageInventoryDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get sellerManageInventoryDiscard;

  /// No description provided for @sellerManageInventorySaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save Inventories'**
  String get sellerManageInventorySaveAction;

  /// No description provided for @sellerManageInventorySaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Inventory updated'**
  String get sellerManageInventorySaveSuccess;

  /// No description provided for @sellerManageInventoryEditPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get sellerManageInventoryEditPrice;

  /// No description provided for @sellerManageInventorySelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get sellerManageInventorySelectAll;

  /// No description provided for @sellerManageInventorySelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String sellerManageInventorySelected(int count);

  /// No description provided for @sellerManageInventoryEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get sellerManageInventoryEnable;

  /// No description provided for @sellerManageInventoryDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get sellerManageInventoryDisable;

  /// No description provided for @sellerManageInventoryBatchResult.
  ///
  /// In en, this message translates to:
  /// **'{saved} updated, {skipped} skipped'**
  String sellerManageInventoryBatchResult(int saved, int skipped);

  /// No description provided for @sellerManageInventoryPageSize.
  ///
  /// In en, this message translates to:
  /// **'Per page'**
  String get sellerManageInventoryPageSize;

  /// No description provided for @sellerProductCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get sellerProductCreateTitle;

  /// No description provided for @sellerProductCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get sellerProductCreateAction;

  /// No description provided for @sellerProductSkuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sellerProductSkuLabel;

  /// No description provided for @sellerProductFamilyLabel.
  ///
  /// In en, this message translates to:
  /// **'Which attribute family does your product belong to? *'**
  String get sellerProductFamilyLabel;

  /// No description provided for @sellerProductFamilyHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the attribute family that best matches your product.'**
  String get sellerProductFamilyHelp;

  /// No description provided for @sellerProductFamiliesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load attribute families.'**
  String get sellerProductFamiliesFailed;

  /// No description provided for @sellerProductFamiliesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attribute families are available.'**
  String get sellerProductFamiliesEmpty;

  /// No description provided for @sellerProductSaveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get sellerProductSaveAsDraft;

  /// No description provided for @sellerProductNeedsVariants.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one attribute the product varies by'**
  String get sellerProductNeedsVariants;

  /// No description provided for @sellerProductLoadingVariants.
  ///
  /// In en, this message translates to:
  /// **'Loading options…'**
  String get sellerProductLoadingVariants;

  /// No description provided for @sellerProductVariesBy.
  ///
  /// In en, this message translates to:
  /// **'Varies by'**
  String get sellerProductVariesBy;

  /// No description provided for @sellerProductVariesByHelp.
  ///
  /// In en, this message translates to:
  /// **'Each selected option combination creates a variant. You can add combinations after saving the product.'**
  String get sellerProductVariesByHelp;

  /// No description provided for @sellerProductEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get sellerProductEditorTitle;

  /// No description provided for @sellerProductNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sellerProductNameLabel;

  /// No description provided for @sellerProductUrlKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'URL key'**
  String get sellerProductUrlKeyLabel;

  /// No description provided for @sellerProductNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Number'**
  String get sellerProductNumberLabel;

  /// No description provided for @sellerProductPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerProductPriceLabel;

  /// No description provided for @sellerProductSpecialPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'Special price from'**
  String get sellerProductSpecialPriceFrom;

  /// No description provided for @sellerProductSpecialPriceTo.
  ///
  /// In en, this message translates to:
  /// **'Special price to'**
  String get sellerProductSpecialPriceTo;

  /// No description provided for @sellerProductShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get sellerProductShortDescription;

  /// No description provided for @sellerProductFullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full description'**
  String get sellerProductFullDescription;

  /// No description provided for @sellerProductIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get sellerProductIdentity;

  /// No description provided for @sellerProductFlags.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get sellerProductFlags;

  /// No description provided for @sellerProductVisibleIndividually.
  ///
  /// In en, this message translates to:
  /// **'Visible individually'**
  String get sellerProductVisibleIndividually;

  /// No description provided for @sellerProductFeaturedFlag.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get sellerProductFeaturedFlag;

  /// No description provided for @sellerProductNewFlag.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get sellerProductNewFlag;

  /// No description provided for @sellerProductGuestCheckout.
  ///
  /// In en, this message translates to:
  /// **'Guest Checkout'**
  String get sellerProductGuestCheckout;

  /// No description provided for @sellerProductImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get sellerProductImages;

  /// No description provided for @sellerProductAddImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Add image URL'**
  String get sellerProductAddImageUrl;

  /// No description provided for @sellerProductPickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick from device'**
  String get sellerProductPickImage;

  /// No description provided for @sellerProductImageUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get sellerProductImageUrlHint;

  /// No description provided for @sellerProductVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get sellerProductVideos;

  /// No description provided for @sellerProductNoVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos'**
  String get sellerProductNoVideos;

  /// No description provided for @sellerProductAddVideoUrl.
  ///
  /// In en, this message translates to:
  /// **'Add video URL'**
  String get sellerProductAddVideoUrl;

  /// No description provided for @sellerProductPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick from device'**
  String get sellerProductPickVideo;

  /// No description provided for @sellerProductVideoUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get sellerProductVideoUrlHint;

  /// No description provided for @sellerProductVideoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Video must be 2MB or smaller'**
  String get sellerProductVideoTooLarge;

  /// No description provided for @sellerProductNoCategories.
  ///
  /// In en, this message translates to:
  /// **'The admin has not given this shop any categories to file products under.'**
  String get sellerProductNoCategories;

  /// No description provided for @sellerProductSaved.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get sellerProductSaved;

  /// No description provided for @sellerProductNoStockLocations.
  ///
  /// In en, this message translates to:
  /// **'Add a stock location before setting stock.'**
  String get sellerProductNoStockLocations;

  /// No description provided for @sellerProductEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sellerProductEditAction;

  /// No description provided for @sellerProductDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get sellerProductDeleteAction;

  /// No description provided for @sellerProductUnassignAction.
  ///
  /// In en, this message translates to:
  /// **'Stop selling this product'**
  String get sellerProductUnassignAction;

  /// No description provided for @sellerProductDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this product from the marketplace?'**
  String get sellerProductDeleteConfirm;

  /// No description provided for @sellerProductUnassignConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove your listing for this product?'**
  String get sellerProductUnassignConfirm;

  /// No description provided for @sellerProductDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get sellerProductDeleted;

  /// No description provided for @sellerProductsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String sellerProductsSelected(int count);

  /// No description provided for @sellerProductsDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get sellerProductsDeleteSelected;

  /// No description provided for @sellerProductsBulkResult.
  ///
  /// In en, this message translates to:
  /// **'{removed} removed, {skipped} skipped'**
  String sellerProductsBulkResult(int removed, int skipped);

  /// No description provided for @sellerTypeReplaceNotice.
  ///
  /// In en, this message translates to:
  /// **'This is what the product holds now. Saving sends the whole set back, so a row removed here is removed on the marketplace.'**
  String get sellerTypeReplaceNotice;

  /// No description provided for @sellerBundleNotice.
  ///
  /// In en, this message translates to:
  /// **'This is what the product holds now. Every option needs at least one product, or the server refuses the save.'**
  String get sellerBundleNotice;

  /// No description provided for @sellerBundleNeedsProduct.
  ///
  /// In en, this message translates to:
  /// **'Every bundle option needs at least one product. Add one, or remove the option.'**
  String get sellerBundleNeedsProduct;

  /// No description provided for @sellerPickProductHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or SKU'**
  String get sellerPickProductHint;

  /// No description provided for @sellerPickProductEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products match'**
  String get sellerPickProductEmpty;

  /// No description provided for @sellerVariantsNotice.
  ///
  /// In en, this message translates to:
  /// **'Edit variant details or add option combinations here.'**
  String get sellerVariantsNotice;

  /// No description provided for @sellerVariantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get sellerVariantsTitle;

  /// No description provided for @sellerGroupedTitle.
  ///
  /// In en, this message translates to:
  /// **'Grouped products'**
  String get sellerGroupedTitle;

  /// No description provided for @sellerGroupedAdd.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get sellerGroupedAdd;

  /// No description provided for @sellerRelatedProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related products'**
  String get sellerRelatedProductsTitle;

  /// No description provided for @sellerRelatedProductsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add related product'**
  String get sellerRelatedProductsAdd;

  /// No description provided for @sellerUpSellsTitle.
  ///
  /// In en, this message translates to:
  /// **'Up-sells'**
  String get sellerUpSellsTitle;

  /// No description provided for @sellerUpSellsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add up-sell'**
  String get sellerUpSellsAdd;

  /// No description provided for @sellerCrossSellsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cross-sells'**
  String get sellerCrossSellsTitle;

  /// No description provided for @sellerCrossSellsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add cross-sell'**
  String get sellerCrossSellsAdd;

  /// No description provided for @sellerBundleTitle.
  ///
  /// In en, this message translates to:
  /// **'Bundle options'**
  String get sellerBundleTitle;

  /// No description provided for @sellerBundleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add option'**
  String get sellerBundleAdd;

  /// No description provided for @sellerDownloadableTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloadable links'**
  String get sellerDownloadableTitle;

  /// No description provided for @sellerDownloadableAdd.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get sellerDownloadableAdd;

  /// No description provided for @sellerDownloadableSamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloadable samples'**
  String get sellerDownloadableSamplesTitle;

  /// No description provided for @sellerDownloadableSamplesNotice.
  ///
  /// In en, this message translates to:
  /// **'Free previews a shopper can download before buying. Saving sends the whole set back, so a row removed here is removed on the marketplace.'**
  String get sellerDownloadableSamplesNotice;

  /// No description provided for @sellerDownloadableSampleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add sample'**
  String get sellerDownloadableSampleAdd;

  /// No description provided for @sellerBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get sellerBookingTitle;

  /// No description provided for @sellerPickProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a product'**
  String get sellerPickProductTitle;

  /// No description provided for @sellerOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sellerOrdersTitle;

  /// No description provided for @sellerOrdersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get sellerOrdersEmpty;

  /// No description provided for @sellerOrdersEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Orders placed for your products will appear here.'**
  String get sellerOrdersEmptyHint;

  /// No description provided for @sellerOrdersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Order number, customer or status'**
  String get sellerOrdersSearchHint;

  /// No description provided for @sellerOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String sellerOrdersCount(int count);

  /// No description provided for @sellerOrderPayoutPending.
  ///
  /// In en, this message translates to:
  /// **'Invoice Pending'**
  String get sellerOrderPayoutPending;

  /// No description provided for @sellerOrderPayoutRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get sellerOrderPayoutRequested;

  /// No description provided for @sellerOrderPayoutPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get sellerOrderPayoutPaid;

  /// No description provided for @sellerOrderPayoutRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get sellerOrderPayoutRefunded;

  /// No description provided for @sellerOrderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get sellerOrderDetailTitle;

  /// No description provided for @sellerOrderItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get sellerOrderItems;

  /// No description provided for @sellerOrderTabInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get sellerOrderTabInformation;

  /// No description provided for @sellerOrderSubTotal.
  ///
  /// In en, this message translates to:
  /// **'Sub total'**
  String get sellerOrderSubTotal;

  /// No description provided for @sellerOrderTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get sellerOrderTax;

  /// No description provided for @sellerOrderDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get sellerOrderDiscount;

  /// No description provided for @sellerOrderShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping & handling'**
  String get sellerOrderShipping;

  /// No description provided for @sellerOrderSkuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU - {sku}'**
  String sellerOrderSkuLabel(String sku);

  /// No description provided for @sellerOrderPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerOrderPrice;

  /// No description provided for @sellerOrderTotalRefunded.
  ///
  /// In en, this message translates to:
  /// **'Total refunded'**
  String get sellerOrderTotalRefunded;

  /// No description provided for @sellerOrderTotalSellerAmount.
  ///
  /// In en, this message translates to:
  /// **'Total seller amount'**
  String get sellerOrderTotalSellerAmount;

  /// No description provided for @sellerOrderAdminCommission.
  ///
  /// In en, this message translates to:
  /// **'Admin commission'**
  String get sellerOrderAdminCommission;

  /// No description provided for @sellerOrderTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get sellerOrderTotalPaid;

  /// No description provided for @sellerOrderTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get sellerOrderTotalDue;

  /// No description provided for @sellerOrderGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get sellerOrderGrandTotal;

  /// No description provided for @sellerOrderOrdered.
  ///
  /// In en, this message translates to:
  /// **'Ordered'**
  String get sellerOrderOrdered;

  /// No description provided for @sellerOrderInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Invoiced'**
  String get sellerOrderInvoiced;

  /// No description provided for @sellerOrderShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get sellerOrderShipped;

  /// No description provided for @sellerOrderRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get sellerOrderRefunded;

  /// No description provided for @sellerOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get sellerOrderCancelled;

  /// No description provided for @sellerOrderInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get sellerOrderInvoice;

  /// No description provided for @sellerOrderShipment.
  ///
  /// In en, this message translates to:
  /// **'Shipment'**
  String get sellerOrderShipment;

  /// No description provided for @sellerOrderPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get sellerOrderPrint;

  /// No description provided for @sellerOrderNoInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices raised yet'**
  String get sellerOrderNoInvoices;

  /// No description provided for @sellerOrderNoShipments.
  ///
  /// In en, this message translates to:
  /// **'Nothing shipped yet'**
  String get sellerOrderNoShipments;

  /// No description provided for @sellerOrderBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'The carrier did not accept the booking'**
  String get sellerOrderBookingFailed;

  /// No description provided for @sellerOrderInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get sellerOrderInvoices;

  /// No description provided for @sellerOrderShipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get sellerOrderShipments;

  /// No description provided for @sellerOrderRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get sellerOrderRefunds;

  /// No description provided for @sellerOrderCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get sellerOrderCustomer;

  /// No description provided for @sellerOrderEarnings.
  ///
  /// In en, this message translates to:
  /// **'Your earnings'**
  String get sellerOrderEarnings;

  /// No description provided for @sellerOrderCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get sellerOrderCommission;

  /// No description provided for @sellerOrderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get sellerOrderTotal;

  /// No description provided for @sellerOrderItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get sellerOrderItemsLabel;

  /// No description provided for @sellerOrdersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sellerOrdersFilterAll;

  /// No description provided for @sellerOrderCreateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create invoice'**
  String get sellerOrderCreateInvoice;

  /// No description provided for @sellerOrderCreateShipment.
  ///
  /// In en, this message translates to:
  /// **'Create shipment'**
  String get sellerOrderCreateShipment;

  /// No description provided for @sellerOrderCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get sellerOrderCancelAction;

  /// No description provided for @sellerOrderRequestPayment.
  ///
  /// In en, this message translates to:
  /// **'Request payment'**
  String get sellerOrderRequestPayment;

  /// No description provided for @sellerOrderPaymentConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get sellerOrderPaymentConfirmTitle;

  /// No description provided for @sellerOrderPaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to perform this action?'**
  String get sellerOrderPaymentConfirm;

  /// No description provided for @sellerOrderPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your payment request is submitted successfully'**
  String get sellerOrderPaymentSuccess;

  /// No description provided for @sellerOrderSchedulePickup.
  ///
  /// In en, this message translates to:
  /// **'Schedule Pickup'**
  String get sellerOrderSchedulePickup;

  /// No description provided for @sellerOrderCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel your items on this order?'**
  String get sellerOrderCancelConfirm;

  /// No description provided for @sellerOrderInvoiceCreated.
  ///
  /// In en, this message translates to:
  /// **'Invoice created'**
  String get sellerOrderInvoiceCreated;

  /// No description provided for @sellerOrderShipmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Shipment created'**
  String get sellerOrderShipmentCreated;

  /// No description provided for @sellerOrderPaymentRequested.
  ///
  /// In en, this message translates to:
  /// **'Payment requested'**
  String get sellerOrderPaymentRequested;

  /// No description provided for @sellerOrderCarrier.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get sellerOrderCarrier;

  /// No description provided for @sellerOrderTrackingNumber.
  ///
  /// In en, this message translates to:
  /// **'Tracking number'**
  String get sellerOrderTrackingNumber;

  /// No description provided for @sellerOrderParcel.
  ///
  /// In en, this message translates to:
  /// **'Parcel'**
  String get sellerOrderParcel;

  /// No description provided for @sellerOrderPickup.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get sellerOrderPickup;

  /// No description provided for @sellerOrderPickupDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get sellerOrderPickupDate;

  /// No description provided for @sellerOrderPickupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions for the driver'**
  String get sellerOrderPickupInstructions;

  /// No description provided for @sellerOrderShipFrom.
  ///
  /// In en, this message translates to:
  /// **'Ship from'**
  String get sellerOrderShipFrom;

  /// No description provided for @sellerOrderQtyToInvoice.
  ///
  /// In en, this message translates to:
  /// **'To invoice'**
  String get sellerOrderQtyToInvoice;

  /// No description provided for @sellerOrderQtyToShip.
  ///
  /// In en, this message translates to:
  /// **'To ship'**
  String get sellerOrderQtyToShip;

  /// No description provided for @sellerOrderNothingToInvoice.
  ///
  /// In en, this message translates to:
  /// **'Everything is invoiced already'**
  String get sellerOrderNothingToInvoice;

  /// No description provided for @sellerOrderNothingToShip.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting to ship'**
  String get sellerOrderNothingToShip;

  /// No description provided for @sellerOrderDownloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download invoice'**
  String get sellerOrderDownloadInvoice;

  /// No description provided for @sellerOrderNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include order access.'**
  String get sellerOrderNoPermission;

  /// No description provided for @sellerEarningsMenu.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get sellerEarningsMenu;

  /// No description provided for @sellerEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get sellerEarningsTitle;

  /// No description provided for @sellerEarningsTotalSale.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get sellerEarningsTotalSale;

  /// No description provided for @sellerEarningsYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share'**
  String get sellerEarningsYourShare;

  /// No description provided for @sellerEarningsCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get sellerEarningsCommission;

  /// No description provided for @sellerEarningsPaidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get sellerEarningsPaidOut;

  /// No description provided for @sellerEarningsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payout'**
  String get sellerEarningsRemaining;

  /// No description provided for @sellerEarningsTransactions.
  ///
  /// In en, this message translates to:
  /// **'Payout history'**
  String get sellerEarningsTransactions;

  /// No description provided for @sellerEarningsNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No payouts recorded yet'**
  String get sellerEarningsNoTransactions;

  /// No description provided for @sellerEarningsDownloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download receipt'**
  String get sellerEarningsDownloadReceipt;

  /// No description provided for @sellerEarningsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include payout access.'**
  String get sellerEarningsNoPermission;

  /// No description provided for @sellerReportsMenu.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get sellerReportsMenu;

  /// No description provided for @sellerReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get sellerReportsTitle;

  /// No description provided for @sellerReportsFormatGraph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get sellerReportsFormatGraph;

  /// No description provided for @sellerReportsFormatTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get sellerReportsFormatTable;

  /// No description provided for @sellerReportsPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get sellerReportsPeriodDay;

  /// No description provided for @sellerReportsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get sellerReportsPeriodMonth;

  /// No description provided for @sellerReportsPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get sellerReportsPeriodYear;

  /// No description provided for @sellerReportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No figures for this period'**
  String get sellerReportsEmpty;

  /// No description provided for @sellerReportsNone.
  ///
  /// In en, this message translates to:
  /// **'No reports are available to your role.'**
  String get sellerReportsNone;

  /// No description provided for @sellerReportsExport.
  ///
  /// In en, this message translates to:
  /// **'Export as spreadsheet'**
  String get sellerReportsExport;

  /// No description provided for @sellerReportsViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get sellerReportsViewDetails;

  /// No description provided for @sellerReportsVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'vs previous period'**
  String get sellerReportsVsPrevious;

  /// No description provided for @sellerReportsEntitySales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sellerReportsEntitySales;

  /// No description provided for @sellerReportsEntityProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerReportsEntityProducts;

  /// No description provided for @sellerReportsEntityCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerReportsEntityCustomers;

  /// No description provided for @sellerAssignMenu.
  ///
  /// In en, this message translates to:
  /// **'Sell an existing product'**
  String get sellerAssignMenu;

  /// No description provided for @sellerAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell yours'**
  String get sellerAssignTitle;

  /// No description provided for @sellerAssignSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the marketplace catalogue'**
  String get sellerAssignSearchHint;

  /// No description provided for @sellerAssignEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here you can sell yet'**
  String get sellerAssignEmpty;

  /// No description provided for @sellerAssignAction.
  ///
  /// In en, this message translates to:
  /// **'Sell this'**
  String get sellerAssignAction;

  /// No description provided for @sellerAssignAlreadySelling.
  ///
  /// In en, this message translates to:
  /// **'You are already selling this product'**
  String get sellerAssignAlreadySelling;

  /// No description provided for @sellerAssignSellersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sellers yet} =1{1 seller} other{{count} sellers}}'**
  String sellerAssignSellersCount(int count);

  /// No description provided for @sellerAssignLowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest offer'**
  String get sellerAssignLowestPrice;

  /// No description provided for @sellerAssignYourPrice.
  ///
  /// In en, this message translates to:
  /// **'Your price'**
  String get sellerAssignYourPrice;

  /// No description provided for @sellerAssignCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get sellerAssignCondition;

  /// No description provided for @sellerAssignConditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get sellerAssignConditionNew;

  /// No description provided for @sellerAssignConditionOld.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get sellerAssignConditionOld;

  /// No description provided for @sellerAssignDescription.
  ///
  /// In en, this message translates to:
  /// **'Your description'**
  String get sellerAssignDescription;

  /// No description provided for @sellerAssignStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get sellerAssignStock;

  /// No description provided for @sellerAssignSubmit.
  ///
  /// In en, this message translates to:
  /// **'Start selling'**
  String get sellerAssignSubmit;

  /// No description provided for @sellerAssignDone.
  ///
  /// In en, this message translates to:
  /// **'Listed. It goes live once the marketplace approves it.'**
  String get sellerAssignDone;

  /// No description provided for @sellerAssignNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include selling existing products.'**
  String get sellerAssignNoPermission;

  /// No description provided for @sellerBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get sellerBarcodeTitle;

  /// No description provided for @sellerBarcodeMenu.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get sellerBarcodeMenu;

  /// No description provided for @sellerBarcodeNone.
  ///
  /// In en, this message translates to:
  /// **'No barcode generated yet'**
  String get sellerBarcodeNone;

  /// No description provided for @sellerBarcodeGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate barcode'**
  String get sellerBarcodeGenerate;

  /// No description provided for @sellerBarcodeRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get sellerBarcodeRegenerate;

  /// No description provided for @sellerBarcodeSymbology.
  ///
  /// In en, this message translates to:
  /// **'Symbology'**
  String get sellerBarcodeSymbology;

  /// No description provided for @sellerBarcodeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get sellerBarcodeDownload;

  /// No description provided for @sellerBarcodeBulkGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate barcodes'**
  String get sellerBarcodeBulkGenerate;

  /// No description provided for @sellerBarcodeBulkPrint.
  ///
  /// In en, this message translates to:
  /// **'Print barcodes'**
  String get sellerBarcodeBulkPrint;

  /// No description provided for @sellerBarcodeBatchResult.
  ///
  /// In en, this message translates to:
  /// **'{generated} generated, {skipped} skipped'**
  String sellerBarcodeBatchResult(int generated, int skipped);

  /// No description provided for @sellerBarcodeNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include barcodes.'**
  String get sellerBarcodeNoPermission;

  /// No description provided for @sellerMagicAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Magic AI'**
  String get sellerMagicAiTitle;

  /// No description provided for @sellerMagicAiMenu.
  ///
  /// In en, this message translates to:
  /// **'Fill in with Magic AI'**
  String get sellerMagicAiMenu;

  /// No description provided for @sellerMagicAiPrompt.
  ///
  /// In en, this message translates to:
  /// **'Describe the product'**
  String get sellerMagicAiPrompt;

  /// No description provided for @sellerMagicAiPromptHint.
  ///
  /// In en, this message translates to:
  /// **'A brass desk lamp with a warm dimmable bulb'**
  String get sellerMagicAiPromptHint;

  /// No description provided for @sellerMagicAiGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get sellerMagicAiGenerate;

  /// No description provided for @sellerMagicAiFields.
  ///
  /// In en, this message translates to:
  /// **'Fields to fill'**
  String get sellerMagicAiFields;

  /// No description provided for @sellerMagicAiSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested values'**
  String get sellerMagicAiSuggested;

  /// No description provided for @sellerMagicAiSkipped.
  ///
  /// In en, this message translates to:
  /// **'Not filled'**
  String get sellerMagicAiSkipped;

  /// No description provided for @sellerMagicAiApply.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get sellerMagicAiApply;

  /// No description provided for @sellerMagicAiCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get sellerMagicAiCopied;

  /// No description provided for @sellerMagicAiOffGlobally.
  ///
  /// In en, this message translates to:
  /// **'The marketplace has Magic AI switched off.'**
  String get sellerMagicAiOffGlobally;

  /// No description provided for @sellerMagicAiOff.
  ///
  /// In en, this message translates to:
  /// **'Magic AI is unavailable for this product.'**
  String get sellerMagicAiOff;

  /// No description provided for @sellerReturnsMenu.
  ///
  /// In en, this message translates to:
  /// **'RMA'**
  String get sellerReturnsMenu;

  /// No description provided for @sellerReturnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Return requests'**
  String get sellerReturnsTitle;

  /// No description provided for @sellerReturnsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by order, product or customer'**
  String get sellerReturnsSearchHint;

  /// No description provided for @sellerReturnsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No return requests'**
  String get sellerReturnsEmpty;

  /// No description provided for @sellerReturnsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include returns.'**
  String get sellerReturnsNoPermission;

  /// No description provided for @sellerReturnDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Return request'**
  String get sellerReturnDetailTitle;

  /// No description provided for @sellerReturnResolution.
  ///
  /// In en, this message translates to:
  /// **'Wanted'**
  String get sellerReturnResolution;

  /// No description provided for @sellerReturnStepPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sellerReturnStepPending;

  /// No description provided for @sellerReturnStepApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sellerReturnStepApproved;

  /// No description provided for @sellerReturnStepAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting return'**
  String get sellerReturnStepAwaiting;

  /// No description provided for @sellerReturnStepTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get sellerReturnStepTransit;

  /// No description provided for @sellerReturnStepRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get sellerReturnStepRefunded;

  /// No description provided for @sellerReturnStepDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get sellerReturnStepDeclined;

  /// No description provided for @sellerReturnStepCancelled.
  ///
  /// In en, this message translates to:
  /// **'Item cancelled'**
  String get sellerReturnStepCancelled;

  /// No description provided for @sellerReturnStepWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get sellerReturnStepWithdrawn;

  /// No description provided for @sellerReturnReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get sellerReturnReason;

  /// No description provided for @sellerReturnQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get sellerReturnQuantity;

  /// No description provided for @sellerReturnPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get sellerReturnPackage;

  /// No description provided for @sellerReturnCustomerNote.
  ///
  /// In en, this message translates to:
  /// **'What the customer said'**
  String get sellerReturnCustomerNote;

  /// No description provided for @sellerReturnPhotos.
  ///
  /// In en, this message translates to:
  /// **'Customer photos'**
  String get sellerReturnPhotos;

  /// No description provided for @sellerReturnConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get sellerReturnConversation;

  /// No description provided for @sellerReturnReply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get sellerReturnReply;

  /// No description provided for @sellerReturnSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sellerReturnSend;

  /// No description provided for @sellerReturnChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get sellerReturnChangeStatus;

  /// No description provided for @sellerReturnReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen request'**
  String get sellerReturnReopen;

  /// No description provided for @sellerReturnStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'This request can no longer change status.'**
  String get sellerReturnStatusLocked;

  /// No description provided for @sellerReturnRefundWarning.
  ///
  /// In en, this message translates to:
  /// **'This refunds the returned item. It cannot be undone.'**
  String get sellerReturnRefundWarning;

  /// No description provided for @sellerReturnCancelWarning.
  ///
  /// In en, this message translates to:
  /// **'This cancels the item on the order. It cannot be undone.'**
  String get sellerReturnCancelWarning;

  /// No description provided for @sellerReturnNotInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Not invoiced yet'**
  String get sellerReturnNotInvoiced;

  /// No description provided for @sellerBookingsMenu.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get sellerBookingsMenu;

  /// No description provided for @sellerBookingsFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get sellerBookingsFilters;

  /// No description provided for @sellerBookingsFilterOrder.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get sellerBookingsFilterOrder;

  /// No description provided for @sellerBookingsFilterProduct.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get sellerBookingsFilterProduct;

  /// No description provided for @sellerBookingsFilterId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get sellerBookingsFilterId;

  /// No description provided for @sellerBookingsFilterQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get sellerBookingsFilterQty;

  /// No description provided for @sellerBookingsFilterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get sellerBookingsFilterFrom;

  /// No description provided for @sellerBookingsFilterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get sellerBookingsFilterTo;

  /// No description provided for @sellerBookingsFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get sellerBookingsFilterApply;

  /// No description provided for @sellerBookingsFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get sellerBookingsFilterClear;

  /// No description provided for @sellerBookingsFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sellerBookingsFilterToday;

  /// No description provided for @sellerBookingsFilterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get sellerBookingsFilterThisWeek;

  /// No description provided for @sellerBookingsFilterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get sellerBookingsFilterThisMonth;

  /// No description provided for @sellerBookingsFilterLast3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get sellerBookingsFilterLast3Months;

  /// No description provided for @sellerBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get sellerBookingsTitle;

  /// No description provided for @sellerBookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No slots booked'**
  String get sellerBookingsEmpty;

  /// No description provided for @sellerBookingsAllDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get sellerBookingsAllDates;

  /// No description provided for @sellerBookingsPickRange.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get sellerBookingsPickRange;

  /// No description provided for @sellerBookingsCalendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get sellerBookingsCalendarView;

  /// No description provided for @sellerBookingsListView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get sellerBookingsListView;

  /// No description provided for @sellerBookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get sellerBookingDetailsTitle;

  /// No description provided for @sellerBookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get sellerBookingDate;

  /// No description provided for @sellerBookingTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get sellerBookingTimeSlot;

  /// No description provided for @sellerBookingOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Id'**
  String get sellerBookingOrderIdLabel;

  /// No description provided for @sellerBookingViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get sellerBookingViewDetails;

  /// No description provided for @sellerBookingsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include bookings.'**
  String get sellerBookingsNoPermission;

  /// No description provided for @sellerBookingSlot.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get sellerBookingSlot;

  /// No description provided for @sellerBookingGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get sellerBookingGuests;

  /// No description provided for @sellerBookingContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get sellerBookingContact;

  /// No description provided for @sellerBookingCancellable.
  ///
  /// In en, this message translates to:
  /// **'Cancellation allowed'**
  String get sellerBookingCancellable;

  /// No description provided for @sellerCustomersMenu.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerCustomersMenu;

  /// No description provided for @sellerCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerCustomersTitle;

  /// No description provided for @sellerCustomersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get sellerCustomersSearchHint;

  /// No description provided for @sellerCustomersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get sellerCustomersEmpty;

  /// No description provided for @sellerCustomersNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include customers.'**
  String get sellerCustomersNoPermission;

  /// No description provided for @sellerCustomerRevenue.
  ///
  /// In en, this message translates to:
  /// **'Spent with you'**
  String get sellerCustomerRevenue;

  /// No description provided for @sellerCustomerOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sellerCustomerOrders;

  /// No description provided for @sellerCustomerActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerCustomerActive;

  /// No description provided for @sellerCustomerInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get sellerCustomerInactive;

  /// No description provided for @sellerProductAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get sellerProductAssigned;

  /// No description provided for @sellerProductOwn.
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get sellerProductOwn;

  /// No description provided for @sellerProductDraftBadge.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get sellerProductDraftBadge;

  /// No description provided for @sellerTransactionOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get sellerTransactionOrder;

  /// No description provided for @sellerReviewsMenu.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get sellerReviewsMenu;

  /// No description provided for @sellerReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get sellerReviewsTitle;

  /// No description provided for @sellerReviewsOnProducts.
  ///
  /// In en, this message translates to:
  /// **'On products'**
  String get sellerReviewsOnProducts;

  /// No description provided for @sellerReviewsOnShop.
  ///
  /// In en, this message translates to:
  /// **'On your shop'**
  String get sellerReviewsOnShop;

  /// No description provided for @sellerReviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get sellerReviewsEmpty;

  /// No description provided for @sellerReviewsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include reviews.'**
  String get sellerReviewsNoPermission;

  /// No description provided for @sellerReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sellerReviewPending;

  /// No description provided for @sellerReviewApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sellerReviewApproved;

  /// No description provided for @sellerReviewDisapproved.
  ///
  /// In en, this message translates to:
  /// **'Not published'**
  String get sellerReviewDisapproved;

  /// No description provided for @sellerReviewDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sellerReviewDate;

  /// No description provided for @sellerMarketingMenu.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get sellerMarketingMenu;

  /// No description provided for @sellerMarketingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get sellerMarketingTitle;

  /// No description provided for @sellerMarketingDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Product discounts'**
  String get sellerMarketingDiscounts;

  /// No description provided for @sellerMarketingJoinable.
  ///
  /// In en, this message translates to:
  /// **'Join product discounts'**
  String get sellerMarketingJoinable;

  /// No description provided for @sellerMarketingDeals.
  ///
  /// In en, this message translates to:
  /// **'Checkout deals'**
  String get sellerMarketingDeals;

  /// No description provided for @sellerMarketingNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include marketing.'**
  String get sellerMarketingNoPermission;

  /// No description provided for @sellerMarketingEmptyDiscounts.
  ///
  /// In en, this message translates to:
  /// **'No product discounts yet'**
  String get sellerMarketingEmptyDiscounts;

  /// No description provided for @sellerMarketingEmptyJoinable.
  ///
  /// In en, this message translates to:
  /// **'No discounts are open to join right now'**
  String get sellerMarketingEmptyJoinable;

  /// No description provided for @sellerMarketingEmptyDeals.
  ///
  /// In en, this message translates to:
  /// **'No checkout deals yet'**
  String get sellerMarketingEmptyDeals;

  /// No description provided for @sellerMarketingJoin.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get sellerMarketingJoin;

  /// No description provided for @sellerMarketingLeave.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get sellerMarketingLeave;

  /// No description provided for @sellerMarketingJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get sellerMarketingJoined;

  /// No description provided for @sellerMarketingNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Not Enrolled'**
  String get sellerMarketingNotEnrolled;

  /// No description provided for @sellerMarketingParticipation.
  ///
  /// In en, this message translates to:
  /// **'Participation'**
  String get sellerMarketingParticipation;

  /// No description provided for @sellerMarketingNewDiscount.
  ///
  /// In en, this message translates to:
  /// **'New discount'**
  String get sellerMarketingNewDiscount;

  /// No description provided for @sellerMarketingNewDeal.
  ///
  /// In en, this message translates to:
  /// **'New deal'**
  String get sellerMarketingNewDeal;

  /// No description provided for @sellerMarketingName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sellerMarketingName;

  /// No description provided for @sellerMarketingDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerMarketingDescription;

  /// No description provided for @sellerMarketingActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerMarketingActive;

  /// No description provided for @sellerMarketingInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get sellerMarketingInactive;

  /// No description provided for @sellerMarketingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get sellerMarketingScheduled;

  /// No description provided for @sellerMarketingExpired.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get sellerMarketingExpired;

  /// No description provided for @sellerMarketingDiscountType.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get sellerMarketingDiscountType;

  /// No description provided for @sellerMarketingAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sellerMarketingAmount;

  /// No description provided for @sellerMarketingDiscountPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount Percent (%)'**
  String get sellerMarketingDiscountPercentLabel;

  /// No description provided for @sellerMarketingDiscountAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get sellerMarketingDiscountAmountLabel;

  /// No description provided for @sellerRuleMaxDiscountedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Maximum Discounted Quantity'**
  String get sellerRuleMaxDiscountedQuantity;

  /// No description provided for @sellerMarketingStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get sellerMarketingStarts;

  /// No description provided for @sellerMarketingEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get sellerMarketingEnds;

  /// No description provided for @sellerMarketingNeedsCoupon.
  ///
  /// In en, this message translates to:
  /// **'Needs a coupon code'**
  String get sellerMarketingNeedsCoupon;

  /// No description provided for @sellerMarketingAutoCoupons.
  ///
  /// In en, this message translates to:
  /// **'Generate a batch of codes'**
  String get sellerMarketingAutoCoupons;

  /// No description provided for @sellerMarketingCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get sellerMarketingCouponCode;

  /// No description provided for @sellerMarketingUsesPerCoupon.
  ///
  /// In en, this message translates to:
  /// **'Uses per code'**
  String get sellerMarketingUsesPerCoupon;

  /// No description provided for @sellerMarketingUsagePerCustomer.
  ///
  /// In en, this message translates to:
  /// **'Uses per customer'**
  String get sellerMarketingUsagePerCustomer;

  /// No description provided for @sellerMarketingCopyDeal.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get sellerMarketingCopyDeal;

  /// No description provided for @sellerMarketingDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this permanently?'**
  String get sellerMarketingDeleteConfirm;

  /// No description provided for @sellerMarketingTimesUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get sellerMarketingTimesUsed;

  /// No description provided for @sellerCouponsTitle.
  ///
  /// In en, this message translates to:
  /// **'Coupon codes'**
  String get sellerCouponsTitle;

  /// No description provided for @sellerCouponsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No codes generated yet'**
  String get sellerCouponsEmpty;

  /// No description provided for @sellerCouponsGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate codes'**
  String get sellerCouponsGenerate;

  /// No description provided for @sellerCouponsQuantity.
  ///
  /// In en, this message translates to:
  /// **'How many'**
  String get sellerCouponsQuantity;

  /// No description provided for @sellerCouponsLength.
  ///
  /// In en, this message translates to:
  /// **'Code length'**
  String get sellerCouponsLength;

  /// No description provided for @sellerCouponsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get sellerCouponsPrefix;

  /// No description provided for @sellerCouponsMinLength.
  ///
  /// In en, this message translates to:
  /// **'Codes must be at least 10 characters.'**
  String get sellerCouponsMinLength;

  /// No description provided for @sellerCouponsSpent.
  ///
  /// In en, this message translates to:
  /// **'Used up'**
  String get sellerCouponsSpent;

  /// No description provided for @sellerBulkMenu.
  ///
  /// In en, this message translates to:
  /// **'Manage Pricing'**
  String get sellerBulkMenu;

  /// No description provided for @sellerBulkTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk edit'**
  String get sellerBulkTitle;

  /// No description provided for @sellerBulkPricingTab.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get sellerBulkPricingTab;

  /// No description provided for @sellerBulkPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerBulkPrice;

  /// No description provided for @sellerBulkSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get sellerBulkSalePrice;

  /// No description provided for @sellerBulkValidFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get sellerBulkValidFrom;

  /// No description provided for @sellerBulkValidTo.
  ///
  /// In en, this message translates to:
  /// **'Valid to'**
  String get sellerBulkValidTo;

  /// No description provided for @sellerBulkResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String sellerBulkResults(int count);

  /// No description provided for @sellerBulkStockTab.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get sellerBulkStockTab;

  /// No description provided for @sellerBulkSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get sellerBulkSave;

  /// No description provided for @sellerBulkDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get sellerBulkDiscard;

  /// No description provided for @sellerBulkPending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change} other{{count} changes}}'**
  String sellerBulkPending(int count);

  /// No description provided for @sellerBulkSaved.
  ///
  /// In en, this message translates to:
  /// **'{saved} saved, {skipped} skipped'**
  String sellerBulkSaved(int saved, int skipped);

  /// No description provided for @sellerBulkSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prices saved successfully.'**
  String get sellerBulkSavedSuccess;

  /// No description provided for @sellerBulkNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include bulk editing.'**
  String get sellerBulkNoPermission;

  /// No description provided for @sellerBulkSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} selected'**
  String sellerBulkSelected(int count, int total);

  /// No description provided for @sellerBulkSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get sellerBulkSelectAll;

  /// No description provided for @sellerBulkAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get sellerBulkAction;

  /// No description provided for @sellerBulkValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get sellerBulkValue;

  /// No description provided for @sellerBulkApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get sellerBulkApply;

  /// No description provided for @sellerBulkSetTo.
  ///
  /// In en, this message translates to:
  /// **'Set to'**
  String get sellerBulkSetTo;

  /// No description provided for @sellerBulkIncreaseBy.
  ///
  /// In en, this message translates to:
  /// **'Increase by'**
  String get sellerBulkIncreaseBy;

  /// No description provided for @sellerBulkDecreaseBy.
  ///
  /// In en, this message translates to:
  /// **'Decrease by'**
  String get sellerBulkDecreaseBy;

  /// No description provided for @sellerBulkQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get sellerBulkQuantity;

  /// No description provided for @sellerBulkMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get sellerBulkMode;

  /// No description provided for @sellerBulkTiers.
  ///
  /// In en, this message translates to:
  /// **'Customer group prices'**
  String get sellerBulkTiers;

  /// No description provided for @sellerBulkTiersNotice.
  ///
  /// In en, this message translates to:
  /// **'What this product holds now. Saving replaces every group price it has.'**
  String get sellerBulkTiersNotice;

  /// No description provided for @sellerBulkTierAllGroups.
  ///
  /// In en, this message translates to:
  /// **'All groups'**
  String get sellerBulkTierAllGroups;

  /// No description provided for @sellerBulkTierAdd.
  ///
  /// In en, this message translates to:
  /// **'Add group price'**
  String get sellerBulkTierAdd;

  /// No description provided for @sellerBulkTierGroup.
  ///
  /// In en, this message translates to:
  /// **'Customer group'**
  String get sellerBulkTierGroup;

  /// No description provided for @sellerBulkTierFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get sellerBulkTierFixed;

  /// No description provided for @sellerBulkTierDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount (%)'**
  String get sellerBulkTierDiscount;

  /// No description provided for @sellerBulkAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sellerBulkAmount;

  /// No description provided for @sellerBulkPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent (%)'**
  String get sellerBulkPercent;

  /// No description provided for @sellerBulkActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get sellerBulkActivate;

  /// No description provided for @sellerBulkDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get sellerBulkDeactivate;

  /// No description provided for @sellerImportsMenu.
  ///
  /// In en, this message translates to:
  /// **'Bulk upload'**
  String get sellerImportsMenu;

  /// No description provided for @sellerImportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk upload'**
  String get sellerImportsTitle;

  /// No description provided for @sellerImportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No uploads yet'**
  String get sellerImportsEmpty;

  /// No description provided for @sellerImportsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include bulk upload.'**
  String get sellerImportsNoPermission;

  /// No description provided for @sellerImportsSamples.
  ///
  /// In en, this message translates to:
  /// **'Starter spreadsheets'**
  String get sellerImportsSamples;

  /// No description provided for @sellerImportsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload sheet'**
  String get sellerImportsUpload;

  /// No description provided for @sellerImportOwnTitle.
  ///
  /// In en, this message translates to:
  /// **'List your own products'**
  String get sellerImportOwnTitle;

  /// No description provided for @sellerImportCatalogueTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell catalogue products'**
  String get sellerImportCatalogueTitle;

  /// No description provided for @sellerImportOwnBlurb.
  ///
  /// In en, this message translates to:
  /// **'Bulk create new products in your catalogue from a spreadsheet.'**
  String get sellerImportOwnBlurb;

  /// No description provided for @sellerImportCatalogueBlurb.
  ///
  /// In en, this message translates to:
  /// **'Add products already in the marketplace catalogue to your store, at your own price and stock.'**
  String get sellerImportCatalogueBlurb;

  /// No description provided for @sellerImportSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sellerImportSource;

  /// No description provided for @sellerImportSourceHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the file to import.'**
  String get sellerImportSourceHelp;

  /// No description provided for @sellerImportRequiredColumns.
  ///
  /// In en, this message translates to:
  /// **'Every row must fill in these columns'**
  String get sellerImportRequiredColumns;

  /// No description provided for @sellerImportCatalogueSheetHelp.
  ///
  /// In en, this message translates to:
  /// **'Each row needs the catalogue product SKU plus your selling details: price, stock quantity, condition and an optional description. Images come from the catalogue product.'**
  String get sellerImportCatalogueSheetHelp;

  /// No description provided for @sellerImportFile.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet'**
  String get sellerImportFile;

  /// No description provided for @sellerImportImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get sellerImportImages;

  /// No description provided for @sellerImportImagesHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional. A flat zip whose file names match the sheet’s images column. Rows that name images by URL need no zip.'**
  String get sellerImportImagesHelp;

  /// No description provided for @sellerImportImagesZip.
  ///
  /// In en, this message translates to:
  /// **'Images zip'**
  String get sellerImportImagesZip;

  /// No description provided for @sellerImportSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerImportSettings;

  /// No description provided for @sellerImportSettingsHelp.
  ///
  /// In en, this message translates to:
  /// **'How strictly the sheet is read, and how it is run.'**
  String get sellerImportSettingsHelp;

  /// No description provided for @sellerImportAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get sellerImportAction;

  /// No description provided for @sellerImportValidation.
  ///
  /// In en, this message translates to:
  /// **'Bad rows'**
  String get sellerImportValidation;

  /// No description provided for @sellerImportAllowedErrors.
  ///
  /// In en, this message translates to:
  /// **'Errors allowed'**
  String get sellerImportAllowedErrors;

  /// No description provided for @sellerImportEditSettings.
  ///
  /// In en, this message translates to:
  /// **'Edit settings'**
  String get sellerImportEditSettings;

  /// No description provided for @sellerImportReimport.
  ///
  /// In en, this message translates to:
  /// **'Reimport'**
  String get sellerImportReimport;

  /// No description provided for @sellerImportEditResets.
  ///
  /// In en, this message translates to:
  /// **'Changing these resets the job, so the sheet is read again from the start.'**
  String get sellerImportEditResets;

  /// No description provided for @sellerImportCurrentSheet.
  ///
  /// In en, this message translates to:
  /// **'Current uploaded file'**
  String get sellerImportCurrentSheet;

  /// No description provided for @sellerImportNewSheet.
  ///
  /// In en, this message translates to:
  /// **'New file selected'**
  String get sellerImportNewSheet;

  /// No description provided for @sellerImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get sellerImportConfirmTitle;

  /// No description provided for @sellerImportConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will validate your file and start the import. Do you want to continue?'**
  String get sellerImportConfirmMessage;

  /// No description provided for @sellerImportDownloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download the sheet'**
  String get sellerImportDownloadFile;

  /// No description provided for @sellerImportSeparator.
  ///
  /// In en, this message translates to:
  /// **'Column separator'**
  String get sellerImportSeparator;

  /// No description provided for @sellerImportQueue.
  ///
  /// In en, this message translates to:
  /// **'Run in the background'**
  String get sellerImportQueue;

  /// No description provided for @sellerImportQueueHelp.
  ///
  /// In en, this message translates to:
  /// **'Hands the whole run to the queue worker. Needs a queue configured on the server.'**
  String get sellerImportQueueHelp;

  /// No description provided for @sellerImportBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get sellerImportBack;

  /// No description provided for @sellerImportNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get sellerImportNext;

  /// No description provided for @sellerImportStart.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get sellerImportStart;

  /// No description provided for @sellerImportChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to add products in bulk.'**
  String get sellerImportChoose;

  /// No description provided for @sellerImportPastUploads.
  ///
  /// In en, this message translates to:
  /// **'Past uploads'**
  String get sellerImportPastUploads;

  /// No description provided for @sellerImportReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get sellerImportReportTitle;

  /// No description provided for @sellerImportCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sellerImportCreated;

  /// No description provided for @sellerImportUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get sellerImportUpdated;

  /// No description provided for @sellerImportRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get sellerImportRemoved;

  /// No description provided for @sellerImportSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get sellerImportSkipped;

  /// No description provided for @sellerImportImagesFetched.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get sellerImportImagesFetched;

  /// No description provided for @sellerImportDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get sellerImportDeleteSelected;

  /// No description provided for @sellerDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get sellerDownloadStarted;

  /// No description provided for @sellerDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'That file could not be downloaded'**
  String get sellerDownloadFailed;

  /// No description provided for @sellerDownloadNoApp.
  ///
  /// In en, this message translates to:
  /// **'No app on this device can open that file'**
  String get sellerDownloadNoApp;

  /// No description provided for @sellerImportsRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get sellerImportsRun;

  /// No description provided for @sellerImportsNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next: {step}'**
  String sellerImportsNextStep(String step);

  /// No description provided for @sellerImportsFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get sellerImportsFinished;

  /// No description provided for @sellerImportProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get sellerImportProcessTitle;

  /// No description provided for @sellerImportReady.
  ///
  /// In en, this message translates to:
  /// **'Validate the file to check your import.'**
  String get sellerImportReady;

  /// No description provided for @sellerImportValidateAction.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get sellerImportValidateAction;

  /// No description provided for @sellerImportValidating.
  ///
  /// In en, this message translates to:
  /// **'Reading and validating your file…'**
  String get sellerImportValidating;

  /// No description provided for @sellerImportRowsValidated.
  ///
  /// In en, this message translates to:
  /// **'{processed} / {total} rows validated'**
  String sellerImportRowsValidated(int processed, int total);

  /// No description provided for @sellerImportDownloadingImages.
  ///
  /// In en, this message translates to:
  /// **'Downloading product images…'**
  String get sellerImportDownloadingImages;

  /// No description provided for @sellerImportImagesProgress.
  ///
  /// In en, this message translates to:
  /// **'{processed} / {total} images downloaded'**
  String sellerImportImagesProgress(int processed, int total);

  /// No description provided for @sellerImportCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating your products…'**
  String get sellerImportCreating;

  /// No description provided for @sellerImportAssigning.
  ///
  /// In en, this message translates to:
  /// **'Adding the products to your store…'**
  String get sellerImportAssigning;

  /// No description provided for @sellerImportDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting your products…'**
  String get sellerImportDeleting;

  /// No description provided for @sellerImportLinking.
  ///
  /// In en, this message translates to:
  /// **'Connecting related products…'**
  String get sellerImportLinking;

  /// No description provided for @sellerImportIndexing.
  ///
  /// In en, this message translates to:
  /// **'Finalising prices and stock…'**
  String get sellerImportIndexing;

  /// No description provided for @sellerImportValid.
  ///
  /// In en, this message translates to:
  /// **'Your file is valid. Start the import when you are ready.'**
  String get sellerImportValid;

  /// No description provided for @sellerImportPartly.
  ///
  /// In en, this message translates to:
  /// **'Some rows have errors and will be skipped. The rest can still be imported.'**
  String get sellerImportPartly;

  /// No description provided for @sellerImportInvalid.
  ///
  /// In en, this message translates to:
  /// **'This file cannot be imported. Fix the errors below and upload it again.'**
  String get sellerImportInvalid;

  /// No description provided for @sellerImportStartAction.
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get sellerImportStartAction;

  /// No description provided for @sellerImportContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Import the rest'**
  String get sellerImportContinueAction;

  /// No description provided for @sellerImportRowsProcessed.
  ///
  /// In en, this message translates to:
  /// **'Rows read'**
  String get sellerImportRowsProcessed;

  /// No description provided for @sellerImportRowsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid rows'**
  String get sellerImportRowsInvalid;

  /// No description provided for @sellerImportErrorCount.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get sellerImportErrorCount;

  /// No description provided for @sellerImportFinished.
  ///
  /// In en, this message translates to:
  /// **'Your import finished.'**
  String get sellerImportFinished;

  /// No description provided for @sellerImportFullReport.
  ///
  /// In en, this message translates to:
  /// **'Download full report'**
  String get sellerImportFullReport;

  /// No description provided for @sellerImportActionAppend.
  ///
  /// In en, this message translates to:
  /// **'Create / update'**
  String get sellerImportActionAppend;

  /// No description provided for @sellerImportActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sellerImportActionDelete;

  /// No description provided for @sellerImportReplaceSheet.
  ///
  /// In en, this message translates to:
  /// **'Replace the sheet'**
  String get sellerImportReplaceSheet;

  /// No description provided for @sellerImportReplaceImages.
  ///
  /// In en, this message translates to:
  /// **'Replace the images zip'**
  String get sellerImportReplaceImages;

  /// No description provided for @sellerImportFileChosen.
  ///
  /// In en, this message translates to:
  /// **'New file: {name}'**
  String sellerImportFileChosen(String name);

  /// No description provided for @sellerImportRecordsCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sellerImportRecordsCreated;

  /// No description provided for @sellerImportRecordsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get sellerImportRecordsUpdated;

  /// No description provided for @sellerImportRecordsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get sellerImportRecordsDeleted;

  /// No description provided for @sellerImportStagePending.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get sellerImportStagePending;

  /// No description provided for @sellerImportStageValidated.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get sellerImportStageValidated;

  /// No description provided for @sellerImportStageProcessed.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get sellerImportStageProcessed;

  /// No description provided for @sellerImportStageLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get sellerImportStageLinked;

  /// No description provided for @sellerImportStageIndexed.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get sellerImportStageIndexed;

  /// No description provided for @sellerImportsRows.
  ///
  /// In en, this message translates to:
  /// **'{processed} rows, {invalid} invalid'**
  String sellerImportsRows(int processed, int invalid);

  /// No description provided for @sellerImportsErrorReport.
  ///
  /// In en, this message translates to:
  /// **'Download error report'**
  String get sellerImportsErrorReport;

  /// No description provided for @sellerSettingsMenu.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerSettingsMenu;

  /// No description provided for @sellerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerSettingsTitle;

  /// No description provided for @sellerSettingsGeneralUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'General settings updated successfully'**
  String get sellerSettingsGeneralUpdatedSuccessfully;

  /// No description provided for @sellerSettingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sellerSettingsPreferences;

  /// No description provided for @sellerSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sellerSettingsLanguage;

  /// No description provided for @sellerSettingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get sellerSettingsCurrency;

  /// No description provided for @sellerSettingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email me about messages'**
  String get sellerSettingsEmailNotifications;

  /// No description provided for @sellerSettingsPassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get sellerSettingsPassword;

  /// No description provided for @sellerSettingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get sellerSettingsCurrentPassword;

  /// No description provided for @sellerSettingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get sellerSettingsNewPassword;

  /// No description provided for @sellerSettingsConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get sellerSettingsConfirmPassword;

  /// No description provided for @sellerSettingsNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'The new password field is required when current password is present.'**
  String get sellerSettingsNewPasswordRequired;

  /// No description provided for @sellerSettingsConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'The new password confirmation field is required when new password is present.'**
  String get sellerSettingsConfirmPasswordRequired;

  /// No description provided for @sellerSettingsPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The new password field confirmation does not match.'**
  String get sellerSettingsPasswordMismatch;

  /// No description provided for @sellerSettingsStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get sellerSettingsStaff;

  /// No description provided for @sellerSettingsStaffEmpty.
  ///
  /// In en, this message translates to:
  /// **'No staff members yet'**
  String get sellerSettingsStaffEmpty;

  /// No description provided for @sellerSettingsAddStaff.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get sellerSettingsAddStaff;

  /// No description provided for @sellerSettingsEditStaff.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get sellerSettingsEditStaff;

  /// No description provided for @sellerSettingsUserNameRequired.
  ///
  /// In en, this message translates to:
  /// **'The name field is required'**
  String get sellerSettingsUserNameRequired;

  /// No description provided for @sellerSettingsUserEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'The email field is required'**
  String get sellerSettingsUserEmailRequired;

  /// No description provided for @sellerSettingsUserPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'The Phone Number field is required'**
  String get sellerSettingsUserPhoneRequired;

  /// No description provided for @sellerSettingsUserPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'The password field is required'**
  String get sellerSettingsUserPasswordRequired;

  /// No description provided for @sellerSettingsUserConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'The Confirm Password field is required'**
  String get sellerSettingsUserConfirmPasswordRequired;

  /// No description provided for @sellerSettingsUserPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The password confirmation does not match'**
  String get sellerSettingsUserPasswordMismatch;

  /// No description provided for @sellerSettingsRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get sellerSettingsRoles;

  /// No description provided for @sellerSettingsSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get sellerSettingsSelectRole;

  /// No description provided for @sellerSettingsRoleRequired.
  ///
  /// In en, this message translates to:
  /// **'The Role field is required'**
  String get sellerSettingsRoleRequired;

  /// No description provided for @sellerSettingsRolesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No roles yet'**
  String get sellerSettingsRolesEmpty;

  /// No description provided for @sellerSettingsAddRole.
  ///
  /// In en, this message translates to:
  /// **'Add role'**
  String get sellerSettingsAddRole;

  /// No description provided for @sellerSettingsEditRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get sellerSettingsEditRole;

  /// No description provided for @sellerSettingsRoleAll.
  ///
  /// In en, this message translates to:
  /// **'Full access'**
  String get sellerSettingsRoleAll;

  /// No description provided for @sellerSettingsRoleCustom.
  ///
  /// In en, this message translates to:
  /// **'Limited access'**
  String get sellerSettingsRoleCustom;

  /// No description provided for @sellerRolePermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get sellerRolePermissions;

  /// No description provided for @sellerRolePermissionsChosen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing selected} =1{1 selected} other{{count} selected}}'**
  String sellerRolePermissionsChosen(int count);

  /// No description provided for @sellerRolePermissionsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search permissions'**
  String get sellerRolePermissionsSearch;

  /// No description provided for @sellerRolePermissionsNone.
  ///
  /// In en, this message translates to:
  /// **'No permission matches that'**
  String get sellerRolePermissionsNone;

  /// No description provided for @sellerRolePermissionsEdit.
  ///
  /// In en, this message translates to:
  /// **'Choose permissions'**
  String get sellerRolePermissionsEdit;

  /// No description provided for @sellerRoleNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the role a name'**
  String get sellerRoleNameRequired;

  /// No description provided for @sellerSettingsRoleInUse.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 staff member} other{{count} staff members}}'**
  String sellerSettingsRoleInUse(int count);

  /// No description provided for @sellerSettingsSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get sellerSettingsSuspended;

  /// No description provided for @sellerSettingsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerSettingsActive;

  /// No description provided for @sellerSettingsAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get sellerSettingsAwaitingApproval;

  /// No description provided for @sellerSettingsHealth.
  ///
  /// In en, this message translates to:
  /// **'Account health'**
  String get sellerSettingsHealth;

  /// No description provided for @sellerSettingsHealthRefresh.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get sellerSettingsHealthRefresh;

  /// No description provided for @sellerSettingsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include settings.'**
  String get sellerSettingsNoPermission;

  /// No description provided for @marketplaceLandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplaceLandingTitle;

  /// No description provided for @marketplaceLandingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sell on this marketplace'**
  String get marketplaceLandingHeadline;

  /// No description provided for @marketplaceLandingBlurb.
  ///
  /// In en, this message translates to:
  /// **'List your products, manage orders and get paid — from your phone.'**
  String get marketplaceLandingBlurb;

  /// No description provided for @marketplaceLandingShopAction.
  ///
  /// In en, this message translates to:
  /// **'Just browsing? Shop the marketplace'**
  String get marketplaceLandingShopAction;

  /// No description provided for @marketplaceLandingWhyHeading.
  ///
  /// In en, this message translates to:
  /// **'Why sell with us?'**
  String get marketplaceLandingWhyHeading;

  /// No description provided for @marketplaceLandingWhyBlurb.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to run a marketplace store, from your phone.'**
  String get marketplaceLandingWhyBlurb;

  /// No description provided for @marketplaceLandingStatSellers.
  ///
  /// In en, this message translates to:
  /// **'Shops trading'**
  String get marketplaceLandingStatSellers;

  /// No description provided for @marketplaceLandingStatListing.
  ///
  /// In en, this message translates to:
  /// **'To list your products'**
  String get marketplaceLandingStatListing;

  /// No description provided for @marketplaceLandingStatListingValue.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get marketplaceLandingStatListingValue;

  /// No description provided for @marketplaceLandingStatAlways.
  ///
  /// In en, this message translates to:
  /// **'Open for orders'**
  String get marketplaceLandingStatAlways;

  /// No description provided for @marketplaceLandingStatMobile.
  ///
  /// In en, this message translates to:
  /// **'Run it from'**
  String get marketplaceLandingStatMobile;

  /// No description provided for @marketplaceLandingStatMobileValue.
  ///
  /// In en, this message translates to:
  /// **'Your phone'**
  String get marketplaceLandingStatMobileValue;

  /// No description provided for @marketplaceLandingStatCommission.
  ///
  /// In en, this message translates to:
  /// **'You keep'**
  String get marketplaceLandingStatCommission;

  /// No description provided for @marketplaceLandingStatCommissionValue.
  ///
  /// In en, this message translates to:
  /// **'Most of it'**
  String get marketplaceLandingStatCommissionValue;

  /// No description provided for @marketplaceLandingReasonCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Your whole catalogue'**
  String get marketplaceLandingReasonCatalogue;

  /// No description provided for @marketplaceLandingReasonCatalogueBlurb.
  ///
  /// In en, this message translates to:
  /// **'Add products one at a time or a spreadsheet at a time, with variants, stock and photographs.'**
  String get marketplaceLandingReasonCatalogueBlurb;

  /// No description provided for @marketplaceLandingReasonOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders end to end'**
  String get marketplaceLandingReasonOrders;

  /// No description provided for @marketplaceLandingReasonOrdersBlurb.
  ///
  /// In en, this message translates to:
  /// **'Invoice, ship, track and handle returns without leaving the app.'**
  String get marketplaceLandingReasonOrdersBlurb;

  /// No description provided for @marketplaceLandingReasonPayouts.
  ///
  /// In en, this message translates to:
  /// **'See what you are owed'**
  String get marketplaceLandingReasonPayouts;

  /// No description provided for @marketplaceLandingReasonPayoutsBlurb.
  ///
  /// In en, this message translates to:
  /// **'Every sale, the commission taken and what is still to be paid out.'**
  String get marketplaceLandingReasonPayoutsBlurb;

  /// No description provided for @marketplaceLandingReasonInsight.
  ///
  /// In en, this message translates to:
  /// **'Know how it is going'**
  String get marketplaceLandingReasonInsight;

  /// No description provided for @marketplaceLandingReasonInsightBlurb.
  ///
  /// In en, this message translates to:
  /// **'Sales over time, best sellers, low stock and your best customers.'**
  String get marketplaceLandingReasonInsightBlurb;

  /// No description provided for @marketplaceLandingSellAction.
  ///
  /// In en, this message translates to:
  /// **'Open Store'**
  String get marketplaceLandingSellAction;

  /// No description provided for @marketplaceLandingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get marketplaceLandingSignInPrompt;

  /// No description provided for @marketplaceLandingDashboardAction.
  ///
  /// In en, this message translates to:
  /// **'Open dashboard'**
  String get marketplaceLandingDashboardAction;

  /// No description provided for @marketplaceLandingVisitShopAction.
  ///
  /// In en, this message translates to:
  /// **'Visit your shop'**
  String get marketplaceLandingVisitShopAction;

  /// No description provided for @marketplaceLandingShopHeading.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get marketplaceLandingShopHeading;

  /// No description provided for @marketplaceLandingBrowseBlurb.
  ///
  /// In en, this message translates to:
  /// **'Find shops and see what they sell'**
  String get marketplaceLandingBrowseBlurb;

  /// No description provided for @marketplaceLandingMessagesBlurb.
  ///
  /// In en, this message translates to:
  /// **'Your conversations with sellers'**
  String get marketplaceLandingMessagesBlurb;

  /// No description provided for @marketplaceLandingStatCommunity.
  ///
  /// In en, this message translates to:
  /// **'Seller Community'**
  String get marketplaceLandingStatCommunity;

  /// No description provided for @marketplaceLandingStatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online Business'**
  String get marketplaceLandingStatOnline;

  /// No description provided for @marketplaceLandingStatPaymentDays.
  ///
  /// In en, this message translates to:
  /// **'Days* Payment'**
  String get marketplaceLandingStatPaymentDays;

  /// No description provided for @marketplaceLandingStatPincode.
  ///
  /// In en, this message translates to:
  /// **'Serviceable Pincode'**
  String get marketplaceLandingStatPincode;

  /// No description provided for @marketplaceLandingStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String marketplaceLandingStepLabel(int number);

  /// No description provided for @marketplaceLandingTrustFreeShippingTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Shipping'**
  String get marketplaceLandingTrustFreeShippingTitle;

  /// No description provided for @marketplaceLandingTrustFreeShippingBlurb.
  ///
  /// In en, this message translates to:
  /// **'Enjoy free shipping on all orders'**
  String get marketplaceLandingTrustFreeShippingBlurb;

  /// No description provided for @marketplaceLandingTrustReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Replace'**
  String get marketplaceLandingTrustReplaceTitle;

  /// No description provided for @marketplaceLandingTrustReplaceBlurb.
  ///
  /// In en, this message translates to:
  /// **'Easy Product Replacement Available!'**
  String get marketplaceLandingTrustReplaceBlurb;

  /// No description provided for @marketplaceLandingTrustEmiTitle.
  ///
  /// In en, this message translates to:
  /// **'EMI Available'**
  String get marketplaceLandingTrustEmiTitle;

  /// No description provided for @marketplaceLandingTrustEmiBlurb.
  ///
  /// In en, this message translates to:
  /// **'No cost EMI available on all major credit cards'**
  String get marketplaceLandingTrustEmiBlurb;

  /// No description provided for @marketplaceLandingTrustSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get marketplaceLandingTrustSupportTitle;

  /// No description provided for @marketplaceLandingTrustSupportBlurb.
  ///
  /// In en, this message translates to:
  /// **'Dedicated 24/7 support via chat and email'**
  String get marketplaceLandingTrustSupportBlurb;

  /// No description provided for @shopSoldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold By'**
  String get shopSoldBy;

  /// No description provided for @shopSoldByReport.
  ///
  /// In en, this message translates to:
  /// **'Report Product'**
  String get shopSoldByReport;

  /// No description provided for @shopReportLoginAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get shopReportLoginAlertTitle;

  /// No description provided for @shopReportLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'You need to login to report this product'**
  String get shopReportLoginRequired;

  /// No description provided for @shopReportLoginDisagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get shopReportLoginDisagree;

  /// No description provided for @shopReportLoginAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get shopReportLoginAgree;

  /// No description provided for @shopSoldByOtherSellers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 other seller} other{{count} other sellers}}'**
  String shopSoldByOtherSellers(int count);

  /// No description provided for @shopProductMoreSellers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more seller selling same product} other{{count} more sellers selling same product}}'**
  String shopProductMoreSellers(int count);

  /// No description provided for @shopSoldByReported.
  ///
  /// In en, this message translates to:
  /// **'Reported. The marketplace will look into it.'**
  String get shopSoldByReported;

  /// No description provided for @shopSoldByReviews.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reviews} =1{1 review} other{{count} reviews}}'**
  String shopSoldByReviews(int count);

  /// No description provided for @marketplaceFeaturedSellersTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Featured Sellers'**
  String get marketplaceFeaturedSellersTitle;

  /// No description provided for @marketplaceFeaturedSellersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start selling with large customer around the world, round the clock.'**
  String get marketplaceFeaturedSellersSubtitle;

  /// No description provided for @shopSellersMenu.
  ///
  /// In en, this message translates to:
  /// **'Browse sellers'**
  String get shopSellersMenu;

  /// No description provided for @shopSellersTitle.
  ///
  /// In en, this message translates to:
  /// **'Sellers'**
  String get shopSellersTitle;

  /// No description provided for @shopSellersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search sellers'**
  String get shopSellersSearchHint;

  /// No description provided for @shopSellersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sellers found'**
  String get shopSellersEmpty;

  /// No description provided for @shopSellerLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'That link could not be opened'**
  String get shopSellerLinkFailed;

  /// No description provided for @shopSellerProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get shopSellerProducts;

  /// No description provided for @shopSellerReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get shopSellerReviews;

  /// No description provided for @shopSellerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get shopSellerAbout;

  /// No description provided for @shopSellerPolicies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get shopSellerPolicies;

  /// No description provided for @shopSellerReturnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get shopSellerReturnPolicy;

  /// No description provided for @shopSellerShippingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shopSellerShippingPolicy;

  /// No description provided for @shopSellerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get shopSellerPrivacyPolicy;

  /// No description provided for @shopSellerContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get shopSellerContact;

  /// No description provided for @shopSellerReport.
  ///
  /// In en, this message translates to:
  /// **'Report this seller'**
  String get shopSellerReport;

  /// No description provided for @shopSellerWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get shopSellerWriteReview;

  /// No description provided for @shopSellerNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get shopSellerNoReviews;

  /// No description provided for @shopSellerNoProducts.
  ///
  /// In en, this message translates to:
  /// **'Nothing for sale right now'**
  String get shopSellerNoProducts;

  /// No description provided for @shopSellerSince.
  ///
  /// In en, this message translates to:
  /// **'Selling since {date}'**
  String shopSellerSince(String date);

  /// No description provided for @shopSellerOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order} other{{count} orders}}'**
  String shopSellerOrdersCount(int count);

  /// No description provided for @shopOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Other sellers'**
  String get shopOffersTitle;

  /// No description provided for @shopOffersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No other sellers offer this'**
  String get shopOffersEmpty;

  /// No description provided for @shopOffersBest.
  ///
  /// In en, this message translates to:
  /// **'Best price'**
  String get shopOffersBest;

  /// No description provided for @shopOffersConditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get shopOffersConditionNew;

  /// No description provided for @shopOffersConditionUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get shopOffersConditionUsed;

  /// No description provided for @shopOffersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get shopOffersUnavailable;

  /// No description provided for @shopMessagesMenu.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get shopMessagesMenu;

  /// No description provided for @shopMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Communications'**
  String get shopMessagesTitle;

  /// No description provided for @shopMessagesSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your conversations with sellers'**
  String get shopMessagesSignIn;

  /// No description provided for @shopReturnsMenu.
  ///
  /// In en, this message translates to:
  /// **'Returns & Cancellations'**
  String get shopReturnsMenu;

  /// No description provided for @shopReturnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Returns & Cancellations'**
  String get shopReturnsTitle;

  /// No description provided for @shopReturnsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your returns'**
  String get shopReturnsSignIn;

  /// No description provided for @shopReturnsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have not asked to return anything yet'**
  String get shopReturnsEmpty;

  /// No description provided for @shopReturnsRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get shopReturnsRetry;

  /// No description provided for @shopReturnsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get shopReturnsLoadMore;

  /// No description provided for @shopReturnsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get shopReturnsLoading;

  /// No description provided for @shopReturnsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shopReturnsFilterAll;

  /// No description provided for @shopReturnsRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request #{id}'**
  String shopReturnsRequestNumber(Object id);

  /// No description provided for @shopReturnsOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String shopReturnsOrderNumber(Object number);

  /// No description provided for @shopReturnsQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String shopReturnsQuantity(Object count);

  /// No description provided for @shopReturnsMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} message(s)'**
  String shopReturnsMessageCount(Object count);

  /// No description provided for @shopReturnsNew.
  ///
  /// In en, this message translates to:
  /// **'Request a return'**
  String get shopReturnsNew;

  /// No description provided for @shopReturnsViewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get shopReturnsViewAction;

  /// No description provided for @shopReturnsCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get shopReturnsCancelAction;

  /// No description provided for @shopReturnsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request withdrawn'**
  String get shopReturnsCancelled;

  /// No description provided for @shopReturnAttachments.
  ///
  /// In en, this message translates to:
  /// **'Photos you sent'**
  String get shopReturnAttachments;

  /// No description provided for @shopReturnAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get shopReturnAttachment;

  /// No description provided for @shopReturnDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Return request'**
  String get shopReturnDetailTitle;

  /// No description provided for @shopReturnItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get shopReturnItem;

  /// No description provided for @shopReturnReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get shopReturnReason;

  /// No description provided for @shopReturnResolution.
  ///
  /// In en, this message translates to:
  /// **'You asked for'**
  String get shopReturnResolution;

  /// No description provided for @shopReturnResolutionReturn.
  ///
  /// In en, this message translates to:
  /// **'A refund'**
  String get shopReturnResolutionReturn;

  /// No description provided for @shopReturnResolutionCancel.
  ///
  /// In en, this message translates to:
  /// **'The item cancelled'**
  String get shopReturnResolutionCancel;

  /// No description provided for @shopReturnPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get shopReturnPackage;

  /// No description provided for @shopReturnInformation.
  ///
  /// In en, this message translates to:
  /// **'What you told us'**
  String get shopReturnInformation;

  /// No description provided for @shopReturnRaised.
  ///
  /// In en, this message translates to:
  /// **'Raised'**
  String get shopReturnRaised;

  /// No description provided for @shopReturnExpired.
  ///
  /// In en, this message translates to:
  /// **'The window for this request has closed'**
  String get shopReturnExpired;

  /// No description provided for @shopReturnActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Withdraw request'**
  String get shopReturnActionCancel;

  /// No description provided for @shopReturnActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close request'**
  String get shopReturnActionClose;

  /// No description provided for @shopReturnActionReopen.
  ///
  /// In en, this message translates to:
  /// **'Ask again'**
  String get shopReturnActionReopen;

  /// No description provided for @shopReturnConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this request? The seller will no longer see it.'**
  String get shopReturnConfirmCancel;

  /// No description provided for @shopReturnConfirmClose.
  ///
  /// In en, this message translates to:
  /// **'Close this request? It cannot be continued afterwards.'**
  String get shopReturnConfirmClose;

  /// No description provided for @shopReturnConfirmKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get shopReturnConfirmKeep;

  /// No description provided for @shopReturnConfirmProceed.
  ///
  /// In en, this message translates to:
  /// **'Yes, go ahead'**
  String get shopReturnConfirmProceed;

  /// No description provided for @shopReturnThread.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get shopReturnThread;

  /// No description provided for @shopReturnThreadEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages on this request yet'**
  String get shopReturnThreadEmpty;

  /// No description provided for @shopReturnMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get shopReturnMessageHint;

  /// No description provided for @shopReturnMessageSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get shopReturnMessageSend;

  /// No description provided for @shopReturnFromSeller.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get shopReturnFromSeller;

  /// No description provided for @shopReturnFromYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get shopReturnFromYou;

  /// No description provided for @shopReturnNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a return'**
  String get shopReturnNewTitle;

  /// No description provided for @shopReturnNewResolution.
  ///
  /// In en, this message translates to:
  /// **'What would you like?'**
  String get shopReturnNewResolution;

  /// No description provided for @shopReturnNewItem.
  ///
  /// In en, this message translates to:
  /// **'Which item?'**
  String get shopReturnNewItem;

  /// No description provided for @shopReturnNewQuantity.
  ///
  /// In en, this message translates to:
  /// **'How many?'**
  String get shopReturnNewQuantity;

  /// No description provided for @shopReturnNewReason.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get shopReturnNewReason;

  /// No description provided for @shopReturnNewPackage.
  ///
  /// In en, this message translates to:
  /// **'Package condition'**
  String get shopReturnNewPackage;

  /// No description provided for @shopReturnNewPackageOpen.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get shopReturnNewPackageOpen;

  /// No description provided for @shopReturnNewPackagePacked.
  ///
  /// In en, this message translates to:
  /// **'Still packed'**
  String get shopReturnNewPackagePacked;

  /// No description provided for @shopReturnNewInformation.
  ///
  /// In en, this message translates to:
  /// **'Anything else we should know?'**
  String get shopReturnNewInformation;

  /// No description provided for @shopReturnNewAgreement.
  ///
  /// In en, this message translates to:
  /// **'I have read the return policy'**
  String get shopReturnNewAgreement;

  /// No description provided for @shopReturnNewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get shopReturnNewSubmit;

  /// No description provided for @shopReturnNewNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this order can be returned. The marketplace decides what is eligible and for how long.'**
  String get shopReturnNewNothing;

  /// No description provided for @shopReturnNewNeedsItem.
  ///
  /// In en, this message translates to:
  /// **'Pick the item you want to send back'**
  String get shopReturnNewNeedsItem;

  /// No description provided for @shopReturnNewNeedsReason.
  ///
  /// In en, this message translates to:
  /// **'Pick a reason'**
  String get shopReturnNewNeedsReason;

  /// No description provided for @shopReturnNewNeedsAgreement.
  ///
  /// In en, this message translates to:
  /// **'Please accept the return policy'**
  String get shopReturnNewNeedsAgreement;

  /// No description provided for @shopReturnCreated.
  ///
  /// In en, this message translates to:
  /// **'Return request sent'**
  String get shopReturnCreated;

  /// No description provided for @shopMessagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get shopMessagesEmpty;

  /// No description provided for @shopMessagesBlocked.
  ///
  /// In en, this message translates to:
  /// **'This seller has turned off replies.'**
  String get shopMessagesBlocked;

  /// No description provided for @shopMessagesSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get shopMessagesSend;

  /// No description provided for @shopMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get shopMessagesHint;

  /// No description provided for @shopContactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get shopContactNameLabel;

  /// No description provided for @shopContactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get shopContactEmailLabel;

  /// No description provided for @shopContactSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get shopContactSubjectLabel;

  /// No description provided for @shopContactQueryLabel.
  ///
  /// In en, this message translates to:
  /// **'Query'**
  String get shopContactQueryLabel;

  /// No description provided for @shopContactNameRequired.
  ///
  /// In en, this message translates to:
  /// **'The name field is required'**
  String get shopContactNameRequired;

  /// No description provided for @shopContactEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'The email field is required'**
  String get shopContactEmailRequired;

  /// No description provided for @shopContactSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'The subject field is required'**
  String get shopContactSubjectRequired;

  /// No description provided for @shopContactQueryRequired.
  ///
  /// In en, this message translates to:
  /// **'The query field is required'**
  String get shopContactQueryRequired;

  /// No description provided for @shopReportReason.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this?'**
  String get shopReportReason;

  /// No description provided for @shopReportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get shopReportSubmit;

  /// No description provided for @shopReviewRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get shopReviewRating;

  /// No description provided for @shopReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get shopReviewTitle;

  /// No description provided for @shopReviewComment.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get shopReviewComment;

  /// No description provided for @shopReviewNeedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Give your review a title'**
  String get shopReviewNeedsTitle;

  /// No description provided for @shopContactNeedsMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message first'**
  String get shopContactNeedsMessage;

  /// No description provided for @shopReviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Post review'**
  String get shopReviewSubmit;

  /// No description provided for @sellerInboxMenu.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get sellerInboxMenu;

  /// No description provided for @sellerInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get sellerInboxTitle;

  /// No description provided for @sellerInboxAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get sellerInboxAdmin;

  /// No description provided for @sellerInboxCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerInboxCustomers;

  /// No description provided for @sellerInboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get sellerInboxEmpty;

  /// No description provided for @sellerInboxSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search customers'**
  String get sellerInboxSearchHint;

  /// No description provided for @sellerInboxBlocked.
  ///
  /// In en, this message translates to:
  /// **'You have blocked this conversation.'**
  String get sellerInboxBlocked;

  /// No description provided for @sellerInboxAdminBlocked.
  ///
  /// In en, this message translates to:
  /// **'The marketplace has turned off replies.'**
  String get sellerInboxAdminBlocked;

  /// No description provided for @sellerInboxBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get sellerInboxBlock;

  /// No description provided for @sellerInboxUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get sellerInboxUnblock;

  /// No description provided for @sellerInboxUnreadNote.
  ///
  /// In en, this message translates to:
  /// **'Marking as read is not available from the app.'**
  String get sellerInboxUnreadNote;

  /// No description provided for @sellerInboxNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include messages.'**
  String get sellerInboxNoPermission;

  /// No description provided for @sellerPlansMenu.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get sellerPlansMenu;

  /// No description provided for @sellerPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get sellerPlansTitle;

  /// No description provided for @sellerPlansCurrent.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get sellerPlansCurrent;

  /// No description provided for @sellerPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Plans'**
  String get sellerPlansAvailable;

  /// No description provided for @sellerPlansHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sellerPlansHistory;

  /// No description provided for @sellerPlansChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get sellerPlansChoose;

  /// No description provided for @sellerPlansCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get sellerPlansCancel;

  /// No description provided for @sellerPlansUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This marketplace does not use paid plans.'**
  String get sellerPlansUnavailable;

  /// No description provided for @sellerPlanRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'A plan is needed'**
  String get sellerPlanRequiredTitle;

  /// No description provided for @sellerPlanRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This marketplace now runs on subscription plans, and your account does not have one yet. Choose a plan to use your dashboard again.'**
  String get sellerPlanRequiredBody;

  /// No description provided for @sellerPlanRequiredAction.
  ///
  /// In en, this message translates to:
  /// **'See plans'**
  String get sellerPlanRequiredAction;

  /// No description provided for @sellerPlansDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String sellerPlansDaysLeft(int count);

  /// No description provided for @sellerPlansMaxProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerPlansMaxProducts;

  /// No description provided for @sellerPlansMaxStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get sellerPlansMaxStaff;

  /// No description provided for @sellerPlansCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get sellerPlansCommission;

  /// No description provided for @sellerPlansFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get sellerPlansFree;

  /// No description provided for @sellerPickupsMenu.
  ///
  /// In en, this message translates to:
  /// **'Courier collections'**
  String get sellerPickupsMenu;

  /// No description provided for @sellerPickupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get sellerPickupsTitle;

  /// No description provided for @sellerPickupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No collections booked'**
  String get sellerPickupsEmpty;

  /// No description provided for @sellerPickupsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get sellerPickupsConfirmation;

  /// No description provided for @sellerPickupsPackages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 package} other{{count} packages}}'**
  String sellerPickupsPackages(int count);

  /// No description provided for @sellerPickupsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Your role does not include collections.'**
  String get sellerPickupsNoPermission;

  /// No description provided for @sellerRuleHowItApplies.
  ///
  /// In en, this message translates to:
  /// **'How it applies'**
  String get sellerRuleHowItApplies;

  /// No description provided for @sellerRuleConditionType.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get sellerRuleConditionType;

  /// No description provided for @sellerRuleMatchAll.
  ///
  /// In en, this message translates to:
  /// **'Match all'**
  String get sellerRuleMatchAll;

  /// No description provided for @sellerRuleMatchAny.
  ///
  /// In en, this message translates to:
  /// **'Match any'**
  String get sellerRuleMatchAny;

  /// No description provided for @sellerRulePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sellerRulePriority;

  /// No description provided for @sellerRuleEndOthers.
  ///
  /// In en, this message translates to:
  /// **'Stop other rules'**
  String get sellerRuleEndOthers;

  /// No description provided for @sellerRuleEndOthersHelp.
  ///
  /// In en, this message translates to:
  /// **'No lower-priority rule applies to a basket this one has matched.'**
  String get sellerRuleEndOthersHelp;

  /// No description provided for @sellerRuleBuyQuantity.
  ///
  /// In en, this message translates to:
  /// **'Buy quantity'**
  String get sellerRuleBuyQuantity;

  /// No description provided for @sellerRuleFreeStep.
  ///
  /// In en, this message translates to:
  /// **'Free every'**
  String get sellerRuleFreeStep;

  /// No description provided for @sellerOrderBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Billing address'**
  String get sellerOrderBillingAddress;

  /// No description provided for @sellerOrderShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get sellerOrderShippingAddress;

  /// No description provided for @sellerOrderShippingMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping method'**
  String get sellerOrderShippingMethodLabel;

  /// No description provided for @sellerOrderPaymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get sellerOrderPaymentMethodLabel;

  /// No description provided for @sellerOrderNoAddress.
  ///
  /// In en, this message translates to:
  /// **'The order carries no address'**
  String get sellerOrderNoAddress;

  /// No description provided for @sellerProfileLogo.
  ///
  /// In en, this message translates to:
  /// **'Shop logo'**
  String get sellerProfileLogo;

  /// No description provided for @sellerProfileBanner.
  ///
  /// In en, this message translates to:
  /// **'Shop banner'**
  String get sellerProfileBanner;

  /// No description provided for @sellerProfileImageChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get sellerProfileImageChange;

  /// No description provided for @sellerProfileImageRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sellerProfileImageRemove;

  /// No description provided for @sellerProfileImageAdd.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get sellerProfileImageAdd;

  /// No description provided for @sellerProfileImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That image is too large — pick one under 2 MB'**
  String get sellerProfileImageTooLarge;

  /// No description provided for @sellerOrderFilters.
  ///
  /// In en, this message translates to:
  /// **'Filter orders'**
  String get sellerOrderFilters;

  /// No description provided for @sellerOrderFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get sellerOrderFilterApply;

  /// No description provided for @sellerOrderFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get sellerOrderFilterClear;

  /// No description provided for @sellerOrderFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get sellerOrderFilterStatus;

  /// No description provided for @sellerOrderFilterFrom.
  ///
  /// In en, this message translates to:
  /// **'Placed from'**
  String get sellerOrderFilterFrom;

  /// No description provided for @sellerOrderFilterTo.
  ///
  /// In en, this message translates to:
  /// **'Placed to'**
  String get sellerOrderFilterTo;

  /// No description provided for @sellerOrderFilterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get sellerOrderFilterCustomerName;

  /// No description provided for @sellerOrderFilterCustomerEmail.
  ///
  /// In en, this message translates to:
  /// **'Customer email'**
  String get sellerOrderFilterCustomerEmail;

  /// No description provided for @sellerOrderFilterLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sellerOrderFilterLocation;

  /// No description provided for @sellerOrderFilterPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get sellerOrderFilterPaymentMethod;

  /// No description provided for @sellerOrderFilterShippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Shipping method'**
  String get sellerOrderFilterShippingMethod;

  /// No description provided for @sellerOrderFilterProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get sellerOrderFilterProductName;

  /// No description provided for @sellerOrderFilterItemCount.
  ///
  /// In en, this message translates to:
  /// **'Items in order'**
  String get sellerOrderFilterItemCount;

  /// No description provided for @sellerOrderFilterSellerTotal.
  ///
  /// In en, this message translates to:
  /// **'Your total'**
  String get sellerOrderFilterSellerTotal;

  /// No description provided for @sellerOrderFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get sellerOrderFilterAny;

  /// No description provided for @sellerOrderWebTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get sellerOrderWebTitle;

  /// No description provided for @sellerOrderWebApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get sellerOrderWebApply;

  /// No description provided for @sellerOrderWebId.
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get sellerOrderWebId;

  /// No description provided for @sellerOrderWebDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sellerOrderWebDate;

  /// No description provided for @sellerOrderWebStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerOrderWebStatus;

  /// No description provided for @sellerOrderWebCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get sellerOrderWebCustomer;

  /// No description provided for @sellerOrderWebEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get sellerOrderWebEmail;

  /// No description provided for @sellerOrderWebItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get sellerOrderWebItems;

  /// No description provided for @sellerOrderWebPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get sellerOrderWebPayment;

  /// No description provided for @sellerOrderWebShipment.
  ///
  /// In en, this message translates to:
  /// **'Shipment'**
  String get sellerOrderWebShipment;

  /// No description provided for @sellerOrderWebGross.
  ///
  /// In en, this message translates to:
  /// **'Gross Amt.'**
  String get sellerOrderWebGross;

  /// No description provided for @sellerOrderWebDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get sellerOrderWebDiscount;

  /// No description provided for @sellerOrderWebCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get sellerOrderWebCommission;

  /// No description provided for @sellerOrderWebSellerEarn.
  ///
  /// In en, this message translates to:
  /// **'Seller Earn'**
  String get sellerOrderWebSellerEarn;

  /// No description provided for @sellerOrderWebSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get sellerOrderWebSelect;

  /// No description provided for @sellerOrderFilterGross.
  ///
  /// In en, this message translates to:
  /// **'Gross amt.'**
  String get sellerOrderFilterGross;

  /// No description provided for @sellerOrderFilterSellerEarn.
  ///
  /// In en, this message translates to:
  /// **'Seller earn'**
  String get sellerOrderFilterSellerEarn;

  /// No description provided for @sellerOrderFilterButton.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get sellerOrderFilterButton;

  /// No description provided for @sellerOrderQuickToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sellerOrderQuickToday;

  /// No description provided for @sellerOrderQuickYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get sellerOrderQuickYesterday;

  /// No description provided for @sellerOrderQuickThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get sellerOrderQuickThisWeek;

  /// No description provided for @sellerOrderQuickThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get sellerOrderQuickThisMonth;

  /// No description provided for @sellerOrderQuickLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get sellerOrderQuickLastMonth;

  /// No description provided for @sellerOrderQuickLast3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 Months'**
  String get sellerOrderQuickLast3Months;

  /// No description provided for @sellerOrderQuickLast6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 Months'**
  String get sellerOrderQuickLast6Months;

  /// No description provided for @sellerOrderQuickThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get sellerOrderQuickThisYear;

  /// No description provided for @sellerDiscountConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get sellerDiscountConditions;

  /// No description provided for @sellerDiscountConditionsHelp.
  ///
  /// In en, this message translates to:
  /// **'The rule applies only to products matching every condition. With none, it applies to your whole catalogue.'**
  String get sellerDiscountConditionsHelp;

  /// No description provided for @sellerDiscountConditionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get sellerDiscountConditionAdd;

  /// No description provided for @sellerDiscountConditionAttribute.
  ///
  /// In en, this message translates to:
  /// **'Attribute'**
  String get sellerDiscountConditionAttribute;

  /// No description provided for @sellerDiscountConditionOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get sellerDiscountConditionOperator;

  /// No description provided for @sellerDiscountConditionValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get sellerDiscountConditionValue;

  /// No description provided for @sellerDiscountConditionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove condition'**
  String get sellerDiscountConditionRemove;

  /// No description provided for @sellerDiscountConditionChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a condition to add'**
  String get sellerDiscountConditionChoose;

  /// No description provided for @sellerRuleYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get sellerRuleYes;

  /// No description provided for @sellerRuleNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get sellerRuleNo;

  /// No description provided for @sellerRuleChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get sellerRuleChoose;

  /// No description provided for @sellerRuleAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get sellerRuleAddMore;

  /// No description provided for @sellerRuleChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get sellerRuleChannels;

  /// No description provided for @sellerRuleCustomerGroups.
  ///
  /// In en, this message translates to:
  /// **'Customer groups'**
  String get sellerRuleCustomerGroups;

  /// No description provided for @sellerRuleWhoItAppliesTo.
  ///
  /// In en, this message translates to:
  /// **'Who it applies to'**
  String get sellerRuleWhoItAppliesTo;

  /// No description provided for @sellerRuleNoChannel.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one channel'**
  String get sellerRuleNoChannel;

  /// No description provided for @sellerRuleNoCustomerGroup.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one customer group'**
  String get sellerRuleNoCustomerGroup;

  /// No description provided for @sellerDiscountWebCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Product Discount'**
  String get sellerDiscountWebCreateTitle;

  /// No description provided for @sellerDiscountWebEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Product Discount'**
  String get sellerDiscountWebEditTitle;

  /// No description provided for @sellerDiscountWebSave.
  ///
  /// In en, this message translates to:
  /// **'Save Product Discount'**
  String get sellerDiscountWebSave;

  /// No description provided for @sellerDiscountWebHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to discount these products?'**
  String get sellerDiscountWebHowTitle;

  /// No description provided for @sellerDiscountWebPercentTitle.
  ///
  /// In en, this message translates to:
  /// **'Percentage off the price'**
  String get sellerDiscountWebPercentTitle;

  /// No description provided for @sellerDiscountWebPercentHelp.
  ///
  /// In en, this message translates to:
  /// **'Take a percentage off every product this discount matches.'**
  String get sellerDiscountWebPercentHelp;

  /// No description provided for @sellerDiscountWebFixedTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount off the price'**
  String get sellerDiscountWebFixedTitle;

  /// No description provided for @sellerDiscountWebFixedHelp.
  ///
  /// In en, this message translates to:
  /// **'Take a set amount off every product this discount matches.'**
  String get sellerDiscountWebFixedHelp;

  /// No description provided for @sellerDiscountWebAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get sellerDiscountWebAmount;

  /// No description provided for @sellerDiscountWebNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should this discount be called?'**
  String get sellerDiscountWebNameTitle;

  /// No description provided for @sellerDiscountWebName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sellerDiscountWebName;

  /// No description provided for @sellerDiscountWebDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerDiscountWebDescription;

  /// No description provided for @sellerDiscountWebWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When should it run?'**
  String get sellerDiscountWebWhenTitle;

  /// No description provided for @sellerDiscountWebStartsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts From'**
  String get sellerDiscountWebStartsFrom;

  /// No description provided for @sellerDiscountWebEndsTill.
  ///
  /// In en, this message translates to:
  /// **'Ends Till'**
  String get sellerDiscountWebEndsTill;

  /// No description provided for @sellerDiscountWebMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Which products should it match?'**
  String get sellerDiscountWebMatchTitle;

  /// No description provided for @sellerDiscountWebConditionType.
  ///
  /// In en, this message translates to:
  /// **'Condition Type'**
  String get sellerDiscountWebConditionType;

  /// No description provided for @sellerDiscountWebAllTrue.
  ///
  /// In en, this message translates to:
  /// **'All Conditions Are True'**
  String get sellerDiscountWebAllTrue;

  /// No description provided for @sellerDiscountWebAnyTrue.
  ///
  /// In en, this message translates to:
  /// **'Any Condition Is True'**
  String get sellerDiscountWebAnyTrue;

  /// No description provided for @sellerDiscountWebAddCondition.
  ///
  /// In en, this message translates to:
  /// **'Add Condition'**
  String get sellerDiscountWebAddCondition;

  /// No description provided for @sellerDiscountWebSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerDiscountWebSettings;

  /// No description provided for @sellerDiscountWebChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get sellerDiscountWebChannels;

  /// No description provided for @sellerDiscountWebCustomerGroups.
  ///
  /// In en, this message translates to:
  /// **'Customer Groups'**
  String get sellerDiscountWebCustomerGroups;

  /// No description provided for @sellerDiscountWebPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sellerDiscountWebPriority;

  /// No description provided for @sellerDiscountWebStopFurther.
  ///
  /// In en, this message translates to:
  /// **'Stop Further Rules'**
  String get sellerDiscountWebStopFurther;

  /// No description provided for @sellerDiscountWebStopFurtherHelp.
  ///
  /// In en, this message translates to:
  /// **'Once this rule applies, stop applying your other rules with a greater priority number.'**
  String get sellerDiscountWebStopFurtherHelp;

  /// No description provided for @sellerDiscountWebStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerDiscountWebStatus;

  /// No description provided for @sellerDiscountWebNameRequired.
  ///
  /// In en, this message translates to:
  /// **'The Name field is required'**
  String get sellerDiscountWebNameRequired;

  /// No description provided for @sellerDiscountWebAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'The Discount Amount field is required'**
  String get sellerDiscountWebAmountRequired;

  /// No description provided for @sellerDiscountWebAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'The Discount Amount must be a number of 0 or more'**
  String get sellerDiscountWebAmountInvalid;

  /// No description provided for @sellerDiscountWebPercentMax.
  ///
  /// In en, this message translates to:
  /// **'A percentage cannot be more than 100'**
  String get sellerDiscountWebPercentMax;

  /// No description provided for @sellerDiscountWebPriorityInvalid.
  ///
  /// In en, this message translates to:
  /// **'The Priority must be a whole number of 0 or more'**
  String get sellerDiscountWebPriorityInvalid;

  /// No description provided for @sellerDiscountWebEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Ends Till cannot be before Starts From'**
  String get sellerDiscountWebEndBeforeStart;

  /// No description provided for @sellerJoinDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Discount details'**
  String get sellerJoinDetailTitle;

  /// No description provided for @sellerJoinDetailGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sellerJoinDetailGeneral;

  /// No description provided for @sellerJoinDetailActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get sellerJoinDetailActions;

  /// No description provided for @sellerJoinDetailSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerJoinDetailSettings;

  /// No description provided for @sellerJoinDetailTime.
  ///
  /// In en, this message translates to:
  /// **'Marketing time'**
  String get sellerJoinDetailTime;

  /// No description provided for @sellerJoinDetailNoConditions.
  ///
  /// In en, this message translates to:
  /// **'No conditions — this rule applies to all matching products.'**
  String get sellerJoinDetailNoConditions;

  /// No description provided for @sellerJoinDetailDiscountType.
  ///
  /// In en, this message translates to:
  /// **'Discount type'**
  String get sellerJoinDetailDiscountType;

  /// No description provided for @sellerJoinDetailDiscountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount amount'**
  String get sellerJoinDetailDiscountAmount;

  /// No description provided for @sellerJoinDetailStopRules.
  ///
  /// In en, this message translates to:
  /// **'Stop further rules'**
  String get sellerJoinDetailStopRules;

  /// No description provided for @sellerJoinDetailStopRulesHelp.
  ///
  /// In en, this message translates to:
  /// **'Once this rule applies, your other rules with a greater priority number stop applying.'**
  String get sellerJoinDetailStopRulesHelp;

  /// No description provided for @sellerJoinDetailPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sellerJoinDetailPriority;

  /// No description provided for @sellerJoinDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerJoinDetailStatus;

  /// No description provided for @sellerJoinDetailStartsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get sellerJoinDetailStartsFrom;

  /// No description provided for @sellerJoinDetailEndsTill.
  ///
  /// In en, this message translates to:
  /// **'Ends till'**
  String get sellerJoinDetailEndsTill;

  /// No description provided for @sellerJoinDetailView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get sellerJoinDetailView;

  /// No description provided for @sellerProductVariantsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the attributes for this family'**
  String get sellerProductVariantsFailed;

  /// No description provided for @sellerProductVariantsNone.
  ///
  /// In en, this message translates to:
  /// **'This attribute family has nothing that can vary'**
  String get sellerProductVariantsNone;

  /// No description provided for @sellerProductVariantsRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get sellerProductVariantsRetry;

  /// No description provided for @sellerProductVariesWhich.
  ///
  /// In en, this message translates to:
  /// **'Which attributes will vary?'**
  String get sellerProductVariesWhich;

  /// No description provided for @sellerProductVariesNeedsOption.
  ///
  /// In en, this message translates to:
  /// **'An attribute you ticked carries no options to vary by'**
  String get sellerProductVariesNeedsOption;

  /// No description provided for @sellerProductKindLabel.
  ///
  /// In en, this message translates to:
  /// **'What kind of product are you selling?'**
  String get sellerProductKindLabel;

  /// No description provided for @sellerProductKindSimple.
  ///
  /// In en, this message translates to:
  /// **'Physical product'**
  String get sellerProductKindSimple;

  /// No description provided for @sellerProductKindSimpleHelp.
  ///
  /// In en, this message translates to:
  /// **'A tangible item you ship to the customer.'**
  String get sellerProductKindSimpleHelp;

  /// No description provided for @sellerProductKindVirtual.
  ///
  /// In en, this message translates to:
  /// **'Service or membership'**
  String get sellerProductKindVirtual;

  /// No description provided for @sellerProductKindVirtualHelp.
  ///
  /// In en, this message translates to:
  /// **'An intangible offering with no shipping.'**
  String get sellerProductKindVirtualHelp;

  /// No description provided for @sellerProductKindDownloadable.
  ///
  /// In en, this message translates to:
  /// **'Digital download'**
  String get sellerProductKindDownloadable;

  /// No description provided for @sellerProductKindDownloadableHelp.
  ///
  /// In en, this message translates to:
  /// **'A downloadable file such as an e-book or software.'**
  String get sellerProductKindDownloadableHelp;

  /// No description provided for @sellerProductKindBooking.
  ///
  /// In en, this message translates to:
  /// **'Bookable'**
  String get sellerProductKindBooking;

  /// No description provided for @sellerProductKindBookingHelp.
  ///
  /// In en, this message translates to:
  /// **'A product customers reserve for a date or time.'**
  String get sellerProductKindBookingHelp;

  /// No description provided for @sellerProductKindBundle.
  ///
  /// In en, this message translates to:
  /// **'Bundle'**
  String get sellerProductKindBundle;

  /// No description provided for @sellerProductKindBundleHelp.
  ///
  /// In en, this message translates to:
  /// **'Several products sold together as one package.'**
  String get sellerProductKindBundleHelp;

  /// No description provided for @sellerProductKindGrouped.
  ///
  /// In en, this message translates to:
  /// **'Grouped products'**
  String get sellerProductKindGrouped;

  /// No description provided for @sellerProductKindGroupedHelp.
  ///
  /// In en, this message translates to:
  /// **'A set of related products shown together.'**
  String get sellerProductKindGroupedHelp;

  /// No description provided for @sellerProductHasVariations.
  ///
  /// In en, this message translates to:
  /// **'Does this product have variations?'**
  String get sellerProductHasVariations;

  /// No description provided for @sellerProductHasVariationsHelp.
  ///
  /// In en, this message translates to:
  /// **'Each combination you pick becomes its own variant.'**
  String get sellerProductHasVariationsHelp;

  /// No description provided for @sellerProductTabVariants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get sellerProductTabVariants;

  /// No description provided for @sellerProductTabLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked products'**
  String get sellerProductTabLinked;

  /// No description provided for @sellerProductTabBundle.
  ///
  /// In en, this message translates to:
  /// **'Bundle items'**
  String get sellerProductTabBundle;

  /// No description provided for @sellerProductTabDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get sellerProductTabDownloads;

  /// No description provided for @sellerProductTabBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get sellerProductTabBooking;

  /// No description provided for @sellerLblStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sellerLblStatusPending;

  /// No description provided for @sellerLblStatusPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get sellerLblStatusPendingPayment;

  /// No description provided for @sellerLblStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get sellerLblStatusProcessing;

  /// No description provided for @sellerLblStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sellerLblStatusCompleted;

  /// No description provided for @sellerLblStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get sellerLblStatusCanceled;

  /// No description provided for @sellerLblStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get sellerLblStatusClosed;

  /// No description provided for @sellerLblStatusFraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud'**
  String get sellerLblStatusFraud;

  /// No description provided for @sellerLblStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get sellerLblStatusRefunded;

  /// No description provided for @sellerLblStatusOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get sellerLblStatusOnHold;

  /// No description provided for @sellerLblStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sellerLblStatusApproved;

  /// No description provided for @sellerLblStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get sellerLblStatusRejected;

  /// No description provided for @sellerLblStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get sellerLblStatusDraft;

  /// No description provided for @sellerLblStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerLblStatusActive;

  /// No description provided for @sellerLblStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get sellerLblStatusInactive;

  /// No description provided for @sellerLblStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get sellerLblStatusPaid;

  /// No description provided for @sellerLblStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get sellerLblStatusRequested;

  /// No description provided for @sellerLblStatusDisapproved.
  ///
  /// In en, this message translates to:
  /// **'Disapproved'**
  String get sellerLblStatusDisapproved;

  /// No description provided for @sellerLblTypeSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get sellerLblTypeSimple;

  /// No description provided for @sellerLblTypeVirtual.
  ///
  /// In en, this message translates to:
  /// **'Virtual'**
  String get sellerLblTypeVirtual;

  /// No description provided for @sellerLblTypeConfigurable.
  ///
  /// In en, this message translates to:
  /// **'Configurable'**
  String get sellerLblTypeConfigurable;

  /// No description provided for @sellerLblTypeGrouped.
  ///
  /// In en, this message translates to:
  /// **'Grouped'**
  String get sellerLblTypeGrouped;

  /// No description provided for @sellerLblTypeBundle.
  ///
  /// In en, this message translates to:
  /// **'Bundle'**
  String get sellerLblTypeBundle;

  /// No description provided for @sellerLblTypeDownloadable.
  ///
  /// In en, this message translates to:
  /// **'Downloadable'**
  String get sellerLblTypeDownloadable;

  /// No description provided for @sellerLblTypeBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get sellerLblTypeBooking;

  /// No description provided for @sellerHcOrdersPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get sellerHcOrdersPlaced;

  /// No description provided for @sellerHcOrdersQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get sellerHcOrdersQty;

  /// No description provided for @sellerHcOrdersPriceEach.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String sellerHcOrdersPriceEach(String price);

  /// No description provided for @sellerHcOrdersPayoutStatus.
  ///
  /// In en, this message translates to:
  /// **'Payout status'**
  String get sellerHcOrdersPayoutStatus;

  /// No description provided for @sellerHcOrdersSkuMax.
  ///
  /// In en, this message translates to:
  /// **'{sku} · max {max}'**
  String sellerHcOrdersSkuMax(String sku, int max);

  /// No description provided for @sellerHcOrdersLengthShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get sellerHcOrdersLengthShort;

  /// No description provided for @sellerHcOrdersWidthShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get sellerHcOrdersWidthShort;

  /// No description provided for @sellerHcOrdersHeightShort.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get sellerHcOrdersHeightShort;

  /// No description provided for @sellerHcOrdersCarrierManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get sellerHcOrdersCarrierManual;

  /// No description provided for @sellerHcPlansWeightKg.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String sellerHcPlansWeightKg(String weight);

  /// No description provided for @sellerHcPlansUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get sellerHcPlansUnlimited;

  /// No description provided for @sellerHcEarningsTypeCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get sellerHcEarningsTypeCredit;

  /// No description provided for @sellerHcEarningsTypeDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get sellerHcEarningsTypeDebit;

  /// No description provided for @sellerHcReportingAverageSales.
  ///
  /// In en, this message translates to:
  /// **'Average sales'**
  String get sellerHcReportingAverageSales;

  /// No description provided for @sellerHcReportingTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get sellerHcReportingTotalOrders;

  /// No description provided for @sellerHcReportingPurchaseFunnel.
  ///
  /// In en, this message translates to:
  /// **'Purchase funnel'**
  String get sellerHcReportingPurchaseFunnel;

  /// No description provided for @sellerHcReportingAbandonedCarts.
  ///
  /// In en, this message translates to:
  /// **'Abandoned carts'**
  String get sellerHcReportingAbandonedCarts;

  /// No description provided for @sellerHcReportingTaxCollected.
  ///
  /// In en, this message translates to:
  /// **'Tax collected'**
  String get sellerHcReportingTaxCollected;

  /// No description provided for @sellerHcReportingShippingCollected.
  ///
  /// In en, this message translates to:
  /// **'Shipping collected'**
  String get sellerHcReportingShippingCollected;

  /// No description provided for @sellerHcReportingTopPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Top payment methods'**
  String get sellerHcReportingTopPaymentMethods;

  /// No description provided for @sellerHcReportingTopSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Top selling products'**
  String get sellerHcReportingTopSellingProducts;

  /// No description provided for @sellerHcReportingSoldProductsQuantity.
  ///
  /// In en, this message translates to:
  /// **'Sold products quantity'**
  String get sellerHcReportingSoldProductsQuantity;

  /// No description provided for @sellerHcReportingProductsAddedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Products added to wishlist'**
  String get sellerHcReportingProductsAddedToWishlist;

  /// No description provided for @sellerHcReportingProductsWithMostReviews.
  ///
  /// In en, this message translates to:
  /// **'Products with most reviews'**
  String get sellerHcReportingProductsWithMostReviews;

  /// No description provided for @sellerHcReportingProductsWithMostVisits.
  ///
  /// In en, this message translates to:
  /// **'Products with most visits'**
  String get sellerHcReportingProductsWithMostVisits;

  /// No description provided for @sellerHcReportingLastSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Last search terms'**
  String get sellerHcReportingLastSearchTerms;

  /// No description provided for @sellerHcReportingTopSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Top search terms'**
  String get sellerHcReportingTopSearchTerms;

  /// No description provided for @sellerHcReportingCustomersTraffic.
  ///
  /// In en, this message translates to:
  /// **'Customers traffic'**
  String get sellerHcReportingCustomersTraffic;

  /// No description provided for @sellerHcReportingCustomersWithMostSales.
  ///
  /// In en, this message translates to:
  /// **'Customers with most sales'**
  String get sellerHcReportingCustomersWithMostSales;

  /// No description provided for @sellerHcReportingCustomersWithMostOrders.
  ///
  /// In en, this message translates to:
  /// **'Customers with most orders'**
  String get sellerHcReportingCustomersWithMostOrders;

  /// No description provided for @sellerHcReportingCustomersWithMostReviews.
  ///
  /// In en, this message translates to:
  /// **'Customers with most reviews'**
  String get sellerHcReportingCustomersWithMostReviews;

  /// No description provided for @sellerHcReportingTopCustomerGroups.
  ///
  /// In en, this message translates to:
  /// **'Top customer groups'**
  String get sellerHcReportingTopCustomerGroups;

  /// No description provided for @sellerHcReportingFunnelVisitors.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get sellerHcReportingFunnelVisitors;

  /// No description provided for @sellerHcReportingFunnelProductViews.
  ///
  /// In en, this message translates to:
  /// **'Product views'**
  String get sellerHcReportingFunnelProductViews;

  /// No description provided for @sellerHcReportingFunnelAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get sellerHcReportingFunnelAddedToCart;

  /// No description provided for @sellerHcProductsNoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'None available'**
  String get sellerHcProductsNoneAvailable;

  /// No description provided for @sellerHcProductsCustomizableItem.
  ///
  /// In en, this message translates to:
  /// **'Customizable Item'**
  String get sellerHcProductsCustomizableItem;

  /// No description provided for @sellerHcProductsAddOption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get sellerHcProductsAddOption;

  /// No description provided for @sellerHcProductsNoOptions.
  ///
  /// In en, this message translates to:
  /// **'No options yet. Add one to let buyers customize this product.'**
  String get sellerHcProductsNoOptions;

  /// No description provided for @sellerHcProductsOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get sellerHcProductsOptional;

  /// No description provided for @sellerHcProductsChoiceCount.
  ///
  /// In en, this message translates to:
  /// **'{count} choice(s)'**
  String sellerHcProductsChoiceCount(int count);

  /// No description provided for @sellerHcProductsPriceValue.
  ///
  /// In en, this message translates to:
  /// **'Price {price}'**
  String sellerHcProductsPriceValue(String price);

  /// No description provided for @sellerHcProductsTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get sellerHcProductsTitleRequired;

  /// No description provided for @sellerHcProductsAddOneChoice.
  ///
  /// In en, this message translates to:
  /// **'Add at least one choice.'**
  String get sellerHcProductsAddOneChoice;

  /// No description provided for @sellerHcProductsOption.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get sellerHcProductsOption;

  /// No description provided for @sellerHcProductsTitleStar.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get sellerHcProductsTitleStar;

  /// No description provided for @sellerHcProductsTypeStar.
  ///
  /// In en, this message translates to:
  /// **'Type *'**
  String get sellerHcProductsTypeStar;

  /// No description provided for @sellerHcProductsIsRequiredStar.
  ///
  /// In en, this message translates to:
  /// **'Is Required *'**
  String get sellerHcProductsIsRequiredStar;

  /// No description provided for @sellerHcProductsMaxCharacters.
  ///
  /// In en, this message translates to:
  /// **'Max characters'**
  String get sellerHcProductsMaxCharacters;

  /// No description provided for @sellerHcProductsMaxCharactersStar.
  ///
  /// In en, this message translates to:
  /// **'Max Characters *'**
  String get sellerHcProductsMaxCharactersStar;

  /// No description provided for @sellerHcProductsFileExtensions.
  ///
  /// In en, this message translates to:
  /// **'Supported file extensions'**
  String get sellerHcProductsFileExtensions;

  /// No description provided for @sellerHcProductsFileExtensionsStar.
  ///
  /// In en, this message translates to:
  /// **'Supported File Extensions *'**
  String get sellerHcProductsFileExtensionsStar;

  /// No description provided for @sellerHcProductsPriceStar.
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get sellerHcProductsPriceStar;

  /// No description provided for @sellerHcProductsLabelStar.
  ///
  /// In en, this message translates to:
  /// **'Label *'**
  String get sellerHcProductsLabelStar;

  /// No description provided for @sellerHcProductsTitleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'The Title field is required.'**
  String get sellerHcProductsTitleRequiredError;

  /// No description provided for @sellerHcProductsMaxCharactersRequired.
  ///
  /// In en, this message translates to:
  /// **'The Max Characters field is required.'**
  String get sellerHcProductsMaxCharactersRequired;

  /// No description provided for @sellerHcProductsExtensionsRequired.
  ///
  /// In en, this message translates to:
  /// **'The Supported File Extensions field is required.'**
  String get sellerHcProductsExtensionsRequired;

  /// No description provided for @sellerHcProductsPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'The Price field is required.'**
  String get sellerHcProductsPriceRequired;

  /// No description provided for @sellerHcProductsLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'The Label field is required.'**
  String get sellerHcProductsLabelRequired;

  /// No description provided for @sellerHcProductsAddChoiceCombinations.
  ///
  /// In en, this message translates to:
  /// **'To create various combination of product on a go.'**
  String get sellerHcProductsAddChoiceCombinations;

  /// No description provided for @sellerHcProductsAddOptionOnGo.
  ///
  /// In en, this message translates to:
  /// **'To create customizable options on a go.'**
  String get sellerHcProductsAddOptionOnGo;

  /// No description provided for @sellerHcProductsChoices.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get sellerHcProductsChoices;

  /// No description provided for @sellerHcProductsAddChoice.
  ///
  /// In en, this message translates to:
  /// **'Add choice'**
  String get sellerHcProductsAddChoice;

  /// No description provided for @sellerHcProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get sellerHcProductsLabel;

  /// No description provided for @sellerHcProductsOptTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get sellerHcProductsOptTypeText;

  /// No description provided for @sellerHcProductsOptTypeTextarea.
  ///
  /// In en, this message translates to:
  /// **'Text area'**
  String get sellerHcProductsOptTypeTextarea;

  /// No description provided for @sellerHcProductsOptTypeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Checkbox'**
  String get sellerHcProductsOptTypeCheckbox;

  /// No description provided for @sellerHcProductsOptTypeRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get sellerHcProductsOptTypeRadio;

  /// No description provided for @sellerHcProductsOptTypeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get sellerHcProductsOptTypeSelect;

  /// No description provided for @sellerHcProductsOptTypeMultiselect.
  ///
  /// In en, this message translates to:
  /// **'Multiselect'**
  String get sellerHcProductsOptTypeMultiselect;

  /// No description provided for @sellerHcProductsOptTypeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sellerHcProductsOptTypeDate;

  /// No description provided for @sellerHcProductsOptTypeDatetime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get sellerHcProductsOptTypeDatetime;

  /// No description provided for @sellerHcProductsOptTypeTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get sellerHcProductsOptTypeTime;

  /// No description provided for @sellerHcProductsOptTypeFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get sellerHcProductsOptTypeFile;

  /// No description provided for @sellerHcProductsUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get sellerHcProductsUnsavedChanges;

  /// No description provided for @sellerHcProductsSwitchLocaleWarning.
  ///
  /// In en, this message translates to:
  /// **'Switching language discards what you changed and have not saved.'**
  String get sellerHcProductsSwitchLocaleWarning;

  /// No description provided for @sellerHcProductsStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get sellerHcProductsStay;

  /// No description provided for @sellerHcProductsSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get sellerHcProductsSwitch;

  /// No description provided for @sellerHcProductsFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} is required'**
  String sellerHcProductsFieldRequired(String label);

  /// No description provided for @sellerHcProductsEnterValid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid {label}'**
  String sellerHcProductsEnterValid(String label);

  /// No description provided for @sellerHcProductsVariantsError.
  ///
  /// In en, this message translates to:
  /// **'Variants: {message}'**
  String sellerHcProductsVariantsError(String message);

  /// No description provided for @sellerHcProductsRelatedDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Changes to these product links apply across all languages.'**
  String get sellerHcProductsRelatedDefaultLanguage;

  /// No description provided for @sellerHcProductsTabInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get sellerHcProductsTabInventory;

  /// No description provided for @sellerHcProductsTabMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get sellerHcProductsTabMedia;

  /// No description provided for @sellerHcProductsTabOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get sellerHcProductsTabOrganization;

  /// No description provided for @sellerHcTypesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get sellerHcTypesAdd;

  /// No description provided for @sellerHcTypesAddSlot.
  ///
  /// In en, this message translates to:
  /// **'Add slot'**
  String get sellerHcTypesAddSlot;

  /// No description provided for @sellerHcTypesAddTicket.
  ///
  /// In en, this message translates to:
  /// **'Add ticket'**
  String get sellerHcTypesAddTicket;

  /// No description provided for @sellerHcTypesAvailableFrom.
  ///
  /// In en, this message translates to:
  /// **'Available from'**
  String get sellerHcTypesAvailableFrom;

  /// No description provided for @sellerHcTypesAvailableTo.
  ///
  /// In en, this message translates to:
  /// **'Available to'**
  String get sellerHcTypesAvailableTo;

  /// No description provided for @sellerHcTypesBookingAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment Booking'**
  String get sellerHcTypesBookingAppointment;

  /// No description provided for @sellerHcTypesBookingDefault.
  ///
  /// In en, this message translates to:
  /// **'Default Booking'**
  String get sellerHcTypesBookingDefault;

  /// No description provided for @sellerHcTypesBookingEvent.
  ///
  /// In en, this message translates to:
  /// **'Event Booking'**
  String get sellerHcTypesBookingEvent;

  /// No description provided for @sellerHcTypesBookingRental.
  ///
  /// In en, this message translates to:
  /// **'Rental Booking'**
  String get sellerHcTypesBookingRental;

  /// No description provided for @sellerHcTypesBookingTable.
  ///
  /// In en, this message translates to:
  /// **'Table Booking'**
  String get sellerHcTypesBookingTable;

  /// No description provided for @sellerHcTypesBookingInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get sellerHcTypesBookingInformation;

  /// No description provided for @sellerHcTypesBookingType.
  ///
  /// In en, this message translates to:
  /// **'Booking type'**
  String get sellerHcTypesBookingType;

  /// No description provided for @sellerHcTypesBreakTime.
  ///
  /// In en, this message translates to:
  /// **'Break Time b/w Slots (Mins)'**
  String get sellerHcTypesBreakTime;

  /// No description provided for @sellerHcTypesBundleOptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product, or this option sells nothing.'**
  String get sellerHcTypesBundleOptionEmpty;

  /// No description provided for @sellerHcTypesChargedPer.
  ///
  /// In en, this message translates to:
  /// **'Charged Per'**
  String get sellerHcTypesChargedPer;

  /// No description provided for @sellerHcTypesChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get sellerHcTypesChooseFile;

  /// No description provided for @sellerHcTypesDailyAndHourly.
  ///
  /// In en, this message translates to:
  /// **'Both (Daily and Hourly Basis)'**
  String get sellerHcTypesDailyAndHourly;

  /// No description provided for @sellerHcTypesDailyBasis.
  ///
  /// In en, this message translates to:
  /// **'Daily Basis'**
  String get sellerHcTypesDailyBasis;

  /// No description provided for @sellerHcTypesDailyPrice.
  ///
  /// In en, this message translates to:
  /// **'Daily Price'**
  String get sellerHcTypesDailyPrice;

  /// No description provided for @sellerHcTypesDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get sellerHcTypesDay;

  /// No description provided for @sellerHcTypesDownloadAllowed.
  ///
  /// In en, this message translates to:
  /// **'Download allowed'**
  String get sellerHcTypesDownloadAllowed;

  /// No description provided for @sellerHcTypesEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Available every week'**
  String get sellerHcTypesEveryWeek;

  /// No description provided for @sellerHcTypesFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get sellerHcTypesFile;

  /// No description provided for @sellerHcTypesFileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get sellerHcTypesFileType;

  /// No description provided for @sellerHcTypesFileUrl.
  ///
  /// In en, this message translates to:
  /// **'File URL'**
  String get sellerHcTypesFileUrl;

  /// No description provided for @sellerHcTypesFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get sellerHcTypesFriday;

  /// No description provided for @sellerHcTypesGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get sellerHcTypesGuest;

  /// No description provided for @sellerHcTypesGuestCapacity.
  ///
  /// In en, this message translates to:
  /// **'Guest Capacity'**
  String get sellerHcTypesGuestCapacity;

  /// No description provided for @sellerHcTypesGuestLimitPerTable.
  ///
  /// In en, this message translates to:
  /// **'Guest Limit Per Table'**
  String get sellerHcTypesGuestLimitPerTable;

  /// No description provided for @sellerHcTypesHourlyBasis.
  ///
  /// In en, this message translates to:
  /// **'Hourly Basis'**
  String get sellerHcTypesHourlyBasis;

  /// No description provided for @sellerHcTypesHourlyPrice.
  ///
  /// In en, this message translates to:
  /// **'Hourly Price'**
  String get sellerHcTypesHourlyPrice;

  /// No description provided for @sellerHcTypesManyBookingsOneDay.
  ///
  /// In en, this message translates to:
  /// **'Many Bookings For One Day'**
  String get sellerHcTypesManyBookingsOneDay;

  /// No description provided for @sellerHcTypesMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get sellerHcTypesMonday;

  /// No description provided for @sellerHcTypesNoFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get sellerHcTypesNoFileChosen;

  /// No description provided for @sellerHcTypesNoVariants.
  ///
  /// In en, this message translates to:
  /// **'No variants found for this product.'**
  String get sellerHcTypesNoVariants;

  /// No description provided for @sellerHcTypesOneBookingManyDays.
  ///
  /// In en, this message translates to:
  /// **'One Booking For Many Days'**
  String get sellerHcTypesOneBookingManyDays;

  /// No description provided for @sellerHcTypesOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Option label'**
  String get sellerHcTypesOptionLabel;

  /// No description provided for @sellerHcTypesPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get sellerHcTypesPickDate;

  /// No description provided for @sellerHcTypesPreventBefore.
  ///
  /// In en, this message translates to:
  /// **'Prevent Scheduling Before'**
  String get sellerHcTypesPreventBefore;

  /// No description provided for @sellerHcTypesQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get sellerHcTypesQty;

  /// No description provided for @sellerHcTypesRentingType.
  ///
  /// In en, this message translates to:
  /// **'Renting Type'**
  String get sellerHcTypesRentingType;

  /// No description provided for @sellerHcTypesSameSlot.
  ///
  /// In en, this message translates to:
  /// **'Same slot for all days'**
  String get sellerHcTypesSameSlot;

  /// No description provided for @sellerHcTypesSampleType.
  ///
  /// In en, this message translates to:
  /// **'Sample type'**
  String get sellerHcTypesSampleType;

  /// No description provided for @sellerHcTypesSampleUrl.
  ///
  /// In en, this message translates to:
  /// **'Sample URL'**
  String get sellerHcTypesSampleUrl;

  /// No description provided for @sellerHcTypesSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sellerHcTypesSaturday;

  /// No description provided for @sellerHcTypesSlotDuration.
  ///
  /// In en, this message translates to:
  /// **'Slot Duration (Mins)'**
  String get sellerHcTypesSlotDuration;

  /// No description provided for @sellerHcTypesSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sellerHcTypesSunday;

  /// No description provided for @sellerHcTypesThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get sellerHcTypesThursday;

  /// No description provided for @sellerHcTypesTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get sellerHcTypesTuesday;

  /// No description provided for @sellerHcTypesTypeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Checkbox'**
  String get sellerHcTypesTypeCheckbox;

  /// No description provided for @sellerHcTypesTypeMultiselect.
  ///
  /// In en, this message translates to:
  /// **'Multiselect'**
  String get sellerHcTypesTypeMultiselect;

  /// No description provided for @sellerHcTypesTypeRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get sellerHcTypesTypeRadio;

  /// No description provided for @sellerHcTypesTypeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get sellerHcTypesTypeSelect;

  /// No description provided for @sellerHcTypesUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get sellerHcTypesUrl;

  /// No description provided for @sellerHcTypesValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get sellerHcTypesValidUntil;

  /// No description provided for @sellerHcTypesWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get sellerHcTypesWednesday;

  /// No description provided for @sellerHcTypesFromDay.
  ///
  /// In en, this message translates to:
  /// **'From Day'**
  String get sellerHcTypesFromDay;

  /// No description provided for @sellerHcTypesToDay.
  ///
  /// In en, this message translates to:
  /// **'To Day'**
  String get sellerHcTypesToDay;

  /// No description provided for @sellerHcTypesStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerHcTypesStatus;

  /// No description provided for @sellerHcTypesStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get sellerHcTypesStatusOpen;

  /// No description provided for @sellerHcTypesStatusClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sellerHcTypesStatusClose;

  /// No description provided for @sellerHcTypesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get sellerHcTypesUnavailable;

  /// No description provided for @sellerHcTypesSlotsTimeDuration.
  ///
  /// In en, this message translates to:
  /// **'Slots Time Duration'**
  String get sellerHcTypesSlotsTimeDuration;

  /// No description provided for @sellerHcTypesSlotsTimeDurationDesc.
  ///
  /// In en, this message translates to:
  /// **'According to slots the time duration will be created and visible on the storefront.'**
  String get sellerHcTypesSlotsTimeDurationDesc;

  /// No description provided for @sellerHcTypesSlotEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get sellerHcTypesSlotEndAfterStart;

  /// No description provided for @sellerHcTypesSlotOverlap.
  ///
  /// In en, this message translates to:
  /// **'Time slots on the same day cannot overlap.'**
  String get sellerHcTypesSlotOverlap;

  /// No description provided for @sellerHcTypesNoSlotsAdded.
  ///
  /// In en, this message translates to:
  /// **'No slots added yet. Tap \'Add Slot\' to set up slot time duration.'**
  String get sellerHcTypesNoSlotsAdded;

  /// No description provided for @sellerHcTypesWeeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly Schedule'**
  String get sellerHcTypesWeeklySchedule;

  /// No description provided for @sellerHcTypesProductNumber.
  ///
  /// In en, this message translates to:
  /// **'Product #{id}'**
  String sellerHcTypesProductNumber(int id);

  /// No description provided for @sellerHcMarketingDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get sellerHcMarketingDatePlaceholder;

  /// No description provided for @sellerHcMarketingCouponsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} codes'**
  String sellerHcMarketingCouponsCount(int count);

  /// No description provided for @sellerHcMarketingActionPercentOrder.
  ///
  /// In en, this message translates to:
  /// **'Percentage off the order'**
  String get sellerHcMarketingActionPercentOrder;

  /// No description provided for @sellerHcMarketingActionFixedOrder.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount off the order'**
  String get sellerHcMarketingActionFixedOrder;

  /// No description provided for @sellerHcMarketingActionFixedItem.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount off each item'**
  String get sellerHcMarketingActionFixedItem;

  /// No description provided for @sellerHcMarketingActionBuyXGetY.
  ///
  /// In en, this message translates to:
  /// **'Buy X, get Y free'**
  String get sellerHcMarketingActionBuyXGetY;

  /// No description provided for @sellerHcMarketingActionPercentPrice.
  ///
  /// In en, this message translates to:
  /// **'Percentage of product price'**
  String get sellerHcMarketingActionPercentPrice;

  /// No description provided for @sellerHcMarketingActionFixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount off product price'**
  String get sellerHcMarketingActionFixedPrice;

  /// No description provided for @sellerHcMarketingImportActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get sellerHcMarketingImportActionUpdate;

  /// No description provided for @sellerHcMarketingValidationSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip bad rows'**
  String get sellerHcMarketingValidationSkip;

  /// No description provided for @sellerHcMarketingValidationStop.
  ///
  /// In en, this message translates to:
  /// **'Stop on the first bad row'**
  String get sellerHcMarketingValidationStop;

  /// No description provided for @sellerHcMarketingValidationStopShort.
  ///
  /// In en, this message translates to:
  /// **'Stop on the first'**
  String get sellerHcMarketingValidationStopShort;

  /// No description provided for @sellerHcMarketingSeparatorComma.
  ///
  /// In en, this message translates to:
  /// **'Comma'**
  String get sellerHcMarketingSeparatorComma;

  /// No description provided for @sellerHcMarketingSeparatorSemicolon.
  ///
  /// In en, this message translates to:
  /// **'Semicolon'**
  String get sellerHcMarketingSeparatorSemicolon;

  /// No description provided for @sellerHcMarketingSeparatorPipe.
  ///
  /// In en, this message translates to:
  /// **'Pipe'**
  String get sellerHcMarketingSeparatorPipe;

  /// No description provided for @sellerHcAftersalesResolutionReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get sellerHcAftersalesResolutionReturn;

  /// No description provided for @sellerHcAftersalesResolutionCancelItems.
  ///
  /// In en, this message translates to:
  /// **'Cancel items'**
  String get sellerHcAftersalesResolutionCancelItems;

  /// No description provided for @sellerHcAftersalesAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get sellerHcAftersalesAttachment;

  /// No description provided for @sellerHcAftersalesWeekHeader.
  ///
  /// In en, this message translates to:
  /// **'Week {week} ({month} {year})'**
  String sellerHcAftersalesWeekHeader(int week, String month, String year);

  /// No description provided for @sellerHcCommsAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get sellerHcCommsAttachment;

  /// No description provided for @sellerHcShopAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get sellerHcShopAttachment;

  /// No description provided for @sellerHcShopYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get sellerHcShopYourEmail;

  /// No description provided for @sellerHcShopSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get sellerHcShopSubject;

  /// No description provided for @sellerHcAccountUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get sellerHcAccountUnsavedChanges;

  /// No description provided for @sellerHcAccountSwitchLanguageWarning.
  ///
  /// In en, this message translates to:
  /// **'Switching language discards what you changed and have not saved.'**
  String get sellerHcAccountSwitchLanguageWarning;

  /// No description provided for @sellerHcAccountStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get sellerHcAccountStay;

  /// No description provided for @sellerHcAccountSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get sellerHcAccountSwitch;

  /// No description provided for @sellerHcSettingsLeaveBlankToKeep.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep'**
  String get sellerHcSettingsLeaveBlankToKeep;

  /// No description provided for @sellerReturnRowRmaId.
  ///
  /// In en, this message translates to:
  /// **'RMA ID'**
  String get sellerReturnRowRmaId;

  /// No description provided for @sellerReturnRowOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get sellerReturnRowOrderId;

  /// No description provided for @sellerReturnRowCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get sellerReturnRowCustomer;

  /// No description provided for @sellerReturnRowStatus.
  ///
  /// In en, this message translates to:
  /// **'RMA Status'**
  String get sellerReturnRowStatus;

  /// No description provided for @sellerReturnRowGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get sellerReturnRowGuest;

  /// No description provided for @sellerReturnRowOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get sellerReturnRowOrderStatus;

  /// No description provided for @sellerReturnRowDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sellerReturnRowDate;

  /// No description provided for @sellerReturnYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get sellerReturnYes;

  /// No description provided for @sellerReturnNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get sellerReturnNo;

  /// No description provided for @sellerReturnDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get sellerReturnDelivered;

  /// No description provided for @sellerReturnUndelivered.
  ///
  /// In en, this message translates to:
  /// **'Undelivered'**
  String get sellerReturnUndelivered;

  /// No description provided for @sellerReturnSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sellerReturnSectionGeneral;

  /// No description provided for @sellerReturnSectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerReturnSectionStatus;

  /// No description provided for @sellerReturnSectionItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get sellerReturnSectionItems;

  /// No description provided for @sellerReturnSectionOrder.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get sellerReturnSectionOrder;

  /// No description provided for @sellerReturnSectionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get sellerReturnSectionCustomer;

  /// No description provided for @sellerReturnItemPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerReturnItemPrice;

  /// No description provided for @sellerReturnItemRmaQty.
  ///
  /// In en, this message translates to:
  /// **'RMA Qty'**
  String get sellerReturnItemRmaQty;

  /// No description provided for @sellerReturnItemOrderQty.
  ///
  /// In en, this message translates to:
  /// **'Order Qty'**
  String get sellerReturnItemOrderQty;

  /// No description provided for @sellerReturnItemResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution Type'**
  String get sellerReturnItemResolution;

  /// No description provided for @sellerReturnOrderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get sellerReturnOrderTotal;

  /// No description provided for @sellerReturnOrderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get sellerReturnOrderDate;

  /// No description provided for @sellerReturnPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get sellerReturnPaymentMethod;

  /// No description provided for @sellerReturnRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'RMA Request #{id}'**
  String sellerReturnRequestTitle(int id);

  /// No description provided for @sellerReturnAddAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get sellerReturnAddAttachment;

  /// No description provided for @sellerReturnAttachmentUnreadable.
  ///
  /// In en, this message translates to:
  /// **'That file could not be read.'**
  String get sellerReturnAttachmentUnreadable;

  /// No description provided for @sellerDashboardHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get sellerDashboardHealthy;

  /// No description provided for @sellerDashboardAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At Risk'**
  String get sellerDashboardAtRisk;

  /// No description provided for @sellerDashboardUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get sellerDashboardUnhealthy;

  /// No description provided for @sellerHealthUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {ago}'**
  String sellerHealthUpdated(String ago);

  /// No description provided for @sellerHealthJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get sellerHealthJustNow;

  /// No description provided for @sellerHealthMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String sellerHealthMinutesAgo(int count);

  /// No description provided for @sellerHealthHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String sellerHealthHoursAgo(int count);

  /// No description provided for @sellerHealthDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String sellerHealthDaysAgo(int count);

  /// No description provided for @sellerHealthNotCalculated.
  ///
  /// In en, this message translates to:
  /// **'Not calculated'**
  String get sellerHealthNotCalculated;

  /// No description provided for @sellerHealthNotCalculatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Calculated'**
  String get sellerHealthNotCalculatedTitle;

  /// No description provided for @sellerHealthRefreshNow.
  ///
  /// In en, this message translates to:
  /// **'Refresh now'**
  String get sellerHealthRefreshNow;

  /// No description provided for @sellerHealthOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall Health'**
  String get sellerHealthOverall;

  /// No description provided for @sellerHealthStandingGood.
  ///
  /// In en, this message translates to:
  /// **'Your account is in good standing.'**
  String get sellerHealthStandingGood;

  /// No description provided for @sellerHealthStandingRisk.
  ///
  /// In en, this message translates to:
  /// **'Your account needs attention.'**
  String get sellerHealthStandingRisk;

  /// No description provided for @sellerHealthStandingBad.
  ///
  /// In en, this message translates to:
  /// **'Your account is at risk. Improve your metrics.'**
  String get sellerHealthStandingBad;

  /// No description provided for @sellerHealthScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get sellerHealthScoreTitle;

  /// No description provided for @sellerHealthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get sellerHealthGood;

  /// No description provided for @sellerHealthWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get sellerHealthWarning;

  /// No description provided for @sellerHealthCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get sellerHealthCritical;

  /// No description provided for @sellerHealthCancellationTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Cancellation Rate'**
  String get sellerHealthCancellationTitle;

  /// No description provided for @sellerHealthCancellationDesc.
  ///
  /// In en, this message translates to:
  /// **'Cancelled units over the last {days} days.'**
  String sellerHealthCancellationDesc(int days);

  /// No description provided for @sellerHealthCancellationTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: below {value}%'**
  String sellerHealthCancellationTarget(String value);

  /// No description provided for @sellerHealthCancellationHelp.
  ///
  /// In en, this message translates to:
  /// **'Share of ordered units you cancelled. Keep it low to stay in good standing.'**
  String get sellerHealthCancellationHelp;

  /// No description provided for @sellerHealthFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Feedback'**
  String get sellerHealthFeedbackTitle;

  /// No description provided for @sellerHealthFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Your average customer rating.'**
  String get sellerHealthFeedbackDesc;

  /// No description provided for @sellerHealthFeedbackTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: {value} and above'**
  String sellerHealthFeedbackTarget(String value);

  /// No description provided for @sellerHealthFeedbackHelp.
  ///
  /// In en, this message translates to:
  /// **'Your average customer rating across all approved reviews.'**
  String get sellerHealthFeedbackHelp;

  /// No description provided for @sellerHealthFlagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flags'**
  String get sellerHealthFlagsTitle;

  /// No description provided for @sellerHealthFlagsDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} flag(s) raised against your store.'**
  String sellerHealthFlagsDesc(String count);

  /// No description provided for @sellerHealthFlagsLimit.
  ///
  /// In en, this message translates to:
  /// **'Red flag limit: {limit}'**
  String sellerHealthFlagsLimit(int limit);

  /// No description provided for @sellerHealthFlagsHelp.
  ///
  /// In en, this message translates to:
  /// **'Flags raised against your store by customers.'**
  String get sellerHealthFlagsHelp;

  /// No description provided for @sellerHealthLastDays.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String sellerHealthLastDays(int days);

  /// No description provided for @sellerHealthRefreshIn.
  ///
  /// In en, this message translates to:
  /// **'You can refresh again in {time}'**
  String sellerHealthRefreshIn(String time);

  /// No description provided for @accountMyReturns.
  ///
  /// In en, this message translates to:
  /// **'RMA'**
  String get accountMyReturns;

  /// No description provided for @accountReturns.
  ///
  /// In en, this message translates to:
  /// **'RMA'**
  String get accountReturns;

  /// No description provided for @accountReturnSingular.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get accountReturnSingular;

  /// No description provided for @accountReturnPlural.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get accountReturnPlural;

  /// No description provided for @accountNoReturnsYet.
  ///
  /// In en, this message translates to:
  /// **'No Returns Yet'**
  String get accountNoReturnsYet;

  /// No description provided for @accountReturnsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your return requests will appear here.'**
  String get accountReturnsEmptyDescription;

  /// No description provided for @accountReturnWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Return {number}'**
  String accountReturnWithNumber(Object number);

  /// No description provided for @accountReturnOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String accountReturnOrderLabel(Object number);

  /// No description provided for @accountReturnQtyValue.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String accountReturnQtyValue(int count);

  /// No description provided for @accountReturnMaxQty.
  ///
  /// In en, this message translates to:
  /// **'Max: {count}'**
  String accountReturnMaxQty(int count);

  /// No description provided for @accountReturnResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get accountReturnResolution;

  /// No description provided for @accountReturnResolutionReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get accountReturnResolutionReturn;

  /// No description provided for @accountReturnResolutionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Items'**
  String get accountReturnResolutionCancel;

  /// No description provided for @accountReturnReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get accountReturnReason;

  /// No description provided for @accountReturnSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get accountReturnSelectReason;

  /// No description provided for @accountReturnPackageCondition.
  ///
  /// In en, this message translates to:
  /// **'Package Condition'**
  String get accountReturnPackageCondition;

  /// No description provided for @accountReturnPackageConditionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. opened, sealed, damaged box'**
  String get accountReturnPackageConditionHint;

  /// No description provided for @accountReturnAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get accountReturnAdditionalInfo;

  /// No description provided for @accountReturnAdditionalInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue (optional)'**
  String get accountReturnAdditionalInfoHint;

  /// No description provided for @accountReturnEvidenceImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get accountReturnEvidenceImages;

  /// No description provided for @accountReturnAddImages.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get accountReturnAddImages;

  /// No description provided for @accountReturnAgreement.
  ///
  /// In en, this message translates to:
  /// **'I agree with the return policy terms'**
  String get accountReturnAgreement;

  /// No description provided for @accountReturnAgreementRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the return policy terms'**
  String get accountReturnAgreementRequired;

  /// No description provided for @accountReturnSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get accountReturnSubmit;

  /// No description provided for @accountReturnCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get accountReturnCreatedTitle;

  /// No description provided for @accountReturnCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your return request has been submitted successfully.'**
  String get accountReturnCreatedMessage;

  /// No description provided for @accountReturnSelectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get accountReturnSelectItem;

  /// No description provided for @accountReturnNoReturnableItems.
  ///
  /// In en, this message translates to:
  /// **'No Returnable Items'**
  String get accountReturnNoReturnableItems;

  /// No description provided for @accountReturnNoReturnableItemsDescription.
  ///
  /// In en, this message translates to:
  /// **'This order has no items eligible for return or cancellation.'**
  String get accountReturnNoReturnableItemsDescription;

  /// No description provided for @accountReturnViewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get accountReturnViewAction;

  /// No description provided for @accountReturnCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get accountReturnCancelAction;

  /// No description provided for @accountReturnCloseAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as Solved'**
  String get accountReturnCloseAction;

  /// No description provided for @accountReturnReopenAction.
  ///
  /// In en, this message translates to:
  /// **'Reopen Request'**
  String get accountReturnReopenAction;

  /// No description provided for @accountReturnCancelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this return request?'**
  String get accountReturnCancelConfirmation;

  /// No description provided for @accountReturnCloseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Mark this return request as solved?'**
  String get accountReturnCloseConfirmation;

  /// No description provided for @accountReturnMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get accountReturnMessages;

  /// No description provided for @accountReturnNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get accountReturnNoMessages;

  /// No description provided for @accountReturnMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message…'**
  String get accountReturnMessageHint;

  /// No description provided for @accountReturnStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Return status updated to {status}'**
  String accountReturnStatusUpdated(Object status);

  /// No description provided for @accountReturnExpired.
  ///
  /// In en, this message translates to:
  /// **'Return window expired'**
  String get accountReturnExpired;

  /// No description provided for @accountReturnInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get accountReturnInformation;

  /// No description provided for @accountReturnSelectOrder.
  ///
  /// In en, this message translates to:
  /// **'Select an order'**
  String get accountReturnSelectOrder;

  /// No description provided for @accountReturnChangeOrder.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get accountReturnChangeOrder;

  /// No description provided for @accountReturnChooseAnotherOrder.
  ///
  /// In en, this message translates to:
  /// **'Choose another order'**
  String get accountReturnChooseAnotherOrder;

  /// No description provided for @accountCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get accountCancelOrder;

  /// No description provided for @accountCancelOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order? This cannot be undone.'**
  String get accountCancelOrderConfirmation;

  /// No description provided for @accountReviewPhotosVideos.
  ///
  /// In en, this message translates to:
  /// **'Photos & Videos'**
  String get accountReviewPhotosVideos;

  /// No description provided for @accountReviewGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get accountReviewGallery;

  /// No description provided for @accountReviewCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get accountReviewCamera;

  /// No description provided for @accountReviewMaxFiles.
  ///
  /// In en, this message translates to:
  /// **'You can attach up to {count} files'**
  String accountReviewMaxFiles(int count);

  /// No description provided for @accountReviewFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Each file must be 5 MB or smaller'**
  String get accountReviewFileTooLarge;

  /// No description provided for @accountReviewUnsupportedFile.
  ///
  /// In en, this message translates to:
  /// **'Only images and videos are supported'**
  String get accountReviewUnsupportedFile;

  /// No description provided for @accountReviewPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add media. Please try again'**
  String get accountReviewPickFailed;

  /// No description provided for @accountReviewVideoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to play this video'**
  String get accountReviewVideoLoadFailed;

  /// No description provided for @accountShippedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Shipped'**
  String accountShippedCount(int count);

  /// No description provided for @accountReturnNoEligibleOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders are eligible for a return right now'**
  String get accountReturnNoEligibleOrders;

  /// No description provided for @accountRequestReturn.
  ///
  /// In en, this message translates to:
  /// **'Request a Return'**
  String get accountRequestReturn;

  /// No description provided for @accountRefundBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Refund Breakdown'**
  String get accountRefundBreakdown;

  /// No description provided for @accountSubtotalRefunded.
  ///
  /// In en, this message translates to:
  /// **'Subtotal Refunded'**
  String get accountSubtotalRefunded;

  /// No description provided for @accountShippingRefunded.
  ///
  /// In en, this message translates to:
  /// **'Shipping Refunded'**
  String get accountShippingRefunded;

  /// No description provided for @accountTaxRefunded.
  ///
  /// In en, this message translates to:
  /// **'Tax Refunded'**
  String get accountTaxRefunded;

  /// No description provided for @accountDiscountRefunded.
  ///
  /// In en, this message translates to:
  /// **'Discount Refunded'**
  String get accountDiscountRefunded;

  /// No description provided for @accountRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get accountRefunded;

  /// No description provided for @accountCanceledQty.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get accountCanceledQty;

  /// No description provided for @productBookingCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get productBookingCancellation;

  /// No description provided for @productBookingCancellationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Not Allowed'**
  String get productBookingCancellationNotAllowed;

  /// No description provided for @accountBookingItemsNotCanceled.
  ///
  /// In en, this message translates to:
  /// **'Booking items in this order will not be canceled.'**
  String get accountBookingItemsNotCanceled;

  /// No description provided for @cartQtyValue.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String cartQtyValue(int count);

  /// No description provided for @checkoutAccountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended. You can browse the store, but you cannot place orders.'**
  String get checkoutAccountSuspended;

  /// No description provided for @accountGenderRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender *'**
  String get accountGenderRequiredLabel;

  /// No description provided for @accountGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is required'**
  String get accountGenderRequired;

  /// No description provided for @accountPhoneRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get accountPhoneRequiredLabel;

  /// No description provided for @cartGuestCheckoutNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to check out these items.'**
  String get cartGuestCheckoutNotAllowed;

  /// No description provided for @accountEuWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw from Contract'**
  String get accountEuWithdraw;

  /// No description provided for @accountEuWithdrawGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw from Your Contract'**
  String get accountEuWithdrawGuestTitle;

  /// No description provided for @accountEuWithdrawReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get accountEuWithdrawReason;

  /// No description provided for @accountEuWithdrawSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send me the withdrawal link'**
  String get accountEuWithdrawSubmit;

  /// No description provided for @accountEuWithdrawSubmitted.
  ///
  /// In en, this message translates to:
  /// **'If a matching order exists, we have just emailed a withdrawal link to that address. It will be valid for 24 hours.'**
  String get accountEuWithdrawSubmitted;

  /// No description provided for @accountEuWithdrawStatus.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request: {status}'**
  String accountEuWithdrawStatus(String status);

  /// No description provided for @accountEuWithdrawGuestDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the order number and the email address you used at checkout. We will send you a link to file your withdrawal.'**
  String get accountEuWithdrawGuestDescription;

  /// No description provided for @accountEuWithdrawOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get accountEuWithdrawOrderNumber;

  /// No description provided for @accountEuWithdrawEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get accountEuWithdrawEmail;

  /// No description provided for @accountEuWithdrawFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get accountEuWithdrawFieldRequired;

  /// No description provided for @accountEuWithdrawView.
  ///
  /// In en, this message translates to:
  /// **'View your withdrawal'**
  String get accountEuWithdrawView;

  /// No description provided for @accountEuWithdrawReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Receipt'**
  String get accountEuWithdrawReceiptTitle;

  /// No description provided for @accountEuWithdrawReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal has been received'**
  String get accountEuWithdrawReceivedTitle;

  /// No description provided for @accountEuWithdrawReceivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have recorded your declaration. This page and the email we just sent you both serve as confirmation on a durable medium.'**
  String get accountEuWithdrawReceivedSubtitle;

  /// No description provided for @accountEuWithdrawReceivedAt.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED AT'**
  String get accountEuWithdrawReceivedAt;

  /// No description provided for @accountEuWithdrawReference.
  ///
  /// In en, this message translates to:
  /// **'REFERENCE'**
  String get accountEuWithdrawReference;

  /// No description provided for @accountEuWithdrawOrder.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get accountEuWithdrawOrder;

  /// No description provided for @accountEuWithdrawEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get accountEuWithdrawEmailLabel;

  /// No description provided for @accountEuWithdrawStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get accountEuWithdrawStatusLabel;

  /// No description provided for @accountEuWithdrawReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'REASON'**
  String get accountEuWithdrawReasonLabel;

  /// No description provided for @accountEuWithdrawWhatNext.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get accountEuWithdrawWhatNext;

  /// No description provided for @accountEuWithdrawNextRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your declaration has been received and recorded.'**
  String get accountEuWithdrawNextRecorded;

  /// No description provided for @accountEuWithdrawNextEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent to your inbox.'**
  String get accountEuWithdrawNextEmail;

  /// No description provided for @accountEuWithdrawNextEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email has been sent.'**
  String get accountEuWithdrawNextEmailDesc;

  /// No description provided for @accountEuWithdrawNextRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund issued within 14 days.'**
  String get accountEuWithdrawNextRefund;

  /// No description provided for @accountEuWithdrawNextRefundDesc.
  ///
  /// In en, this message translates to:
  /// **'We reimburse using the same means of payment you used for the original transaction, unless you have expressly agreed otherwise.'**
  String get accountEuWithdrawNextRefundDesc;

  /// No description provided for @accountEuWithdrawReceiptFooter.
  ///
  /// In en, this message translates to:
  /// **'This page is your receipt. You may save or print it.'**
  String get accountEuWithdrawReceiptFooter;

  /// No description provided for @accountEuWithdrawReferenceCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference copied to clipboard'**
  String get accountEuWithdrawReferenceCopied;

  /// No description provided for @accountEuWithdrawDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal was declined'**
  String get accountEuWithdrawDeclinedTitle;

  /// No description provided for @accountEuWithdrawDeclinedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The merchant has contested your entitlement to a refund under this declaration. See the details below for the reason given and your remaining options.'**
  String get accountEuWithdrawDeclinedSubtitle;

  /// No description provided for @accountEuWithdrawNextDeclined.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal declined by the merchant.'**
  String get accountEuWithdrawNextDeclined;

  /// No description provided for @accountEuWithdrawMerchantReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'REASON GIVEN BY THE MERCHANT'**
  String get accountEuWithdrawMerchantReasonLabel;

  /// No description provided for @accountEuWithdrawDeclinedLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'You retain all other legal remedies under EU consumer law. If you disagree with this decision, contact the merchant directly.'**
  String get accountEuWithdrawDeclinedLegalNotice;

  /// No description provided for @sellerAssignProfileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please update your profile details'**
  String get sellerAssignProfileIncomplete;

  /// No description provided for @sellerAssignProfileIncompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile before assigning products for sale.'**
  String get sellerAssignProfileIncompleteBody;

  /// No description provided for @sellerAssignUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get sellerAssignUpdateProfile;

  /// No description provided for @accountBookingNotCanceledTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Items Will Not Be Canceled'**
  String get accountBookingNotCanceledTitle;

  /// No description provided for @accountBookingNotCanceledBody.
  ///
  /// In en, this message translates to:
  /// **'This order contains booking products marked as non-cancellable. Cancelling the order will only cancel the remaining items; the booking items will remain active. Please contact support if you need assistance with the booking items.'**
  String get accountBookingNotCanceledBody;

  /// No description provided for @marketplaceLandingVisitShopButton.
  ///
  /// In en, this message translates to:
  /// **'Visit Shop'**
  String get marketplaceLandingVisitShopButton;

  /// No description provided for @sellerProductActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerProductActiveLabel;

  /// No description provided for @sellerProductDisableLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get sellerProductDisableLabel;

  /// No description provided for @sellerProductWaitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting For Approval'**
  String get sellerProductWaitingForApproval;

  /// No description provided for @sellerProductOutOfStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Out Of Stock'**
  String get sellerProductOutOfStockLabel;

  /// No description provided for @sellerProductStockAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} Available'**
  String sellerProductStockAvailable(int count);

  /// No description provided for @sellerProductBarcodeNotGenerated.
  ///
  /// In en, this message translates to:
  /// **'Not Generated'**
  String get sellerProductBarcodeNotGenerated;

  /// No description provided for @sellerProductIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID - {id}'**
  String sellerProductIdLabel(int id);

  /// No description provided for @sellerAssignedProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Product'**
  String get sellerAssignedProductTitle;

  /// No description provided for @sellerAssignedPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get sellerAssignedPriceInvalid;

  /// No description provided for @sellerAssignedProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get sellerAssignedProductDetails;

  /// No description provided for @sellerProductDisapproved.
  ///
  /// In en, this message translates to:
  /// **'Disapproved'**
  String get sellerProductDisapproved;

  /// No description provided for @accountPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get accountPhoneNumberLabel;

  /// No description provided for @accountContactUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Jot us a note, and we’ll get back to you as quickly as possible'**
  String get accountContactUsDescription;

  /// No description provided for @accountPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get accountPhoneNumber;

  /// No description provided for @accountWhatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What’s on your mind?'**
  String get accountWhatsOnYourMind;

  /// No description provided for @accountDescribeHere.
  ///
  /// In en, this message translates to:
  /// **'Describe Here'**
  String get accountDescribeHere;

  /// No description provided for @accountSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get accountSubmit;

  /// No description provided for @sellerPlansMaxProductsChip.
  ///
  /// In en, this message translates to:
  /// **'Max Products'**
  String get sellerPlansMaxProductsChip;

  /// No description provided for @sellerPlansMaxStaffChip.
  ///
  /// In en, this message translates to:
  /// **'Max Staff Ids'**
  String get sellerPlansMaxStaffChip;

  /// No description provided for @sellerPlansCommissionChip.
  ///
  /// In en, this message translates to:
  /// **'Admin Commission'**
  String get sellerPlansCommissionChip;

  /// No description provided for @sellerPlansDurationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String sellerPlansDurationDays(int count);

  /// No description provided for @sellerPlansPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get sellerPlansPermissions;

  /// No description provided for @sellerPlansProductTypes.
  ///
  /// In en, this message translates to:
  /// **'Product Types'**
  String get sellerPlansProductTypes;

  /// No description provided for @sellerPlansNoProductTypes.
  ///
  /// In en, this message translates to:
  /// **'No Product Types'**
  String get sellerPlansNoProductTypes;

  /// No description provided for @sellerPlansTerms.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree with the terms and conditions.'**
  String get sellerPlansTerms;

  /// No description provided for @sellerPlansProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get sellerPlansProceed;

  /// No description provided for @sellerPlansPaidNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a paid plan. Buy it from the seller panel on the web, where the payment gateway runs.'**
  String get sellerPlansPaidNotice;

  /// No description provided for @sellerPlansCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get sellerPlansCurrentPlan;

  /// No description provided for @sellerPlansNoPlans.
  ///
  /// In en, this message translates to:
  /// **'No plans on offer yet.'**
  String get sellerPlansNoPlans;

  /// No description provided for @sellerPlansNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No past subscriptions yet.'**
  String get sellerPlansNoHistory;

  /// No description provided for @sellerPlansHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan History'**
  String get sellerPlansHistoryTitle;

  /// No description provided for @sellerPlansPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get sellerPlansPaymentMethod;

  /// No description provided for @sellerPlansNoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment method is enabled for this marketplace.'**
  String get sellerPlansNoPaymentMethods;

  /// No description provided for @sellerPlansStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get sellerPlansStartDate;

  /// No description provided for @sellerPlansEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get sellerPlansEndDate;

  /// No description provided for @sellerPlansPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get sellerPlansPayment;

  /// No description provided for @sellerPlansPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerPlansPrice;

  /// No description provided for @sellerPlansAclDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get sellerPlansAclDashboard;

  /// No description provided for @sellerPlansAclProfile.
  ///
  /// In en, this message translates to:
  /// **'Manage Profile'**
  String get sellerPlansAclProfile;

  /// No description provided for @sellerPlansAclCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get sellerPlansAclCatalog;

  /// No description provided for @sellerPlansAclInventories.
  ///
  /// In en, this message translates to:
  /// **'Inventories'**
  String get sellerPlansAclInventories;

  /// No description provided for @sellerPlansAclPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get sellerPlansAclPricing;

  /// No description provided for @sellerPlansAclMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get sellerPlansAclMarketing;

  /// No description provided for @sellerPlansAclSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sellerPlansAclSales;

  /// No description provided for @sellerPlansAclPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get sellerPlansAclPerformance;

  /// No description provided for @sellerPlansAclReporting.
  ///
  /// In en, this message translates to:
  /// **'Reporting'**
  String get sellerPlansAclReporting;

  /// No description provided for @sellerPlansAclCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get sellerPlansAclCommunication;

  /// No description provided for @sellerPlansAclCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sellerPlansAclCustomers;

  /// No description provided for @sellerPlansAclSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sellerPlansAclSettings;

  /// No description provided for @priceStartingAt.
  ///
  /// In en, this message translates to:
  /// **'Starting at'**
  String get priceStartingAt;

  /// No description provided for @priceStartingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get priceStartingFrom;

  /// No description provided for @priceAsLowAs.
  ///
  /// In en, this message translates to:
  /// **'As low as'**
  String get priceAsLowAs;

  /// No description provided for @priceRangeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get priceRangeTo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'nl',
    'ru',
    'tr',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
