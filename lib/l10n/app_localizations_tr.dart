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
  String get sellerProfileCountriesUnavailable =>
      'Country and state options could not be loaded.';

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
  String get accountSeller => 'Satıcı';

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
  String get sellerLoginTitle => 'Seller sign in';

  @override
  String get sellerLoginSubtitle => 'Manage your shop, products and orders';

  @override
  String get sellerEmailLabel => 'Email';

  @override
  String get sellerPasswordLabel => 'Password';

  @override
  String get sellerSignInAction => 'Sign in';

  @override
  String get sellerEmailRequired => 'Enter your email';

  @override
  String get sellerPasswordRequired => 'Enter your password';

  @override
  String get sellerPendingApprovalTitle => 'Waiting for approval';

  @override
  String get sellerPendingApprovalBody =>
      'The marketplace admin has not approved this shop yet. You will be able to sign in once they do.';

  @override
  String get sellerSuspendedTitle => 'Shop suspended';

  @override
  String get sellerSuspendedBody =>
      'This shop has been suspended by the marketplace admin.';

  @override
  String get accountSellOnMarketplace => 'Sell on marketplace';

  @override
  String get sellerProfileTitle => 'Shop profile';

  @override
  String get sellerBusinessNameLabel => 'Business name';

  @override
  String get sellerBusinessDescriptionLabel => 'About the shop';

  @override
  String get sellerPhoneLabel => 'Phone';

  @override
  String get sellerSaveAction => 'Save changes';

  @override
  String get sellerProfileSaved => 'Profile updated';

  @override
  String get sellerProfileFieldRequired => 'This field is required';

  @override
  String get sellerProfileRequiredFieldsMissing =>
      'Please fill in all required fields';

  @override
  String get sellerProfilePhone => 'Phone';

  @override
  String get sellerProfileDescription => 'Shop description';

  @override
  String get sellerProfileBusinessName => 'Business name';

  @override
  String get sellerProfileTabGeneral => 'General';

  @override
  String get sellerProfileTabAddress => 'Address';

  @override
  String get sellerProfileTabPolicies => 'Policies';

  @override
  String get sellerProfileTabSeo => 'SEO';

  @override
  String get sellerProfileTabSocial => 'Social';

  @override
  String get sellerProfileTabOther => 'More';

  @override
  String get sellerShopInfoTitle => 'Shop Information';

  @override
  String get sellerShopInfoCommission => 'Admin commission';

  @override
  String sellerShopInfoCommissionText(String rate) {
    return 'Admin Commission $rate of total Invoiced Amount';
  }

  @override
  String get sellerShopInfoRestrictedCategories => 'Restricted categories';

  @override
  String get sellerShopInfoProductTypes => 'Allowed product types';

  @override
  String get sellerShopInfoPaymentMethods => 'Payment methods';

  @override
  String get sellerShopInfoShippingMethods => 'Shipping methods';

  @override
  String get sellerProfileNoFields =>
      'This marketplace defines no editable profile fields.';

  @override
  String get sellerProfileContactName => 'Contact name';

  @override
  String get sellerProfileSlug => 'Shop URL';

  @override
  String get sellerProfileAddress => 'Street address';

  @override
  String get sellerProfileCity => 'City';

  @override
  String get sellerProfileState => 'State';

  @override
  String get sellerProfileCountry => 'Country';

  @override
  String get sellerProfilePostcode => 'Postcode';

  @override
  String get sellerProfileReturnPolicy => 'Return policy';

  @override
  String get sellerProfileShippingPolicy => 'Shipping policy';

  @override
  String get sellerProfilePrivacyPolicy => 'Privacy policy';

  @override
  String get sellerProfileMetaTitle => 'Meta title';

  @override
  String get sellerProfileMetaKeywords => 'Meta keywords';

  @override
  String get sellerProfileMetaDescription => 'Meta description';

  @override
  String get sellerProfileAnalyticsId => 'Google Analytics ID';

  @override
  String get sellerProfileMinOrder => 'Minimum order amount';

  @override
  String get sellerStatusSuspended => 'Suspended';

  @override
  String get sellerDrawerSettingsGroup => 'Settings';

  @override
  String get sellerDrawerCatalogGroup => 'Catalog';

  @override
  String get sellerDrawerInventoriesGroup => 'Inventories';

  @override
  String get sellerDrawerPricingGroup => 'Pricing';

  @override
  String get sellerDrawerSalesGroup => 'Sales';

  @override
  String get sellerDrawerAllProducts => 'Products';

  @override
  String get sellerDrawerReportingGroup => 'Reporting';

  @override
  String get sellerDrawerGeneral => 'General';

  @override
  String get sellerDrawerUsers => 'Users';

  @override
  String get sellerDrawerRoles => 'Roles';

  @override
  String get sellerDrawerInventory => 'Inventory Sources';

  @override
  String get sellerDrawerManageInventory => 'Manage Inventory';

  @override
  String get sellerDrawerReportSales => 'Sales';

  @override
  String get sellerDrawerReportProducts => 'Products';

  @override
  String get sellerDrawerReportCustomers => 'Customers';

  @override
  String get sellerDrawerProductReviews => 'Product reviews';

  @override
  String get sellerDrawerShopReviews => 'Shop reviews';

  @override
  String get sellerDrawerMoreTools => 'More tools';

  @override
  String get sellerPanelTitle => 'Seller panel';

  @override
  String get sellerTabDashboard => 'Dashboard';

  @override
  String get sellerTabProducts => 'Products';

  @override
  String get sellerTabOrders => 'Orders';

  @override
  String get sellerStatusApproved => 'Approved';

  @override
  String get sellerStatusPending => 'Awaiting approval';

  @override
  String get sellerDashboardSalesTrend => 'Sales over time';

  @override
  String get sellerDashboardDateFilter => 'Date range';

  @override
  String get sellerDashboardDefaultRange => 'Default range';

  @override
  String get sellerDashboardToday => 'Today';

  @override
  String get sellerDashboardLast7Days => 'Last 7 Days';

  @override
  String get sellerDashboardLast30Days => 'Last 30 Days';

  @override
  String get sellerDashboardThisMonth => 'This Month';

  @override
  String get sellerDashboardLastMonth => 'Last Month';

  @override
  String get sellerDashboardLast6Months => 'Last 6 Months';

  @override
  String get sellerDashboardThisYear => 'This Year';

  @override
  String get sellerDashboardLastYear => 'Last Year';

  @override
  String get sellerDashboardCustomRange => 'Custom range';

  @override
  String get sellerDashboardOrderStatus => 'Orders by status';

  @override
  String get sellerDashboardTopProducts => 'Top products';

  @override
  String get sellerDashboardTopCategories => 'Top categories';

  @override
  String get sellerDashboardTopCustomers => 'Top customers';

  @override
  String get sellerDashboardTodo => 'Things to do';

  @override
  String get sellerProfileScoreTitle => 'Profile Score';

  @override
  String get sellerProfileScoreSubtitle =>
      'Maximize your visibility by keeping your profile information complete.';

  @override
  String get sellerProfileScoreAction => 'Complete Your Profile';

  @override
  String get sellerDashboardTodoClear => 'You are all caught up.';

  @override
  String get sellerDashboardTodoUnshipped => 'Orders to ship';

  @override
  String get sellerDashboardTodoLowStock => 'Products low on stock';

  @override
  String get sellerDashboardTodoPending => 'Products awaiting approval';

  @override
  String get sellerDashboardTodoMessages => 'Unread messages';

  @override
  String get sellerDashboardBuyerMessages => 'Buyer Messages';

  @override
  String get sellerDashboardUnread => 'Unread';

  @override
  String sellerDashboardReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashboardLowStock => 'Stock Threshold';

  @override
  String get sellerDashboardNoData => 'Nothing to show for this period';

  @override
  String get sellerDashboardAvgSale => 'Average sale';

  @override
  String get sellerDashboardPaidOut => 'Paid out';

  @override
  String get sellerDashboardViewAll => 'View all';

  @override
  String sellerDashboardOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String sellerDashboardLeftInStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count left',
      one: '1 left',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashboardPerformance => 'Performance';

  @override
  String get sellerDashboardOrders => 'Orders';

  @override
  String get sellerDashboardSales => 'Sales';

  @override
  String get sellerDashboardCustomers => 'Customers';

  @override
  String get sellerMoreCatalogue => 'Catalogue';

  @override
  String get sellerMoreSelling => 'Selling';

  @override
  String get sellerMoreMoney => 'Money';

  @override
  String get sellerMoreShop => 'Your shop';

  @override
  String get sellerShopProfileMenu => 'Shop profile';

  @override
  String get sellerSignOutAction => 'Sign out';

  @override
  String get sellerRegisterTitle => 'Become a seller';

  @override
  String get sellerRegisterAction => 'Create shop';

  @override
  String get sellerRegisterAdditionalInfo => 'Additional Information';

  @override
  String get sellerNameLabel => 'Your name';

  @override
  String get sellerShopUrlLabel => 'Shop URL';

  @override
  String get sellerConfirmPasswordLabel => 'Confirm password';

  @override
  String get sellerPasswordMismatch => 'Passwords do not match';

  @override
  String get sellerFieldRequired => 'This field is required';

  @override
  String get sellerForgotPasswordTitle => 'Reset password';

  @override
  String get sellerForgotPasswordAction => 'Send reset link';

  @override
  String get sellerForgotPasswordSent =>
      'If that email has a shop, a reset link is on its way.';

  @override
  String get sellerNoAccountPrompt => 'New seller? Create a shop';

  @override
  String get sellerForgotPasswordPrompt => 'Forgot password?';

  @override
  String get sellerProductsTitle => 'Products';

  @override
  String get sellerProductsSearchHint => 'Search name or SKU';

  @override
  String get sellerProductsEmpty => 'No products yet';

  @override
  String get sellerProductsEmptyFiltered => 'No products match these filters';

  @override
  String get sellerProductsFilters => 'Filters';

  @override
  String get sellerProductStatusApproved => 'Approved';

  @override
  String get sellerProductStatusPending => 'Pending';

  @override
  String get sellerProductStatusRejected => 'Rejected';

  @override
  String get sellerProductStatusDraft => 'Draft';

  @override
  String get sellerProductStockLabel => 'Stock';

  @override
  String get sellerProductOutOfStock => 'Out';

  @override
  String get sellerProductsRetry => 'Retry';

  @override
  String get sellerFiltersApply => 'Apply';

  @override
  String get sellerFiltersClear => 'Clear all';

  @override
  String get sellerProductTypeLabel => 'Type';

  @override
  String get sellerProductStatusLabel => 'Status';

  @override
  String get sellerProductApprovalLabel => 'Approval';

  @override
  String get sellerProductEnabled => 'Enabled';

  @override
  String get sellerProductDisabled => 'Disabled';

  @override
  String get sellerProductDraftsOnly => 'Drafts only';

  @override
  String get sellerProductAnyValue => 'Any';

  @override
  String sellerProductsCount(int count) {
    return '$count products';
  }

  @override
  String get sellerProductDetailTitle => 'Product';

  @override
  String get sellerProductPricing => 'Pricing';

  @override
  String get sellerProductShipping => 'Shipping';

  @override
  String get sellerProductStockBySource => 'Stock by location';

  @override
  String sellerProductPendingOrderedQty(int count) {
    return 'Pending Ordered Qty: $count';
  }

  @override
  String get sellerListingCompleteness => 'Listing Completeness';

  @override
  String get sellerListingCompletenessHint =>
      'A complete listing gets more visibility and sells better. Fill in the remaining details to reach 100%.';

  @override
  String sellerGroupPriceFixed(Object qty, Object value) {
    return 'For $qty Qty at fixed price of $value';
  }

  @override
  String sellerGroupPriceDiscount(Object qty, Object value) {
    return 'For $qty Qty at $value% discount';
  }

  @override
  String get sellerGroupPriceAddNew => 'Add New';

  @override
  String get sellerGroupPriceCreateTitle => 'Create Customer Group Price';

  @override
  String get sellerGroupPriceEditTitle => 'Edit Customer Group Price';

  @override
  String get sellerGroupPriceEmpty =>
      'No group prices yet. Special pricing for customers belonging to a specific group.';

  @override
  String get sellerGroupPriceSave => 'Save';

  @override
  String get sellerGroupPriceDuplicate =>
      'A price for this group and quantity already exists. Edit that one instead, or use a different quantity.';

  @override
  String get sellerProductInventoriesLabel => 'Inventories';

  @override
  String get sellerProductManageStock => 'Manage Stock';

  @override
  String get sellerProductCategoriesLabel => 'Categories';

  @override
  String get sellerProductAttributes => 'Attributes';

  @override
  String get sellerProductSeo => 'SEO';

  @override
  String get sellerProductNoImages => 'No images';

  @override
  String get sellerProductRejectionReason => 'Rejection reason';

  @override
  String get sellerProductSpecialPrice => 'Special price';

  @override
  String get sellerProductWeight => 'Weight';

  @override
  String get sellerProductDescription => 'Description';

  @override
  String get sellerProductNoPermission =>
      'Your role does not include product access.';

  @override
  String get sellerStockLocationsTitle => 'Stock locations';

  @override
  String get sellerStockLocationsEmpty => 'No stock locations yet';

  @override
  String get sellerStockLocationsCreateAction => 'Create Inventory Sources';

  @override
  String get sellerStockLocationsSaveAction => 'Save Inventory Sources';

  @override
  String get sellerStockLocationAdd => 'Add Inventory Source';

  @override
  String get sellerStockLocationEdit => 'Edit location';

  @override
  String get sellerStockLocationCode => 'Code';

  @override
  String get sellerStockLocationName => 'Name';

  @override
  String get sellerStockLocationContactName => 'Contact name';

  @override
  String get sellerStockLocationContactEmail => 'Contact email';

  @override
  String get sellerStockLocationContactNumber => 'Contact number';

  @override
  String get sellerStockLocationContactFax => 'Contact fax';

  @override
  String get sellerStockLocationStreet => 'Street';

  @override
  String get sellerStockLocationCity => 'City';

  @override
  String get sellerStockLocationState => 'State';

  @override
  String get sellerStockLocationCountry => 'Country';

  @override
  String get sellerStockLocationPostcode => 'Postcode';

  @override
  String get sellerStockLocationPriority => 'Priority';

  @override
  String get sellerStockLocationDescription => 'Description';

  @override
  String get sellerStockLocationLatitude => 'Latitude';

  @override
  String get sellerStockLocationLongitude => 'Longitude';

  @override
  String get sellerStockLocationActive => 'Active';

  @override
  String get sellerStockLocationInactive => 'Inactive';

  @override
  String get sellerStockLocationSectionGeneral => 'General';

  @override
  String get sellerStockLocationSectionAddress => 'Source Address';

  @override
  String get sellerStockLocationSectionSettings => 'Settings';

  @override
  String get sellerStockLocationSectionContact => 'Contact Information';

  @override
  String sellerStockLocationProducts(int count) {
    return '$count products';
  }

  @override
  String get sellerStockLocationDelete => 'Delete location';

  @override
  String get sellerStockLocationDeleteConfirm => 'Delete this stock location?';

  @override
  String get sellerCancel => 'Cancel';

  @override
  String get sellerDelete => 'Delete';

  @override
  String get sellerSave => 'Save';

  @override
  String get sellerStockLocationCodeHint => 'Unique across the whole store';

  @override
  String get sellerManageInventoryTitle => 'Manage Inventory';

  @override
  String get sellerManageInventorySearchHint => 'Search';

  @override
  String sellerManageInventoryResults(int count) {
    return '$count Results';
  }

  @override
  String get sellerManageInventoryEmpty => 'No products yet';

  @override
  String get sellerManageInventoryRetry => 'Try again';

  @override
  String get sellerManageInventoryStatusUnapproved => 'Unapproved';

  @override
  String get sellerManageInventoryStatusActive => 'Active';

  @override
  String get sellerManageInventoryStatusInactive => 'Inactive';

  @override
  String sellerManageInventorySold(int count) {
    return 'Sold $count';
  }

  @override
  String sellerManageInventoryUndelivered(int count) {
    return 'Undelivered $count';
  }

  @override
  String sellerManageInventoryCanceled(int count) {
    return 'Canceled $count';
  }

  @override
  String sellerManageInventoryStock(int count) {
    return 'Stock: $count';
  }

  @override
  String get sellerManageInventoryReadOnlyStock =>
      'Stock is read-only with more than one stock location — edit it from the product instead.';

  @override
  String sellerManageInventoryUnsavedChanges(int count) {
    return '$count unsaved change(s)';
  }

  @override
  String get sellerManageInventoryUnsavedHint =>
      'Review your inventory edits, then save to publish them.';

  @override
  String get sellerManageInventoryDiscard => 'Discard';

  @override
  String get sellerManageInventorySaveAction => 'Save Inventories';

  @override
  String get sellerManageInventorySaveSuccess => 'Inventory updated';

  @override
  String get sellerManageInventoryEditPrice => 'Edit price';

  @override
  String get sellerManageInventorySelectAll => 'Select all';

  @override
  String sellerManageInventorySelected(int count) {
    return '$count selected';
  }

  @override
  String get sellerManageInventoryEnable => 'Enable';

  @override
  String get sellerManageInventoryDisable => 'Disable';

  @override
  String sellerManageInventoryBatchResult(int saved, int skipped) {
    return '$saved updated, $skipped skipped';
  }

  @override
  String get sellerManageInventoryPageSize => 'Per page';

  @override
  String get sellerProductCreateTitle => 'New product';

  @override
  String get sellerProductCreateAction => 'Create';

  @override
  String get sellerProductSkuLabel => 'SKU';

  @override
  String get sellerProductFamilyLabel =>
      'Which attribute family does your product belong to? *';

  @override
  String get sellerProductFamilyHelp =>
      'Choose the attribute family that best matches your product.';

  @override
  String get sellerProductFamiliesFailed =>
      'Could not load attribute families.';

  @override
  String get sellerProductFamiliesEmpty =>
      'No attribute families are available.';

  @override
  String get sellerProductSaveAsDraft => 'Save as draft';

  @override
  String get sellerProductNeedsVariants =>
      'Choose at least one attribute the product varies by';

  @override
  String get sellerProductLoadingVariants => 'Loading options…';

  @override
  String get sellerProductVariesBy => 'Varies by';

  @override
  String get sellerProductVariesByHelp =>
      'Each selected option combination creates a variant. You can add combinations after saving the product.';

  @override
  String get sellerProductEditorTitle => 'Edit product';

  @override
  String get sellerProductNameLabel => 'Name';

  @override
  String get sellerProductUrlKeyLabel => 'URL key';

  @override
  String get sellerProductNumberLabel => 'Product Number';

  @override
  String get sellerProductPriceLabel => 'Price';

  @override
  String get sellerProductSpecialPriceFrom => 'Special price from';

  @override
  String get sellerProductSpecialPriceTo => 'Special price to';

  @override
  String get sellerProductShortDescription => 'Short description';

  @override
  String get sellerProductFullDescription => 'Full description';

  @override
  String get sellerProductIdentity => 'Identity';

  @override
  String get sellerProductFlags => 'Visibility';

  @override
  String get sellerProductVisibleIndividually => 'Visible individually';

  @override
  String get sellerProductFeaturedFlag => 'Featured';

  @override
  String get sellerProductNewFlag => 'New';

  @override
  String get sellerProductGuestCheckout => 'Guest Checkout';

  @override
  String get sellerProductImages => 'Images';

  @override
  String get sellerProductAddImageUrl => 'Add image URL';

  @override
  String get sellerProductPickImage => 'Pick from device';

  @override
  String get sellerProductImageUrlHint => 'https://…';

  @override
  String get sellerProductVideos => 'Videos';

  @override
  String get sellerProductNoVideos => 'No videos';

  @override
  String get sellerProductAddVideoUrl => 'Add video URL';

  @override
  String get sellerProductPickVideo => 'Pick from device';

  @override
  String get sellerProductVideoUrlHint => 'https://…';

  @override
  String get sellerProductVideoTooLarge => 'Video must be 2MB or smaller';

  @override
  String get sellerProductNoCategories =>
      'The admin has not given this shop any categories to file products under.';

  @override
  String get sellerProductSaved => 'Product updated successfully';

  @override
  String get sellerProductNoStockLocations =>
      'Add a stock location before setting stock.';

  @override
  String get sellerProductEditAction => 'Edit';

  @override
  String get sellerProductDeleteAction => 'Delete product';

  @override
  String get sellerProductUnassignAction => 'Stop selling this product';

  @override
  String get sellerProductDeleteConfirm =>
      'Delete this product from the marketplace?';

  @override
  String get sellerProductUnassignConfirm =>
      'Remove your listing for this product?';

  @override
  String get sellerProductDeleted => 'Product deleted successfully';

  @override
  String sellerProductsSelected(int count) {
    return '$count selected';
  }

  @override
  String get sellerProductsDeleteSelected => 'Delete selected';

  @override
  String sellerProductsBulkResult(int removed, int skipped) {
    return '$removed removed, $skipped skipped';
  }

  @override
  String get sellerTypeReplaceNotice =>
      'This is what the product holds now. Saving sends the whole set back, so a row removed here is removed on the marketplace.';

  @override
  String get sellerBundleNotice =>
      'This is what the product holds now. Every option needs at least one product, or the server refuses the save.';

  @override
  String get sellerBundleNeedsProduct =>
      'Every bundle option needs at least one product. Add one, or remove the option.';

  @override
  String get sellerPickProductHint => 'Search by name or SKU';

  @override
  String get sellerPickProductEmpty => 'No products match';

  @override
  String get sellerVariantsNotice =>
      'Edit variant details or add option combinations here.';

  @override
  String get sellerVariantsTitle => 'Variants';

  @override
  String get sellerGroupedTitle => 'Grouped products';

  @override
  String get sellerGroupedAdd => 'Add product';

  @override
  String get sellerRelatedProductsTitle => 'Related products';

  @override
  String get sellerRelatedProductsAdd => 'Add related product';

  @override
  String get sellerUpSellsTitle => 'Up-sells';

  @override
  String get sellerUpSellsAdd => 'Add up-sell';

  @override
  String get sellerCrossSellsTitle => 'Cross-sells';

  @override
  String get sellerCrossSellsAdd => 'Add cross-sell';

  @override
  String get sellerBundleTitle => 'Bundle options';

  @override
  String get sellerBundleAdd => 'Add option';

  @override
  String get sellerDownloadableTitle => 'Downloadable links';

  @override
  String get sellerDownloadableAdd => 'Add link';

  @override
  String get sellerDownloadableSamplesTitle => 'Downloadable samples';

  @override
  String get sellerDownloadableSamplesNotice =>
      'Free previews a shopper can download before buying. Saving sends the whole set back, so a row removed here is removed on the marketplace.';

  @override
  String get sellerDownloadableSampleAdd => 'Add sample';

  @override
  String get sellerBookingTitle => 'Booking';

  @override
  String get sellerPickProductTitle => 'Choose a product';

  @override
  String get sellerOrdersTitle => 'Orders';

  @override
  String get sellerOrdersEmpty => 'No orders yet';

  @override
  String get sellerOrdersEmptyHint =>
      'Orders placed for your products will appear here.';

  @override
  String get sellerOrdersSearchHint => 'Order number, customer or status';

  @override
  String sellerOrdersCount(int count) {
    return '$count orders';
  }

  @override
  String get sellerOrderPayoutPending => 'Invoice Pending';

  @override
  String get sellerOrderPayoutRequested => 'Requested';

  @override
  String get sellerOrderPayoutPaid => 'Paid';

  @override
  String get sellerOrderPayoutRefunded => 'Refunded';

  @override
  String get sellerOrderDetailTitle => 'Order';

  @override
  String get sellerOrderItems => 'Items';

  @override
  String get sellerOrderTabInformation => 'Information';

  @override
  String get sellerOrderSubTotal => 'Sub total';

  @override
  String get sellerOrderTax => 'Tax';

  @override
  String get sellerOrderDiscount => 'Discount';

  @override
  String get sellerOrderShipping => 'Shipping & handling';

  @override
  String sellerOrderSkuLabel(String sku) {
    return 'SKU - $sku';
  }

  @override
  String get sellerOrderPrice => 'Price';

  @override
  String get sellerOrderTotalRefunded => 'Total refunded';

  @override
  String get sellerOrderTotalSellerAmount => 'Total seller amount';

  @override
  String get sellerOrderAdminCommission => 'Admin commission';

  @override
  String get sellerOrderTotalPaid => 'Total paid';

  @override
  String get sellerOrderTotalDue => 'Total due';

  @override
  String get sellerOrderGrandTotal => 'Grand total';

  @override
  String get sellerOrderOrdered => 'Ordered';

  @override
  String get sellerOrderInvoiced => 'Invoiced';

  @override
  String get sellerOrderShipped => 'Shipped';

  @override
  String get sellerOrderRefunded => 'Refunded';

  @override
  String get sellerOrderCancelled => 'Cancelled';

  @override
  String get sellerOrderInvoice => 'Invoice';

  @override
  String get sellerOrderShipment => 'Shipment';

  @override
  String get sellerOrderPrint => 'Print';

  @override
  String get sellerOrderNoInvoices => 'No invoices raised yet';

  @override
  String get sellerOrderNoShipments => 'Nothing shipped yet';

  @override
  String get sellerOrderBookingFailed =>
      'The carrier did not accept the booking';

  @override
  String get sellerOrderInvoices => 'Invoices';

  @override
  String get sellerOrderShipments => 'Shipments';

  @override
  String get sellerOrderRefunds => 'Refunds';

  @override
  String get sellerOrderCustomer => 'Customer';

  @override
  String get sellerOrderEarnings => 'Your earnings';

  @override
  String get sellerOrderCommission => 'Commission';

  @override
  String get sellerOrderTotal => 'Order total';

  @override
  String get sellerOrderItemsLabel => 'Items';

  @override
  String get sellerOrdersFilterAll => 'All';

  @override
  String get sellerOrderCreateInvoice => 'Create invoice';

  @override
  String get sellerOrderCreateShipment => 'Create shipment';

  @override
  String get sellerOrderCancelAction => 'Cancel order';

  @override
  String get sellerOrderRequestPayment => 'Request payment';

  @override
  String get sellerOrderPaymentConfirmTitle => 'Are you sure?';

  @override
  String get sellerOrderPaymentConfirm =>
      'Are you sure you want to perform this action?';

  @override
  String get sellerOrderPaymentSuccess =>
      'Your payment request is submitted successfully';

  @override
  String get sellerOrderSchedulePickup => 'Schedule Pickup';

  @override
  String get sellerOrderCancelConfirm => 'Cancel your items on this order?';

  @override
  String get sellerOrderInvoiceCreated => 'Invoice created';

  @override
  String get sellerOrderShipmentCreated => 'Shipment created';

  @override
  String get sellerOrderPaymentRequested => 'Payment requested';

  @override
  String get sellerOrderCarrier => 'Carrier';

  @override
  String get sellerOrderTrackingNumber => 'Tracking number';

  @override
  String get sellerOrderParcel => 'Parcel';

  @override
  String get sellerOrderPickup => 'Collection';

  @override
  String get sellerOrderPickupDate => 'Choose a date';

  @override
  String get sellerOrderPickupInstructions => 'Instructions for the driver';

  @override
  String get sellerOrderShipFrom => 'Ship from';

  @override
  String get sellerOrderQtyToInvoice => 'To invoice';

  @override
  String get sellerOrderQtyToShip => 'To ship';

  @override
  String get sellerOrderNothingToInvoice => 'Everything is invoiced already';

  @override
  String get sellerOrderNothingToShip => 'Nothing is waiting to ship';

  @override
  String get sellerOrderDownloadInvoice => 'Download invoice';

  @override
  String get sellerOrderNoPermission =>
      'Your role does not include order access.';

  @override
  String get sellerEarningsMenu => 'Transactions';

  @override
  String get sellerEarningsTitle => 'Transactions';

  @override
  String get sellerEarningsTotalSale => 'Total sales';

  @override
  String get sellerEarningsYourShare => 'Your share';

  @override
  String get sellerEarningsCommission => 'Commission';

  @override
  String get sellerEarningsPaidOut => 'Paid out';

  @override
  String get sellerEarningsRemaining => 'Awaiting payout';

  @override
  String get sellerEarningsTransactions => 'Payout history';

  @override
  String get sellerEarningsNoTransactions => 'No payouts recorded yet';

  @override
  String get sellerEarningsDownloadReceipt => 'Download receipt';

  @override
  String get sellerEarningsNoPermission =>
      'Your role does not include payout access.';

  @override
  String get sellerReportsMenu => 'Reports';

  @override
  String get sellerReportsTitle => 'Reports';

  @override
  String get sellerReportsFormatGraph => 'Graph';

  @override
  String get sellerReportsFormatTable => 'Table';

  @override
  String get sellerReportsPeriodDay => 'Daily';

  @override
  String get sellerReportsPeriodMonth => 'Monthly';

  @override
  String get sellerReportsPeriodYear => 'Yearly';

  @override
  String get sellerReportsEmpty => 'No figures for this period';

  @override
  String get sellerReportsNone => 'No reports are available to your role.';

  @override
  String get sellerReportsExport => 'Export as spreadsheet';

  @override
  String get sellerReportsViewDetails => 'View Details';

  @override
  String get sellerReportsVsPrevious => 'vs previous period';

  @override
  String get sellerReportsEntitySales => 'Sales';

  @override
  String get sellerReportsEntityProducts => 'Products';

  @override
  String get sellerReportsEntityCustomers => 'Customers';

  @override
  String get sellerAssignMenu => 'Sell an existing product';

  @override
  String get sellerAssignTitle => 'Sell yours';

  @override
  String get sellerAssignSearchHint => 'Search the marketplace catalogue';

  @override
  String get sellerAssignEmpty => 'Nothing here you can sell yet';

  @override
  String get sellerAssignAction => 'Sell this';

  @override
  String get sellerAssignAlreadySelling =>
      'You are already selling this product';

  @override
  String sellerAssignSellersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sellers',
      one: '1 seller',
      zero: 'No sellers yet',
    );
    return '$_temp0';
  }

  @override
  String get sellerAssignLowestPrice => 'Lowest offer';

  @override
  String get sellerAssignYourPrice => 'Your price';

  @override
  String get sellerAssignCondition => 'Condition';

  @override
  String get sellerAssignConditionNew => 'New';

  @override
  String get sellerAssignConditionOld => 'Old';

  @override
  String get sellerAssignDescription => 'Your description';

  @override
  String get sellerAssignStock => 'Stock';

  @override
  String get sellerAssignSubmit => 'Start selling';

  @override
  String get sellerAssignDone =>
      'Listed. It goes live once the marketplace approves it.';

  @override
  String get sellerAssignNoPermission =>
      'Your role does not include selling existing products.';

  @override
  String get sellerBarcodeTitle => 'Barcode';

  @override
  String get sellerBarcodeMenu => 'Barcode';

  @override
  String get sellerBarcodeNone => 'No barcode generated yet';

  @override
  String get sellerBarcodeGenerate => 'Generate barcode';

  @override
  String get sellerBarcodeRegenerate => 'Regenerate';

  @override
  String get sellerBarcodeSymbology => 'Symbology';

  @override
  String get sellerBarcodeDownload => 'Download PDF';

  @override
  String get sellerBarcodeBulkGenerate => 'Generate barcodes';

  @override
  String get sellerBarcodeBulkPrint => 'Print barcodes';

  @override
  String sellerBarcodeBatchResult(int generated, int skipped) {
    return '$generated generated, $skipped skipped';
  }

  @override
  String get sellerBarcodeNoPermission =>
      'Your role does not include barcodes.';

  @override
  String get sellerMagicAiTitle => 'Magic AI';

  @override
  String get sellerMagicAiMenu => 'Fill in with Magic AI';

  @override
  String get sellerMagicAiPrompt => 'Describe the product';

  @override
  String get sellerMagicAiPromptHint =>
      'A brass desk lamp with a warm dimmable bulb';

  @override
  String get sellerMagicAiGenerate => 'Generate';

  @override
  String get sellerMagicAiFields => 'Fields to fill';

  @override
  String get sellerMagicAiSuggested => 'Suggested values';

  @override
  String get sellerMagicAiSkipped => 'Not filled';

  @override
  String get sellerMagicAiApply => 'Copy to clipboard';

  @override
  String get sellerMagicAiCopied => 'Copied';

  @override
  String get sellerMagicAiOffGlobally =>
      'The marketplace has Magic AI switched off.';

  @override
  String get sellerMagicAiOff => 'Magic AI is unavailable for this product.';

  @override
  String get sellerReturnsMenu => 'RMA';

  @override
  String get sellerReturnsTitle => 'Return requests';

  @override
  String get sellerReturnsSearchHint => 'Search by order, product or customer';

  @override
  String get sellerReturnsEmpty => 'No return requests';

  @override
  String get sellerReturnsNoPermission => 'Your role does not include returns.';

  @override
  String get sellerReturnDetailTitle => 'Return request';

  @override
  String get sellerReturnResolution => 'Wanted';

  @override
  String get sellerReturnStepPending => 'Pending';

  @override
  String get sellerReturnStepApproved => 'Approved';

  @override
  String get sellerReturnStepAwaiting => 'Awaiting return';

  @override
  String get sellerReturnStepTransit => 'In transit';

  @override
  String get sellerReturnStepRefunded => 'Refunded';

  @override
  String get sellerReturnStepDeclined => 'Declined';

  @override
  String get sellerReturnStepCancelled => 'Item cancelled';

  @override
  String get sellerReturnStepWithdrawn => 'Withdrawn';

  @override
  String get sellerReturnReason => 'Reason';

  @override
  String get sellerReturnQuantity => 'Quantity';

  @override
  String get sellerReturnPackage => 'Package';

  @override
  String get sellerReturnCustomerNote => 'What the customer said';

  @override
  String get sellerReturnPhotos => 'Customer photos';

  @override
  String get sellerReturnConversation => 'Conversation';

  @override
  String get sellerReturnReply => 'Write a reply';

  @override
  String get sellerReturnSend => 'Send';

  @override
  String get sellerReturnChangeStatus => 'Change status';

  @override
  String get sellerReturnReopen => 'Reopen request';

  @override
  String get sellerReturnStatusLocked =>
      'This request can no longer change status.';

  @override
  String get sellerReturnRefundWarning =>
      'This refunds the returned item. It cannot be undone.';

  @override
  String get sellerReturnCancelWarning =>
      'This cancels the item on the order. It cannot be undone.';

  @override
  String get sellerReturnNotInvoiced => 'Not invoiced yet';

  @override
  String get sellerBookingsMenu => 'Bookings';

  @override
  String get sellerBookingsFilters => 'Filters';

  @override
  String get sellerBookingsFilterOrder => 'Order ID';

  @override
  String get sellerBookingsFilterProduct => 'Product ID';

  @override
  String get sellerBookingsFilterId => 'Booking ID';

  @override
  String get sellerBookingsFilterQty => 'Quantity';

  @override
  String get sellerBookingsFilterFrom => 'From';

  @override
  String get sellerBookingsFilterTo => 'To';

  @override
  String get sellerBookingsFilterApply => 'Apply filters';

  @override
  String get sellerBookingsFilterClear => 'Clear';

  @override
  String get sellerBookingsFilterToday => 'Today';

  @override
  String get sellerBookingsFilterThisWeek => 'This week';

  @override
  String get sellerBookingsFilterThisMonth => 'This month';

  @override
  String get sellerBookingsFilterLast3Months => 'Last 3 months';

  @override
  String get sellerBookingsTitle => 'Bookings';

  @override
  String get sellerBookingsEmpty => 'No slots booked';

  @override
  String get sellerBookingsAllDates => 'All dates';

  @override
  String get sellerBookingsPickRange => 'Dates';

  @override
  String get sellerBookingsCalendarView => 'Calendar';

  @override
  String get sellerBookingsListView => 'List';

  @override
  String get sellerBookingDetailsTitle => 'Booking Details';

  @override
  String get sellerBookingDate => 'Booking Date';

  @override
  String get sellerBookingTimeSlot => 'Time Slot';

  @override
  String get sellerBookingOrderIdLabel => 'Order Id';

  @override
  String get sellerBookingViewDetails => 'View Details';

  @override
  String get sellerBookingsNoPermission =>
      'Your role does not include bookings.';

  @override
  String get sellerBookingSlot => 'Slot';

  @override
  String get sellerBookingGuests => 'Guests';

  @override
  String get sellerBookingContact => 'Contact';

  @override
  String get sellerBookingCancellable => 'Cancellation allowed';

  @override
  String get sellerCustomersMenu => 'Customers';

  @override
  String get sellerCustomersTitle => 'Customers';

  @override
  String get sellerCustomersSearchHint => 'Search by name or email';

  @override
  String get sellerCustomersEmpty => 'No customers yet';

  @override
  String get sellerCustomersNoPermission =>
      'Your role does not include customers.';

  @override
  String get sellerCustomerRevenue => 'Spent with you';

  @override
  String get sellerCustomerOrders => 'Orders';

  @override
  String get sellerCustomerActive => 'Active';

  @override
  String get sellerCustomerInactive => 'Inactive';

  @override
  String get sellerProductAssigned => 'Assigned';

  @override
  String get sellerProductOwn => 'Yours';

  @override
  String get sellerProductDraftBadge => 'Draft';

  @override
  String get sellerTransactionOrder => 'Order';

  @override
  String get sellerReviewsMenu => 'Reviews';

  @override
  String get sellerReviewsTitle => 'Performance';

  @override
  String get sellerReviewsOnProducts => 'On products';

  @override
  String get sellerReviewsOnShop => 'On your shop';

  @override
  String get sellerReviewsEmpty => 'No reviews yet';

  @override
  String get sellerReviewsNoPermission => 'Your role does not include reviews.';

  @override
  String get sellerReviewPending => 'Pending';

  @override
  String get sellerReviewApproved => 'Approved';

  @override
  String get sellerReviewDisapproved => 'Not published';

  @override
  String get sellerReviewDate => 'Date';

  @override
  String get sellerMarketingMenu => 'Marketing';

  @override
  String get sellerMarketingTitle => 'Marketing';

  @override
  String get sellerMarketingDiscounts => 'Product discounts';

  @override
  String get sellerMarketingJoinable => 'Join product discounts';

  @override
  String get sellerMarketingDeals => 'Checkout deals';

  @override
  String get sellerMarketingNoPermission =>
      'Your role does not include marketing.';

  @override
  String get sellerMarketingEmptyDiscounts => 'No product discounts yet';

  @override
  String get sellerMarketingEmptyJoinable =>
      'No discounts are open to join right now';

  @override
  String get sellerMarketingEmptyDeals => 'No checkout deals yet';

  @override
  String get sellerMarketingJoin => 'Enroll';

  @override
  String get sellerMarketingLeave => 'Withdraw';

  @override
  String get sellerMarketingJoined => 'Joined';

  @override
  String get sellerMarketingNotEnrolled => 'Not Enrolled';

  @override
  String get sellerMarketingParticipation => 'Participation';

  @override
  String get sellerMarketingNewDiscount => 'New discount';

  @override
  String get sellerMarketingNewDeal => 'New deal';

  @override
  String get sellerMarketingName => 'Name';

  @override
  String get sellerMarketingDescription => 'Description';

  @override
  String get sellerMarketingActive => 'Active';

  @override
  String get sellerMarketingInactive => 'Inactive';

  @override
  String get sellerMarketingScheduled => 'Scheduled';

  @override
  String get sellerMarketingExpired => 'Ended';

  @override
  String get sellerMarketingDiscountType => 'Discount';

  @override
  String get sellerMarketingAmount => 'Amount';

  @override
  String get sellerMarketingDiscountPercentLabel => 'Discount Percent (%)';

  @override
  String get sellerMarketingDiscountAmountLabel => 'Discount Amount';

  @override
  String get sellerRuleMaxDiscountedQuantity => 'Maximum Discounted Quantity';

  @override
  String get sellerMarketingStarts => 'Starts';

  @override
  String get sellerMarketingEnds => 'Ends';

  @override
  String get sellerMarketingNeedsCoupon => 'Needs a coupon code';

  @override
  String get sellerMarketingAutoCoupons => 'Generate a batch of codes';

  @override
  String get sellerMarketingCouponCode => 'Coupon code';

  @override
  String get sellerMarketingUsesPerCoupon => 'Uses per code';

  @override
  String get sellerMarketingUsagePerCustomer => 'Uses per customer';

  @override
  String get sellerMarketingCopyDeal => 'Duplicate';

  @override
  String get sellerMarketingDeleteConfirm => 'Delete this permanently?';

  @override
  String get sellerMarketingTimesUsed => 'Used';

  @override
  String get sellerCouponsTitle => 'Coupon codes';

  @override
  String get sellerCouponsEmpty => 'No codes generated yet';

  @override
  String get sellerCouponsGenerate => 'Generate codes';

  @override
  String get sellerCouponsQuantity => 'How many';

  @override
  String get sellerCouponsLength => 'Code length';

  @override
  String get sellerCouponsPrefix => 'Prefix';

  @override
  String get sellerCouponsMinLength => 'Codes must be at least 10 characters.';

  @override
  String get sellerCouponsSpent => 'Used up';

  @override
  String get sellerBulkMenu => 'Manage Pricing';

  @override
  String get sellerBulkTitle => 'Bulk edit';

  @override
  String get sellerBulkPricingTab => 'Pricing';

  @override
  String get sellerBulkPrice => 'Price';

  @override
  String get sellerBulkSalePrice => 'Sale price';

  @override
  String get sellerBulkValidFrom => 'Valid from';

  @override
  String get sellerBulkValidTo => 'Valid to';

  @override
  String sellerBulkResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get sellerBulkStockTab => 'Stock';

  @override
  String get sellerBulkSave => 'Save changes';

  @override
  String get sellerBulkDiscard => 'Discard';

  @override
  String sellerBulkPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes',
      one: '1 change',
    );
    return '$_temp0';
  }

  @override
  String sellerBulkSaved(int saved, int skipped) {
    return '$saved saved, $skipped skipped';
  }

  @override
  String get sellerBulkSavedSuccess => 'Fiyatlar başarıyla kaydedildi.';

  @override
  String get sellerBulkNoPermission =>
      'Your role does not include bulk editing.';

  @override
  String sellerBulkSelected(int count, int total) {
    return '$count of $total selected';
  }

  @override
  String get sellerBulkSelectAll => 'Select all';

  @override
  String get sellerBulkAction => 'Action';

  @override
  String get sellerBulkValue => 'Value';

  @override
  String get sellerBulkApply => 'Apply';

  @override
  String get sellerBulkSetTo => 'Set to';

  @override
  String get sellerBulkIncreaseBy => 'Increase by';

  @override
  String get sellerBulkDecreaseBy => 'Decrease by';

  @override
  String get sellerBulkQuantity => 'Quantity';

  @override
  String get sellerBulkMode => 'Mode';

  @override
  String get sellerBulkTiers => 'Customer group prices';

  @override
  String get sellerBulkTiersNotice =>
      'What this product holds now. Saving replaces every group price it has.';

  @override
  String get sellerBulkTierAllGroups => 'All groups';

  @override
  String get sellerBulkTierAdd => 'Add group price';

  @override
  String get sellerBulkTierGroup => 'Customer group';

  @override
  String get sellerBulkTierFixed => 'Fixed';

  @override
  String get sellerBulkTierDiscount => 'Discount (%)';

  @override
  String get sellerBulkAmount => 'Amount';

  @override
  String get sellerBulkPercent => 'Percent (%)';

  @override
  String get sellerBulkActivate => 'Activate';

  @override
  String get sellerBulkDeactivate => 'Deactivate';

  @override
  String get sellerImportsMenu => 'Bulk upload';

  @override
  String get sellerImportsTitle => 'Bulk upload';

  @override
  String get sellerImportsEmpty => 'No uploads yet';

  @override
  String get sellerImportsNoPermission =>
      'Your role does not include bulk upload.';

  @override
  String get sellerImportsSamples => 'Starter spreadsheets';

  @override
  String get sellerImportsUpload => 'Upload sheet';

  @override
  String get sellerImportOwnTitle => 'List your own products';

  @override
  String get sellerImportCatalogueTitle => 'Sell catalogue products';

  @override
  String get sellerImportOwnBlurb =>
      'Bulk create new products in your catalogue from a spreadsheet.';

  @override
  String get sellerImportCatalogueBlurb =>
      'Add products already in the marketplace catalogue to your store, at your own price and stock.';

  @override
  String get sellerImportSource => 'Source';

  @override
  String get sellerImportSourceHelp => 'Choose the file to import.';

  @override
  String get sellerImportRequiredColumns =>
      'Every row must fill in these columns';

  @override
  String get sellerImportCatalogueSheetHelp =>
      'Each row needs the catalogue product SKU plus your selling details: price, stock quantity, condition and an optional description. Images come from the catalogue product.';

  @override
  String get sellerImportFile => 'Spreadsheet';

  @override
  String get sellerImportImages => 'Images';

  @override
  String get sellerImportImagesHelp =>
      'Optional. A flat zip whose file names match the sheet’s images column. Rows that name images by URL need no zip.';

  @override
  String get sellerImportImagesZip => 'Images zip';

  @override
  String get sellerImportSettings => 'Settings';

  @override
  String get sellerImportSettingsHelp =>
      'How strictly the sheet is read, and how it is run.';

  @override
  String get sellerImportAction => 'Action';

  @override
  String get sellerImportValidation => 'Bad rows';

  @override
  String get sellerImportAllowedErrors => 'Errors allowed';

  @override
  String get sellerImportEditSettings => 'Edit settings';

  @override
  String get sellerImportReimport => 'Reimport';

  @override
  String get sellerImportEditResets =>
      'Changing these resets the job, so the sheet is read again from the start.';

  @override
  String get sellerImportCurrentSheet => 'Current uploaded file';

  @override
  String get sellerImportNewSheet => 'New file selected';

  @override
  String get sellerImportConfirmTitle => 'Are you sure?';

  @override
  String get sellerImportConfirmMessage =>
      'This will validate your file and start the import. Do you want to continue?';

  @override
  String get sellerImportDownloadFile => 'Download the sheet';

  @override
  String get sellerImportSeparator => 'Column separator';

  @override
  String get sellerImportQueue => 'Run in the background';

  @override
  String get sellerImportQueueHelp =>
      'Hands the whole run to the queue worker. Needs a queue configured on the server.';

  @override
  String get sellerImportBack => 'Back';

  @override
  String get sellerImportNext => 'Next';

  @override
  String get sellerImportStart => 'Upload';

  @override
  String get sellerImportChoose =>
      'Choose how you want to add products in bulk.';

  @override
  String get sellerImportPastUploads => 'Past uploads';

  @override
  String get sellerImportReportTitle => 'Result';

  @override
  String get sellerImportCreated => 'Created';

  @override
  String get sellerImportUpdated => 'Updated';

  @override
  String get sellerImportRemoved => 'Removed';

  @override
  String get sellerImportSkipped => 'Skipped';

  @override
  String get sellerImportImagesFetched => 'Images';

  @override
  String get sellerImportDeleteSelected => 'Delete selected';

  @override
  String get sellerDownloadStarted => 'Downloading…';

  @override
  String get sellerDownloadFailed => 'That file could not be downloaded';

  @override
  String get sellerDownloadNoApp => 'No app on this device can open that file';

  @override
  String get sellerImportsRun => 'Run';

  @override
  String sellerImportsNextStep(String step) {
    return 'Next: $step';
  }

  @override
  String get sellerImportsFinished => 'Finished';

  @override
  String get sellerImportProcessTitle => 'Import';

  @override
  String get sellerImportReady => 'Validate the file to check your import.';

  @override
  String get sellerImportValidateAction => 'Validate';

  @override
  String get sellerImportValidating => 'Reading and validating your file…';

  @override
  String sellerImportRowsValidated(int processed, int total) {
    return '$processed / $total rows validated';
  }

  @override
  String get sellerImportDownloadingImages => 'Downloading product images…';

  @override
  String sellerImportImagesProgress(int processed, int total) {
    return '$processed / $total images downloaded';
  }

  @override
  String get sellerImportCreating => 'Creating your products…';

  @override
  String get sellerImportAssigning => 'Adding the products to your store…';

  @override
  String get sellerImportDeleting => 'Deleting your products…';

  @override
  String get sellerImportLinking => 'Connecting related products…';

  @override
  String get sellerImportIndexing => 'Finalising prices and stock…';

  @override
  String get sellerImportValid =>
      'Your file is valid. Start the import when you are ready.';

  @override
  String get sellerImportPartly =>
      'Some rows have errors and will be skipped. The rest can still be imported.';

  @override
  String get sellerImportInvalid =>
      'This file cannot be imported. Fix the errors below and upload it again.';

  @override
  String get sellerImportStartAction => 'Start import';

  @override
  String get sellerImportContinueAction => 'Import the rest';

  @override
  String get sellerImportRowsProcessed => 'Rows read';

  @override
  String get sellerImportRowsInvalid => 'Invalid rows';

  @override
  String get sellerImportErrorCount => 'Errors';

  @override
  String get sellerImportFinished => 'Your import finished.';

  @override
  String get sellerImportFullReport => 'Download full report';

  @override
  String get sellerImportActionAppend => 'Create / update';

  @override
  String get sellerImportActionDelete => 'Delete';

  @override
  String get sellerImportReplaceSheet => 'Replace the sheet';

  @override
  String get sellerImportReplaceImages => 'Replace the images zip';

  @override
  String sellerImportFileChosen(String name) {
    return 'New file: $name';
  }

  @override
  String get sellerImportRecordsCreated => 'Created';

  @override
  String get sellerImportRecordsUpdated => 'Updated';

  @override
  String get sellerImportRecordsDeleted => 'Deleted';

  @override
  String get sellerImportStagePending => 'Uploaded';

  @override
  String get sellerImportStageValidated => 'Checked';

  @override
  String get sellerImportStageProcessed => 'Imported';

  @override
  String get sellerImportStageLinked => 'Linked';

  @override
  String get sellerImportStageIndexed => 'Live';

  @override
  String sellerImportsRows(int processed, int invalid) {
    return '$processed rows, $invalid invalid';
  }

  @override
  String get sellerImportsErrorReport => 'Download error report';

  @override
  String get sellerSettingsMenu => 'Settings';

  @override
  String get sellerSettingsTitle => 'Settings';

  @override
  String get sellerSettingsGeneralUpdatedSuccessfully =>
      'General settings updated successfully';

  @override
  String get sellerSettingsPreferences => 'Preferences';

  @override
  String get sellerSettingsLanguage => 'Language';

  @override
  String get sellerSettingsCurrency => 'Currency';

  @override
  String get sellerSettingsEmailNotifications => 'Email me about messages';

  @override
  String get sellerSettingsPassword => 'Change password';

  @override
  String get sellerSettingsCurrentPassword => 'Current password';

  @override
  String get sellerSettingsNewPassword => 'New password';

  @override
  String get sellerSettingsConfirmPassword => 'Confirm password';

  @override
  String get sellerSettingsNewPasswordRequired =>
      'The new password field is required when current password is present.';

  @override
  String get sellerSettingsConfirmPasswordRequired =>
      'The new password confirmation field is required when new password is present.';

  @override
  String get sellerSettingsPasswordMismatch =>
      'The new password field confirmation does not match.';

  @override
  String get sellerSettingsStaff => 'Staff';

  @override
  String get sellerSettingsStaffEmpty => 'No staff members yet';

  @override
  String get sellerSettingsAddStaff => 'Create User';

  @override
  String get sellerSettingsEditStaff => 'Edit User';

  @override
  String get sellerSettingsUserNameRequired => 'The name field is required';

  @override
  String get sellerSettingsUserEmailRequired => 'The email field is required';

  @override
  String get sellerSettingsUserPhoneRequired =>
      'The Phone Number field is required';

  @override
  String get sellerSettingsUserPasswordRequired =>
      'The password field is required';

  @override
  String get sellerSettingsUserConfirmPasswordRequired =>
      'The Confirm Password field is required';

  @override
  String get sellerSettingsUserPasswordMismatch =>
      'The password confirmation does not match';

  @override
  String get sellerSettingsRoles => 'Roles';

  @override
  String get sellerSettingsSelectRole => 'Select Role';

  @override
  String get sellerSettingsRoleRequired => 'The Role field is required';

  @override
  String get sellerSettingsRolesEmpty => 'No roles yet';

  @override
  String get sellerSettingsAddRole => 'Add role';

  @override
  String get sellerSettingsEditRole => 'Edit Role';

  @override
  String get sellerSettingsRoleAll => 'Full access';

  @override
  String get sellerSettingsRoleCustom => 'Limited access';

  @override
  String get sellerRolePermissions => 'Permissions';

  @override
  String sellerRolePermissionsChosen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
      zero: 'Nothing selected',
    );
    return '$_temp0';
  }

  @override
  String get sellerRolePermissionsSearch => 'Search permissions';

  @override
  String get sellerRolePermissionsNone => 'No permission matches that';

  @override
  String get sellerRolePermissionsEdit => 'Choose permissions';

  @override
  String get sellerRoleNameRequired => 'Give the role a name';

  @override
  String sellerSettingsRoleInUse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count staff members',
      one: '1 staff member',
    );
    return '$_temp0';
  }

  @override
  String get sellerSettingsSuspended => 'Suspended';

  @override
  String get sellerSettingsActive => 'Active';

  @override
  String get sellerSettingsAwaitingApproval => 'Awaiting approval';

  @override
  String get sellerSettingsHealth => 'Account health';

  @override
  String get sellerSettingsHealthRefresh => 'Recalculate';

  @override
  String get sellerSettingsNoPermission =>
      'Your role does not include settings.';

  @override
  String get marketplaceLandingTitle => 'Marketplace';

  @override
  String get marketplaceLandingHeadline => 'Sell on this marketplace';

  @override
  String get marketplaceLandingBlurb =>
      'List your products, manage orders and get paid — from your phone.';

  @override
  String get marketplaceLandingShopAction =>
      'Just browsing? Shop the marketplace';

  @override
  String get marketplaceLandingWhyHeading => 'Why sell with us?';

  @override
  String get marketplaceLandingWhyBlurb =>
      'Everything you need to run a marketplace store, from your phone.';

  @override
  String get marketplaceLandingStatSellers => 'Shops trading';

  @override
  String get marketplaceLandingStatListing => 'To list your products';

  @override
  String get marketplaceLandingStatListingValue => 'Free';

  @override
  String get marketplaceLandingStatAlways => 'Open for orders';

  @override
  String get marketplaceLandingStatMobile => 'Run it from';

  @override
  String get marketplaceLandingStatMobileValue => 'Your phone';

  @override
  String get marketplaceLandingStatCommission => 'You keep';

  @override
  String get marketplaceLandingStatCommissionValue => 'Most of it';

  @override
  String get marketplaceLandingReasonCatalogue => 'Your whole catalogue';

  @override
  String get marketplaceLandingReasonCatalogueBlurb =>
      'Add products one at a time or a spreadsheet at a time, with variants, stock and photographs.';

  @override
  String get marketplaceLandingReasonOrders => 'Orders end to end';

  @override
  String get marketplaceLandingReasonOrdersBlurb =>
      'Invoice, ship, track and handle returns without leaving the app.';

  @override
  String get marketplaceLandingReasonPayouts => 'See what you are owed';

  @override
  String get marketplaceLandingReasonPayoutsBlurb =>
      'Every sale, the commission taken and what is still to be paid out.';

  @override
  String get marketplaceLandingReasonInsight => 'Know how it is going';

  @override
  String get marketplaceLandingReasonInsightBlurb =>
      'Sales over time, best sellers, low stock and your best customers.';

  @override
  String get marketplaceLandingSellAction => 'Open Store';

  @override
  String get marketplaceLandingSignInPrompt =>
      'Already have an account? Sign In';

  @override
  String get marketplaceLandingDashboardAction => 'Open dashboard';

  @override
  String get marketplaceLandingVisitShopAction => 'Visit your shop';

  @override
  String get marketplaceLandingShopHeading => 'Shopping';

  @override
  String get marketplaceLandingBrowseBlurb =>
      'Find shops and see what they sell';

  @override
  String get marketplaceLandingMessagesBlurb =>
      'Your conversations with sellers';

  @override
  String get marketplaceLandingStatCommunity => 'Seller Community';

  @override
  String get marketplaceLandingStatOnline => 'Online Business';

  @override
  String get marketplaceLandingStatPaymentDays => 'Days* Payment';

  @override
  String get marketplaceLandingStatPincode => 'Serviceable Pincode';

  @override
  String marketplaceLandingStepLabel(int number) {
    return 'Step $number';
  }

  @override
  String get marketplaceLandingTrustFreeShippingTitle => 'Free Shipping';

  @override
  String get marketplaceLandingTrustFreeShippingBlurb =>
      'Enjoy free shipping on all orders';

  @override
  String get marketplaceLandingTrustReplaceTitle => 'Product Replace';

  @override
  String get marketplaceLandingTrustReplaceBlurb =>
      'Easy Product Replacement Available!';

  @override
  String get marketplaceLandingTrustEmiTitle => 'EMI Available';

  @override
  String get marketplaceLandingTrustEmiBlurb =>
      'No cost EMI available on all major credit cards';

  @override
  String get marketplaceLandingTrustSupportTitle => '24/7 Support';

  @override
  String get marketplaceLandingTrustSupportBlurb =>
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
  String shopSoldByOtherSellers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count other sellers',
      one: '1 other seller',
    );
    return '$_temp0';
  }

  @override
  String shopProductMoreSellers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aynı ürünü satan $count satıcı daha var',
      one: 'Aynı ürünü satan 1 satıcı daha var',
    );
    return '$_temp0';
  }

  @override
  String get shopSoldByReported =>
      'Reported. The marketplace will look into it.';

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
  String get marketplaceFeaturedSellersTitle => 'Our Featured Sellers';

  @override
  String get marketplaceFeaturedSellersSubtitle =>
      'Start selling with large customer around the world, round the clock.';

  @override
  String get shopSellersMenu => 'Browse sellers';

  @override
  String get shopSellersTitle => 'Sellers';

  @override
  String get shopSellersSearchHint => 'Search sellers';

  @override
  String get shopSellersEmpty => 'No sellers found';

  @override
  String get shopSellerLinkFailed => 'That link could not be opened';

  @override
  String get shopSellerProducts => 'Products';

  @override
  String get shopSellerReviews => 'Reviews';

  @override
  String get shopSellerAbout => 'About';

  @override
  String get shopSellerPolicies => 'Policies';

  @override
  String get shopSellerReturnPolicy => 'Returns';

  @override
  String get shopSellerShippingPolicy => 'Shipping';

  @override
  String get shopSellerPrivacyPolicy => 'Privacy';

  @override
  String get shopSellerContact => 'Contact Seller';

  @override
  String get shopSellerReport => 'Report this seller';

  @override
  String get shopSellerWriteReview => 'Write a review';

  @override
  String get shopSellerNoReviews => 'No reviews yet';

  @override
  String get shopSellerNoProducts => 'Nothing for sale right now';

  @override
  String shopSellerSince(String date) {
    return 'Selling since $date';
  }

  @override
  String shopSellerOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String get shopOffersTitle => 'Other sellers';

  @override
  String get shopOffersEmpty => 'No other sellers offer this';

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
      'Sign in to see your conversations with sellers';

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
      'Withdraw this request? The seller will no longer see it.';

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
  String get shopReturnFromSeller => 'Marketplace';

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
      'Nothing on this order can be returned. The marketplace decides what is eligible and for how long.';

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
  String get shopMessagesBlocked => 'This seller has turned off replies.';

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
  String get sellerInboxMenu => 'Communication';

  @override
  String get sellerInboxTitle => 'Messages';

  @override
  String get sellerInboxAdmin => 'Admin';

  @override
  String get sellerInboxCustomers => 'Customers';

  @override
  String get sellerInboxEmpty => 'No conversations yet';

  @override
  String get sellerInboxSearchHint => 'Search customers';

  @override
  String get sellerInboxBlocked => 'You have blocked this conversation.';

  @override
  String get sellerInboxAdminBlocked =>
      'The marketplace has turned off replies.';

  @override
  String get sellerInboxBlock => 'Block';

  @override
  String get sellerInboxUnblock => 'Unblock';

  @override
  String get sellerInboxUnreadNote =>
      'Marking as read is not available from the app.';

  @override
  String get sellerInboxNoPermission => 'Your role does not include messages.';

  @override
  String get sellerPlansMenu => 'Plans';

  @override
  String get sellerPlansTitle => 'Plans';

  @override
  String get sellerPlansCurrent => 'Your plan';

  @override
  String get sellerPlansAvailable => 'Available Plans';

  @override
  String get sellerPlansHistory => 'History';

  @override
  String get sellerPlansChoose => 'Choose';

  @override
  String get sellerPlansCancel => 'Cancel subscription';

  @override
  String get sellerPlansUnavailable =>
      'This marketplace does not use paid plans.';

  @override
  String get sellerPlanRequiredTitle => 'A plan is needed';

  @override
  String get sellerPlanRequiredBody =>
      'This marketplace now runs on subscription plans, and your account does not have one yet. Choose a plan to use your dashboard again.';

  @override
  String get sellerPlanRequiredAction => 'See plans';

  @override
  String sellerPlansDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get sellerPlansMaxProducts => 'Products';

  @override
  String get sellerPlansMaxStaff => 'Staff';

  @override
  String get sellerPlansCommission => 'Commission';

  @override
  String get sellerPlansFree => 'Free';

  @override
  String get sellerPickupsMenu => 'Courier collections';

  @override
  String get sellerPickupsTitle => 'Collections';

  @override
  String get sellerPickupsEmpty => 'No collections booked';

  @override
  String get sellerPickupsConfirmation => 'Confirmation';

  @override
  String sellerPickupsPackages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count packages',
      one: '1 package',
    );
    return '$_temp0';
  }

  @override
  String get sellerPickupsNoPermission =>
      'Your role does not include collections.';

  @override
  String get sellerRuleHowItApplies => 'How it applies';

  @override
  String get sellerRuleConditionType => 'Conditions';

  @override
  String get sellerRuleMatchAll => 'Match all';

  @override
  String get sellerRuleMatchAny => 'Match any';

  @override
  String get sellerRulePriority => 'Priority';

  @override
  String get sellerRuleEndOthers => 'Stop other rules';

  @override
  String get sellerRuleEndOthersHelp =>
      'No lower-priority rule applies to a basket this one has matched.';

  @override
  String get sellerRuleBuyQuantity => 'Buy quantity';

  @override
  String get sellerRuleFreeStep => 'Free every';

  @override
  String get sellerOrderBillingAddress => 'Billing address';

  @override
  String get sellerOrderShippingAddress => 'Shipping address';

  @override
  String get sellerOrderShippingMethodLabel => 'Shipping method';

  @override
  String get sellerOrderPaymentMethodLabel => 'Payment method';

  @override
  String get sellerOrderNoAddress => 'The order carries no address';

  @override
  String get sellerProfileLogo => 'Shop logo';

  @override
  String get sellerProfileBanner => 'Shop banner';

  @override
  String get sellerProfileImageChange => 'Change';

  @override
  String get sellerProfileImageRemove => 'Remove';

  @override
  String get sellerProfileImageAdd => 'Add image';

  @override
  String get sellerProfileImageTooLarge =>
      'That image is too large — pick one under 2 MB';

  @override
  String get sellerOrderFilters => 'Filter orders';

  @override
  String get sellerOrderFilterApply => 'Apply';

  @override
  String get sellerOrderFilterClear => 'Clear all';

  @override
  String get sellerOrderFilterStatus => 'Order status';

  @override
  String get sellerOrderFilterFrom => 'Placed from';

  @override
  String get sellerOrderFilterTo => 'Placed to';

  @override
  String get sellerOrderFilterCustomerName => 'Customer name';

  @override
  String get sellerOrderFilterCustomerEmail => 'Customer email';

  @override
  String get sellerOrderFilterLocation => 'Location';

  @override
  String get sellerOrderFilterPaymentMethod => 'Payment method';

  @override
  String get sellerOrderFilterShippingMethod => 'Shipping method';

  @override
  String get sellerOrderFilterProductName => 'Product name';

  @override
  String get sellerOrderFilterItemCount => 'Items in order';

  @override
  String get sellerOrderFilterSellerTotal => 'Your total';

  @override
  String get sellerOrderFilterAny => 'Any';

  @override
  String get sellerOrderWebTitle => 'Apply Filters';

  @override
  String get sellerOrderWebApply => 'Apply Filters';

  @override
  String get sellerOrderWebId => 'Id';

  @override
  String get sellerOrderWebDate => 'Date';

  @override
  String get sellerOrderWebStatus => 'Status';

  @override
  String get sellerOrderWebCustomer => 'Customer';

  @override
  String get sellerOrderWebEmail => 'Email';

  @override
  String get sellerOrderWebItems => 'Items';

  @override
  String get sellerOrderWebPayment => 'Payment';

  @override
  String get sellerOrderWebShipment => 'Shipment';

  @override
  String get sellerOrderWebGross => 'Gross Amt.';

  @override
  String get sellerOrderWebDiscount => 'Discount';

  @override
  String get sellerOrderWebCommission => 'Commission';

  @override
  String get sellerOrderWebSellerEarn => 'Seller Earn';

  @override
  String get sellerOrderWebSelect => 'Select';

  @override
  String get sellerOrderFilterGross => 'Gross amt.';

  @override
  String get sellerOrderFilterSellerEarn => 'Seller earn';

  @override
  String get sellerOrderFilterButton => 'Filters';

  @override
  String get sellerOrderQuickToday => 'Today';

  @override
  String get sellerOrderQuickYesterday => 'Yesterday';

  @override
  String get sellerOrderQuickThisWeek => 'This Week';

  @override
  String get sellerOrderQuickThisMonth => 'This Month';

  @override
  String get sellerOrderQuickLastMonth => 'Last Month';

  @override
  String get sellerOrderQuickLast3Months => 'Last 3 Months';

  @override
  String get sellerOrderQuickLast6Months => 'Last 6 Months';

  @override
  String get sellerOrderQuickThisYear => 'This Year';

  @override
  String get sellerDiscountConditions => 'Conditions';

  @override
  String get sellerDiscountConditionsHelp =>
      'The rule applies only to products matching every condition. With none, it applies to your whole catalogue.';

  @override
  String get sellerDiscountConditionAdd => 'Add condition';

  @override
  String get sellerDiscountConditionAttribute => 'Attribute';

  @override
  String get sellerDiscountConditionOperator => 'Operator';

  @override
  String get sellerDiscountConditionValue => 'Value';

  @override
  String get sellerDiscountConditionRemove => 'Remove condition';

  @override
  String get sellerDiscountConditionChoose => 'Choose a condition to add';

  @override
  String get sellerRuleYes => 'Yes';

  @override
  String get sellerRuleNo => 'No';

  @override
  String get sellerRuleChoose => 'Choose';

  @override
  String get sellerRuleAddMore => 'Add more';

  @override
  String get sellerRuleChannels => 'Channels';

  @override
  String get sellerRuleCustomerGroups => 'Customer groups';

  @override
  String get sellerRuleWhoItAppliesTo => 'Who it applies to';

  @override
  String get sellerRuleNoChannel => 'Pick at least one channel';

  @override
  String get sellerRuleNoCustomerGroup => 'Pick at least one customer group';

  @override
  String get sellerDiscountWebCreateTitle => 'Create Product Discount';

  @override
  String get sellerDiscountWebEditTitle => 'Edit Product Discount';

  @override
  String get sellerDiscountWebSave => 'Save Product Discount';

  @override
  String get sellerDiscountWebHowTitle =>
      'How would you like to discount these products?';

  @override
  String get sellerDiscountWebPercentTitle => 'Percentage off the price';

  @override
  String get sellerDiscountWebPercentHelp =>
      'Take a percentage off every product this discount matches.';

  @override
  String get sellerDiscountWebFixedTitle => 'Fixed amount off the price';

  @override
  String get sellerDiscountWebFixedHelp =>
      'Take a set amount off every product this discount matches.';

  @override
  String get sellerDiscountWebAmount => 'Discount Amount';

  @override
  String get sellerDiscountWebNameTitle =>
      'What should this discount be called?';

  @override
  String get sellerDiscountWebName => 'Name';

  @override
  String get sellerDiscountWebDescription => 'Description';

  @override
  String get sellerDiscountWebWhenTitle => 'When should it run?';

  @override
  String get sellerDiscountWebStartsFrom => 'Starts From';

  @override
  String get sellerDiscountWebEndsTill => 'Ends Till';

  @override
  String get sellerDiscountWebMatchTitle => 'Which products should it match?';

  @override
  String get sellerDiscountWebConditionType => 'Condition Type';

  @override
  String get sellerDiscountWebAllTrue => 'All Conditions Are True';

  @override
  String get sellerDiscountWebAnyTrue => 'Any Condition Is True';

  @override
  String get sellerDiscountWebAddCondition => 'Add Condition';

  @override
  String get sellerDiscountWebSettings => 'Settings';

  @override
  String get sellerDiscountWebChannels => 'Channels';

  @override
  String get sellerDiscountWebCustomerGroups => 'Customer Groups';

  @override
  String get sellerDiscountWebPriority => 'Priority';

  @override
  String get sellerDiscountWebStopFurther => 'Stop Further Rules';

  @override
  String get sellerDiscountWebStopFurtherHelp =>
      'Once this rule applies, stop applying your other rules with a greater priority number.';

  @override
  String get sellerDiscountWebStatus => 'Status';

  @override
  String get sellerDiscountWebNameRequired => 'The Name field is required';

  @override
  String get sellerDiscountWebAmountRequired =>
      'The Discount Amount field is required';

  @override
  String get sellerDiscountWebAmountInvalid =>
      'The Discount Amount must be a number of 0 or more';

  @override
  String get sellerDiscountWebPercentMax =>
      'A percentage cannot be more than 100';

  @override
  String get sellerDiscountWebPriorityInvalid =>
      'The Priority must be a whole number of 0 or more';

  @override
  String get sellerDiscountWebEndBeforeStart =>
      'Ends Till cannot be before Starts From';

  @override
  String get sellerJoinDetailTitle => 'Discount details';

  @override
  String get sellerJoinDetailGeneral => 'General';

  @override
  String get sellerJoinDetailActions => 'Actions';

  @override
  String get sellerJoinDetailSettings => 'Settings';

  @override
  String get sellerJoinDetailTime => 'Marketing time';

  @override
  String get sellerJoinDetailNoConditions =>
      'No conditions — this rule applies to all matching products.';

  @override
  String get sellerJoinDetailDiscountType => 'Discount type';

  @override
  String get sellerJoinDetailDiscountAmount => 'Discount amount';

  @override
  String get sellerJoinDetailStopRules => 'Stop further rules';

  @override
  String get sellerJoinDetailStopRulesHelp =>
      'Once this rule applies, your other rules with a greater priority number stop applying.';

  @override
  String get sellerJoinDetailPriority => 'Priority';

  @override
  String get sellerJoinDetailStatus => 'Status';

  @override
  String get sellerJoinDetailStartsFrom => 'Starts from';

  @override
  String get sellerJoinDetailEndsTill => 'Ends till';

  @override
  String get sellerJoinDetailView => 'View';

  @override
  String get sellerProductVariantsFailed =>
      'Could not load the attributes for this family';

  @override
  String get sellerProductVariantsNone =>
      'This attribute family has nothing that can vary';

  @override
  String get sellerProductVariantsRetry => 'Try again';

  @override
  String get sellerProductVariesWhich => 'Which attributes will vary?';

  @override
  String get sellerProductVariesNeedsOption =>
      'An attribute you ticked carries no options to vary by';

  @override
  String get sellerProductKindLabel => 'What kind of product are you selling?';

  @override
  String get sellerProductKindSimple => 'Physical product';

  @override
  String get sellerProductKindSimpleHelp =>
      'A tangible item you ship to the customer.';

  @override
  String get sellerProductKindVirtual => 'Service or membership';

  @override
  String get sellerProductKindVirtualHelp =>
      'An intangible offering with no shipping.';

  @override
  String get sellerProductKindDownloadable => 'Digital download';

  @override
  String get sellerProductKindDownloadableHelp =>
      'A downloadable file such as an e-book or software.';

  @override
  String get sellerProductKindBooking => 'Bookable';

  @override
  String get sellerProductKindBookingHelp =>
      'A product customers reserve for a date or time.';

  @override
  String get sellerProductKindBundle => 'Bundle';

  @override
  String get sellerProductKindBundleHelp =>
      'Several products sold together as one package.';

  @override
  String get sellerProductKindGrouped => 'Grouped products';

  @override
  String get sellerProductKindGroupedHelp =>
      'A set of related products shown together.';

  @override
  String get sellerProductHasVariations => 'Does this product have variations?';

  @override
  String get sellerProductHasVariationsHelp =>
      'Each combination you pick becomes its own variant.';

  @override
  String get sellerProductTabVariants => 'Variants';

  @override
  String get sellerProductTabLinked => 'Linked products';

  @override
  String get sellerProductTabBundle => 'Bundle items';

  @override
  String get sellerProductTabDownloads => 'Downloads';

  @override
  String get sellerProductTabBooking => 'Booking';

  @override
  String get sellerLblStatusPending => 'Pending';

  @override
  String get sellerLblStatusPendingPayment => 'Pending payment';

  @override
  String get sellerLblStatusProcessing => 'Processing';

  @override
  String get sellerLblStatusCompleted => 'Completed';

  @override
  String get sellerLblStatusCanceled => 'Canceled';

  @override
  String get sellerLblStatusClosed => 'Closed';

  @override
  String get sellerLblStatusFraud => 'Fraud';

  @override
  String get sellerLblStatusRefunded => 'Refunded';

  @override
  String get sellerLblStatusOnHold => 'On hold';

  @override
  String get sellerLblStatusApproved => 'Approved';

  @override
  String get sellerLblStatusRejected => 'Rejected';

  @override
  String get sellerLblStatusDraft => 'Draft';

  @override
  String get sellerLblStatusActive => 'Active';

  @override
  String get sellerLblStatusInactive => 'Inactive';

  @override
  String get sellerLblStatusPaid => 'Paid';

  @override
  String get sellerLblStatusRequested => 'Requested';

  @override
  String get sellerLblStatusDisapproved => 'Disapproved';

  @override
  String get sellerLblTypeSimple => 'Simple';

  @override
  String get sellerLblTypeVirtual => 'Virtual';

  @override
  String get sellerLblTypeConfigurable => 'Configurable';

  @override
  String get sellerLblTypeGrouped => 'Grouped';

  @override
  String get sellerLblTypeBundle => 'Bundle';

  @override
  String get sellerLblTypeDownloadable => 'Downloadable';

  @override
  String get sellerLblTypeBooking => 'Booking';

  @override
  String get sellerHcOrdersPlaced => 'Placed';

  @override
  String get sellerHcOrdersQty => 'Qty';

  @override
  String sellerHcOrdersPriceEach(String price) {
    return '$price each';
  }

  @override
  String get sellerHcOrdersPayoutStatus => 'Payout status';

  @override
  String sellerHcOrdersSkuMax(String sku, int max) {
    return '$sku · max $max';
  }

  @override
  String get sellerHcOrdersLengthShort => 'L';

  @override
  String get sellerHcOrdersWidthShort => 'W';

  @override
  String get sellerHcOrdersHeightShort => 'H';

  @override
  String get sellerHcOrdersCarrierManual => 'Manual';

  @override
  String sellerHcPlansWeightKg(String weight) {
    return '$weight kg';
  }

  @override
  String get sellerHcPlansUnlimited => 'Unlimited';

  @override
  String get sellerHcEarningsTypeCredit => 'Credit';

  @override
  String get sellerHcEarningsTypeDebit => 'Debit';

  @override
  String get sellerHcReportingAverageSales => 'Average sales';

  @override
  String get sellerHcReportingTotalOrders => 'Total orders';

  @override
  String get sellerHcReportingPurchaseFunnel => 'Purchase funnel';

  @override
  String get sellerHcReportingAbandonedCarts => 'Abandoned carts';

  @override
  String get sellerHcReportingTaxCollected => 'Tax collected';

  @override
  String get sellerHcReportingShippingCollected => 'Shipping collected';

  @override
  String get sellerHcReportingTopPaymentMethods => 'Top payment methods';

  @override
  String get sellerHcReportingTopSellingProducts => 'Top selling products';

  @override
  String get sellerHcReportingSoldProductsQuantity => 'Sold products quantity';

  @override
  String get sellerHcReportingProductsAddedToWishlist =>
      'Products added to wishlist';

  @override
  String get sellerHcReportingProductsWithMostReviews =>
      'Products with most reviews';

  @override
  String get sellerHcReportingProductsWithMostVisits =>
      'Products with most visits';

  @override
  String get sellerHcReportingLastSearchTerms => 'Last search terms';

  @override
  String get sellerHcReportingTopSearchTerms => 'Top search terms';

  @override
  String get sellerHcReportingCustomersTraffic => 'Customers traffic';

  @override
  String get sellerHcReportingCustomersWithMostSales =>
      'Customers with most sales';

  @override
  String get sellerHcReportingCustomersWithMostOrders =>
      'Customers with most orders';

  @override
  String get sellerHcReportingCustomersWithMostReviews =>
      'Customers with most reviews';

  @override
  String get sellerHcReportingTopCustomerGroups => 'Top customer groups';

  @override
  String get sellerHcReportingFunnelVisitors => 'Visitors';

  @override
  String get sellerHcReportingFunnelProductViews => 'Product views';

  @override
  String get sellerHcReportingFunnelAddedToCart => 'Added to cart';

  @override
  String get sellerHcProductsNoneAvailable => 'None available';

  @override
  String get sellerHcProductsCustomizableItem => 'Customizable Item';

  @override
  String get sellerHcProductsAddOption => 'Add Option';

  @override
  String get sellerHcProductsNoOptions =>
      'No options yet. Add one to let buyers customize this product.';

  @override
  String get sellerHcProductsOptional => 'Optional';

  @override
  String sellerHcProductsChoiceCount(int count) {
    return '$count choice(s)';
  }

  @override
  String sellerHcProductsPriceValue(String price) {
    return 'Price $price';
  }

  @override
  String get sellerHcProductsTitleRequired => 'Title is required.';

  @override
  String get sellerHcProductsAddOneChoice => 'Add at least one choice.';

  @override
  String get sellerHcProductsOption => 'Option';

  @override
  String get sellerHcProductsTitleStar => 'Title *';

  @override
  String get sellerHcProductsTypeStar => 'Type *';

  @override
  String get sellerHcProductsIsRequiredStar => 'Is Required *';

  @override
  String get sellerHcProductsMaxCharacters => 'Max characters';

  @override
  String get sellerHcProductsMaxCharactersStar => 'Max Characters *';

  @override
  String get sellerHcProductsFileExtensions => 'Supported file extensions';

  @override
  String get sellerHcProductsFileExtensionsStar =>
      'Supported File Extensions *';

  @override
  String get sellerHcProductsPriceStar => 'Price *';

  @override
  String get sellerHcProductsLabelStar => 'Label *';

  @override
  String get sellerHcProductsTitleRequiredError =>
      'The Title field is required.';

  @override
  String get sellerHcProductsMaxCharactersRequired =>
      'The Max Characters field is required.';

  @override
  String get sellerHcProductsExtensionsRequired =>
      'The Supported File Extensions field is required.';

  @override
  String get sellerHcProductsPriceRequired => 'The Price field is required.';

  @override
  String get sellerHcProductsLabelRequired => 'The Label field is required.';

  @override
  String get sellerHcProductsAddChoiceCombinations =>
      'To create various combination of product on a go.';

  @override
  String get sellerHcProductsAddOptionOnGo =>
      'To create customizable options on a go.';

  @override
  String get sellerHcProductsChoices => 'Choices';

  @override
  String get sellerHcProductsAddChoice => 'Add choice';

  @override
  String get sellerHcProductsLabel => 'Label';

  @override
  String get sellerHcProductsOptTypeText => 'Text';

  @override
  String get sellerHcProductsOptTypeTextarea => 'Text area';

  @override
  String get sellerHcProductsOptTypeCheckbox => 'Checkbox';

  @override
  String get sellerHcProductsOptTypeRadio => 'Radio';

  @override
  String get sellerHcProductsOptTypeSelect => 'Select';

  @override
  String get sellerHcProductsOptTypeMultiselect => 'Multiselect';

  @override
  String get sellerHcProductsOptTypeDate => 'Date';

  @override
  String get sellerHcProductsOptTypeDatetime => 'Date & time';

  @override
  String get sellerHcProductsOptTypeTime => 'Time';

  @override
  String get sellerHcProductsOptTypeFile => 'File';

  @override
  String get sellerHcProductsUnsavedChanges => 'Unsaved changes';

  @override
  String get sellerHcProductsSwitchLocaleWarning =>
      'Switching language discards what you changed and have not saved.';

  @override
  String get sellerHcProductsStay => 'Stay';

  @override
  String get sellerHcProductsSwitch => 'Switch';

  @override
  String sellerHcProductsFieldRequired(String label) {
    return '$label is required';
  }

  @override
  String sellerHcProductsEnterValid(String label) {
    return 'Enter a valid $label';
  }

  @override
  String sellerHcProductsVariantsError(String message) {
    return 'Variants: $message';
  }

  @override
  String get sellerHcProductsRelatedDefaultLanguage =>
      'Changes to these product links apply across all languages.';

  @override
  String get sellerHcProductsTabInventory => 'Inventory';

  @override
  String get sellerHcProductsTabMedia => 'Media';

  @override
  String get sellerHcProductsTabOrganization => 'Organization';

  @override
  String get sellerHcTypesAdd => 'Add';

  @override
  String get sellerHcTypesAddSlot => 'Add slot';

  @override
  String get sellerHcTypesAddTicket => 'Add ticket';

  @override
  String get sellerHcTypesAvailableFrom => 'Available from';

  @override
  String get sellerHcTypesAvailableTo => 'Available to';

  @override
  String get sellerHcTypesBookingAppointment => 'Appointment Booking';

  @override
  String get sellerHcTypesBookingDefault => 'Default Booking';

  @override
  String get sellerHcTypesBookingEvent => 'Event Booking';

  @override
  String get sellerHcTypesBookingRental => 'Rental Booking';

  @override
  String get sellerHcTypesBookingTable => 'Table Booking';

  @override
  String get sellerHcTypesBookingInformation => 'Booking Information';

  @override
  String get sellerHcTypesBookingType => 'Booking type';

  @override
  String get sellerHcTypesBreakTime => 'Break Time b/w Slots (Mins)';

  @override
  String get sellerHcTypesBundleOptionEmpty =>
      'Add at least one product, or this option sells nothing.';

  @override
  String get sellerHcTypesChargedPer => 'Charged Per';

  @override
  String get sellerHcTypesChooseFile => 'Choose file';

  @override
  String get sellerHcTypesDailyAndHourly => 'Both (Daily and Hourly Basis)';

  @override
  String get sellerHcTypesDailyBasis => 'Daily Basis';

  @override
  String get sellerHcTypesDailyPrice => 'Daily Price';

  @override
  String get sellerHcTypesDay => 'Day';

  @override
  String get sellerHcTypesDownloadAllowed => 'Download allowed';

  @override
  String get sellerHcTypesEveryWeek => 'Available every week';

  @override
  String get sellerHcTypesFile => 'File';

  @override
  String get sellerHcTypesFileType => 'File type';

  @override
  String get sellerHcTypesFileUrl => 'File URL';

  @override
  String get sellerHcTypesFriday => 'Friday';

  @override
  String get sellerHcTypesGuest => 'Guest';

  @override
  String get sellerHcTypesGuestCapacity => 'Guest Capacity';

  @override
  String get sellerHcTypesGuestLimitPerTable => 'Guest Limit Per Table';

  @override
  String get sellerHcTypesHourlyBasis => 'Hourly Basis';

  @override
  String get sellerHcTypesHourlyPrice => 'Hourly Price';

  @override
  String get sellerHcTypesManyBookingsOneDay => 'Many Bookings For One Day';

  @override
  String get sellerHcTypesMonday => 'Monday';

  @override
  String get sellerHcTypesNoFileChosen => 'No file chosen';

  @override
  String get sellerHcTypesNoVariants => 'No variants found for this product.';

  @override
  String get sellerHcTypesOneBookingManyDays => 'One Booking For Many Days';

  @override
  String get sellerHcTypesOptionLabel => 'Option label';

  @override
  String get sellerHcTypesPickDate => 'Pick a date';

  @override
  String get sellerHcTypesPreventBefore => 'Prevent Scheduling Before';

  @override
  String get sellerHcTypesQty => 'Qty';

  @override
  String get sellerHcTypesRentingType => 'Renting Type';

  @override
  String get sellerHcTypesSameSlot => 'Same slot for all days';

  @override
  String get sellerHcTypesSampleType => 'Sample type';

  @override
  String get sellerHcTypesSampleUrl => 'Sample URL';

  @override
  String get sellerHcTypesSaturday => 'Saturday';

  @override
  String get sellerHcTypesSlotDuration => 'Slot Duration (Mins)';

  @override
  String get sellerHcTypesSunday => 'Sunday';

  @override
  String get sellerHcTypesThursday => 'Thursday';

  @override
  String get sellerHcTypesTuesday => 'Tuesday';

  @override
  String get sellerHcTypesTypeCheckbox => 'Checkbox';

  @override
  String get sellerHcTypesTypeMultiselect => 'Multiselect';

  @override
  String get sellerHcTypesTypeRadio => 'Radio';

  @override
  String get sellerHcTypesTypeSelect => 'Select';

  @override
  String get sellerHcTypesUrl => 'URL';

  @override
  String get sellerHcTypesValidUntil => 'Valid until';

  @override
  String get sellerHcTypesWednesday => 'Wednesday';

  @override
  String get sellerHcTypesFromDay => 'From Day';

  @override
  String get sellerHcTypesToDay => 'To Day';

  @override
  String get sellerHcTypesStatus => 'Status';

  @override
  String get sellerHcTypesStatusOpen => 'Open';

  @override
  String get sellerHcTypesStatusClose => 'Close';

  @override
  String get sellerHcTypesUnavailable => 'Unavailable';

  @override
  String get sellerHcTypesSlotsTimeDuration => 'Slots Time Duration';

  @override
  String get sellerHcTypesSlotsTimeDurationDesc =>
      'According to slots the time duration will be created and visible on the storefront.';

  @override
  String get sellerHcTypesSlotEndAfterStart =>
      'End time must be after start time.';

  @override
  String get sellerHcTypesSlotOverlap =>
      'Time slots on the same day cannot overlap.';

  @override
  String get sellerHcTypesNoSlotsAdded =>
      'No slots added yet. Tap \'Add Slot\' to set up slot time duration.';

  @override
  String get sellerHcTypesWeeklySchedule => 'Weekly Schedule';

  @override
  String sellerHcTypesProductNumber(int id) {
    return 'Product #$id';
  }

  @override
  String get sellerHcMarketingDatePlaceholder => 'dd/mm/yyyy';

  @override
  String sellerHcMarketingCouponsCount(int count) {
    return '$count codes';
  }

  @override
  String get sellerHcMarketingActionPercentOrder => 'Percentage off the order';

  @override
  String get sellerHcMarketingActionFixedOrder => 'Fixed amount off the order';

  @override
  String get sellerHcMarketingActionFixedItem => 'Fixed amount off each item';

  @override
  String get sellerHcMarketingActionBuyXGetY => 'Buy X, get Y free';

  @override
  String get sellerHcMarketingActionPercentPrice =>
      'Percentage of product price';

  @override
  String get sellerHcMarketingActionFixedPrice =>
      'Fixed amount off product price';

  @override
  String get sellerHcMarketingImportActionUpdate => 'Update';

  @override
  String get sellerHcMarketingValidationSkip => 'Skip bad rows';

  @override
  String get sellerHcMarketingValidationStop => 'Stop on the first bad row';

  @override
  String get sellerHcMarketingValidationStopShort => 'Stop on the first';

  @override
  String get sellerHcMarketingSeparatorComma => 'Comma';

  @override
  String get sellerHcMarketingSeparatorSemicolon => 'Semicolon';

  @override
  String get sellerHcMarketingSeparatorPipe => 'Pipe';

  @override
  String get sellerHcAftersalesResolutionReturn => 'Return';

  @override
  String get sellerHcAftersalesResolutionCancelItems => 'Cancel items';

  @override
  String get sellerHcAftersalesAttachment => 'Attachment';

  @override
  String sellerHcAftersalesWeekHeader(int week, String month, String year) {
    return 'Week $week ($month $year)';
  }

  @override
  String get sellerHcCommsAttachment => 'Attachment';

  @override
  String get sellerHcShopAttachment => 'Attachment';

  @override
  String get sellerHcShopYourEmail => 'Your email';

  @override
  String get sellerHcShopSubject => 'Subject';

  @override
  String get sellerHcAccountUnsavedChanges => 'Unsaved changes';

  @override
  String get sellerHcAccountSwitchLanguageWarning =>
      'Switching language discards what you changed and have not saved.';

  @override
  String get sellerHcAccountStay => 'Stay';

  @override
  String get sellerHcAccountSwitch => 'Switch';

  @override
  String get sellerHcSettingsLeaveBlankToKeep => 'Leave blank to keep';

  @override
  String get sellerReturnRowRmaId => 'RMA ID';

  @override
  String get sellerReturnRowOrderId => 'Order ID';

  @override
  String get sellerReturnRowCustomer => 'Customer Name';

  @override
  String get sellerReturnRowStatus => 'RMA Status';

  @override
  String get sellerReturnRowGuest => 'Guest';

  @override
  String get sellerReturnRowOrderStatus => 'Order Status';

  @override
  String get sellerReturnRowDate => 'Date';

  @override
  String get sellerReturnYes => 'Yes';

  @override
  String get sellerReturnNo => 'No';

  @override
  String get sellerReturnDelivered => 'Delivered';

  @override
  String get sellerReturnUndelivered => 'Undelivered';

  @override
  String get sellerReturnSectionGeneral => 'General';

  @override
  String get sellerReturnSectionStatus => 'Status';

  @override
  String get sellerReturnSectionItems => 'Items';

  @override
  String get sellerReturnSectionOrder => 'Order Details';

  @override
  String get sellerReturnSectionCustomer => 'Customer Details';

  @override
  String get sellerReturnItemPrice => 'Price';

  @override
  String get sellerReturnItemRmaQty => 'RMA Qty';

  @override
  String get sellerReturnItemOrderQty => 'Order Qty';

  @override
  String get sellerReturnItemResolution => 'Resolution Type';

  @override
  String get sellerReturnOrderTotal => 'Order Total';

  @override
  String get sellerReturnOrderDate => 'Order Date';

  @override
  String get sellerReturnPaymentMethod => 'Payment Method';

  @override
  String sellerReturnRequestTitle(int id) {
    return 'RMA Request #$id';
  }

  @override
  String get sellerReturnAddAttachment => 'Attachments';

  @override
  String get sellerReturnAttachmentUnreadable => 'That file could not be read.';

  @override
  String get sellerDashboardHealthy => 'Healthy';

  @override
  String get sellerDashboardAtRisk => 'At Risk';

  @override
  String get sellerDashboardUnhealthy => 'Unhealthy';

  @override
  String sellerHealthUpdated(String ago) {
    return 'Last updated $ago';
  }

  @override
  String get sellerHealthJustNow => 'just now';

  @override
  String sellerHealthMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String sellerHealthHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String sellerHealthDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get sellerHealthNotCalculated => 'Not calculated';

  @override
  String get sellerHealthNotCalculatedTitle => 'Not Calculated';

  @override
  String get sellerHealthRefreshNow => 'Refresh now';

  @override
  String get sellerHealthOverall => 'Overall Health';

  @override
  String get sellerHealthStandingGood => 'Your account is in good standing.';

  @override
  String get sellerHealthStandingRisk => 'Your account needs attention.';

  @override
  String get sellerHealthStandingBad =>
      'Your account is at risk. Improve your metrics.';

  @override
  String get sellerHealthScoreTitle => 'Health Score';

  @override
  String get sellerHealthGood => 'Good';

  @override
  String get sellerHealthWarning => 'Warning';

  @override
  String get sellerHealthCritical => 'Critical';

  @override
  String get sellerHealthCancellationTitle => 'Order Cancellation Rate';

  @override
  String sellerHealthCancellationDesc(int days) {
    return 'Cancelled units over the last $days days.';
  }

  @override
  String sellerHealthCancellationTarget(String value) {
    return 'Target: below $value%';
  }

  @override
  String get sellerHealthCancellationHelp =>
      'Share of ordered units you cancelled. Keep it low to stay in good standing.';

  @override
  String get sellerHealthFeedbackTitle => 'Customer Feedback';

  @override
  String get sellerHealthFeedbackDesc => 'Your average customer rating.';

  @override
  String sellerHealthFeedbackTarget(String value) {
    return 'Target: $value and above';
  }

  @override
  String get sellerHealthFeedbackHelp =>
      'Your average customer rating across all approved reviews.';

  @override
  String get sellerHealthFlagsTitle => 'Flags';

  @override
  String sellerHealthFlagsDesc(String count) {
    return '$count flag(s) raised against your store.';
  }

  @override
  String sellerHealthFlagsLimit(int limit) {
    return 'Red flag limit: $limit';
  }

  @override
  String get sellerHealthFlagsHelp =>
      'Flags raised against your store by customers.';

  @override
  String sellerHealthLastDays(int days) {
    return 'Last $days days';
  }

  @override
  String sellerHealthRefreshIn(String time) {
    return 'You can refresh again in $time';
  }

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
  String get accountReturnEvidenceImages => 'Görseller';

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
      'Yalnızca görseller ve videolar desteklenir';

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
  String get sellerAssignProfileIncomplete =>
      'Please update your profile details';

  @override
  String get sellerAssignProfileIncompleteBody =>
      'Complete your profile before assigning products for sale.';

  @override
  String get sellerAssignUpdateProfile => 'Update profile';

  @override
  String get accountBookingNotCanceledTitle =>
      'Booking Items Will Not Be Canceled';

  @override
  String get accountBookingNotCanceledBody =>
      'This order contains booking products marked as non-cancellable. Cancelling the order will only cancel the remaining items; the booking items will remain active. Please contact support if you need assistance with the booking items.';

  @override
  String get marketplaceLandingVisitShopButton => 'Visit Shop';

  @override
  String get sellerProductActiveLabel => 'Active';

  @override
  String get sellerProductDisableLabel => 'Disable';

  @override
  String get sellerProductWaitingForApproval => 'Waiting For Approval';

  @override
  String get sellerProductOutOfStockLabel => 'Out Of Stock';

  @override
  String sellerProductStockAvailable(int count) {
    return '$count Available';
  }

  @override
  String get sellerProductBarcodeNotGenerated => 'Not Generated';

  @override
  String sellerProductIdLabel(int id) {
    return 'ID - $id';
  }

  @override
  String get sellerAssignedProductTitle => 'Assign Product';

  @override
  String get sellerAssignedPriceInvalid => 'Enter a valid price';

  @override
  String get sellerAssignedProductDetails => 'Product Details';

  @override
  String get sellerProductDisapproved => 'Disapproved';

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
  String get sellerPlansMaxProductsChip => 'Max Products';

  @override
  String get sellerPlansMaxStaffChip => 'Max Staff Ids';

  @override
  String get sellerPlansCommissionChip => 'Admin Commission';

  @override
  String sellerPlansDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get sellerPlansPermissions => 'Permissions';

  @override
  String get sellerPlansProductTypes => 'Product Types';

  @override
  String get sellerPlansNoProductTypes => 'No Product Types';

  @override
  String get sellerPlansTerms =>
      'I have read and agree with the terms and conditions.';

  @override
  String get sellerPlansProceed => 'Proceed';

  @override
  String get sellerPlansPaidNotice =>
      'This is a paid plan. Buy it from the seller panel on the web, where the payment gateway runs.';

  @override
  String get sellerPlansCurrentPlan => 'Current plan';

  @override
  String get sellerPlansNoPlans => 'No plans on offer yet.';

  @override
  String get sellerPlansNoHistory => 'No past subscriptions yet.';

  @override
  String get sellerPlansHistoryTitle => 'Plan History';

  @override
  String get sellerPlansPaymentMethod => 'Payment Method';

  @override
  String get sellerPlansNoPaymentMethods =>
      'No payment method is enabled for this marketplace.';

  @override
  String get sellerPlansStartDate => 'Start Date';

  @override
  String get sellerPlansEndDate => 'End Date';

  @override
  String get sellerPlansPayment => 'Payment';

  @override
  String get sellerPlansPrice => 'Price';

  @override
  String get sellerPlansAclDashboard => 'Dashboard';

  @override
  String get sellerPlansAclProfile => 'Manage Profile';

  @override
  String get sellerPlansAclCatalog => 'Catalog';

  @override
  String get sellerPlansAclInventories => 'Inventories';

  @override
  String get sellerPlansAclPricing => 'Pricing';

  @override
  String get sellerPlansAclMarketing => 'Marketing';

  @override
  String get sellerPlansAclSales => 'Sales';

  @override
  String get sellerPlansAclPerformance => 'Performance';

  @override
  String get sellerPlansAclReporting => 'Reporting';

  @override
  String get sellerPlansAclCommunication => 'Communication';

  @override
  String get sellerPlansAclCustomers => 'Customers';

  @override
  String get sellerPlansAclSettings => 'Settings';

  @override
  String get priceStartingAt => 'Starting at';

  @override
  String get priceStartingFrom => 'Starting from';

  @override
  String get priceAsLowAs => 'As low as';

  @override
  String get priceRangeTo => 'To';
}
