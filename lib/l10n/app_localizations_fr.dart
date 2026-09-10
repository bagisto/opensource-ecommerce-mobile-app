// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Boutique Bagisto';

  @override
  String get homeFailedToLoad => 'Échec du chargement de la page d\'accueil';

  @override
  String get commonUnknownError => 'Erreur inconnue';

  @override
  String get commonRetry => 'Réessayer';

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
  String get homeFeaturedProducts => 'Produits en vedette';

  @override
  String get homeDefaultProducts => 'Produits';

  @override
  String get homeBackToTop => 'Retour en haut';

  @override
  String get homeViewCart => 'VOIR LE PANIER';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName ajouté au panier';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Veuillez vous connecter pour gérer la liste de souhaits';

  @override
  String get homeAddedToWishlist => 'Ajouté à la liste de souhaits';

  @override
  String get homeRemovedFromWishlist => 'Retiré de la liste de souhaits';

  @override
  String get homeViewAll => 'Voir tout';

  @override
  String get homeCollections => 'Collections';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Catégorie $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% de réduction';
  }

  @override
  String get productFailedToLoad => 'Échec du chargement du produit';

  @override
  String get productNotFound => 'Produit introuvable';

  @override
  String get productDetail => 'Détail du produit';

  @override
  String get productDetails => 'Détails';

  @override
  String get productShowLess => 'Voir moins';

  @override
  String get productLoadMore => 'Charger plus';

  @override
  String get productMoreInformations => 'Plus d\'informations';

  @override
  String get productSku => 'UGS';

  @override
  String get productType => 'Type';

  @override
  String get productBrand => 'Marque';

  @override
  String get productColor => 'Couleur';

  @override
  String get productSize => 'Taille';

  @override
  String get productReviews => 'Avis';

  @override
  String get productNoReviewsYet => 'Aucun avis pour le moment';

  @override
  String productRating(Object count) {
    return '$count note';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count avis';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Publié le $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Votre avis a été envoyé !';

  @override
  String get productWriteReview => 'Rédiger un avis';

  @override
  String get productPleaseLoginForReviews =>
      'Veuillez vous connecter pour voir vos avis';

  @override
  String get productLoadMoreReviews => 'Charger plus d\'avis';

  @override
  String get productRelatedProduct => 'Produit associé';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% de réduction';
  }

  @override
  String get productVeryGood => 'Très bien';

  @override
  String get productGood => 'Bien';

  @override
  String get productAverage => 'Moyen';

  @override
  String get productBad => 'Mauvais';

  @override
  String get productVeryBad => 'Très mauvais';

  @override
  String get productInStock => 'En stock';

  @override
  String get productOutOfStock => 'Rupture de stock';

  @override
  String get productQuantity => 'Quantité';

  @override
  String get productWishlistAction => 'Liste de souhaits';

  @override
  String get productCompareAction => 'Comparer';

  @override
  String get productShareAction => 'Partager';

  @override
  String get productLoginToCompare =>
      'Veuillez vous connecter pour ajouter au comparatif';

  @override
  String get productAddedToCompare => 'Ajouté au comparatif';

  @override
  String get productAddToCart => 'Ajouter au panier';

  @override
  String get accountMoveToCart => 'Déplacer vers le panier';

  @override
  String get productBuyNow => 'Acheter maintenant';

  @override
  String get productSelectOptionsFirst =>
      'Veuillez d\'abord sélectionner les options du produit';

  @override
  String get productBookingBookTable => 'Réserver une table *';

  @override
  String get productBookingSelectDateRequired => 'Sélectionner une date *';

  @override
  String get productBookingSelectSlotRequired => 'Sélectionner un créneau *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Demandes spéciales/Notes *';

  @override
  String get productBookingBookAppointment => 'Prendre rendez-vous *';

  @override
  String get productBookingDateFormatHint => 'AAAA-MM-JJ';

  @override
  String get productBookingFrom => 'Du';

  @override
  String get productBookingTo => 'Au';

  @override
  String get productBookingSelectDate => 'Sélectionner une date';

  @override
  String get productBookingLocation => 'Lieu';

  @override
  String get productBookingSlotDuration => 'Durée du créneau';

  @override
  String get productBookingAvailability => 'Disponibilité';

  @override
  String get productBookingStartDate => 'Date de début';

  @override
  String get productBookingEndDate => 'Date de fin';

  @override
  String get productBookingDate => 'Date';

  @override
  String get productBookingViewOnMap => 'Voir sur la carte';

  @override
  String get productBookingEventOn => 'Événement le :';

  @override
  String get productBookingBookYourTicket => 'Réservez votre billet';

  @override
  String get productBookingSlotDurationLabel => 'Durée du créneau :';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get productBookingAvailableFrom => 'Disponible à partir du';

  @override
  String get productBookingAvailableTo => 'Disponible jusqu\'au';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Demandes spéciales/Notes';

  @override
  String get productBookingChooseRentOption =>
      'Choisir l\'option de location *';

  @override
  String get productBookingDailyBasis => 'À la journée';

  @override
  String get productBookingHourlyBasis => 'À l\'heure';

  @override
  String get productBookingNoDatesAvailable =>
      'Aucune date disponible pour la réservation';

  @override
  String get productBookingSelectSlot => 'Sélectionner un créneau';

  @override
  String get productBookingSelectDateFirst => 'Sélectionnez d\'abord une date';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Sélectionnez d\'abord une date pour voir les créneaux disponibles.';

  @override
  String get productBookingLoadingSlots => 'Chargement des créneaux...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Les créneaux disponibles pour la date sélectionnée sont en cours de chargement.';

  @override
  String get productBookingUnableToLoadSlots =>
      'Impossible de charger les créneaux';

  @override
  String get productBookingNoSlotsAvailable => 'Aucun créneau disponible';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Aucun créneau n\'est disponible pour la date sélectionnée.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Sélectionnez un créneau disponible pour continuer.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Demandes spéciales/Notes';

  @override
  String get productDownloadableLinks => 'Liens';

  @override
  String get productDownloadableSamples => 'Exemples';

  @override
  String get productDownloadSample => 'Télécharger l\'exemple';

  @override
  String get productDefaultName => 'Produit';

  @override
  String get categoryDefaultName => 'Catégories';

  @override
  String get categorySubCategories => 'Sous-catégories';

  @override
  String get categorySomethingWentWrong => 'Un problème est survenu';

  @override
  String get categoryUnknownError => 'Erreur inconnue';

  @override
  String categoryItemsFound(Object count) {
    return '$count articles trouvés';
  }

  @override
  String get categoryNoProductsFound => 'Aucun produit trouvé';

  @override
  String get categorySort => 'Trier';

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
  String get categoryFilter => 'Filtrer';

  @override
  String get categoryFilters => 'Filtres';

  @override
  String get categoryNoFiltersAvailable => 'Aucun filtre disponible';

  @override
  String get categoryFiltersWillAppear =>
      'Les filtres apparaîtront lorsqu\'ils seront disponibles pour cette catégorie';

  @override
  String get categoryApplyFilters => 'Appliquer les filtres';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Appliquer les filtres ($count)';
  }

  @override
  String get categoryClearAll => 'Tout effacer';

  @override
  String get categoryTryAdjustingFilters =>
      'Essayez d\'ajuster vos filtres ou vos critères de recherche';

  @override
  String get categoryError => 'Erreur';

  @override
  String get categoryLoginToManageWishlist =>
      'Veuillez vous connecter pour gérer la liste de souhaits';

  @override
  String get categoryAddedToWishlist => 'Ajouté à la liste de souhaits';

  @override
  String get categoryRemovedFromWishlist => 'Retiré de la liste de souhaits';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Impossible de mettre à jour la liste de souhaits : $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Panier';

  @override
  String get cartPleaseLoginWishlist =>
      'Veuillez vous connecter pour voir la liste de souhaits';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText dans le panier';
  }

  @override
  String get cartYourCartEmpty => 'Votre panier est vide';

  @override
  String get cartAddProductsHere =>
      'Ajoutez des produits à votre panier pour les voir ici';

  @override
  String get cartContinueShopping => 'Continuer les achats';

  @override
  String get cartUnit => 'Unité';

  @override
  String get cartUnits => 'Unités';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Veuillez vous connecter pour ajouter à la liste de souhaits';

  @override
  String get cartMovedToWishlist => 'Déplacé vers la liste de souhaits';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Échec du déplacement vers la liste de souhaits : $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Voir plus';

  @override
  String get cartViewLess => 'Voir moins';

  @override
  String get cartEmptyCartAction => 'Vider le panier';

  @override
  String get cartApplyCoupon => 'Appliquer un coupon';

  @override
  String get cartCouponCode => 'Code promo';

  @override
  String get cartApply => 'Appliquer';

  @override
  String get cartAppliedCoupon => 'Coupon appliqué';

  @override
  String get cartRemove => 'Supprimer';

  @override
  String get cartPriceBreak => 'Détail des prix';

  @override
  String get cartSubTotal => 'Sous-total';

  @override
  String get cartDiscount => 'Remise';

  @override
  String get cartDeliveryCharges => 'Frais de livraison';

  @override
  String get cartTax => 'Taxe';

  @override
  String get cartGrandTotal => 'Total général';

  @override
  String get cartAmountToBePaid => 'Montant à payer';

  @override
  String get cartPayNow => 'Payer maintenant';

  @override
  String get cartRemoveItem => 'Supprimer l\'article';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Voulez-vous vraiment supprimer \"$productName\" de votre panier ?';
  }

  @override
  String get cartCancel => 'Annuler';

  @override
  String get cartEmptyCartTitle => 'Vider le panier';

  @override
  String get cartEmptyCartConfirm =>
      'Voulez-vous vraiment supprimer tous les articles de votre panier ?';

  @override
  String get checkout => 'Paiement';

  @override
  String get checkoutBillingTo => 'Facturation à';

  @override
  String get checkoutDeliveredTo => 'Livré à';

  @override
  String get checkoutChange => 'Modifier';

  @override
  String get checkoutSelectBillingAddress =>
      'Sélectionner l\'adresse de facturation';

  @override
  String get checkoutSelectShippingAddress =>
      'Sélectionner l\'adresse de livraison';

  @override
  String get checkoutBillingAddress => 'Adresse de facturation';

  @override
  String get checkoutEnterAddress => 'Saisir l\'adresse';

  @override
  String get checkoutFirstName => 'Prénom';

  @override
  String get checkoutLastName => 'Nom';

  @override
  String get checkoutEmail => 'E-mail';

  @override
  String get checkoutPhone => 'Téléphone';

  @override
  String get checkoutStreetAddress => 'Adresse';

  @override
  String get checkoutCountry => 'Pays';

  @override
  String get checkoutState => 'État';

  @override
  String get checkoutCity => 'Ville';

  @override
  String get checkoutPostcode => 'Code postal';

  @override
  String get checkoutCompanyOptional => 'Société (facultatif)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Utiliser la même adresse pour la livraison ?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Téléphone : $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Bureau';

  @override
  String get checkoutAddressTypeHome => 'Domicile';

  @override
  String get checkoutAddressTypeBilling => 'Facturation';

  @override
  String get checkoutAddressTypeShipping => 'Livraison';

  @override
  String get checkoutAddressTypeDefault => 'Par défaut';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field est requis';
  }

  @override
  String get checkoutSaveContinue => 'Enregistrer et continuer';

  @override
  String get checkoutYourCartEmpty => 'Votre panier est vide';

  @override
  String get checkoutSelectCountry => 'Sélectionner un pays';

  @override
  String get checkoutSelectState => 'Sélectionner un État';

  @override
  String get checkoutCountryRequired => 'Le pays est requis';

  @override
  String get checkoutStateRequired => 'L\'État est requis';

  @override
  String get checkoutSelectCountryFirst => 'Sélectionnez d\'abord un pays';

  @override
  String get checkoutShippingMethod => 'Mode de livraison';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Enregistrez votre adresse pour voir les options de livraison';

  @override
  String get checkoutPaymentMethod => 'Mode de paiement';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Sélectionnez d\'abord un mode de livraison';

  @override
  String get checkoutEnterCouponCode => 'Saisissez votre code promo';

  @override
  String get checkoutDiscountCoupon => 'Remise (coupon)';

  @override
  String get checkoutPlaceOrder => 'Passer la commande';

  @override
  String get thankYouTitle => 'Merci pour votre commande !';

  @override
  String get thankYouSubtitle =>
      'Nous vous enverrons par e-mail les détails et le suivi de votre commande';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Votre commande n° $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Voir la commande';

  @override
  String get thankYouContinueShopping => 'Continuer les achats';

  @override
  String get accountPleaseTryAgainLater => 'Veuillez réessayer plus tard';

  @override
  String get accountUserFallback => 'Utilisateur';

  @override
  String get accountBack => 'Retour';

  @override
  String get accountSettings => 'Paramètres';

  @override
  String get accountMyOrders => 'Mes commandes';

  @override
  String get accountMyDownloadableProducts => 'Mes produits téléchargeables';

  @override
  String get accountWishlist => 'Liste de souhaits';

  @override
  String get accountCompareProducts => 'Comparer les produits';

  @override
  String get accountProductReview => 'Avis produit';

  @override
  String get accountAddressBook => 'Carnet d\'adresses';

  @override
  String get accountEditAccount => 'Modifier le compte';

  @override
  String get accountLogout => 'Déconnexion';

  @override
  String get accountLogoutConfirmation =>
      'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get accountNoCountriesAvailable =>
      'Aucun pays disponible. Veuillez réessayer.';

  @override
  String get accountPleaseSelectCountry => 'Veuillez sélectionner un pays';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Veuillez sélectionner ou saisir un État';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'Adresse mise à jour avec succès';

  @override
  String get accountAddressAddedSuccessfully => 'Adresse ajoutée avec succès';

  @override
  String get accountGoBack => 'Retour';

  @override
  String get accountEditAddress => 'Modifier l\'adresse';

  @override
  String get accountAddNewAddress => 'Ajouter une nouvelle adresse';

  @override
  String get accountFirstNameRequired => 'Le prénom est requis';

  @override
  String get accountLastNameRequired => 'Le nom est requis';

  @override
  String get accountEnterValidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get accountCompanyName => 'Nom de l\'entreprise';

  @override
  String get accountVatId => 'N° TVA';

  @override
  String get accountStreetAddressRequired => 'L\'adresse est requise';

  @override
  String get accountCityRequired => 'La ville est requise';

  @override
  String get accountZipPostcode => 'Code postal';

  @override
  String get accountZipPostcodeRequired => 'Le code postal est requis';

  @override
  String get accountTelephone => 'Téléphone';

  @override
  String get accountPhoneNumberRequired => 'Le numéro de téléphone est requis';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Modifier l\'adresse de facturation par défaut';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Modifier l\'adresse de livraison par défaut';

  @override
  String get accountUpdateAddress => 'Mettre à jour l\'adresse';

  @override
  String get accountSaveToAddressBook =>
      'Enregistrer dans le carnet d\'adresses';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Veuillez vous connecter pour rédiger un avis';

  @override
  String get accountPleaseSelectRating => 'Veuillez sélectionner une note';

  @override
  String get accountAddReview => 'Ajouter un avis';

  @override
  String get accountReviewSubmitted => 'Avis envoyé !';

  @override
  String get accountNickName => 'Pseudo';

  @override
  String get accountEnterYourName => 'Saisissez votre nom';

  @override
  String get accountNameRequired => 'Le nom est requis';

  @override
  String get accountSummary => 'Résumé';

  @override
  String get accountReviewSummaryHint => 'Bref résumé de votre avis';

  @override
  String get accountSummaryRequired => 'Le résumé est requis';

  @override
  String get accountReview => 'Avis';

  @override
  String get accountDetailedReviewHint => 'Rédigez votre avis détaillé ici';

  @override
  String get accountReviewRequired => 'L\'avis est requis';

  @override
  String get accountRating => 'Note';

  @override
  String get accountSubmitReview => 'Envoyer l\'avis';

  @override
  String get accountCouldNotLoadAddresses =>
      'Impossible de charger les adresses';

  @override
  String get accountPleaseTryAgain => 'Veuillez réessayer';

  @override
  String get accountNoAddressesSaved => 'Aucune adresse enregistrée';

  @override
  String get accountAddAddressToGetStarted =>
      'Ajoutez une nouvelle adresse pour commencer';

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
  String get accountNoProductsToCompare => 'Aucun produit à comparer';

  @override
  String get accountAddProductsToCompareHint =>
      'Ajoutez des produits à comparer depuis la page de détail du produit.';

  @override
  String get accountProducts => 'Produits';

  @override
  String get accountDescription => 'Description';

  @override
  String get accountShortDescription => 'Description courte';

  @override
  String get accountActivity => 'Activité';

  @override
  String get accountSeller => 'Vendeur';

  @override
  String get accountNotAvailable => 'N/D';

  @override
  String get accountMessageSentSuccessfully => 'Message envoyé avec succès !';

  @override
  String get accountAnErrorOccurred => 'Une erreur s\'est produite';

  @override
  String get accountContactUs => 'Contactez-nous';

  @override
  String get accountName => 'Nom';

  @override
  String get accountEnterYourEmail => 'Saisissez votre e-mail';

  @override
  String get accountContact => 'Contact';

  @override
  String get accountEnterYourPhoneNumber =>
      'Saisissez votre numéro de téléphone';

  @override
  String get accountMessage => 'Message';

  @override
  String get accountEnterYourMessage => 'Saisissez votre message';

  @override
  String get accountSendMessage => 'Envoyer le message';

  @override
  String get accountNameFieldEmpty => 'Le champ nom ne peut pas être vide';

  @override
  String get accountNameMinChars =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get accountEmailFieldEmpty => 'Le champ e-mail ne peut pas être vide';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get accountContactNumberEmpty =>
      'Le numéro de contact ne peut pas être vide';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Veuillez saisir un numéro de contact valide';

  @override
  String get accountMessageFieldEmpty =>
      'Le champ message ne peut pas être vide';

  @override
  String get accountMessageMinChars =>
      'Le message doit contenir au moins 10 caractères';

  @override
  String get accountDownloadableProducts => 'Produits téléchargeables';

  @override
  String get accountNoDownloadsYet => 'Aucun téléchargement pour le moment';

  @override
  String get accountDownloadsEmptyDescription =>
      'Vos produits téléchargés apparaîtront ici.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total produits';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value restants';
  }

  @override
  String get accountDownload => 'Télécharger';

  @override
  String accountFileName(Object fileName) {
    return 'Fichier : $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Votre téléchargement commencera sous peu. Vérifiez votre dossier de téléchargements.';

  @override
  String get accountClose => 'Fermer';

  @override
  String get accountOrders => 'Commandes';

  @override
  String get accountNoOrdersYet => 'Aucune commande pour le moment';

  @override
  String get accountOrdersEmptyDescription =>
      'Vos commandes apparaîtront ici une fois votre achat effectué.';

  @override
  String get accountOrderSingular => 'Commande';

  @override
  String get accountOrderPlural => 'Commandes';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Articles $count)';
  }

  @override
  String get accountOrderAndReturn => 'Commande et retour';

  @override
  String get accountTrackOrder => 'Suivre la commande';

  @override
  String get accountReturnPolicy => 'Politique de retour';

  @override
  String get accountReturnRequest => 'Demande de retour';

  @override
  String get accountMyReturns => 'Mes retours';

  @override
  String get accountReturns => 'Retours';

  @override
  String get accountReturnSingular => 'Retour';

  @override
  String get accountReturnPlural => 'Retours';

  @override
  String get accountNoReturnsYet => 'Aucun retour pour le moment';

  @override
  String get accountReturnsEmptyDescription =>
      'Vos demandes de retour apparaîtront ici.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Retour $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Commande $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Qté : $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Max : $count';
  }

  @override
  String get accountReturnResolution => 'Résolution';

  @override
  String get accountReturnResolutionReturn => 'Retour';

  @override
  String get accountReturnResolutionCancel => 'Annuler les articles';

  @override
  String get accountReturnReason => 'Motif';

  @override
  String get accountReturnSelectReason => 'Sélectionnez un motif';

  @override
  String get accountReturnPackageCondition => 'État de l\'emballage';

  @override
  String get accountReturnPackageConditionHint =>
      'ex. ouvert, scellé, carton endommagé';

  @override
  String get accountReturnAdditionalInfo => 'Informations complémentaires';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Décrivez le problème (facultatif)';

  @override
  String get accountReturnAgreement =>
      'J\'accepte les conditions de la politique de retour';

  @override
  String get accountReturnAgreementRequired =>
      'Veuillez accepter la politique de retour';

  @override
  String get accountReturnSubmit => 'Envoyer la demande';

  @override
  String get accountReturnCreatedTitle => 'Demande envoyée';

  @override
  String get accountReturnCreatedMessage =>
      'Votre demande de retour a été envoyée avec succès.';

  @override
  String get accountReturnSelectItem => 'Sélectionner un article';

  @override
  String get accountReturnNoReturnableItems => 'Aucun article retournable';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Cette commande ne contient aucun article éligible au retour ou à l\'annulation.';

  @override
  String get accountReturnViewAction => 'Voir';

  @override
  String get accountReturnCancelAction => 'Annuler la demande';

  @override
  String get accountReturnCloseAction => 'Marquer comme résolu';

  @override
  String get accountReturnReopenAction => 'Rouvrir la demande';

  @override
  String get accountReturnCancelConfirmation =>
      'Voulez-vous vraiment annuler cette demande de retour ?';

  @override
  String get accountReturnCloseConfirmation =>
      'Marquer cette demande de retour comme résolue ?';

  @override
  String get accountReturnMessages => 'Messages';

  @override
  String get accountReturnNoMessages => 'Aucun message pour le moment.';

  @override
  String get accountReturnMessageHint => 'Écrire un message…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Statut du retour mis à jour : $status';
  }

  @override
  String get accountReturnExpired => 'Délai de retour expiré';

  @override
  String get accountReturnInformation => 'Informations';

  @override
  String get accountReturnSelectOrder => 'Sélectionnez une commande';

  @override
  String get accountReturnChangeOrder => 'Modifier';

  @override
  String get accountReturnChooseAnotherOrder => 'Choisir une autre commande';

  @override
  String get accountNotifications => 'Notifications';

  @override
  String get accountPrivacy => 'Confidentialité';

  @override
  String get accountAccount => 'Compte';

  @override
  String get accountPreferences => 'Préférences';

  @override
  String get accountLanguage => 'Langue';

  @override
  String get accountNoLanguagesAvailable => 'Aucune langue disponible';

  @override
  String get accountCurrency => 'Devise';

  @override
  String get accountOthers => 'Autres';

  @override
  String get accountNoPagesAvailable => 'Aucune page disponible';

  @override
  String get accountProductReviews => 'Avis produits';

  @override
  String get accountMyReviews => 'Mes avis';

  @override
  String get accountNoReviewsYet => 'Aucun avis pour le moment';

  @override
  String get accountReviewsEmptyDescription =>
      'Vos avis produits apparaîtront ici.';

  @override
  String get accountReviewSingular => 'Avis';

  @override
  String get accountReviewPlural => 'Avis';

  @override
  String accountPostedOn(Object date) {
    return 'Publié le $date';
  }

  @override
  String get accountCloseSettings => 'Fermer les paramètres';

  @override
  String get accountChangeTheme => 'Changer le thème';

  @override
  String get accountAllNotifications => 'Toutes les notifications';

  @override
  String get accountOffers => 'Offres';

  @override
  String get accountOfflineData => 'Données hors ligne';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Suivre et afficher les produits récemment consultés';

  @override
  String get accountShowSearchTag => 'Afficher l\'étiquette de recherche';

  @override
  String get accountTryAgain => 'Réessayer';

  @override
  String get accountYourWishlistEmpty => 'Votre liste de souhaits est vide';

  @override
  String get accountWishlistEmptyDescription =>
      'Parcourez les produits et ajoutez-les à votre liste de souhaits';

  @override
  String get accountItemSingular => 'Article';

  @override
  String get accountItemPlural => 'Articles';

  @override
  String accountStartingAt(Object price) {
    return 'À partir de $price';
  }

  @override
  String get accountAboutThisPage => 'À propos de cette page';

  @override
  String accountPageId(Object id) {
    return 'ID de page : $id';
  }

  @override
  String get mainTabHome => 'Accueil';

  @override
  String get mainTabCategories => 'Catégories';

  @override
  String get mainTabCart => 'Panier';

  @override
  String get mainTabAccount => 'Compte';

  @override
  String get authLoginSuccess => 'Bienvenue ! Connexion réussie.';

  @override
  String get authWelcomeBack => 'Bon retour !';

  @override
  String get authLoginToAccount => 'Connectez-vous à votre compte';

  @override
  String get authEmailAddress => 'Adresse e-mail';

  @override
  String get authEnterYourEmail => 'Saisissez votre e-mail';

  @override
  String get authPleaseEnterEmail => 'Veuillez saisir votre e-mail';

  @override
  String get authPleaseEnterValidEmail =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authEnterYourPassword => 'Saisissez votre mot de passe';

  @override
  String get authPleaseEnterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get authPasswordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get authLogin => 'Connexion';

  @override
  String get authNoAccountPrompt => 'Vous n\'avez pas de compte ? ';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String get authAccountCreatedSuccess => 'Compte créé avec succès !';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authSignupGetStarted => 'Inscrivez-vous pour commencer';

  @override
  String get authFirstNameHint => 'Prénom';

  @override
  String get authLastNameHint => 'Nom';

  @override
  String get authRequired => 'Obligatoire';

  @override
  String get authCreatePasswordHint => 'Créer un mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authConfirmPasswordHint => 'Confirmez votre mot de passe';

  @override
  String get authPleaseConfirmPassword =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get authPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authAlreadyHaveAccountPrompt => 'Vous avez déjà un compte ? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Saisissez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get authSendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authNiceToSeeYouHere => 'Ravi de vous revoir';

  @override
  String get accountEditTitle => 'Modification du compte';

  @override
  String get accountFirstNameRequiredLabel => 'Prénom *';

  @override
  String get accountLastNameRequiredLabel => 'Nom *';

  @override
  String get accountChangeEmail => 'Changer l\'e-mail';

  @override
  String get accountChangePassword => 'Changer le mot de passe';

  @override
  String get accountDeleteAccount => 'Supprimer le compte';

  @override
  String get accountGender => 'Genre';

  @override
  String get accountSelectGender => 'Sélectionner le genre';

  @override
  String get accountDob => 'Date de naissance';

  @override
  String get monthJanShort => 'Jan';

  @override
  String get monthFebShort => 'Fév';

  @override
  String get monthMarShort => 'Mar';

  @override
  String get monthAprShort => 'Avr';

  @override
  String get monthMayShort => 'Mai';

  @override
  String get monthJunShort => 'Juin';

  @override
  String get monthJulShort => 'Juil';

  @override
  String get monthAugShort => 'Aoû';

  @override
  String get monthSepShort => 'Sep';

  @override
  String get monthOctShort => 'Oct';

  @override
  String get monthNovShort => 'Nov';

  @override
  String get monthDecShort => 'Déc';

  @override
  String get accountSubscribeNewsletters => 'S\'abonner aux newsletters';

  @override
  String get accountSaveProfile => 'Enregistrer le profil';

  @override
  String get accountNewEmail => 'Nouvel e-mail';

  @override
  String get accountEmailRequired => 'L\'e-mail est requis';

  @override
  String get accountCurrentPassword => 'Mot de passe actuel';

  @override
  String get accountPasswordRequired => 'Le mot de passe est requis';

  @override
  String get accountChange => 'Modifier';

  @override
  String get accountCurrentPasswordRequired =>
      'Le mot de passe actuel est requis';

  @override
  String get accountNewPassword => 'Nouveau mot de passe';

  @override
  String get accountConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get accountDeleteWarning =>
      'Cette action est définitive et ne peut pas être annulée. Toutes vos données seront supprimées.';

  @override
  String get accountEnterYourPassword => 'Saisissez votre mot de passe';

  @override
  String get accountDelete => 'Supprimer';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Homme';

  @override
  String get accountGenderFemale => 'Femme';

  @override
  String get accountGenderOther => 'Autre';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Commandes $number';
  }

  @override
  String get accountReorderSuccessful => 'Nouvelle commande réussie';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count articles ont été ajoutés à votre panier.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Aller au panier';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Échec du chargement des détails de la commande';

  @override
  String get accountDetails => 'Détails';

  @override
  String get accountInvoices => 'Factures';

  @override
  String get accountShipments => 'Expéditions';

  @override
  String accountPlacedOn(Object date) {
    return 'Passée le $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count article(s) commandé(s)';
  }

  @override
  String get accountBillingAddress => 'Adresse de facturation';

  @override
  String get accountShippingAddress => 'Adresse de livraison';

  @override
  String get accountShippingMethod => 'Mode de livraison';

  @override
  String get accountPaymentMethod => 'Mode de paiement';

  @override
  String get accountNoInvoicesForOrder => 'Aucune facture pour cette commande';

  @override
  String accountInvoicedCount(int count) {
    return '$count facturé(s)';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'Aucune expédition pour cette commande';

  @override
  String get accountReorder => 'Commander à nouveau';

  @override
  String get accountCancelOrder => 'Annuler la commande';

  @override
  String get accountCancelOrderConfirmation =>
      'Voulez-vous vraiment annuler cette commande ? Cette action est irréversible.';

  @override
  String get accountMoreInfo => 'Plus d\'infos';

  @override
  String get accountOrderedQty => 'Qté commandée';

  @override
  String get accountShipped => 'Expédié';

  @override
  String get accountInvoiced => 'Facturé';

  @override
  String get accountUnitPrice => 'Prix unitaire';

  @override
  String get accountSubTotalWithSpace => 'Sous-total';

  @override
  String get accountTotalPaid => 'Total payé';

  @override
  String get accountTotalRefunded => 'Total remboursé';

  @override
  String get accountTotalDue => 'Total dû';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Facture $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Expédition $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Échec du chargement des détails de la facture';

  @override
  String get accountInvoiceStatus => 'Statut de la facture';

  @override
  String get accountInvoiceDate => 'Date de facture';

  @override
  String get accountOrderId => 'ID de commande';

  @override
  String get accountOrderDate => 'Date de commande';

  @override
  String get accountOrderStatus => 'Statut de la commande';

  @override
  String get accountChannel => 'Canal';

  @override
  String get accountDefault => 'Par défaut';

  @override
  String get accountStatusPaid => 'Payé';

  @override
  String get accountStatusPending => 'En attente';

  @override
  String get accountStatusPendingPayment => 'Paiement en attente';

  @override
  String get accountStatusOverdue => 'En retard';

  @override
  String get accountStatusRefunded => 'Remboursé';

  @override
  String get accountShippedQty => 'Qté expédiée';

  @override
  String get accountInvoicedQty => 'Qté facturée';

  @override
  String get accountUnitPriceWithColon => 'Prix unitaire :';

  @override
  String get accountSubTotalWithColon => 'Sous-total :';

  @override
  String get accountDownloadInvoice => 'Télécharger la facture';

  @override
  String get accountInvoice => 'Facture';

  @override
  String get accountRecentOrders => 'Commandes récentes';

  @override
  String get accountNoRecentOrders => 'Aucune commande récente';

  @override
  String get accountStatusProcessing => 'En cours de traitement';

  @override
  String get accountStatusCompleted => 'Terminée';

  @override
  String get accountStatusCancelled => 'Annulée';

  @override
  String get accountStatusClosed => 'Fermée';

  @override
  String get accountStatusUnknown => 'Inconnu';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Articles de la liste de souhaits ($count)';
  }

  @override
  String get accountNoWishlistItems =>
      'Aucun article dans la liste de souhaits';

  @override
  String get accountDefaultAddresses => 'Adresses par défaut';

  @override
  String get accountNoProductReviewsYet => 'Aucun avis produit pour le moment';

  @override
  String get searchFailedTitle => 'Échec de la recherche';

  @override
  String get searchHint => 'Rechercher des produits';

  @override
  String get searchImageSearch => 'Recherche par image';

  @override
  String get searchRecentSearches => 'Recherches récentes';

  @override
  String get searchClearAll => 'Tout effacer';

  @override
  String get searchTopCategories => 'Catégories principales';

  @override
  String searchResultsFound(int count) {
    return '$count résultats trouvés';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% de réduction';
  }

  @override
  String get searchNoProductsFound => 'Aucun produit trouvé';

  @override
  String get searchTryDifferentTerm =>
      'Essayez avec un autre terme de recherche';

  @override
  String get searchSpeechNotAvailable =>
      'La reconnaissance vocale n\'est pas disponible';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Échec du démarrage de la saisie vocale : $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Autorisation du microphone refusée';

  @override
  String get searchRetake => 'Reprendre';

  @override
  String get searchSearch => 'Rechercher';

  @override
  String get searchTryAgain => 'Réessayer';

  @override
  String get searchRecognizedObjects => 'Objets reconnus';

  @override
  String get searchResult => 'Résultat :';

  @override
  String get searchFailedToCaptureImage => 'Échec de la capture d\'image';

  @override
  String searchProcessing(int progress) {
    return 'Traitement... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Ouverture de la caméra...';

  @override
  String get searchFailedToProcessImage => 'Échec du traitement de l\'image';

  @override
  String get homeRecentlyViewedProducts => 'Produits consultés récemment';

  @override
  String accountItemsCount(int count) {
    return '$count article(s)';
  }

  @override
  String get accountTrack => 'Suivre';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Suivi $trackNumber via $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Transporteur inconnu';

  @override
  String get accountTrackingNumber => 'Numéro de suivi';

  @override
  String accountSkuValue(Object sku) {
    return 'UGS : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Qté expédiée : $qty';
  }
}
