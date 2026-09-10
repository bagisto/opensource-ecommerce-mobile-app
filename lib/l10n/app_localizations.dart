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
  /// **'Details'**
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
  /// **'More Informations'**
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
  /// **'Related Product'**
  String get productRelatedProduct;

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
  /// **'Your order No. #{orderNumber}'**
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
  /// **'Nick Name'**
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
  /// **'Summary'**
  String get accountSummary;

  /// No description provided for @accountReviewSummaryHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your review'**
  String get accountReviewSummaryHint;

  /// No description provided for @accountSummaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Summary is required'**
  String get accountSummaryRequired;

  /// No description provided for @accountReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get accountReview;

  /// No description provided for @accountDetailedReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Write your detailed review here'**
  String get accountDetailedReviewHint;

  /// No description provided for @accountReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Review is required'**
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

  /// No description provided for @accountMyReturns.
  ///
  /// In en, this message translates to:
  /// **'My Returns'**
  String get accountMyReturns;

  /// No description provided for @accountReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
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
