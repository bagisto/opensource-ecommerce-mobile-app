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
  String get productDetails => 'التفاصيل';

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
    return 'رقم طلبك # $orderNumber';
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
  String get accountNickName => 'الاسم المستعار';

  @override
  String get accountEnterYourName => 'أدخل اسمك';

  @override
  String get accountNameRequired => 'الاسم مطلوب';

  @override
  String get accountSummary => 'الملخص';

  @override
  String get accountReviewSummaryHint => 'ملخص قصير لتقييمك';

  @override
  String get accountSummaryRequired => 'الملخص مطلوب';

  @override
  String get accountReview => 'التقييم';

  @override
  String get accountDetailedReviewHint => 'اكتب تقييمك التفصيلي هنا';

  @override
  String get accountReviewRequired => 'التقييم مطلوب';

  @override
  String get accountRating => 'التقييم';

  @override
  String get accountSubmitReview => 'إرسال التقييم';

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
  String get accountMyReturns => 'مرتجعاتي';

  @override
  String get accountReturns => 'المرتجعات';

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
  String get accountCancelOrder => 'إلغاء الطلب';

  @override
  String get accountCancelOrderConfirmation =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.';

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
}
