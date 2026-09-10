// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Магазин Bagisto';

  @override
  String get homeFailedToLoad => 'Не удалось загрузить главную страницу';

  @override
  String get commonUnknownError => 'Неизвестная ошибка';

  @override
  String get commonRetry => 'Повторить';

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
  String get homeFeaturedProducts => 'Рекомендуемые товары';

  @override
  String get homeDefaultProducts => 'Товары';

  @override
  String get homeBackToTop => 'Наверх';

  @override
  String get homeViewCart => 'ПОСМОТРЕТЬ КОРЗИНУ';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName добавлен в корзину';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Войдите, чтобы управлять списком желаний';

  @override
  String get homeAddedToWishlist => 'Добавлено в список желаний';

  @override
  String get homeRemovedFromWishlist => 'Удалено из списка желаний';

  @override
  String get homeViewAll => 'Смотреть все';

  @override
  String get homeCollections => 'Коллекции';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Категория $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return 'Скидка $percent%';
  }

  @override
  String get productFailedToLoad => 'Не удалось загрузить товар';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String get productDetail => 'Детали товара';

  @override
  String get productDetails => 'Детали';

  @override
  String get productShowLess => 'Показать меньше';

  @override
  String get productLoadMore => 'Загрузить еще';

  @override
  String get productMoreInformations => 'Подробнее';

  @override
  String get productSku => 'Артикул';

  @override
  String get productType => 'Тип';

  @override
  String get productBrand => 'Бренд';

  @override
  String get productColor => 'Цвет';

  @override
  String get productSize => 'Размер';

  @override
  String get productReviews => 'Отзывы';

  @override
  String get productNoReviewsYet => 'Пока нет отзывов';

  @override
  String productRating(Object count) {
    return '$count оценка';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count отзывов';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Опубликовано $day $month $year';
  }

  @override
  String get productReviewSubmitted => 'Ваш отзыв отправлен!';

  @override
  String get productWriteReview => 'Написать отзыв';

  @override
  String get productPleaseLoginForReviews =>
      'Войдите, чтобы увидеть свои отзывы';

  @override
  String get productLoadMoreReviews => 'Загрузить больше отзывов';

  @override
  String get productRelatedProduct => 'Похожие товары';

  @override
  String productDiscountOff(Object percent) {
    return 'Скидка $percent%';
  }

  @override
  String get productVeryGood => 'Очень хорошо';

  @override
  String get productGood => 'Хорошо';

  @override
  String get productAverage => 'Средне';

  @override
  String get productBad => 'Плохо';

  @override
  String get productVeryBad => 'Очень плохо';

  @override
  String get productInStock => 'В наличии';

  @override
  String get productOutOfStock => 'Нет в наличии';

  @override
  String get productQuantity => 'Количество';

  @override
  String get productWishlistAction => 'Список желаний';

  @override
  String get productCompareAction => 'Сравнить';

  @override
  String get productShareAction => 'Поделиться';

  @override
  String get productLoginToCompare => 'Войдите, чтобы добавить к сравнению';

  @override
  String get productAddedToCompare => 'Добавлено к сравнению';

  @override
  String get productAddToCart => 'Добавить в корзину';

  @override
  String get accountMoveToCart => 'Переместить в корзину';

  @override
  String get productBuyNow => 'Купить сейчас';

  @override
  String get productSelectOptionsFirst => 'Сначала выберите параметры товара';

  @override
  String get productBookingBookTable => 'Забронировать столик *';

  @override
  String get productBookingSelectDateRequired => 'Выберите дату *';

  @override
  String get productBookingSelectSlotRequired => 'Выберите слот *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Особые пожелания/Заметки *';

  @override
  String get productBookingBookAppointment => 'Записаться на прием *';

  @override
  String get productBookingDateFormatHint => 'ГГГГ-ММ-ДД';

  @override
  String get productBookingFrom => 'С';

  @override
  String get productBookingTo => 'По';

  @override
  String get productBookingSelectDate => 'Выберите дату';

  @override
  String get productBookingLocation => 'Местоположение';

  @override
  String get productBookingSlotDuration => 'Длительность слота';

  @override
  String get productBookingAvailability => 'Доступность';

  @override
  String get productBookingStartDate => 'Дата начала';

  @override
  String get productBookingEndDate => 'Дата окончания';

  @override
  String get productBookingDate => 'Дата';

  @override
  String get productBookingViewOnMap => 'Показать на карте';

  @override
  String get productBookingEventOn => 'Событие:';

  @override
  String get productBookingBookYourTicket => 'Забронируйте билет';

  @override
  String get productBookingSlotDurationLabel => 'Длительность слота:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count минут';
  }

  @override
  String get productBookingAvailableFrom => 'Доступно с';

  @override
  String get productBookingAvailableTo => 'Доступно до';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Особые пожелания/Заметки';

  @override
  String get productBookingChooseRentOption => 'Выберите вариант аренды *';

  @override
  String get productBookingDailyBasis => 'Посуточно';

  @override
  String get productBookingHourlyBasis => 'Почасово';

  @override
  String get productBookingNoDatesAvailable =>
      'Нет доступных дат для бронирования';

  @override
  String get productBookingSelectSlot => 'Выберите слот';

  @override
  String get productBookingSelectDateFirst => 'Сначала выберите дату';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Сначала выберите дату, чтобы увидеть доступные слоты.';

  @override
  String get productBookingLoadingSlots => 'Загрузка слотов...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Загружаются доступные слоты для выбранной даты.';

  @override
  String get productBookingUnableToLoadSlots => 'Не удалось загрузить слоты';

  @override
  String get productBookingNoSlotsAvailable => 'Нет доступных слотов';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'Для выбранной даты нет доступных слотов.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Выберите один доступный слот, чтобы продолжить.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Особые пожелания/Заметки';

  @override
  String get productDownloadableLinks => 'Ссылки';

  @override
  String get productDownloadableSamples => 'Образцы';

  @override
  String get productDownloadSample => 'Скачать образец';

  @override
  String get productDefaultName => 'Товар';

  @override
  String get categoryDefaultName => 'Категории';

  @override
  String get categorySubCategories => 'Подкатегории';

  @override
  String get categorySomethingWentWrong => 'Что-то пошло не так';

  @override
  String get categoryUnknownError => 'Неизвестная ошибка';

  @override
  String categoryItemsFound(Object count) {
    return 'Найдено товаров: $count';
  }

  @override
  String get categoryNoProductsFound => 'Товары не найдены';

  @override
  String get categorySort => 'Сортировка';

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
  String get categoryFilter => 'Фильтр';

  @override
  String get categoryFilters => 'Фильтры';

  @override
  String get categoryNoFiltersAvailable => 'Нет доступных фильтров';

  @override
  String get categoryFiltersWillAppear =>
      'Фильтры появятся, когда будут доступны для этой категории';

  @override
  String get categoryApplyFilters => 'Применить фильтры';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Применить фильтры ($count)';
  }

  @override
  String get categoryClearAll => 'Очистить всё';

  @override
  String get categoryTryAdjustingFilters =>
      'Попробуйте изменить фильтры или условия поиска';

  @override
  String get categoryError => 'Ошибка';

  @override
  String get categoryLoginToManageWishlist =>
      'Войдите, чтобы управлять списком желаний';

  @override
  String get categoryAddedToWishlist => 'Добавлено в список желаний';

  @override
  String get categoryRemovedFromWishlist => 'Удалено из списка желаний';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'Не удалось обновить список желаний: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Корзина';

  @override
  String get cartPleaseLoginWishlist =>
      'Войдите, чтобы просмотреть список желаний';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText в корзине';
  }

  @override
  String get cartYourCartEmpty => 'Ваша корзина пуста';

  @override
  String get cartAddProductsHere =>
      'Добавьте товары в корзину, чтобы увидеть их здесь';

  @override
  String get cartContinueShopping => 'Продолжить покупки';

  @override
  String get cartUnit => 'Ед.';

  @override
  String get cartUnits => 'Ед.';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Войдите, чтобы добавить в список желаний';

  @override
  String get cartMovedToWishlist => 'Перемещено в список желаний';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Не удалось переместить в список желаний: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Показать больше';

  @override
  String get cartViewLess => 'Показать меньше';

  @override
  String get cartEmptyCartAction => 'Очистить корзину';

  @override
  String get cartApplyCoupon => 'Применить купон';

  @override
  String get cartCouponCode => 'Код купона';

  @override
  String get cartApply => 'Применить';

  @override
  String get cartAppliedCoupon => 'Купон применен';

  @override
  String get cartRemove => 'Удалить';

  @override
  String get cartPriceBreak => 'Разбивка цены';

  @override
  String get cartSubTotal => 'Промежуточный итог';

  @override
  String get cartDiscount => 'Скидка';

  @override
  String get cartDeliveryCharges => 'Стоимость доставки';

  @override
  String get cartTax => 'Налог';

  @override
  String get cartGrandTotal => 'Итоговая сумма';

  @override
  String get cartAmountToBePaid => 'Сумма к оплате';

  @override
  String get cartPayNow => 'Оплатить сейчас';

  @override
  String get cartRemoveItem => 'Удалить товар';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return 'Вы уверены, что хотите удалить \"$productName\" из корзины?';
  }

  @override
  String get cartCancel => 'Отмена';

  @override
  String get cartEmptyCartTitle => 'Очистить корзину';

  @override
  String get cartEmptyCartConfirm =>
      'Вы уверены, что хотите удалить все товары из корзины?';

  @override
  String get checkout => 'Оформление заказа';

  @override
  String get checkoutBillingTo => 'Плательщик';

  @override
  String get checkoutDeliveredTo => 'Доставить';

  @override
  String get checkoutChange => 'Изменить';

  @override
  String get checkoutSelectBillingAddress => 'Выберите платежный адрес';

  @override
  String get checkoutSelectShippingAddress => 'Выберите адрес доставки';

  @override
  String get checkoutBillingAddress => 'Платежный адрес';

  @override
  String get checkoutEnterAddress => 'Введите адрес';

  @override
  String get checkoutFirstName => 'Имя';

  @override
  String get checkoutLastName => 'Фамилия';

  @override
  String get checkoutEmail => 'Эл. почта';

  @override
  String get checkoutPhone => 'Телефон';

  @override
  String get checkoutStreetAddress => 'Улица';

  @override
  String get checkoutCountry => 'Страна';

  @override
  String get checkoutState => 'Регион';

  @override
  String get checkoutCity => 'Город';

  @override
  String get checkoutPostcode => 'Почтовый индекс';

  @override
  String get checkoutCompanyOptional => 'Компания (необязательно)';

  @override
  String get checkoutUseSameAddressShipping =>
      'Использовать тот же адрес для доставки?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Телефон: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Офис';

  @override
  String get checkoutAddressTypeHome => 'Дом';

  @override
  String get checkoutAddressTypeBilling => 'Оплата';

  @override
  String get checkoutAddressTypeShipping => 'Доставка';

  @override
  String get checkoutAddressTypeDefault => 'По умолчанию';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field обязательно';
  }

  @override
  String get checkoutSaveContinue => 'Сохранить и продолжить';

  @override
  String get checkoutYourCartEmpty => 'Ваша корзина пуста';

  @override
  String get checkoutSelectCountry => 'Выберите страну';

  @override
  String get checkoutSelectState => 'Выберите регион';

  @override
  String get checkoutCountryRequired => 'Страна обязательна';

  @override
  String get checkoutStateRequired => 'Регион обязателен';

  @override
  String get checkoutSelectCountryFirst => 'Сначала выберите страну';

  @override
  String get checkoutShippingMethod => 'Способ доставки';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Сохраните адрес, чтобы увидеть варианты доставки';

  @override
  String get checkoutPaymentMethod => 'Способ оплаты';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Сначала выберите способ доставки';

  @override
  String get checkoutEnterCouponCode => 'Введите код купона';

  @override
  String get checkoutDiscountCoupon => 'Скидка (купон)';

  @override
  String get checkoutPlaceOrder => 'Оформить заказ';

  @override
  String get thankYouTitle => 'Спасибо за ваш заказ!';

  @override
  String get thankYouSubtitle =>
      'Мы отправим вам на почту детали заказа и информацию для отслеживания';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Ваш номер заказа #$orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Посмотреть заказ';

  @override
  String get thankYouContinueShopping => 'Продолжить покупки';

  @override
  String get accountPleaseTryAgainLater => 'Пожалуйста, попробуйте позже';

  @override
  String get accountUserFallback => 'Пользователь';

  @override
  String get accountBack => 'Назад';

  @override
  String get accountSettings => 'Настройки';

  @override
  String get accountMyOrders => 'Мои заказы';

  @override
  String get accountMyDownloadableProducts => 'Мои загружаемые товары';

  @override
  String get accountWishlist => 'Список желаний';

  @override
  String get accountCompareProducts => 'Сравнить товары';

  @override
  String get accountProductReview => 'Отзыв о товаре';

  @override
  String get accountAddressBook => 'Адресная книга';

  @override
  String get accountEditAccount => 'Редактировать аккаунт';

  @override
  String get accountLogout => 'Выйти';

  @override
  String get accountLogoutConfirmation => 'Вы уверены, что хотите выйти?';

  @override
  String get accountNoCountriesAvailable =>
      'Нет доступных стран. Попробуйте снова.';

  @override
  String get accountPleaseSelectCountry => 'Пожалуйста, выберите страну';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Пожалуйста, выберите или введите регион';

  @override
  String get accountAddressUpdatedSuccessfully => 'Адрес успешно обновлен';

  @override
  String get accountAddressAddedSuccessfully => 'Адрес успешно добавлен';

  @override
  String get accountGoBack => 'Назад';

  @override
  String get accountEditAddress => 'Редактировать адрес';

  @override
  String get accountAddNewAddress => 'Добавить новый адрес';

  @override
  String get accountFirstNameRequired => 'Имя обязательно';

  @override
  String get accountLastNameRequired => 'Фамилия обязательна';

  @override
  String get accountEnterValidEmail => 'Введите корректный e-mail';

  @override
  String get accountCompanyName => 'Название компании';

  @override
  String get accountVatId => 'НДС ID';

  @override
  String get accountStreetAddressRequired => 'Адрес обязателен';

  @override
  String get accountCityRequired => 'Город обязателен';

  @override
  String get accountZipPostcode => 'Почтовый индекс';

  @override
  String get accountZipPostcodeRequired => 'Почтовый индекс обязателен';

  @override
  String get accountTelephone => 'Телефон';

  @override
  String get accountPhoneNumberRequired => 'Номер телефона обязателен';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Изменить адрес оплаты по умолчанию';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Изменить адрес доставки по умолчанию';

  @override
  String get accountUpdateAddress => 'Обновить адрес';

  @override
  String get accountSaveToAddressBook => 'Сохранить в адресную книгу';

  @override
  String get accountPleaseLoginToWriteReview => 'Войдите, чтобы написать отзыв';

  @override
  String get accountPleaseSelectRating => 'Пожалуйста, выберите оценку';

  @override
  String get accountAddReview => 'Добавить отзыв';

  @override
  String get accountReviewSubmitted => 'Отзыв отправлен!';

  @override
  String get accountNickName => 'Псевдоним';

  @override
  String get accountEnterYourName => 'Введите ваше имя';

  @override
  String get accountNameRequired => 'Имя обязательно';

  @override
  String get accountSummary => 'Кратко';

  @override
  String get accountReviewSummaryHint => 'Краткое описание вашего отзыва';

  @override
  String get accountSummaryRequired => 'Краткое описание обязательно';

  @override
  String get accountReview => 'Отзыв';

  @override
  String get accountDetailedReviewHint => 'Напишите подробный отзыв здесь';

  @override
  String get accountReviewRequired => 'Отзыв обязателен';

  @override
  String get accountRating => 'Оценка';

  @override
  String get accountSubmitReview => 'Отправить отзыв';

  @override
  String get accountCouldNotLoadAddresses => 'Не удалось загрузить адреса';

  @override
  String get accountPleaseTryAgain => 'Пожалуйста, попробуйте снова';

  @override
  String get accountNoAddressesSaved => 'Нет сохраненных адресов';

  @override
  String get accountAddAddressToGetStarted =>
      'Добавьте новый адрес, чтобы начать';

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
  String get accountNoProductsToCompare => 'Нет товаров для сравнения';

  @override
  String get accountAddProductsToCompareHint =>
      'Добавляйте товары для сравнения со страницы товара.';

  @override
  String get accountProducts => 'Товары';

  @override
  String get accountDescription => 'Описание';

  @override
  String get accountShortDescription => 'Краткое описание';

  @override
  String get accountActivity => 'Активность';

  @override
  String get accountSeller => 'Продавец';

  @override
  String get accountNotAvailable => 'Н/Д';

  @override
  String get accountMessageSentSuccessfully => 'Сообщение успешно отправлено!';

  @override
  String get accountAnErrorOccurred => 'Произошла ошибка';

  @override
  String get accountContactUs => 'Свяжитесь с нами';

  @override
  String get accountName => 'Имя';

  @override
  String get accountEnterYourEmail => 'Введите ваш e-mail';

  @override
  String get accountContact => 'Контакт';

  @override
  String get accountEnterYourPhoneNumber => 'Введите ваш номер телефона';

  @override
  String get accountMessage => 'Сообщение';

  @override
  String get accountEnterYourMessage => 'Введите ваше сообщение';

  @override
  String get accountSendMessage => 'Отправить сообщение';

  @override
  String get accountNameFieldEmpty => 'Поле имени не может быть пустым';

  @override
  String get accountNameMinChars => 'Имя должно содержать минимум 2 символа';

  @override
  String get accountEmailFieldEmpty => 'Поле e-mail не может быть пустым';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Введите корректный e-mail адрес';

  @override
  String get accountContactNumberEmpty => 'Номер контакта не может быть пустым';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Введите корректный номер контакта';

  @override
  String get accountMessageFieldEmpty => 'Поле сообщения не может быть пустым';

  @override
  String get accountMessageMinChars =>
      'Сообщение должно содержать минимум 10 символов';

  @override
  String get accountDownloadableProducts => 'Загружаемые товары';

  @override
  String get accountNoDownloadsYet => 'Пока нет загрузок';

  @override
  String get accountDownloadsEmptyDescription =>
      'Здесь появятся ваши загруженные товары.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total товаров';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return 'Осталось $value';
  }

  @override
  String get accountDownload => 'Скачать';

  @override
  String accountFileName(Object fileName) {
    return 'Файл: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Загрузка начнется в ближайшее время. Проверьте папку загрузок.';

  @override
  String get accountClose => 'Закрыть';

  @override
  String get accountOrders => 'Заказы';

  @override
  String get accountNoOrdersYet => 'Пока нет заказов';

  @override
  String get accountOrdersEmptyDescription =>
      'Ваши заказы появятся здесь после покупки.';

  @override
  String get accountOrderSingular => 'Заказ';

  @override
  String get accountOrderPlural => 'Заказы';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Товаров $count)';
  }

  @override
  String get accountOrderAndReturn => 'Заказ и возврат';

  @override
  String get accountTrackOrder => 'Отследить заказ';

  @override
  String get accountReturnPolicy => 'Политика возврата';

  @override
  String get accountReturnRequest => 'Запрос на возврат';

  @override
  String get accountMyReturns => 'Мои возвраты';

  @override
  String get accountReturns => 'Возвраты';

  @override
  String get accountReturnSingular => 'Возврат';

  @override
  String get accountReturnPlural => 'Возвраты';

  @override
  String get accountNoReturnsYet => 'Возвратов пока нет';

  @override
  String get accountReturnsEmptyDescription =>
      'Ваши запросы на возврат появятся здесь.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Возврат $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Заказ $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Кол-во: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Макс.: $count';
  }

  @override
  String get accountReturnResolution => 'Решение';

  @override
  String get accountReturnResolutionReturn => 'Возврат';

  @override
  String get accountReturnResolutionCancel => 'Отменить товары';

  @override
  String get accountReturnReason => 'Причина';

  @override
  String get accountReturnSelectReason => 'Выберите причину';

  @override
  String get accountReturnPackageCondition => 'Состояние упаковки';

  @override
  String get accountReturnPackageConditionHint =>
      'напр. вскрыта, запечатана, коробка повреждена';

  @override
  String get accountReturnAdditionalInfo => 'Дополнительная информация';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Опишите проблему (необязательно)';

  @override
  String get accountReturnAgreement =>
      'Я согласен с условиями политики возврата';

  @override
  String get accountReturnAgreementRequired =>
      'Пожалуйста, примите условия политики возврата';

  @override
  String get accountReturnSubmit => 'Отправить запрос';

  @override
  String get accountReturnCreatedTitle => 'Запрос отправлен';

  @override
  String get accountReturnCreatedMessage =>
      'Ваш запрос на возврат успешно отправлен.';

  @override
  String get accountReturnSelectItem => 'Выберите товар';

  @override
  String get accountReturnNoReturnableItems => 'Нет товаров для возврата';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'В этом заказе нет товаров, доступных для возврата или отмены.';

  @override
  String get accountReturnViewAction => 'Просмотр';

  @override
  String get accountReturnCancelAction => 'Отменить запрос';

  @override
  String get accountReturnCloseAction => 'Отметить как решённый';

  @override
  String get accountReturnReopenAction => 'Открыть запрос заново';

  @override
  String get accountReturnCancelConfirmation =>
      'Вы уверены, что хотите отменить этот запрос на возврат?';

  @override
  String get accountReturnCloseConfirmation =>
      'Отметить этот запрос на возврат как решённый?';

  @override
  String get accountReturnMessages => 'Сообщения';

  @override
  String get accountReturnNoMessages => 'Сообщений пока нет.';

  @override
  String get accountReturnMessageHint => 'Написать сообщение…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Статус возврата обновлён: $status';
  }

  @override
  String get accountReturnExpired => 'Срок возврата истёк';

  @override
  String get accountReturnInformation => 'Информация';

  @override
  String get accountReturnSelectOrder => 'Выберите заказ';

  @override
  String get accountReturnChangeOrder => 'Изменить';

  @override
  String get accountReturnChooseAnotherOrder => 'Выбрать другой заказ';

  @override
  String get accountNotifications => 'Уведомления';

  @override
  String get accountPrivacy => 'Конфиденциальность';

  @override
  String get accountAccount => 'Аккаунт';

  @override
  String get accountPreferences => 'Настройки';

  @override
  String get accountLanguage => 'Язык';

  @override
  String get accountNoLanguagesAvailable => 'Нет доступных языков';

  @override
  String get accountCurrency => 'Валюта';

  @override
  String get accountOthers => 'Другое';

  @override
  String get accountNoPagesAvailable => 'Нет доступных страниц';

  @override
  String get accountProductReviews => 'Отзывы о товарах';

  @override
  String get accountMyReviews => 'Мои отзывы';

  @override
  String get accountNoReviewsYet => 'Пока нет отзывов';

  @override
  String get accountReviewsEmptyDescription =>
      'Здесь появятся ваши отзывы о товарах.';

  @override
  String get accountReviewSingular => 'Отзыв';

  @override
  String get accountReviewPlural => 'Отзывы';

  @override
  String accountPostedOn(Object date) {
    return 'Опубликовано $date';
  }

  @override
  String get accountCloseSettings => 'Закрыть настройки';

  @override
  String get accountChangeTheme => 'Изменить тему';

  @override
  String get accountAllNotifications => 'Все уведомления';

  @override
  String get accountOffers => 'Предложения';

  @override
  String get accountOfflineData => 'Офлайн-данные';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Отслеживать и показывать недавно просмотренные товары';

  @override
  String get accountShowSearchTag => 'Показывать поисковый тег';

  @override
  String get accountTryAgain => 'Повторить';

  @override
  String get accountYourWishlistEmpty => 'Ваш список желаний пуст';

  @override
  String get accountWishlistEmptyDescription =>
      'Просматривайте товары и добавляйте их в список желаний';

  @override
  String get accountItemSingular => 'Товар';

  @override
  String get accountItemPlural => 'Товары';

  @override
  String accountStartingAt(Object price) {
    return 'От $price';
  }

  @override
  String get accountAboutThisPage => 'Об этой странице';

  @override
  String accountPageId(Object id) {
    return 'ID страницы: $id';
  }

  @override
  String get mainTabHome => 'Главная';

  @override
  String get mainTabCategories => 'Категории';

  @override
  String get mainTabCart => 'Корзина';

  @override
  String get mainTabAccount => 'Аккаунт';

  @override
  String get authLoginSuccess => 'Добро пожаловать! Вход выполнен успешно.';

  @override
  String get authWelcomeBack => 'С возвращением!';

  @override
  String get authLoginToAccount => 'Войдите в свой аккаунт';

  @override
  String get authEmailAddress => 'E-mail';

  @override
  String get authEnterYourEmail => 'Введите ваш e-mail';

  @override
  String get authPleaseEnterEmail => 'Введите ваш e-mail';

  @override
  String get authPleaseEnterValidEmail => 'Введите корректный e-mail';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authEnterYourPassword => 'Введите пароль';

  @override
  String get authPleaseEnterPassword => 'Введите пароль';

  @override
  String get authPasswordMinLength =>
      'Пароль должен содержать минимум 6 символов';

  @override
  String get authForgotPasswordTitle => 'Забыли пароль?';

  @override
  String get authLogin => 'Войти';

  @override
  String get authNoAccountPrompt => 'Нет аккаунта? ';

  @override
  String get authSignUp => 'Регистрация';

  @override
  String get authAccountCreatedSuccess => 'Аккаунт успешно создан!';

  @override
  String get authCreateAccount => 'Создать аккаунт';

  @override
  String get authSignupGetStarted => 'Зарегистрируйтесь, чтобы начать';

  @override
  String get authFirstNameHint => 'Имя';

  @override
  String get authLastNameHint => 'Фамилия';

  @override
  String get authRequired => 'Обязательно';

  @override
  String get authCreatePasswordHint => 'Создайте пароль';

  @override
  String get authConfirmPassword => 'Подтвердите пароль';

  @override
  String get authConfirmPasswordHint => 'Подтвердите ваш пароль';

  @override
  String get authPleaseConfirmPassword => 'Подтвердите пароль';

  @override
  String get authPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get authAlreadyHaveAccountPrompt => 'Уже есть аккаунт? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Введите ваш e-mail, и мы отправим ссылку для сброса пароля.';

  @override
  String get authSendResetLink => 'Отправить ссылку';

  @override
  String get authBackToLogin => 'Назад ко входу';

  @override
  String get authNiceToSeeYouHere => 'Рады видеть вас здесь';

  @override
  String get accountEditTitle => 'Редактирование аккаунта';

  @override
  String get accountFirstNameRequiredLabel => 'Имя *';

  @override
  String get accountLastNameRequiredLabel => 'Фамилия *';

  @override
  String get accountChangeEmail => 'Изменить e-mail';

  @override
  String get accountChangePassword => 'Изменить пароль';

  @override
  String get accountDeleteAccount => 'Удалить аккаунт';

  @override
  String get accountGender => 'Пол';

  @override
  String get accountSelectGender => 'Выберите пол';

  @override
  String get accountDob => 'Дата рождения';

  @override
  String get monthJanShort => 'Янв';

  @override
  String get monthFebShort => 'Фев';

  @override
  String get monthMarShort => 'Мар';

  @override
  String get monthAprShort => 'Апр';

  @override
  String get monthMayShort => 'Май';

  @override
  String get monthJunShort => 'Июн';

  @override
  String get monthJulShort => 'Июл';

  @override
  String get monthAugShort => 'Авг';

  @override
  String get monthSepShort => 'Сен';

  @override
  String get monthOctShort => 'Окт';

  @override
  String get monthNovShort => 'Ноя';

  @override
  String get monthDecShort => 'Дек';

  @override
  String get accountSubscribeNewsletters => 'Подписаться на рассылку';

  @override
  String get accountSaveProfile => 'Сохранить профиль';

  @override
  String get accountNewEmail => 'Новый e-mail';

  @override
  String get accountEmailRequired => 'E-mail обязателен';

  @override
  String get accountCurrentPassword => 'Текущий пароль';

  @override
  String get accountPasswordRequired => 'Пароль обязателен';

  @override
  String get accountChange => 'Изменить';

  @override
  String get accountCurrentPasswordRequired => 'Текущий пароль обязателен';

  @override
  String get accountNewPassword => 'Новый пароль';

  @override
  String get accountConfirmPassword => 'Подтвердите пароль';

  @override
  String get accountDeleteWarning =>
      'Это действие необратимо. Все ваши данные будут удалены.';

  @override
  String get accountEnterYourPassword => 'Введите пароль';

  @override
  String get accountDelete => 'Удалить';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Мужской';

  @override
  String get accountGenderFemale => 'Женский';

  @override
  String get accountGenderOther => 'Другой';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Заказы $number';
  }

  @override
  String get accountReorderSuccessful => 'Повторный заказ выполнен успешно';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\nВ корзину добавлено $count товаров.';
  }

  @override
  String get accountOk => 'ОК';

  @override
  String get accountGoToCart => 'Перейти в корзину';

  @override
  String get accountFailedToLoadOrderDetails =>
      'Не удалось загрузить детали заказа';

  @override
  String get accountDetails => 'Детали';

  @override
  String get accountInvoices => 'Счета';

  @override
  String get accountShipments => 'Отгрузки';

  @override
  String accountPlacedOn(Object date) {
    return 'Оформлен $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return 'Заказано товаров: $count';
  }

  @override
  String get accountBillingAddress => 'Платежный адрес';

  @override
  String get accountShippingAddress => 'Адрес доставки';

  @override
  String get accountShippingMethod => 'Способ доставки';

  @override
  String get accountPaymentMethod => 'Способ оплаты';

  @override
  String get accountNoInvoicesForOrder => 'Для этого заказа нет счетов';

  @override
  String accountInvoicedCount(int count) {
    return 'Выставлено счетов: $count';
  }

  @override
  String get accountNoShipmentsForOrder => 'Для этого заказа нет отгрузок';

  @override
  String get accountReorder => 'Повторить заказ';

  @override
  String get accountCancelOrder => 'Отменить заказ';

  @override
  String get accountCancelOrderConfirmation =>
      'Вы уверены, что хотите отменить этот заказ? Это действие нельзя отменить.';

  @override
  String get accountMoreInfo => 'Подробнее';

  @override
  String get accountOrderedQty => 'Заказано';

  @override
  String get accountShipped => 'Отправлено';

  @override
  String get accountInvoiced => 'Выставлено';

  @override
  String get accountUnitPrice => 'Цена за единицу';

  @override
  String get accountSubTotalWithSpace => 'Промежуточный итог';

  @override
  String get accountTotalPaid => 'Оплачено';

  @override
  String get accountTotalRefunded => 'Возвращено';

  @override
  String get accountTotalDue => 'К оплате';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Счет $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Отгрузка $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'Не удалось загрузить детали счета';

  @override
  String get accountInvoiceStatus => 'Статус счета';

  @override
  String get accountInvoiceDate => 'Дата счета';

  @override
  String get accountOrderId => 'ID заказа';

  @override
  String get accountOrderDate => 'Дата заказа';

  @override
  String get accountOrderStatus => 'Статус заказа';

  @override
  String get accountChannel => 'Канал';

  @override
  String get accountDefault => 'По умолчанию';

  @override
  String get accountStatusPaid => 'Оплачено';

  @override
  String get accountStatusPending => 'В ожидании';

  @override
  String get accountStatusPendingPayment => 'Ожидается оплата';

  @override
  String get accountStatusOverdue => 'Просрочено';

  @override
  String get accountStatusRefunded => 'Возвращено';

  @override
  String get accountShippedQty => 'Отправлено';

  @override
  String get accountInvoicedQty => 'Выставлено';

  @override
  String get accountUnitPriceWithColon => 'Цена за единицу:';

  @override
  String get accountSubTotalWithColon => 'Промежуточный итог:';

  @override
  String get accountDownloadInvoice => 'Скачать счет';

  @override
  String get accountInvoice => 'Счет';

  @override
  String get accountRecentOrders => 'Последние заказы';

  @override
  String get accountNoRecentOrders => 'Нет последних заказов';

  @override
  String get accountStatusProcessing => 'Обработка';

  @override
  String get accountStatusCompleted => 'Завершено';

  @override
  String get accountStatusCancelled => 'Отменено';

  @override
  String get accountStatusClosed => 'Закрыто';

  @override
  String get accountStatusUnknown => 'Неизвестно';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Товары в списке желаний ($count)';
  }

  @override
  String get accountNoWishlistItems => 'Нет товаров в списке желаний';

  @override
  String get accountDefaultAddresses => 'Адреса по умолчанию';

  @override
  String get accountNoProductReviewsYet => 'Пока нет отзывов о товарах';

  @override
  String get searchFailedTitle => 'Поиск не удался';

  @override
  String get searchHint => 'Поиск товаров';

  @override
  String get searchImageSearch => 'Поиск по изображению';

  @override
  String get searchRecentSearches => 'Недавние поиски';

  @override
  String get searchClearAll => 'Очистить все';

  @override
  String get searchTopCategories => 'Популярные категории';

  @override
  String searchResultsFound(int count) {
    return 'Найдено результатов: $count';
  }

  @override
  String searchDiscountOff(Object percent) {
    return 'Скидка $percent%';
  }

  @override
  String get searchNoProductsFound => 'Товары не найдены';

  @override
  String get searchTryDifferentTerm => 'Попробуйте другой поисковый запрос';

  @override
  String get searchSpeechNotAvailable => 'Распознавание речи недоступно';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'Не удалось начать голосовой ввод: $error';
  }

  @override
  String get searchMicrophonePermissionDenied => 'Доступ к микрофону запрещен';

  @override
  String get searchRetake => 'Переснять';

  @override
  String get searchSearch => 'Поиск';

  @override
  String get searchTryAgain => 'Попробовать снова';

  @override
  String get searchRecognizedObjects => 'Распознанные объекты';

  @override
  String get searchResult => 'Результат:';

  @override
  String get searchFailedToCaptureImage => 'Не удалось сделать снимок';

  @override
  String searchProcessing(int progress) {
    return 'Обработка... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Открытие камеры...';

  @override
  String get searchFailedToProcessImage => 'Не удалось обработать изображение';

  @override
  String get homeRecentlyViewedProducts => 'Недавно просмотренные товары';

  @override
  String accountItemsCount(int count) {
    return '$count товар(ов)';
  }

  @override
  String get accountTrack => 'Отследить';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Отслеживание $trackNumber через $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Неизвестный перевозчик';

  @override
  String get accountTrackingNumber => 'Номер отслеживания';

  @override
  String accountSkuValue(Object sku) {
    return 'Артикул : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Отправлено : $qty';
  }
}
