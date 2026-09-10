// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Bagisto Store';

  @override
  String get homeFailedToLoad => 'Startseite konnte nicht geladen werden';

  @override
  String get commonUnknownError => 'Unbekannter Fehler';

  @override
  String get commonRetry => 'Erneut versuchen';

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
  String get homeFeaturedProducts => 'Empfohlene Produkte';

  @override
  String get homeDefaultProducts => 'Produkte';

  @override
  String get homeBackToTop => 'Zurück nach oben';

  @override
  String get homeViewCart => 'WARENKORB ANZEIGEN';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName wurde zum Warenkorb hinzugefügt';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Bitte melden Sie sich an, um die Wunschliste zu verwalten';

  @override
  String get homeAddedToWishlist => 'Zur Wunschliste hinzugefügt';

  @override
  String get homeRemovedFromWishlist => 'Von der Wunschliste entfernt';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeCollections => 'Kollektionen';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Kategorie $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% Rabatt';
  }

  @override
  String get productFailedToLoad => 'Produkt konnte nicht geladen werden';

  @override
  String get productNotFound => 'Produkt nicht gefunden';

  @override
  String get productDetail => 'Produktdetails';

  @override
  String get productDetails => 'Details';

  @override
  String get productShowLess => 'Weniger anzeigen';

  @override
  String get productLoadMore => 'Mehr laden';

  @override
  String get productMoreInformations => 'Weitere Informationen';

  @override
  String get productSku => 'Artikelnummer';

  @override
  String get productType => 'Typ';

  @override
  String get productBrand => 'Marke';

  @override
  String get productColor => 'Farbe';

  @override
  String get productSize => 'Größe';

  @override
  String get productReviews => 'Bewertungen';

  @override
  String get productNoReviewsYet => 'Noch keine Bewertungen';

  @override
  String productRating(Object count) {
    return '$count Bewertung';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count Bewertungen';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Veröffentlicht am $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Ihre Bewertung wurde gesendet!';

  @override
  String get productWriteReview => 'Bewertung schreiben';

  @override
  String get productPleaseLoginForReviews =>
      'Bitte melden Sie sich an, um Ihre Bewertungen zu sehen';

  @override
  String get productLoadMoreReviews => 'Mehr Bewertungen laden';

  @override
  String get productRelatedProduct => 'Ähnliches Produkt';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% Rabatt';
  }

  @override
  String get productVeryGood => 'Sehr gut';

  @override
  String get productGood => 'Gut';

  @override
  String get productAverage => 'Durchschnittlich';

  @override
  String get productBad => 'Schlecht';

  @override
  String get productVeryBad => 'Sehr schlecht';

  @override
  String get productInStock => 'Auf Lager';

  @override
  String get productOutOfStock => 'Nicht auf Lager';

  @override
  String get productQuantity => 'Menge';

  @override
  String get productWishlistAction => 'Wunschliste';

  @override
  String get productCompareAction => 'Vergleichen';

  @override
  String get productShareAction => 'Teilen';

  @override
  String get productLoginToCompare =>
      'Bitte melden Sie sich an, um zum Vergleich hinzuzufügen';

  @override
  String get productAddedToCompare => 'Zum Vergleich hinzugefügt';

  @override
  String get productAddToCart => 'In den Warenkorb';

  @override
  String get accountMoveToCart => 'In den Warenkorb verschieben';

  @override
  String get productBuyNow => 'Jetzt kaufen';

  @override
  String get productSelectOptionsFirst =>
      'Bitte wählen Sie zuerst die Produktoptionen aus';

  @override
  String get productBookingBookTable => 'Tisch reservieren *';

  @override
  String get productBookingSelectDateRequired => 'Datum auswählen *';

  @override
  String get productBookingSelectSlotRequired => 'Zeitfenster auswählen *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Besondere Wünsche/Notizen *';

  @override
  String get productBookingBookAppointment => 'Termin buchen *';

  @override
  String get productBookingDateFormatHint => 'JJJJ-MM-TT';

  @override
  String get productBookingFrom => 'Von';

  @override
  String get productBookingTo => 'Bis';

  @override
  String get productBookingSelectDate => 'Datum auswählen';

  @override
  String get productBookingLocation => 'Standort';

  @override
  String get productBookingSlotDuration => 'Dauer des Zeitfensters';

  @override
  String get productBookingAvailability => 'Verfügbarkeit';

  @override
  String get productBookingStartDate => 'Startdatum';

  @override
  String get productBookingEndDate => 'Enddatum';

  @override
  String get productBookingDate => 'Datum';

  @override
  String get productBookingViewOnMap => 'Auf der Karte anzeigen';

  @override
  String get productBookingEventOn => 'Veranstaltung am:';

  @override
  String get productBookingBookYourTicket => 'Buchen Sie Ihr Ticket';

  @override
  String get productBookingSlotDurationLabel => 'Dauer des Zeitfensters:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count Minuten';
  }

  @override
  String get productBookingAvailableFrom => 'Verfügbar ab';

  @override
  String get productBookingAvailableTo => 'Verfügbar bis';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Besondere Wünsche/Notizen';

  @override
  String get productBookingChooseRentOption => 'Mietoption wählen *';

  @override
  String get productBookingDailyBasis => 'Tagesbasis';

  @override
  String get productBookingHourlyBasis => 'Stundenbasis';

  @override
  String get productBookingNoDatesAvailable =>
      'Keine Termine für die Buchung verfügbar';

  @override
  String get productBookingSelectSlot => 'Zeitfenster auswählen';

  @override
  String get productBookingSelectDateFirst => 'Wählen Sie zuerst ein Datum aus';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Wählen Sie zuerst ein Datum aus, um verfügbare Zeitfenster zu sehen.';

  @override
  String get productBookingLoadingSlots => 'Zeitfenster werden geladen...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Verfügbare Zeitfenster für das ausgewählte Datum werden geladen.';

  @override
  String get productBookingUnableToLoadSlots =>
      'Zeitfenster konnten nicht geladen werden';

  @override
  String get productBookingNoSlotsAvailable => 'Keine Zeitfenster verfügbar';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Für das ausgewählte Datum sind keine Zeitfenster verfügbar.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Wählen Sie ein verfügbares Zeitfenster aus, um fortzufahren.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Besondere Wünsche/Notizen';

  @override
  String get productDownloadableLinks => 'Links';

  @override
  String get productDownloadableSamples => 'Beispiele';

  @override
  String get productDownloadSample => 'Beispiel herunterladen';

  @override
  String get productDefaultName => 'Produkt';

  @override
  String get categoryDefaultName => 'Kategorien';

  @override
  String get categorySubCategories => 'Unterkategorien';

  @override
  String get categorySomethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get categoryUnknownError => 'Unbekannter Fehler';

  @override
  String categoryItemsFound(Object count) {
    return '$count Artikel gefunden';
  }

  @override
  String get categoryNoProductsFound => 'Keine Produkte gefunden';

  @override
  String get categorySort => 'Sortieren';

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
  String get categoryFilter => 'Filtern';

  @override
  String get categoryFilters => 'Filter';

  @override
  String get categoryNoFiltersAvailable => 'Keine Filter verfügbar';

  @override
  String get categoryFiltersWillAppear =>
      'Filter werden angezeigt, wenn sie für diese Kategorie verfügbar sind';

  @override
  String get categoryApplyFilters => 'Filter anwenden';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Filter anwenden ($count)';
  }

  @override
  String get categoryClearAll => 'Alle löschen';

  @override
  String get categoryTryAdjustingFilters =>
      'Versuchen Sie, Ihre Filter oder Suchkriterien anzupassen';

  @override
  String get categoryError => 'Fehler';

  @override
  String get categoryLoginToManageWishlist =>
      'Bitte melden Sie sich an, um die Wunschliste zu verwalten';

  @override
  String get categoryAddedToWishlist => 'Zur Wunschliste hinzugefügt';

  @override
  String get categoryRemovedFromWishlist => 'Von der Wunschliste entfernt';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Wunschliste konnte nicht aktualisiert werden: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Warenkorb';

  @override
  String get cartPleaseLoginWishlist =>
      'Bitte melden Sie sich an, um die Wunschliste zu sehen';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText im Warenkorb';
  }

  @override
  String get cartYourCartEmpty => 'Ihr Warenkorb ist leer';

  @override
  String get cartAddProductsHere =>
      'Fügen Sie Produkte zum Warenkorb hinzu, um sie hier zu sehen';

  @override
  String get cartContinueShopping => 'Weiter einkaufen';

  @override
  String get cartUnit => 'Einheit';

  @override
  String get cartUnits => 'Einheiten';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Bitte melden Sie sich an, um zur Wunschliste hinzuzufügen';

  @override
  String get cartMovedToWishlist => 'Zur Wunschliste verschoben';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Verschieben zur Wunschliste fehlgeschlagen: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Mehr anzeigen';

  @override
  String get cartViewLess => 'Weniger anzeigen';

  @override
  String get cartEmptyCartAction => 'Warenkorb leeren';

  @override
  String get cartApplyCoupon => 'Gutschein anwenden';

  @override
  String get cartCouponCode => 'Gutscheincode';

  @override
  String get cartApply => 'Anwenden';

  @override
  String get cartAppliedCoupon => 'Gutschein angewendet';

  @override
  String get cartRemove => 'Entfernen';

  @override
  String get cartPriceBreak => 'Preisübersicht';

  @override
  String get cartSubTotal => 'Zwischensumme';

  @override
  String get cartDiscount => 'Rabatt';

  @override
  String get cartDeliveryCharges => 'Versandkosten';

  @override
  String get cartTax => 'Steuer';

  @override
  String get cartGrandTotal => 'Gesamtsumme';

  @override
  String get cartAmountToBePaid => 'Zu zahlender Betrag';

  @override
  String get cartPayNow => 'Jetzt bezahlen';

  @override
  String get cartRemoveItem => 'Artikel entfernen';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Möchten Sie \"$productName\" wirklich aus Ihrem Warenkorb entfernen?';
  }

  @override
  String get cartCancel => 'Abbrechen';

  @override
  String get cartEmptyCartTitle => 'Warenkorb leeren';

  @override
  String get cartEmptyCartConfirm =>
      'Möchten Sie wirklich alle Artikel aus Ihrem Warenkorb entfernen?';

  @override
  String get checkout => 'Kasse';

  @override
  String get checkoutBillingTo => 'Rechnungsadresse';

  @override
  String get checkoutDeliveredTo => 'Geliefert an';

  @override
  String get checkoutChange => 'Ändern';

  @override
  String get checkoutSelectBillingAddress => 'Rechnungsadresse auswählen';

  @override
  String get checkoutSelectShippingAddress => 'Lieferadresse auswählen';

  @override
  String get checkoutBillingAddress => 'Rechnungsadresse';

  @override
  String get checkoutEnterAddress => 'Adresse eingeben';

  @override
  String get checkoutFirstName => 'Vorname';

  @override
  String get checkoutLastName => 'Nachname';

  @override
  String get checkoutEmail => 'E-Mail';

  @override
  String get checkoutPhone => 'Telefon';

  @override
  String get checkoutStreetAddress => 'Straßenadresse';

  @override
  String get checkoutCountry => 'Land';

  @override
  String get checkoutState => 'Bundesland';

  @override
  String get checkoutCity => 'Stadt';

  @override
  String get checkoutPostcode => 'Postleitzahl';

  @override
  String get checkoutCompanyOptional => 'Firma (optional)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Dieselbe Adresse für den Versand verwenden?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Telefon: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Büro';

  @override
  String get checkoutAddressTypeHome => 'Zuhause';

  @override
  String get checkoutAddressTypeBilling => 'Rechnung';

  @override
  String get checkoutAddressTypeShipping => 'Versand';

  @override
  String get checkoutAddressTypeDefault => 'Standard';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field ist erforderlich';
  }

  @override
  String get checkoutSaveContinue => 'Speichern und fortfahren';

  @override
  String get checkoutYourCartEmpty => 'Ihr Warenkorb ist leer';

  @override
  String get checkoutSelectCountry => 'Land auswählen';

  @override
  String get checkoutSelectState => 'Bundesland auswählen';

  @override
  String get checkoutCountryRequired => 'Land ist erforderlich';

  @override
  String get checkoutStateRequired => 'Bundesland ist erforderlich';

  @override
  String get checkoutSelectCountryFirst => 'Wählen Sie zuerst ein Land aus';

  @override
  String get checkoutShippingMethod => 'Versandart';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Speichern Sie Ihre Adresse, um Versandoptionen zu sehen';

  @override
  String get checkoutPaymentMethod => 'Zahlungsmethode';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Wählen Sie zuerst eine Versandart aus';

  @override
  String get checkoutEnterCouponCode => 'Gutscheincode eingeben';

  @override
  String get checkoutDiscountCoupon => 'Rabatt (Gutschein)';

  @override
  String get checkoutPlaceOrder => 'Bestellung aufgeben';

  @override
  String get thankYouTitle => 'Vielen Dank für Ihre Bestellung!';

  @override
  String get thankYouSubtitle =>
      'Wir senden Ihnen die Bestelldetails und Tracking-Informationen per E-Mail';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Ihre Bestellnummer: $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Bestellung ansehen';

  @override
  String get thankYouContinueShopping => 'Weiter einkaufen';

  @override
  String get accountPleaseTryAgainLater =>
      'Bitte versuchen Sie es später erneut';

  @override
  String get accountUserFallback => 'Benutzer';

  @override
  String get accountBack => 'Zurück';

  @override
  String get accountSettings => 'Einstellungen';

  @override
  String get accountMyOrders => 'Meine Bestellungen';

  @override
  String get accountMyDownloadableProducts => 'Meine herunterladbaren Produkte';

  @override
  String get accountWishlist => 'Wunschliste';

  @override
  String get accountCompareProducts => 'Produkte vergleichen';

  @override
  String get accountProductReview => 'Produktbewertung';

  @override
  String get accountAddressBook => 'Adressbuch';

  @override
  String get accountEditAccount => 'Konto bearbeiten';

  @override
  String get accountLogout => 'Abmelden';

  @override
  String get accountLogoutConfirmation => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get accountNoCountriesAvailable =>
      'Keine Länder verfügbar. Bitte versuchen Sie es erneut.';

  @override
  String get accountPleaseSelectCountry => 'Bitte wählen Sie ein Land aus';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Bitte wählen oder geben Sie ein Bundesland ein';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'Adresse erfolgreich aktualisiert';

  @override
  String get accountAddressAddedSuccessfully =>
      'Adresse erfolgreich hinzugefügt';

  @override
  String get accountGoBack => 'Zurück';

  @override
  String get accountEditAddress => 'Adresse bearbeiten';

  @override
  String get accountAddNewAddress => 'Neue Adresse hinzufügen';

  @override
  String get accountFirstNameRequired => 'Vorname ist erforderlich';

  @override
  String get accountLastNameRequired => 'Nachname ist erforderlich';

  @override
  String get accountEnterValidEmail => 'Geben Sie eine gültige E-Mail ein';

  @override
  String get accountCompanyName => 'Firmenname';

  @override
  String get accountVatId => 'USt-IdNr.';

  @override
  String get accountStreetAddressRequired => 'Straßenadresse ist erforderlich';

  @override
  String get accountCityRequired => 'Stadt ist erforderlich';

  @override
  String get accountZipPostcode => 'PLZ/Postleitzahl';

  @override
  String get accountZipPostcodeRequired => 'PLZ/Postleitzahl ist erforderlich';

  @override
  String get accountTelephone => 'Telefon';

  @override
  String get accountPhoneNumberRequired => 'Telefonnummer ist erforderlich';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Standard-Rechnungsadresse ändern';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Standard-Lieferadresse ändern';

  @override
  String get accountUpdateAddress => 'Adresse aktualisieren';

  @override
  String get accountSaveToAddressBook => 'Im Adressbuch speichern';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Bitte melden Sie sich an, um eine Bewertung zu schreiben';

  @override
  String get accountPleaseSelectRating => 'Bitte wählen Sie eine Bewertung aus';

  @override
  String get accountAddReview => 'Bewertung hinzufügen';

  @override
  String get accountReviewSubmitted => 'Bewertung gesendet!';

  @override
  String get accountNickName => 'Spitzname';

  @override
  String get accountEnterYourName => 'Geben Sie Ihren Namen ein';

  @override
  String get accountNameRequired => 'Name ist erforderlich';

  @override
  String get accountSummary => 'Zusammenfassung';

  @override
  String get accountReviewSummaryHint =>
      'Kurze Zusammenfassung Ihrer Bewertung';

  @override
  String get accountSummaryRequired => 'Zusammenfassung ist erforderlich';

  @override
  String get accountReview => 'Bewertung';

  @override
  String get accountDetailedReviewHint =>
      'Schreiben Sie hier Ihre ausführliche Bewertung';

  @override
  String get accountReviewRequired => 'Bewertung ist erforderlich';

  @override
  String get accountRating => 'Bewertung';

  @override
  String get accountSubmitReview => 'Bewertung absenden';

  @override
  String get accountCouldNotLoadAddresses =>
      'Adressen konnten nicht geladen werden';

  @override
  String get accountPleaseTryAgain => 'Bitte versuchen Sie es erneut';

  @override
  String get accountNoAddressesSaved => 'Keine Adressen gespeichert';

  @override
  String get accountAddAddressToGetStarted =>
      'Fügen Sie eine neue Adresse hinzu, um zu beginnen';

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
  String get accountNoProductsToCompare => 'Keine Produkte zum Vergleichen';

  @override
  String get accountAddProductsToCompareHint =>
      'Fügen Sie Produkte von der Produktdetailseite zum Vergleich hinzu.';

  @override
  String get accountProducts => 'Produkte';

  @override
  String get accountDescription => 'Beschreibung';

  @override
  String get accountShortDescription => 'Kurzbeschreibung';

  @override
  String get accountActivity => 'Aktivität';

  @override
  String get accountSeller => 'Verkäufer';

  @override
  String get accountNotAvailable => 'Nicht verfügbar';

  @override
  String get accountMessageSentSuccessfully =>
      'Nachricht erfolgreich gesendet!';

  @override
  String get accountAnErrorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get accountContactUs => 'Kontaktieren Sie uns';

  @override
  String get accountName => 'Name';

  @override
  String get accountEnterYourEmail => 'Geben Sie Ihre E-Mail ein';

  @override
  String get accountContact => 'Kontakt';

  @override
  String get accountEnterYourPhoneNumber => 'Geben Sie Ihre Telefonnummer ein';

  @override
  String get accountMessage => 'Nachricht';

  @override
  String get accountEnterYourMessage => 'Geben Sie Ihre Nachricht ein';

  @override
  String get accountSendMessage => 'Nachricht senden';

  @override
  String get accountNameFieldEmpty => 'Namensfeld darf nicht leer sein';

  @override
  String get accountNameMinChars => 'Name muss mindestens 2 Zeichen lang sein';

  @override
  String get accountEmailFieldEmpty => 'E-Mail-Feld darf nicht leer sein';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get accountContactNumberEmpty => 'Kontaktfeld darf nicht leer sein';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Bitte geben Sie eine gültige Kontaktnummer ein';

  @override
  String get accountMessageFieldEmpty => 'Nachrichtenfeld darf nicht leer sein';

  @override
  String get accountMessageMinChars =>
      'Nachricht muss mindestens 10 Zeichen lang sein';

  @override
  String get accountDownloadableProducts => 'Herunterladbare Produkte';

  @override
  String get accountNoDownloadsYet => 'Noch keine Downloads';

  @override
  String get accountDownloadsEmptyDescription =>
      'Ihre heruntergeladenen Produkte erscheinen hier.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total Produkte';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value verbleibend';
  }

  @override
  String get accountDownload => 'Herunterladen';

  @override
  String accountFileName(Object fileName) {
    return 'Datei: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Ihr Download beginnt in Kürze. Prüfen Sie Ihren Download-Ordner.';

  @override
  String get accountClose => 'Schließen';

  @override
  String get accountOrders => 'Bestellungen';

  @override
  String get accountNoOrdersYet => 'Noch keine Bestellungen';

  @override
  String get accountOrdersEmptyDescription =>
      'Ihre Bestellungen erscheinen hier, sobald Sie einen Kauf tätigen.';

  @override
  String get accountOrderSingular => 'Bestellung';

  @override
  String get accountOrderPlural => 'Bestellungen';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Artikel $count)';
  }

  @override
  String get accountOrderAndReturn => 'Bestellung und Rückgabe';

  @override
  String get accountTrackOrder => 'Bestellung verfolgen';

  @override
  String get accountReturnPolicy => 'Rückgaberichtlinie';

  @override
  String get accountReturnRequest => 'Rückgabeanfrage';

  @override
  String get accountMyReturns => 'Meine Rücksendungen';

  @override
  String get accountReturns => 'Rücksendungen';

  @override
  String get accountReturnSingular => 'Rücksendung';

  @override
  String get accountReturnPlural => 'Rücksendungen';

  @override
  String get accountNoReturnsYet => 'Noch keine Rücksendungen';

  @override
  String get accountReturnsEmptyDescription =>
      'Ihre Rückgabeanfragen werden hier angezeigt.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Rücksendung $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Bestellung $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Menge: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Max.: $count';
  }

  @override
  String get accountReturnResolution => 'Lösung';

  @override
  String get accountReturnResolutionReturn => 'Rückgabe';

  @override
  String get accountReturnResolutionCancel => 'Artikel stornieren';

  @override
  String get accountReturnReason => 'Grund';

  @override
  String get accountReturnSelectReason => 'Grund auswählen';

  @override
  String get accountReturnPackageCondition => 'Zustand der Verpackung';

  @override
  String get accountReturnPackageConditionHint =>
      'z. B. geöffnet, versiegelt, Karton beschädigt';

  @override
  String get accountReturnAdditionalInfo => 'Zusätzliche Informationen';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Problem beschreiben (optional)';

  @override
  String get accountReturnAgreement =>
      'Ich stimme den Bedingungen der Rückgaberichtlinie zu';

  @override
  String get accountReturnAgreementRequired =>
      'Bitte akzeptieren Sie die Rückgaberichtlinie';

  @override
  String get accountReturnSubmit => 'Anfrage senden';

  @override
  String get accountReturnCreatedTitle => 'Anfrage gesendet';

  @override
  String get accountReturnCreatedMessage =>
      'Ihre Rückgabeanfrage wurde erfolgreich übermittelt.';

  @override
  String get accountReturnSelectItem => 'Artikel auswählen';

  @override
  String get accountReturnNoReturnableItems => 'Keine rückgabefähigen Artikel';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Diese Bestellung enthält keine Artikel, die zurückgegeben oder storniert werden können.';

  @override
  String get accountReturnViewAction => 'Ansehen';

  @override
  String get accountReturnCancelAction => 'Anfrage stornieren';

  @override
  String get accountReturnCloseAction => 'Als gelöst markieren';

  @override
  String get accountReturnReopenAction => 'Anfrage erneut öffnen';

  @override
  String get accountReturnCancelConfirmation =>
      'Möchten Sie diese Rückgabeanfrage wirklich stornieren?';

  @override
  String get accountReturnCloseConfirmation =>
      'Diese Rückgabeanfrage als gelöst markieren?';

  @override
  String get accountReturnMessages => 'Nachrichten';

  @override
  String get accountReturnNoMessages => 'Noch keine Nachrichten.';

  @override
  String get accountReturnMessageHint => 'Nachricht schreiben…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Rückgabestatus aktualisiert auf $status';
  }

  @override
  String get accountReturnExpired => 'Rückgabefrist abgelaufen';

  @override
  String get accountReturnInformation => 'Informationen';

  @override
  String get accountReturnSelectOrder => 'Bestellung auswählen';

  @override
  String get accountReturnChangeOrder => 'Ändern';

  @override
  String get accountReturnChooseAnotherOrder => 'Andere Bestellung wählen';

  @override
  String get accountNotifications => 'Benachrichtigungen';

  @override
  String get accountPrivacy => 'Datenschutz';

  @override
  String get accountAccount => 'Konto';

  @override
  String get accountPreferences => 'Einstellungen';

  @override
  String get accountLanguage => 'Sprache';

  @override
  String get accountNoLanguagesAvailable => 'Keine Sprachen verfügbar';

  @override
  String get accountCurrency => 'Währung';

  @override
  String get accountOthers => 'Sonstiges';

  @override
  String get accountNoPagesAvailable => 'Keine Seiten verfügbar';

  @override
  String get accountProductReviews => 'Produktbewertungen';

  @override
  String get accountMyReviews => 'Meine Bewertungen';

  @override
  String get accountNoReviewsYet => 'Noch keine Bewertungen';

  @override
  String get accountReviewsEmptyDescription =>
      'Ihre Produktbewertungen erscheinen hier.';

  @override
  String get accountReviewSingular => 'Bewertung';

  @override
  String get accountReviewPlural => 'Bewertungen';

  @override
  String accountPostedOn(Object date) {
    return 'Veröffentlicht am $date';
  }

  @override
  String get accountCloseSettings => 'Einstellungen schließen';

  @override
  String get accountChangeTheme => 'Design ändern';

  @override
  String get accountAllNotifications => 'Alle Benachrichtigungen';

  @override
  String get accountOffers => 'Angebote';

  @override
  String get accountOfflineData => 'Offline-Daten';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Zuletzt angesehene Produkte verfolgen und anzeigen';

  @override
  String get accountShowSearchTag => 'Such-Tag anzeigen';

  @override
  String get accountTryAgain => 'Erneut versuchen';

  @override
  String get accountYourWishlistEmpty => 'Ihre Wunschliste ist leer';

  @override
  String get accountWishlistEmptyDescription =>
      'Durchsuchen Sie Produkte und fügen Sie sie Ihrer Wunschliste hinzu';

  @override
  String get accountItemSingular => 'Artikel';

  @override
  String get accountItemPlural => 'Artikel';

  @override
  String accountStartingAt(Object price) {
    return 'Ab $price';
  }

  @override
  String get accountAboutThisPage => 'Über diese Seite';

  @override
  String accountPageId(Object id) {
    return 'Seiten-ID: $id';
  }

  @override
  String get mainTabHome => 'Startseite';

  @override
  String get mainTabCategories => 'Kategorien';

  @override
  String get mainTabCart => 'Warenkorb';

  @override
  String get mainTabAccount => 'Konto';

  @override
  String get authLoginSuccess => 'Willkommen! Erfolgreich angemeldet.';

  @override
  String get authWelcomeBack => 'Willkommen zurück!';

  @override
  String get authLoginToAccount => 'Melden Sie sich bei Ihrem Konto an';

  @override
  String get authEmailAddress => 'E-Mail-Adresse';

  @override
  String get authEnterYourEmail => 'Geben Sie Ihre E-Mail ein';

  @override
  String get authPleaseEnterEmail => 'Bitte geben Sie Ihre E-Mail ein';

  @override
  String get authPleaseEnterValidEmail =>
      'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authEnterYourPassword => 'Geben Sie Ihr Passwort ein';

  @override
  String get authPleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get authPasswordMinLength =>
      'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get authForgotPasswordTitle => 'Passwort vergessen?';

  @override
  String get authLogin => 'Anmelden';

  @override
  String get authNoAccountPrompt => 'Sie haben kein Konto? ';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String get authAccountCreatedSuccess => 'Konto erfolgreich erstellt!';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authSignupGetStarted => 'Registrieren Sie sich, um loszulegen';

  @override
  String get authFirstNameHint => 'Vorname';

  @override
  String get authLastNameHint => 'Nachname';

  @override
  String get authRequired => 'Erforderlich';

  @override
  String get authCreatePasswordHint => 'Passwort erstellen';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authConfirmPasswordHint => 'Bestätigen Sie Ihr Passwort';

  @override
  String get authPleaseConfirmPassword => 'Bitte bestätigen Sie Ihr Passwort';

  @override
  String get authPasswordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get authAlreadyHaveAccountPrompt => 'Sie haben bereits ein Konto? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen Ihres Passworts.';

  @override
  String get authSendResetLink => 'Link zum Zurücksetzen senden';

  @override
  String get authBackToLogin => 'Zurück zur Anmeldung';

  @override
  String get authNiceToSeeYouHere => 'Schön, Sie hier zu sehen';

  @override
  String get accountEditTitle => 'Konto bearbeiten';

  @override
  String get accountFirstNameRequiredLabel => 'Vorname *';

  @override
  String get accountLastNameRequiredLabel => 'Nachname *';

  @override
  String get accountChangeEmail => 'E-Mail ändern';

  @override
  String get accountChangePassword => 'Passwort ändern';

  @override
  String get accountDeleteAccount => 'Konto löschen';

  @override
  String get accountGender => 'Geschlecht';

  @override
  String get accountSelectGender => 'Geschlecht auswählen';

  @override
  String get accountDob => 'Geburtsdatum';

  @override
  String get monthJanShort => 'Jan';

  @override
  String get monthFebShort => 'Feb';

  @override
  String get monthMarShort => 'Mär';

  @override
  String get monthAprShort => 'Apr';

  @override
  String get monthMayShort => 'Mai';

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
  String get monthDecShort => 'Dez';

  @override
  String get accountSubscribeNewsletters => 'Newsletter abonnieren';

  @override
  String get accountSaveProfile => 'Profil speichern';

  @override
  String get accountNewEmail => 'Neue E-Mail';

  @override
  String get accountEmailRequired => 'E-Mail ist erforderlich';

  @override
  String get accountCurrentPassword => 'Aktuelles Passwort';

  @override
  String get accountPasswordRequired => 'Passwort ist erforderlich';

  @override
  String get accountChange => 'Ändern';

  @override
  String get accountCurrentPasswordRequired =>
      'Aktuelles Passwort ist erforderlich';

  @override
  String get accountNewPassword => 'Neues Passwort';

  @override
  String get accountConfirmPassword => 'Passwort bestätigen';

  @override
  String get accountDeleteWarning =>
      'Diese Aktion ist dauerhaft und kann nicht rückgängig gemacht werden. Alle Ihre Daten werden gelöscht.';

  @override
  String get accountEnterYourPassword => 'Geben Sie Ihr Passwort ein';

  @override
  String get accountDelete => 'Löschen';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Männlich';

  @override
  String get accountGenderFemale => 'Weiblich';

  @override
  String get accountGenderOther => 'Andere';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Bestellungen $number';
  }

  @override
  String get accountReorderSuccessful => 'Erneute Bestellung erfolgreich';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count Artikel wurden Ihrem Warenkorb hinzugefügt.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Zum Warenkorb';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Bestelldetails konnten nicht geladen werden';

  @override
  String get accountDetails => 'Details';

  @override
  String get accountInvoices => 'Rechnungen';

  @override
  String get accountShipments => 'Sendungen';

  @override
  String accountPlacedOn(Object date) {
    return 'Bestellt am $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count Artikel bestellt';
  }

  @override
  String get accountBillingAddress => 'Rechnungsadresse';

  @override
  String get accountShippingAddress => 'Lieferadresse';

  @override
  String get accountShippingMethod => 'Versandart';

  @override
  String get accountPaymentMethod => 'Zahlungsmethode';

  @override
  String get accountNoInvoicesForOrder =>
      'Keine Rechnungen für diese Bestellung';

  @override
  String accountInvoicedCount(int count) {
    return '$count in Rechnung gestellt';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'Keine Sendungen für diese Bestellung';

  @override
  String get accountReorder => 'Erneut bestellen';

  @override
  String get accountCancelOrder => 'Bestellung stornieren';

  @override
  String get accountCancelOrderConfirmation =>
      'Möchten Sie diese Bestellung wirklich stornieren? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get accountMoreInfo => 'Mehr Infos';

  @override
  String get accountOrderedQty => 'Bestellte Menge';

  @override
  String get accountShipped => 'Versendet';

  @override
  String get accountInvoiced => 'Berechnet';

  @override
  String get accountUnitPrice => 'Stückpreis';

  @override
  String get accountSubTotalWithSpace => 'Zwischensumme';

  @override
  String get accountTotalPaid => 'Gesamt bezahlt';

  @override
  String get accountTotalRefunded => 'Gesamt erstattet';

  @override
  String get accountTotalDue => 'Gesamt fällig';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Rechnung $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Sendung $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Rechnungsdetails konnten nicht geladen werden';

  @override
  String get accountInvoiceStatus => 'Rechnungsstatus';

  @override
  String get accountInvoiceDate => 'Rechnungsdatum';

  @override
  String get accountOrderId => 'Bestell-ID';

  @override
  String get accountOrderDate => 'Bestelldatum';

  @override
  String get accountOrderStatus => 'Bestellstatus';

  @override
  String get accountChannel => 'Kanal';

  @override
  String get accountDefault => 'Standard';

  @override
  String get accountStatusPaid => 'Bezahlt';

  @override
  String get accountStatusPending => 'Ausstehend';

  @override
  String get accountStatusPendingPayment => 'Zahlung ausstehend';

  @override
  String get accountStatusOverdue => 'Überfällig';

  @override
  String get accountStatusRefunded => 'Erstattet';

  @override
  String get accountShippedQty => 'Versendete Menge';

  @override
  String get accountInvoicedQty => 'Berechnete Menge';

  @override
  String get accountUnitPriceWithColon => 'Stückpreis:';

  @override
  String get accountSubTotalWithColon => 'Zwischensumme:';

  @override
  String get accountDownloadInvoice => 'Rechnung herunterladen';

  @override
  String get accountInvoice => 'Rechnung';

  @override
  String get accountRecentOrders => 'Letzte Bestellungen';

  @override
  String get accountNoRecentOrders => 'Keine letzten Bestellungen';

  @override
  String get accountStatusProcessing => 'In Bearbeitung';

  @override
  String get accountStatusCompleted => 'Abgeschlossen';

  @override
  String get accountStatusCancelled => 'Storniert';

  @override
  String get accountStatusClosed => 'Geschlossen';

  @override
  String get accountStatusUnknown => 'Unbekannt';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Wunschlistenartikel ($count)';
  }

  @override
  String get accountNoWishlistItems => 'Keine Wunschlistenartikel';

  @override
  String get accountDefaultAddresses => 'Standardadressen';

  @override
  String get accountNoProductReviewsYet => 'Noch keine Produktbewertungen';

  @override
  String get searchFailedTitle => 'Suche fehlgeschlagen';

  @override
  String get searchHint => 'Produkte suchen';

  @override
  String get searchImageSearch => 'Bildersuche';

  @override
  String get searchRecentSearches => 'Letzte Suchanfragen';

  @override
  String get searchClearAll => 'Alles löschen';

  @override
  String get searchTopCategories => 'Top-Kategorien';

  @override
  String searchResultsFound(int count) {
    return '$count Ergebnisse gefunden';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% Rabatt';
  }

  @override
  String get searchNoProductsFound => 'Keine Produkte gefunden';

  @override
  String get searchTryDifferentTerm =>
      'Versuchen Sie es mit einem anderen Suchbegriff';

  @override
  String get searchSpeechNotAvailable => 'Spracherkennung ist nicht verfügbar';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Spracherfassung konnte nicht gestartet werden: $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Mikrofonberechtigung verweigert';

  @override
  String get searchRetake => 'Erneut aufnehmen';

  @override
  String get searchSearch => 'Suchen';

  @override
  String get searchTryAgain => 'Erneut versuchen';

  @override
  String get searchRecognizedObjects => 'Erkannte Objekte';

  @override
  String get searchResult => 'Ergebnis:';

  @override
  String get searchFailedToCaptureImage =>
      'Bild konnte nicht aufgenommen werden';

  @override
  String searchProcessing(int progress) {
    return 'Verarbeitung... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Kamera wird geöffnet...';

  @override
  String get searchFailedToProcessImage =>
      'Bild konnte nicht verarbeitet werden';

  @override
  String get homeRecentlyViewedProducts => 'Kürzlich angesehene Produkte';

  @override
  String accountItemsCount(int count) {
    return '$count Artikel';
  }

  @override
  String get accountTrack => 'Verfolgen';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Sendungsverfolgung $trackNumber über $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Unbekannter Versanddienstleister';

  @override
  String get accountTrackingNumber => 'Sendungsnummer';

  @override
  String accountSkuValue(Object sku) {
    return 'Artikelnummer : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Versendete Menge : $qty';
  }
}
