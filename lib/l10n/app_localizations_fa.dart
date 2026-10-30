// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'فروشگاه Bagisto';

  @override
  String get homeFailedToLoad => 'بارگذاری صفحه اصلی ناموفق بود';

  @override
  String get commonUnknownError => 'خطای ناشناخته';

  @override
  String get commonRetry => 'تلاش مجدد';

  @override
  String get commonTimeoutError =>
      'پاسخ‌دهی سرور بیش از حد طول کشید. لطفاً اتصال خود را بررسی کرده و دوباره تلاش کنید.';

  @override
  String get commonUnableToReachServer =>
      'برقراری ارتباط با سرور امکان‌پذیر نیست. لطفاً اتصال اینترنت خود را بررسی کرده و دوباره تلاش کنید.';

  @override
  String get commonNetworkError =>
      'خطای شبکه رخ داد. لطفاً اتصال اینترنت خود را بررسی کرده و دوباره تلاش کنید.';

  @override
  String get commonProcessingError =>
      'هنگام پردازش داده‌ها مشکلی پیش آمد. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get commonMissingInformation =>
      'برخی از اطلاعات لازم موجود نیست. لطفاً همه فیلدهای الزامی را پر کرده و دوباره تلاش کنید.';

  @override
  String get commonTooManyRequests =>
      'تعداد درخواست‌ها بیش از حد مجاز است. لطفاً کمی صبر کرده و دوباره تلاش کنید.';

  @override
  String get commonServerError =>
      'سرور با خطا مواجه شد. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get commonPermissionDenied => 'شما اجازه انجام این کار را ندارید.';

  @override
  String get commonSecureConnectionError =>
      'برقراری ارتباط امن امکان‌پذیر نبود. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get commonCartSessionExpired =>
      'نشست سبد خرید شما منقضی شده است. لطفاً دوباره تلاش کنید.';

  @override
  String get commonGenericError => 'مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String commonGenericErrorWithContext(Object context) {
    return 'هنگام $context مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';
  }

  @override
  String get commonEdit => 'ویرایش';

  @override
  String get authInvalidCredentials =>
      'ایمیل یا رمز عبور واردشده نادرست است. لطفاً دوباره تلاش کنید.';

  @override
  String get authSessionExpired =>
      'نشست شما منقضی شده است. لطفاً دوباره وارد شوید.';

  @override
  String get authSessionInvalid =>
      'نشست شما دیگر معتبر نیست. لطفاً دوباره وارد شوید.';

  @override
  String get homeFeaturedProducts => 'محصولات ویژه';

  @override
  String get homeDefaultProducts => 'محصولات';

  @override
  String get homeBackToTop => 'بازگشت به بالا';

  @override
  String get homeViewCart => 'مشاهده سبد خرید';

  @override
  String homeAddedToCartMessage(Object productName) {
    return 'محصول $productName به سبد خرید اضافه شد';
  }

  @override
  String get homeLoginToManageWishlist =>
      'لطفاً برای مدیریت فهرست علاقه‌مندی‌ها وارد شوید';

  @override
  String get homeAddedToWishlist => 'به فهرست علاقه‌مندی‌ها اضافه شد';

  @override
  String get homeRemovedFromWishlist => 'از فهرست علاقه‌مندی‌ها حذف شد';

  @override
  String get homeViewAll => 'مشاهده همه';

  @override
  String get homeCollections => 'مجموعه‌ها';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'دسته‌بندی $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% تخفیف';
  }

  @override
  String get productFailedToLoad => 'بارگذاری محصول ناموفق بود';

  @override
  String get productNotFound => 'محصول یافت نشد';

  @override
  String get productDetail => 'جزئیات محصول';

  @override
  String get productDetails => 'جزئیات';

  @override
  String get productShowLess => 'نمایش کمتر';

  @override
  String get productLoadMore => 'بارگذاری بیشتر';

  @override
  String get productMoreInformations => 'اطلاعات بیشتر';

  @override
  String get productSku => 'شناسه SKU';

  @override
  String get productType => 'نوع';

  @override
  String get productBrand => 'برند';

  @override
  String get productColor => 'رنگ';

  @override
  String get productSize => 'اندازه';

  @override
  String get productReviews => 'نقد و بررسی‌ها';

  @override
  String get productNoReviewsYet => 'هنوز نقد و بررسی ثبت نشده است';

  @override
  String productRating(Object count) {
    return '$count امتیاز';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count نقد و بررسی';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'ثبت‌شده در $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'نقد و بررسی شما ثبت شد!';

  @override
  String get productWriteReview => 'ثبت نقد و بررسی';

  @override
  String get productPleaseLoginForReviews =>
      'لطفاً برای مشاهده نقد و بررسی‌های خود وارد شوید';

  @override
  String get productLoadMoreReviews => 'بارگذاری نقد و بررسی‌های بیشتر';

  @override
  String get productRelatedProduct => 'محصول مرتبط';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% تخفیف';
  }

  @override
  String get productVeryGood => 'خیلی خوب';

  @override
  String get productGood => 'خوب';

  @override
  String get productAverage => 'متوسط';

  @override
  String get productBad => 'بد';

  @override
  String get productVeryBad => 'خیلی بد';

  @override
  String get productInStock => 'موجود در انبار';

  @override
  String get productOutOfStock => 'ناموجود';

  @override
  String get productQuantity => 'تعداد';

  @override
  String get productWishlistAction => 'فهرست علاقه‌مندی‌ها';

  @override
  String get productCompareAction => 'مقایسه';

  @override
  String get productShareAction => 'اشتراک‌گذاری';

  @override
  String get productLoginToCompare => 'لطفاً برای افزودن به مقایسه وارد شوید';

  @override
  String get productAddedToCompare => 'به مقایسه اضافه شد';

  @override
  String get productAddToCart => 'افزودن به سبد خرید';

  @override
  String get accountMoveToCart => 'انتقال به سبد خرید';

  @override
  String get productBuyNow => 'خرید فوری';

  @override
  String get productSelectOptionsFirst =>
      'لطفاً ابتدا گزینه‌های محصول را انتخاب کنید';

  @override
  String get productBookingBookTable => 'رزرو میز *';

  @override
  String get productBookingSelectDateRequired => 'انتخاب تاریخ *';

  @override
  String get productBookingSelectSlotRequired => 'انتخاب بازه زمانی *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'درخواست ویژه/یادداشت‌ها *';

  @override
  String get productBookingBookAppointment => 'رزرو نوبت *';

  @override
  String get productBookingDateFormatHint => 'سال-ماه-روز';

  @override
  String get productBookingFrom => 'از';

  @override
  String get productBookingTo => 'تا';

  @override
  String get productBookingSelectDate => 'انتخاب تاریخ';

  @override
  String get productBookingLocation => 'مکان';

  @override
  String get productBookingSlotDuration => 'مدت بازه زمانی';

  @override
  String get productBookingAvailability => 'امکان رزرو';

  @override
  String get productBookingStartDate => 'تاریخ شروع';

  @override
  String get productBookingEndDate => 'تاریخ پایان';

  @override
  String get productBookingDate => 'تاریخ';

  @override
  String get productBookingViewOnMap => 'مشاهده روی نقشه';

  @override
  String get productBookingEventOn => 'رویداد در:';

  @override
  String get productBookingBookYourTicket => 'رزرو بلیت';

  @override
  String get productBookingSlotDurationLabel => 'مدت بازه زمانی:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count دقیقه';
  }

  @override
  String get productBookingAvailableFrom => 'قابل رزرو از';

  @override
  String get productBookingAvailableTo => 'قابل رزرو تا';

  @override
  String get productBookingSpecialRequestNotesHint => 'درخواست ویژه/یادداشت‌ها';

  @override
  String get productBookingChooseRentOption => 'انتخاب گزینه اجاره *';

  @override
  String get productBookingDailyBasis => 'روزانه';

  @override
  String get productBookingHourlyBasis => 'ساعتی';

  @override
  String get productBookingNoDatesAvailable =>
      'هیچ تاریخی برای رزرو موجود نیست';

  @override
  String get productBookingSelectSlot => 'انتخاب بازه زمانی';

  @override
  String get productBookingSelectDateFirst => 'ابتدا تاریخ را انتخاب کنید';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'برای مشاهده بازه‌های زمانی موجود، ابتدا یک تاریخ انتخاب کنید.';

  @override
  String get productBookingLoadingSlots => 'در حال بارگذاری بازه‌های زمانی...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'بازه‌های زمانی موجود برای تاریخ انتخاب‌شده در حال بارگذاری هستند.';

  @override
  String get productBookingUnableToLoadSlots =>
      'بارگذاری بازه‌های زمانی ناموفق بود';

  @override
  String get productBookingNoSlotsAvailable => 'هیچ بازه زمانی موجود نیست';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'برای تاریخ انتخاب‌شده هیچ بازه زمانی موجود نیست.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'برای ادامه، یکی از بازه‌های زمانی موجود را انتخاب کنید.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'یادداشت‌های درخواست ویژه';

  @override
  String get productDownloadableLinks => 'پیوندها';

  @override
  String get productDownloadableSamples => 'نمونه‌ها';

  @override
  String get productDownloadSample => 'دانلود نمونه';

  @override
  String get productDefaultName => 'محصول';

  @override
  String get categoryDefaultName => 'دسته‌بندی‌ها';

  @override
  String get categorySubCategories => 'زیردسته‌بندی‌ها';

  @override
  String get categorySomethingWentWrong => 'مشکلی پیش آمد';

  @override
  String get categoryUnknownError => 'خطای ناشناخته';

  @override
  String categoryItemsFound(Object count) {
    return '$count مورد یافت شد';
  }

  @override
  String get categoryNoProductsFound => 'هیچ محصولی یافت نشد';

  @override
  String get categorySort => 'مرتب‌سازی';

  @override
  String get categorySortByTitle => 'مرتب‌سازی بر اساس';

  @override
  String get categorySortAZ => 'از الف تا ی';

  @override
  String get categorySortZA => 'از ی تا الف';

  @override
  String get categorySortNewest => 'جدیدترین';

  @override
  String get categorySortOldest => 'قدیمی‌ترین';

  @override
  String get categorySortCheapest => 'ارزان‌ترین';

  @override
  String get categorySortExpensive => 'گران‌ترین';

  @override
  String get categoryFilter => 'فیلتر';

  @override
  String get categoryFilters => 'فیلترها';

  @override
  String get categoryNoFiltersAvailable => 'هیچ فیلتری موجود نیست';

  @override
  String get categoryFiltersWillAppear =>
      'فیلترها در صورت موجود بودن برای این دسته‌بندی نمایش داده خواهند شد';

  @override
  String get categoryApplyFilters => 'اعمال فیلترها';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'اعمال فیلترها ($count)';
  }

  @override
  String get categoryClearAll => 'پاک کردن همه';

  @override
  String get categoryTryAdjustingFilters =>
      'فیلترها یا معیارهای جستجوی خود را تغییر دهید';

  @override
  String get categoryError => 'خطا';

  @override
  String get categoryLoginToManageWishlist =>
      'لطفاً برای مدیریت فهرست علاقه‌مندی‌ها وارد شوید';

  @override
  String get categoryAddedToWishlist => 'به فهرست علاقه‌مندی‌ها اضافه شد';

  @override
  String get categoryRemovedFromWishlist => 'از فهرست علاقه‌مندی‌ها حذف شد';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'خطا در به‌روزرسانی فهرست علاقه‌مندی‌ها: $error';
  }

  @override
  String get wishlistItemRemoved => 'مورد از فهرست علاقه‌مندی‌ها حذف شد';

  @override
  String get cart => 'سبد خرید';

  @override
  String get cartPleaseLoginWishlist =>
      'لطفاً برای مشاهده فهرست علاقه‌مندی‌ها وارد شوید';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText در سبد خرید';
  }

  @override
  String get cartYourCartEmpty => 'سبد خرید شما خالی است';

  @override
  String get cartAddProductsHere =>
      'برای مشاهده محصولات در اینجا، آن‌ها را به سبد خرید اضافه کنید';

  @override
  String get cartContinueShopping => 'ادامه خرید';

  @override
  String get cartUnit => 'واحد';

  @override
  String get cartUnits => 'واحدها';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'لطفاً برای افزودن به فهرست علاقه‌مندی‌ها وارد شوید';

  @override
  String get cartMovedToWishlist => 'به فهرست علاقه‌مندی‌ها منتقل شد';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'خطا در انتقال به فهرست علاقه‌مندی‌ها: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'محصول با موفقیت به سبد خرید اضافه شد';

  @override
  String get productSelectDownloadLink => 'لطفاً حداقل یک پیوند را انتخاب کنید';

  @override
  String get cartViewMore => 'مشاهده بیشتر';

  @override
  String get cartViewLess => 'مشاهده کمتر';

  @override
  String get cartEmptyCartAction => 'خالی کردن سبد خرید';

  @override
  String get cartApplyCoupon => 'اعمال کد تخفیف';

  @override
  String get cartCouponCode => 'کد تخفیف';

  @override
  String get cartApply => 'اعمال';

  @override
  String get cartAppliedCoupon => 'کد تخفیف اعمال‌شده';

  @override
  String get cartRemove => 'حذف';

  @override
  String get cartPriceBreak => 'جزئیات قیمت';

  @override
  String get cartSubTotal => 'جمع جزء';

  @override
  String get cartDiscount => 'تخفیف';

  @override
  String get cartDeliveryCharges => 'هزینه ارسال';

  @override
  String get cartTax => 'مالیات';

  @override
  String get cartGrandTotal => 'جمع کل';

  @override
  String get cartAmountToBePaid => 'مبلغ قابل پرداخت';

  @override
  String get cartPayNow => 'پرداخت فوری';

  @override
  String get cartRemoveItem => 'حذف مورد';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'آیا از حذف «$productName» از سبد خرید خود اطمینان دارید؟';
  }

  @override
  String get cartCancel => 'لغو';

  @override
  String get cartEmptyCartTitle => 'خالی کردن سبد خرید';

  @override
  String get cartEmptyCartConfirm =>
      'آیا از حذف همه موارد از سبد خرید خود اطمینان دارید؟';

  @override
  String get checkout => 'تسویه حساب';

  @override
  String get checkoutBillingTo => 'صورت‌حساب به';

  @override
  String get checkoutDeliveredTo => 'تحویل به';

  @override
  String get checkoutChange => 'تغییر';

  @override
  String get checkoutSelectBillingAddress => 'انتخاب نشانی صورت‌حساب';

  @override
  String get checkoutSelectShippingAddress => 'انتخاب نشانی ارسال';

  @override
  String get checkoutBillingAddress => 'نشانی صورت‌حساب';

  @override
  String get checkoutEnterAddress => 'ورود نشانی';

  @override
  String get checkoutFirstName => 'نام';

  @override
  String get checkoutLastName => 'نام خانوادگی';

  @override
  String get checkoutEmail => 'ایمیل';

  @override
  String get checkoutPhone => 'تلفن';

  @override
  String get checkoutStreetAddress => 'نشانی خیابان';

  @override
  String get checkoutCountry => 'کشور';

  @override
  String get checkoutState => 'استان';

  @override
  String get checkoutCity => 'شهر';

  @override
  String get checkoutPostcode => 'کد پستی';

  @override
  String get checkoutCompanyOptional => 'شرکت (اختیاری)';

  @override
  String get checkoutUseSameAddressShipping =>
      'از همین نشانی برای ارسال استفاده شود؟';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'تلفن: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'محل کار';

  @override
  String get checkoutAddressTypeHome => 'منزل';

  @override
  String get checkoutAddressTypeBilling => 'صورت‌حساب';

  @override
  String get checkoutAddressTypeShipping => 'ارسال';

  @override
  String get checkoutAddressTypeDefault => 'پیش‌فرض';

  @override
  String checkoutFieldRequired(Object field) {
    return 'فیلد $field الزامی است';
  }

  @override
  String get checkoutSaveContinue => 'ذخیره و ادامه';

  @override
  String get checkoutYourCartEmpty => 'سبد خرید شما خالی است';

  @override
  String get checkoutSelectCountry => 'انتخاب کشور';

  @override
  String get checkoutSelectState => 'انتخاب استان';

  @override
  String get checkoutCountryRequired => 'کشور الزامی است';

  @override
  String get checkoutStateRequired => 'استان الزامی است';

  @override
  String get checkoutSelectCountryFirst => 'ابتدا کشور را انتخاب کنید';

  @override
  String get checkoutShippingMethod => 'روش ارسال';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'برای مشاهده گزینه‌های ارسال، نشانی خود را ذخیره کنید';

  @override
  String get checkoutPaymentMethod => 'روش پرداخت';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'ابتدا یک روش ارسال را انتخاب کنید';

  @override
  String get checkoutEnterCouponCode => 'کد تخفیف خود را وارد کنید';

  @override
  String get checkoutDiscountCoupon => 'تخفیف (کد تخفیف)';

  @override
  String get checkoutPlaceOrder => 'ثبت سفارش';

  @override
  String get thankYouTitle => 'از سفارش شما سپاسگزاریم!';

  @override
  String get thankYouSubtitle =>
      'جزئیات سفارش و اطلاعات پیگیری را برایتان ایمیل خواهیم کرد';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'شماره سفارش شما: #$orderNumber';
  }

  @override
  String get thankYouViewOrder => 'مشاهده سفارش';

  @override
  String get thankYouContinueShopping => 'ادامه خرید';

  @override
  String get accountPleaseTryAgainLater => 'لطفاً بعداً دوباره تلاش کنید';

  @override
  String get accountUserFallback => 'کاربر';

  @override
  String get accountBack => 'بازگشت';

  @override
  String get accountSettings => 'تنظیمات';

  @override
  String get accountMyOrders => 'سفارش‌های من';

  @override
  String get accountMyDownloadableProducts => 'محصولات دانلودی من';

  @override
  String get accountWishlist => 'فهرست علاقه‌مندی‌ها';

  @override
  String get accountCompareProducts => 'مقایسه محصولات';

  @override
  String get accountProductReview => 'نقد و بررسی محصول';

  @override
  String get accountAddressBook => 'دفترچه نشانی‌ها';

  @override
  String get accountEditAccount => 'ویرایش حساب کاربری';

  @override
  String get accountLogout => 'خروج';

  @override
  String get accountLogoutConfirmation =>
      'آیا مطمئن هستید که می‌خواهید خارج شوید؟';

  @override
  String get accountNoCountriesAvailable =>
      'هیچ کشوری در دسترس نیست. لطفاً دوباره تلاش کنید.';

  @override
  String get accountPleaseSelectCountry => 'لطفاً یک کشور را انتخاب کنید';

  @override
  String get accountPleaseSelectOrEnterState =>
      'لطفاً یک استان را انتخاب یا وارد کنید';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'نشانی با موفقیت به‌روزرسانی شد';

  @override
  String get accountAddressAddedSuccessfully => 'نشانی با موفقیت اضافه شد';

  @override
  String get accountGoBack => 'بازگشت';

  @override
  String get accountEditAddress => 'ویرایش نشانی';

  @override
  String get accountAddNewAddress => 'افزودن نشانی جدید';

  @override
  String get accountFirstNameRequired => 'نام الزامی است';

  @override
  String get accountLastNameRequired => 'نام خانوادگی الزامی است';

  @override
  String get accountEnterValidEmail => 'یک ایمیل معتبر وارد کنید';

  @override
  String get accountCompanyName => 'نام شرکت';

  @override
  String get accountVatId => 'شناسه VAT';

  @override
  String get accountStreetAddressRequired => 'نشانی خیابان الزامی است';

  @override
  String get accountCityRequired => 'شهر الزامی است';

  @override
  String get accountZipPostcode => 'کد پستی';

  @override
  String get accountZipPostcodeRequired => 'کد پستی الزامی است';

  @override
  String get accountTelephone => 'تلفن';

  @override
  String get accountPhoneNumberRequired => 'شماره تلفن الزامی است';

  @override
  String get accountChangeDefaultBillingAddress =>
      'تغییر نشانی پیش‌فرض صورت‌حساب';

  @override
  String get accountChangeDefaultShippingAddress => 'تغییر نشانی پیش‌فرض ارسال';

  @override
  String get accountUpdateAddress => 'به‌روزرسانی نشانی';

  @override
  String get accountSaveToAddressBook => 'ذخیره در دفترچه نشانی‌ها';

  @override
  String get accountPleaseLoginToWriteReview =>
      'لطفاً برای ثبت نقد و بررسی وارد شوید';

  @override
  String get accountPleaseSelectRating => 'لطفاً یک امتیاز انتخاب کنید';

  @override
  String get accountAddReview => 'افزودن نقد و بررسی';

  @override
  String get accountReviewSubmitted => 'نقد و بررسی ثبت شد!';

  @override
  String get accountNickName => 'نام مستعار';

  @override
  String get accountEnterYourName => 'نام خود را وارد کنید';

  @override
  String get accountNameRequired => 'نام الزامی است';

  @override
  String get accountSummary => 'خلاصه';

  @override
  String get accountReviewSummaryHint => 'خلاصه کوتاهی از نقد و بررسی شما';

  @override
  String get accountSummaryRequired => 'خلاصه الزامی است';

  @override
  String get accountReview => 'نقد و بررسی';

  @override
  String get accountDetailedReviewHint =>
      'نقد و بررسی دقیق خود را اینجا بنویسید';

  @override
  String get accountReviewRequired => 'نقد و بررسی الزامی است';

  @override
  String get accountRating => 'امتیاز';

  @override
  String get accountSubmitReview => 'ثبت نقد و بررسی';

  @override
  String get accountCouldNotLoadAddresses => 'بارگیری نشانی‌ها ناموفق بود';

  @override
  String get accountPleaseTryAgain => 'لطفاً دوباره تلاش کنید';

  @override
  String get accountNoAddressesSaved => 'هیچ نشانی‌ای ذخیره نشده است';

  @override
  String get accountAddAddressToGetStarted =>
      'برای شروع، یک نشانی جدید اضافه کنید';

  @override
  String get accountSelectAddress => 'انتخاب نشانی';

  @override
  String get accountSetAsDefault => 'تنظیم به‌عنوان پیش‌فرض';

  @override
  String get accountAddressTypeHome => 'خانه';

  @override
  String get accountAddressTypeOffice => 'محل کار';

  @override
  String get accountAddressTypeCustomer => 'مشتری';

  @override
  String get accountNoProductsToCompare => 'هیچ محصولی برای مقایسه وجود ندارد';

  @override
  String get accountAddProductsToCompareHint =>
      'از صفحه جزئیات محصول، محصولاتی را برای مقایسه اضافه کنید.';

  @override
  String get accountProducts => 'محصولات';

  @override
  String get accountDescription => 'توضیحات';

  @override
  String get accountShortDescription => 'توضیحات کوتاه';

  @override
  String get accountActivity => 'فعالیت';

  @override
  String get accountSeller => 'فروشنده';

  @override
  String get accountNotAvailable => 'نامشخص';

  @override
  String get accountMessageSentSuccessfully => 'پیام با موفقیت ارسال شد!';

  @override
  String get accountAnErrorOccurred => 'خطایی رخ داد';

  @override
  String get accountContactUs => 'تماس با ما';

  @override
  String get accountName => 'نام';

  @override
  String get accountEnterYourEmail => 'ایمیل خود را وارد کنید';

  @override
  String get accountContact => 'شماره تماس';

  @override
  String get accountEnterYourPhoneNumber => 'شماره تلفن خود را وارد کنید';

  @override
  String get accountMessage => 'پیام';

  @override
  String get accountEnterYourMessage => 'پیام خود را وارد کنید';

  @override
  String get accountSendMessage => 'ارسال پیام';

  @override
  String get accountNameFieldEmpty => 'فیلد نام نمی‌تواند خالی باشد';

  @override
  String get accountNameMinChars => 'نام باید حداقل ۲ کاراکتر باشد';

  @override
  String get accountEmailFieldEmpty => 'فیلد ایمیل نمی‌تواند خالی باشد';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'لطفاً یک نشانی ایمیل معتبر وارد کنید';

  @override
  String get accountContactNumberEmpty => 'شماره تماس نمی‌تواند خالی باشد';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'لطفاً یک شماره تماس معتبر وارد کنید';

  @override
  String get accountMessageFieldEmpty => 'فیلد پیام نمی‌تواند خالی باشد';

  @override
  String get accountMessageMinChars => 'پیام باید حداقل ۱۰ کاراکتر باشد';

  @override
  String get accountDownloadableProducts => 'محصولات دانلودی';

  @override
  String get accountNoDownloadsYet => 'هنوز دانلودی وجود ندارد';

  @override
  String get accountDownloadsEmptyDescription =>
      'محصولات دانلودشده شما اینجا نمایش داده می‌شوند.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total محصول';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return '$value باقی‌مانده';
  }

  @override
  String get accountDownload => 'دانلود';

  @override
  String accountFileName(Object fileName) {
    return 'فایل: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'دانلود شما به‌زودی آغاز می‌شود. پوشه دانلودهای خود را بررسی کنید.';

  @override
  String get accountClose => 'بستن';

  @override
  String get accountOrders => 'سفارش‌ها';

  @override
  String get accountNoOrdersYet => 'هنوز سفارشی وجود ندارد';

  @override
  String get accountOrdersEmptyDescription =>
      'پس از انجام خرید، سفارش‌های شما اینجا نمایش داده می‌شوند.';

  @override
  String get accountOrderSingular => 'سفارش';

  @override
  String get accountOrderPlural => 'سفارش‌ها';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total ($count کالا)';
  }

  @override
  String get accountOrderAndReturn => 'سفارش و مرجوعی';

  @override
  String get accountTrackOrder => 'پیگیری سفارش';

  @override
  String get accountReturnPolicy => 'قوانین مرجوعی';

  @override
  String get accountReturnRequest => 'درخواست مرجوعی';

  @override
  String get accountMyReturns => 'مرجوعی‌های من';

  @override
  String get accountReturns => 'مرجوعی‌ها';

  @override
  String get accountReturnSingular => 'مرجوعی';

  @override
  String get accountReturnPlural => 'مرجوعی‌ها';

  @override
  String get accountNoReturnsYet => 'هنوز مرجوعی‌ای وجود ندارد';

  @override
  String get accountReturnsEmptyDescription =>
      'درخواست‌های مرجوعی شما اینجا نمایش داده می‌شوند.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'مرجوعی $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'سفارش $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'تعداد: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'حداکثر: $count';
  }

  @override
  String get accountReturnResolution => 'روش رسیدگی';

  @override
  String get accountReturnResolutionReturn => 'مرجوع کردن';

  @override
  String get accountReturnResolutionCancel => 'لغو اقلام';

  @override
  String get accountReturnReason => 'دلیل';

  @override
  String get accountReturnSelectReason => 'یک دلیل انتخاب کنید';

  @override
  String get accountReturnPackageCondition => 'وضعیت بسته‌بندی';

  @override
  String get accountReturnPackageConditionHint =>
      'برای مثال: بازشده، پلمب، جعبه آسیب‌دیده';

  @override
  String get accountReturnAdditionalInfo => 'اطلاعات تکمیلی';

  @override
  String get accountReturnAdditionalInfoHint => 'شرح مشکل (اختیاری)';

  @override
  String get accountReturnAgreement => 'با شرایط قوانین مرجوعی موافقم';

  @override
  String get accountReturnAgreementRequired =>
      'لطفاً شرایط قوانین مرجوعی را بپذیرید';

  @override
  String get accountReturnSubmit => 'ثبت درخواست';

  @override
  String get accountReturnCreatedTitle => 'درخواست ثبت شد';

  @override
  String get accountReturnCreatedMessage =>
      'درخواست مرجوعی شما با موفقیت ثبت شد.';

  @override
  String get accountReturnSelectItem => 'انتخاب کالا';

  @override
  String get accountReturnNoReturnableItems => 'کالای قابل مرجوعی وجود ندارد';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'این سفارش هیچ کالایی برای مرجوعی یا لغو ندارد.';

  @override
  String get accountReturnViewAction => 'مشاهده';

  @override
  String get accountReturnCancelAction => 'لغو درخواست';

  @override
  String get accountReturnCloseAction => 'علامت‌گذاری به‌عنوان حل‌شده';

  @override
  String get accountReturnReopenAction => 'بازگشایی مجدد درخواست';

  @override
  String get accountReturnCancelConfirmation =>
      'آیا مطمئن هستید که می‌خواهید این درخواست مرجوعی را لغو کنید؟';

  @override
  String get accountReturnCloseConfirmation =>
      'این درخواست مرجوعی به‌عنوان حل‌شده علامت‌گذاری شود؟';

  @override
  String get accountReturnMessages => 'پیام‌ها';

  @override
  String get accountReturnNoMessages => 'هنوز پیامی وجود ندارد.';

  @override
  String get accountReturnMessageHint => 'پیامی بنویسید…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'وضعیت مرجوعی به $status به‌روزرسانی شد';
  }

  @override
  String get accountReturnExpired => 'مهلت مرجوعی به پایان رسیده است';

  @override
  String get accountReturnInformation => 'اطلاعات';

  @override
  String get accountReturnSelectOrder => 'یک سفارش را انتخاب کنید';

  @override
  String get accountReturnChangeOrder => 'تغییر';

  @override
  String get accountReturnChooseAnotherOrder => 'انتخاب سفارشی دیگر';

  @override
  String get accountNotifications => 'اعلان‌ها';

  @override
  String get accountPrivacy => 'حریم خصوصی';

  @override
  String get accountAccount => 'حساب کاربری';

  @override
  String get accountPreferences => 'ترجیحات';

  @override
  String get accountLanguage => 'زبان';

  @override
  String get accountNoLanguagesAvailable => 'هیچ زبانی در دسترس نیست';

  @override
  String get accountCurrency => 'واحد پول';

  @override
  String get accountOthers => 'سایر موارد';

  @override
  String get accountNoPagesAvailable => 'هیچ صفحه‌ای در دسترس نیست';

  @override
  String get accountProductReviews => 'نقد و بررسی‌های محصول';

  @override
  String get accountMyReviews => 'نقد و بررسی‌های من';

  @override
  String get accountNoReviewsYet => 'هنوز نقد و بررسی‌ای وجود ندارد';

  @override
  String get accountReviewsEmptyDescription =>
      'نقد و بررسی‌های محصول شما اینجا نمایش داده می‌شوند.';

  @override
  String get accountReviewSingular => 'نقد و بررسی';

  @override
  String get accountReviewPlural => 'نقد و بررسی‌ها';

  @override
  String accountPostedOn(Object date) {
    return 'ثبت‌شده در $date';
  }

  @override
  String get accountCloseSettings => 'بستن تنظیمات';

  @override
  String get accountChangeTheme => 'تغییر پوسته';

  @override
  String get accountAllNotifications => 'همه اعلان‌ها';

  @override
  String get accountOffers => 'پیشنهادها';

  @override
  String get accountOfflineData => 'داده‌های آفلاین';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'پیگیری و نمایش محصولات اخیراً مشاهده‌شده';

  @override
  String get accountShowSearchTag => 'نمایش برچسب جستجو';

  @override
  String get accountTryAgain => 'تلاش دوباره';

  @override
  String get accountYourWishlistEmpty => 'فهرست علاقه‌مندی‌های شما خالی است';

  @override
  String get accountWishlistEmptyDescription =>
      'محصولات را مرور کنید و آن‌ها را به فهرست علاقه‌مندی‌های خود اضافه کنید';

  @override
  String get accountItemSingular => 'کالا';

  @override
  String get accountItemPlural => 'کالاها';

  @override
  String accountStartingAt(Object price) {
    return 'شروع قیمت از $price';
  }

  @override
  String get accountAboutThisPage => 'درباره این صفحه';

  @override
  String accountPageId(Object id) {
    return 'شناسه صفحه: $id';
  }

  @override
  String get mainTabHome => 'خانه';

  @override
  String get mainTabCategories => 'دسته‌بندی‌ها';

  @override
  String get mainTabCart => 'سبد خرید';

  @override
  String get mainTabAccount => 'حساب کاربری';

  @override
  String get authLoginSuccess => 'خوش آمدید! ورود با موفقیت انجام شد.';

  @override
  String get authWelcomeBack => 'خوش برگشتید!';

  @override
  String get authLoginToAccount => 'ورود به حساب کاربری';

  @override
  String get authEmailAddress => 'نشانی ایمیل';

  @override
  String get authEnterYourEmail => 'ایمیل خود را وارد کنید';

  @override
  String get authPleaseEnterEmail => 'لطفاً ایمیل خود را وارد کنید';

  @override
  String get authPleaseEnterValidEmail => 'لطفاً یک ایمیل معتبر وارد کنید';

  @override
  String get authPassword => 'رمز عبور';

  @override
  String get authEnterYourPassword => 'رمز عبور خود را وارد کنید';

  @override
  String get authPleaseEnterPassword => 'لطفاً رمز عبور خود را وارد کنید';

  @override
  String get authPasswordMinLength => 'رمز عبور باید حداقل ۶ کاراکتر باشد';

  @override
  String get authForgotPasswordTitle => 'رمز عبور را فراموش کرده‌اید؟';

  @override
  String get authLogin => 'ورود';

  @override
  String get authNoAccountPrompt => 'حساب کاربری ندارید؟ ';

  @override
  String get authSignUp => 'ثبت‌نام';

  @override
  String get authAccountCreatedSuccess => 'حساب کاربری با موفقیت ایجاد شد!';

  @override
  String get authCreateAccount => 'ایجاد حساب کاربری';

  @override
  String get authSignupGetStarted => 'برای شروع ثبت‌نام کنید';

  @override
  String get authFirstNameHint => 'نام';

  @override
  String get authLastNameHint => 'نام خانوادگی';

  @override
  String get authRequired => 'الزامی';

  @override
  String get authCreatePasswordHint => 'یک رمز عبور ایجاد کنید';

  @override
  String get authConfirmPassword => 'تأیید رمز عبور';

  @override
  String get authConfirmPasswordHint => 'رمز عبور خود را تأیید کنید';

  @override
  String get authPleaseConfirmPassword => 'لطفاً رمز عبور خود را تأیید کنید';

  @override
  String get authPasswordsDoNotMatch => 'رمزهای عبور مطابقت ندارند';

  @override
  String get authAlreadyHaveAccountPrompt => 'از قبل حساب کاربری دارید؟ ';

  @override
  String get authForgotPasswordSubtitle =>
      'نشانی ایمیل خود را وارد کنید تا پیوند بازنشانی رمز عبور برایتان ارسال شود.';

  @override
  String get authSendResetLink => 'ارسال پیوند بازنشانی';

  @override
  String get authBackToLogin => 'بازگشت به ورود';

  @override
  String get authNiceToSeeYouHere => 'از دیدن شما در اینجا خوشحالیم';

  @override
  String get accountEditTitle => 'ویرایش حساب کاربری';

  @override
  String get accountFirstNameRequiredLabel => 'نام *';

  @override
  String get accountLastNameRequiredLabel => 'نام خانوادگی *';

  @override
  String get accountChangeEmail => 'تغییر ایمیل';

  @override
  String get accountChangePassword => 'تغییر رمز عبور';

  @override
  String get accountDeleteAccount => 'حذف حساب کاربری';

  @override
  String get accountGender => 'جنسیت';

  @override
  String get accountSelectGender => 'انتخاب جنسیت';

  @override
  String get accountDob => 'تاریخ تولد';

  @override
  String get monthJanShort => 'ژانویه';

  @override
  String get monthFebShort => 'فوریه';

  @override
  String get monthMarShort => 'مارس';

  @override
  String get monthAprShort => 'آوریل';

  @override
  String get monthMayShort => 'مه';

  @override
  String get monthJunShort => 'ژوئن';

  @override
  String get monthJulShort => 'ژوئیه';

  @override
  String get monthAugShort => 'اوت';

  @override
  String get monthSepShort => 'سپتامبر';

  @override
  String get monthOctShort => 'اکتبر';

  @override
  String get monthNovShort => 'نوامبر';

  @override
  String get monthDecShort => 'دسامبر';

  @override
  String get accountSubscribeNewsletters => 'اشتراک در خبرنامه‌ها';

  @override
  String get accountSaveProfile => 'ذخیره نمایه';

  @override
  String get accountNewEmail => 'ایمیل جدید';

  @override
  String get accountEmailRequired => 'ایمیل الزامی است';

  @override
  String get accountCurrentPassword => 'رمز عبور فعلی';

  @override
  String get accountPasswordRequired => 'رمز عبور الزامی است';

  @override
  String get accountChange => 'تغییر';

  @override
  String get accountCurrentPasswordRequired => 'رمز عبور فعلی الزامی است';

  @override
  String get accountNewPassword => 'رمز عبور جدید';

  @override
  String get accountConfirmPassword => 'تأیید رمز عبور';

  @override
  String get accountDeleteWarning =>
      'این اقدام برگشت‌ناپذیر است و قابل بازگشت نیست. تمام داده‌های شما حذف خواهد شد.';

  @override
  String get accountEnterYourPassword => 'رمز عبور خود را وارد کنید';

  @override
  String get accountDelete => 'حذف';

  @override
  String get accountDeleteAddress => 'حذف نشانی';

  @override
  String get accountDeleteAddressConfirm => 'آیا از حذف این نشانی مطمئن هستید؟';

  @override
  String get accountGenderMale => 'مرد';

  @override
  String get accountGenderFemale => 'زن';

  @override
  String get accountGenderOther => 'سایر';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'سفارش‌های $number';
  }

  @override
  String get accountReorderSuccessful => 'سفارش مجدد با موفقیت انجام شد';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\n$count کالا به سبد خرید شما اضافه شد.';
  }

  @override
  String get accountOk => 'تأیید';

  @override
  String get accountGoToCart => 'رفتن به سبد خرید';

  @override
  String get accountFailedToLoadOrderDetails =>
      'بارگیری جزئیات سفارش ناموفق بود';

  @override
  String get accountDetails => 'جزئیات';

  @override
  String get accountInvoices => 'فاکتورها';

  @override
  String get accountShipments => 'ارسال‌ها';

  @override
  String accountPlacedOn(Object date) {
    return 'ثبت‌شده در $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count قلم کالای سفارش‌داده‌شده';
  }

  @override
  String get accountBillingAddress => 'نشانی صورت‌حساب';

  @override
  String get accountShippingAddress => 'نشانی ارسال';

  @override
  String get accountShippingMethod => 'روش ارسال';

  @override
  String get accountPaymentMethod => 'روش پرداخت';

  @override
  String get accountNoInvoicesForOrder =>
      'هیچ فاکتوری برای این سفارش وجود ندارد';

  @override
  String accountInvoicedCount(int count) {
    return '$count فاکتورشده';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'هیچ ارسالی برای این سفارش وجود ندارد';

  @override
  String get accountReorder => 'سفارش مجدد';

  @override
  String get accountCancelOrder => 'لغو سفارش';

  @override
  String get accountCancelOrderConfirmation =>
      'آیا از لغو این سفارش مطمئن هستید؟ این اقدام برگشت‌ناپذیر است.';

  @override
  String get accountMoreInfo => 'اطلاعات بیشتر';

  @override
  String get accountOrderedQty => 'تعداد سفارش‌داده‌شده';

  @override
  String get accountShipped => 'ارسال‌شده';

  @override
  String get accountInvoiced => 'فاکتورشده';

  @override
  String get accountUnitPrice => 'قیمت واحد';

  @override
  String get accountSubTotalWithSpace => 'جمع جزء';

  @override
  String get accountTotalPaid => 'کل پرداختی';

  @override
  String get accountTotalRefunded => 'مجموع بازپرداخت';

  @override
  String get accountTotalDue => 'مبلغ قابل پرداخت';

  @override
  String accountInvoiceNumber(Object number) {
    return 'فاکتور $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'ارسال $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'بارگیری جزئیات فاکتور ناموفق بود';

  @override
  String get accountInvoiceStatus => 'وضعیت فاکتور';

  @override
  String get accountInvoiceDate => 'تاریخ فاکتور';

  @override
  String get accountOrderId => 'شناسه سفارش';

  @override
  String get accountOrderDate => 'تاریخ سفارش';

  @override
  String get accountOrderStatus => 'وضعیت سفارش';

  @override
  String get accountChannel => 'کانال';

  @override
  String get accountDefault => 'پیش‌فرض';

  @override
  String get accountStatusPaid => 'پرداخت‌شده';

  @override
  String get accountStatusPending => 'در انتظار';

  @override
  String get accountStatusPendingPayment => 'در انتظار پرداخت';

  @override
  String get accountStatusOverdue => 'سررسید گذشته';

  @override
  String get accountStatusRefunded => 'بازپرداخت‌شده';

  @override
  String get accountShippedQty => 'تعداد ارسال‌شده';

  @override
  String get accountInvoicedQty => 'تعداد فاکتورشده';

  @override
  String get accountUnitPriceWithColon => 'قیمت واحد:';

  @override
  String get accountSubTotalWithColon => 'جمع جزء:';

  @override
  String get accountDownloadInvoice => 'دانلود فاکتور';

  @override
  String get accountInvoice => 'فاکتور';

  @override
  String get accountRecentOrders => 'سفارش‌های اخیر';

  @override
  String get accountNoRecentOrders => 'هیچ سفارش اخیری وجود ندارد';

  @override
  String get accountStatusProcessing => 'در حال پردازش';

  @override
  String get accountStatusCompleted => 'تکمیل‌شده';

  @override
  String get accountStatusCancelled => 'لغوشده';

  @override
  String get accountStatusClosed => 'بسته‌شده';

  @override
  String get accountStatusUnknown => 'نامشخص';

  @override
  String accountWishlistItemsCount(int count) {
    return 'کالاهای فهرست علاقه‌مندی‌ها ($count)';
  }

  @override
  String get accountNoWishlistItems =>
      'هیچ کالایی در فهرست علاقه‌مندی‌ها وجود ندارد';

  @override
  String get accountDefaultAddresses => 'نشانی‌های پیش‌فرض';

  @override
  String get accountNoProductReviewsYet =>
      'هنوز هیچ نقد و بررسی‌ای برای محصولات ثبت نشده است';

  @override
  String get searchFailedTitle => 'جستجو ناموفق بود';

  @override
  String get searchHint => 'جستجوی محصولات';

  @override
  String get searchImageSearch => 'جستجوی تصویری';

  @override
  String get searchRecentSearches => 'جستجوهای اخیر';

  @override
  String get searchClearAll => 'پاک کردن همه';

  @override
  String get searchTopCategories => 'دسته‌بندی‌های برتر';

  @override
  String searchResultsFound(int count) {
    return '$count نتیجه یافت شد';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% تخفیف';
  }

  @override
  String get searchNoProductsFound => 'هیچ محصولی یافت نشد';

  @override
  String get searchTryDifferentTerm => 'جستجو با عبارت دیگری را امتحان کنید';

  @override
  String get searchSpeechNotAvailable => 'تشخیص گفتار در دسترس نیست';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'شروع ورودی صوتی ناموفق بود: $error';
  }

  @override
  String get searchMicrophonePermissionDenied => 'مجوز میکروفون رد شد';

  @override
  String get searchRetake => 'عکس‌برداری مجدد';

  @override
  String get searchSearch => 'جستجو';

  @override
  String get searchTryAgain => 'تلاش مجدد';

  @override
  String get searchRecognizedObjects => 'اشیاء شناسایی‌شده';

  @override
  String get searchResult => 'نتیجه:';

  @override
  String get searchFailedToCaptureImage => 'ثبت تصویر ناموفق بود';

  @override
  String searchProcessing(int progress) {
    return 'در حال پردازش... $progress%';
  }

  @override
  String get searchOpeningCamera => 'در حال باز کردن دوربین...';

  @override
  String get searchFailedToProcessImage => 'پردازش تصویر ناموفق بود';

  @override
  String get homeRecentlyViewedProducts => 'محصولات اخیراً مشاهده‌شده';

  @override
  String accountItemsCount(int count) {
    return '$count قلم کالا';
  }

  @override
  String get accountTrack => 'پیگیری';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'پیگیری $trackNumber از طریق $carrier';
  }

  @override
  String get accountUnknownCarrier => 'شرکت حمل‌ونقل نامشخص';

  @override
  String get accountTrackingNumber => 'شماره پیگیری';

  @override
  String accountSkuValue(Object sku) {
    return 'کد SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'تعداد ارسال‌شده : $qty';
  }

  @override
  String get accountReviewPhotosVideos => 'عکس‌ها و ویدیوها';

  @override
  String get accountReviewAddMedia => 'افزودن';

  @override
  String get accountReviewGallery => 'گالری';

  @override
  String get accountReviewCamera => 'دوربین';

  @override
  String accountReviewMaxFiles(int count) {
    return 'می‌توانید حداکثر $count فایل پیوست کنید';
  }

  @override
  String get accountReviewFileTooLarge => 'هر فایل باید 5 MB یا کمتر باشد';

  @override
  String get accountReviewUnsupportedFile =>
      'فقط تصاویر و ویدیوها پشتیبانی می‌شوند';

  @override
  String get accountReviewPickFailed =>
      'افزودن رسانه ناموفق بود. لطفاً دوباره تلاش کنید';

  @override
  String get accountReviewVideoLoadFailed => 'پخش این ویدیو امکان‌پذیر نیست';

  @override
  String accountShippedCount(int count) {
    return '$count ارسال‌شده';
  }

  @override
  String get accountReturnNoEligibleOrders =>
      'در حال حاضر هیچ سفارشی واجد شرایط مرجوعی نیست';

  @override
  String get accountRequestReturn => 'درخواست مرجوعی';

  @override
  String get accountRefunded => 'بازپرداخت‌شده';

  @override
  String get accountCanceledQty => 'لغوشده';

  @override
  String get productBookingCancellation => 'لغو';

  @override
  String get productBookingCancellationNotAllowed => 'لغو مجاز نیست';

  @override
  String get accountBookingItemsNotCanceled =>
      'اقلام رزروی این سفارش لغو نخواهند شد.';

  @override
  String cartQtyValue(int count) {
    return 'تعداد: $count';
  }

  @override
  String get checkoutAccountSuspended =>
      'حساب کاربری شما تعلیق شده است. می‌توانید فروشگاه را مرور کنید، اما امکان ثبت سفارش را ندارید.';

  @override
  String get accountGenderRequiredLabel => 'جنسیت *';

  @override
  String get accountGenderRequired => 'جنسیت الزامی است';

  @override
  String get accountPhoneRequiredLabel => 'تلفن *';

  @override
  String get cartGuestCheckoutNotAllowed =>
      'لطفاً برای تسویه حساب این اقلام وارد شوید.';

  @override
  String get accountEuWithdraw => 'انصراف از قرارداد';

  @override
  String get accountEuWithdrawReason => 'دلیل (اختیاری)';

  @override
  String get accountEuWithdrawSubmit => 'ثبت انصراف';

  @override
  String get accountEuWithdrawSubmitted => 'درخواست انصراف شما دریافت شد.';

  @override
  String accountEuWithdrawStatus(String status) {
    return 'درخواست انصراف: $status';
  }

  @override
  String get accountEuWithdrawGuestDescription =>
      'برای انصراف از قرارداد، شماره سفارش و نشانی ایمیل استفاده‌شده برای سفارش را وارد کنید.';

  @override
  String get accountEuWithdrawOrderNumber => 'شماره سفارش *';

  @override
  String get accountEuWithdrawEmail => 'ایمیل سفارش *';

  @override
  String get accountEuWithdrawFieldRequired => 'تکمیل این فیلد الزامی است';

  @override
  String get accountRefunds => 'بازپرداخت‌ها';

  @override
  String get accountShippingAndHandling => 'ارسال و بسته‌بندی';

  @override
  String get accountContactUsDescription =>
      'پیام خود را برای ما بنویسید، در سریع‌ترین زمان ممکن با شما تماس خواهیم گرفت';

  @override
  String get accountPhoneNumber => 'شماره تلفن';

  @override
  String get accountWhatsOnYourMind => 'چه چیزی در ذهن دارید؟';

  @override
  String get accountDescribeHere => 'اینجا شرح دهید';

  @override
  String get accountSubmit => 'ارسال';

  @override
  String cartMinimumOrderAmount(String amount) {
    return 'حداقل مبلغ سفارش $amount است';
  }

  @override
  String get accountPrice => 'قیمت';

  @override
  String get accountQty => 'تعداد';
}
