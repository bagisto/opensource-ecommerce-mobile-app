// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Negozio Bagisto';

  @override
  String get homeFailedToLoad => 'Impossibile caricare la home page';

  @override
  String get commonUnknownError => 'Errore sconosciuto';

  @override
  String get commonRetry => 'Riprova';

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
  String get homeFeaturedProducts => 'Prodotti in evidenza';

  @override
  String get homeDefaultProducts => 'Prodotti';

  @override
  String get homeBackToTop => 'Torna su';

  @override
  String get homeViewCart => 'VISUALIZZA CARRELLO';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName aggiunto al carrello';
  }

  @override
  String get homeLoginToManageWishlist => 'Accedi per gestire la wishlist';

  @override
  String get homeAddedToWishlist => 'Aggiunto alla wishlist';

  @override
  String get homeRemovedFromWishlist => 'Rimosso dalla wishlist';

  @override
  String get homeViewAll => 'Vedi tutto';

  @override
  String get homeCollections => 'Collezioni';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Categoria $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% di sconto';
  }

  @override
  String get productFailedToLoad => 'Impossibile caricare il prodotto';

  @override
  String get productNotFound => 'Prodotto non trovato';

  @override
  String get productDetail => 'Dettaglio prodotto';

  @override
  String get productDetails => 'Dettagli';

  @override
  String get productShowLess => 'Mostra meno';

  @override
  String get productLoadMore => 'Carica altro';

  @override
  String get productMoreInformations => 'Maggiori informazioni';

  @override
  String get productSku => 'SKU';

  @override
  String get productType => 'Tipo';

  @override
  String get productBrand => 'Marca';

  @override
  String get productColor => 'Colore';

  @override
  String get productSize => 'Taglia';

  @override
  String get productReviews => 'Recensioni';

  @override
  String get productNoReviewsYet => 'Ancora nessuna recensione';

  @override
  String productRating(Object count) {
    return '$count valutazione';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count recensioni';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Pubblicato il $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'La tua recensione è stata inviata!';

  @override
  String get productWriteReview => 'Scrivi una recensione';

  @override
  String get productPleaseLoginForReviews =>
      'Accedi per vedere le tue recensioni';

  @override
  String get productLoadMoreReviews => 'Carica altre recensioni';

  @override
  String get productRelatedProduct => 'Prodotto correlato';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% di sconto';
  }

  @override
  String get productVeryGood => 'Molto buono';

  @override
  String get productGood => 'Buono';

  @override
  String get productAverage => 'Nella media';

  @override
  String get productBad => 'Scarso';

  @override
  String get productVeryBad => 'Molto scarso';

  @override
  String get productInStock => 'Disponibile';

  @override
  String get productOutOfStock => 'Esaurito';

  @override
  String get productQuantity => 'Quantità';

  @override
  String get productWishlistAction => 'Wishlist';

  @override
  String get productCompareAction => 'Confronta';

  @override
  String get productShareAction => 'Condividi';

  @override
  String get productLoginToCompare => 'Accedi per aggiungere al confronto';

  @override
  String get productAddedToCompare => 'Aggiunto al confronto';

  @override
  String get productAddToCart => 'Aggiungi al carrello';

  @override
  String get accountMoveToCart => 'Sposta nel carrello';

  @override
  String get productBuyNow => 'Acquista ora';

  @override
  String get productSelectOptionsFirst =>
      'Seleziona prima le opzioni del prodotto';

  @override
  String get productBookingBookTable => 'Prenota un tavolo *';

  @override
  String get productBookingSelectDateRequired => 'Seleziona la data *';

  @override
  String get productBookingSelectSlotRequired => 'Seleziona la fascia oraria *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Richieste speciali/Note *';

  @override
  String get productBookingBookAppointment => 'Prenota un appuntamento *';

  @override
  String get productBookingDateFormatHint => 'AAAA-MM-GG';

  @override
  String get productBookingFrom => 'Da';

  @override
  String get productBookingTo => 'A';

  @override
  String get productBookingSelectDate => 'Seleziona la data';

  @override
  String get productBookingLocation => 'Posizione';

  @override
  String get productBookingSlotDuration => 'Durata della fascia oraria';

  @override
  String get productBookingAvailability => 'Disponibilità';

  @override
  String get productBookingStartDate => 'Data di inizio';

  @override
  String get productBookingEndDate => 'Data di fine';

  @override
  String get productBookingDate => 'Data';

  @override
  String get productBookingViewOnMap => 'Visualizza sulla mappa';

  @override
  String get productBookingEventOn => 'Evento il:';

  @override
  String get productBookingBookYourTicket => 'Prenota il tuo biglietto';

  @override
  String get productBookingSlotDurationLabel => 'Durata della fascia oraria:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count minuti';
  }

  @override
  String get productBookingAvailableFrom => 'Disponibile dal';

  @override
  String get productBookingAvailableTo => 'Disponibile fino al';

  @override
  String get productBookingSpecialRequestNotesHint => 'Richieste speciali/Note';

  @override
  String get productBookingChooseRentOption =>
      'Scegli l\'opzione di noleggio *';

  @override
  String get productBookingDailyBasis => 'Giornaliero';

  @override
  String get productBookingHourlyBasis => 'Orario';

  @override
  String get productBookingNoDatesAvailable =>
      'Nessuna data disponibile per la prenotazione';

  @override
  String get productBookingSelectSlot => 'Seleziona la fascia oraria';

  @override
  String get productBookingSelectDateFirst => 'Seleziona prima una data';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Seleziona prima una data per vedere le fasce orarie disponibili.';

  @override
  String get productBookingLoadingSlots => 'Caricamento delle fasce orarie...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Le fasce orarie disponibili per la data selezionata sono in caricamento.';

  @override
  String get productBookingUnableToLoadSlots =>
      'Impossibile caricare le fasce orarie';

  @override
  String get productBookingNoSlotsAvailable =>
      'Nessuna fascia oraria disponibile';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Non ci sono fasce orarie disponibili per la data selezionata.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Seleziona una fascia oraria disponibile per continuare.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Richieste speciali/Note';

  @override
  String get productDownloadableLinks => 'Link';

  @override
  String get productDownloadableSamples => 'Campioni';

  @override
  String get productDownloadSample => 'Scarica campione';

  @override
  String get productDefaultName => 'Prodotto';

  @override
  String get categoryDefaultName => 'Categorie';

  @override
  String get categorySubCategories => 'Sottocategorie';

  @override
  String get categorySomethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get categoryUnknownError => 'Errore sconosciuto';

  @override
  String categoryItemsFound(Object count) {
    return '$count articoli trovati';
  }

  @override
  String get categoryNoProductsFound => 'Nessun prodotto trovato';

  @override
  String get categorySort => 'Ordina';

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
  String get categoryFilter => 'Filtra';

  @override
  String get categoryFilters => 'Filtri';

  @override
  String get categoryNoFiltersAvailable => 'Nessun filtro disponibile';

  @override
  String get categoryFiltersWillAppear =>
      'I filtri appariranno quando disponibili per questa categoria';

  @override
  String get categoryApplyFilters => 'Applica filtri';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Applica filtri ($count)';
  }

  @override
  String get categoryClearAll => 'Cancella tutto';

  @override
  String get categoryTryAdjustingFilters =>
      'Prova a modificare i filtri o i criteri di ricerca';

  @override
  String get categoryError => 'Errore';

  @override
  String get categoryLoginToManageWishlist => 'Accedi per gestire la wishlist';

  @override
  String get categoryAddedToWishlist => 'Aggiunto alla wishlist';

  @override
  String get categoryRemovedFromWishlist => 'Rimosso dalla wishlist';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Impossibile aggiornare la wishlist: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Carrello';

  @override
  String get cartPleaseLoginWishlist => 'Accedi per vedere la wishlist';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText nel carrello';
  }

  @override
  String get cartYourCartEmpty => 'Il tuo carrello è vuoto';

  @override
  String get cartAddProductsHere =>
      'Aggiungi prodotti al carrello per vederli qui';

  @override
  String get cartContinueShopping => 'Continua gli acquisti';

  @override
  String get cartUnit => 'Unità';

  @override
  String get cartUnits => 'Unità';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Accedi per aggiungere alla wishlist';

  @override
  String get cartMovedToWishlist => 'Spostato nella wishlist';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Impossibile spostare nella wishlist: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Mostra di più';

  @override
  String get cartViewLess => 'Mostra meno';

  @override
  String get cartEmptyCartAction => 'Svuota carrello';

  @override
  String get cartApplyCoupon => 'Applica coupon';

  @override
  String get cartCouponCode => 'Codice coupon';

  @override
  String get cartApply => 'Applica';

  @override
  String get cartAppliedCoupon => 'Coupon applicato';

  @override
  String get cartRemove => 'Rimuovi';

  @override
  String get cartPriceBreak => 'Dettaglio prezzi';

  @override
  String get cartSubTotal => 'Subtotale';

  @override
  String get cartDiscount => 'Sconto';

  @override
  String get cartDeliveryCharges => 'Spese di consegna';

  @override
  String get cartTax => 'Tasse';

  @override
  String get cartGrandTotal => 'Totale complessivo';

  @override
  String get cartAmountToBePaid => 'Importo da pagare';

  @override
  String get cartPayNow => 'Paga ora';

  @override
  String get cartRemoveItem => 'Rimuovi articolo';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Sei sicuro di voler rimuovere \"$productName\" dal carrello?';
  }

  @override
  String get cartCancel => 'Annulla';

  @override
  String get cartEmptyCartTitle => 'Svuota carrello';

  @override
  String get cartEmptyCartConfirm =>
      'Sei sicuro di voler rimuovere tutti gli articoli dal carrello?';

  @override
  String get checkout => 'Checkout';

  @override
  String get checkoutBillingTo => 'Fatturazione a';

  @override
  String get checkoutDeliveredTo => 'Consegnato a';

  @override
  String get checkoutChange => 'Modifica';

  @override
  String get checkoutSelectBillingAddress =>
      'Seleziona indirizzo di fatturazione';

  @override
  String get checkoutSelectShippingAddress =>
      'Seleziona indirizzo di spedizione';

  @override
  String get checkoutBillingAddress => 'Indirizzo di fatturazione';

  @override
  String get checkoutEnterAddress => 'Inserisci indirizzo';

  @override
  String get checkoutFirstName => 'Nome';

  @override
  String get checkoutLastName => 'Cognome';

  @override
  String get checkoutEmail => 'E-mail';

  @override
  String get checkoutPhone => 'Telefono';

  @override
  String get checkoutStreetAddress => 'Indirizzo';

  @override
  String get checkoutCountry => 'Paese';

  @override
  String get checkoutState => 'Provincia';

  @override
  String get checkoutCity => 'Città';

  @override
  String get checkoutPostcode => 'CAP';

  @override
  String get checkoutCompanyOptional => 'Azienda (facoltativo)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Usare lo stesso indirizzo per la spedizione?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Telefono: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Ufficio';

  @override
  String get checkoutAddressTypeHome => 'Casa';

  @override
  String get checkoutAddressTypeBilling => 'Fatturazione';

  @override
  String get checkoutAddressTypeShipping => 'Spedizione';

  @override
  String get checkoutAddressTypeDefault => 'Predefinito';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field è obbligatorio';
  }

  @override
  String get checkoutSaveContinue => 'Salva e continua';

  @override
  String get checkoutYourCartEmpty => 'Il tuo carrello è vuoto';

  @override
  String get checkoutSelectCountry => 'Seleziona paese';

  @override
  String get checkoutSelectState => 'Seleziona provincia';

  @override
  String get checkoutCountryRequired => 'Il paese è obbligatorio';

  @override
  String get checkoutStateRequired => 'La provincia è obbligatoria';

  @override
  String get checkoutSelectCountryFirst => 'Seleziona prima un paese';

  @override
  String get checkoutShippingMethod => 'Metodo di spedizione';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Salva il tuo indirizzo per vedere le opzioni di spedizione';

  @override
  String get checkoutPaymentMethod => 'Metodo di pagamento';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Seleziona prima un metodo di spedizione';

  @override
  String get checkoutEnterCouponCode => 'Inserisci il tuo codice coupon';

  @override
  String get checkoutDiscountCoupon => 'Sconto (coupon)';

  @override
  String get checkoutPlaceOrder => 'Effettua ordine';

  @override
  String get thankYouTitle => 'Grazie per il tuo ordine!';

  @override
  String get thankYouSubtitle =>
      'Ti invieremo via e-mail i dettagli e il tracking del tuo ordine';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Il tuo ordine n. $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Visualizza ordine';

  @override
  String get thankYouContinueShopping => 'Continua gli acquisti';

  @override
  String get accountPleaseTryAgainLater => 'Riprova più tardi';

  @override
  String get accountUserFallback => 'Utente';

  @override
  String get accountBack => 'Indietro';

  @override
  String get accountSettings => 'Impostazioni';

  @override
  String get accountMyOrders => 'I miei ordini';

  @override
  String get accountMyDownloadableProducts => 'I miei prodotti scaricabili';

  @override
  String get accountWishlist => 'Wishlist';

  @override
  String get accountCompareProducts => 'Confronta prodotti';

  @override
  String get accountProductReview => 'Recensione prodotto';

  @override
  String get accountAddressBook => 'Rubrica indirizzi';

  @override
  String get accountEditAccount => 'Modifica account';

  @override
  String get accountLogout => 'Esci';

  @override
  String get accountLogoutConfirmation => 'Sei sicuro di voler uscire?';

  @override
  String get accountNoCountriesAvailable =>
      'Nessun paese disponibile. Riprova.';

  @override
  String get accountPleaseSelectCountry => 'Seleziona un paese';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Seleziona o inserisci una provincia';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'Indirizzo aggiornato con successo';

  @override
  String get accountAddressAddedSuccessfully =>
      'Indirizzo aggiunto con successo';

  @override
  String get accountGoBack => 'Torna indietro';

  @override
  String get accountEditAddress => 'Modifica indirizzo';

  @override
  String get accountAddNewAddress => 'Aggiungi nuovo indirizzo';

  @override
  String get accountFirstNameRequired => 'Il nome è obbligatorio';

  @override
  String get accountLastNameRequired => 'Il cognome è obbligatorio';

  @override
  String get accountEnterValidEmail => 'Inserisci un\'e-mail valida';

  @override
  String get accountCompanyName => 'Nome azienda';

  @override
  String get accountVatId => 'Partita IVA';

  @override
  String get accountStreetAddressRequired => 'L\'indirizzo è obbligatorio';

  @override
  String get accountCityRequired => 'La città è obbligatoria';

  @override
  String get accountZipPostcode => 'CAP';

  @override
  String get accountZipPostcodeRequired => 'Il CAP è obbligatorio';

  @override
  String get accountTelephone => 'Telefono';

  @override
  String get accountPhoneNumberRequired =>
      'Il numero di telefono è obbligatorio';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Modifica indirizzo di fatturazione predefinito';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Modifica indirizzo di spedizione predefinito';

  @override
  String get accountUpdateAddress => 'Aggiorna indirizzo';

  @override
  String get accountSaveToAddressBook => 'Salva nella rubrica';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Accedi per scrivere una recensione';

  @override
  String get accountPleaseSelectRating => 'Seleziona una valutazione';

  @override
  String get accountAddReview => 'Aggiungi recensione';

  @override
  String get accountReviewSubmitted => 'Recensione inviata!';

  @override
  String get accountNickName => 'Nickname';

  @override
  String get accountEnterYourName => 'Inserisci il tuo nome';

  @override
  String get accountNameRequired => 'Il nome è obbligatorio';

  @override
  String get accountSummary => 'Riepilogo';

  @override
  String get accountReviewSummaryHint => 'Breve riepilogo della tua recensione';

  @override
  String get accountSummaryRequired => 'Il riepilogo è obbligatorio';

  @override
  String get accountReview => 'Recensione';

  @override
  String get accountDetailedReviewHint =>
      'Scrivi qui la tua recensione dettagliata';

  @override
  String get accountReviewRequired => 'La recensione è obbligatoria';

  @override
  String get accountRating => 'Valutazione';

  @override
  String get accountSubmitReview => 'Invia recensione';

  @override
  String get accountCouldNotLoadAddresses =>
      'Impossibile caricare gli indirizzi';

  @override
  String get accountPleaseTryAgain => 'Riprova';

  @override
  String get accountNoAddressesSaved => 'Nessun indirizzo salvato';

  @override
  String get accountAddAddressToGetStarted =>
      'Aggiungi un nuovo indirizzo per iniziare';

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
  String get accountNoProductsToCompare => 'Nessun prodotto da confrontare';

  @override
  String get accountAddProductsToCompareHint =>
      'Aggiungi prodotti da confrontare dalla pagina dettaglio prodotto.';

  @override
  String get accountProducts => 'Prodotti';

  @override
  String get accountDescription => 'Descrizione';

  @override
  String get accountShortDescription => 'Descrizione breve';

  @override
  String get accountActivity => 'Attività';

  @override
  String get accountSeller => 'Venditore';

  @override
  String get accountNotAvailable => 'N/D';

  @override
  String get accountMessageSentSuccessfully =>
      'Messaggio inviato con successo!';

  @override
  String get accountAnErrorOccurred => 'Si è verificato un errore';

  @override
  String get accountContactUs => 'Contattaci';

  @override
  String get accountName => 'Nome';

  @override
  String get accountEnterYourEmail => 'Inserisci la tua e-mail';

  @override
  String get accountContact => 'Contatto';

  @override
  String get accountEnterYourPhoneNumber =>
      'Inserisci il tuo numero di telefono';

  @override
  String get accountMessage => 'Messaggio';

  @override
  String get accountEnterYourMessage => 'Inserisci il tuo messaggio';

  @override
  String get accountSendMessage => 'Invia messaggio';

  @override
  String get accountNameFieldEmpty => 'Il campo nome non può essere vuoto';

  @override
  String get accountNameMinChars => 'Il nome deve contenere almeno 2 caratteri';

  @override
  String get accountEmailFieldEmpty => 'Il campo e-mail non può essere vuoto';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Inserisci un indirizzo e-mail valido';

  @override
  String get accountContactNumberEmpty =>
      'Il numero di contatto non può essere vuoto';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Inserisci un numero di contatto valido';

  @override
  String get accountMessageFieldEmpty =>
      'Il campo messaggio non può essere vuoto';

  @override
  String get accountMessageMinChars =>
      'Il messaggio deve contenere almeno 10 caratteri';

  @override
  String get accountDownloadableProducts => 'Prodotti scaricabili';

  @override
  String get accountNoDownloadsYet => 'Nessun download disponibile';

  @override
  String get accountDownloadsEmptyDescription =>
      'I tuoi prodotti scaricati appariranno qui.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total prodotti';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value rimanenti';
  }

  @override
  String get accountDownload => 'Scarica';

  @override
  String accountFileName(Object fileName) {
    return 'File: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Il download inizierà a breve. Controlla la cartella Download.';

  @override
  String get accountClose => 'Chiudi';

  @override
  String get accountOrders => 'Ordini';

  @override
  String get accountNoOrdersYet => 'Nessun ordine per ora';

  @override
  String get accountOrdersEmptyDescription =>
      'I tuoi ordini appariranno qui una volta effettuato un acquisto.';

  @override
  String get accountOrderSingular => 'Ordine';

  @override
  String get accountOrderPlural => 'Ordini';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Articoli $count)';
  }

  @override
  String get accountOrderAndReturn => 'Ordine e reso';

  @override
  String get accountTrackOrder => 'Traccia ordine';

  @override
  String get accountReturnPolicy => 'Politica di reso';

  @override
  String get accountReturnRequest => 'Richiesta di reso';

  @override
  String get accountMyReturns => 'I miei resi';

  @override
  String get accountReturns => 'Resi';

  @override
  String get accountReturnSingular => 'Reso';

  @override
  String get accountReturnPlural => 'Resi';

  @override
  String get accountNoReturnsYet => 'Ancora nessun reso';

  @override
  String get accountReturnsEmptyDescription =>
      'Le tue richieste di reso appariranno qui.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Reso $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Ordine $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Qtà: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Max: $count';
  }

  @override
  String get accountReturnResolution => 'Risoluzione';

  @override
  String get accountReturnResolutionReturn => 'Reso';

  @override
  String get accountReturnResolutionCancel => 'Annulla articoli';

  @override
  String get accountReturnReason => 'Motivo';

  @override
  String get accountReturnSelectReason => 'Seleziona un motivo';

  @override
  String get accountReturnPackageCondition => 'Condizione della confezione';

  @override
  String get accountReturnPackageConditionHint =>
      'es. aperta, sigillata, scatola danneggiata';

  @override
  String get accountReturnAdditionalInfo => 'Informazioni aggiuntive';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Descrivi il problema (facoltativo)';

  @override
  String get accountReturnAgreement =>
      'Accetto i termini della politica di reso';

  @override
  String get accountReturnAgreementRequired =>
      'Accetta la politica di reso per continuare';

  @override
  String get accountReturnSubmit => 'Invia richiesta';

  @override
  String get accountReturnCreatedTitle => 'Richiesta inviata';

  @override
  String get accountReturnCreatedMessage =>
      'La tua richiesta di reso è stata inviata con successo.';

  @override
  String get accountReturnSelectItem => 'Seleziona articolo';

  @override
  String get accountReturnNoReturnableItems => 'Nessun articolo restituibile';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Questo ordine non contiene articoli idonei al reso o all\'annullamento.';

  @override
  String get accountReturnViewAction => 'Visualizza';

  @override
  String get accountReturnCancelAction => 'Annulla richiesta';

  @override
  String get accountReturnCloseAction => 'Segna come risolto';

  @override
  String get accountReturnReopenAction => 'Riapri richiesta';

  @override
  String get accountReturnCancelConfirmation =>
      'Vuoi davvero annullare questa richiesta di reso?';

  @override
  String get accountReturnCloseConfirmation =>
      'Segnare questa richiesta di reso come risolta?';

  @override
  String get accountReturnMessages => 'Messaggi';

  @override
  String get accountReturnNoMessages => 'Ancora nessun messaggio.';

  @override
  String get accountReturnMessageHint => 'Scrivi un messaggio…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Stato del reso aggiornato a $status';
  }

  @override
  String get accountReturnExpired => 'Periodo di reso scaduto';

  @override
  String get accountReturnInformation => 'Informazioni';

  @override
  String get accountReturnSelectOrder => 'Seleziona un ordine';

  @override
  String get accountReturnChangeOrder => 'Cambia';

  @override
  String get accountReturnChooseAnotherOrder => 'Scegli un altro ordine';

  @override
  String get accountNotifications => 'Notifiche';

  @override
  String get accountPrivacy => 'Privacy';

  @override
  String get accountAccount => 'Account';

  @override
  String get accountPreferences => 'Preferenze';

  @override
  String get accountLanguage => 'Lingua';

  @override
  String get accountNoLanguagesAvailable => 'Nessuna lingua disponibile';

  @override
  String get accountCurrency => 'Valuta';

  @override
  String get accountOthers => 'Altro';

  @override
  String get accountNoPagesAvailable => 'Nessuna pagina disponibile';

  @override
  String get accountProductReviews => 'Recensioni prodotto';

  @override
  String get accountMyReviews => 'Le mie recensioni';

  @override
  String get accountNoReviewsYet => 'Nessuna recensione al momento';

  @override
  String get accountReviewsEmptyDescription =>
      'Le tue recensioni prodotto appariranno qui.';

  @override
  String get accountReviewSingular => 'Recensione';

  @override
  String get accountReviewPlural => 'Recensioni';

  @override
  String accountPostedOn(Object date) {
    return 'Pubblicato il $date';
  }

  @override
  String get accountCloseSettings => 'Chiudi impostazioni';

  @override
  String get accountChangeTheme => 'Cambia tema';

  @override
  String get accountAllNotifications => 'Tutte le notifiche';

  @override
  String get accountOffers => 'Offerte';

  @override
  String get accountOfflineData => 'Dati offline';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Tieni traccia e mostra i prodotti visualizzati di recente';

  @override
  String get accountShowSearchTag => 'Mostra tag di ricerca';

  @override
  String get accountTryAgain => 'Riprova';

  @override
  String get accountYourWishlistEmpty => 'La tua wishlist è vuota';

  @override
  String get accountWishlistEmptyDescription =>
      'Sfoglia i prodotti e aggiungili alla tua wishlist';

  @override
  String get accountItemSingular => 'Articolo';

  @override
  String get accountItemPlural => 'Articoli';

  @override
  String accountStartingAt(Object price) {
    return 'A partire da $price';
  }

  @override
  String get accountAboutThisPage => 'Informazioni su questa pagina';

  @override
  String accountPageId(Object id) {
    return 'ID pagina: $id';
  }

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabCategories => 'Categorie';

  @override
  String get mainTabCart => 'Carrello';

  @override
  String get mainTabAccount => 'Account';

  @override
  String get authLoginSuccess => 'Benvenuto! Accesso effettuato con successo.';

  @override
  String get authWelcomeBack => 'Bentornato!';

  @override
  String get authLoginToAccount => 'Accedi al tuo account';

  @override
  String get authEmailAddress => 'Indirizzo e-mail';

  @override
  String get authEnterYourEmail => 'Inserisci la tua e-mail';

  @override
  String get authPleaseEnterEmail => 'Inserisci la tua e-mail';

  @override
  String get authPleaseEnterValidEmail => 'Inserisci un\'e-mail valida';

  @override
  String get authPassword => 'Password';

  @override
  String get authEnterYourPassword => 'Inserisci la tua password';

  @override
  String get authPleaseEnterPassword => 'Inserisci la tua password';

  @override
  String get authPasswordMinLength =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get authForgotPasswordTitle => 'Password dimenticata?';

  @override
  String get authLogin => 'Accedi';

  @override
  String get authNoAccountPrompt => 'Non hai un account? ';

  @override
  String get authSignUp => 'Registrati';

  @override
  String get authAccountCreatedSuccess => 'Account creato con successo!';

  @override
  String get authCreateAccount => 'Crea account';

  @override
  String get authSignupGetStarted => 'Registrati per iniziare';

  @override
  String get authFirstNameHint => 'Nome';

  @override
  String get authLastNameHint => 'Cognome';

  @override
  String get authRequired => 'Obbligatorio';

  @override
  String get authCreatePasswordHint => 'Crea una password';

  @override
  String get authConfirmPassword => 'Conferma password';

  @override
  String get authConfirmPasswordHint => 'Conferma la tua password';

  @override
  String get authPleaseConfirmPassword => 'Conferma la tua password';

  @override
  String get authPasswordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get authAlreadyHaveAccountPrompt => 'Hai già un account? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Inserisci il tuo indirizzo e-mail e ti invieremo un link per reimpostare la password.';

  @override
  String get authSendResetLink => 'Invia link di reimpostazione';

  @override
  String get authBackToLogin => 'Torna al login';

  @override
  String get authNiceToSeeYouHere => 'Felici di vederti qui';

  @override
  String get accountEditTitle => 'Modifica account';

  @override
  String get accountFirstNameRequiredLabel => 'Nome *';

  @override
  String get accountLastNameRequiredLabel => 'Cognome *';

  @override
  String get accountChangeEmail => 'Cambia e-mail';

  @override
  String get accountChangePassword => 'Cambia password';

  @override
  String get accountDeleteAccount => 'Elimina account';

  @override
  String get accountGender => 'Genere';

  @override
  String get accountSelectGender => 'Seleziona genere';

  @override
  String get accountDob => 'Data di nascita';

  @override
  String get monthJanShort => 'Gen';

  @override
  String get monthFebShort => 'Feb';

  @override
  String get monthMarShort => 'Mar';

  @override
  String get monthAprShort => 'Apr';

  @override
  String get monthMayShort => 'Mag';

  @override
  String get monthJunShort => 'Giu';

  @override
  String get monthJulShort => 'Lug';

  @override
  String get monthAugShort => 'Ago';

  @override
  String get monthSepShort => 'Set';

  @override
  String get monthOctShort => 'Ott';

  @override
  String get monthNovShort => 'Nov';

  @override
  String get monthDecShort => 'Dic';

  @override
  String get accountSubscribeNewsletters => 'Iscriviti alle newsletter';

  @override
  String get accountSaveProfile => 'Salva profilo';

  @override
  String get accountNewEmail => 'Nuova e-mail';

  @override
  String get accountEmailRequired => 'L\'e-mail è obbligatoria';

  @override
  String get accountCurrentPassword => 'Password attuale';

  @override
  String get accountPasswordRequired => 'La password è obbligatoria';

  @override
  String get accountChange => 'Cambia';

  @override
  String get accountCurrentPasswordRequired =>
      'La password attuale è obbligatoria';

  @override
  String get accountNewPassword => 'Nuova password';

  @override
  String get accountConfirmPassword => 'Conferma password';

  @override
  String get accountDeleteWarning =>
      'Questa azione è permanente e non può essere annullata. Tutti i tuoi dati saranno eliminati.';

  @override
  String get accountEnterYourPassword => 'Inserisci la tua password';

  @override
  String get accountDelete => 'Elimina';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Maschio';

  @override
  String get accountGenderFemale => 'Femmina';

  @override
  String get accountGenderOther => 'Altro';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Ordini $number';
  }

  @override
  String get accountReorderSuccessful => 'Riordino completato con successo';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count articoli aggiunti al carrello.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Vai al carrello';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Impossibile caricare i dettagli dell\'ordine';

  @override
  String get accountDetails => 'Dettagli';

  @override
  String get accountInvoices => 'Fatture';

  @override
  String get accountShipments => 'Spedizioni';

  @override
  String accountPlacedOn(Object date) {
    return 'Effettuato il $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count articolo/i ordinati';
  }

  @override
  String get accountBillingAddress => 'Indirizzo di fatturazione';

  @override
  String get accountShippingAddress => 'Indirizzo di spedizione';

  @override
  String get accountShippingMethod => 'Metodo di spedizione';

  @override
  String get accountPaymentMethod => 'Metodo di pagamento';

  @override
  String get accountNoInvoicesForOrder => 'Nessuna fattura per questo ordine';

  @override
  String accountInvoicedCount(int count) {
    return '$count fatturato/i';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'Nessuna spedizione per questo ordine';

  @override
  String get accountReorder => 'Riordina';

  @override
  String get accountCancelOrder => 'Annulla ordine';

  @override
  String get accountCancelOrderConfirmation =>
      'Vuoi davvero annullare questo ordine? L\'operazione non può essere annullata.';

  @override
  String get accountMoreInfo => 'Maggiori info';

  @override
  String get accountOrderedQty => 'Qtà ordinata';

  @override
  String get accountShipped => 'Spedito';

  @override
  String get accountInvoiced => 'Fatturato';

  @override
  String get accountUnitPrice => 'Prezzo unitario';

  @override
  String get accountSubTotalWithSpace => 'Subtotale';

  @override
  String get accountTotalPaid => 'Totale pagato';

  @override
  String get accountTotalRefunded => 'Totale rimborsato';

  @override
  String get accountTotalDue => 'Totale dovuto';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Fattura $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Spedizione $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Impossibile caricare i dettagli della fattura';

  @override
  String get accountInvoiceStatus => 'Stato fattura';

  @override
  String get accountInvoiceDate => 'Data fattura';

  @override
  String get accountOrderId => 'ID ordine';

  @override
  String get accountOrderDate => 'Data ordine';

  @override
  String get accountOrderStatus => 'Stato ordine';

  @override
  String get accountChannel => 'Canale';

  @override
  String get accountDefault => 'Predefinito';

  @override
  String get accountStatusPaid => 'Pagato';

  @override
  String get accountStatusPending => 'In attesa';

  @override
  String get accountStatusPendingPayment => 'Pagamento in attesa';

  @override
  String get accountStatusOverdue => 'Scaduto';

  @override
  String get accountStatusRefunded => 'Rimborsato';

  @override
  String get accountShippedQty => 'Qtà spedita';

  @override
  String get accountInvoicedQty => 'Qtà fatturata';

  @override
  String get accountUnitPriceWithColon => 'Prezzo unitario:';

  @override
  String get accountSubTotalWithColon => 'Subtotale:';

  @override
  String get accountDownloadInvoice => 'Scarica fattura';

  @override
  String get accountInvoice => 'Fattura';

  @override
  String get accountRecentOrders => 'Ordini recenti';

  @override
  String get accountNoRecentOrders => 'Nessun ordine recente';

  @override
  String get accountStatusProcessing => 'In elaborazione';

  @override
  String get accountStatusCompleted => 'Completato';

  @override
  String get accountStatusCancelled => 'Annullato';

  @override
  String get accountStatusClosed => 'Chiuso';

  @override
  String get accountStatusUnknown => 'Sconosciuto';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Articoli wishlist ($count)';
  }

  @override
  String get accountNoWishlistItems => 'Nessun articolo nella wishlist';

  @override
  String get accountDefaultAddresses => 'Indirizzi predefiniti';

  @override
  String get accountNoProductReviewsYet => 'Ancora nessuna recensione prodotto';

  @override
  String get searchFailedTitle => 'Ricerca non riuscita';

  @override
  String get searchHint => 'Cerca prodotti';

  @override
  String get searchImageSearch => 'Ricerca per immagine';

  @override
  String get searchRecentSearches => 'Ricerche recenti';

  @override
  String get searchClearAll => 'Cancella tutto';

  @override
  String get searchTopCategories => 'Categorie principali';

  @override
  String searchResultsFound(int count) {
    return '$count risultati trovati';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% di sconto';
  }

  @override
  String get searchNoProductsFound => 'Nessun prodotto trovato';

  @override
  String get searchTryDifferentTerm => 'Prova a cercare con un termine diverso';

  @override
  String get searchSpeechNotAvailable =>
      'Il riconoscimento vocale non è disponibile';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Impossibile avviare l\'input vocale: $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Autorizzazione microfono negata';

  @override
  String get searchRetake => 'Riprendi';

  @override
  String get searchSearch => 'Cerca';

  @override
  String get searchTryAgain => 'Riprova';

  @override
  String get searchRecognizedObjects => 'Oggetti riconosciuti';

  @override
  String get searchResult => 'Risultato:';

  @override
  String get searchFailedToCaptureImage => 'Impossibile acquisire l\'immagine';

  @override
  String searchProcessing(int progress) {
    return 'Elaborazione... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Apertura fotocamera...';

  @override
  String get searchFailedToProcessImage => 'Impossibile elaborare l\'immagine';

  @override
  String get homeRecentlyViewedProducts => 'Prodotti visti di recente';

  @override
  String accountItemsCount(int count) {
    return '$count articolo/i';
  }

  @override
  String get accountTrack => 'Traccia';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Tracciamento $trackNumber tramite $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Corriere sconosciuto';

  @override
  String get accountTrackingNumber => 'Numero di tracciamento';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Qtà spedita : $qty';
  }
}
