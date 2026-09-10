// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Магазин Bagisto';

  @override
  String get homeFailedToLoad => 'Не вдалося завантажити головну сторінку';

  @override
  String get commonUnknownError => 'Невідома помилка';

  @override
  String get commonRetry => 'Спробувати знову';

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
  String get homeFeaturedProducts => 'Рекомендовані товари';

  @override
  String get homeDefaultProducts => 'Товари';

  @override
  String get homeBackToTop => 'Повернутися вгору';

  @override
  String get homeViewCart => 'ПЕРЕГЛЯНУТИ КОШИК';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName додано до кошика';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Увійдіть, щоб керувати списком бажань';

  @override
  String get homeAddedToWishlist => 'Додано до списку бажань';

  @override
  String get homeRemovedFromWishlist => 'Видалено зі списку бажань';

  @override
  String get homeViewAll => 'Переглянути все';

  @override
  String get homeCollections => 'Колекції';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Категорія $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return 'Знижка $percent%';
  }

  @override
  String get productFailedToLoad => 'Не вдалося завантажити товар';

  @override
  String get productNotFound => 'Товар не знайдено';

  @override
  String get productDetail => 'Деталі товару';

  @override
  String get productDetails => 'Деталі';

  @override
  String get productShowLess => 'Показати менше';

  @override
  String get productLoadMore => 'Завантажити ще';

  @override
  String get productMoreInformations => 'Додаткова інформація';

  @override
  String get productSku => 'Артикул';

  @override
  String get productType => 'Тип';

  @override
  String get productBrand => 'Бренд';

  @override
  String get productColor => 'Колір';

  @override
  String get productSize => 'Розмір';

  @override
  String get productReviews => 'Відгуки';

  @override
  String get productNoReviewsYet => 'Поки немає відгуків';

  @override
  String productRating(Object count) {
    return '$count оцінка';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count відгуків';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Опубліковано $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Ваш відгук надіслано!';

  @override
  String get productWriteReview => 'Написати відгук';

  @override
  String get productPleaseLoginForReviews =>
      'Увійдіть, щоб переглянути свої відгуки';

  @override
  String get productLoadMoreReviews => 'Завантажити більше відгуків';

  @override
  String get productRelatedProduct => 'Схожий товар';

  @override
  String productDiscountOff(Object percent) {
    return 'Знижка $percent%';
  }

  @override
  String get productVeryGood => 'Дуже добре';

  @override
  String get productGood => 'Добре';

  @override
  String get productAverage => 'Середньо';

  @override
  String get productBad => 'Погано';

  @override
  String get productVeryBad => 'Дуже погано';

  @override
  String get productInStock => 'Є в наявності';

  @override
  String get productOutOfStock => 'Немає в наявності';

  @override
  String get productQuantity => 'Кількість';

  @override
  String get productWishlistAction => 'Список бажань';

  @override
  String get productCompareAction => 'Порівняти';

  @override
  String get productShareAction => 'Поділитися';

  @override
  String get productLoginToCompare => 'Увійдіть, щоб додати до порівняння';

  @override
  String get productAddedToCompare => 'Додано до порівняння';

  @override
  String get productAddToCart => 'Додати до кошика';

  @override
  String get accountMoveToCart => 'Перемістити до кошика';

  @override
  String get productBuyNow => 'Купити зараз';

  @override
  String get productSelectOptionsFirst => 'Спочатку виберіть параметри товару';

  @override
  String get productBookingBookTable => 'Забронювати столик *';

  @override
  String get productBookingSelectDateRequired => 'Виберіть дату *';

  @override
  String get productBookingSelectSlotRequired => 'Виберіть слот *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Особливі побажання/Нотатки *';

  @override
  String get productBookingBookAppointment => 'Записатися на зустріч *';

  @override
  String get productBookingDateFormatHint => 'РРРР-ММ-ДД';

  @override
  String get productBookingFrom => 'Від';

  @override
  String get productBookingTo => 'До';

  @override
  String get productBookingSelectDate => 'Виберіть дату';

  @override
  String get productBookingLocation => 'Місцезнаходження';

  @override
  String get productBookingSlotDuration => 'Тривалість слота';

  @override
  String get productBookingAvailability => 'Доступність';

  @override
  String get productBookingStartDate => 'Дата початку';

  @override
  String get productBookingEndDate => 'Дата завершення';

  @override
  String get productBookingDate => 'Дата';

  @override
  String get productBookingViewOnMap => 'Показати на карті';

  @override
  String get productBookingEventOn => 'Подія:';

  @override
  String get productBookingBookYourTicket => 'Забронюйте свій квиток';

  @override
  String get productBookingSlotDurationLabel => 'Тривалість слота:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count хвилин';
  }

  @override
  String get productBookingAvailableFrom => 'Доступно з';

  @override
  String get productBookingAvailableTo => 'Доступно до';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Особливі побажання/Нотатки';

  @override
  String get productBookingChooseRentOption => 'Виберіть варіант оренди *';

  @override
  String get productBookingDailyBasis => 'Подобово';

  @override
  String get productBookingHourlyBasis => 'Погодинно';

  @override
  String get productBookingNoDatesAvailable =>
      'Немає доступних дат для бронювання';

  @override
  String get productBookingSelectSlot => 'Виберіть слот';

  @override
  String get productBookingSelectDateFirst => 'Спочатку виберіть дату';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Спочатку виберіть дату, щоб побачити доступні слоти.';

  @override
  String get productBookingLoadingSlots => 'Завантаження слотів...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Завантажуються доступні слоти для вибраної дати.';

  @override
  String get productBookingUnableToLoadSlots => 'Не вдалося завантажити слоти';

  @override
  String get productBookingNoSlotsAvailable => 'Немає доступних слотів';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Для вибраної дати немає доступних слотів.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Виберіть один доступний слот, щоб продовжити.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Особливі побажання/Нотатки';

  @override
  String get productDownloadableLinks => 'Посилання';

  @override
  String get productDownloadableSamples => 'Зразки';

  @override
  String get productDownloadSample => 'Завантажити зразок';

  @override
  String get productDefaultName => 'Товар';

  @override
  String get categoryDefaultName => 'Категорії';

  @override
  String get categorySubCategories => 'Підкатегорії';

  @override
  String get categorySomethingWentWrong => 'Щось пішло не так';

  @override
  String get categoryUnknownError => 'Невідома помилка';

  @override
  String categoryItemsFound(Object count) {
    return 'Знайдено товарів: $count';
  }

  @override
  String get categoryNoProductsFound => 'Товарів не знайдено';

  @override
  String get categorySort => 'Сортування';

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
  String get categoryFilter => 'Фільтр';

  @override
  String get categoryFilters => 'Фільтри';

  @override
  String get categoryNoFiltersAvailable => 'Немає доступних фільтрів';

  @override
  String get categoryFiltersWillAppear =>
      'Фільтри з\'являться, коли будуть доступні для цієї категорії';

  @override
  String get categoryApplyFilters => 'Застосувати фільтри';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Застосувати фільтри ($count)';
  }

  @override
  String get categoryClearAll => 'Очистити все';

  @override
  String get categoryTryAdjustingFilters =>
      'Спробуйте змінити фільтри або умови пошуку';

  @override
  String get categoryError => 'Помилка';

  @override
  String get categoryLoginToManageWishlist =>
      'Увійдіть, щоб керувати списком бажань';

  @override
  String get categoryAddedToWishlist => 'Додано до списку бажань';

  @override
  String get categoryRemovedFromWishlist => 'Видалено зі списку бажань';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Не вдалося оновити список бажань: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Кошик';

  @override
  String get cartPleaseLoginWishlist =>
      'Увійдіть, щоб переглянути список бажань';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText у кошику';
  }

  @override
  String get cartYourCartEmpty => 'Ваш кошик порожній';

  @override
  String get cartAddProductsHere =>
      'Додайте товари до кошика, щоб побачити їх тут';

  @override
  String get cartContinueShopping => 'Продовжити покупки';

  @override
  String get cartUnit => 'Од.';

  @override
  String get cartUnits => 'Од.';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Увійдіть, щоб додати до списку бажань';

  @override
  String get cartMovedToWishlist => 'Переміщено до списку бажань';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Не вдалося перемістити до списку бажань: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Показати більше';

  @override
  String get cartViewLess => 'Показати менше';

  @override
  String get cartEmptyCartAction => 'Очистити кошик';

  @override
  String get cartApplyCoupon => 'Застосувати купон';

  @override
  String get cartCouponCode => 'Код купона';

  @override
  String get cartApply => 'Застосувати';

  @override
  String get cartAppliedCoupon => 'Купон застосовано';

  @override
  String get cartRemove => 'Видалити';

  @override
  String get cartPriceBreak => 'Розбивка ціни';

  @override
  String get cartSubTotal => 'Проміжний підсумок';

  @override
  String get cartDiscount => 'Знижка';

  @override
  String get cartDeliveryCharges => 'Вартість доставки';

  @override
  String get cartTax => 'Податок';

  @override
  String get cartGrandTotal => 'Загальна сума';

  @override
  String get cartAmountToBePaid => 'Сума до сплати';

  @override
  String get cartPayNow => 'Сплатити зараз';

  @override
  String get cartRemoveItem => 'Видалити товар';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Ви впевнені, що хочете видалити \"$productName\" з кошика?';
  }

  @override
  String get cartCancel => 'Скасувати';

  @override
  String get cartEmptyCartTitle => 'Очистити кошик';

  @override
  String get cartEmptyCartConfirm =>
      'Ви впевнені, що хочете видалити всі товари з кошика?';

  @override
  String get checkout => 'Оформлення замовлення';

  @override
  String get checkoutBillingTo => 'Платіжна адреса';

  @override
  String get checkoutDeliveredTo => 'Доставка до';

  @override
  String get checkoutChange => 'Змінити';

  @override
  String get checkoutSelectBillingAddress => 'Виберіть платіжну адресу';

  @override
  String get checkoutSelectShippingAddress => 'Виберіть адресу доставки';

  @override
  String get checkoutBillingAddress => 'Платіжна адреса';

  @override
  String get checkoutEnterAddress => 'Введіть адресу';

  @override
  String get checkoutFirstName => 'Ім\'я';

  @override
  String get checkoutLastName => 'Прізвище';

  @override
  String get checkoutEmail => 'Ел. пошта';

  @override
  String get checkoutPhone => 'Телефон';

  @override
  String get checkoutStreetAddress => 'Вулиця';

  @override
  String get checkoutCountry => 'Країна';

  @override
  String get checkoutState => 'Область';

  @override
  String get checkoutCity => 'Місто';

  @override
  String get checkoutPostcode => 'Поштовий індекс';

  @override
  String get checkoutCompanyOptional => 'Компанія (необов\'язково)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Використовувати ту ж адресу для доставки?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Телефон: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Офіс';

  @override
  String get checkoutAddressTypeHome => 'Дім';

  @override
  String get checkoutAddressTypeBilling => 'Оплата';

  @override
  String get checkoutAddressTypeShipping => 'Доставка';

  @override
  String get checkoutAddressTypeDefault => 'За замовчуванням';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field є обов\'язковим';
  }

  @override
  String get checkoutSaveContinue => 'Зберегти та продовжити';

  @override
  String get checkoutYourCartEmpty => 'Ваш кошик порожній';

  @override
  String get checkoutSelectCountry => 'Виберіть країну';

  @override
  String get checkoutSelectState => 'Виберіть область';

  @override
  String get checkoutCountryRequired => 'Країна обов\'язкова';

  @override
  String get checkoutStateRequired => 'Область обов\'язкова';

  @override
  String get checkoutSelectCountryFirst => 'Спочатку виберіть країну';

  @override
  String get checkoutShippingMethod => 'Спосіб доставки';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Збережіть адресу, щоб побачити варіанти доставки';

  @override
  String get checkoutPaymentMethod => 'Спосіб оплати';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Спочатку виберіть спосіб доставки';

  @override
  String get checkoutEnterCouponCode => 'Введіть код купона';

  @override
  String get checkoutDiscountCoupon => 'Знижка (купон)';

  @override
  String get checkoutPlaceOrder => 'Оформити замовлення';

  @override
  String get thankYouTitle => 'Дякуємо за ваше замовлення!';

  @override
  String get thankYouSubtitle =>
      'Ми надішлемо вам на e-mail деталі замовлення та інформацію для відстеження';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Ваш номер замовлення #$orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Переглянути замовлення';

  @override
  String get thankYouContinueShopping => 'Продовжити покупки';

  @override
  String get accountPleaseTryAgainLater => 'Будь ласка, спробуйте пізніше';

  @override
  String get accountUserFallback => 'Користувач';

  @override
  String get accountBack => 'Назад';

  @override
  String get accountSettings => 'Налаштування';

  @override
  String get accountMyOrders => 'Мої замовлення';

  @override
  String get accountMyDownloadableProducts => 'Мої завантажувані товари';

  @override
  String get accountWishlist => 'Список бажань';

  @override
  String get accountCompareProducts => 'Порівняти товари';

  @override
  String get accountProductReview => 'Відгук про товар';

  @override
  String get accountAddressBook => 'Адресна книга';

  @override
  String get accountEditAccount => 'Редагувати акаунт';

  @override
  String get accountLogout => 'Вийти';

  @override
  String get accountLogoutConfirmation => 'Ви впевнені, що хочете вийти?';

  @override
  String get accountNoCountriesAvailable =>
      'Немає доступних країн. Спробуйте ще раз.';

  @override
  String get accountPleaseSelectCountry => 'Будь ласка, виберіть країну';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Будь ласка, виберіть або введіть область';

  @override
  String get accountAddressUpdatedSuccessfully => 'Адресу успішно оновлено';

  @override
  String get accountAddressAddedSuccessfully => 'Адресу успішно додано';

  @override
  String get accountGoBack => 'Назад';

  @override
  String get accountEditAddress => 'Редагувати адресу';

  @override
  String get accountAddNewAddress => 'Додати нову адресу';

  @override
  String get accountFirstNameRequired => 'Ім\'я обов\'язкове';

  @override
  String get accountLastNameRequired => 'Прізвище обов\'язкове';

  @override
  String get accountEnterValidEmail => 'Введіть коректний e-mail';

  @override
  String get accountCompanyName => 'Назва компанії';

  @override
  String get accountVatId => 'ПДВ ID';

  @override
  String get accountStreetAddressRequired => 'Адреса обов\'язкова';

  @override
  String get accountCityRequired => 'Місто обов\'язкове';

  @override
  String get accountZipPostcode => 'Поштовий індекс';

  @override
  String get accountZipPostcodeRequired => 'Поштовий індекс обов\'язковий';

  @override
  String get accountTelephone => 'Телефон';

  @override
  String get accountPhoneNumberRequired => 'Номер телефону обов\'язковий';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Змінити платіжну адресу за замовчуванням';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Змінити адресу доставки за замовчуванням';

  @override
  String get accountUpdateAddress => 'Оновити адресу';

  @override
  String get accountSaveToAddressBook => 'Зберегти в адресну книгу';

  @override
  String get accountPleaseLoginToWriteReview => 'Увійдіть, щоб написати відгук';

  @override
  String get accountPleaseSelectRating => 'Будь ласка, виберіть оцінку';

  @override
  String get accountAddReview => 'Додати відгук';

  @override
  String get accountReviewSubmitted => 'Відгук надіслано!';

  @override
  String get accountNickName => 'Псевдонім';

  @override
  String get accountEnterYourName => 'Введіть ваше ім\'я';

  @override
  String get accountNameRequired => 'Ім\'я обов\'язкове';

  @override
  String get accountSummary => 'Коротко';

  @override
  String get accountReviewSummaryHint => 'Короткий опис вашого відгуку';

  @override
  String get accountSummaryRequired => 'Короткий опис обов\'язковий';

  @override
  String get accountReview => 'Відгук';

  @override
  String get accountDetailedReviewHint => 'Напишіть детальний відгук тут';

  @override
  String get accountReviewRequired => 'Відгук обов\'язковий';

  @override
  String get accountRating => 'Оцінка';

  @override
  String get accountSubmitReview => 'Надіслати відгук';

  @override
  String get accountCouldNotLoadAddresses => 'Не вдалося завантажити адреси';

  @override
  String get accountPleaseTryAgain => 'Будь ласка, спробуйте ще раз';

  @override
  String get accountNoAddressesSaved => 'Немає збережених адрес';

  @override
  String get accountAddAddressToGetStarted => 'Додайте нову адресу, щоб почати';

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
  String get accountNoProductsToCompare => 'Немає товарів для порівняння';

  @override
  String get accountAddProductsToCompareHint =>
      'Додавайте товари для порівняння зі сторінки товару.';

  @override
  String get accountProducts => 'Товари';

  @override
  String get accountDescription => 'Опис';

  @override
  String get accountShortDescription => 'Короткий опис';

  @override
  String get accountActivity => 'Активність';

  @override
  String get accountSeller => 'Продавець';

  @override
  String get accountNotAvailable => 'Н/Д';

  @override
  String get accountMessageSentSuccessfully =>
      'Повідомлення успішно надіслано!';

  @override
  String get accountAnErrorOccurred => 'Сталася помилка';

  @override
  String get accountContactUs => 'Зв\'яжіться з нами';

  @override
  String get accountName => 'Ім\'я';

  @override
  String get accountEnterYourEmail => 'Введіть ваш e-mail';

  @override
  String get accountContact => 'Контакт';

  @override
  String get accountEnterYourPhoneNumber => 'Введіть ваш номер телефону';

  @override
  String get accountMessage => 'Повідомлення';

  @override
  String get accountEnterYourMessage => 'Введіть ваше повідомлення';

  @override
  String get accountSendMessage => 'Надіслати повідомлення';

  @override
  String get accountNameFieldEmpty => 'Поле імені не може бути порожнім';

  @override
  String get accountNameMinChars => 'Ім\'я має містити щонайменше 2 символи';

  @override
  String get accountEmailFieldEmpty => 'Поле e-mail не може бути порожнім';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Введіть коректну адресу e-mail';

  @override
  String get accountContactNumberEmpty =>
      'Номер контакту не може бути порожнім';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Введіть коректний номер контакту';

  @override
  String get accountMessageFieldEmpty =>
      'Поле повідомлення не може бути порожнім';

  @override
  String get accountMessageMinChars =>
      'Повідомлення має містити щонайменше 10 символів';

  @override
  String get accountDownloadableProducts => 'Завантажувані товари';

  @override
  String get accountNoDownloadsYet => 'Поки немає завантажень';

  @override
  String get accountDownloadsEmptyDescription =>
      'Тут з\'являться ваші завантажені товари.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total товарів';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return 'Залишилось $value';
  }

  @override
  String get accountDownload => 'Завантажити';

  @override
  String accountFileName(Object fileName) {
    return 'Файл: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Завантаження почнеться незабаром. Перевірте папку завантажень.';

  @override
  String get accountClose => 'Закрити';

  @override
  String get accountOrders => 'Замовлення';

  @override
  String get accountNoOrdersYet => 'Поки немає замовлень';

  @override
  String get accountOrdersEmptyDescription =>
      'Ваші замовлення з\'являться тут після покупки.';

  @override
  String get accountOrderSingular => 'Замовлення';

  @override
  String get accountOrderPlural => 'Замовлення';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Товарів $count)';
  }

  @override
  String get accountOrderAndReturn => 'Замовлення та повернення';

  @override
  String get accountTrackOrder => 'Відстежити замовлення';

  @override
  String get accountReturnPolicy => 'Політика повернення';

  @override
  String get accountReturnRequest => 'Запит на повернення';

  @override
  String get accountMyReturns => 'Мої повернення';

  @override
  String get accountReturns => 'Повернення';

  @override
  String get accountReturnSingular => 'Повернення';

  @override
  String get accountReturnPlural => 'Повернення';

  @override
  String get accountNoReturnsYet => 'Повернень поки немає';

  @override
  String get accountReturnsEmptyDescription =>
      'Ваші запити на повернення з’являться тут.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Повернення $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Замовлення $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'К-сть: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Макс.: $count';
  }

  @override
  String get accountReturnResolution => 'Рішення';

  @override
  String get accountReturnResolutionReturn => 'Повернення';

  @override
  String get accountReturnResolutionCancel => 'Скасувати товари';

  @override
  String get accountReturnReason => 'Причина';

  @override
  String get accountReturnSelectReason => 'Виберіть причину';

  @override
  String get accountReturnPackageCondition => 'Стан упаковки';

  @override
  String get accountReturnPackageConditionHint =>
      'напр. відкрита, запечатана, коробка пошкоджена';

  @override
  String get accountReturnAdditionalInfo => 'Додаткова інформація';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Опишіть проблему (необов’язково)';

  @override
  String get accountReturnAgreement =>
      'Я погоджуюся з умовами політики повернення';

  @override
  String get accountReturnAgreementRequired =>
      'Будь ласка, прийміть умови політики повернення';

  @override
  String get accountReturnSubmit => 'Надіслати запит';

  @override
  String get accountReturnCreatedTitle => 'Запит надіслано';

  @override
  String get accountReturnCreatedMessage =>
      'Ваш запит на повернення успішно надіслано.';

  @override
  String get accountReturnSelectItem => 'Виберіть товар';

  @override
  String get accountReturnNoReturnableItems => 'Немає товарів для повернення';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'У цьому замовленні немає товарів, доступних для повернення чи скасування.';

  @override
  String get accountReturnViewAction => 'Переглянути';

  @override
  String get accountReturnCancelAction => 'Скасувати запит';

  @override
  String get accountReturnCloseAction => 'Позначити як вирішений';

  @override
  String get accountReturnReopenAction => 'Відкрити запит знову';

  @override
  String get accountReturnCancelConfirmation =>
      'Ви впевнені, що хочете скасувати цей запит на повернення?';

  @override
  String get accountReturnCloseConfirmation =>
      'Позначити цей запит на повернення як вирішений?';

  @override
  String get accountReturnMessages => 'Повідомлення';

  @override
  String get accountReturnNoMessages => 'Повідомлень поки немає.';

  @override
  String get accountReturnMessageHint => 'Напишіть повідомлення…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Статус повернення оновлено: $status';
  }

  @override
  String get accountReturnExpired => 'Термін повернення минув';

  @override
  String get accountReturnInformation => 'Інформація';

  @override
  String get accountReturnSelectOrder => 'Виберіть замовлення';

  @override
  String get accountReturnChangeOrder => 'Змінити';

  @override
  String get accountReturnChooseAnotherOrder => 'Вибрати інше замовлення';

  @override
  String get accountNotifications => 'Сповіщення';

  @override
  String get accountPrivacy => 'Конфіденційність';

  @override
  String get accountAccount => 'Акаунт';

  @override
  String get accountPreferences => 'Налаштування';

  @override
  String get accountLanguage => 'Мова';

  @override
  String get accountNoLanguagesAvailable => 'Немає доступних мов';

  @override
  String get accountCurrency => 'Валюта';

  @override
  String get accountOthers => 'Інше';

  @override
  String get accountNoPagesAvailable => 'Немає доступних сторінок';

  @override
  String get accountProductReviews => 'Відгуки про товари';

  @override
  String get accountMyReviews => 'Мої відгуки';

  @override
  String get accountNoReviewsYet => 'Поки немає відгуків';

  @override
  String get accountReviewsEmptyDescription =>
      'Тут з\'являться ваші відгуки про товари.';

  @override
  String get accountReviewSingular => 'Відгук';

  @override
  String get accountReviewPlural => 'Відгуки';

  @override
  String accountPostedOn(Object date) {
    return 'Опубліковано $date';
  }

  @override
  String get accountCloseSettings => 'Закрити налаштування';

  @override
  String get accountChangeTheme => 'Змінити тему';

  @override
  String get accountAllNotifications => 'Усі сповіщення';

  @override
  String get accountOffers => 'Пропозиції';

  @override
  String get accountOfflineData => 'Офлайн-дані';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Відстежувати та показувати нещодавно переглянуті товари';

  @override
  String get accountShowSearchTag => 'Показувати тег пошуку';

  @override
  String get accountTryAgain => 'Спробувати знову';

  @override
  String get accountYourWishlistEmpty => 'Ваш список бажань порожній';

  @override
  String get accountWishlistEmptyDescription =>
      'Переглядайте товари та додавайте їх до списку бажань';

  @override
  String get accountItemSingular => 'Товар';

  @override
  String get accountItemPlural => 'Товари';

  @override
  String accountStartingAt(Object price) {
    return 'Від $price';
  }

  @override
  String get accountAboutThisPage => 'Про цю сторінку';

  @override
  String accountPageId(Object id) {
    return 'ID сторінки: $id';
  }

  @override
  String get mainTabHome => 'Головна';

  @override
  String get mainTabCategories => 'Категорії';

  @override
  String get mainTabCart => 'Кошик';

  @override
  String get mainTabAccount => 'Акаунт';

  @override
  String get authLoginSuccess => 'Ласкаво просимо! Вхід виконано успішно.';

  @override
  String get authWelcomeBack => 'З поверненням!';

  @override
  String get authLoginToAccount => 'Увійдіть до свого акаунта';

  @override
  String get authEmailAddress => 'E-mail';

  @override
  String get authEnterYourEmail => 'Введіть ваш e-mail';

  @override
  String get authPleaseEnterEmail => 'Введіть ваш e-mail';

  @override
  String get authPleaseEnterValidEmail => 'Введіть коректний e-mail';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authEnterYourPassword => 'Введіть пароль';

  @override
  String get authPleaseEnterPassword => 'Введіть пароль';

  @override
  String get authPasswordMinLength =>
      'Пароль має містити щонайменше 6 символів';

  @override
  String get authForgotPasswordTitle => 'Забули пароль?';

  @override
  String get authLogin => 'Увійти';

  @override
  String get authNoAccountPrompt => 'Немає акаунта? ';

  @override
  String get authSignUp => 'Зареєструватися';

  @override
  String get authAccountCreatedSuccess => 'Акаунт успішно створено!';

  @override
  String get authCreateAccount => 'Створити акаунт';

  @override
  String get authSignupGetStarted => 'Зареєструйтесь, щоб почати';

  @override
  String get authFirstNameHint => 'Ім\'я';

  @override
  String get authLastNameHint => 'Прізвище';

  @override
  String get authRequired => 'Обов\'язково';

  @override
  String get authCreatePasswordHint => 'Створіть пароль';

  @override
  String get authConfirmPassword => 'Підтвердіть пароль';

  @override
  String get authConfirmPasswordHint => 'Підтвердіть ваш пароль';

  @override
  String get authPleaseConfirmPassword => 'Підтвердіть пароль';

  @override
  String get authPasswordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get authAlreadyHaveAccountPrompt => 'Уже є акаунт? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Введіть ваш e-mail, і ми надішлемо посилання для скидання пароля.';

  @override
  String get authSendResetLink => 'Надіслати посилання';

  @override
  String get authBackToLogin => 'Назад до входу';

  @override
  String get authNiceToSeeYouHere => 'Раді бачити вас тут';

  @override
  String get accountEditTitle => 'Редагування акаунта';

  @override
  String get accountFirstNameRequiredLabel => 'Ім\'я *';

  @override
  String get accountLastNameRequiredLabel => 'Прізвище *';

  @override
  String get accountChangeEmail => 'Змінити e-mail';

  @override
  String get accountChangePassword => 'Змінити пароль';

  @override
  String get accountDeleteAccount => 'Видалити акаунт';

  @override
  String get accountGender => 'Стать';

  @override
  String get accountSelectGender => 'Оберіть стать';

  @override
  String get accountDob => 'Дата народження';

  @override
  String get monthJanShort => 'Січ';

  @override
  String get monthFebShort => 'Лют';

  @override
  String get monthMarShort => 'Бер';

  @override
  String get monthAprShort => 'Кві';

  @override
  String get monthMayShort => 'Тра';

  @override
  String get monthJunShort => 'Чер';

  @override
  String get monthJulShort => 'Лип';

  @override
  String get monthAugShort => 'Сер';

  @override
  String get monthSepShort => 'Вер';

  @override
  String get monthOctShort => 'Жов';

  @override
  String get monthNovShort => 'Лис';

  @override
  String get monthDecShort => 'Гру';

  @override
  String get accountSubscribeNewsletters => 'Підписатися на розсилку';

  @override
  String get accountSaveProfile => 'Зберегти профіль';

  @override
  String get accountNewEmail => 'Новий e-mail';

  @override
  String get accountEmailRequired => 'E-mail обов\'язковий';

  @override
  String get accountCurrentPassword => 'Поточний пароль';

  @override
  String get accountPasswordRequired => 'Пароль обов\'язковий';

  @override
  String get accountChange => 'Змінити';

  @override
  String get accountCurrentPasswordRequired => 'Поточний пароль обов\'язковий';

  @override
  String get accountNewPassword => 'Новий пароль';

  @override
  String get accountConfirmPassword => 'Підтвердіть пароль';

  @override
  String get accountDeleteWarning =>
      'Ця дія є незворотною. Усі ваші дані буде видалено.';

  @override
  String get accountEnterYourPassword => 'Введіть пароль';

  @override
  String get accountDelete => 'Видалити';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Чоловіча';

  @override
  String get accountGenderFemale => 'Жіноча';

  @override
  String get accountGenderOther => 'Інша';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Замовлення $number';
  }

  @override
  String get accountReorderSuccessful => 'Повторне замовлення виконано успішно';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\nДо кошика додано $count товарів.';
  }

  @override
  String get accountOk => 'ОК';

  @override
  String get accountGoToCart => 'Перейти до кошика';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Не вдалося завантажити деталі замовлення';

  @override
  String get accountDetails => 'Деталі';

  @override
  String get accountInvoices => 'Рахунки';

  @override
  String get accountShipments => 'Відправлення';

  @override
  String accountPlacedOn(Object date) {
    return 'Оформлено $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return 'Замовлено товарів: $count';
  }

  @override
  String get accountBillingAddress => 'Платіжна адреса';

  @override
  String get accountShippingAddress => 'Адреса доставки';

  @override
  String get accountShippingMethod => 'Спосіб доставки';

  @override
  String get accountPaymentMethod => 'Спосіб оплати';

  @override
  String get accountNoInvoicesForOrder => 'Для цього замовлення немає рахунків';

  @override
  String accountInvoicedCount(int count) {
    return 'Виставлено рахунків: $count';
  }

  @override
  String get accountNoShipmentsForOrder =>
      'Для цього замовлення немає відправлень';

  @override
  String get accountReorder => 'Повторити замовлення';

  @override
  String get accountCancelOrder => 'Скасувати замовлення';

  @override
  String get accountCancelOrderConfirmation =>
      'Ви впевнені, що хочете скасувати це замовлення? Цю дію не можна скасувати.';

  @override
  String get accountMoreInfo => 'Детальніше';

  @override
  String get accountOrderedQty => 'Замовлено';

  @override
  String get accountShipped => 'Відправлено';

  @override
  String get accountInvoiced => 'Виставлено';

  @override
  String get accountUnitPrice => 'Ціна за одиницю';

  @override
  String get accountSubTotalWithSpace => 'Проміжний підсумок';

  @override
  String get accountTotalPaid => 'Сплачено';

  @override
  String get accountTotalRefunded => 'Повернено';

  @override
  String get accountTotalDue => 'До сплати';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Рахунок $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Відправлення $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Не вдалося завантажити деталі рахунку';

  @override
  String get accountInvoiceStatus => 'Статус рахунку';

  @override
  String get accountInvoiceDate => 'Дата рахунку';

  @override
  String get accountOrderId => 'ID замовлення';

  @override
  String get accountOrderDate => 'Дата замовлення';

  @override
  String get accountOrderStatus => 'Статус замовлення';

  @override
  String get accountChannel => 'Канал';

  @override
  String get accountDefault => 'За замовчуванням';

  @override
  String get accountStatusPaid => 'Сплачено';

  @override
  String get accountStatusPending => 'Очікує';

  @override
  String get accountStatusPendingPayment => 'Очікується оплата';

  @override
  String get accountStatusOverdue => 'Прострочено';

  @override
  String get accountStatusRefunded => 'Повернено';

  @override
  String get accountShippedQty => 'Відправлено';

  @override
  String get accountInvoicedQty => 'Виставлено';

  @override
  String get accountUnitPriceWithColon => 'Ціна за одиницю:';

  @override
  String get accountSubTotalWithColon => 'Проміжний підсумок:';

  @override
  String get accountDownloadInvoice => 'Завантажити рахунок';

  @override
  String get accountInvoice => 'Рахунок';

  @override
  String get accountRecentOrders => 'Останні замовлення';

  @override
  String get accountNoRecentOrders => 'Немає останніх замовлень';

  @override
  String get accountStatusProcessing => 'Обробка';

  @override
  String get accountStatusCompleted => 'Завершено';

  @override
  String get accountStatusCancelled => 'Скасовано';

  @override
  String get accountStatusClosed => 'Закрито';

  @override
  String get accountStatusUnknown => 'Невідомо';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Товари у списку бажань ($count)';
  }

  @override
  String get accountNoWishlistItems => 'Немає товарів у списку бажань';

  @override
  String get accountDefaultAddresses => 'Адреси за замовчуванням';

  @override
  String get accountNoProductReviewsYet => 'Поки немає відгуків про товари';

  @override
  String get searchFailedTitle => 'Пошук не вдався';

  @override
  String get searchHint => 'Пошук товарів';

  @override
  String get searchImageSearch => 'Пошук за зображенням';

  @override
  String get searchRecentSearches => 'Нещодавні пошуки';

  @override
  String get searchClearAll => 'Очистити все';

  @override
  String get searchTopCategories => 'Популярні категорії';

  @override
  String searchResultsFound(int count) {
    return 'Знайдено результатів: $count';
  }

  @override
  String searchDiscountOff(Object percent) {
    return 'Знижка $percent%';
  }

  @override
  String get searchNoProductsFound => 'Товарів не знайдено';

  @override
  String get searchTryDifferentTerm => 'Спробуйте інший пошуковий запит';

  @override
  String get searchSpeechNotAvailable => 'Розпізнавання мовлення недоступне';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Не вдалося почати голосове введення: $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Доступ до мікрофона заборонено';

  @override
  String get searchRetake => 'Перезняти';

  @override
  String get searchSearch => 'Пошук';

  @override
  String get searchTryAgain => 'Спробувати знову';

  @override
  String get searchRecognizedObjects => 'Розпізнані об\'єкти';

  @override
  String get searchResult => 'Результат:';

  @override
  String get searchFailedToCaptureImage => 'Не вдалося зробити знімок';

  @override
  String searchProcessing(int progress) {
    return 'Обробка... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Відкриття камери...';

  @override
  String get searchFailedToProcessImage => 'Не вдалося обробити зображення';

  @override
  String get homeRecentlyViewedProducts => 'Нещодавно переглянуті товари';

  @override
  String accountItemsCount(int count) {
    return '$count товар(ів)';
  }

  @override
  String get accountTrack => 'Відстежити';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Відстеження $trackNumber через $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Невідомий перевізник';

  @override
  String get accountTrackingNumber => 'Номер відстеження';

  @override
  String accountSkuValue(Object sku) {
    return 'Артикул : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Відправлено : $qty';
  }
}
