// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجر باجيستو';

  @override
  String get homeFailedToLoad => 'فشل تحميل الصفحة الرئيسية';

  @override
  String get commonUnknownError => 'خطأ غير معروف';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get sellerProfileCountriesUnavailable =>
      'تعذر تحميل خيارات الدولة والولاية.';

  @override
  String get commonTimeoutError =>
      'الخادم يستغرق وقتاً طويلاً للاستجابة. يرجى التحقق من اتصالك بالإنترنت ثم المحاولة مرة أخرى.';

  @override
  String get commonUnableToReachServer =>
      'يتعذر الوصول إلى الخادم. يرجى التحقق من اتصالك بالإنترنت ثم المحاولة مرة أخرى.';

  @override
  String get commonNetworkError =>
      'حدث خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت ثم المحاولة مرة أخرى.';

  @override
  String get commonProcessingError =>
      'حدث خطأ أثناء معالجة البيانات. يرجى المحاولة لاحقاً.';

  @override
  String get commonMissingInformation =>
      'بعض المعلومات المطلوبة مفقودة. يرجى تعبئة جميع الحقول المطلوبة ثم المحاولة مرة أخرى.';

  @override
  String get commonTooManyRequests =>
      'عدد كبير من الطلبات. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.';

  @override
  String get commonServerError => 'واجه الخادم خطأً. يرجى المحاولة لاحقاً.';

  @override
  String get commonPermissionDenied => 'ليست لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get commonSecureConnectionError =>
      'تعذر إنشاء اتصال آمن. يرجى المحاولة لاحقاً.';

  @override
  String get commonCartSessionExpired =>
      'انتهت صلاحية جلسة السلة الخاصة بك. يرجى المحاولة مرة أخرى.';

  @override
  String get commonGenericError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String commonGenericErrorWithContext(Object context) {
    return 'حدث خطأ أثناء $context. يرجى المحاولة مرة أخرى.';
  }

  @override
  String get commonEdit => 'تعديل';

  @override
  String get authInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';

  @override
  String get authSessionExpired =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get authSessionInvalid =>
      'لم تعد جلستك صالحة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get homeFeaturedProducts => 'منتجات مميزة';

  @override
  String get homeDefaultProducts => 'المنتجات';

  @override
  String get homeBackToTop => 'العودة إلى الأعلى';

  @override
  String get homeViewCart => 'عرض السلة';

  @override
  String homeAddedToCartMessage(Object productName) {
    return 'تمت إضافة $productName إلى السلة';
  }

  @override
  String get homeLoginToManageWishlist =>
      'يرجى تسجيل الدخول لإدارة قائمة الرغبات';

  @override
  String get homeAddedToWishlist => 'تمت الإضافة إلى قائمة الرغبات';

  @override
  String get homeRemovedFromWishlist => 'تمت الإزالة من قائمة الرغبات';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeCollections => 'المجموعات';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'فئة $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return 'خصم $percent%';
  }

  @override
  String get productFailedToLoad => 'فشل تحميل المنتج';

  @override
  String get productNotFound => 'المنتج غير موجود';

  @override
  String get productDetail => 'تفاصيل المنتج';

  @override
  String get productDetails => 'الوصف';

  @override
  String get productShowLess => 'عرض أقل';

  @override
  String get productLoadMore => 'المزيد';

  @override
  String get productMoreInformations => 'معلومات إضافية';

  @override
  String get productSku => 'رمز المنتج';

  @override
  String get productType => 'النوع';

  @override
  String get productBrand => 'العلامة التجارية';

  @override
  String get productColor => 'اللون';

  @override
  String get productSize => 'المقاس';

  @override
  String get productReviews => 'التقييمات';

  @override
  String get productNoReviewsYet => 'لا توجد تقييمات بعد';

  @override
  String productRating(Object count) {
    return '$count تقييم';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count تقييمات';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'نشر في $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'تم تقديم تقييمك بنجاح!';

  @override
  String get productWriteReview => 'اكتب تقييماً';

  @override
  String get productPleaseLoginForReviews => 'يرجى تسجيل الدخول لعرض تقييماتك';

  @override
  String get productLoadMoreReviews => 'المزيد من التقييمات';

  @override
  String get productRelatedProduct => 'منتجات ذات صلة';

  @override
  String get productUpsellRecommendation => 'وجدنا منتجات أخرى قد تعجبك!';

  @override
  String productDiscountOff(Object percent) {
    return 'خصم $percent%';
  }

  @override
  String get productVeryGood => 'ممتاز';

  @override
  String get productGood => 'جيد';

  @override
  String get productAverage => 'متوسط';

  @override
  String get productBad => 'سيء';

  @override
  String get productVeryBad => 'سيء جداً';

  @override
  String get productInStock => 'متوفر';

  @override
  String get productOutOfStock => 'غير متوفر';

  @override
  String get productQuantity => 'الكمية';

  @override
  String get productWishlistAction => 'قائمة الرغبات';

  @override
  String get productCompareAction => 'المقارنة';

  @override
  String get productShareAction => 'مشاركة';

  @override
  String get productLoginToCompare => 'يرجى تسجيل الدخول للإضافة إلى المقارنة';

  @override
  String get productAddedToCompare => 'تمت الإضافة إلى المقارنة';

  @override
  String get productAddToCart => 'أضف إلى السلة';

  @override
  String get accountMoveToCart => 'انقل إلى السلة';

  @override
  String get productBuyNow => 'اشترِ الآن';

  @override
  String get productSelectOptionsFirst => 'يرجى تحديد خيارات المنتج أولاً';

  @override
  String get productBookingBookTable => 'احجز طاولة *';

  @override
  String get productBookingSelectDateRequired => 'اختر التاريخ *';

  @override
  String get productBookingSelectSlotRequired => 'اختر الفترة الزمنية *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'طلبات خاصة/ملاحظات *';

  @override
  String get productBookingBookAppointment => 'احجز موعدًا *';

  @override
  String get productBookingDateFormatHint => 'YYYY-MM-DD';

  @override
  String get productBookingFrom => 'من';

  @override
  String get productBookingTo => 'إلى';

  @override
  String get productBookingSelectDate => 'اختر التاريخ';

  @override
  String get productBookingLocation => 'الموقع';

  @override
  String get productBookingSlotDuration => 'مدة الفترة الزمنية';

  @override
  String get productBookingAvailability => 'التوفر';

  @override
  String get productBookingStartDate => 'تاريخ البدء';

  @override
  String get productBookingEndDate => 'تاريخ الانتهاء';

  @override
  String get productBookingDate => 'التاريخ';

  @override
  String get productBookingViewOnMap => 'عرض على الخريطة';

  @override
  String get productBookingEventOn => 'الفعالية في:';

  @override
  String get productBookingBookYourTicket => 'احجز تذكرتك';

  @override
  String get productBookingSlotDurationLabel => 'مدة الفترة الزمنية:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get productBookingAvailableFrom => 'متاح من';

  @override
  String get productBookingAvailableTo => 'متاح حتى';

  @override
  String get productBookingSpecialRequestNotesHint => 'طلبات خاصة/ملاحظات';

  @override
  String get productBookingChooseRentOption => 'اختر خيار الإيجار *';

  @override
  String get productBookingDailyBasis => 'يومي';

  @override
  String get productBookingHourlyBasis => 'بالساعة';

  @override
  String get productBookingNoDatesAvailable => 'لا توجد تواريخ متاحة للحجز';

  @override
  String get productBookingSelectSlot => 'اختر الفترة الزمنية';

  @override
  String get productBookingSelectDateFirst => 'اختر التاريخ أولاً';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'اختر التاريخ أولاً لعرض الفترات الزمنية المتاحة.';

  @override
  String get productBookingLoadingSlots => 'جارٍ تحميل الفترات الزمنية...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'جارٍ تحميل الفترات الزمنية المتاحة للتاريخ المحدد.';

  @override
  String get productBookingUnableToLoadSlots => 'تعذر تحميل الفترات الزمنية';

  @override
  String get productBookingNoSlotsAvailable => 'لا توجد فترات زمنية متاحة';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'لا توجد فترات زمنية متاحة للتاريخ المحدد.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'اختر فترة زمنية واحدة متاحة للمتابعة.';

  @override
  String get productBookingSpecialRequestNotesLowercase => 'طلبات خاصة/ملاحظات';

  @override
  String get productDownloadableLinks => 'الروابط';

  @override
  String get productDownloadableSamples => 'العينات';

  @override
  String get productDownloadSample => 'تنزيل العينة';

  @override
  String get productDefaultName => 'منتج';

  @override
  String get categoryDefaultName => 'الفئات';

  @override
  String get categorySubCategories => 'الفئات الفرعية';

  @override
  String get categorySomethingWentWrong => 'حدث خطأ ما';

  @override
  String get categoryUnknownError => 'خطأ غير معروف';

  @override
  String categoryItemsFound(Object count) {
    return 'تم العثور على $count عنصر';
  }

  @override
  String get categoryNoProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get categoryNoCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get categorySort => 'ترتيب';

  @override
  String get categorySortByTitle => 'ترتيب حسب';

  @override
  String get categorySortAZ => 'من A-Z';

  @override
  String get categorySortZA => 'من Z-A';

  @override
  String get categorySortNewest => 'الأحدث أولاً';

  @override
  String get categorySortOldest => 'الأقدم أولاً';

  @override
  String get categorySortCheapest => 'الأقل سعراً أولاً';

  @override
  String get categorySortExpensive => 'الأغلى سعراً أولاً';

  @override
  String get categoryFilter => 'تصفية';

  @override
  String get categoryFilters => 'عوامل التصفية';

  @override
  String get categoryNoFiltersAvailable => 'لا توجد عوامل تصفية متاحة';

  @override
  String get categoryFiltersWillAppear =>
      'ستظهر عوامل التصفية عندما تكون متاحة لهذه الفئة';

  @override
  String get categoryApplyFilters => 'تطبيق التصفية';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'تطبيق التصفية ($count)';
  }

  @override
  String get categoryClearAll => 'مسح الكل';

  @override
  String get categoryTryAdjustingFilters =>
      'حاول تعديل عوامل التصفية أو معايير البحث';

  @override
  String get categoryError => 'خطأ';

  @override
  String get categoryLoginToManageWishlist =>
      'يرجى تسجيل الدخول لإدارة قائمة الرغبات';

  @override
  String get categoryAddedToWishlist => 'تمت الإضافة إلى قائمة الرغبات';

  @override
  String get categoryRemovedFromWishlist => 'تمت الإزالة من قائمة الرغبات';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'فشل في تحديث قائمة الرغبات: $error';
  }

  @override
  String get wishlistItemRemoved => 'تمت إزالة العنصر من قائمة الرغبات';

  @override
  String get cart => 'السلة';

  @override
  String get cartPleaseLoginWishlist => 'يرجى تسجيل الدخول لعرض قائمة الرغبات';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText في السلة';
  }

  @override
  String get cartYourCartEmpty => 'سلتك فارغة';

  @override
  String get cartAddProductsHere => 'أضف منتجات إلى سلتك لرؤيتها هنا';

  @override
  String get cartContinueShopping => 'متابعة التسوق';

  @override
  String get cartUnit => 'وحدة';

  @override
  String get cartUnits => 'وحدات';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'يرجى تسجيل الدخول لإضافة إلى قائمة الرغبات';

  @override
  String get cartMovedToWishlist => 'تم النقل إلى قائمة الرغبات';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'فشل النقل إلى قائمة الرغبات: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'تمت إضافة المنتج إلى السلة بنجاح';

  @override
  String get productSelectDownloadLink => 'يرجى اختيار رابط واحد على الأقل';

  @override
  String get cartViewMore => 'View More';

  @override
  String get cartViewLess => 'View Less';

  @override
  String get cartEmptyCartAction => 'إفراغ السلة';

  @override
  String get cartApplyCoupon => 'تطبيق الكوبون';

  @override
  String get cartCouponCode => 'كود الكوبون';

  @override
  String get cartCouponNotFound => 'Coupon not found';

  @override
  String get cartApply => 'تطبيق';

  @override
  String get cartAppliedCoupon => 'تم تطبيق الكوبون';

  @override
  String get cartRemove => 'إزالة';

  @override
  String get cartPriceBreak => 'تفصيل السعر';

  @override
  String get cartSubTotal => 'المجموع الفرعي';

  @override
  String get cartDiscount => 'الخصم';

  @override
  String get cartDeliveryCharges => 'رسوم التوصيل';

  @override
  String get cartTax => 'الضريبة';

  @override
  String get cartTaxIncluded => '(included)';

  @override
  String cartExclTax(String amount) {
    return 'Excl. Tax: $amount';
  }

  @override
  String get cartGrandTotal => 'المجموع الكلي';

  @override
  String get cartAmountToBePaid => 'المبلغ المطلوب دفعه';

  @override
  String get cartPayNow => 'ادفع الآن';

  @override
  String get cartRemoveItem => 'إزالة العنصر';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'هل أنت متأكد من أنك تريد إزالة \"$productName\" من سلتك؟';
  }

  @override
  String get cartCancel => 'إلغاء';

  @override
  String get cartEmptyCartTitle => 'إفراغ السلة';

  @override
  String get cartEmptyCartConfirm =>
      'هل أنت متأكد من أنك تريد إزالة جميع العناصر من سلتك؟';

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
  String get checkout => 'الدفع';

  @override
  String get checkoutBillingTo => 'الفواتير إلى';

  @override
  String get checkoutDeliveredTo => 'التسليم إلى';

  @override
  String get checkoutChange => 'تغيير';

  @override
  String get checkoutSelectBillingAddress => 'اختر عنوان الفوترة';

  @override
  String get checkoutSelectShippingAddress => 'اختر عنوان الشحن';

  @override
  String get checkoutBillingAddress => 'عنوان الفوترة';

  @override
  String get checkoutEnterAddress => 'أدخل العنوان';

  @override
  String get checkoutFirstName => 'الاسم الأول';

  @override
  String get checkoutLastName => 'اسم العائلة';

  @override
  String get checkoutEmail => 'البريد الإلكتروني';

  @override
  String get checkoutPhone => 'الهاتف';

  @override
  String get checkoutStreetAddress => 'عنوان الشارع';

  @override
  String get checkoutCountry => 'البلد';

  @override
  String get checkoutState => 'المنطقة';

  @override
  String get checkoutCity => 'المدينة';

  @override
  String get checkoutPostcode => 'الرمز البريدي';

  @override
  String get checkoutCompanyOptional => 'الشركة (اختياري)';

  @override
  String get checkoutUseSameAddressShipping => 'استخدام نفس العنوان للشحن؟';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'الهاتف: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'مكتب';

  @override
  String get checkoutAddressTypeHome => 'المنزل';

  @override
  String get checkoutAddressTypeBilling => 'الفوترة';

  @override
  String get checkoutAddressTypeShipping => 'الشحن';

  @override
  String get checkoutAddressTypeDefault => 'افتراضي';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field مطلوب';
  }

  @override
  String get checkoutSaveContinue => 'حفظ ومتابعة';

  @override
  String get checkoutYourCartEmpty => 'سلتك فارغة';

  @override
  String get checkoutSelectCountry => 'اختر الدولة';

  @override
  String get checkoutSelectState => 'اختر الولاية';

  @override
  String get checkoutCountryRequired => 'الدولة مطلوبة';

  @override
  String get checkoutStateRequired => 'الولاية مطلوبة';

  @override
  String get checkoutSelectCountryFirst => 'اختر الدولة أولاً';

  @override
  String get checkoutShippingMethod => 'طريقة الشحن';

  @override
  String get checkoutSaveAddressSeeShipping => 'احفظ عنوانك لرؤية خيارات الشحن';

  @override
  String get checkoutPaymentMethod => 'طريقة الدفع';

  @override
  String get checkoutSelectShippingMethodFirst => 'اختر طريقة الشحن أولاً';

  @override
  String get checkoutEnterCouponCode => 'أدخل رمز القسيمة';

  @override
  String get checkoutDiscountCoupon => 'الخصم (الكوبون)';

  @override
  String get checkoutPlaceOrder => 'إتمام الطلب';

  @override
  String get thankYouTitle => 'شكراً لطلبك!';

  @override
  String get thankYouSubtitle =>
      'سنرسل لك تفاصيل الطلب ومعلومات التتبع عبر البريد الإلكتروني';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'رقم طلبك $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'عرض الطلب';

  @override
  String get thankYouContinueShopping => 'متابعة التسوق';

  @override
  String get accountPleaseTryAgainLater => 'يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get accountUserFallback => 'مستخدم';

  @override
  String get accountBack => 'رجوع';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get accountMyOrders => 'طلباتي';

  @override
  String get accountMyDownloadableProducts => 'منتجاتي القابلة للتنزيل';

  @override
  String get accountWishlist => 'قائمة الرغبات';

  @override
  String get accountCompareProducts => 'مقارنة المنتجات';

  @override
  String get accountProductReview => 'تقييم المنتج';

  @override
  String get accountAddressBook => 'دفتر العناوين';

  @override
  String get accountEditAccount => 'تعديل الحساب';

  @override
  String get accountLogout => 'تسجيل الخروج';

  @override
  String get accountLogoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get accountNoCountriesAvailable =>
      'لا توجد دول متاحة. يرجى المحاولة مرة أخرى.';

  @override
  String get accountPleaseSelectCountry => 'يرجى اختيار الدولة';

  @override
  String get accountPleaseSelectOrEnterState => 'يرجى اختيار أو إدخال الولاية';

  @override
  String get accountAddressUpdatedSuccessfully => 'تم تحديث العنوان بنجاح';

  @override
  String get accountAddressAddedSuccessfully => 'تمت إضافة العنوان بنجاح';

  @override
  String get accountGoBack => 'الرجوع';

  @override
  String get accountEditAddress => 'تعديل العنوان';

  @override
  String get accountAddNewAddress => 'إضافة عنوان جديد';

  @override
  String get accountFirstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get accountLastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get accountEnterValidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get accountCompanyName => 'اسم الشركة';

  @override
  String get accountVatId => 'رقم الضريبة';

  @override
  String get accountStreetAddressRequired => 'عنوان الشارع مطلوب';

  @override
  String get accountCityRequired => 'المدينة مطلوبة';

  @override
  String get accountZipPostcode => 'الرمز البريدي';

  @override
  String get accountZipPostcodeRequired => 'الرمز البريدي مطلوب';

  @override
  String get accountTelephone => 'الهاتف';

  @override
  String get accountPhoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get accountChangeDefaultBillingAddress =>
      'تغيير عنوان الفوترة الافتراضي';

  @override
  String get accountChangeDefaultShippingAddress =>
      'تغيير عنوان الشحن الافتراضي';

  @override
  String get accountUpdateAddress => 'تحديث العنوان';

  @override
  String get accountSaveToAddressBook => 'حفظ في دفتر العناوين';

  @override
  String get accountPleaseLoginToWriteReview =>
      'يرجى تسجيل الدخول لكتابة تقييم';

  @override
  String get accountPleaseSelectRating => 'يرجى اختيار تقييم';

  @override
  String get accountAddReview => 'إضافة تقييم';

  @override
  String get accountReviewSubmitted => 'تم إرسال التقييم!';

  @override
  String get accountNickName => 'الاسم';

  @override
  String get accountEnterYourName => 'أدخل اسمك';

  @override
  String get accountNameRequired => 'الاسم مطلوب';

  @override
  String get accountSummary => 'العنوان';

  @override
  String get accountReviewSummaryHint => 'العنوان';

  @override
  String get accountSummaryRequired => 'العنوان مطلوب';

  @override
  String get accountReview => 'التعليق';

  @override
  String get accountDetailedReviewHint => 'التعليق';

  @override
  String get accountReviewRequired => 'التعليق مطلوب';

  @override
  String get accountRating => 'التقييم';

  @override
  String get accountSubmitReview => 'إرسال التقييم';

  @override
  String get accountReviewAttachmentsLabel => 'إضافة صورة/فيديو';

  @override
  String get accountReviewAddMedia => 'إضافة صورة أو فيديو';

  @override
  String get accountReviewTakePhoto => 'التقاط صورة';

  @override
  String get accountReviewChooseFromGallery => 'اختيار من المعرض';

  @override
  String get accountReviewChooseVideo => 'اختيار فيديو';

  @override
  String get accountReviewRemoveAttachment => 'إزالة المرفق';

  @override
  String get accountReviewAttachmentLimitReached => 'يمكنك إرفاق حتى 5 ملفات';

  @override
  String get accountReviewAttachmentTooLarge =>
      'الملف كبير جدًا (الحد الأقصى 5 ميغابايت)';

  @override
  String get accountCouldNotLoadAddresses => 'تعذر تحميل العناوين';

  @override
  String get accountPleaseTryAgain => 'يرجى المحاولة مرة أخرى';

  @override
  String get accountNoAddressesSaved => 'لا توجد عناوين محفوظة';

  @override
  String get accountAddAddressToGetStarted => 'أضف عنواناً جديداً للبدء';

  @override
  String get accountSelectAddress => 'اختر العنوان';

  @override
  String get accountSetAsDefault => 'تعيين كافتراضي';

  @override
  String get accountAddressTypeHome => 'المنزل';

  @override
  String get accountAddressTypeOffice => 'المكتب';

  @override
  String get accountAddressTypeCustomer => 'العميل';

  @override
  String get accountNoProductsToCompare => 'لا توجد منتجات للمقارنة';

  @override
  String get accountAddProductsToCompareHint =>
      'أضف منتجات للمقارنة من صفحة تفاصيل المنتج.';

  @override
  String get accountProducts => 'المنتجات';

  @override
  String get accountDescription => 'الوصف';

  @override
  String get accountShortDescription => 'وصف مختصر';

  @override
  String get accountActivity => 'النشاط';

  @override
  String get accountSeller => 'البائع';

  @override
  String get accountNotAvailable => 'غير متوفر';

  @override
  String get accountMessageSentSuccessfully => 'تم إرسال الرسالة بنجاح!';

  @override
  String get accountAnErrorOccurred => 'حدث خطأ';

  @override
  String get accountContactUs => 'اتصل بنا';

  @override
  String get accountName => 'الاسم';

  @override
  String get accountEnterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get accountContact => 'رقم التواصل';

  @override
  String get accountEnterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get accountMessage => 'الرسالة';

  @override
  String get accountEnterYourMessage => 'أدخل رسالتك';

  @override
  String get accountSendMessage => 'إرسال الرسالة';

  @override
  String get accountNameFieldEmpty => 'حقل الاسم لا يمكن أن يكون فارغاً';

  @override
  String get accountNameMinChars => 'يجب أن يكون الاسم حرفين على الأقل';

  @override
  String get accountEmailFieldEmpty =>
      'حقل البريد الإلكتروني لا يمكن أن يكون فارغاً';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get accountContactNumberEmpty => 'رقم التواصل لا يمكن أن يكون فارغاً';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'يرجى إدخال رقم تواصل صحيح';

  @override
  String get accountMessageFieldEmpty => 'حقل الرسالة لا يمكن أن يكون فارغاً';

  @override
  String get accountMessageMinChars => 'يجب أن تكون الرسالة 10 أحرف على الأقل';

  @override
  String get accountDownloadableProducts => 'المنتجات القابلة للتنزيل';

  @override
  String get accountNoDownloadsYet => 'لا توجد تنزيلات بعد';

  @override
  String get accountDownloadsEmptyDescription => 'ستظهر منتجاتك المنزلة هنا.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total منتجات';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return 'المتبقي $value';
  }

  @override
  String get accountDownload => 'تنزيل';

  @override
  String accountFileName(Object fileName) {
    return 'الملف: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'سيبدأ التنزيل قريباً. تحقق من مجلد التنزيلات.';

  @override
  String get accountClose => 'إغلاق';

  @override
  String get accountOrders => 'الطلبات';

  @override
  String get accountNoOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get accountOrdersEmptyDescription =>
      'ستظهر طلباتك هنا بعد إتمام الشراء.';

  @override
  String get accountOrderSingular => 'طلب';

  @override
  String get accountOrderPlural => 'طلبات';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (العناصر $count)';
  }

  @override
  String get accountOrderAndReturn => 'الطلب والإرجاع';

  @override
  String get accountTrackOrder => 'تتبع الطلب';

  @override
  String get accountReturnPolicy => 'سياسة الإرجاع';

  @override
  String get accountReturnRequest => 'طلب إرجاع';

  @override
  String get accountNotifications => 'الإشعارات';

  @override
  String get accountPrivacy => 'الخصوصية';

  @override
  String get accountAccount => 'الحساب';

  @override
  String get accountPreferences => 'التفضيلات';

  @override
  String get accountLanguage => 'اللغة';

  @override
  String get accountNoLanguagesAvailable => 'لا توجد لغات متاحة';

  @override
  String get accountCurrency => 'العملة';

  @override
  String get accountOthers => 'أخرى';

  @override
  String get accountNoPagesAvailable => 'لا توجد صفحات متاحة';

  @override
  String get accountProductReviews => 'تقييمات المنتجات';

  @override
  String get accountMyReviews => 'تقييماتي';

  @override
  String get accountNoReviewsYet => 'لا توجد تقييمات بعد';

  @override
  String get accountReviewsEmptyDescription => 'ستظهر تقييمات منتجاتك هنا.';

  @override
  String get accountReviewSingular => 'تقييم';

  @override
  String get accountReviewPlural => 'تقييمات';

  @override
  String accountPostedOn(Object date) {
    return 'تم النشر في $date';
  }

  @override
  String get accountCloseSettings => 'إغلاق الإعدادات';

  @override
  String get accountChangeTheme => 'تغيير النمط';

  @override
  String get accountAllNotifications => 'كل الإشعارات';

  @override
  String get accountOffers => 'العروض';

  @override
  String get accountOfflineData => 'البيانات دون اتصال';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'تتبع وإظهار المنتجات التي تمت مشاهدتها مؤخراً';

  @override
  String get accountShowSearchTag => 'إظهار وسم البحث';

  @override
  String get accountTryAgain => 'حاول مرة أخرى';

  @override
  String get accountYourWishlistEmpty => 'قائمة رغباتك فارغة';

  @override
  String get accountWishlistEmptyDescription =>
      'تصفح المنتجات وأضفها إلى قائمة رغباتك';

  @override
  String get accountItemSingular => 'عنصر';

  @override
  String get accountItemPlural => 'عناصر';

  @override
  String accountStartingAt(Object price) {
    return 'يبدأ من $price';
  }

  @override
  String get accountAboutThisPage => 'حول هذه الصفحة';

  @override
  String accountPageId(Object id) {
    return 'معرّف الصفحة: $id';
  }

  @override
  String get mainTabHome => 'الرئيسية';

  @override
  String get mainTabCategories => 'الفئات';

  @override
  String get mainTabCart => 'السلة';

  @override
  String get mainTabAccount => 'الحساب';

  @override
  String get authLoginSuccess => 'مرحباً! تم تسجيل الدخول بنجاح.';

  @override
  String get authWelcomeBack => 'مرحباً بعودتك!';

  @override
  String get authLoginToAccount => 'سجّل الدخول إلى حسابك';

  @override
  String get authEmailAddress => 'البريد الإلكتروني';

  @override
  String get authEnterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get authPleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get authPleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authEnterYourPassword => 'أدخل كلمة المرور';

  @override
  String get authPleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get authPasswordMinLength =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get authForgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authNoAccountPrompt => 'ليس لديك حساب؟ ';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authAccountCreatedSuccess => 'تم إنشاء الحساب بنجاح!';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authSignupGetStarted => 'أنشئ حسابًا للبدء';

  @override
  String get authFirstNameHint => 'الاسم الأول';

  @override
  String get authLastNameHint => 'اسم العائلة';

  @override
  String get authRequired => 'مطلوب';

  @override
  String get authCreatePasswordHint => 'أنشئ كلمة مرور';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أكد كلمة المرور';

  @override
  String get authPleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get authPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get authAlreadyHaveAccountPrompt => 'لديك حساب بالفعل؟ ';

  @override
  String get authForgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get authSendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get authBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get authNiceToSeeYouHere => 'سعداء برؤيتك هنا';

  @override
  String get accountEditTitle => 'تعديل الحساب';

  @override
  String get accountFirstNameRequiredLabel => 'الاسم الأول *';

  @override
  String get accountLastNameRequiredLabel => 'اسم العائلة *';

  @override
  String get accountChangeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get accountChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountDeleteAccount => 'حذف الحساب';

  @override
  String get accountGender => 'الجنس';

  @override
  String get accountSelectGender => 'اختر الجنس';

  @override
  String get accountDob => 'تاريخ الميلاد';

  @override
  String get monthJanShort => 'ينا';

  @override
  String get monthFebShort => 'فبر';

  @override
  String get monthMarShort => 'مار';

  @override
  String get monthAprShort => 'أبر';

  @override
  String get monthMayShort => 'ماي';

  @override
  String get monthJunShort => 'يون';

  @override
  String get monthJulShort => 'يول';

  @override
  String get monthAugShort => 'أغس';

  @override
  String get monthSepShort => 'سبت';

  @override
  String get monthOctShort => 'أكت';

  @override
  String get monthNovShort => 'نوف';

  @override
  String get monthDecShort => 'ديس';

  @override
  String get accountSubscribeNewsletters => 'الاشتراك في النشرات البريدية';

  @override
  String get accountSaveProfile => 'حفظ الملف الشخصي';

  @override
  String get accountNewEmail => 'بريد إلكتروني جديد';

  @override
  String get accountEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get accountCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get accountPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get accountChange => 'تغيير';

  @override
  String get accountCurrentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get accountNewPassword => 'كلمة مرور جديدة';

  @override
  String get accountConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get accountDeleteWarning =>
      'هذا الإجراء دائم ولا يمكن التراجع عنه. سيتم حذف جميع بياناتك.';

  @override
  String get accountEnterYourPassword => 'أدخل كلمة المرور';

  @override
  String get accountDelete => 'حذف';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'ذكر';

  @override
  String get accountGenderFemale => 'أنثى';

  @override
  String get accountGenderOther => 'آخر';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'الطلبات $number';
  }

  @override
  String get accountReorderSuccessful => 'تمت إعادة الطلب بنجاح';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\nتمت إضافة $count عناصر إلى سلتك.';
  }

  @override
  String get accountOk => 'موافق';

  @override
  String get accountGoToCart => 'اذهب إلى السلة';

  @override
  String get accountFailedToLoadOrderDetails => 'فشل تحميل تفاصيل الطلب';

  @override
  String get accountDetails => 'التفاصيل';

  @override
  String get accountInvoices => 'الفواتير';

  @override
  String get accountShipments => 'الشحنات';

  @override
  String get accountRefunds => 'المبالغ المستردة';

  @override
  String get accountRefundSubtotal => 'Subtotal';

  @override
  String get accountRefundedQty => 'الكمية المستردة';

  @override
  String get accountShippingAndHandling => 'الشحن والتجهيز';

  @override
  String get accountAdjustmentRefund => 'Adjustment Refund';

  @override
  String get accountAdjustmentFee => 'Adjustment Fee';

  @override
  String accountPlacedOn(Object date) {
    return 'تم الطلب في $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return 'تم طلب $count عنصر';
  }

  @override
  String get accountBillingAddress => 'عنوان الفوترة';

  @override
  String get accountShippingAddress => 'عنوان الشحن';

  @override
  String get accountShippingMethod => 'طريقة الشحن';

  @override
  String get accountPaymentMethod => 'طريقة الدفع';

  @override
  String get accountNoInvoicesForOrder => 'لا توجد فواتير لهذا الطلب';

  @override
  String accountInvoicedCount(int count) {
    return '$count مفوتر';
  }

  @override
  String get accountNoShipmentsForOrder => 'لا توجد شحنات لهذا الطلب';

  @override
  String get accountReorder => 'إعادة الطلب';

  @override
  String get accountMoreInfo => 'مزيد من المعلومات';

  @override
  String get accountOrderedQty => 'الكمية المطلوبة';

  @override
  String get accountShipped => 'تم الشحن';

  @override
  String get accountInvoiced => 'تمت الفوترة';

  @override
  String get accountUnitPrice => 'سعر الوحدة';

  @override
  String get accountSubTotalWithSpace => 'المجموع الفرعي';

  @override
  String get accountTotalPaid => 'إجمالي المدفوع';

  @override
  String get accountTotalRefunded => 'إجمالي المسترد';

  @override
  String get accountTotalDue => 'إجمالي المستحق';

  @override
  String accountInvoiceNumber(Object number) {
    return 'فاتورة $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'شحنة $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails => 'فشل تحميل تفاصيل الفاتورة';

  @override
  String get accountInvoiceStatus => 'حالة الفاتورة';

  @override
  String get accountInvoiceDate => 'تاريخ الفاتورة';

  @override
  String get accountOrderId => 'رقم الطلب';

  @override
  String get accountOrderDate => 'تاريخ الطلب';

  @override
  String get accountOrderStatus => 'حالة الطلب';

  @override
  String get accountChannel => 'القناة';

  @override
  String get accountDefault => 'افتراضي';

  @override
  String get accountStatusPaid => 'مدفوع';

  @override
  String get accountStatusPending => 'قيد الانتظار';

  @override
  String get accountStatusPendingPayment => 'بانتظار الدفع';

  @override
  String get accountStatusOverdue => 'متأخر';

  @override
  String get accountStatusRefunded => 'مسترد';

  @override
  String get accountShippedQty => 'الكمية المشحونة';

  @override
  String get accountInvoicedQty => 'الكمية المفوترة';

  @override
  String get accountUnitPriceWithColon => 'سعر الوحدة:';

  @override
  String get accountSubTotalWithColon => 'المجموع الفرعي:';

  @override
  String get accountDownloadInvoice => 'تنزيل الفاتورة';

  @override
  String get accountInvoice => 'فاتورة';

  @override
  String get accountRecentOrders => 'الطلبات الأخيرة';

  @override
  String get accountNoRecentOrders => 'لا توجد طلبات حديثة';

  @override
  String get accountStatusProcessing => 'قيد المعالجة';

  @override
  String get accountStatusCompleted => 'مكتمل';

  @override
  String get accountStatusCancelled => 'ملغي';

  @override
  String get accountStatusClosed => 'مغلق';

  @override
  String get accountStatusUnknown => 'غير معروف';

  @override
  String accountWishlistItemsCount(int count) {
    return 'عناصر قائمة الرغبات ($count)';
  }

  @override
  String get accountNoWishlistItems => 'لا توجد عناصر في قائمة الرغبات';

  @override
  String get accountDefaultAddresses => 'العناوين الافتراضية';

  @override
  String get accountNoProductReviewsYet => 'لا توجد تقييمات منتجات بعد';

  @override
  String get searchFailedTitle => 'فشل البحث';

  @override
  String get searchHint => 'ابحث عن المنتجات';

  @override
  String get searchImageSearch => 'البحث بالصورة';

  @override
  String get searchRecentSearches => 'عمليات البحث الأخيرة';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String get searchTopCategories => 'أفضل الفئات';

  @override
  String searchResultsFound(int count) {
    return 'تم العثور على $count نتيجة';
  }

  @override
  String searchDiscountOff(Object percent) {
    return 'خصم $percent%';
  }

  @override
  String get searchNoProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get searchTryDifferentTerm => 'حاول البحث بكلمة مختلفة';

  @override
  String get searchSpeechNotAvailable => 'التعرف الصوتي غير متاح';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'تعذر بدء الإدخال الصوتي: $error';
  }

  @override
  String get searchMicrophonePermissionDenied => 'تم رفض إذن الميكروفون';

  @override
  String get searchRetake => 'إعادة التقاط';

  @override
  String get searchSearch => 'بحث';

  @override
  String get searchTryAgain => 'حاول مرة أخرى';

  @override
  String get searchRecognizedObjects => 'الكائنات المتعرف عليها';

  @override
  String get searchResult => 'النتيجة:';

  @override
  String get searchFailedToCaptureImage => 'فشل في التقاط الصورة';

  @override
  String searchProcessing(int progress) {
    return 'جارٍ المعالجة... $progress%';
  }

  @override
  String get searchOpeningCamera => 'جارٍ فتح الكاميرا...';

  @override
  String get searchFailedToProcessImage => 'فشل في معالجة الصورة';

  @override
  String get homeRecentlyViewedProducts => 'المنتجات المشاهدة مؤخراً';

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
    return '$count عنصر';
  }

  @override
  String get accountTrack => 'تتبع';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'تتبع $trackNumber عبر $carrier';
  }

  @override
  String get accountUnknownCarrier => 'شركة شحن غير معروفة';

  @override
  String get accountTrackingNumber => 'رقم التتبع';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'الكمية المشحونة : $qty';
  }

  @override
  String get sellerLoginTitle => 'تسجيل دخول البائع';

  @override
  String get sellerLoginSubtitle => 'أدر متجرك ومنتجاتك وطلباتك';

  @override
  String get sellerEmailLabel => 'البريد الإلكتروني';

  @override
  String get sellerPasswordLabel => 'كلمة المرور';

  @override
  String get sellerSignInAction => 'تسجيل الدخول';

  @override
  String get sellerEmailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get sellerPasswordRequired => 'أدخل كلمة المرور';

  @override
  String get sellerPendingApprovalTitle => 'بانتظار الموافقة';

  @override
  String get sellerPendingApprovalBody =>
      'لم يوافق مشرف السوق على هذا المتجر بعد. ستتمكن من تسجيل الدخول بمجرد موافقته.';

  @override
  String get sellerSuspendedTitle => 'المتجر معلّق';

  @override
  String get sellerSuspendedBody => 'تم تعليق هذا المتجر من قبل مشرف السوق.';

  @override
  String get accountSellOnMarketplace => 'Sell on marketplace';

  @override
  String get sellerProfileTitle => 'الملف الشخصي للمتجر';

  @override
  String get sellerBusinessNameLabel => 'اسم النشاط التجاري';

  @override
  String get sellerBusinessDescriptionLabel => 'عن المتجر';

  @override
  String get sellerPhoneLabel => 'الهاتف';

  @override
  String get sellerSaveAction => 'حفظ التغييرات';

  @override
  String get sellerProfileSaved => 'تم تحديث الملف الشخصي';

  @override
  String get sellerProfileFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get sellerProfileRequiredFieldsMissing =>
      'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get sellerProfilePhone => 'الهاتف';

  @override
  String get sellerProfileDescription => 'وصف المتجر';

  @override
  String get sellerProfileBusinessName => 'اسم النشاط التجاري';

  @override
  String get sellerProfileTabGeneral => 'عام';

  @override
  String get sellerProfileTabAddress => 'العنوان';

  @override
  String get sellerProfileTabPolicies => 'السياسات';

  @override
  String get sellerProfileTabSeo => 'تحسين محركات البحث';

  @override
  String get sellerProfileTabSocial => 'التواصل الاجتماعي';

  @override
  String get sellerProfileTabOther => 'المزيد';

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
      'لا يحدد هذا السوق أي حقول قابلة للتعديل في الملف الشخصي.';

  @override
  String get sellerProfileContactName => 'اسم جهة الاتصال';

  @override
  String get sellerProfileSlug => 'رابط المتجر';

  @override
  String get sellerProfileAddress => 'عنوان الشارع';

  @override
  String get sellerProfileCity => 'المدينة';

  @override
  String get sellerProfileState => 'الولاية';

  @override
  String get sellerProfileCountry => 'الدولة';

  @override
  String get sellerProfilePostcode => 'الرمز البريدي';

  @override
  String get sellerProfileReturnPolicy => 'سياسة الإرجاع';

  @override
  String get sellerProfileShippingPolicy => 'سياسة الشحن';

  @override
  String get sellerProfilePrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get sellerProfileMetaTitle => 'عنوان الميتا';

  @override
  String get sellerProfileMetaKeywords => 'الكلمات المفتاحية للميتا';

  @override
  String get sellerProfileMetaDescription => 'وصف الميتا';

  @override
  String get sellerProfileAnalyticsId => 'معرّف Google Analytics';

  @override
  String get sellerProfileMinOrder => 'الحد الأدنى لمبلغ الطلب';

  @override
  String get sellerStatusSuspended => 'معلّق';

  @override
  String get sellerDrawerSettingsGroup => 'الإعدادات';

  @override
  String get sellerDrawerCatalogGroup => 'الكتالوج';

  @override
  String get sellerDrawerInventoriesGroup => 'المخزونات';

  @override
  String get sellerDrawerPricingGroup => 'التسعير';

  @override
  String get sellerDrawerSalesGroup => 'المبيعات';

  @override
  String get sellerDrawerAllProducts => 'المنتجات';

  @override
  String get sellerDrawerReportingGroup => 'التقارير';

  @override
  String get sellerDrawerGeneral => 'عام';

  @override
  String get sellerDrawerUsers => 'المستخدمون';

  @override
  String get sellerDrawerRoles => 'الأدوار';

  @override
  String get sellerDrawerInventory => 'مصادر المخزون';

  @override
  String get sellerDrawerManageInventory => 'إدارة المخزون';

  @override
  String get sellerDrawerReportSales => 'المبيعات';

  @override
  String get sellerDrawerReportProducts => 'المنتجات';

  @override
  String get sellerDrawerReportCustomers => 'العملاء';

  @override
  String get sellerDrawerProductReviews => 'مراجعات المنتجات';

  @override
  String get sellerDrawerShopReviews => 'مراجعات المتجر';

  @override
  String get sellerDrawerMoreTools => 'المزيد من الأدوات';

  @override
  String get sellerPanelTitle => 'لوحة البائع';

  @override
  String get sellerTabDashboard => 'لوحة التحكم';

  @override
  String get sellerTabProducts => 'المنتجات';

  @override
  String get sellerTabOrders => 'الطلبات';

  @override
  String get sellerStatusApproved => 'تمت الموافقة';

  @override
  String get sellerStatusPending => 'بانتظار الموافقة';

  @override
  String get sellerDashboardSalesTrend => 'المبيعات عبر الزمن';

  @override
  String get sellerDashboardDateFilter => 'النطاق الزمني';

  @override
  String get sellerDashboardDefaultRange => 'النطاق الافتراضي';

  @override
  String get sellerDashboardToday => 'اليوم';

  @override
  String get sellerDashboardLast7Days => 'آخر 7 أيام';

  @override
  String get sellerDashboardLast30Days => 'آخر 30 يومًا';

  @override
  String get sellerDashboardThisMonth => 'هذا الشهر';

  @override
  String get sellerDashboardLastMonth => 'الشهر الماضي';

  @override
  String get sellerDashboardLast6Months => 'آخر 6 أشهر';

  @override
  String get sellerDashboardThisYear => 'هذه السنة';

  @override
  String get sellerDashboardLastYear => 'السنة الماضية';

  @override
  String get sellerDashboardCustomRange => 'نطاق مخصص';

  @override
  String get sellerDashboardOrderStatus => 'الطلبات حسب الحالة';

  @override
  String get sellerDashboardTopProducts => 'أفضل المنتجات';

  @override
  String get sellerDashboardTopCategories => 'أفضل الفئات';

  @override
  String get sellerDashboardTopCustomers => 'أفضل العملاء';

  @override
  String get sellerDashboardTodo => 'مهام للإنجاز';

  @override
  String get sellerProfileScoreTitle => 'تقييم الملف الشخصي';

  @override
  String get sellerProfileScoreSubtitle =>
      'زد ظهورك بإبقاء معلومات ملفك الشخصي مكتملة.';

  @override
  String get sellerProfileScoreAction => 'أكمل ملفك الشخصي';

  @override
  String get sellerDashboardTodoClear => 'لقد أنجزت كل شيء.';

  @override
  String get sellerDashboardTodoUnshipped => 'طلبات بحاجة إلى شحن';

  @override
  String get sellerDashboardTodoLowStock => 'منتجات منخفضة المخزون';

  @override
  String get sellerDashboardTodoPending => 'منتجات بانتظار الموافقة';

  @override
  String get sellerDashboardTodoMessages => 'رسائل غير مقروءة';

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
  String get sellerDashboardLowStock => 'حد المخزون';

  @override
  String get sellerDashboardNoData => 'لا يوجد ما يمكن عرضه لهذه الفترة';

  @override
  String get sellerDashboardAvgSale => 'متوسط البيع';

  @override
  String get sellerDashboardPaidOut => 'المبالغ المدفوعة';

  @override
  String get sellerDashboardViewAll => 'عرض الكل';

  @override
  String sellerDashboardOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count طلب',
      many: '$count طلبًا',
      few: '$count طلبات',
      two: 'طلبان',
      one: 'طلب واحد',
      zero: 'لا طلبات',
    );
    return '$_temp0';
  }

  @override
  String sellerDashboardLeftInStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متبقٍ $count',
      many: 'متبقٍ $count',
      few: 'متبقٍ $count',
      two: 'متبقيان 2',
      one: 'متبقٍ 1',
      zero: 'لا شيء متبقٍ',
    );
    return '$_temp0';
  }

  @override
  String get sellerDashboardPerformance => 'الأداء';

  @override
  String get sellerDashboardOrders => 'الطلبات';

  @override
  String get sellerDashboardSales => 'المبيعات';

  @override
  String get sellerDashboardCustomers => 'العملاء';

  @override
  String get sellerMoreCatalogue => 'الكتالوج';

  @override
  String get sellerMoreSelling => 'البيع';

  @override
  String get sellerMoreMoney => 'الأموال';

  @override
  String get sellerMoreShop => 'متجرك';

  @override
  String get sellerShopProfileMenu => 'الملف الشخصي للمتجر';

  @override
  String get sellerSignOutAction => 'تسجيل الخروج';

  @override
  String get sellerRegisterTitle => 'كن بائعًا';

  @override
  String get sellerRegisterAction => 'إنشاء متجر';

  @override
  String get sellerRegisterAdditionalInfo => 'Additional Information';

  @override
  String get sellerNameLabel => 'اسمك';

  @override
  String get sellerShopUrlLabel => 'رابط المتجر';

  @override
  String get sellerConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get sellerPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get sellerFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get sellerForgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get sellerForgotPasswordAction => 'إرسال رابط إعادة التعيين';

  @override
  String get sellerForgotPasswordSent =>
      'إذا كان هذا البريد الإلكتروني مرتبطًا بمتجر، فسيصلك رابط إعادة التعيين قريبًا.';

  @override
  String get sellerNoAccountPrompt => 'بائع جديد؟ أنشئ متجرًا';

  @override
  String get sellerForgotPasswordPrompt => 'نسيت كلمة المرور؟';

  @override
  String get sellerProductsTitle => 'المنتجات';

  @override
  String get sellerProductsSearchHint => 'ابحث بالاسم أو SKU';

  @override
  String get sellerProductsEmpty => 'لا توجد منتجات بعد';

  @override
  String get sellerProductsEmptyFiltered => 'لا توجد منتجات تطابق هذه التصفيات';

  @override
  String get sellerProductsFilters => 'التصفية';

  @override
  String get sellerProductStatusApproved => 'تمت الموافقة';

  @override
  String get sellerProductStatusPending => 'قيد الانتظار';

  @override
  String get sellerProductStatusRejected => 'مرفوض';

  @override
  String get sellerProductStatusDraft => 'مسودة';

  @override
  String get sellerProductStockLabel => 'المخزون';

  @override
  String get sellerProductOutOfStock => 'نفد';

  @override
  String get sellerProductsRetry => 'إعادة المحاولة';

  @override
  String get sellerFiltersApply => 'تطبيق';

  @override
  String get sellerFiltersClear => 'مسح الكل';

  @override
  String get sellerProductTypeLabel => 'النوع';

  @override
  String get sellerProductStatusLabel => 'الحالة';

  @override
  String get sellerProductApprovalLabel => 'الموافقة';

  @override
  String get sellerProductEnabled => 'مفعّل';

  @override
  String get sellerProductDisabled => 'معطّل';

  @override
  String get sellerProductDraftsOnly => 'المسودات فقط';

  @override
  String get sellerProductAnyValue => 'أي';

  @override
  String sellerProductsCount(int count) {
    return '$count منتجات';
  }

  @override
  String get sellerProductDetailTitle => 'المنتج';

  @override
  String get sellerProductPricing => 'التسعير';

  @override
  String get sellerProductShipping => 'الشحن';

  @override
  String get sellerProductStockBySource => 'المخزون حسب الموقع';

  @override
  String sellerProductPendingOrderedQty(int count) {
    return 'الكمية المطلوبة قيد الانتظار: $count';
  }

  @override
  String get sellerListingCompleteness => 'اكتمال القائمة';

  @override
  String get sellerListingCompletenessHint =>
      'القائمة المكتملة تحظى بظهور أكبر وتحقق مبيعات أفضل. أكمل التفاصيل المتبقية للوصول إلى 100%.';

  @override
  String sellerGroupPriceFixed(Object qty, Object value) {
    return 'لكمية $qty بسعر ثابت قدره $value';
  }

  @override
  String sellerGroupPriceDiscount(Object qty, Object value) {
    return 'لكمية $qty بخصم $value%';
  }

  @override
  String get sellerGroupPriceAddNew => 'إضافة جديد';

  @override
  String get sellerGroupPriceCreateTitle => 'إنشاء سعر لمجموعة العملاء';

  @override
  String get sellerGroupPriceEditTitle => 'تعديل سعر مجموعة العملاء';

  @override
  String get sellerGroupPriceEmpty =>
      'لا توجد أسعار للمجموعات بعد. تسعير خاص للعملاء المنتمين إلى مجموعة محددة.';

  @override
  String get sellerGroupPriceSave => 'حفظ';

  @override
  String get sellerGroupPriceDuplicate =>
      'يوجد سعر لهذه المجموعة والكمية بالفعل. عدّل ذلك السعر بدلًا من ذلك، أو استخدم كمية مختلفة.';

  @override
  String get sellerProductInventoriesLabel => 'المخزون';

  @override
  String get sellerProductManageStock => 'إدارة المخزون';

  @override
  String get sellerProductCategoriesLabel => 'الفئات';

  @override
  String get sellerProductAttributes => 'السمات';

  @override
  String get sellerProductSeo => 'تحسين محركات البحث (SEO)';

  @override
  String get sellerProductNoImages => 'لا توجد صور';

  @override
  String get sellerProductRejectionReason => 'سبب الرفض';

  @override
  String get sellerProductSpecialPrice => 'السعر الخاص';

  @override
  String get sellerProductWeight => 'الوزن';

  @override
  String get sellerProductDescription => 'الوصف';

  @override
  String get sellerProductNoPermission =>
      'دورك لا يتضمن صلاحية الوصول إلى المنتجات.';

  @override
  String get sellerStockLocationsTitle => 'مواقع المخزون';

  @override
  String get sellerStockLocationsEmpty => 'لا توجد مواقع مخزون بعد';

  @override
  String get sellerStockLocationsCreateAction => 'إنشاء مصادر المخزون';

  @override
  String get sellerStockLocationsSaveAction => 'حفظ مصادر المخزون';

  @override
  String get sellerStockLocationAdd => 'إضافة مصدر مخزون';

  @override
  String get sellerStockLocationEdit => 'تعديل الموقع';

  @override
  String get sellerStockLocationCode => 'الرمز';

  @override
  String get sellerStockLocationName => 'الاسم';

  @override
  String get sellerStockLocationContactName => 'اسم جهة الاتصال';

  @override
  String get sellerStockLocationContactEmail =>
      'البريد الإلكتروني لجهة الاتصال';

  @override
  String get sellerStockLocationContactNumber => 'رقم جهة الاتصال';

  @override
  String get sellerStockLocationContactFax => 'فاكس جهة الاتصال';

  @override
  String get sellerStockLocationStreet => 'الشارع';

  @override
  String get sellerStockLocationCity => 'المدينة';

  @override
  String get sellerStockLocationState => 'المنطقة';

  @override
  String get sellerStockLocationCountry => 'الدولة';

  @override
  String get sellerStockLocationPostcode => 'الرمز البريدي';

  @override
  String get sellerStockLocationPriority => 'الأولوية';

  @override
  String get sellerStockLocationDescription => 'الوصف';

  @override
  String get sellerStockLocationLatitude => 'خط العرض';

  @override
  String get sellerStockLocationLongitude => 'خط الطول';

  @override
  String get sellerStockLocationActive => 'نشط';

  @override
  String get sellerStockLocationInactive => 'غير نشط';

  @override
  String get sellerStockLocationSectionGeneral => 'عام';

  @override
  String get sellerStockLocationSectionAddress => 'عنوان المصدر';

  @override
  String get sellerStockLocationSectionSettings => 'الإعدادات';

  @override
  String get sellerStockLocationSectionContact => 'معلومات الاتصال';

  @override
  String sellerStockLocationProducts(int count) {
    return '$count منتجات';
  }

  @override
  String get sellerStockLocationDelete => 'حذف الموقع';

  @override
  String get sellerStockLocationDeleteConfirm =>
      'هل تريد حذف موقع المخزون هذا؟';

  @override
  String get sellerCancel => 'إلغاء';

  @override
  String get sellerDelete => 'حذف';

  @override
  String get sellerSave => 'حفظ';

  @override
  String get sellerStockLocationCodeHint => 'فريد في المتجر بأكمله';

  @override
  String get sellerManageInventoryTitle => 'إدارة المخزون';

  @override
  String get sellerManageInventorySearchHint => 'بحث';

  @override
  String sellerManageInventoryResults(int count) {
    return '$count نتيجة';
  }

  @override
  String get sellerManageInventoryEmpty => 'لا توجد منتجات بعد';

  @override
  String get sellerManageInventoryRetry => 'حاول مرة أخرى';

  @override
  String get sellerManageInventoryStatusUnapproved => 'غير موافق عليه';

  @override
  String get sellerManageInventoryStatusActive => 'نشط';

  @override
  String get sellerManageInventoryStatusInactive => 'غير نشط';

  @override
  String sellerManageInventorySold(int count) {
    return 'مباع $count';
  }

  @override
  String sellerManageInventoryUndelivered(int count) {
    return 'غير مسلّم $count';
  }

  @override
  String sellerManageInventoryCanceled(int count) {
    return 'ملغى $count';
  }

  @override
  String sellerManageInventoryStock(int count) {
    return 'المخزون: $count';
  }

  @override
  String get sellerManageInventoryReadOnlyStock =>
      'المخزون للقراءة فقط عند وجود أكثر من موقع مخزون — عدّله من صفحة المنتج بدلًا من ذلك.';

  @override
  String sellerManageInventoryUnsavedChanges(int count) {
    return '$count تغيير(ات) غير محفوظة';
  }

  @override
  String get sellerManageInventoryUnsavedHint =>
      'راجع تعديلات المخزون، ثم احفظ لنشرها.';

  @override
  String get sellerManageInventoryDiscard => 'تجاهل';

  @override
  String get sellerManageInventorySaveAction => 'حفظ المخزون';

  @override
  String get sellerManageInventorySaveSuccess => 'تم تحديث المخزون';

  @override
  String get sellerManageInventoryEditPrice => 'تعديل السعر';

  @override
  String get sellerManageInventorySelectAll => 'تحديد الكل';

  @override
  String sellerManageInventorySelected(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get sellerManageInventoryEnable => 'تفعيل';

  @override
  String get sellerManageInventoryDisable => 'تعطيل';

  @override
  String sellerManageInventoryBatchResult(int saved, int skipped) {
    return 'تم تحديث $saved، وتخطي $skipped';
  }

  @override
  String get sellerManageInventoryPageSize => 'لكل صفحة';

  @override
  String get sellerProductCreateTitle => 'منتج جديد';

  @override
  String get sellerProductCreateAction => 'إنشاء';

  @override
  String get sellerProductSkuLabel => 'SKU';

  @override
  String get sellerProductFamilyLabel => 'معرّف مجموعة السمات';

  @override
  String get sellerProductFamilyHelp =>
      'معرّف المجموعة لدى المسؤول من اللوحة. القيمة 1 هي مجموعة Bagisto الافتراضية.';

  @override
  String get sellerProductFamiliesFailed =>
      'Could not load attribute families.';

  @override
  String get sellerProductFamiliesEmpty =>
      'No attribute families are available.';

  @override
  String get sellerProductSaveAsDraft => 'حفظ كمسودة';

  @override
  String get sellerProductNeedsVariants =>
      'اختر خاصية واحدة على الأقل يتنوع المنتج بحسبها';

  @override
  String get sellerProductLoadingVariants => 'جارٍ تحميل الخيارات…';

  @override
  String get sellerProductVariesBy => 'يتنوع حسب';

  @override
  String get sellerProductVariesByHelp =>
      'يُنشأ متغير لكل تركيبة خيارات محددة. يمكنك إضافة تركيبات بعد حفظ المنتج.';

  @override
  String get sellerProductEditorTitle => 'تعديل المنتج';

  @override
  String get sellerProductNameLabel => 'الاسم';

  @override
  String get sellerProductUrlKeyLabel => 'مفتاح URL';

  @override
  String get sellerProductNumberLabel => 'رقم المنتج';

  @override
  String get sellerProductPriceLabel => 'السعر';

  @override
  String get sellerProductSpecialPriceFrom => 'السعر الخاص من';

  @override
  String get sellerProductSpecialPriceTo => 'السعر الخاص إلى';

  @override
  String get sellerProductShortDescription => 'وصف مختصر';

  @override
  String get sellerProductFullDescription => 'الوصف الكامل';

  @override
  String get sellerProductIdentity => 'الهوية';

  @override
  String get sellerProductFlags => 'الظهور';

  @override
  String get sellerProductVisibleIndividually => 'ظاهر بشكل فردي';

  @override
  String get sellerProductFeaturedFlag => 'مميز';

  @override
  String get sellerProductNewFlag => 'جديد';

  @override
  String get sellerProductGuestCheckout => 'الدفع كضيف';

  @override
  String get sellerProductImages => 'الصور';

  @override
  String get sellerProductAddImageUrl => 'إضافة رابط صورة';

  @override
  String get sellerProductPickImage => 'اختيار من الجهاز';

  @override
  String get sellerProductImageUrlHint => 'https://…';

  @override
  String get sellerProductVideos => 'مقاطع الفيديو';

  @override
  String get sellerProductNoVideos => 'لا توجد مقاطع فيديو';

  @override
  String get sellerProductAddVideoUrl => 'إضافة رابط فيديو';

  @override
  String get sellerProductPickVideo => 'اختيار من الجهاز';

  @override
  String get sellerProductVideoUrlHint => 'https://…';

  @override
  String get sellerProductVideoTooLarge => 'يجب ألا يتجاوز حجم الفيديو 2MB';

  @override
  String get sellerProductNoCategories =>
      'لم يمنح المسؤول هذا المتجر أي فئات لتصنيف المنتجات ضمنها.';

  @override
  String get sellerProductSaved => 'تم تحديث المنتج بنجاح';

  @override
  String get sellerProductNoStockLocations =>
      'أضف موقع مخزون قبل تحديد المخزون.';

  @override
  String get sellerProductEditAction => 'تعديل';

  @override
  String get sellerProductDeleteAction => 'حذف المنتج';

  @override
  String get sellerProductUnassignAction => 'إيقاف بيع هذا المنتج';

  @override
  String get sellerProductDeleteConfirm => 'هل تريد حذف هذا المنتج من السوق؟';

  @override
  String get sellerProductUnassignConfirm => 'هل تريد إزالة عرضك لهذا المنتج؟';

  @override
  String get sellerProductDeleted => 'تم حذف المنتج بنجاح';

  @override
  String sellerProductsSelected(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get sellerProductsDeleteSelected => 'حذف المحدد';

  @override
  String sellerProductsBulkResult(int removed, int skipped) {
    return 'تمت إزالة $removed، وتم تخطي $skipped';
  }

  @override
  String get sellerTypeReplaceNotice =>
      'هذا ما يحتويه المنتج حاليًا. يؤدي الحفظ إلى إرسال المجموعة بالكامل، لذا فإن أي صف يتم حذفه هنا سيُحذف من السوق.';

  @override
  String get sellerBundleNotice =>
      'هذا ما يحتويه المنتج حاليًا. يحتاج كل خيار إلى منتج واحد على الأقل، وإلا سيرفض الخادم الحفظ.';

  @override
  String get sellerBundleNeedsProduct =>
      'يحتاج كل خيار في الحزمة إلى منتج واحد على الأقل. أضف منتجًا أو احذف الخيار.';

  @override
  String get sellerPickProductHint => 'ابحث بالاسم أو SKU';

  @override
  String get sellerPickProductEmpty => 'لا توجد منتجات مطابقة';

  @override
  String get sellerVariantsNotice =>
      'عدّل تفاصيل المتغير أو أضف تركيبات خيارات من هنا.';

  @override
  String get sellerVariantsTitle => 'المتغيرات';

  @override
  String get sellerGroupedTitle => 'المنتجات المجمّعة';

  @override
  String get sellerGroupedAdd => 'إضافة منتج';

  @override
  String get sellerRelatedProductsTitle => 'المنتجات ذات الصلة';

  @override
  String get sellerRelatedProductsAdd => 'إضافة منتج ذي صلة';

  @override
  String get sellerUpSellsTitle => 'المبيعات الأعلى';

  @override
  String get sellerUpSellsAdd => 'إضافة منتج للبيع الأعلى';

  @override
  String get sellerCrossSellsTitle => 'المبيعات المتقاطعة';

  @override
  String get sellerCrossSellsAdd => 'إضافة منتج للبيع المتقاطع';

  @override
  String get sellerBundleTitle => 'خيارات الحزمة';

  @override
  String get sellerBundleAdd => 'إضافة خيار';

  @override
  String get sellerDownloadableTitle => 'روابط التنزيل';

  @override
  String get sellerDownloadableAdd => 'إضافة رابط';

  @override
  String get sellerDownloadableSamplesTitle => 'عينات قابلة للتنزيل';

  @override
  String get sellerDownloadableSamplesNotice =>
      'معاينات مجانية يمكن للمتسوق تنزيلها قبل الشراء. يؤدي الحفظ إلى إرسال المجموعة بالكامل، لذا فإن أي صف يتم حذفه هنا سيُحذف من السوق.';

  @override
  String get sellerDownloadableSampleAdd => 'إضافة عينة';

  @override
  String get sellerBookingTitle => 'الحجز';

  @override
  String get sellerPickProductTitle => 'اختر منتجًا';

  @override
  String get sellerOrdersTitle => 'الطلبات';

  @override
  String get sellerOrdersEmpty => 'لا توجد طلبات بعد';

  @override
  String get sellerOrdersEmptyHint => 'ستظهر هنا الطلبات المقدمة لمنتجاتك.';

  @override
  String get sellerOrdersSearchHint => 'رقم الطلب أو العميل أو الحالة';

  @override
  String sellerOrdersCount(int count) {
    return '$count طلبات';
  }

  @override
  String get sellerOrderPayoutPending => 'الفاتورة قيد الانتظار';

  @override
  String get sellerOrderPayoutRequested => 'تم الطلب';

  @override
  String get sellerOrderPayoutPaid => 'مدفوع';

  @override
  String get sellerOrderPayoutRefunded => 'تم الاسترداد';

  @override
  String get sellerOrderDetailTitle => 'الطلب';

  @override
  String get sellerOrderItems => 'العناصر';

  @override
  String get sellerOrderTabInformation => 'المعلومات';

  @override
  String get sellerOrderSubTotal => 'المجموع الفرعي';

  @override
  String get sellerOrderTax => 'الضريبة';

  @override
  String get sellerOrderDiscount => 'الخصم';

  @override
  String get sellerOrderShipping => 'الشحن والمناولة';

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
  String get sellerOrderOrdered => 'تم الطلب';

  @override
  String get sellerOrderInvoiced => 'تمت الفوترة';

  @override
  String get sellerOrderShipped => 'تم الشحن';

  @override
  String get sellerOrderRefunded => 'تم الاسترداد';

  @override
  String get sellerOrderCancelled => 'تم الإلغاء';

  @override
  String get sellerOrderInvoice => 'الفاتورة';

  @override
  String get sellerOrderShipment => 'الشحنة';

  @override
  String get sellerOrderPrint => 'طباعة';

  @override
  String get sellerOrderNoInvoices => 'لم يتم إصدار فواتير بعد';

  @override
  String get sellerOrderNoShipments => 'لم يتم شحن أي شيء بعد';

  @override
  String get sellerOrderBookingFailed => 'لم تقبل شركة الشحن الحجز';

  @override
  String get sellerOrderInvoices => 'الفواتير';

  @override
  String get sellerOrderShipments => 'الشحنات';

  @override
  String get sellerOrderRefunds => 'المبالغ المستردة';

  @override
  String get sellerOrderCustomer => 'العميل';

  @override
  String get sellerOrderEarnings => 'أرباحك';

  @override
  String get sellerOrderCommission => 'العمولة';

  @override
  String get sellerOrderTotal => 'إجمالي الطلب';

  @override
  String get sellerOrderItemsLabel => 'العناصر';

  @override
  String get sellerOrdersFilterAll => 'الكل';

  @override
  String get sellerOrderCreateInvoice => 'إنشاء فاتورة';

  @override
  String get sellerOrderCreateShipment => 'إنشاء شحنة';

  @override
  String get sellerOrderCancelAction => 'إلغاء الطلب';

  @override
  String get sellerOrderRequestPayment => 'طلب الدفع';

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
  String get sellerOrderCancelConfirm => 'هل تريد إلغاء عناصرك في هذا الطلب؟';

  @override
  String get sellerOrderInvoiceCreated => 'تم إنشاء الفاتورة';

  @override
  String get sellerOrderShipmentCreated => 'تم إنشاء الشحنة';

  @override
  String get sellerOrderPaymentRequested => 'تم طلب الدفع';

  @override
  String get sellerOrderCarrier => 'شركة الشحن';

  @override
  String get sellerOrderTrackingNumber => 'رقم التتبع';

  @override
  String get sellerOrderParcel => 'الطرد';

  @override
  String get sellerOrderPickup => 'الاستلام';

  @override
  String get sellerOrderPickupDate => 'اختر تاريخًا';

  @override
  String get sellerOrderPickupInstructions => 'تعليمات للسائق';

  @override
  String get sellerOrderShipFrom => 'الشحن من';

  @override
  String get sellerOrderQtyToInvoice => 'للفوترة';

  @override
  String get sellerOrderQtyToShip => 'للشحن';

  @override
  String get sellerOrderNothingToInvoice => 'تم إصدار فواتير لكل شيء بالفعل';

  @override
  String get sellerOrderNothingToShip => 'لا شيء في انتظار الشحن';

  @override
  String get sellerOrderDownloadInvoice => 'تنزيل الفاتورة';

  @override
  String get sellerOrderNoPermission =>
      'دورك لا يتضمن صلاحية الوصول إلى الطلبات.';

  @override
  String get sellerEarningsMenu => 'المعاملات';

  @override
  String get sellerEarningsTitle => 'المعاملات';

  @override
  String get sellerEarningsTotalSale => 'إجمالي المبيعات';

  @override
  String get sellerEarningsYourShare => 'حصتك';

  @override
  String get sellerEarningsCommission => 'العمولة';

  @override
  String get sellerEarningsPaidOut => 'المبلغ المدفوع';

  @override
  String get sellerEarningsRemaining => 'بانتظار الدفع';

  @override
  String get sellerEarningsTransactions => 'سجل المدفوعات';

  @override
  String get sellerEarningsNoTransactions => 'لم يتم تسجيل أي مدفوعات بعد';

  @override
  String get sellerEarningsDownloadReceipt => 'تنزيل الإيصال';

  @override
  String get sellerEarningsNoPermission =>
      'دورك لا يتضمن صلاحية الوصول إلى المدفوعات.';

  @override
  String get sellerReportsMenu => 'التقارير';

  @override
  String get sellerReportsTitle => 'التقارير';

  @override
  String get sellerReportsFormatGraph => 'رسم بياني';

  @override
  String get sellerReportsFormatTable => 'جدول';

  @override
  String get sellerReportsPeriodDay => 'يومي';

  @override
  String get sellerReportsPeriodMonth => 'شهري';

  @override
  String get sellerReportsPeriodYear => 'سنوي';

  @override
  String get sellerReportsEmpty => 'لا توجد أرقام لهذه الفترة';

  @override
  String get sellerReportsNone => 'لا توجد تقارير متاحة لدورك.';

  @override
  String get sellerReportsExport => 'تصدير كجدول بيانات';

  @override
  String get sellerReportsViewDetails => 'عرض التفاصيل';

  @override
  String get sellerReportsVsPrevious => 'مقارنة بالفترة السابقة';

  @override
  String get sellerReportsEntitySales => 'المبيعات';

  @override
  String get sellerReportsEntityProducts => 'المنتجات';

  @override
  String get sellerReportsEntityCustomers => 'العملاء';

  @override
  String get sellerAssignMenu => 'بيع منتج موجود';

  @override
  String get sellerAssignTitle => 'بع منتجك';

  @override
  String get sellerAssignSearchHint => 'ابحث في كتالوج السوق';

  @override
  String get sellerAssignEmpty => 'لا يوجد شيء يمكنك بيعه حتى الآن';

  @override
  String get sellerAssignAction => 'بيع هذا المنتج';

  @override
  String get sellerAssignAlreadySelling => 'أنت تبيع هذا المنتج بالفعل';

  @override
  String sellerAssignSellersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بائعًا',
      few: '$count بائعين',
      two: 'بائعان',
      one: 'بائع واحد',
      zero: 'لا يوجد بائعون بعد',
    );
    return '$_temp0';
  }

  @override
  String get sellerAssignLowestPrice => 'أقل عرض';

  @override
  String get sellerAssignYourPrice => 'سعرك';

  @override
  String get sellerAssignCondition => 'الحالة';

  @override
  String get sellerAssignConditionNew => 'جديد';

  @override
  String get sellerAssignConditionOld => 'مستعمل';

  @override
  String get sellerAssignDescription => 'وصفك';

  @override
  String get sellerAssignStock => 'المخزون';

  @override
  String get sellerAssignSubmit => 'ابدأ البيع';

  @override
  String get sellerAssignDone =>
      'تم الإدراج. سيصبح متاحًا بمجرد موافقة السوق عليه.';

  @override
  String get sellerAssignNoPermission => 'دورك لا يتضمن بيع المنتجات الموجودة.';

  @override
  String get sellerBarcodeTitle => 'الباركود';

  @override
  String get sellerBarcodeMenu => 'الباركود';

  @override
  String get sellerBarcodeNone => 'لم يتم إنشاء باركود بعد';

  @override
  String get sellerBarcodeGenerate => 'إنشاء باركود';

  @override
  String get sellerBarcodeRegenerate => 'إعادة الإنشاء';

  @override
  String get sellerBarcodeSymbology => 'نوع الترميز';

  @override
  String get sellerBarcodeDownload => 'تنزيل PDF';

  @override
  String get sellerBarcodeBulkGenerate => 'إنشاء الباركودات';

  @override
  String get sellerBarcodeBulkPrint => 'طباعة الباركودات';

  @override
  String sellerBarcodeBatchResult(int generated, int skipped) {
    return 'تم إنشاء $generated، وتم تخطي $skipped';
  }

  @override
  String get sellerBarcodeNoPermission => 'دورك لا يتضمن الباركود.';

  @override
  String get sellerMagicAiTitle => 'Magic AI';

  @override
  String get sellerMagicAiMenu => 'التعبئة باستخدام Magic AI';

  @override
  String get sellerMagicAiPrompt => 'صف المنتج';

  @override
  String get sellerMagicAiPromptHint =>
      'مصباح مكتب نحاسي بلمبة دافئة قابلة لتعديل السطوع';

  @override
  String get sellerMagicAiGenerate => 'إنشاء';

  @override
  String get sellerMagicAiFields => 'الحقول المراد تعبئتها';

  @override
  String get sellerMagicAiSuggested => 'القيم المقترحة';

  @override
  String get sellerMagicAiSkipped => 'لم تتم التعبئة';

  @override
  String get sellerMagicAiApply => 'نسخ إلى الحافظة';

  @override
  String get sellerMagicAiCopied => 'تم النسخ';

  @override
  String get sellerMagicAiOffGlobally => 'ميزة Magic AI متوقفة في السوق.';

  @override
  String get sellerMagicAiOff => 'ميزة Magic AI غير متاحة لهذا المنتج.';

  @override
  String get sellerReturnsMenu => 'RMA';

  @override
  String get sellerReturnsTitle => 'طلبات الإرجاع';

  @override
  String get sellerReturnsSearchHint => 'البحث حسب الطلب أو المنتج أو العميل';

  @override
  String get sellerReturnsEmpty => 'لا توجد طلبات إرجاع';

  @override
  String get sellerReturnsNoPermission => 'دورك لا يتضمن عمليات الإرجاع.';

  @override
  String get sellerReturnDetailTitle => 'طلب إرجاع';

  @override
  String get sellerReturnResolution => 'المطلوب';

  @override
  String get sellerReturnStepPending => 'قيد الانتظار';

  @override
  String get sellerReturnStepApproved => 'تمت الموافقة';

  @override
  String get sellerReturnStepAwaiting => 'بانتظار الإرجاع';

  @override
  String get sellerReturnStepTransit => 'قيد الشحن';

  @override
  String get sellerReturnStepRefunded => 'تم استرداد المبلغ';

  @override
  String get sellerReturnStepDeclined => 'مرفوض';

  @override
  String get sellerReturnStepCancelled => 'تم إلغاء العنصر';

  @override
  String get sellerReturnStepWithdrawn => 'تم السحب';

  @override
  String get sellerReturnReason => 'السبب';

  @override
  String get sellerReturnQuantity => 'الكمية';

  @override
  String get sellerReturnPackage => 'الطرد';

  @override
  String get sellerReturnCustomerNote => 'ما قاله العميل';

  @override
  String get sellerReturnPhotos => 'صور العميل';

  @override
  String get sellerReturnConversation => 'المحادثة';

  @override
  String get sellerReturnReply => 'اكتب ردًا';

  @override
  String get sellerReturnSend => 'إرسال';

  @override
  String get sellerReturnChangeStatus => 'تغيير الحالة';

  @override
  String get sellerReturnReopen => 'إعادة فتح الطلب';

  @override
  String get sellerReturnStatusLocked =>
      'لم يعد بالإمكان تغيير حالة هذا الطلب.';

  @override
  String get sellerReturnRefundWarning =>
      'سيؤدي هذا إلى استرداد مبلغ العنصر المرتجع. لا يمكن التراجع عن ذلك.';

  @override
  String get sellerReturnCancelWarning =>
      'سيؤدي هذا إلى إلغاء العنصر في الطلب. لا يمكن التراجع عن ذلك.';

  @override
  String get sellerReturnNotInvoiced => 'لم تصدر فاتورة بعد';

  @override
  String get sellerBookingsMenu => 'الحجوزات';

  @override
  String get sellerBookingsFilters => 'عوامل التصفية';

  @override
  String get sellerBookingsFilterOrder => 'رقم الطلب';

  @override
  String get sellerBookingsFilterProduct => 'رقم المنتج';

  @override
  String get sellerBookingsFilterId => 'رقم الحجز';

  @override
  String get sellerBookingsFilterQty => 'الكمية';

  @override
  String get sellerBookingsFilterFrom => 'من';

  @override
  String get sellerBookingsFilterTo => 'إلى';

  @override
  String get sellerBookingsFilterApply => 'تطبيق عوامل التصفية';

  @override
  String get sellerBookingsFilterClear => 'مسح';

  @override
  String get sellerBookingsFilterToday => 'اليوم';

  @override
  String get sellerBookingsFilterThisWeek => 'هذا الأسبوع';

  @override
  String get sellerBookingsFilterThisMonth => 'هذا الشهر';

  @override
  String get sellerBookingsFilterLast3Months => 'آخر 3 أشهر';

  @override
  String get sellerBookingsTitle => 'الحجوزات';

  @override
  String get sellerBookingsEmpty => 'لا توجد فترات محجوزة';

  @override
  String get sellerBookingsAllDates => 'كل التواريخ';

  @override
  String get sellerBookingsPickRange => 'التواريخ';

  @override
  String get sellerBookingsCalendarView => 'التقويم';

  @override
  String get sellerBookingsListView => 'قائمة';

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
  String get sellerBookingsNoPermission => 'دورك لا يتضمن الحجوزات.';

  @override
  String get sellerBookingSlot => 'الفترة';

  @override
  String get sellerBookingGuests => 'الضيوف';

  @override
  String get sellerBookingContact => 'جهة الاتصال';

  @override
  String get sellerBookingCancellable => 'الإلغاء مسموح';

  @override
  String get sellerCustomersMenu => 'العملاء';

  @override
  String get sellerCustomersTitle => 'العملاء';

  @override
  String get sellerCustomersSearchHint => 'البحث بالاسم أو البريد الإلكتروني';

  @override
  String get sellerCustomersEmpty => 'لا يوجد عملاء بعد';

  @override
  String get sellerCustomersNoPermission => 'دورك لا يتضمن العملاء.';

  @override
  String get sellerCustomerRevenue => 'أنفقوا لديك';

  @override
  String get sellerCustomerOrders => 'الطلبات';

  @override
  String get sellerCustomerActive => 'نشط';

  @override
  String get sellerCustomerInactive => 'غير نشط';

  @override
  String get sellerProductAssigned => 'مُسند';

  @override
  String get sellerProductOwn => 'منتجاتك';

  @override
  String get sellerProductDraftBadge => 'مسودة';

  @override
  String get sellerTransactionOrder => 'الطلب';

  @override
  String get sellerReviewsMenu => 'المراجعات';

  @override
  String get sellerReviewsTitle => 'الأداء';

  @override
  String get sellerReviewsOnProducts => 'على المنتجات';

  @override
  String get sellerReviewsOnShop => 'على متجرك';

  @override
  String get sellerReviewsEmpty => 'لا توجد مراجعات بعد';

  @override
  String get sellerReviewsNoPermission => 'دورك لا يتضمن المراجعات.';

  @override
  String get sellerReviewPending => 'قيد الانتظار';

  @override
  String get sellerReviewApproved => 'تمت الموافقة';

  @override
  String get sellerReviewDisapproved => 'غير منشورة';

  @override
  String get sellerReviewDate => 'التاريخ';

  @override
  String get sellerMarketingMenu => 'التسويق';

  @override
  String get sellerMarketingTitle => 'التسويق';

  @override
  String get sellerMarketingDiscounts => 'خصومات المنتجات';

  @override
  String get sellerMarketingJoinable => 'الانضمام إلى خصومات المنتجات';

  @override
  String get sellerMarketingDeals => 'عروض الدفع';

  @override
  String get sellerMarketingNoPermission => 'دورك لا يتضمن التسويق.';

  @override
  String get sellerMarketingEmptyDiscounts => 'لا توجد خصومات منتجات بعد';

  @override
  String get sellerMarketingEmptyJoinable =>
      'لا توجد خصومات متاحة للانضمام حاليًا';

  @override
  String get sellerMarketingEmptyDeals => 'لا توجد عروض دفع بعد';

  @override
  String get sellerMarketingJoin => 'انضمام';

  @override
  String get sellerMarketingLeave => 'مغادرة';

  @override
  String get sellerMarketingJoined => 'تم الانضمام';

  @override
  String get sellerMarketingNotEnrolled => 'Not Enrolled';

  @override
  String get sellerMarketingParticipation => 'Participation';

  @override
  String get sellerMarketingNewDiscount => 'خصم جديد';

  @override
  String get sellerMarketingNewDeal => 'عرض جديد';

  @override
  String get sellerMarketingName => 'الاسم';

  @override
  String get sellerMarketingDescription => 'الوصف';

  @override
  String get sellerMarketingActive => 'نشط';

  @override
  String get sellerMarketingInactive => 'غير نشط';

  @override
  String get sellerMarketingScheduled => 'مجدول';

  @override
  String get sellerMarketingExpired => 'منتهٍ';

  @override
  String get sellerMarketingDiscountType => 'الخصم';

  @override
  String get sellerMarketingAmount => 'المبلغ';

  @override
  String get sellerMarketingDiscountPercentLabel => 'نسبة الخصم (%)';

  @override
  String get sellerMarketingDiscountAmountLabel => 'مبلغ الخصم';

  @override
  String get sellerRuleMaxDiscountedQuantity => 'الحد الأقصى للكمية المخفضة';

  @override
  String get sellerMarketingStarts => 'يبدأ';

  @override
  String get sellerMarketingEnds => 'ينتهي';

  @override
  String get sellerMarketingNeedsCoupon => 'يتطلب رمز قسيمة';

  @override
  String get sellerMarketingAutoCoupons => 'إنشاء مجموعة من الرموز';

  @override
  String get sellerMarketingCouponCode => 'رمز القسيمة';

  @override
  String get sellerMarketingUsesPerCoupon => 'عدد الاستخدامات لكل رمز';

  @override
  String get sellerMarketingUsagePerCustomer => 'عدد الاستخدامات لكل عميل';

  @override
  String get sellerMarketingCopyDeal => 'تكرار';

  @override
  String get sellerMarketingDeleteConfirm => 'حذف هذا نهائيًا؟';

  @override
  String get sellerMarketingTimesUsed => 'مرات الاستخدام';

  @override
  String get sellerCouponsTitle => 'رموز القسائم';

  @override
  String get sellerCouponsEmpty => 'لم يتم إنشاء رموز بعد';

  @override
  String get sellerCouponsGenerate => 'إنشاء رموز';

  @override
  String get sellerCouponsQuantity => 'الكمية المطلوبة';

  @override
  String get sellerCouponsLength => 'طول الرمز';

  @override
  String get sellerCouponsPrefix => 'البادئة';

  @override
  String get sellerCouponsMinLength =>
      'يجب أن تتكون الرموز من 10 أحرف على الأقل.';

  @override
  String get sellerCouponsSpent => 'مستنفد';

  @override
  String get sellerBulkMenu => 'إدارة التسعير';

  @override
  String get sellerBulkTitle => 'تعديل جماعي';

  @override
  String get sellerBulkPricingTab => 'التسعير';

  @override
  String get sellerBulkPrice => 'السعر';

  @override
  String get sellerBulkSalePrice => 'سعر البيع';

  @override
  String get sellerBulkValidFrom => 'صالح من';

  @override
  String get sellerBulkValidTo => 'صالح حتى';

  @override
  String sellerBulkResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      one: 'نتيجة واحدة',
      zero: 'لا توجد نتائج',
    );
    return '$_temp0';
  }

  @override
  String get sellerBulkStockTab => 'المخزون';

  @override
  String get sellerBulkSave => 'حفظ التغييرات';

  @override
  String get sellerBulkDiscard => 'تجاهل';

  @override
  String sellerBulkPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات',
      one: 'تغيير واحد',
    );
    return '$_temp0';
  }

  @override
  String sellerBulkSaved(int saved, int skipped) {
    return 'تم حفظ $saved، وتخطي $skipped';
  }

  @override
  String get sellerBulkSavedSuccess => 'تم حفظ الأسعار بنجاح.';

  @override
  String get sellerBulkNoPermission => 'دورك لا يتضمن التعديل الجماعي.';

  @override
  String sellerBulkSelected(int count, int total) {
    return 'تم تحديد $count من $total';
  }

  @override
  String get sellerBulkSelectAll => 'تحديد الكل';

  @override
  String get sellerBulkAction => 'الإجراء';

  @override
  String get sellerBulkValue => 'القيمة';

  @override
  String get sellerBulkApply => 'تطبيق';

  @override
  String get sellerBulkSetTo => 'تعيين إلى';

  @override
  String get sellerBulkIncreaseBy => 'زيادة بمقدار';

  @override
  String get sellerBulkDecreaseBy => 'تخفيض بمقدار';

  @override
  String get sellerBulkQuantity => 'الكمية';

  @override
  String get sellerBulkMode => 'الوضع';

  @override
  String get sellerBulkTiers => 'أسعار مجموعات العملاء';

  @override
  String get sellerBulkTiersNotice =>
      'ما يحتويه هذا المنتج حاليًا. الحفظ يستبدل جميع أسعار المجموعات الموجودة له.';

  @override
  String get sellerBulkTierAllGroups => 'جميع المجموعات';

  @override
  String get sellerBulkTierAdd => 'إضافة سعر مجموعة';

  @override
  String get sellerBulkTierGroup => 'مجموعة العملاء';

  @override
  String get sellerBulkTierFixed => 'ثابت';

  @override
  String get sellerBulkTierDiscount => 'الخصم (%)';

  @override
  String get sellerBulkAmount => 'المبلغ';

  @override
  String get sellerBulkPercent => 'النسبة (%)';

  @override
  String get sellerBulkActivate => 'تفعيل';

  @override
  String get sellerBulkDeactivate => 'إلغاء التفعيل';

  @override
  String get sellerImportsMenu => 'الرفع الجماعي';

  @override
  String get sellerImportsTitle => 'الرفع الجماعي';

  @override
  String get sellerImportsEmpty => 'لا توجد عمليات رفع بعد';

  @override
  String get sellerImportsNoPermission => 'دورك لا يتضمن الرفع الجماعي.';

  @override
  String get sellerImportsSamples => 'جداول بيانات نموذجية';

  @override
  String get sellerImportsUpload => 'رفع الجدول';

  @override
  String get sellerImportOwnTitle => 'اعرض منتجاتك الخاصة';

  @override
  String get sellerImportCatalogueTitle => 'بيع منتجات الكتالوج';

  @override
  String get sellerImportOwnBlurb =>
      'أنشئ منتجات جديدة في كتالوجك بشكل جماعي من جدول بيانات.';

  @override
  String get sellerImportCatalogueBlurb =>
      'أضف المنتجات الموجودة في كتالوج السوق إلى متجرك، بسعرك ومخزونك الخاص.';

  @override
  String get sellerImportSource => 'المصدر';

  @override
  String get sellerImportSourceHelp => 'اختر الملف المراد استيراده.';

  @override
  String get sellerImportRequiredColumns => 'يجب ملء هذه الأعمدة في كل صف';

  @override
  String get sellerImportCatalogueSheetHelp =>
      'يحتاج كل صف إلى SKU لمنتج الكتالوج إضافةً إلى تفاصيل البيع الخاصة بك: السعر وكمية المخزون والحالة ووصف اختياري. تأتي الصور من منتج الكتالوج.';

  @override
  String get sellerImportFile => 'جدول بيانات';

  @override
  String get sellerImportImages => 'الصور';

  @override
  String get sellerImportImagesHelp =>
      'اختياري. ملف zip مسطح تطابق أسماء ملفاته عمود الصور في الجدول. الصفوف التي تحدد الصور برابط URL لا تحتاج إلى ملف zip.';

  @override
  String get sellerImportImagesZip => 'ملف zip للصور';

  @override
  String get sellerImportSettings => 'الإعدادات';

  @override
  String get sellerImportSettingsHelp =>
      'مدى صرامة قراءة الجدول وكيفية تشغيله.';

  @override
  String get sellerImportAction => 'الإجراء';

  @override
  String get sellerImportValidation => 'الصفوف الخاطئة';

  @override
  String get sellerImportAllowedErrors => 'الأخطاء المسموح بها';

  @override
  String get sellerImportEditSettings => 'تعديل الإعدادات';

  @override
  String get sellerImportReimport => 'إعادة الاستيراد';

  @override
  String get sellerImportEditResets =>
      'تغيير هذه الإعدادات يعيد تعيين المهمة، لذلك تتم قراءة الجدول من البداية مرة أخرى.';

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
  String get sellerImportDownloadFile => 'تنزيل الجدول';

  @override
  String get sellerImportSeparator => 'فاصل الأعمدة';

  @override
  String get sellerImportQueue => 'التشغيل في الخلفية';

  @override
  String get sellerImportQueueHelp =>
      'يسلّم التشغيل بالكامل إلى معالج قائمة الانتظار. يتطلب إعداد قائمة انتظار على الخادم.';

  @override
  String get sellerImportBack => 'رجوع';

  @override
  String get sellerImportNext => 'التالي';

  @override
  String get sellerImportStart => 'رفع';

  @override
  String get sellerImportChoose => 'اختر طريقة إضافة المنتجات بالجملة.';

  @override
  String get sellerImportPastUploads => 'عمليات الرفع السابقة';

  @override
  String get sellerImportReportTitle => 'النتيجة';

  @override
  String get sellerImportCreated => 'تم الإنشاء';

  @override
  String get sellerImportUpdated => 'تم التحديث';

  @override
  String get sellerImportRemoved => 'تمت الإزالة';

  @override
  String get sellerImportSkipped => 'تم التخطي';

  @override
  String get sellerImportImagesFetched => 'الصور';

  @override
  String get sellerImportDeleteSelected => 'حذف المحدد';

  @override
  String get sellerDownloadStarted => 'جارٍ التنزيل…';

  @override
  String get sellerDownloadFailed => 'تعذر تنزيل هذا الملف';

  @override
  String get sellerDownloadNoApp =>
      'لا يوجد تطبيق على هذا الجهاز يمكنه فتح هذا الملف';

  @override
  String get sellerImportsRun => 'تشغيل';

  @override
  String sellerImportsNextStep(String step) {
    return 'التالي: $step';
  }

  @override
  String get sellerImportsFinished => 'اكتمل';

  @override
  String get sellerImportProcessTitle => 'استيراد';

  @override
  String get sellerImportReady => 'تحقق من الملف لفحص عملية الاستيراد.';

  @override
  String get sellerImportValidateAction => 'تحقق';

  @override
  String get sellerImportValidating => 'جارٍ قراءة ملفك والتحقق منه…';

  @override
  String sellerImportRowsValidated(int processed, int total) {
    return 'تم التحقق من $processed / $total صف';
  }

  @override
  String get sellerImportDownloadingImages => 'جارٍ تنزيل صور المنتجات…';

  @override
  String sellerImportImagesProgress(int processed, int total) {
    return 'تم تنزيل $processed / $total صورة';
  }

  @override
  String get sellerImportCreating => 'جارٍ إنشاء منتجاتك…';

  @override
  String get sellerImportAssigning => 'جارٍ إضافة المنتجات إلى متجرك…';

  @override
  String get sellerImportDeleting => 'جارٍ حذف منتجاتك…';

  @override
  String get sellerImportLinking => 'جارٍ ربط المنتجات ذات الصلة…';

  @override
  String get sellerImportIndexing => 'جارٍ إنهاء الأسعار والمخزون…';

  @override
  String get sellerImportValid =>
      'ملفك صالح. ابدأ الاستيراد عندما تكون جاهزًا.';

  @override
  String get sellerImportPartly =>
      'بعض الصفوف بها أخطاء وسيتم تخطيها. يمكن استيراد الباقي.';

  @override
  String get sellerImportInvalid =>
      'لا يمكن استيراد هذا الملف. أصلح الأخطاء أدناه وارفعه مرة أخرى.';

  @override
  String get sellerImportStartAction => 'بدء الاستيراد';

  @override
  String get sellerImportContinueAction => 'استيراد الباقي';

  @override
  String get sellerImportRowsProcessed => 'الصفوف المقروءة';

  @override
  String get sellerImportRowsInvalid => 'الصفوف غير الصالحة';

  @override
  String get sellerImportErrorCount => 'الأخطاء';

  @override
  String get sellerImportFinished => 'اكتمل الاستيراد.';

  @override
  String get sellerImportFullReport => 'تنزيل التقرير الكامل';

  @override
  String get sellerImportActionAppend => 'إنشاء / تحديث';

  @override
  String get sellerImportActionDelete => 'حذف';

  @override
  String get sellerImportReplaceSheet => 'استبدال الجدول';

  @override
  String get sellerImportReplaceImages => 'استبدال ملف zip للصور';

  @override
  String sellerImportFileChosen(String name) {
    return 'ملف جديد: $name';
  }

  @override
  String get sellerImportRecordsCreated => 'تم الإنشاء';

  @override
  String get sellerImportRecordsUpdated => 'تم التحديث';

  @override
  String get sellerImportRecordsDeleted => 'تم الحذف';

  @override
  String get sellerImportStagePending => 'تم الرفع';

  @override
  String get sellerImportStageValidated => 'تم الفحص';

  @override
  String get sellerImportStageProcessed => 'تم الاستيراد';

  @override
  String get sellerImportStageLinked => 'تم الربط';

  @override
  String get sellerImportStageIndexed => 'مباشر';

  @override
  String sellerImportsRows(int processed, int invalid) {
    return '$processed صف، $invalid غير صالح';
  }

  @override
  String get sellerImportsErrorReport => 'تنزيل تقرير الأخطاء';

  @override
  String get sellerSettingsMenu => 'الإعدادات';

  @override
  String get sellerSettingsTitle => 'الإعدادات';

  @override
  String get sellerSettingsGeneralUpdatedSuccessfully =>
      'تم تحديث الإعدادات العامة بنجاح';

  @override
  String get sellerSettingsPreferences => 'التفضيلات';

  @override
  String get sellerSettingsLanguage => 'اللغة';

  @override
  String get sellerSettingsCurrency => 'العملة';

  @override
  String get sellerSettingsEmailNotifications =>
      'أرسل لي رسالة بريد عن الرسائل';

  @override
  String get sellerSettingsPassword => 'تغيير كلمة المرور';

  @override
  String get sellerSettingsCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get sellerSettingsNewPassword => 'كلمة المرور الجديدة';

  @override
  String get sellerSettingsConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get sellerSettingsNewPasswordRequired =>
      'حقل كلمة المرور الجديدة مطلوب عند إدخال كلمة المرور الحالية.';

  @override
  String get sellerSettingsConfirmPasswordRequired =>
      'حقل تأكيد كلمة المرور الجديدة مطلوب عند إدخال كلمة مرور جديدة.';

  @override
  String get sellerSettingsPasswordMismatch =>
      'تأكيد حقل كلمة المرور الجديدة غير مطابق.';

  @override
  String get sellerSettingsStaff => 'الموظفون';

  @override
  String get sellerSettingsStaffEmpty => 'لا يوجد موظفون بعد';

  @override
  String get sellerSettingsAddStaff => 'إنشاء مستخدم';

  @override
  String get sellerSettingsEditStaff => 'تعديل المستخدم';

  @override
  String get sellerSettingsUserNameRequired => 'حقل الاسم مطلوب';

  @override
  String get sellerSettingsUserEmailRequired => 'حقل البريد الإلكتروني مطلوب';

  @override
  String get sellerSettingsUserPhoneRequired => 'حقل رقم الهاتف مطلوب';

  @override
  String get sellerSettingsUserPasswordRequired => 'حقل كلمة المرور مطلوب';

  @override
  String get sellerSettingsUserConfirmPasswordRequired =>
      'حقل تأكيد كلمة المرور مطلوب';

  @override
  String get sellerSettingsUserPasswordMismatch =>
      'تأكيد كلمة المرور غير مطابق';

  @override
  String get sellerSettingsRoles => 'الأدوار';

  @override
  String get sellerSettingsSelectRole => 'Select Role';

  @override
  String get sellerSettingsRoleRequired => 'The Role field is required';

  @override
  String get sellerSettingsRolesEmpty => 'لا توجد أدوار بعد';

  @override
  String get sellerSettingsAddRole => 'إضافة دور';

  @override
  String get sellerSettingsEditRole => 'تعديل الدور';

  @override
  String get sellerSettingsRoleAll => 'وصول كامل';

  @override
  String get sellerSettingsRoleCustom => 'وصول محدود';

  @override
  String get sellerRolePermissions => 'الصلاحيات';

  @override
  String sellerRolePermissionsChosen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count',
      many: 'تم تحديد $count',
      few: 'تم تحديد $count',
      two: 'تم تحديد 2',
      one: 'تم تحديد 1',
      zero: 'لم يتم تحديد شيء',
    );
    return '$_temp0';
  }

  @override
  String get sellerRolePermissionsSearch => 'البحث في الصلاحيات';

  @override
  String get sellerRolePermissionsNone => 'لا توجد صلاحية مطابقة';

  @override
  String get sellerRolePermissionsEdit => 'اختيار الصلاحيات';

  @override
  String get sellerRoleNameRequired => 'أدخل اسمًا للدور';

  @override
  String sellerSettingsRoleInUse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موظف',
      many: '$count موظفًا',
      few: '$count موظفين',
      two: 'موظفان',
      one: 'موظف واحد',
    );
    return '$_temp0';
  }

  @override
  String get sellerSettingsSuspended => 'معلّق';

  @override
  String get sellerSettingsActive => 'Active';

  @override
  String get sellerSettingsAwaitingApproval => 'بانتظار الموافقة';

  @override
  String get sellerSettingsHealth => 'صحة الحساب';

  @override
  String get sellerSettingsHealthRefresh => 'إعادة الحساب';

  @override
  String get sellerSettingsNoPermission => 'دورك لا يتضمن الإعدادات.';

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
      other: '$count بائعين آخرين يبيعون المنتج نفسه',
      one: 'بائع آخر واحد يبيع المنتج نفسه',
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
  String get sellerInboxMenu => 'التواصل';

  @override
  String get sellerInboxTitle => 'الرسائل';

  @override
  String get sellerInboxAdmin => 'المسؤول';

  @override
  String get sellerInboxCustomers => 'العملاء';

  @override
  String get sellerInboxEmpty => 'لا توجد محادثات بعد';

  @override
  String get sellerInboxSearchHint => 'البحث عن العملاء';

  @override
  String get sellerInboxBlocked => 'لقد حظرت هذه المحادثة.';

  @override
  String get sellerInboxAdminBlocked => 'أوقف السوق الردود.';

  @override
  String get sellerInboxBlock => 'حظر';

  @override
  String get sellerInboxUnblock => 'إلغاء الحظر';

  @override
  String get sellerInboxUnreadNote => 'وضع علامة مقروء غير متاح من التطبيق.';

  @override
  String get sellerInboxNoPermission => 'دورك لا يتضمن الرسائل.';

  @override
  String get sellerPlansMenu => 'الخطة والفوترة';

  @override
  String get sellerPlansTitle => 'الخطة';

  @override
  String get sellerPlansCurrent => 'خطتك';

  @override
  String get sellerPlansAvailable => 'الخطط المتاحة';

  @override
  String get sellerPlansHistory => 'الاشتراكات السابقة';

  @override
  String get sellerPlansChoose => 'اختيار';

  @override
  String get sellerPlansCancel => 'إلغاء الاشتراك';

  @override
  String get sellerPlansUnavailable => 'هذا السوق لا يستخدم خططًا مدفوعة.';

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
      other: '$count يوم متبقٍ',
      many: '$count يومًا متبقيًا',
      few: '$count أيام متبقية',
      two: 'يومان متبقيان',
      one: 'يوم واحد متبقٍ',
      zero: 'لا توجد أيام متبقية',
    );
    return '$_temp0';
  }

  @override
  String get sellerPlansMaxProducts => 'المنتجات';

  @override
  String get sellerPlansMaxStaff => 'الموظفون';

  @override
  String get sellerPlansCommission => 'العمولة';

  @override
  String get sellerPlansFree => 'مجاني';

  @override
  String get sellerPickupsMenu => 'عمليات استلام الشحنات';

  @override
  String get sellerPickupsTitle => 'عمليات الاستلام';

  @override
  String get sellerPickupsEmpty => 'لا توجد عمليات استلام محجوزة';

  @override
  String get sellerPickupsConfirmation => 'التأكيد';

  @override
  String sellerPickupsPackages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count طرد',
      many: '$count طردًا',
      few: '$count طرود',
      two: 'طردان',
      one: 'طرد واحد',
      zero: 'لا توجد طرود',
    );
    return '$_temp0';
  }

  @override
  String get sellerPickupsNoPermission => 'دورك لا يتضمن عمليات الاستلام.';

  @override
  String get sellerRuleHowItApplies => 'كيفية التطبيق';

  @override
  String get sellerRuleConditionType => 'الشروط';

  @override
  String get sellerRuleMatchAll => 'مطابقة الكل';

  @override
  String get sellerRuleMatchAny => 'مطابقة أي شرط';

  @override
  String get sellerRulePriority => 'الأولوية';

  @override
  String get sellerRuleEndOthers => 'إيقاف القواعد الأخرى';

  @override
  String get sellerRuleEndOthersHelp =>
      'لا تُطبَّق أي قاعدة ذات أولوية أدنى على سلة تمت مطابقتها بهذه القاعدة.';

  @override
  String get sellerRuleBuyQuantity => 'كمية الشراء';

  @override
  String get sellerRuleFreeStep => 'مجاني كل';

  @override
  String get sellerOrderBillingAddress => 'عنوان الفوترة';

  @override
  String get sellerOrderShippingAddress => 'عنوان الشحن';

  @override
  String get sellerOrderShippingMethodLabel => 'طريقة الشحن';

  @override
  String get sellerOrderPaymentMethodLabel => 'طريقة الدفع';

  @override
  String get sellerOrderNoAddress => 'لا يحتوي الطلب على عنوان';

  @override
  String get sellerProfileLogo => 'شعار المتجر';

  @override
  String get sellerProfileBanner => 'لافتة المتجر';

  @override
  String get sellerProfileImageChange => 'تغيير';

  @override
  String get sellerProfileImageRemove => 'إزالة';

  @override
  String get sellerProfileImageAdd => 'إضافة صورة';

  @override
  String get sellerProfileImageTooLarge =>
      'هذه الصورة كبيرة جدًا — اختر صورة أقل من 2 MB';

  @override
  String get sellerOrderFilters => 'تصفية الطلبات';

  @override
  String get sellerOrderFilterApply => 'تطبيق';

  @override
  String get sellerOrderFilterClear => 'مسح الكل';

  @override
  String get sellerOrderFilterStatus => 'حالة الطلب';

  @override
  String get sellerOrderFilterFrom => 'تاريخ الطلب من';

  @override
  String get sellerOrderFilterTo => 'تاريخ الطلب إلى';

  @override
  String get sellerOrderFilterCustomerName => 'اسم العميل';

  @override
  String get sellerOrderFilterCustomerEmail => 'البريد الإلكتروني للعميل';

  @override
  String get sellerOrderFilterLocation => 'الموقع';

  @override
  String get sellerOrderFilterPaymentMethod => 'طريقة الدفع';

  @override
  String get sellerOrderFilterShippingMethod => 'طريقة الشحن';

  @override
  String get sellerOrderFilterProductName => 'اسم المنتج';

  @override
  String get sellerOrderFilterItemCount => 'عدد العناصر في الطلب';

  @override
  String get sellerOrderFilterSellerTotal => 'إجماليك';

  @override
  String get sellerOrderFilterAny => 'أي';

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
  String get sellerDiscountConditions => 'الشروط';

  @override
  String get sellerDiscountConditionsHelp =>
      'تنطبق القاعدة فقط على المنتجات التي تطابق جميع الشروط. وبدون شروط، تنطبق على كامل كتالوجك.';

  @override
  String get sellerDiscountConditionAdd => 'إضافة شرط';

  @override
  String get sellerDiscountConditionAttribute => 'السمة';

  @override
  String get sellerDiscountConditionOperator => 'المعامل';

  @override
  String get sellerDiscountConditionValue => 'القيمة';

  @override
  String get sellerDiscountConditionRemove => 'إزالة الشرط';

  @override
  String get sellerDiscountConditionChoose => 'اختر شرطًا لإضافته';

  @override
  String get sellerRuleYes => 'نعم';

  @override
  String get sellerRuleNo => 'لا';

  @override
  String get sellerRuleChoose => 'اختيار';

  @override
  String get sellerRuleAddMore => 'إضافة المزيد';

  @override
  String get sellerRuleChannels => 'القنوات';

  @override
  String get sellerRuleCustomerGroups => 'مجموعات العملاء';

  @override
  String get sellerRuleWhoItAppliesTo => 'من تنطبق عليه';

  @override
  String get sellerRuleNoChannel => 'اختر قناة واحدة على الأقل';

  @override
  String get sellerRuleNoCustomerGroup => 'اختر مجموعة عملاء واحدة على الأقل';

  @override
  String get sellerDiscountWebCreateTitle => 'إنشاء خصم على المنتج';

  @override
  String get sellerDiscountWebEditTitle => 'تعديل خصم المنتج';

  @override
  String get sellerDiscountWebSave => 'حفظ خصم المنتج';

  @override
  String get sellerDiscountWebHowTitle =>
      'كيف تريد تطبيق الخصم على هذه المنتجات؟';

  @override
  String get sellerDiscountWebPercentTitle => 'نسبة مئوية من السعر';

  @override
  String get sellerDiscountWebPercentHelp =>
      'خصم نسبة مئوية من كل منتج يطابقه هذا الخصم.';

  @override
  String get sellerDiscountWebFixedTitle => 'مبلغ ثابت من السعر';

  @override
  String get sellerDiscountWebFixedHelp =>
      'خصم مبلغ محدد من كل منتج يطابقه هذا الخصم.';

  @override
  String get sellerDiscountWebAmount => 'مبلغ الخصم';

  @override
  String get sellerDiscountWebNameTitle => 'ماذا تريد أن تسمي هذا الخصم؟';

  @override
  String get sellerDiscountWebName => 'الاسم';

  @override
  String get sellerDiscountWebDescription => 'الوصف';

  @override
  String get sellerDiscountWebWhenTitle => 'متى يعمل؟';

  @override
  String get sellerDiscountWebStartsFrom => 'يبدأ من';

  @override
  String get sellerDiscountWebEndsTill => 'ينتهي في';

  @override
  String get sellerDiscountWebMatchTitle => 'ما المنتجات التي يطابقها؟';

  @override
  String get sellerDiscountWebConditionType => 'نوع الشرط';

  @override
  String get sellerDiscountWebAllTrue => 'جميع الشروط صحيحة';

  @override
  String get sellerDiscountWebAnyTrue => 'أي شرط صحيح';

  @override
  String get sellerDiscountWebAddCondition => 'إضافة شرط';

  @override
  String get sellerDiscountWebSettings => 'الإعدادات';

  @override
  String get sellerDiscountWebChannels => 'القنوات';

  @override
  String get sellerDiscountWebCustomerGroups => 'مجموعات العملاء';

  @override
  String get sellerDiscountWebPriority => 'الأولوية';

  @override
  String get sellerDiscountWebStopFurther => 'إيقاف القواعد الأخرى';

  @override
  String get sellerDiscountWebStopFurtherHelp =>
      'بمجرد تطبيق هذه القاعدة، توقف عن تطبيق قواعدك الأخرى ذات رقم الأولوية الأكبر.';

  @override
  String get sellerDiscountWebStatus => 'الحالة';

  @override
  String get sellerDiscountWebNameRequired => 'حقل الاسم مطلوب';

  @override
  String get sellerDiscountWebAmountRequired => 'حقل مبلغ الخصم مطلوب';

  @override
  String get sellerDiscountWebAmountInvalid =>
      'يجب أن يكون مبلغ الخصم رقمًا لا يقل عن 0';

  @override
  String get sellerDiscountWebPercentMax =>
      'لا يمكن أن تتجاوز النسبة المئوية 100';

  @override
  String get sellerDiscountWebPriorityInvalid =>
      'يجب أن تكون الأولوية عددًا صحيحًا لا يقل عن 0';

  @override
  String get sellerDiscountWebEndBeforeStart =>
      'لا يمكن أن يكون تاريخ الانتهاء قبل تاريخ البدء';

  @override
  String get sellerJoinDetailTitle => 'تفاصيل الخصم';

  @override
  String get sellerJoinDetailGeneral => 'عام';

  @override
  String get sellerJoinDetailActions => 'الإجراءات';

  @override
  String get sellerJoinDetailSettings => 'الإعدادات';

  @override
  String get sellerJoinDetailTime => 'وقت التسويق';

  @override
  String get sellerJoinDetailNoConditions =>
      'لا توجد شروط — تنطبق هذه القاعدة على جميع المنتجات المطابقة.';

  @override
  String get sellerJoinDetailDiscountType => 'نوع الخصم';

  @override
  String get sellerJoinDetailDiscountAmount => 'قيمة الخصم';

  @override
  String get sellerJoinDetailStopRules => 'إيقاف القواعد اللاحقة';

  @override
  String get sellerJoinDetailStopRulesHelp =>
      'بمجرد تطبيق هذه القاعدة، تتوقف قواعدك الأخرى ذات رقم الأولوية الأكبر عن التطبيق.';

  @override
  String get sellerJoinDetailPriority => 'الأولوية';

  @override
  String get sellerJoinDetailStatus => 'الحالة';

  @override
  String get sellerJoinDetailStartsFrom => 'تبدأ من';

  @override
  String get sellerJoinDetailEndsTill => 'تنتهي في';

  @override
  String get sellerJoinDetailView => 'عرض';

  @override
  String get sellerProductVariantsFailed => 'تعذر تحميل السمات لهذه المجموعة';

  @override
  String get sellerProductVariantsNone =>
      'لا تحتوي مجموعة السمات هذه على ما يمكن تنويعه';

  @override
  String get sellerProductVariantsRetry => 'إعادة المحاولة';

  @override
  String get sellerProductVariesWhich => 'ما السمات التي ستتنوع؟';

  @override
  String get sellerProductVariesNeedsOption =>
      'السمة التي حددتها لا تحتوي على خيارات للتنويع';

  @override
  String get sellerProductKindLabel => 'ما نوع المنتج الذي تبيعه؟';

  @override
  String get sellerProductKindSimple => 'منتج مادي';

  @override
  String get sellerProductKindSimpleHelp => 'سلعة ملموسة تشحنها إلى العميل.';

  @override
  String get sellerProductKindVirtual => 'خدمة أو عضوية';

  @override
  String get sellerProductKindVirtualHelp => 'عرض غير ملموس بدون شحن.';

  @override
  String get sellerProductKindDownloadable => 'تنزيل رقمي';

  @override
  String get sellerProductKindDownloadableHelp =>
      'ملف قابل للتنزيل مثل كتاب إلكتروني أو برنامج.';

  @override
  String get sellerProductKindBooking => 'قابل للحجز';

  @override
  String get sellerProductKindBookingHelp =>
      'منتج يحجزه العملاء لتاريخ أو وقت محدد.';

  @override
  String get sellerProductKindBundle => 'حزمة';

  @override
  String get sellerProductKindBundleHelp =>
      'عدة منتجات تُباع معًا كحزمة واحدة.';

  @override
  String get sellerProductKindGrouped => 'منتجات مجمعة';

  @override
  String get sellerProductKindGroupedHelp =>
      'مجموعة من المنتجات ذات الصلة تُعرض معًا.';

  @override
  String get sellerProductHasVariations => 'هل لهذا المنتج متغيرات؟';

  @override
  String get sellerProductHasVariationsHelp =>
      'كل تركيبة تختارها تصبح متغيرًا مستقلًا.';

  @override
  String get sellerProductTabVariants => 'المتغيرات';

  @override
  String get sellerProductTabLinked => 'المنتجات المرتبطة';

  @override
  String get sellerProductTabBundle => 'عناصر الحزمة';

  @override
  String get sellerProductTabDownloads => 'التنزيلات';

  @override
  String get sellerProductTabBooking => 'الحجز';

  @override
  String get sellerLblStatusPending => 'قيد الانتظار';

  @override
  String get sellerLblStatusPendingPayment => 'في انتظار الدفع';

  @override
  String get sellerLblStatusProcessing => 'قيد المعالجة';

  @override
  String get sellerLblStatusCompleted => 'مكتمل';

  @override
  String get sellerLblStatusCanceled => 'ملغي';

  @override
  String get sellerLblStatusClosed => 'مغلق';

  @override
  String get sellerLblStatusFraud => 'احتيال';

  @override
  String get sellerLblStatusRefunded => 'تم الاسترداد';

  @override
  String get sellerLblStatusOnHold => 'معلّق';

  @override
  String get sellerLblStatusApproved => 'تمت الموافقة';

  @override
  String get sellerLblStatusRejected => 'مرفوض';

  @override
  String get sellerLblStatusDraft => 'مسودة';

  @override
  String get sellerLblStatusActive => 'نشط';

  @override
  String get sellerLblStatusInactive => 'غير نشط';

  @override
  String get sellerLblStatusPaid => 'مدفوع';

  @override
  String get sellerLblStatusRequested => 'تم الطلب';

  @override
  String get sellerLblStatusDisapproved => 'غير موافق عليه';

  @override
  String get sellerLblTypeSimple => 'بسيط';

  @override
  String get sellerLblTypeVirtual => 'افتراضي';

  @override
  String get sellerLblTypeConfigurable => 'قابل للتهيئة';

  @override
  String get sellerLblTypeGrouped => 'مجمّع';

  @override
  String get sellerLblTypeBundle => 'حزمة';

  @override
  String get sellerLblTypeDownloadable => 'قابل للتنزيل';

  @override
  String get sellerLblTypeBooking => 'حجز';

  @override
  String get sellerHcOrdersPlaced => 'تاريخ الطلب';

  @override
  String get sellerHcOrdersQty => 'الكمية';

  @override
  String sellerHcOrdersPriceEach(String price) {
    return '$price للوحدة';
  }

  @override
  String get sellerHcOrdersPayoutStatus => 'حالة الدفع';

  @override
  String sellerHcOrdersSkuMax(String sku, int max) {
    return '$sku · الحد الأقصى $max';
  }

  @override
  String get sellerHcOrdersLengthShort => 'الطول';

  @override
  String get sellerHcOrdersWidthShort => 'العرض';

  @override
  String get sellerHcOrdersHeightShort => 'الارتفاع';

  @override
  String get sellerHcOrdersCarrierManual => 'يدوي';

  @override
  String sellerHcPlansWeightKg(String weight) {
    return '$weight كجم';
  }

  @override
  String get sellerHcPlansUnlimited => 'غير محدود';

  @override
  String get sellerHcEarningsTypeCredit => 'دائن';

  @override
  String get sellerHcEarningsTypeDebit => 'مدين';

  @override
  String get sellerHcReportingAverageSales => 'متوسط المبيعات';

  @override
  String get sellerHcReportingTotalOrders => 'إجمالي الطلبات';

  @override
  String get sellerHcReportingPurchaseFunnel => 'مسار الشراء';

  @override
  String get sellerHcReportingAbandonedCarts => 'السلات المتروكة';

  @override
  String get sellerHcReportingTaxCollected => 'الضرائب المحصلة';

  @override
  String get sellerHcReportingShippingCollected => 'الشحن المحصل';

  @override
  String get sellerHcReportingTopPaymentMethods => 'أكثر طرق الدفع استخداماً';

  @override
  String get sellerHcReportingTopSellingProducts => 'المنتجات الأكثر مبيعاً';

  @override
  String get sellerHcReportingSoldProductsQuantity => 'كمية المنتجات المباعة';

  @override
  String get sellerHcReportingProductsAddedToWishlist =>
      'المنتجات المضافة إلى قائمة الأمنيات';

  @override
  String get sellerHcReportingProductsWithMostReviews =>
      'المنتجات الأكثر تقييماً';

  @override
  String get sellerHcReportingProductsWithMostVisits => 'المنتجات الأكثر زيارة';

  @override
  String get sellerHcReportingLastSearchTerms => 'آخر عبارات البحث';

  @override
  String get sellerHcReportingTopSearchTerms => 'أكثر عبارات البحث';

  @override
  String get sellerHcReportingCustomersTraffic => 'زيارات العملاء';

  @override
  String get sellerHcReportingCustomersWithMostSales => 'العملاء الأعلى مبيعاً';

  @override
  String get sellerHcReportingCustomersWithMostOrders => 'العملاء الأكثر طلباً';

  @override
  String get sellerHcReportingCustomersWithMostReviews =>
      'العملاء الأكثر تقييماً';

  @override
  String get sellerHcReportingTopCustomerGroups => 'أفضل مجموعات العملاء';

  @override
  String get sellerHcReportingFunnelVisitors => 'الزوار';

  @override
  String get sellerHcReportingFunnelProductViews => 'مشاهدات المنتج';

  @override
  String get sellerHcReportingFunnelAddedToCart => 'أضيف إلى السلة';

  @override
  String get sellerHcProductsNoneAvailable => 'غير متوفر';

  @override
  String get sellerHcProductsCustomizableItem => 'عنصر قابل للتخصيص';

  @override
  String get sellerHcProductsAddOption => 'إضافة خيار';

  @override
  String get sellerHcProductsNoOptions =>
      'لا توجد خيارات بعد. أضف خيارًا ليتمكن المشترون من تخصيص هذا المنتج.';

  @override
  String get sellerHcProductsOptional => 'اختياري';

  @override
  String sellerHcProductsChoiceCount(int count) {
    return '$count اختيار(ات)';
  }

  @override
  String sellerHcProductsPriceValue(String price) {
    return 'السعر $price';
  }

  @override
  String get sellerHcProductsTitleRequired => 'العنوان مطلوب.';

  @override
  String get sellerHcProductsAddOneChoice => 'أضف اختيارًا واحدًا على الأقل.';

  @override
  String get sellerHcProductsOption => 'خيار';

  @override
  String get sellerHcProductsTitleStar => 'العنوان *';

  @override
  String get sellerHcProductsTypeStar => 'النوع *';

  @override
  String get sellerHcProductsIsRequiredStar => 'مطلوب *';

  @override
  String get sellerHcProductsMaxCharacters => 'الحد الأقصى للأحرف';

  @override
  String get sellerHcProductsMaxCharactersStar => 'Max Characters *';

  @override
  String get sellerHcProductsFileExtensions => 'امتدادات الملفات المدعومة';

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
  String get sellerHcProductsChoices => 'الاختيارات';

  @override
  String get sellerHcProductsAddChoice => 'إضافة اختيار';

  @override
  String get sellerHcProductsLabel => 'التسمية';

  @override
  String get sellerHcProductsOptTypeText => 'نص';

  @override
  String get sellerHcProductsOptTypeTextarea => 'منطقة نص';

  @override
  String get sellerHcProductsOptTypeCheckbox => 'مربع اختيار';

  @override
  String get sellerHcProductsOptTypeRadio => 'زر اختيار';

  @override
  String get sellerHcProductsOptTypeSelect => 'قائمة منسدلة';

  @override
  String get sellerHcProductsOptTypeMultiselect => 'قائمة متعددة الاختيار';

  @override
  String get sellerHcProductsOptTypeDate => 'التاريخ';

  @override
  String get sellerHcProductsOptTypeDatetime => 'التاريخ والوقت';

  @override
  String get sellerHcProductsOptTypeTime => 'الوقت';

  @override
  String get sellerHcProductsOptTypeFile => 'ملف';

  @override
  String get sellerHcProductsUnsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get sellerHcProductsSwitchLocaleWarning =>
      'تغيير اللغة سيتجاهل التغييرات التي لم تحفظها.';

  @override
  String get sellerHcProductsStay => 'البقاء';

  @override
  String get sellerHcProductsSwitch => 'تبديل';

  @override
  String sellerHcProductsFieldRequired(String label) {
    return '$label مطلوب';
  }

  @override
  String sellerHcProductsEnterValid(String label) {
    return 'أدخل $label صالحًا';
  }

  @override
  String sellerHcProductsVariantsError(String message) {
    return 'المتغيرات: $message';
  }

  @override
  String get sellerHcProductsRelatedDefaultLanguage =>
      'تُطبَّق التغييرات على روابط المنتجات هذه في جميع اللغات.';

  @override
  String get sellerHcProductsTabInventory => 'المخزون';

  @override
  String get sellerHcProductsTabMedia => 'الوسائط';

  @override
  String get sellerHcProductsTabOrganization => 'التنظيم';

  @override
  String get sellerHcTypesAdd => 'إضافة';

  @override
  String get sellerHcTypesAddSlot => 'إضافة فترة';

  @override
  String get sellerHcTypesAddTicket => 'إضافة تذكرة';

  @override
  String get sellerHcTypesAvailableFrom => 'متاح من';

  @override
  String get sellerHcTypesAvailableTo => 'متاح حتى';

  @override
  String get sellerHcTypesBookingAppointment => 'حجز موعد';

  @override
  String get sellerHcTypesBookingDefault => 'حجز افتراضي';

  @override
  String get sellerHcTypesBookingEvent => 'حجز فعالية';

  @override
  String get sellerHcTypesBookingRental => 'حجز تأجير';

  @override
  String get sellerHcTypesBookingTable => 'حجز طاولة';

  @override
  String get sellerHcTypesBookingInformation => 'معلومات الحجز';

  @override
  String get sellerHcTypesBookingType => 'نوع الحجز';

  @override
  String get sellerHcTypesBreakTime => 'الاستراحة بين الفترات (دقائق)';

  @override
  String get sellerHcTypesBundleOptionEmpty =>
      'أضف منتجًا واحدًا على الأقل، وإلا لن يبيع هذا الخيار شيئًا.';

  @override
  String get sellerHcTypesChargedPer => 'يُحتسب السعر لكل';

  @override
  String get sellerHcTypesChooseFile => 'اختيار ملف';

  @override
  String get sellerHcTypesDailyAndHourly => 'كلاهما (يوميًا وبالساعة)';

  @override
  String get sellerHcTypesDailyBasis => 'يوميًا';

  @override
  String get sellerHcTypesDailyPrice => 'السعر اليومي';

  @override
  String get sellerHcTypesDay => 'اليوم';

  @override
  String get sellerHcTypesDownloadAllowed => 'التنزيلات المسموحة';

  @override
  String get sellerHcTypesEveryWeek => 'متاح كل أسبوع';

  @override
  String get sellerHcTypesFile => 'ملف';

  @override
  String get sellerHcTypesFileType => 'نوع الملف';

  @override
  String get sellerHcTypesFileUrl => 'رابط الملف';

  @override
  String get sellerHcTypesFriday => 'الجمعة';

  @override
  String get sellerHcTypesGuest => 'ضيف';

  @override
  String get sellerHcTypesGuestCapacity => 'سعة الضيوف';

  @override
  String get sellerHcTypesGuestLimitPerTable => 'Guest Limit Per Table';

  @override
  String get sellerHcTypesHourlyBasis => 'بالساعة';

  @override
  String get sellerHcTypesHourlyPrice => 'السعر بالساعة';

  @override
  String get sellerHcTypesManyBookingsOneDay => 'حجوزات متعددة ليوم واحد';

  @override
  String get sellerHcTypesMonday => 'الاثنين';

  @override
  String get sellerHcTypesNoFileChosen => 'لم يتم اختيار ملف';

  @override
  String get sellerHcTypesNoVariants => 'لا توجد متغيرات لهذا المنتج.';

  @override
  String get sellerHcTypesOneBookingManyDays => 'حجز واحد لعدة أيام';

  @override
  String get sellerHcTypesOptionLabel => 'عنوان الخيار';

  @override
  String get sellerHcTypesPickDate => 'اختر تاريخًا';

  @override
  String get sellerHcTypesPreventBefore => 'منع الجدولة قبل';

  @override
  String get sellerHcTypesQty => 'الكمية';

  @override
  String get sellerHcTypesRentingType => 'نوع التأجير';

  @override
  String get sellerHcTypesSameSlot => 'نفس الفترة لجميع الأيام';

  @override
  String get sellerHcTypesSampleType => 'نوع العينة';

  @override
  String get sellerHcTypesSampleUrl => 'رابط العينة';

  @override
  String get sellerHcTypesSaturday => 'السبت';

  @override
  String get sellerHcTypesSlotDuration => 'مدة الفترة (دقائق)';

  @override
  String get sellerHcTypesSunday => 'الأحد';

  @override
  String get sellerHcTypesThursday => 'الخميس';

  @override
  String get sellerHcTypesTuesday => 'الثلاثاء';

  @override
  String get sellerHcTypesTypeCheckbox => 'خانة اختيار';

  @override
  String get sellerHcTypesTypeMultiselect => 'اختيار متعدد';

  @override
  String get sellerHcTypesTypeRadio => 'اختيار واحد';

  @override
  String get sellerHcTypesTypeSelect => 'قائمة منسدلة';

  @override
  String get sellerHcTypesUrl => 'رابط';

  @override
  String get sellerHcTypesValidUntil => 'صالح حتى';

  @override
  String get sellerHcTypesWednesday => 'الأربعاء';

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
    return 'المنتج #$id';
  }

  @override
  String get sellerHcMarketingDatePlaceholder => 'يوم/شهر/سنة';

  @override
  String sellerHcMarketingCouponsCount(int count) {
    return '$count رمز';
  }

  @override
  String get sellerHcMarketingActionPercentOrder => 'نسبة خصم على الطلب';

  @override
  String get sellerHcMarketingActionFixedOrder => 'مبلغ ثابت من الطلب';

  @override
  String get sellerHcMarketingActionFixedItem => 'مبلغ ثابت على كل منتج';

  @override
  String get sellerHcMarketingActionBuyXGetY => 'اشترِ X واحصل على Y مجانًا';

  @override
  String get sellerHcMarketingActionPercentPrice => 'نسبة من سعر المنتج';

  @override
  String get sellerHcMarketingActionFixedPrice => 'مبلغ ثابت من سعر المنتج';

  @override
  String get sellerHcMarketingImportActionUpdate => 'تحديث';

  @override
  String get sellerHcMarketingValidationSkip => 'تخطي الصفوف الخاطئة';

  @override
  String get sellerHcMarketingValidationStop => 'التوقف عند أول صف خاطئ';

  @override
  String get sellerHcMarketingValidationStopShort => 'التوقف عند الأول';

  @override
  String get sellerHcMarketingSeparatorComma => 'فاصلة';

  @override
  String get sellerHcMarketingSeparatorSemicolon => 'فاصلة منقوطة';

  @override
  String get sellerHcMarketingSeparatorPipe => 'خط عمودي';

  @override
  String get sellerHcAftersalesResolutionReturn => 'إرجاع';

  @override
  String get sellerHcAftersalesResolutionCancelItems => 'إلغاء العناصر';

  @override
  String get sellerHcAftersalesAttachment => 'مرفق';

  @override
  String sellerHcAftersalesWeekHeader(int week, String month, String year) {
    return 'الأسبوع $week ($month $year)';
  }

  @override
  String get sellerHcCommsAttachment => 'مرفق';

  @override
  String get sellerHcShopAttachment => 'مرفق';

  @override
  String get sellerHcShopYourEmail => 'بريدك الإلكتروني';

  @override
  String get sellerHcShopSubject => 'الموضوع';

  @override
  String get sellerHcAccountUnsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get sellerHcAccountSwitchLanguageWarning =>
      'تغيير اللغة سيتجاهل التعديلات غير المحفوظة.';

  @override
  String get sellerHcAccountStay => 'البقاء';

  @override
  String get sellerHcAccountSwitch => 'تبديل';

  @override
  String get sellerHcSettingsLeaveBlankToKeep => 'اتركه فارغًا للإبقاء عليه';

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
  String get accountReturnSingular => 'مرتجع';

  @override
  String get accountReturnPlural => 'مرتجعات';

  @override
  String get accountNoReturnsYet => 'لا توجد مرتجعات بعد';

  @override
  String get accountReturnsEmptyDescription =>
      'ستظهر طلبات الإرجاع الخاصة بك هنا.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'مرتجع $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'الطلب $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'الكمية: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'الحد الأقصى: $count';
  }

  @override
  String get accountReturnResolution => 'الحل';

  @override
  String get accountReturnResolutionReturn => 'إرجاع';

  @override
  String get accountReturnResolutionCancel => 'إلغاء العناصر';

  @override
  String get accountReturnReason => 'السبب';

  @override
  String get accountReturnSelectReason => 'اختر سببًا';

  @override
  String get accountReturnPackageCondition => 'حالة العبوة';

  @override
  String get accountReturnPackageConditionHint =>
      'مثال: مفتوحة، مغلقة، صندوق تالف';

  @override
  String get accountReturnAdditionalInfo => 'معلومات إضافية';

  @override
  String get accountReturnAdditionalInfoHint => 'صف المشكلة (اختياري)';

  @override
  String get accountReturnEvidenceImages => 'صور';

  @override
  String get accountReturnAddImages => 'إضافة صور';

  @override
  String get accountReturnAgreement => 'أوافق على شروط سياسة الإرجاع';

  @override
  String get accountReturnAgreementRequired => 'يرجى قبول شروط سياسة الإرجاع';

  @override
  String get accountReturnSubmit => 'إرسال الطلب';

  @override
  String get accountReturnCreatedTitle => 'تم إرسال الطلب';

  @override
  String get accountReturnCreatedMessage =>
      'تم إرسال طلب الإرجاع الخاص بك بنجاح.';

  @override
  String get accountReturnSelectItem => 'اختر عنصرًا';

  @override
  String get accountReturnNoReturnableItems => 'لا توجد عناصر قابلة للإرجاع';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'لا يحتوي هذا الطلب على عناصر مؤهلة للإرجاع أو الإلغاء.';

  @override
  String get accountReturnViewAction => 'عرض';

  @override
  String get accountReturnCancelAction => 'إلغاء الطلب';

  @override
  String get accountReturnCloseAction => 'وضع علامة كمحلول';

  @override
  String get accountReturnReopenAction => 'إعادة فتح الطلب';

  @override
  String get accountReturnCancelConfirmation =>
      'هل أنت متأكد أنك تريد إلغاء طلب الإرجاع هذا؟';

  @override
  String get accountReturnCloseConfirmation =>
      'وضع علامة على طلب الإرجاع هذا كمحلول؟';

  @override
  String get accountReturnMessages => 'الرسائل';

  @override
  String get accountReturnNoMessages => 'لا توجد رسائل بعد.';

  @override
  String get accountReturnMessageHint => 'اكتب رسالة…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'تم تحديث حالة الإرجاع إلى $status';
  }

  @override
  String get accountReturnExpired => 'انتهت فترة الإرجاع';

  @override
  String get accountReturnInformation => 'معلومات';

  @override
  String get accountReturnSelectOrder => 'اختر طلبًا';

  @override
  String get accountReturnChangeOrder => 'تغيير';

  @override
  String get accountReturnChooseAnotherOrder => 'اختر طلبًا آخر';

  @override
  String get accountCancelOrder => 'إلغاء الطلب';

  @override
  String get accountCancelOrderConfirmation =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get accountReviewPhotosVideos => 'الصور ومقاطع الفيديو';

  @override
  String get accountReviewGallery => 'المعرض';

  @override
  String get accountReviewCamera => 'الكاميرا';

  @override
  String accountReviewMaxFiles(int count) {
    return 'يمكنك إرفاق $count ملفات كحد أقصى';
  }

  @override
  String get accountReviewFileTooLarge =>
      'يجب ألا يتجاوز حجم كل ملف 5 ميغابايت';

  @override
  String get accountReviewUnsupportedFile => 'يتم دعم الصور ومقاطع الفيديو فقط';

  @override
  String get accountReviewPickFailed =>
      'تعذرت إضافة الوسائط. يرجى المحاولة مرة أخرى';

  @override
  String get accountReviewVideoLoadFailed => 'تعذر تشغيل هذا الفيديو';

  @override
  String accountShippedCount(int count) {
    return '$count تم شحنها';
  }

  @override
  String get accountReturnNoEligibleOrders =>
      'لا توجد طلبات مؤهلة للإرجاع حاليًا';

  @override
  String get accountRequestReturn => 'طلب إرجاع';

  @override
  String get accountRefundBreakdown => 'تفاصيل الاسترداد';

  @override
  String get accountSubtotalRefunded => 'المجموع الفرعي المسترد';

  @override
  String get accountShippingRefunded => 'الشحن المسترد';

  @override
  String get accountTaxRefunded => 'الضريبة المستردة';

  @override
  String get accountDiscountRefunded => 'الخصم المسترد';

  @override
  String get accountRefunded => 'مسترد';

  @override
  String get accountCanceledQty => 'ملغى';

  @override
  String get productBookingCancellation => 'الإلغاء';

  @override
  String get productBookingCancellationNotAllowed => 'الإلغاء غير مسموح';

  @override
  String get accountBookingItemsNotCanceled =>
      'لن يتم إلغاء عناصر الحجز في هذا الطلب.';

  @override
  String cartQtyValue(int count) {
    return 'الكمية: $count';
  }

  @override
  String get checkoutAccountSuspended =>
      'تم تعليق حسابك. يمكنك تصفح المتجر لكن لا يمكنك إجراء الطلبات.';

  @override
  String get accountGenderRequiredLabel => 'الجنس *';

  @override
  String get accountGenderRequired => 'الجنس مطلوب';

  @override
  String get accountPhoneRequiredLabel => 'الهاتف *';

  @override
  String get cartGuestCheckoutNotAllowed =>
      'يرجى تسجيل الدخول لإتمام شراء هذه المنتجات.';

  @override
  String get accountEuWithdraw => 'الانسحاب من العقد';

  @override
  String get accountEuWithdrawGuestTitle => 'الانسحاب من عقدك';

  @override
  String get accountEuWithdrawReason => 'السبب (اختياري)';

  @override
  String get accountEuWithdrawSubmit => 'أرسل إليّ رابط الانسحاب';

  @override
  String get accountEuWithdrawSubmitted =>
      'إذا وُجد طلب مطابق، فقد أرسلنا للتو رابط الانسحاب إلى ذلك العنوان. سيكون صالحًا لمدة 24 ساعة.';

  @override
  String accountEuWithdrawStatus(String status) {
    return 'طلب الانسحاب: $status';
  }

  @override
  String get accountEuWithdrawGuestDescription =>
      'أدخل رقم الطلب وعنوان البريد الإلكتروني الذي استخدمته عند الدفع. سنرسل إليك رابطًا لتقديم طلب الانسحاب.';

  @override
  String get accountEuWithdrawOrderNumber => 'رقم الطلب';

  @override
  String get accountEuWithdrawEmail => 'عنوان البريد الإلكتروني';

  @override
  String get accountEuWithdrawFieldRequired => 'هذا الحقل مطلوب';

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
      'اكتب لنا ملاحظة، وسنعود إليك في أسرع وقت ممكن';

  @override
  String get accountPhoneNumber => 'رقم الهاتف';

  @override
  String get accountWhatsOnYourMind => 'بماذا تفكر؟';

  @override
  String get accountDescribeHere => 'اكتب هنا';

  @override
  String get accountSubmit => 'إرسال';

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
  String get sellerPlansHistoryTitle => 'سجل الخطط';

  @override
  String get sellerPlansPaymentMethod => 'طريقة الدفع';

  @override
  String get sellerPlansNoPaymentMethods =>
      'لا توجد طريقة دفع مُمكَّنة في هذا السوق.';

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
  String get priceStartingAt => 'يبدأ من';

  @override
  String get priceStartingFrom => 'يبدأ من';

  @override
  String get priceAsLowAs => 'بسعر يبدأ من';

  @override
  String get priceRangeTo => 'إلى';
}
