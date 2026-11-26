// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Bagisto Mağazası';

  @override
  String get homeFailedToLoad => 'Ana sayfa yüklenemedi';

  @override
  String get commonUnknownError => 'Bilinmeyen hata';

  @override
  String get commonRetry => 'Tekrar dene';

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
  String get homeFeaturedProducts => 'Öne Çıkan Ürünler';

  @override
  String get homeDefaultProducts => 'Ürünler';

  @override
  String get homeBackToTop => 'Yukarı Dön';

  @override
  String get homeViewCart => 'SEPETİ GÖRÜNTÜLE';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName sepete eklendi';
  }

  @override
  String get homeLoginToManageWishlist =>
      'İstek listesini yönetmek için giriş yapın';

  @override
  String get homeAddedToWishlist => 'İstek listesine eklendi';

  @override
  String get homeRemovedFromWishlist => 'İstek listesinden kaldırıldı';

  @override
  String get homeViewAll => 'Tümünü Gör';

  @override
  String get homeCollections => 'Koleksiyonlar';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return '$categoryName kategorisi';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '%$percent indirim';
  }

  @override
  String get productFailedToLoad => 'Ürün yüklenemedi';

  @override
  String get productNotFound => 'Ürün bulunamadı';

  @override
  String get productDetail => 'Ürün Detayı';

  @override
  String get productDetails => 'Açıklama';

  @override
  String get productShowLess => 'Daha Az Göster';

  @override
  String get productLoadMore => 'Daha Fazla Yükle';

  @override
  String get productMoreInformations => 'Daha Fazla Bilgi';

  @override
  String get productSku => 'SKU';

  @override
  String get productType => 'Tür';

  @override
  String get productBrand => 'Marka';

  @override
  String get productColor => 'Renk';

  @override
  String get productSize => 'Beden';

  @override
  String get productReviews => 'Yorumlar';

  @override
  String get productNoReviewsYet => 'Henüz yorum yok';

  @override
  String productRating(Object count) {
    return '$count puan';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count yorum';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return '$day $month $year tarihinde yayınlandı';
  }

  @override
  String get productReviewSubmitted => 'Yorumunuz gönderildi!';

  @override
  String get productWriteReview => 'Yorum Yaz';

  @override
  String get productPleaseLoginForReviews =>
      'Yorumlarınızı görmek için giriş yapın';

  @override
  String get productLoadMoreReviews => 'Daha Fazla Yorum Yükle';

  @override
  String get productRelatedProduct => 'İlgili Ürünler';

  @override
  String get productUpsellRecommendation =>
      'Beğenebileceğiniz başka ürünler bulduk!';

  @override
  String productDiscountOff(Object percent) {
    return '%$percent indirim';
  }

  @override
  String get productVeryGood => 'Çok iyi';

  @override
  String get productGood => 'İyi';

  @override
  String get productAverage => 'Orta';

  @override
  String get productBad => 'Kötü';

  @override
  String get productVeryBad => 'Çok kötü';

  @override
  String get productInStock => 'Stokta var';

  @override
  String get productOutOfStock => 'Stokta yok';

  @override
  String get productQuantity => 'Adet';

  @override
  String get productWishlistAction => 'İstek Listesi';

  @override
  String get productCompareAction => 'Karşılaştır';

  @override
  String get productShareAction => 'Paylaş';

  @override
  String get productLoginToCompare =>
      'Karşılaştırmaya eklemek için giriş yapın';

  @override
  String get productAddedToCompare => 'Karşılaştırmaya eklendi';

  @override
  String get productAddToCart => 'Sepete Ekle';

  @override
  String get accountMoveToCart => 'Sepete Taşı';

  @override
  String get productBuyNow => 'Şimdi Satın Al';

  @override
  String get productSelectOptionsFirst =>
      'Lütfen önce ürün seçeneklerini seçin';

  @override
  String get productBookingBookTable => 'Masa Rezervasyonu Yap *';

  @override
  String get productBookingSelectDateRequired => 'Tarih seçin *';

  @override
  String get productBookingSelectSlotRequired => 'Zaman aralığı seçin *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Özel İstekler/Notlar *';

  @override
  String get productBookingBookAppointment => 'Randevu Al *';

  @override
  String get productBookingDateFormatHint => 'YYYY-AA-GG';

  @override
  String get productBookingFrom => 'Başlangıç';

  @override
  String get productBookingTo => 'Bitiş';

  @override
  String get productBookingSelectDate => 'Tarih seçin';

  @override
  String get productBookingLocation => 'Konum';

  @override
  String get productBookingSlotDuration => 'Zaman Aralığı Süresi';

  @override
  String get productBookingAvailability => 'Uygunluk';

  @override
  String get productBookingStartDate => 'Başlangıç Tarihi';

  @override
  String get productBookingEndDate => 'Bitiş Tarihi';

  @override
  String get productBookingDate => 'Tarih';

  @override
  String get productBookingViewOnMap => 'Haritada Gör';

  @override
  String get productBookingEventOn => 'Etkinlik tarihi:';

  @override
  String get productBookingBookYourTicket => 'Biletinizi Ayırtın';

  @override
  String get productBookingSlotDurationLabel => 'Zaman Aralığı Süresi:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count dakika';
  }

  @override
  String get productBookingAvailableFrom => 'Başlangıç';

  @override
  String get productBookingAvailableTo => 'Bitiş';

  @override
  String get productBookingSpecialRequestNotesHint => 'Özel İstekler/Notlar';

  @override
  String get productBookingChooseRentOption =>
      'Kiralama Seçeneğini Belirleyin *';

  @override
  String get productBookingDailyBasis => 'Günlük';

  @override
  String get productBookingHourlyBasis => 'Saatlik';

  @override
  String get productBookingNoDatesAvailable =>
      'Rezervasyon için uygun tarih yok';

  @override
  String get productBookingSelectSlot => 'Zaman aralığı seçin';

  @override
  String get productBookingSelectDateFirst => 'Önce tarih seçin';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Uygun zaman aralıklarını görmek için önce tarih seçin.';

  @override
  String get productBookingLoadingSlots => 'Zaman aralıkları yükleniyor...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Seçilen tarih için uygun zaman aralıkları yükleniyor.';

  @override
  String get productBookingUnableToLoadSlots => 'Zaman aralıkları yüklenemedi';

  @override
  String get productBookingNoSlotsAvailable => 'Uygun zaman aralığı yok';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Seçilen tarih için uygun zaman aralığı yok.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Devam etmek için uygun bir zaman aralığı seçin.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Özel istekler/notlar';

  @override
  String get productDownloadableLinks => 'Bağlantılar';

  @override
  String get productDownloadableSamples => 'Örnekler';

  @override
  String get productDownloadSample => 'Örneği indir';

  @override
  String get productDefaultName => 'Ürün';

  @override
  String get categoryDefaultName => 'Kategoriler';

  @override
  String get categorySubCategories => 'Alt Kategoriler';

  @override
  String get categorySomethingWentWrong => 'Bir şeyler yanlış gitti';

  @override
  String get categoryUnknownError => 'Bilinmeyen hata';

  @override
  String categoryItemsFound(Object count) {
    return '$count ürün bulundu';
  }

  @override
  String get categoryNoProductsFound => 'Ürün bulunamadı';

  @override
  String get categoryNoCategoriesFound => 'Kategori bulunamadı';

  @override
  String get categorySort => 'Sırala';

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
  String get categoryFilter => 'Filtrele';

  @override
  String get categoryFilters => 'Filtreler';

  @override
  String get categoryNoFiltersAvailable => 'Filtre mevcut değil';

  @override
  String get categoryFiltersWillAppear =>
      'Bu kategori için mevcut olduğunda filtreler görünecektir';

  @override
  String get categoryApplyFilters => 'Filtreleri uygula';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Filtreleri uygula ($count)';
  }

  @override
  String get categoryClearAll => 'Tümünü temizle';

  @override
  String get categoryTryAdjustingFilters =>
      'Filtrelerinizi veya arama kriterlerinizi değiştirmeyi deneyin';

  @override
  String get categoryError => 'Hata';

  @override
  String get categoryLoginToManageWishlist =>
      'İstek listesini yönetmek için giriş yapın';

  @override
  String get categoryAddedToWishlist => 'İstek listesine eklendi';

  @override
  String get categoryRemovedFromWishlist => 'İstek listesinden kaldırıldı';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'İstek listesi güncellenemedi: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Sepet';

  @override
  String get cartPleaseLoginWishlist =>
      'İstek listesini görmek için giriş yapın';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return 'Sepette $count $itemText';
  }

  @override
  String get cartYourCartEmpty => 'Sepetiniz boş';

  @override
  String get cartAddProductsHere =>
      'Burada görmek için sepetinize ürün ekleyin';

  @override
  String get cartContinueShopping => 'Alışverişe Devam Et';

  @override
  String get cartUnit => 'Birim';

  @override
  String get cartUnits => 'Birim';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'İstek listesine eklemek için giriş yapın';

  @override
  String get cartMovedToWishlist => 'İstek listesine taşındı';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'İstek listesine taşınamadı: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Daha Fazla Gör';

  @override
  String get cartViewLess => 'Daha Az Gör';

  @override
  String get cartEmptyCartAction => 'Sepeti Boşalt';

  @override
  String get cartApplyCoupon => 'Kupon Uygula';

  @override
  String get cartCouponCode => 'Kupon Kodu';

  @override
  String get cartCouponNotFound => 'Coupon not found';

  @override
  String get cartApply => 'Uygula';

  @override
  String get cartAppliedCoupon => 'Kupon uygulandı';

  @override
  String get cartRemove => 'Kaldır';

  @override
  String get cartPriceBreak => 'Fiyat Dökümü';

  @override
  String get cartSubTotal => 'Ara Toplam';

  @override
  String get cartDiscount => 'İndirim';

  @override
  String get cartDeliveryCharges => 'Teslimat Ücreti';

  @override
  String get cartTax => 'Vergi';

  @override
  String get cartTaxIncluded => '(included)';

  @override
  String cartExclTax(String amount) {
    return 'Excl. Tax: $amount';
  }

  @override
  String get cartGrandTotal => 'Genel Toplam';

  @override
  String get cartAmountToBePaid => 'Ödenecek Tutar';

  @override
  String get cartPayNow => 'Şimdi Öde';

  @override
  String get cartRemoveItem => 'Ürünü Kaldır';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return '\"$productName\" ürününü sepetinizden kaldırmak istediğinize emin misiniz?';
  }

  @override
  String get cartCancel => 'İptal';

  @override
  String get cartEmptyCartTitle => 'Sepeti Boşalt';

  @override
  String get cartEmptyCartConfirm =>
      'Sepetinizdeki tüm ürünleri kaldırmak istediğinize emin misiniz?';

  @override
  String get cartEstimateShippingAndTax => 'Estimate Shipping and Tax';

  @override
  String get cartEstimateShippingPrompt =>
      'Enter your destination to get a shipping and tax estimate.';

  @override
  String get cartEstimateCountry => 'Country';

  @override
  String get cartEstimateState => 'State';

  @override
  String get cartEstimateZip => 'Zip/Postcode';

  @override
  String get cartEstimateSelectCountry => 'Select Country';

  @override
  String get cartEstimateSelectState => 'Select State';

  @override
  String get cartEstimateButton => 'Estimate';

  @override
  String get cartEstimateNoMethods =>
      'No shipping methods available for this destination.';

  @override
  String get cartMoreChoices => 'More Choices';

  @override
  String get checkout => 'Ödeme';

  @override
  String get checkoutBillingTo => 'Fatura adresi';

  @override
  String get checkoutDeliveredTo => 'Teslimat adresi';

  @override
  String get checkoutChange => 'Değiştir';

  @override
  String get checkoutSelectBillingAddress => 'Fatura adresi seçin';

  @override
  String get checkoutSelectShippingAddress => 'Teslimat adresi seçin';

  @override
  String get checkoutBillingAddress => 'Fatura Adresi';

  @override
  String get checkoutEnterAddress => 'Adres Girin';

  @override
  String get checkoutFirstName => 'Ad';

  @override
  String get checkoutLastName => 'Soyad';

  @override
  String get checkoutEmail => 'E-posta';

  @override
  String get checkoutPhone => 'Telefon';

  @override
  String get checkoutStreetAddress => 'Sokak Adresi';

  @override
  String get checkoutCountry => 'Ülke';

  @override
  String get checkoutState => 'İl';

  @override
  String get checkoutCity => 'Şehir';

  @override
  String get checkoutPostcode => 'Posta Kodu';

  @override
  String get checkoutCompanyOptional => 'Şirket (İsteğe bağlı)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Teslimat için aynı adres kullanılsın mı?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Telefon: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Ofis';

  @override
  String get checkoutAddressTypeHome => 'Ev';

  @override
  String get checkoutAddressTypeBilling => 'Faturalama';

  @override
  String get checkoutAddressTypeShipping => 'Teslimat';

  @override
  String get checkoutAddressTypeDefault => 'Varsayılan';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field zorunludur';
  }

  @override
  String get checkoutSaveContinue => 'Kaydet ve Devam Et';

  @override
  String get checkoutYourCartEmpty => 'Sepetiniz boş';

  @override
  String get checkoutSelectCountry => 'Ülke Seçin';

  @override
  String get checkoutSelectState => 'İl Seçin';

  @override
  String get checkoutCountryRequired => 'Ülke zorunludur';

  @override
  String get checkoutStateRequired => 'İl zorunludur';

  @override
  String get checkoutSelectCountryFirst => 'Önce ülke seçin';

  @override
  String get checkoutShippingMethod => 'Teslimat Yöntemi';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Teslimat seçeneklerini görmek için adresinizi kaydedin';

  @override
  String get checkoutPaymentMethod => 'Ödeme Yöntemi';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Önce bir teslimat yöntemi seçin';

  @override
  String get checkoutEnterCouponCode => 'Kupon kodunuzu girin';

  @override
  String get checkoutDiscountCoupon => 'İndirim (Kupon)';

  @override
  String get checkoutPlaceOrder => 'Sipariş Ver';

  @override
  String get thankYouTitle => 'Siparişiniz için teşekkür ederiz!';

  @override
  String get thankYouSubtitle =>
      'Sipariş detaylarınızı ve takip bilgilerinizi e-posta ile göndereceğiz';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Sipariş Numaranız $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Siparişi Görüntüle';

  @override
  String get thankYouContinueShopping => 'Alışverişe Devam Et';

  @override
  String get accountPleaseTryAgainLater => 'Lütfen daha sonra tekrar deneyin';

  @override
  String get accountUserFallback => 'Kullanıcı';

  @override
  String get accountBack => 'Geri';

  @override
  String get accountSettings => 'Ayarlar';

  @override
  String get accountMyOrders => 'Siparişlerim';

  @override
  String get accountMyDownloadableProducts => 'İndirilebilir Ürünlerim';

  @override
  String get accountWishlist => 'İstek Listem';

  @override
  String get accountCompareProducts => 'Ürünleri Karşılaştır';

  @override
  String get accountProductReview => 'Ürün Yorumu';

  @override
  String get accountAddressBook => 'Adres Defteri';

  @override
  String get accountEditAccount => 'Hesabı Düzenle';

  @override
  String get accountLogout => 'Çıkış Yap';

  @override
  String get accountLogoutConfirmation =>
      'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get accountNoCountriesAvailable => 'Ülke yok. Lütfen tekrar deneyin.';

  @override
  String get accountPleaseSelectCountry => 'Lütfen bir ülke seçin';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Lütfen bir il seçin veya girin';

  @override
  String get accountAddressUpdatedSuccessfully => 'Adres başarıyla güncellendi';

  @override
  String get accountAddressAddedSuccessfully => 'Adres başarıyla eklendi';

  @override
  String get accountGoBack => 'Geri Git';

  @override
  String get accountEditAddress => 'Adresi Düzenle';

  @override
  String get accountAddNewAddress => 'Yeni Adres Ekle';

  @override
  String get accountFirstNameRequired => 'Ad zorunludur';

  @override
  String get accountLastNameRequired => 'Soyad zorunludur';

  @override
  String get accountEnterValidEmail => 'Geçerli bir e-posta girin';

  @override
  String get accountCompanyName => 'Şirket Adı';

  @override
  String get accountVatId => 'Vergi No';

  @override
  String get accountStreetAddressRequired => 'Sokak adresi zorunludur';

  @override
  String get accountCityRequired => 'Şehir zorunludur';

  @override
  String get accountZipPostcode => 'Posta Kodu';

  @override
  String get accountZipPostcodeRequired => 'Posta kodu zorunludur';

  @override
  String get accountTelephone => 'Telefon';

  @override
  String get accountPhoneNumberRequired => 'Telefon numarası zorunludur';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Varsayılan fatura adresini değiştir';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Varsayılan teslimat adresini değiştir';

  @override
  String get accountUpdateAddress => 'Adresi Güncelle';

  @override
  String get accountSaveToAddressBook => 'Adres Defterine Kaydet';

  @override
  String get accountPleaseLoginToWriteReview => 'Yorum yazmak için giriş yapın';

  @override
  String get accountPleaseSelectRating => 'Lütfen bir puan seçin';

  @override
  String get accountAddReview => 'Yorum Ekle';

  @override
  String get accountReviewSubmitted => 'Yorum gönderildi!';

  @override
  String get accountNickName => 'İsim';

  @override
  String get accountEnterYourName => 'Adınızı girin';

  @override
  String get accountNameRequired => 'Ad zorunludur';

  @override
  String get accountSummary => 'Başlık';

  @override
  String get accountReviewSummaryHint => 'Başlık';

  @override
  String get accountSummaryRequired => 'Başlık zorunludur';

  @override
  String get accountReview => 'Yorum';

  @override
  String get accountDetailedReviewHint => 'Yorum';

  @override
  String get accountReviewRequired => 'Yorum zorunludur';

  @override
  String get accountRating => 'Puan';

  @override
  String get accountSubmitReview => 'Yorumu Gönder';

  @override
  String get accountReviewAttachmentsLabel => 'Görsel/video ekle';

  @override
  String get accountReviewAddMedia => 'Ekle';

  @override
  String get accountReviewTakePhoto => 'Fotoğraf Çek';

  @override
  String get accountReviewChooseFromGallery => 'Galeriden Seç';

  @override
  String get accountReviewChooseVideo => 'Video Seç';

  @override
  String get accountReviewRemoveAttachment => 'Eki Kaldır';

  @override
  String get accountReviewAttachmentLimitReached =>
      'En fazla 5 dosya ekleyebilirsiniz';

  @override
  String get accountReviewAttachmentTooLarge => 'Dosya çok büyük (maks. 5 MB)';

  @override
  String get accountCouldNotLoadAddresses => 'Adresler yüklenemedi';

  @override
  String get accountPleaseTryAgain => 'Lütfen tekrar deneyin';

  @override
  String get accountNoAddressesSaved => 'Kayıtlı adres yok';

  @override
  String get accountAddAddressToGetStarted =>
      'Başlamak için yeni bir adres ekleyin';

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
  String get accountNoProductsToCompare => 'Karşılaştırılacak ürün yok';

  @override
  String get accountAddProductsToCompareHint =>
      'Ürün detay sayfasından karşılaştırmak için ürün ekleyin.';

  @override
  String get accountProducts => 'Ürünler';

  @override
  String get accountDescription => 'Açıklama';

  @override
  String get accountShortDescription => 'Kısa Açıklama';

  @override
  String get accountActivity => 'Etkinlik';

  @override
  String get accountStore => 'Mağaza';

  @override
  String get accountNotAvailable => 'Yok';

  @override
  String get accountMessageSentSuccessfully => 'Mesaj başarıyla gönderildi!';

  @override
  String get accountAnErrorOccurred => 'Bir hata oluştu';

  @override
  String get accountContactUs => 'Bize Ulaşın';

  @override
  String get accountName => 'Ad';

  @override
  String get accountEnterYourEmail => 'E-postanızı girin';

  @override
  String get accountContact => 'İletişim';

  @override
  String get accountEnterYourPhoneNumber => 'Telefon numaranızı girin';

  @override
  String get accountMessage => 'Mesaj';

  @override
  String get accountEnterYourMessage => 'Mesajınızı girin';

  @override
  String get accountSendMessage => 'Mesaj Gönder';

  @override
  String get accountNameFieldEmpty => 'Ad alanı boş bırakılamaz';

  @override
  String get accountNameMinChars => 'Ad en az 2 karakter olmalıdır';

  @override
  String get accountEmailFieldEmpty => 'E-posta alanı boş bırakılamaz';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Lütfen geçerli bir e-posta adresi girin';

  @override
  String get accountContactNumberEmpty => 'İletişim numarası boş bırakılamaz';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Lütfen geçerli bir iletişim numarası girin';

  @override
  String get accountMessageFieldEmpty => 'Mesaj alanı boş bırakılamaz';

  @override
  String get accountMessageMinChars => 'Mesaj en az 10 karakter olmalıdır';

  @override
  String get accountDownloadableProducts => 'İndirilebilir Ürünler';

  @override
  String get accountNoDownloadsYet => 'Henüz indirme yok';

  @override
  String get accountDownloadsEmptyDescription =>
      'İndirdiğiniz ürünler burada görünecek.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total Ürün';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value kaldı';
  }

  @override
  String get accountDownload => 'İndir';

  @override
  String accountFileName(Object fileName) {
    return 'Dosya: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'İndirmeniz kısa süre içinde başlayacak. İndirilenler klasörünü kontrol edin.';

  @override
  String get accountClose => 'Kapat';

  @override
  String get accountOrders => 'Siparişler';

  @override
  String get accountNoOrdersYet => 'Henüz sipariş yok';

  @override
  String get accountOrdersEmptyDescription =>
      'Bir satın alma yaptığınızda siparişleriniz burada görünecek.';

  @override
  String get accountOrderSingular => 'Sipariş';

  @override
  String get accountOrderPlural => 'Siparişler';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Ürün $count)';
  }

  @override
  String get accountOrderAndReturn => 'Sipariş ve İade';

  @override
  String get accountTrackOrder => 'Siparişi Takip Et';

  @override
  String get accountReturnPolicy => 'İade Politikası';

  @override
  String get accountReturnRequest => 'İade Talebi';

  @override
  String get accountNotifications => 'Bildirimler';

  @override
  String get accountPrivacy => 'Gizlilik';

  @override
  String get accountAccount => 'Hesap';

  @override
  String get accountPreferences => 'Tercihler';

  @override
  String get accountLanguage => 'Dil';

  @override
  String get accountNoLanguagesAvailable => 'Dil yok';

  @override
  String get accountCurrency => 'Para Birimi';

  @override
  String get accountOthers => 'Diğer';

  @override
  String get accountNoPagesAvailable => 'Sayfa yok';

  @override
  String get accountProductReviews => 'Ürün Yorumları';

  @override
  String get accountMyReviews => 'Yorumlarım';

  @override
  String get accountNoReviewsYet => 'Henüz yorum yok';

  @override
  String get accountReviewsEmptyDescription =>
      'Ürün yorumlarınız burada görünecek.';

  @override
  String get accountReviewSingular => 'Yorum';

  @override
  String get accountReviewPlural => 'Yorumlar';

  @override
  String accountPostedOn(Object date) {
    return '$date tarihinde yayınlandı';
  }

  @override
  String get accountCloseSettings => 'Ayarları kapat';

  @override
  String get accountChangeTheme => 'Temayı Değiştir';

  @override
  String get accountAllNotifications => 'Tüm Bildirimler';

  @override
  String get accountOffers => 'Fırsatlar';

  @override
  String get accountOfflineData => 'Çevrimdışı Veriler';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Son görüntülenen ürünleri takip et ve göster';

  @override
  String get accountShowSearchTag => 'Arama Etiketini Göster';

  @override
  String get accountTryAgain => 'Tekrar Dene';

  @override
  String get accountYourWishlistEmpty => 'İstek listeniz boş';

  @override
  String get accountWishlistEmptyDescription =>
      'Ürünlere göz atın ve istek listenize ekleyin';

  @override
  String get accountItemSingular => 'Ürün';

  @override
  String get accountItemPlural => 'Ürünler';

  @override
  String accountStartingAt(Object price) {
    return '$price fiyatından başlayan';
  }

  @override
  String get accountAboutThisPage => 'Bu sayfa hakkında';

  @override
  String accountPageId(Object id) {
    return 'Sayfa ID: $id';
  }

  @override
  String get mainTabHome => 'Ana Sayfa';

  @override
  String get mainTabCategories => 'Kategoriler';

  @override
  String get mainTabCart => 'Sepet';

  @override
  String get mainTabAccount => 'Hesap';

  @override
  String get authLoginSuccess => 'Hoş geldiniz! Başarıyla giriş yapıldı.';

  @override
  String get authWelcomeBack => 'Tekrar hoş geldiniz!';

  @override
  String get authLoginToAccount => 'Hesabınıza giriş yapın';

  @override
  String get authEmailAddress => 'E-posta Adresi';

  @override
  String get authEnterYourEmail => 'E-postanızı girin';

  @override
  String get authPleaseEnterEmail => 'Lütfen e-postanızı girin';

  @override
  String get authPleaseEnterValidEmail => 'Lütfen geçerli bir e-posta girin';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authEnterYourPassword => 'Şifrenizi girin';

  @override
  String get authPleaseEnterPassword => 'Lütfen şifrenizi girin';

  @override
  String get authPasswordMinLength => 'Şifre en az 6 karakter olmalıdır';

  @override
  String get authForgotPasswordTitle => 'Şifrenizi mi unuttunuz?';

  @override
  String get authLogin => 'Giriş Yap';

  @override
  String get authNoAccountPrompt => 'Hesabınız yok mu? ';

  @override
  String get authSignUp => 'Kayıt Ol';

  @override
  String get authAccountCreatedSuccess => 'Hesap başarıyla oluşturuldu!';

  @override
  String get authCreateAccount => 'Hesap Oluştur';

  @override
  String get authSignupGetStarted => 'Başlamak için kaydolun';

  @override
  String get authFirstNameHint => 'Ad';

  @override
  String get authLastNameHint => 'Soyad';

  @override
  String get authRequired => 'Zorunlu';

  @override
  String get authCreatePasswordHint => 'Bir şifre oluşturun';

  @override
  String get authConfirmPassword => 'Şifreyi Onayla';

  @override
  String get authConfirmPasswordHint => 'Şifrenizi onaylayın';

  @override
  String get authPleaseConfirmPassword => 'Lütfen şifrenizi onaylayın';

  @override
  String get authPasswordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get authAlreadyHaveAccountPrompt => 'Zaten bir hesabınız var mı? ';

  @override
  String get authForgotPasswordSubtitle =>
      'E-posta adresinizi girin, size şifrenizi sıfırlamanız için bir bağlantı gönderelim.';

  @override
  String get authSendResetLink => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get authBackToLogin => 'Girişe Dön';

  @override
  String get authNiceToSeeYouHere => 'Sizi burada görmek güzel';

  @override
  String get accountEditTitle => 'Hesabı Düzenle';

  @override
  String get accountFirstNameRequiredLabel => 'Ad *';

  @override
  String get accountLastNameRequiredLabel => 'Soyad *';

  @override
  String get accountChangeEmail => 'E-postayı Değiştir';

  @override
  String get accountChangePassword => 'Şifreyi Değiştir';

  @override
  String get accountDeleteAccount => 'Hesabı Sil';

  @override
  String get accountGender => 'Cinsiyet';

  @override
  String get accountSelectGender => 'Cinsiyet Seçin';

  @override
  String get accountDob => 'Doğum Tarihi';

  @override
  String get monthJanShort => 'Oca';

  @override
  String get monthFebShort => 'Şub';

  @override
  String get monthMarShort => 'Mar';

  @override
  String get monthAprShort => 'Nis';

  @override
  String get monthMayShort => 'May';

  @override
  String get monthJunShort => 'Haz';

  @override
  String get monthJulShort => 'Tem';

  @override
  String get monthAugShort => 'Ağu';

  @override
  String get monthSepShort => 'Eyl';

  @override
  String get monthOctShort => 'Eki';

  @override
  String get monthNovShort => 'Kas';

  @override
  String get monthDecShort => 'Ara';

  @override
  String get accountSubscribeNewsletters => 'Bültenlere abone ol';

  @override
  String get accountSaveProfile => 'Profili Kaydet';

  @override
  String get accountNewEmail => 'Yeni E-posta';

  @override
  String get accountEmailRequired => 'E-posta zorunludur';

  @override
  String get accountCurrentPassword => 'Mevcut Şifre';

  @override
  String get accountPasswordRequired => 'Şifre zorunludur';

  @override
  String get accountChange => 'Değiştir';

  @override
  String get accountCurrentPasswordRequired => 'Mevcut şifre zorunludur';

  @override
  String get accountNewPassword => 'Yeni Şifre';

  @override
  String get accountConfirmPassword => 'Şifreyi Onayla';

  @override
  String get accountDeleteWarning =>
      'Bu işlem kalıcıdır ve geri alınamaz. Tüm verileriniz silinecektir.';

  @override
  String get accountEnterYourPassword => 'Şifrenizi girin';

  @override
  String get accountDelete => 'Sil';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Erkek';

  @override
  String get accountGenderFemale => 'Kadın';

  @override
  String get accountGenderOther => 'Diğer';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Siparişler $number';
  }

  @override
  String get accountReorderSuccessful => 'Tekrar sipariş başarılı';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count ürün sepetinize eklendi.';
  }

  @override
  String get accountOk => 'Tamam';

  @override
  String get accountGoToCart => 'Sepete Git';

  @override
  String get accountFailedToLoadOrderDetails => 'Sipariş detayları yüklenemedi';

  @override
  String get accountDetails => 'Detaylar';

  @override
  String get accountInvoices => 'Faturalar';

  @override
  String get accountShipments => 'Gönderiler';

  @override
  String get accountRefunds => 'İadeler';

  @override
  String get accountRefundSubtotal => 'Subtotal';

  @override
  String get accountRefundedQty => 'İade edilen adet';

  @override
  String get accountShippingAndHandling => 'Kargo ve işlem';

  @override
  String get accountAdjustmentRefund => 'Adjustment Refund';

  @override
  String get accountAdjustmentFee => 'Adjustment Fee';

  @override
  String accountPlacedOn(Object date) {
    return '$date tarihinde verildi';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count ürün sipariş edildi';
  }

  @override
  String get accountBillingAddress => 'Fatura Adresi';

  @override
  String get accountShippingAddress => 'Teslimat Adresi';

  @override
  String get accountShippingMethod => 'Teslimat Yöntemi';

  @override
  String get accountPaymentMethod => 'Ödeme Yöntemi';

  @override
  String get accountNoInvoicesForOrder => 'Bu sipariş için fatura yok';

  @override
  String accountInvoicedCount(int count) {
    return '$count faturalandı';
  }

  @override
  String get accountNoShipmentsForOrder => 'Bu sipariş için gönderi yok';

  @override
  String get accountReorder => 'Tekrar Sipariş Ver';

  @override
  String get accountMoreInfo => 'Daha fazla bilgi';

  @override
  String get accountOrderedQty => 'Sipariş Adedi';

  @override
  String get accountShipped => 'Gönderildi';

  @override
  String get accountInvoiced => 'Faturalandı';

  @override
  String get accountUnitPrice => 'Birim Fiyat';

  @override
  String get accountSubTotalWithSpace => 'Ara Toplam';

  @override
  String get accountTotalPaid => 'Toplam Ödenen';

  @override
  String get accountTotalRefunded => 'Toplam İade';

  @override
  String get accountTotalDue => 'Toplam Borç';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Fatura $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Gönderi $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Fatura detayları yüklenemedi';

  @override
  String get accountInvoiceStatus => 'Fatura Durumu';

  @override
  String get accountInvoiceDate => 'Fatura Tarihi';

  @override
  String get accountOrderId => 'Sipariş ID';

  @override
  String get accountOrderDate => 'Sipariş Tarihi';

  @override
  String get accountOrderStatus => 'Sipariş Durumu';

  @override
  String get accountChannel => 'Kanal';

  @override
  String get accountDefault => 'Varsayılan';

  @override
  String get accountStatusPaid => 'Ödendi';

  @override
  String get accountStatusPending => 'Beklemede';

  @override
  String get accountStatusPendingPayment => 'Ödeme Bekleniyor';

  @override
  String get accountStatusOverdue => 'Süresi Geçti';

  @override
  String get accountStatusRefunded => 'İade Edildi';

  @override
  String get accountShippedQty => 'Gönderilen Adet';

  @override
  String get accountInvoicedQty => 'Faturalanan Adet';

  @override
  String get accountUnitPriceWithColon => 'Birim Fiyat:';

  @override
  String get accountSubTotalWithColon => 'Ara Toplam:';

  @override
  String get accountDownloadInvoice => 'Faturayı İndir';

  @override
  String get accountInvoice => 'Fatura';

  @override
  String get accountRecentOrders => 'Son Siparişler';

  @override
  String get accountNoRecentOrders => 'Son sipariş yok';

  @override
  String get accountStatusProcessing => 'İşleniyor';

  @override
  String get accountStatusCompleted => 'Tamamlandı';

  @override
  String get accountStatusCancelled => 'İptal Edildi';

  @override
  String get accountStatusClosed => 'Kapalı';

  @override
  String get accountStatusUnknown => 'Bilinmiyor';

  @override
  String accountWishlistItemsCount(int count) {
    return 'İstek Listesi Ürünleri ($count)';
  }

  @override
  String get accountNoWishlistItems => 'İstek listesinde ürün yok';

  @override
  String get accountDefaultAddresses => 'Varsayılan Adresler';

  @override
  String get accountNoProductReviewsYet => 'Henüz ürün yorumu yok';

  @override
  String get searchFailedTitle => 'Arama başarısız';

  @override
  String get searchHint => 'Ürün ara';

  @override
  String get searchImageSearch => 'Görselle Ara';

  @override
  String get searchRecentSearches => 'Son Aramalar';

  @override
  String get searchClearAll => 'Tümünü Temizle';

  @override
  String get searchTopCategories => 'Öne Çıkan Kategoriler';

  @override
  String searchResultsFound(int count) {
    return '$count sonuç bulundu';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '%$percent indirim';
  }

  @override
  String get searchNoProductsFound => 'Ürün bulunamadı';

  @override
  String get searchTryDifferentTerm => 'Farklı bir terimle aramayı deneyin';

  @override
  String get searchSpeechNotAvailable => 'Sesli tanıma kullanılamıyor';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Sesli giriş başlatılamadı: $error';
  }

  @override
  String get searchMicrophonePermissionDenied => 'Mikrofon izni reddedildi';

  @override
  String get searchRetake => 'Yeniden çek';

  @override
  String get searchSearch => 'Ara';

  @override
  String get searchTryAgain => 'Tekrar dene';

  @override
  String get searchRecognizedObjects => 'Tanınan Nesneler';

  @override
  String get searchResult => 'Sonuç:';

  @override
  String get searchFailedToCaptureImage => 'Görüntü yakalanamadı';

  @override
  String searchProcessing(int progress) {
    return 'İşleniyor... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Kamera açılıyor...';

  @override
  String get searchFailedToProcessImage => 'Görüntü işlenemedi';

  @override
  String get homeRecentlyViewedProducts => 'Son görüntülenen ürünler';

  @override
  String get homeNewsletterHeadline => 'Get Ready for our Fun Newsletter!';

  @override
  String get homeNewsletterSubtitle => 'Subscribe to stay in touch.';

  @override
  String get homeNewsletterEmailHint => 'email@example.com';

  @override
  String get homeNewsletterSubscribeAction => 'Subscribe';

  @override
  String get homeNewsletterEmailRequired => 'Please enter your email';

  @override
  String get homeNewsletterEmailInvalid => 'Please enter a valid email address';

  @override
  String get homeNewsletterSubscribed =>
      'You have successfully subscribed to our newsletter.';

  @override
  String get homeNewsletterAlreadySubscribed =>
      'You are already subscribed to our newsletter.';

  @override
  String get homeNewsletterGenericError =>
      'Something went wrong. Please try again.';

  @override
  String accountItemsCount(int count) {
    return '$count ürün';
  }

  @override
  String get accountTrack => 'Takip Et';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return '$carrier ile $trackNumber takip';
  }

  @override
  String get accountUnknownCarrier => 'Bilinmeyen kargo';

  @override
  String get accountTrackingNumber => 'Takip Numarası';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Gönderilen Adet : $qty';
  }

  @override
  String get storefrontBrowseAction => 'Just browsing? Shop our stores';

  @override
  String get storefrontShoppingHeading => 'Shopping';

  @override
  String get storefrontBrowseBlurb => 'Find shops and see what they sell';

  @override
  String get storefrontMessagesBlurb => 'Your conversations with shops';

  @override
  String get storefrontTrustFreeShippingTitle => 'Free Shipping';

  @override
  String get storefrontTrustFreeShippingBlurb =>
      'Enjoy free shipping on all orders';

  @override
  String get storefrontTrustReplaceTitle => 'Product Replace';

  @override
  String get storefrontTrustReplaceBlurb =>
      'Easy Product Replacement Available!';

  @override
  String get storefrontTrustEmiTitle => 'EMI Available';

  @override
  String get storefrontTrustEmiBlurb =>
      'No cost EMI available on all major credit cards';

  @override
  String get storefrontTrustSupportTitle => '24/7 Support';

  @override
  String get storefrontTrustSupportBlurb =>
      'Dedicated 24/7 support via chat and email';

  @override
  String get shopSoldBy => 'Sold By';

  @override
  String get shopSoldByReport => 'Report Product';

  @override
  String get shopReportLoginAlertTitle => 'Alert';

  @override
  String get shopReportLoginRequired =>
      'You need to login to report this product';

  @override
  String get shopReportLoginDisagree => 'Disagree';

  @override
  String get shopReportLoginAgree => 'Agree';

  @override
  String shopSoldByOtherStores(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count other shops',
      one: '1 other shop',
    );
    return '$_temp0';
  }

  @override
  String shopProductMoreStores(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aynı ürünü satan $count mağaza daha var',
      one: 'Aynı ürünü satan 1 mağaza daha var',
    );
    return '$_temp0';
  }

  @override
  String get shopSoldByReported => 'Reported. Our team will look into it.';

  @override
  String shopSoldByReviews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }

  @override
  String get storefrontFeaturedShopsTitle => 'Our Featured Shops';

  @override
  String get storefrontFeaturedShopsSubtitle =>
      'Discover popular shops and their products.';

  @override
  String get shopStoresMenu => 'Browse shops';

  @override
  String get shopStoresTitle => 'Shops';

  @override
  String get shopStoresSearchHint => 'Search shops';

  @override
  String get shopStoresEmpty => 'No shops found';

  @override
  String get shopStoreLinkFailed => 'That link could not be opened';

  @override
  String get shopStoreProducts => 'Products';

  @override
  String get shopStoreReviews => 'Reviews';

  @override
  String get shopStoreAbout => 'About';

  @override
  String get shopStorePolicies => 'Policies';

  @override
  String get shopStoreReturnPolicy => 'Returns';

  @override
  String get shopStoreShippingPolicy => 'Shipping';

  @override
  String get shopStorePrivacyPolicy => 'Privacy';

  @override
  String get shopStoreContact => 'Contact this shop';

  @override
  String get shopStoreReport => 'Report this shop';

  @override
  String get shopStoreWriteReview => 'Write a review';

  @override
  String get shopStoreNoReviews => 'No reviews yet';

  @override
  String get shopStoreNoProducts => 'Nothing for sale right now';

  @override
  String shopStoreSince(String date) {
    return 'Shop open since $date';
  }

  @override
  String shopStoreOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String get shopOffersTitle => 'Other shops';

  @override
  String get shopOffersEmpty => 'No other shops offer this';

  @override
  String get shopOffersBest => 'Best price';

  @override
  String get shopOffersConditionNew => 'New';

  @override
  String get shopOffersConditionUsed => 'Used';

  @override
  String get shopOffersUnavailable => 'Out of stock';

  @override
  String get shopMessagesMenu => 'Communication';

  @override
  String get shopMessagesTitle => 'Communications';

  @override
  String get shopMessagesSignIn =>
      'Sign in to see your conversations with shops';

  @override
  String get shopReturnsMenu => 'Returns & Cancellations';

  @override
  String get shopReturnsTitle => 'Returns & Cancellations';

  @override
  String get shopReturnsSignIn => 'Sign in to see your returns';

  @override
  String get shopReturnsEmpty => 'You have not asked to return anything yet';

  @override
  String get shopReturnsRetry => 'Try again';

  @override
  String get shopReturnsLoadMore => 'Show more';

  @override
  String get shopReturnsLoading => 'Loading…';

  @override
  String get shopReturnsFilterAll => 'All';

  @override
  String shopReturnsRequestNumber(Object id) {
    return 'Request #$id';
  }

  @override
  String shopReturnsOrderNumber(Object number) {
    return 'Order $number';
  }

  @override
  String shopReturnsQuantity(Object count) {
    return 'Qty $count';
  }

  @override
  String shopReturnsMessageCount(Object count) {
    return '$count message(s)';
  }

  @override
  String get shopReturnsNew => 'Request a return';

  @override
  String get shopReturnsViewAction => 'View';

  @override
  String get shopReturnsCancelAction => 'Cancel request';

  @override
  String get shopReturnsCancelled => 'Request withdrawn';

  @override
  String get shopReturnAttachments => 'Photos you sent';

  @override
  String get shopReturnAttachment => 'Attachment';

  @override
  String get shopReturnDetailTitle => 'Return request';

  @override
  String get shopReturnItem => 'Item';

  @override
  String get shopReturnReason => 'Reason';

  @override
  String get shopReturnResolution => 'You asked for';

  @override
  String get shopReturnResolutionReturn => 'A refund';

  @override
  String get shopReturnResolutionCancel => 'The item cancelled';

  @override
  String get shopReturnPackage => 'Package';

  @override
  String get shopReturnInformation => 'What you told us';

  @override
  String get shopReturnRaised => 'Raised';

  @override
  String get shopReturnExpired => 'The window for this request has closed';

  @override
  String get shopReturnActionCancel => 'Withdraw request';

  @override
  String get shopReturnActionClose => 'Close request';

  @override
  String get shopReturnActionReopen => 'Ask again';

  @override
  String get shopReturnConfirmCancel =>
      'Withdraw this request? The shop will no longer see it.';

  @override
  String get shopReturnConfirmClose =>
      'Close this request? It cannot be continued afterwards.';

  @override
  String get shopReturnConfirmKeep => 'Keep it';

  @override
  String get shopReturnConfirmProceed => 'Yes, go ahead';

  @override
  String get shopReturnThread => 'Messages';

  @override
  String get shopReturnThreadEmpty => 'No messages on this request yet';

  @override
  String get shopReturnMessageHint => 'Write a message';

  @override
  String get shopReturnMessageSend => 'Send';

  @override
  String get shopReturnFromStore => 'Store';

  @override
  String get shopReturnFromYou => 'You';

  @override
  String get shopReturnNewTitle => 'Request a return';

  @override
  String get shopReturnNewResolution => 'What would you like?';

  @override
  String get shopReturnNewItem => 'Which item?';

  @override
  String get shopReturnNewQuantity => 'How many?';

  @override
  String get shopReturnNewReason => 'Why?';

  @override
  String get shopReturnNewPackage => 'Package condition';

  @override
  String get shopReturnNewPackageOpen => 'Opened';

  @override
  String get shopReturnNewPackagePacked => 'Still packed';

  @override
  String get shopReturnNewInformation => 'Anything else we should know?';

  @override
  String get shopReturnNewAgreement => 'I have read the return policy';

  @override
  String get shopReturnNewSubmit => 'Send request';

  @override
  String get shopReturnNewNothing =>
      'Nothing on this order can be returned. The store sets what is eligible and for how long.';

  @override
  String get shopReturnNewNeedsItem => 'Pick the item you want to send back';

  @override
  String get shopReturnNewNeedsReason => 'Pick a reason';

  @override
  String get shopReturnNewNeedsAgreement => 'Please accept the return policy';

  @override
  String get shopReturnCreated => 'Return request sent';

  @override
  String get shopMessagesEmpty => 'No conversations yet';

  @override
  String get shopMessagesBlocked => 'This shop has turned off replies.';

  @override
  String get shopMessagesSend => 'Send';

  @override
  String get shopMessagesHint => 'Write a message';

  @override
  String get shopContactNameLabel => 'Name';

  @override
  String get shopContactEmailLabel => 'Email';

  @override
  String get shopContactSubjectLabel => 'Subject';

  @override
  String get shopContactQueryLabel => 'Query';

  @override
  String get shopContactNameRequired => 'The name field is required';

  @override
  String get shopContactEmailRequired => 'The email field is required';

  @override
  String get shopContactSubjectRequired => 'The subject field is required';

  @override
  String get shopContactQueryRequired => 'The query field is required';

  @override
  String get shopReportReason => 'Why are you reporting this?';

  @override
  String get shopReportSubmit => 'Report';

  @override
  String get shopReviewRating => 'Your rating';

  @override
  String get shopReviewTitle => 'Title';

  @override
  String get shopReviewComment => 'Your review';

  @override
  String get shopReviewNeedsTitle => 'Give your review a title';

  @override
  String get shopContactNeedsMessage => 'Write your message first';

  @override
  String get shopReviewSubmit => 'Post review';

  @override
  String get accountMyReturns => 'RMA';

  @override
  String get accountReturns => 'RMA';

  @override
  String get accountReturnSingular => 'İade';

  @override
  String get accountReturnPlural => 'İadeler';

  @override
  String get accountNoReturnsYet => 'Henüz iade yok';

  @override
  String get accountReturnsEmptyDescription =>
      'İade talepleriniz burada görünecek.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'İade $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Sipariş $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Adet: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Maks.: $count';
  }

  @override
  String get accountReturnResolution => 'Çözüm';

  @override
  String get accountReturnResolutionReturn => 'İade';

  @override
  String get accountReturnResolutionCancel => 'Ürünleri iptal et';

  @override
  String get accountReturnReason => 'Neden';

  @override
  String get accountReturnSelectReason => 'Bir neden seçin';

  @override
  String get accountReturnPackageCondition => 'Paket durumu';

  @override
  String get accountReturnPackageConditionHint =>
      'örn. açılmış, kapalı, kutu hasarlı';

  @override
  String get accountReturnAdditionalInfo => 'Ek bilgi';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Sorunu açıklayın (isteğe bağlı)';

  @override
  String get accountReturnEvidenceImages => 'Resimler';

  @override
  String get accountReturnAddImages => 'Görsel Ekle';

  @override
  String get accountReturnAgreement =>
      'İade politikası şartlarını kabul ediyorum';

  @override
  String get accountReturnAgreementRequired =>
      'Lütfen iade politikası şartlarını kabul edin';

  @override
  String get accountReturnSubmit => 'Talebi gönder';

  @override
  String get accountReturnCreatedTitle => 'Talep gönderildi';

  @override
  String get accountReturnCreatedMessage =>
      'İade talebiniz başarıyla gönderildi.';

  @override
  String get accountReturnSelectItem => 'Ürün seçin';

  @override
  String get accountReturnNoReturnableItems => 'İade edilebilir ürün yok';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Bu siparişte iade veya iptal için uygun ürün bulunmuyor.';

  @override
  String get accountReturnViewAction => 'Görüntüle';

  @override
  String get accountReturnCancelAction => 'Talebi iptal et';

  @override
  String get accountReturnCloseAction => 'Çözüldü olarak işaretle';

  @override
  String get accountReturnReopenAction => 'Talebi yeniden aç';

  @override
  String get accountReturnCancelConfirmation =>
      'Bu iade talebini iptal etmek istediğinizden emin misiniz?';

  @override
  String get accountReturnCloseConfirmation =>
      'Bu iade talebi çözüldü olarak işaretlensin mi?';

  @override
  String get accountReturnMessages => 'Mesajlar';

  @override
  String get accountReturnNoMessages => 'Henüz mesaj yok.';

  @override
  String get accountReturnMessageHint => 'Mesaj yazın…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'İade durumu $status olarak güncellendi';
  }

  @override
  String get accountReturnExpired => 'İade süresi doldu';

  @override
  String get accountReturnInformation => 'Bilgi';

  @override
  String get accountReturnSelectOrder => 'Bir sipariş seçin';

  @override
  String get accountReturnChangeOrder => 'Değiştir';

  @override
  String get accountReturnChooseAnotherOrder => 'Başka bir sipariş seç';

  @override
  String get accountCancelOrder => 'Siparişi İptal Et';

  @override
  String get accountCancelOrderConfirmation =>
      'Bu siparişi iptal etmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get accountReviewPhotosVideos => 'Fotoğraflar ve Videolar';

  @override
  String get accountReviewGallery => 'Galeri';

  @override
  String get accountReviewCamera => 'Kamera';

  @override
  String accountReviewMaxFiles(int count) {
    return 'En fazla $count dosya ekleyebilirsiniz';
  }

  @override
  String get accountReviewFileTooLarge => 'Her dosya en fazla 5 MB olmalıdır';

  @override
  String get accountReviewUnsupportedFile =>
      'Yalnızca resimler ve videolar desteklenir';

  @override
  String get accountReviewPickFailed =>
      'Medya eklenemedi. Lütfen tekrar deneyin';

  @override
  String get accountReviewVideoLoadFailed => 'Bu video oynatılamıyor';

  @override
  String accountShippedCount(int count) {
    return '$count gönderildi';
  }

  @override
  String get accountReturnNoEligibleOrders =>
      'Şu anda iade için uygun sipariş yok';

  @override
  String get accountRequestReturn => 'İade talep et';

  @override
  String get accountRefundBreakdown => 'İade dökümü';

  @override
  String get accountSubtotalRefunded => 'İade edilen ara toplam';

  @override
  String get accountShippingRefunded => 'İade edilen kargo';

  @override
  String get accountTaxRefunded => 'İade edilen vergi';

  @override
  String get accountDiscountRefunded => 'İade edilen indirim';

  @override
  String get accountRefunded => 'İade edildi';

  @override
  String get accountCanceledQty => 'İptal edildi';

  @override
  String get productBookingCancellation => 'İptal';

  @override
  String get productBookingCancellationNotAllowed => 'İptale izin verilmez';

  @override
  String get accountBookingItemsNotCanceled =>
      'Bu siparişteki rezervasyon ürünleri iptal edilmeyecek.';

  @override
  String cartQtyValue(int count) {
    return 'Adet: $count';
  }

  @override
  String get checkoutAccountSuspended =>
      'Hesabınız askıya alındı. Mağazaya göz atabilirsiniz ancak sipariş veremezsiniz.';

  @override
  String get accountGenderRequiredLabel => 'Cinsiyet *';

  @override
  String get accountGenderRequired => 'Cinsiyet gerekli';

  @override
  String get accountPhoneRequiredLabel => 'Telefon *';

  @override
  String get cartGuestCheckoutNotAllowed =>
      'Bu ürünleri satın almak için lütfen giriş yapın.';

  @override
  String get accountEuWithdraw => 'Sözleşmeden cayma';

  @override
  String get accountEuWithdrawGuestTitle => 'Sözleşmenizden cayın';

  @override
  String get accountEuWithdrawReason => 'Neden (isteğe bağlı)';

  @override
  String get accountEuWithdrawSubmit => 'Cayma bağlantısını bana gönder';

  @override
  String get accountEuWithdrawSubmitted =>
      'Eşleşen bir sipariş varsa cayma bağlantısını bu adrese az önce gönderdik. Bağlantı 24 saat geçerlidir.';

  @override
  String accountEuWithdrawStatus(String status) {
    return 'Cayma talebi: $status';
  }

  @override
  String get accountEuWithdrawGuestDescription =>
      'Sipariş numarasını ve ödeme sırasında kullandığınız e-posta adresini girin. Cayma talebinizi iletmeniz için size bir bağlantı göndereceğiz.';

  @override
  String get accountEuWithdrawOrderNumber => 'Sipariş numarası';

  @override
  String get accountEuWithdrawEmail => 'E-posta adresi';

  @override
  String get accountEuWithdrawFieldRequired => 'Bu alan zorunludur';

  @override
  String get accountEuWithdrawView => 'View your withdrawal';

  @override
  String get accountEuWithdrawReceiptTitle => 'Withdrawal Receipt';

  @override
  String get accountEuWithdrawReceivedTitle =>
      'Your withdrawal has been received';

  @override
  String get accountEuWithdrawReceivedSubtitle =>
      'We have recorded your declaration. This page and the email we just sent you both serve as confirmation on a durable medium.';

  @override
  String get accountEuWithdrawReceivedAt => 'RECEIVED AT';

  @override
  String get accountEuWithdrawReference => 'REFERENCE';

  @override
  String get accountEuWithdrawOrder => 'ORDER';

  @override
  String get accountEuWithdrawEmailLabel => 'EMAIL';

  @override
  String get accountEuWithdrawStatusLabel => 'STATUS';

  @override
  String get accountEuWithdrawReasonLabel => 'REASON';

  @override
  String get accountEuWithdrawWhatNext => 'What happens next';

  @override
  String get accountEuWithdrawNextRecorded =>
      'Your declaration has been received and recorded.';

  @override
  String get accountEuWithdrawNextEmail =>
      'Confirmation email sent to your inbox.';

  @override
  String get accountEuWithdrawNextEmailDesc =>
      'Confirmation email has been sent.';

  @override
  String get accountEuWithdrawNextRefund => 'Refund issued within 14 days.';

  @override
  String get accountEuWithdrawNextRefundDesc =>
      'We reimburse using the same means of payment you used for the original transaction, unless you have expressly agreed otherwise.';

  @override
  String get accountEuWithdrawReceiptFooter =>
      'This page is your receipt. You may save or print it.';

  @override
  String get accountEuWithdrawReferenceCopied =>
      'Reference copied to clipboard';

  @override
  String get accountEuWithdrawDeclinedTitle => 'Your withdrawal was declined';

  @override
  String get accountEuWithdrawDeclinedSubtitle =>
      'The merchant has contested your entitlement to a refund under this declaration. See the details below for the reason given and your remaining options.';

  @override
  String get accountEuWithdrawNextDeclined =>
      'Withdrawal declined by the merchant.';

  @override
  String get accountEuWithdrawMerchantReasonLabel =>
      'REASON GIVEN BY THE MERCHANT';

  @override
  String get accountEuWithdrawDeclinedLegalNotice =>
      'You retain all other legal remedies under EU consumer law. If you disagree with this decision, contact the merchant directly.';

  @override
  String get accountBookingNotCanceledTitle =>
      'Booking Items Will Not Be Canceled';

  @override
  String get accountBookingNotCanceledBody =>
      'This order contains booking products marked as non-cancellable. Cancelling the order will only cancel the remaining items; the booking items will remain active. Please contact support if you need assistance with the booking items.';

  @override
  String get storefrontVisitShopButton => 'Visit Shop';

  @override
  String get accountPhoneNumberLabel => 'Phone number';

  @override
  String get accountContactUsDescription =>
      'Bize bir not bırakın, en kısa sürede size dönelim';

  @override
  String get accountPhoneNumber => 'Telefon numarası';

  @override
  String get accountWhatsOnYourMind => 'Aklınızda ne var?';

  @override
  String get accountDescribeHere => 'Buraya yazın';

  @override
  String get accountSubmit => 'Gönder';

  @override
  String get priceStartingAt => 'Starting at';

  @override
  String get priceStartingFrom => 'Starting from';

  @override
  String get priceAsLowAs => 'As low as';

  @override
  String get priceRangeTo => 'To';
}
