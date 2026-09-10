// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Bagisto Winkel';

  @override
  String get homeFailedToLoad => 'Startpagina kon niet worden geladen';

  @override
  String get commonUnknownError => 'Onbekende fout';

  @override
  String get commonRetry => 'Opnieuw proberen';

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
  String get homeFeaturedProducts => 'Uitgelichte producten';

  @override
  String get homeDefaultProducts => 'Producten';

  @override
  String get homeBackToTop => 'Terug naar boven';

  @override
  String get homeViewCart => 'BEKIJK WINKELWAGEN';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName toegevoegd aan winkelwagen';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Log in om de verlanglijst te beheren';

  @override
  String get homeAddedToWishlist => 'Toegevoegd aan verlanglijst';

  @override
  String get homeRemovedFromWishlist => 'Verwijderd uit verlanglijst';

  @override
  String get homeViewAll => 'Alles bekijken';

  @override
  String get homeCollections => 'Collecties';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Categorie $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% korting';
  }

  @override
  String get productFailedToLoad => 'Product kon niet worden geladen';

  @override
  String get productNotFound => 'Product niet gevonden';

  @override
  String get productDetail => 'Productdetails';

  @override
  String get productDetails => 'Details';

  @override
  String get productShowLess => 'Minder tonen';

  @override
  String get productLoadMore => 'Meer laden';

  @override
  String get productMoreInformations => 'Meer informatie';

  @override
  String get productSku => 'SKU';

  @override
  String get productType => 'Type';

  @override
  String get productBrand => 'Merk';

  @override
  String get productColor => 'Kleur';

  @override
  String get productSize => 'Maat';

  @override
  String get productReviews => 'Beoordelingen';

  @override
  String get productNoReviewsYet => 'Nog geen beoordelingen';

  @override
  String productRating(Object count) {
    return '$count beoordeling';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count beoordelingen';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Geplaatst op $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Je beoordeling is verzonden!';

  @override
  String get productWriteReview => 'Beoordeling schrijven';

  @override
  String get productPleaseLoginForReviews =>
      'Log in om je beoordelingen te bekijken';

  @override
  String get productLoadMoreReviews => 'Meer beoordelingen laden';

  @override
  String get productRelatedProduct => 'Gerelateerd product';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% korting';
  }

  @override
  String get productVeryGood => 'Zeer goed';

  @override
  String get productGood => 'Goed';

  @override
  String get productAverage => 'Gemiddeld';

  @override
  String get productBad => 'Slecht';

  @override
  String get productVeryBad => 'Zeer slecht';

  @override
  String get productInStock => 'Op voorraad';

  @override
  String get productOutOfStock => 'Niet op voorraad';

  @override
  String get productQuantity => 'Aantal';

  @override
  String get productWishlistAction => 'Verlanglijst';

  @override
  String get productCompareAction => 'Vergelijken';

  @override
  String get productShareAction => 'Delen';

  @override
  String get productLoginToCompare => 'Log in om toe te voegen aan vergelijken';

  @override
  String get productAddedToCompare => 'Toegevoegd aan vergelijken';

  @override
  String get productAddToCart => 'Toevoegen aan winkelwagen';

  @override
  String get accountMoveToCart => 'Verplaatsen naar winkelwagen';

  @override
  String get productBuyNow => 'Nu kopen';

  @override
  String get productSelectOptionsFirst => 'Selecteer eerst productopties';

  @override
  String get productBookingBookTable => 'Tafel reserveren *';

  @override
  String get productBookingSelectDateRequired => 'Datum selecteren *';

  @override
  String get productBookingSelectSlotRequired => 'Tijdslot selecteren *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Speciale verzoeken/Notities *';

  @override
  String get productBookingBookAppointment => 'Afspraak boeken *';

  @override
  String get productBookingDateFormatHint => 'JJJJ-MM-DD';

  @override
  String get productBookingFrom => 'Van';

  @override
  String get productBookingTo => 'Tot';

  @override
  String get productBookingSelectDate => 'Datum selecteren';

  @override
  String get productBookingLocation => 'Locatie';

  @override
  String get productBookingSlotDuration => 'Duur van het tijdslot';

  @override
  String get productBookingAvailability => 'Beschikbaarheid';

  @override
  String get productBookingStartDate => 'Startdatum';

  @override
  String get productBookingEndDate => 'Einddatum';

  @override
  String get productBookingDate => 'Datum';

  @override
  String get productBookingViewOnMap => 'Bekijk op kaart';

  @override
  String get productBookingEventOn => 'Evenement op:';

  @override
  String get productBookingBookYourTicket => 'Boek je ticket';

  @override
  String get productBookingSlotDurationLabel => 'Duur van het tijdslot:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count minuten';
  }

  @override
  String get productBookingAvailableFrom => 'Beschikbaar vanaf';

  @override
  String get productBookingAvailableTo => 'Beschikbaar tot';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Speciale verzoeken/Notities';

  @override
  String get productBookingChooseRentOption => 'Kies huurtype *';

  @override
  String get productBookingDailyBasis => 'Per dag';

  @override
  String get productBookingHourlyBasis => 'Per uur';

  @override
  String get productBookingNoDatesAvailable =>
      'Geen data beschikbaar voor reservering';

  @override
  String get productBookingSelectSlot => 'Tijdslot selecteren';

  @override
  String get productBookingSelectDateFirst => 'Selecteer eerst een datum';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Selecteer eerst een datum om beschikbare tijdslots te zien.';

  @override
  String get productBookingLoadingSlots => 'Tijdslots laden...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Beschikbare tijdslots voor de geselecteerde datum worden geladen.';

  @override
  String get productBookingUnableToLoadSlots => 'Kan tijdslots niet laden';

  @override
  String get productBookingNoSlotsAvailable => 'Geen tijdslots beschikbaar';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Er zijn geen tijdslots beschikbaar voor de geselecteerde datum.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Selecteer een beschikbaar tijdslot om verder te gaan.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Speciale verzoeken/Notities';

  @override
  String get productDownloadableLinks => 'Links';

  @override
  String get productDownloadableSamples => 'Voorbeelden';

  @override
  String get productDownloadSample => 'Voorbeeld downloaden';

  @override
  String get productDefaultName => 'Product';

  @override
  String get categoryDefaultName => 'Categorieën';

  @override
  String get categorySubCategories => 'Subcategorieën';

  @override
  String get categorySomethingWentWrong => 'Er is iets misgegaan';

  @override
  String get categoryUnknownError => 'Onbekende fout';

  @override
  String categoryItemsFound(Object count) {
    return '$count artikelen gevonden';
  }

  @override
  String get categoryNoProductsFound => 'Geen producten gevonden';

  @override
  String get categorySort => 'Sorteren';

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
  String get categoryFilter => 'Filteren';

  @override
  String get categoryFilters => 'Filters';

  @override
  String get categoryNoFiltersAvailable => 'Geen filters beschikbaar';

  @override
  String get categoryFiltersWillAppear =>
      'Filters verschijnen wanneer beschikbaar voor deze categorie';

  @override
  String get categoryApplyFilters => 'Filters toepassen';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Filters toepassen ($count)';
  }

  @override
  String get categoryClearAll => 'Alles wissen';

  @override
  String get categoryTryAdjustingFilters =>
      'Probeer je filters of zoekcriteria aan te passen';

  @override
  String get categoryError => 'Fout';

  @override
  String get categoryLoginToManageWishlist =>
      'Log in om de verlanglijst te beheren';

  @override
  String get categoryAddedToWishlist => 'Toegevoegd aan verlanglijst';

  @override
  String get categoryRemovedFromWishlist => 'Verwijderd uit verlanglijst';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Verlanglijst kon niet worden bijgewerkt: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Winkelwagen';

  @override
  String get cartPleaseLoginWishlist => 'Log in om de verlanglijst te bekijken';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText in de winkelwagen';
  }

  @override
  String get cartYourCartEmpty => 'Je winkelwagen is leeg';

  @override
  String get cartAddProductsHere =>
      'Voeg producten toe aan je winkelwagen om ze hier te zien';

  @override
  String get cartContinueShopping => 'Verder winkelen';

  @override
  String get cartUnit => 'Eenheid';

  @override
  String get cartUnits => 'Eenheden';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Log in om toe te voegen aan verlanglijst';

  @override
  String get cartMovedToWishlist => 'Verplaatst naar verlanglijst';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Verplaatsen naar verlanglijst mislukt: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Meer bekijken';

  @override
  String get cartViewLess => 'Minder bekijken';

  @override
  String get cartEmptyCartAction => 'Winkelwagen legen';

  @override
  String get cartApplyCoupon => 'Coupon toepassen';

  @override
  String get cartCouponCode => 'Couponcode';

  @override
  String get cartApply => 'Toepassen';

  @override
  String get cartAppliedCoupon => 'Coupon toegepast';

  @override
  String get cartRemove => 'Verwijderen';

  @override
  String get cartPriceBreak => 'Prijsopbouw';

  @override
  String get cartSubTotal => 'Subtotaal';

  @override
  String get cartDiscount => 'Korting';

  @override
  String get cartDeliveryCharges => 'Verzendkosten';

  @override
  String get cartTax => 'Belasting';

  @override
  String get cartGrandTotal => 'Eindtotaal';

  @override
  String get cartAmountToBePaid => 'Te betalen bedrag';

  @override
  String get cartPayNow => 'Nu betalen';

  @override
  String get cartRemoveItem => 'Artikel verwijderen';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Weet je zeker dat je \"$productName\" uit je winkelwagen wilt verwijderen?';
  }

  @override
  String get cartCancel => 'Annuleren';

  @override
  String get cartEmptyCartTitle => 'Winkelwagen legen';

  @override
  String get cartEmptyCartConfirm =>
      'Weet je zeker dat je alle artikelen uit je winkelwagen wilt verwijderen?';

  @override
  String get checkout => 'Afrekenen';

  @override
  String get checkoutBillingTo => 'Factureren aan';

  @override
  String get checkoutDeliveredTo => 'Geleverd aan';

  @override
  String get checkoutChange => 'Wijzigen';

  @override
  String get checkoutSelectBillingAddress => 'Factuuradres selecteren';

  @override
  String get checkoutSelectShippingAddress => 'Verzendadres selecteren';

  @override
  String get checkoutBillingAddress => 'Factuuradres';

  @override
  String get checkoutEnterAddress => 'Adres invoeren';

  @override
  String get checkoutFirstName => 'Voornaam';

  @override
  String get checkoutLastName => 'Achternaam';

  @override
  String get checkoutEmail => 'E-mail';

  @override
  String get checkoutPhone => 'Telefoon';

  @override
  String get checkoutStreetAddress => 'Straatadres';

  @override
  String get checkoutCountry => 'Land';

  @override
  String get checkoutState => 'Provincie';

  @override
  String get checkoutCity => 'Stad';

  @override
  String get checkoutPostcode => 'Postcode';

  @override
  String get checkoutCompanyOptional => 'Bedrijf (optioneel)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Hetzelfde adres voor verzending gebruiken?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Telefoon: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Kantoor';

  @override
  String get checkoutAddressTypeHome => 'Thuis';

  @override
  String get checkoutAddressTypeBilling => 'Facturering';

  @override
  String get checkoutAddressTypeShipping => 'Verzending';

  @override
  String get checkoutAddressTypeDefault => 'Standaard';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field is verplicht';
  }

  @override
  String get checkoutSaveContinue => 'Opslaan en doorgaan';

  @override
  String get checkoutYourCartEmpty => 'Je winkelwagen is leeg';

  @override
  String get checkoutSelectCountry => 'Land selecteren';

  @override
  String get checkoutSelectState => 'Provincie selecteren';

  @override
  String get checkoutCountryRequired => 'Land is verplicht';

  @override
  String get checkoutStateRequired => 'Provincie is verplicht';

  @override
  String get checkoutSelectCountryFirst => 'Selecteer eerst een land';

  @override
  String get checkoutShippingMethod => 'Verzendmethode';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Sla je adres op om verzendopties te zien';

  @override
  String get checkoutPaymentMethod => 'Betaalmethode';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Selecteer eerst een verzendmethode';

  @override
  String get checkoutEnterCouponCode => 'Voer je couponcode in';

  @override
  String get checkoutDiscountCoupon => 'Korting (coupon)';

  @override
  String get checkoutPlaceOrder => 'Bestelling plaatsen';

  @override
  String get thankYouTitle => 'Bedankt voor je bestelling!';

  @override
  String get thankYouSubtitle =>
      'We mailen je de bestelgegevens en trackinginformatie';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Je bestelnummer is $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Bestelling bekijken';

  @override
  String get thankYouContinueShopping => 'Verder winkelen';

  @override
  String get accountPleaseTryAgainLater => 'Probeer het later opnieuw';

  @override
  String get accountUserFallback => 'Gebruiker';

  @override
  String get accountBack => 'Terug';

  @override
  String get accountSettings => 'Instellingen';

  @override
  String get accountMyOrders => 'Mijn bestellingen';

  @override
  String get accountMyDownloadableProducts => 'Mijn downloadbare producten';

  @override
  String get accountWishlist => 'Verlanglijst';

  @override
  String get accountCompareProducts => 'Producten vergelijken';

  @override
  String get accountProductReview => 'Productbeoordeling';

  @override
  String get accountAddressBook => 'Adresboek';

  @override
  String get accountEditAccount => 'Account bewerken';

  @override
  String get accountLogout => 'Uitloggen';

  @override
  String get accountLogoutConfirmation =>
      'Weet je zeker dat je wilt uitloggen?';

  @override
  String get accountNoCountriesAvailable =>
      'Geen landen beschikbaar. Probeer het opnieuw.';

  @override
  String get accountPleaseSelectCountry => 'Selecteer een land';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Selecteer of voer een provincie in';

  @override
  String get accountAddressUpdatedSuccessfully => 'Adres succesvol bijgewerkt';

  @override
  String get accountAddressAddedSuccessfully => 'Adres succesvol toegevoegd';

  @override
  String get accountGoBack => 'Ga terug';

  @override
  String get accountEditAddress => 'Adres bewerken';

  @override
  String get accountAddNewAddress => 'Nieuw adres toevoegen';

  @override
  String get accountFirstNameRequired => 'Voornaam is verplicht';

  @override
  String get accountLastNameRequired => 'Achternaam is verplicht';

  @override
  String get accountEnterValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get accountCompanyName => 'Bedrijfsnaam';

  @override
  String get accountVatId => 'Btw-nummer';

  @override
  String get accountStreetAddressRequired => 'Straatadres is verplicht';

  @override
  String get accountCityRequired => 'Stad is verplicht';

  @override
  String get accountZipPostcode => 'Postcode';

  @override
  String get accountZipPostcodeRequired => 'Postcode is verplicht';

  @override
  String get accountTelephone => 'Telefoon';

  @override
  String get accountPhoneNumberRequired => 'Telefoonnummer is verplicht';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Standaard factuuradres wijzigen';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Standaard verzendadres wijzigen';

  @override
  String get accountUpdateAddress => 'Adres bijwerken';

  @override
  String get accountSaveToAddressBook => 'Opslaan in adresboek';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Log in om een beoordeling te schrijven';

  @override
  String get accountPleaseSelectRating => 'Selecteer een beoordeling';

  @override
  String get accountAddReview => 'Beoordeling toevoegen';

  @override
  String get accountReviewSubmitted => 'Beoordeling verzonden!';

  @override
  String get accountNickName => 'Bijnaam';

  @override
  String get accountEnterYourName => 'Voer je naam in';

  @override
  String get accountNameRequired => 'Naam is verplicht';

  @override
  String get accountSummary => 'Samenvatting';

  @override
  String get accountReviewSummaryHint =>
      'Korte samenvatting van je beoordeling';

  @override
  String get accountSummaryRequired => 'Samenvatting is verplicht';

  @override
  String get accountReview => 'Beoordeling';

  @override
  String get accountDetailedReviewHint =>
      'Schrijf hier je uitgebreide beoordeling';

  @override
  String get accountReviewRequired => 'Beoordeling is verplicht';

  @override
  String get accountRating => 'Beoordeling';

  @override
  String get accountSubmitReview => 'Beoordeling verzenden';

  @override
  String get accountCouldNotLoadAddresses =>
      'Adressen konden niet worden geladen';

  @override
  String get accountPleaseTryAgain => 'Probeer het opnieuw';

  @override
  String get accountNoAddressesSaved => 'Geen adressen opgeslagen';

  @override
  String get accountAddAddressToGetStarted =>
      'Voeg een nieuw adres toe om te beginnen';

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
  String get accountNoProductsToCompare => 'Geen producten om te vergelijken';

  @override
  String get accountAddProductsToCompareHint =>
      'Voeg producten toe om te vergelijken vanaf de productdetailpagina.';

  @override
  String get accountProducts => 'Producten';

  @override
  String get accountDescription => 'Beschrijving';

  @override
  String get accountShortDescription => 'Korte beschrijving';

  @override
  String get accountActivity => 'Activiteit';

  @override
  String get accountSeller => 'Verkoper';

  @override
  String get accountNotAvailable => 'N/B';

  @override
  String get accountMessageSentSuccessfully => 'Bericht succesvol verzonden!';

  @override
  String get accountAnErrorOccurred => 'Er is een fout opgetreden';

  @override
  String get accountContactUs => 'Neem contact met ons op';

  @override
  String get accountName => 'Naam';

  @override
  String get accountEnterYourEmail => 'Voer je e-mail in';

  @override
  String get accountContact => 'Contact';

  @override
  String get accountEnterYourPhoneNumber => 'Voer je telefoonnummer in';

  @override
  String get accountMessage => 'Bericht';

  @override
  String get accountEnterYourMessage => 'Voer je bericht in';

  @override
  String get accountSendMessage => 'Bericht verzenden';

  @override
  String get accountNameFieldEmpty => 'Naamveld mag niet leeg zijn';

  @override
  String get accountNameMinChars => 'Naam moet minimaal 2 tekens bevatten';

  @override
  String get accountEmailFieldEmpty => 'E-mailveld mag niet leeg zijn';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Voer een geldig e-mailadres in';

  @override
  String get accountContactNumberEmpty => 'Contactnummer mag niet leeg zijn';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Voer een geldig contactnummer in';

  @override
  String get accountMessageFieldEmpty => 'Berichtveld mag niet leeg zijn';

  @override
  String get accountMessageMinChars =>
      'Bericht moet minimaal 10 tekens bevatten';

  @override
  String get accountDownloadableProducts => 'Downloadbare producten';

  @override
  String get accountNoDownloadsYet => 'Nog geen downloads';

  @override
  String get accountDownloadsEmptyDescription =>
      'Je gedownloade producten verschijnen hier.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total producten';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value over';
  }

  @override
  String get accountDownload => 'Downloaden';

  @override
  String accountFileName(Object fileName) {
    return 'Bestand: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Je download start binnenkort. Controleer je downloadmap.';

  @override
  String get accountClose => 'Sluiten';

  @override
  String get accountOrders => 'Bestellingen';

  @override
  String get accountNoOrdersYet => 'Nog geen bestellingen';

  @override
  String get accountOrdersEmptyDescription =>
      'Je bestellingen verschijnen hier zodra je een aankoop doet.';

  @override
  String get accountOrderSingular => 'Bestelling';

  @override
  String get accountOrderPlural => 'Bestellingen';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Artikelen $count)';
  }

  @override
  String get accountOrderAndReturn => 'Bestellen en retourneren';

  @override
  String get accountTrackOrder => 'Bestelling volgen';

  @override
  String get accountReturnPolicy => 'Retourbeleid';

  @override
  String get accountReturnRequest => 'Retouraanvraag';

  @override
  String get accountMyReturns => 'Mijn retouren';

  @override
  String get accountReturns => 'Retouren';

  @override
  String get accountReturnSingular => 'Retour';

  @override
  String get accountReturnPlural => 'Retouren';

  @override
  String get accountNoReturnsYet => 'Nog geen retouren';

  @override
  String get accountReturnsEmptyDescription =>
      'Je retouraanvragen verschijnen hier.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Retour $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Bestelling $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Aantal: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Max: $count';
  }

  @override
  String get accountReturnResolution => 'Oplossing';

  @override
  String get accountReturnResolutionReturn => 'Retourneren';

  @override
  String get accountReturnResolutionCancel => 'Artikelen annuleren';

  @override
  String get accountReturnReason => 'Reden';

  @override
  String get accountReturnSelectReason => 'Selecteer een reden';

  @override
  String get accountReturnPackageCondition => 'Staat van de verpakking';

  @override
  String get accountReturnPackageConditionHint =>
      'bijv. geopend, verzegeld, doos beschadigd';

  @override
  String get accountReturnAdditionalInfo => 'Aanvullende informatie';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Beschrijf het probleem (optioneel)';

  @override
  String get accountReturnAgreement =>
      'Ik ga akkoord met de voorwaarden van het retourbeleid';

  @override
  String get accountReturnAgreementRequired =>
      'Accepteer het retourbeleid om door te gaan';

  @override
  String get accountReturnSubmit => 'Aanvraag versturen';

  @override
  String get accountReturnCreatedTitle => 'Aanvraag verstuurd';

  @override
  String get accountReturnCreatedMessage =>
      'Je retouraanvraag is succesvol verstuurd.';

  @override
  String get accountReturnSelectItem => 'Selecteer artikel';

  @override
  String get accountReturnNoReturnableItems => 'Geen retourneerbare artikelen';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Deze bestelling bevat geen artikelen die in aanmerking komen voor retour of annulering.';

  @override
  String get accountReturnViewAction => 'Bekijken';

  @override
  String get accountReturnCancelAction => 'Aanvraag annuleren';

  @override
  String get accountReturnCloseAction => 'Markeren als opgelost';

  @override
  String get accountReturnReopenAction => 'Aanvraag heropenen';

  @override
  String get accountReturnCancelConfirmation =>
      'Weet je zeker dat je deze retouraanvraag wilt annuleren?';

  @override
  String get accountReturnCloseConfirmation =>
      'Deze retouraanvraag als opgelost markeren?';

  @override
  String get accountReturnMessages => 'Berichten';

  @override
  String get accountReturnNoMessages => 'Nog geen berichten.';

  @override
  String get accountReturnMessageHint => 'Schrijf een bericht…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Retourstatus bijgewerkt naar $status';
  }

  @override
  String get accountReturnExpired => 'Retourperiode verlopen';

  @override
  String get accountReturnInformation => 'Informatie';

  @override
  String get accountReturnSelectOrder => 'Selecteer een bestelling';

  @override
  String get accountReturnChangeOrder => 'Wijzigen';

  @override
  String get accountReturnChooseAnotherOrder => 'Kies een andere bestelling';

  @override
  String get accountNotifications => 'Meldingen';

  @override
  String get accountPrivacy => 'Privacy';

  @override
  String get accountAccount => 'Account';

  @override
  String get accountPreferences => 'Voorkeuren';

  @override
  String get accountLanguage => 'Taal';

  @override
  String get accountNoLanguagesAvailable => 'Geen talen beschikbaar';

  @override
  String get accountCurrency => 'Valuta';

  @override
  String get accountOthers => 'Overig';

  @override
  String get accountNoPagesAvailable => 'Geen pagina\'s beschikbaar';

  @override
  String get accountProductReviews => 'Productbeoordelingen';

  @override
  String get accountMyReviews => 'Mijn beoordelingen';

  @override
  String get accountNoReviewsYet => 'Nog geen beoordelingen';

  @override
  String get accountReviewsEmptyDescription =>
      'Je productbeoordelingen verschijnen hier.';

  @override
  String get accountReviewSingular => 'Beoordeling';

  @override
  String get accountReviewPlural => 'Beoordelingen';

  @override
  String accountPostedOn(Object date) {
    return 'Geplaatst op $date';
  }

  @override
  String get accountCloseSettings => 'Instellingen sluiten';

  @override
  String get accountChangeTheme => 'Thema wijzigen';

  @override
  String get accountAllNotifications => 'Alle meldingen';

  @override
  String get accountOffers => 'Aanbiedingen';

  @override
  String get accountOfflineData => 'Offline gegevens';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Recent bekeken producten volgen en tonen';

  @override
  String get accountShowSearchTag => 'Zoeklabel tonen';

  @override
  String get accountTryAgain => 'Opnieuw proberen';

  @override
  String get accountYourWishlistEmpty => 'Je verlanglijst is leeg';

  @override
  String get accountWishlistEmptyDescription =>
      'Blader door producten en voeg ze toe aan je verlanglijst';

  @override
  String get accountItemSingular => 'Artikel';

  @override
  String get accountItemPlural => 'Artikelen';

  @override
  String accountStartingAt(Object price) {
    return 'Vanaf $price';
  }

  @override
  String get accountAboutThisPage => 'Over deze pagina';

  @override
  String accountPageId(Object id) {
    return 'Pagina-ID: $id';
  }

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabCategories => 'Categorieën';

  @override
  String get mainTabCart => 'Winkelwagen';

  @override
  String get mainTabAccount => 'Account';

  @override
  String get authLoginSuccess => 'Welkom! Succesvol ingelogd.';

  @override
  String get authWelcomeBack => 'Welkom terug!';

  @override
  String get authLoginToAccount => 'Log in op je account';

  @override
  String get authEmailAddress => 'E-mailadres';

  @override
  String get authEnterYourEmail => 'Voer je e-mailadres in';

  @override
  String get authPleaseEnterEmail => 'Voer je e-mailadres in';

  @override
  String get authPleaseEnterValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get authPassword => 'Wachtwoord';

  @override
  String get authEnterYourPassword => 'Voer je wachtwoord in';

  @override
  String get authPleaseEnterPassword => 'Voer je wachtwoord in';

  @override
  String get authPasswordMinLength =>
      'Wachtwoord moet minimaal 6 tekens bevatten';

  @override
  String get authForgotPasswordTitle => 'Wachtwoord vergeten?';

  @override
  String get authLogin => 'Inloggen';

  @override
  String get authNoAccountPrompt => 'Heb je geen account? ';

  @override
  String get authSignUp => 'Registreren';

  @override
  String get authAccountCreatedSuccess => 'Account succesvol aangemaakt!';

  @override
  String get authCreateAccount => 'Account aanmaken';

  @override
  String get authSignupGetStarted => 'Registreer om te beginnen';

  @override
  String get authFirstNameHint => 'Voornaam';

  @override
  String get authLastNameHint => 'Achternaam';

  @override
  String get authRequired => 'Verplicht';

  @override
  String get authCreatePasswordHint => 'Maak een wachtwoord aan';

  @override
  String get authConfirmPassword => 'Bevestig wachtwoord';

  @override
  String get authConfirmPasswordHint => 'Bevestig je wachtwoord';

  @override
  String get authPleaseConfirmPassword => 'Bevestig je wachtwoord';

  @override
  String get authPasswordsDoNotMatch => 'Wachtwoorden komen niet overeen';

  @override
  String get authAlreadyHaveAccountPrompt => 'Heb je al een account? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Voer je e-mailadres in en we sturen je een link om je wachtwoord opnieuw in te stellen.';

  @override
  String get authSendResetLink => 'Link voor reset verzenden';

  @override
  String get authBackToLogin => 'Terug naar inloggen';

  @override
  String get authNiceToSeeYouHere => 'Fijn je hier te zien';

  @override
  String get accountEditTitle => 'Account bewerken';

  @override
  String get accountFirstNameRequiredLabel => 'Voornaam *';

  @override
  String get accountLastNameRequiredLabel => 'Achternaam *';

  @override
  String get accountChangeEmail => 'E-mail wijzigen';

  @override
  String get accountChangePassword => 'Wachtwoord wijzigen';

  @override
  String get accountDeleteAccount => 'Account verwijderen';

  @override
  String get accountGender => 'Geslacht';

  @override
  String get accountSelectGender => 'Geslacht selecteren';

  @override
  String get accountDob => 'Geboortedatum';

  @override
  String get monthJanShort => 'Jan';

  @override
  String get monthFebShort => 'Feb';

  @override
  String get monthMarShort => 'Mrt';

  @override
  String get monthAprShort => 'Apr';

  @override
  String get monthMayShort => 'Mei';

  @override
  String get monthJunShort => 'Jun';

  @override
  String get monthJulShort => 'Jul';

  @override
  String get monthAugShort => 'Aug';

  @override
  String get monthSepShort => 'Sep';

  @override
  String get monthOctShort => 'Okt';

  @override
  String get monthNovShort => 'Nov';

  @override
  String get monthDecShort => 'Dec';

  @override
  String get accountSubscribeNewsletters => 'Abonneren op nieuwsbrieven';

  @override
  String get accountSaveProfile => 'Profiel opslaan';

  @override
  String get accountNewEmail => 'Nieuw e-mailadres';

  @override
  String get accountEmailRequired => 'E-mail is verplicht';

  @override
  String get accountCurrentPassword => 'Huidig wachtwoord';

  @override
  String get accountPasswordRequired => 'Wachtwoord is verplicht';

  @override
  String get accountChange => 'Wijzigen';

  @override
  String get accountCurrentPasswordRequired => 'Huidig wachtwoord is verplicht';

  @override
  String get accountNewPassword => 'Nieuw wachtwoord';

  @override
  String get accountConfirmPassword => 'Bevestig wachtwoord';

  @override
  String get accountDeleteWarning =>
      'Deze actie is permanent en kan niet ongedaan worden gemaakt. Al je gegevens worden verwijderd.';

  @override
  String get accountEnterYourPassword => 'Voer je wachtwoord in';

  @override
  String get accountDelete => 'Verwijderen';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Man';

  @override
  String get accountGenderFemale => 'Vrouw';

  @override
  String get accountGenderOther => 'Anders';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Bestellingen $number';
  }

  @override
  String get accountReorderSuccessful => 'Opnieuw bestellen gelukt';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count artikelen zijn toegevoegd aan je winkelwagen.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Ga naar winkelwagen';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Bestelgegevens konden niet worden geladen';

  @override
  String get accountDetails => 'Details';

  @override
  String get accountInvoices => 'Facturen';

  @override
  String get accountShipments => 'Zendingen';

  @override
  String accountPlacedOn(Object date) {
    return 'Geplaatst op $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count artikel(en) besteld';
  }

  @override
  String get accountBillingAddress => 'Factuuradres';

  @override
  String get accountShippingAddress => 'Verzendadres';

  @override
  String get accountShippingMethod => 'Verzendmethode';

  @override
  String get accountPaymentMethod => 'Betaalmethode';

  @override
  String get accountNoInvoicesForOrder => 'Geen facturen voor deze bestelling';

  @override
  String accountInvoicedCount(int count) {
    return '$count gefactureerd';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'Geen zendingen voor deze bestelling';

  @override
  String get accountReorder => 'Opnieuw bestellen';

  @override
  String get accountCancelOrder => 'Bestelling annuleren';

  @override
  String get accountCancelOrderConfirmation =>
      'Weet je zeker dat je deze bestelling wilt annuleren? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get accountMoreInfo => 'Meer info';

  @override
  String get accountOrderedQty => 'Bestelde hoeveelheid';

  @override
  String get accountShipped => 'Verzonden';

  @override
  String get accountInvoiced => 'Gefactureerd';

  @override
  String get accountUnitPrice => 'Stuksprijs';

  @override
  String get accountSubTotalWithSpace => 'Subtotaal';

  @override
  String get accountTotalPaid => 'Totaal betaald';

  @override
  String get accountTotalRefunded => 'Totaal terugbetaald';

  @override
  String get accountTotalDue => 'Totaal verschuldigd';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Factuur $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Zending $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Factuurgegevens konden niet worden geladen';

  @override
  String get accountInvoiceStatus => 'Factuurstatus';

  @override
  String get accountInvoiceDate => 'Factuurdatum';

  @override
  String get accountOrderId => 'Bestel-ID';

  @override
  String get accountOrderDate => 'Besteldatum';

  @override
  String get accountOrderStatus => 'Bestelstatus';

  @override
  String get accountChannel => 'Kanaal';

  @override
  String get accountDefault => 'Standaard';

  @override
  String get accountStatusPaid => 'Betaald';

  @override
  String get accountStatusPending => 'In behandeling';

  @override
  String get accountStatusPendingPayment => 'Betaling in behandeling';

  @override
  String get accountStatusOverdue => 'Achterstallig';

  @override
  String get accountStatusRefunded => 'Terugbetaald';

  @override
  String get accountShippedQty => 'Verzonden hoeveelheid';

  @override
  String get accountInvoicedQty => 'Gefactureerde hoeveelheid';

  @override
  String get accountUnitPriceWithColon => 'Stuksprijs:';

  @override
  String get accountSubTotalWithColon => 'Subtotaal:';

  @override
  String get accountDownloadInvoice => 'Factuur downloaden';

  @override
  String get accountInvoice => 'Factuur';

  @override
  String get accountRecentOrders => 'Recente bestellingen';

  @override
  String get accountNoRecentOrders => 'Geen recente bestellingen';

  @override
  String get accountStatusProcessing => 'Verwerken';

  @override
  String get accountStatusCompleted => 'Voltooid';

  @override
  String get accountStatusCancelled => 'Geannuleerd';

  @override
  String get accountStatusClosed => 'Gesloten';

  @override
  String get accountStatusUnknown => 'Onbekend';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Verlanglijstitems ($count)';
  }

  @override
  String get accountNoWishlistItems => 'Geen verlanglijstitems';

  @override
  String get accountDefaultAddresses => 'Standaardadressen';

  @override
  String get accountNoProductReviewsYet => 'Nog geen productbeoordelingen';

  @override
  String get searchFailedTitle => 'Zoeken mislukt';

  @override
  String get searchHint => 'Zoek producten';

  @override
  String get searchImageSearch => 'Zoeken op afbeelding';

  @override
  String get searchRecentSearches => 'Recente zoekopdrachten';

  @override
  String get searchClearAll => 'Alles wissen';

  @override
  String get searchTopCategories => 'Topcategorieën';

  @override
  String searchResultsFound(int count) {
    return '$count resultaten gevonden';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% korting';
  }

  @override
  String get searchNoProductsFound => 'Geen producten gevonden';

  @override
  String get searchTryDifferentTerm => 'Probeer te zoeken met een andere term';

  @override
  String get searchSpeechNotAvailable => 'Spraakherkenning is niet beschikbaar';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Spraakinvoer kon niet worden gestart: $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Microfoontoestemming geweigerd';

  @override
  String get searchRetake => 'Opnieuw maken';

  @override
  String get searchSearch => 'Zoeken';

  @override
  String get searchTryAgain => 'Opnieuw proberen';

  @override
  String get searchRecognizedObjects => 'Herkende objecten';

  @override
  String get searchResult => 'Resultaat:';

  @override
  String get searchFailedToCaptureImage => 'Kan afbeelding niet vastleggen';

  @override
  String searchProcessing(int progress) {
    return 'Verwerken... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Camera openen...';

  @override
  String get searchFailedToProcessImage => 'Kan afbeelding niet verwerken';

  @override
  String get homeRecentlyViewedProducts => 'Recent bekeken producten';

  @override
  String accountItemsCount(int count) {
    return '$count artikel(en)';
  }

  @override
  String get accountTrack => 'Volgen';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Tracking $trackNumber via $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Onbekende vervoerder';

  @override
  String get accountTrackingNumber => 'Trackingnummer';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Verzonden aantal : $qty';
  }
}
