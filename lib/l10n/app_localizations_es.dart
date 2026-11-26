// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tienda Bagisto';

  @override
  String get homeFailedToLoad => 'No se pudo cargar la página de inicio';

  @override
  String get commonUnknownError => 'Error desconocido';

  @override
  String get commonRetry => 'Reintentar';

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
  String get homeFeaturedProducts => 'Productos destacados';

  @override
  String get homeDefaultProducts => 'Productos';

  @override
  String get homeBackToTop => 'Volver arriba';

  @override
  String get homeViewCart => 'VER CARRITO';

  @override
  String homeAddedToCartMessage(Object productName) {
    return '$productName agregado al carrito';
  }

  @override
  String get homeLoginToManageWishlist =>
      'Inicia sesión para administrar la lista de deseos';

  @override
  String get homeAddedToWishlist => 'Añadido a la lista de deseos';

  @override
  String get homeRemovedFromWishlist => 'Eliminado de la lista de deseos';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get homeCollections => 'Colecciones';

  @override
  String homeCategorySemanticLabel(Object categoryName) {
    return 'Categoría $categoryName';
  }

  @override
  String homeDiscountOff(Object percent) {
    return '$percent% de descuento';
  }

  @override
  String get productFailedToLoad => 'No se pudo cargar el producto';

  @override
  String get productNotFound => 'Producto no encontrado';

  @override
  String get productDetail => 'Detalle del producto';

  @override
  String get productDetails => 'Descripción';

  @override
  String get productShowLess => 'Mostrar menos';

  @override
  String get productLoadMore => 'Cargar más';

  @override
  String get productMoreInformations => 'Más información';

  @override
  String get productSku => 'SKU';

  @override
  String get productType => 'Tipo';

  @override
  String get productBrand => 'Marca';

  @override
  String get productColor => 'Color';

  @override
  String get productSize => 'Talla';

  @override
  String get productReviews => 'Reseñas';

  @override
  String get productNoReviewsYet => 'Aún no hay reseñas';

  @override
  String productRating(Object count) {
    return '$count calificación';
  }

  @override
  String productReviewsCount(Object count) {
    return '$count reseñas';
  }

  @override
  String productPostedOn(Object day, Object month, Object year) {
    return 'Publicado el $day $month $year';
  }

  @override
  String get productReviewSubmitted => '¡Tu reseña ha sido enviada!';

  @override
  String get productWriteReview => 'Escribir una reseña';

  @override
  String get productPleaseLoginForReviews =>
      'Inicia sesión para ver tus reseñas';

  @override
  String get productLoadMoreReviews => 'Cargar más reseñas';

  @override
  String get productRelatedProduct => 'Productos relacionados';

  @override
  String get productUpsellRecommendation =>
      '¡Encontramos otros productos que podrían gustarte!';

  @override
  String productDiscountOff(Object percent) {
    return '$percent% de descuento';
  }

  @override
  String get productVeryGood => 'Muy bueno';

  @override
  String get productGood => 'Bueno';

  @override
  String get productAverage => 'Regular';

  @override
  String get productBad => 'Malo';

  @override
  String get productVeryBad => 'Muy malo';

  @override
  String get productInStock => 'En stock';

  @override
  String get productOutOfStock => 'Agotado';

  @override
  String get productQuantity => 'Cantidad';

  @override
  String get productWishlistAction => 'Lista de deseos';

  @override
  String get productCompareAction => 'Comparar';

  @override
  String get productShareAction => 'Compartir';

  @override
  String get productLoginToCompare => 'Inicia sesión para agregar a comparar';

  @override
  String get productAddedToCompare => 'Añadido a comparar';

  @override
  String get productAddToCart => 'Agregar al carrito';

  @override
  String get accountMoveToCart => 'Mover al carrito';

  @override
  String get productBuyNow => 'Comprar ahora';

  @override
  String get productSelectOptionsFirst =>
      'Selecciona primero las opciones del producto';

  @override
  String get productBookingBookTable => 'Reservar una mesa *';

  @override
  String get productBookingSelectDateRequired => 'Seleccionar fecha *';

  @override
  String get productBookingSelectSlotRequired => 'Seleccionar franja horaria *';

  @override
  String get productBookingSpecialRequestNotesRequired =>
      'Solicitudes especiales/Notas *';

  @override
  String get productBookingBookAppointment => 'Reservar una cita *';

  @override
  String get productBookingDateFormatHint => 'AAAA-MM-DD';

  @override
  String get productBookingFrom => 'Desde';

  @override
  String get productBookingTo => 'Hasta';

  @override
  String get productBookingSelectDate => 'Seleccionar fecha';

  @override
  String get productBookingLocation => 'Ubicación';

  @override
  String get productBookingSlotDuration => 'Duración de la franja';

  @override
  String get productBookingAvailability => 'Disponibilidad';

  @override
  String get productBookingStartDate => 'Fecha de inicio';

  @override
  String get productBookingEndDate => 'Fecha de fin';

  @override
  String get productBookingDate => 'Fecha';

  @override
  String get productBookingViewOnMap => 'Ver en el mapa';

  @override
  String get productBookingEventOn => 'Evento el:';

  @override
  String get productBookingBookYourTicket => 'Reserva tu entrada';

  @override
  String get productBookingSlotDurationLabel => 'Duración de la franja:';

  @override
  String productBookingDurationMinutes(int count) {
    return '$count minutos';
  }

  @override
  String get productBookingAvailableFrom => 'Disponible desde';

  @override
  String get productBookingAvailableTo => 'Disponible hasta';

  @override
  String get productBookingSpecialRequestNotesHint =>
      'Solicitudes especiales/Notas';

  @override
  String get productBookingChooseRentOption => 'Elegir opción de alquiler *';

  @override
  String get productBookingDailyBasis => 'Por día';

  @override
  String get productBookingHourlyBasis => 'Por hora';

  @override
  String get productBookingNoDatesAvailable =>
      'No hay fechas disponibles para reservar';

  @override
  String get productBookingSelectSlot => 'Seleccionar franja horaria';

  @override
  String get productBookingSelectDateFirst => 'Selecciona primero una fecha';

  @override
  String get productBookingChooseDateFirstToSeeSlots =>
      'Selecciona primero una fecha para ver las franjas horarias disponibles.';

  @override
  String get productBookingLoadingSlots => 'Cargando franjas horarias...';

  @override
  String get productBookingSlotsLoadingForSelectedDate =>
      'Se están cargando las franjas horarias disponibles para la fecha seleccionada.';

  @override
  String get productBookingUnableToLoadSlots =>
      'No se pudieron cargar las franjas horarias';

  @override
  String get productBookingNoSlotsAvailable =>
      'No hay franjas horarias disponibles';

  @override
  String get productBookingNoSlotsAvailableForSelectedDate =>
      'No hay franjas horarias disponibles para la fecha seleccionada.';

  @override
  String get productBookingSelectOneSlotToContinue =>
      'Selecciona una franja horaria disponible para continuar.';

  @override
  String get productBookingSpecialRequestNotesLowercase =>
      'Solicitudes especiales/Notas';

  @override
  String get productDownloadableLinks => 'Enlaces';

  @override
  String get productDownloadableSamples => 'Muestras';

  @override
  String get productDownloadSample => 'Descargar muestra';

  @override
  String get productDefaultName => 'Producto';

  @override
  String get categoryDefaultName => 'Categorías';

  @override
  String get categorySubCategories => 'Subcategorías';

  @override
  String get categorySomethingWentWrong => 'Algo salió mal';

  @override
  String get categoryUnknownError => 'Error desconocido';

  @override
  String categoryItemsFound(Object count) {
    return '$count artículos encontrados';
  }

  @override
  String get categoryNoProductsFound => 'No se encontraron productos';

  @override
  String get categoryNoCategoriesFound => 'No se encontraron categorías';

  @override
  String get categorySort => 'Ordenar';

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
  String get categoryFilter => 'Filtrar';

  @override
  String get categoryFilters => 'Filtros';

  @override
  String get categoryNoFiltersAvailable => 'No hay filtros disponibles';

  @override
  String get categoryFiltersWillAppear =>
      'Los filtros aparecerán cuando estén disponibles para esta categoría';

  @override
  String get categoryApplyFilters => 'Aplicar filtros';

  @override
  String categoryApplyFiltersCount(int count) {
    return 'Aplicar filtros ($count)';
  }

  @override
  String get categoryClearAll => 'Borrar todo';

  @override
  String get categoryTryAdjustingFilters =>
      'Intenta ajustar tus filtros o criterios de búsqueda';

  @override
  String get categoryError => 'Error';

  @override
  String get categoryLoginToManageWishlist =>
      'Inicia sesión para administrar la lista de deseos';

  @override
  String get categoryAddedToWishlist => 'Añadido a la lista de deseos';

  @override
  String get categoryRemovedFromWishlist => 'Eliminado de la lista de deseos';

  @override
  String categoryFailedToUpdateWishlist(Object error) {
    return 'No se pudo actualizar la lista de deseos: $error';
  }

  @override
  String get wishlistItemRemoved => 'Item removed from wishlist';

  @override
  String get cart => 'Carrito';

  @override
  String get cartPleaseLoginWishlist =>
      'Inicia sesión para ver la lista de deseos';

  @override
  String cartItemsInCart(int count, Object itemText) {
    return '$count $itemText en el carrito';
  }

  @override
  String get cartYourCartEmpty => 'Tu carrito está vacío';

  @override
  String get cartAddProductsHere =>
      'Agrega productos a tu carrito para verlos aquí';

  @override
  String get cartContinueShopping => 'Seguir comprando';

  @override
  String get cartUnit => 'Unidad';

  @override
  String get cartUnits => 'Unidades';

  @override
  String get cartPleaseLoginWishlistAdd =>
      'Inicia sesión para agregar a la lista de deseos';

  @override
  String get cartMovedToWishlist => 'Movido a la lista de deseos';

  @override
  String cartFailedMoveWishlist(Object error) {
    return 'Error al mover a la lista de deseos: $error';
  }

  @override
  String get cartAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get productSelectDownloadLink => 'Please select at least one link';

  @override
  String get cartViewMore => 'Ver más';

  @override
  String get cartViewLess => 'Ver menos';

  @override
  String get cartEmptyCartAction => 'Vaciar carrito';

  @override
  String get cartApplyCoupon => 'Aplicar cupón';

  @override
  String get cartCouponCode => 'Código de cupón';

  @override
  String get cartCouponNotFound => 'Coupon not found';

  @override
  String get cartApply => 'Aplicar';

  @override
  String get cartAppliedCoupon => 'Cupón aplicado';

  @override
  String get cartRemove => 'Eliminar';

  @override
  String get cartPriceBreak => 'Desglose de precios';

  @override
  String get cartSubTotal => 'Subtotal';

  @override
  String get cartDiscount => 'Descuento';

  @override
  String get cartDeliveryCharges => 'Gastos de envío';

  @override
  String get cartTax => 'Impuesto';

  @override
  String get cartTaxIncluded => '(included)';

  @override
  String cartExclTax(String amount) {
    return 'Excl. Tax: $amount';
  }

  @override
  String get cartGrandTotal => 'Total general';

  @override
  String get cartAmountToBePaid => 'Importe a pagar';

  @override
  String get cartPayNow => 'Pagar ahora';

  @override
  String get cartRemoveItem => 'Eliminar artículo';

  @override
  String cartRemoveItemConfirm(Object productName) {
    return '¿Seguro que deseas eliminar \"$productName\" de tu carrito?';
  }

  @override
  String get cartCancel => 'Cancelar';

  @override
  String get cartEmptyCartTitle => 'Vaciar carrito';

  @override
  String get cartEmptyCartConfirm =>
      '¿Seguro que deseas eliminar todos los artículos de tu carrito?';

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
  String get checkout => 'Pago';

  @override
  String get checkoutBillingTo => 'Facturar a';

  @override
  String get checkoutDeliveredTo => 'Entregado a';

  @override
  String get checkoutChange => 'Cambiar';

  @override
  String get checkoutSelectBillingAddress =>
      'Seleccionar dirección de facturación';

  @override
  String get checkoutSelectShippingAddress => 'Seleccionar dirección de envío';

  @override
  String get checkoutBillingAddress => 'Dirección de facturación';

  @override
  String get checkoutEnterAddress => 'Ingresar dirección';

  @override
  String get checkoutFirstName => 'Nombre';

  @override
  String get checkoutLastName => 'Apellido';

  @override
  String get checkoutEmail => 'Correo electrónico';

  @override
  String get checkoutPhone => 'Teléfono';

  @override
  String get checkoutStreetAddress => 'Dirección';

  @override
  String get checkoutCountry => 'País';

  @override
  String get checkoutState => 'Estado';

  @override
  String get checkoutCity => 'Ciudad';

  @override
  String get checkoutPostcode => 'Código postal';

  @override
  String get checkoutCompanyOptional => 'Empresa (opcional)';

  @override
  String get checkoutUseSameAddressShipping =>
      '¿Usar la misma dirección para el envío?';

  @override
  String checkoutPhoneValue(Object phone) {
    return 'Teléfono: $phone';
  }

  @override
  String get checkoutAddressTypeOffice => 'Oficina';

  @override
  String get checkoutAddressTypeHome => 'Casa';

  @override
  String get checkoutAddressTypeBilling => 'Facturación';

  @override
  String get checkoutAddressTypeShipping => 'Envío';

  @override
  String get checkoutAddressTypeDefault => 'Predeterminado';

  @override
  String checkoutFieldRequired(Object field) {
    return '$field es obligatorio';
  }

  @override
  String get checkoutSaveContinue => 'Guardar y continuar';

  @override
  String get checkoutYourCartEmpty => 'Tu carrito está vacío';

  @override
  String get checkoutSelectCountry => 'Seleccionar país';

  @override
  String get checkoutSelectState => 'Seleccionar estado';

  @override
  String get checkoutCountryRequired => 'El país es obligatorio';

  @override
  String get checkoutStateRequired => 'El estado es obligatorio';

  @override
  String get checkoutSelectCountryFirst => 'Selecciona primero un país';

  @override
  String get checkoutShippingMethod => 'Método de envío';

  @override
  String get checkoutSaveAddressSeeShipping =>
      'Guarda tu dirección para ver las opciones de envío';

  @override
  String get checkoutPaymentMethod => 'Método de pago';

  @override
  String get checkoutSelectShippingMethodFirst =>
      'Selecciona primero un método de envío';

  @override
  String get checkoutEnterCouponCode => 'Ingresa tu código de cupón';

  @override
  String get checkoutDiscountCoupon => 'Descuento (cupón)';

  @override
  String get checkoutPlaceOrder => 'Realizar pedido';

  @override
  String get thankYouTitle => '¡Gracias por tu pedido!';

  @override
  String get thankYouSubtitle =>
      'Te enviaremos por correo electrónico los detalles y la información de seguimiento de tu pedido';

  @override
  String thankYouOrderNumber(Object orderNumber) {
    return 'Tu pedido n.º $orderNumber';
  }

  @override
  String get thankYouViewOrder => 'Ver pedido';

  @override
  String get thankYouContinueShopping => 'Seguir comprando';

  @override
  String get accountPleaseTryAgainLater =>
      'Por favor, inténtalo de nuevo más tarde';

  @override
  String get accountUserFallback => 'Usuario';

  @override
  String get accountBack => 'Atrás';

  @override
  String get accountSettings => 'Configuración';

  @override
  String get accountMyOrders => 'Mis pedidos';

  @override
  String get accountMyDownloadableProducts => 'Mis productos descargables';

  @override
  String get accountWishlist => 'Lista de deseos';

  @override
  String get accountCompareProducts => 'Comparar productos';

  @override
  String get accountProductReview => 'Reseña de producto';

  @override
  String get accountAddressBook => 'Libreta de direcciones';

  @override
  String get accountEditAccount => 'Editar cuenta';

  @override
  String get accountLogout => 'Cerrar sesión';

  @override
  String get accountLogoutConfirmation => '¿Seguro que deseas cerrar sesión?';

  @override
  String get accountNoCountriesAvailable =>
      'No hay países disponibles. Inténtalo de nuevo.';

  @override
  String get accountPleaseSelectCountry => 'Selecciona un país';

  @override
  String get accountPleaseSelectOrEnterState =>
      'Selecciona o ingresa un estado';

  @override
  String get accountAddressUpdatedSuccessfully =>
      'Dirección actualizada correctamente';

  @override
  String get accountAddressAddedSuccessfully =>
      'Dirección agregada correctamente';

  @override
  String get accountGoBack => 'Volver';

  @override
  String get accountEditAddress => 'Editar dirección';

  @override
  String get accountAddNewAddress => 'Agregar nueva dirección';

  @override
  String get accountFirstNameRequired => 'El nombre es obligatorio';

  @override
  String get accountLastNameRequired => 'El apellido es obligatorio';

  @override
  String get accountEnterValidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get accountCompanyName => 'Nombre de la empresa';

  @override
  String get accountVatId => 'ID de IVA';

  @override
  String get accountStreetAddressRequired => 'La dirección es obligatoria';

  @override
  String get accountCityRequired => 'La ciudad es obligatoria';

  @override
  String get accountZipPostcode => 'Código postal';

  @override
  String get accountZipPostcodeRequired => 'El código postal es obligatorio';

  @override
  String get accountTelephone => 'Teléfono';

  @override
  String get accountPhoneNumberRequired =>
      'El número de teléfono es obligatorio';

  @override
  String get accountChangeDefaultBillingAddress =>
      'Cambiar dirección de facturación predeterminada';

  @override
  String get accountChangeDefaultShippingAddress =>
      'Cambiar dirección de envío predeterminada';

  @override
  String get accountUpdateAddress => 'Actualizar dirección';

  @override
  String get accountSaveToAddressBook => 'Guardar en la libreta de direcciones';

  @override
  String get accountPleaseLoginToWriteReview =>
      'Inicia sesión para escribir una reseña';

  @override
  String get accountPleaseSelectRating => 'Selecciona una calificación';

  @override
  String get accountAddReview => 'Agregar reseña';

  @override
  String get accountReviewSubmitted => '¡Reseña enviada!';

  @override
  String get accountNickName => 'Nombre';

  @override
  String get accountEnterYourName => 'Ingresa tu nombre';

  @override
  String get accountNameRequired => 'El nombre es obligatorio';

  @override
  String get accountSummary => 'Título';

  @override
  String get accountReviewSummaryHint => 'Título';

  @override
  String get accountSummaryRequired => 'El título es obligatorio';

  @override
  String get accountReview => 'Comentario';

  @override
  String get accountDetailedReviewHint => 'Comentario';

  @override
  String get accountReviewRequired => 'El comentario es obligatorio';

  @override
  String get accountRating => 'Calificación';

  @override
  String get accountSubmitReview => 'Enviar reseña';

  @override
  String get accountReviewAttachmentsLabel => 'Añadir imagen/vídeo';

  @override
  String get accountReviewAddMedia => 'Añadir';

  @override
  String get accountReviewTakePhoto => 'Tomar foto';

  @override
  String get accountReviewChooseFromGallery => 'Elegir de la galería';

  @override
  String get accountReviewChooseVideo => 'Elegir video';

  @override
  String get accountReviewRemoveAttachment => 'Quitar archivo adjunto';

  @override
  String get accountReviewAttachmentLimitReached =>
      'Puedes adjuntar hasta 5 archivos';

  @override
  String get accountReviewAttachmentTooLarge =>
      'El archivo es demasiado grande (máx. 5 MB)';

  @override
  String get accountCouldNotLoadAddresses =>
      'No se pudieron cargar las direcciones';

  @override
  String get accountPleaseTryAgain => 'Por favor, inténtalo de nuevo';

  @override
  String get accountNoAddressesSaved => 'No hay direcciones guardadas';

  @override
  String get accountAddAddressToGetStarted =>
      'Agrega una nueva dirección para comenzar';

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
  String get accountNoProductsToCompare => 'No hay productos para comparar';

  @override
  String get accountAddProductsToCompareHint =>
      'Agrega productos para comparar desde la página de detalle del producto.';

  @override
  String get accountProducts => 'Productos';

  @override
  String get accountDescription => 'Descripción';

  @override
  String get accountShortDescription => 'Descripción corta';

  @override
  String get accountActivity => 'Actividad';

  @override
  String get accountStore => 'Tienda';

  @override
  String get accountNotAvailable => 'N/D';

  @override
  String get accountMessageSentSuccessfully =>
      '¡Mensaje enviado correctamente!';

  @override
  String get accountAnErrorOccurred => 'Ocurrió un error';

  @override
  String get accountContactUs => 'Contáctanos';

  @override
  String get accountName => 'Nombre';

  @override
  String get accountEnterYourEmail => 'Ingresa tu correo electrónico';

  @override
  String get accountContact => 'Contacto';

  @override
  String get accountEnterYourPhoneNumber => 'Ingresa tu número de teléfono';

  @override
  String get accountMessage => 'Mensaje';

  @override
  String get accountEnterYourMessage => 'Ingresa tu mensaje';

  @override
  String get accountSendMessage => 'Enviar mensaje';

  @override
  String get accountNameFieldEmpty => 'El campo nombre no puede estar vacío';

  @override
  String get accountNameMinChars =>
      'El nombre debe tener al menos 2 caracteres';

  @override
  String get accountEmailFieldEmpty =>
      'El campo correo electrónico no puede estar vacío';

  @override
  String get accountPleaseEnterValidEmailAddress =>
      'Ingresa una dirección de correo electrónico válida';

  @override
  String get accountContactNumberEmpty =>
      'El número de contacto no puede estar vacío';

  @override
  String get accountPleaseEnterValidContactNumber =>
      'Ingresa un número de contacto válido';

  @override
  String get accountMessageFieldEmpty =>
      'El campo mensaje no puede estar vacío';

  @override
  String get accountMessageMinChars =>
      'El mensaje debe tener al menos 10 caracteres';

  @override
  String get accountDownloadableProducts => 'Productos descargables';

  @override
  String get accountNoDownloadsYet => 'Aún no hay descargas';

  @override
  String get accountDownloadsEmptyDescription =>
      'Tus productos descargados aparecerán aquí.';

  @override
  String accountProductsProgress(int current, int total) {
    return '$current / $total productos';
  }

  @override
  String accountRemainingDownloadsLeft(Object value) {
    return 'Quedan $value';
  }

  @override
  String get accountDownload => 'Descargar';

  @override
  String accountFileName(Object fileName) {
    return 'Archivo: $fileName';
  }

  @override
  String get accountDownloadWillStartShortly =>
      'Tu descarga comenzará en breve. Revisa tu carpeta de descargas.';

  @override
  String get accountClose => 'Cerrar';

  @override
  String get accountOrders => 'Pedidos';

  @override
  String get accountNoOrdersYet => 'Aún no hay pedidos';

  @override
  String get accountOrdersEmptyDescription =>
      'Tus pedidos aparecerán aquí una vez que realices una compra.';

  @override
  String get accountOrderSingular => 'Pedido';

  @override
  String get accountOrderPlural => 'Pedidos';

  @override
  String accountOrderTotalItems(Object total, int count) {
    return '$total (Artículos $count)';
  }

  @override
  String get accountOrderAndReturn => 'Pedido y devolución';

  @override
  String get accountTrackOrder => 'Rastrear pedido';

  @override
  String get accountReturnPolicy => 'Política de devoluciones';

  @override
  String get accountReturnRequest => 'Solicitud de devolución';

  @override
  String get accountNotifications => 'Notificaciones';

  @override
  String get accountPrivacy => 'Privacidad';

  @override
  String get accountAccount => 'Cuenta';

  @override
  String get accountPreferences => 'Preferencias';

  @override
  String get accountLanguage => 'Idioma';

  @override
  String get accountNoLanguagesAvailable => 'No hay idiomas disponibles';

  @override
  String get accountCurrency => 'Moneda';

  @override
  String get accountOthers => 'Otros';

  @override
  String get accountNoPagesAvailable => 'No hay páginas disponibles';

  @override
  String get accountProductReviews => 'Reseñas de productos';

  @override
  String get accountMyReviews => 'Mis reseñas';

  @override
  String get accountNoReviewsYet => 'Aún no hay reseñas';

  @override
  String get accountReviewsEmptyDescription =>
      'Tus reseñas de productos aparecerán aquí.';

  @override
  String get accountReviewSingular => 'Reseña';

  @override
  String get accountReviewPlural => 'Reseñas';

  @override
  String accountPostedOn(Object date) {
    return 'Publicado el $date';
  }

  @override
  String get accountCloseSettings => 'Cerrar configuración';

  @override
  String get accountChangeTheme => 'Cambiar tema';

  @override
  String get accountAllNotifications => 'Todas las notificaciones';

  @override
  String get accountOffers => 'Ofertas';

  @override
  String get accountOfflineData => 'Datos sin conexión';

  @override
  String get accountTrackRecentlyViewedProducts =>
      'Rastrear y mostrar productos vistos recientemente';

  @override
  String get accountShowSearchTag => 'Mostrar etiqueta de búsqueda';

  @override
  String get accountTryAgain => 'Reintentar';

  @override
  String get accountYourWishlistEmpty => 'Tu lista de deseos está vacía';

  @override
  String get accountWishlistEmptyDescription =>
      'Explora productos y agrégalos a tu lista de deseos';

  @override
  String get accountItemSingular => 'Artículo';

  @override
  String get accountItemPlural => 'Artículos';

  @override
  String accountStartingAt(Object price) {
    return 'Desde $price';
  }

  @override
  String get accountAboutThisPage => 'Acerca de esta página';

  @override
  String accountPageId(Object id) {
    return 'ID de página: $id';
  }

  @override
  String get mainTabHome => 'Inicio';

  @override
  String get mainTabCategories => 'Categorías';

  @override
  String get mainTabCart => 'Carrito';

  @override
  String get mainTabAccount => 'Cuenta';

  @override
  String get authLoginSuccess => '¡Bienvenido! Inicio de sesión correcto.';

  @override
  String get authWelcomeBack => '¡Qué gusto verte de nuevo!';

  @override
  String get authLoginToAccount => 'Inicia sesión en tu cuenta';

  @override
  String get authEmailAddress => 'Correo electrónico';

  @override
  String get authEnterYourEmail => 'Ingresa tu correo electrónico';

  @override
  String get authPleaseEnterEmail => 'Ingresa tu correo electrónico';

  @override
  String get authPleaseEnterValidEmail =>
      'Ingresa un correo electrónico válido';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authEnterYourPassword => 'Ingresa tu contraseña';

  @override
  String get authPleaseEnterPassword => 'Ingresa tu contraseña';

  @override
  String get authPasswordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authForgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get authLogin => 'Iniciar sesión';

  @override
  String get authNoAccountPrompt => '¿No tienes una cuenta? ';

  @override
  String get authSignUp => 'Registrarse';

  @override
  String get authAccountCreatedSuccess => '¡Cuenta creada correctamente!';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authSignupGetStarted => 'Regístrate para comenzar';

  @override
  String get authFirstNameHint => 'Nombre';

  @override
  String get authLastNameHint => 'Apellido';

  @override
  String get authRequired => 'Obligatorio';

  @override
  String get authCreatePasswordHint => 'Crea una contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authConfirmPasswordHint => 'Confirma tu contraseña';

  @override
  String get authPleaseConfirmPassword => 'Confirma tu contraseña';

  @override
  String get authPasswordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get authAlreadyHaveAccountPrompt => '¿Ya tienes una cuenta? ';

  @override
  String get authForgotPasswordSubtitle =>
      'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get authSendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get authBackToLogin => 'Volver al inicio de sesión';

  @override
  String get authNiceToSeeYouHere => 'Qué bueno verte aquí';

  @override
  String get accountEditTitle => 'Editar cuenta';

  @override
  String get accountFirstNameRequiredLabel => 'Nombre *';

  @override
  String get accountLastNameRequiredLabel => 'Apellido *';

  @override
  String get accountChangeEmail => 'Cambiar correo electrónico';

  @override
  String get accountChangePassword => 'Cambiar contraseña';

  @override
  String get accountDeleteAccount => 'Eliminar cuenta';

  @override
  String get accountGender => 'Género';

  @override
  String get accountSelectGender => 'Seleccionar género';

  @override
  String get accountDob => 'Fecha de nacimiento';

  @override
  String get monthJanShort => 'Ene';

  @override
  String get monthFebShort => 'Feb';

  @override
  String get monthMarShort => 'Mar';

  @override
  String get monthAprShort => 'Abr';

  @override
  String get monthMayShort => 'May';

  @override
  String get monthJunShort => 'Jun';

  @override
  String get monthJulShort => 'Jul';

  @override
  String get monthAugShort => 'Ago';

  @override
  String get monthSepShort => 'Sep';

  @override
  String get monthOctShort => 'Oct';

  @override
  String get monthNovShort => 'Nov';

  @override
  String get monthDecShort => 'Dic';

  @override
  String get accountSubscribeNewsletters => 'Suscribirse a boletines';

  @override
  String get accountSaveProfile => 'Guardar perfil';

  @override
  String get accountNewEmail => 'Nuevo correo electrónico';

  @override
  String get accountEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get accountCurrentPassword => 'Contraseña actual';

  @override
  String get accountPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get accountChange => 'Cambiar';

  @override
  String get accountCurrentPasswordRequired =>
      'La contraseña actual es obligatoria';

  @override
  String get accountNewPassword => 'Nueva contraseña';

  @override
  String get accountConfirmPassword => 'Confirmar contraseña';

  @override
  String get accountDeleteWarning =>
      'Esta acción es permanente y no se puede deshacer. Todos tus datos serán eliminados.';

  @override
  String get accountEnterYourPassword => 'Ingresa tu contraseña';

  @override
  String get accountDelete => 'Eliminar';

  @override
  String get accountDeleteAddress => 'Delete Address';

  @override
  String get accountDeleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get accountGenderMale => 'Masculino';

  @override
  String get accountGenderFemale => 'Femenino';

  @override
  String get accountGenderOther => 'Otro';

  @override
  String accountOrdersWithNumber(Object number) {
    return 'Pedidos $number';
  }

  @override
  String get accountReorderSuccessful => 'Pedido repetido con éxito';

  @override
  String accountReorderItemsAdded(Object message, int count) {
    return '$message \n\nSe agregaron $count artículos a tu carrito.';
  }

  @override
  String get accountOk => 'OK';

  @override
  String get accountGoToCart => 'Ir al carrito';

  @override
  String get accountFailedToLoadOrderDetails =>
      'No se pudieron cargar los detalles del pedido';

  @override
  String get accountDetails => 'Detalles';

  @override
  String get accountInvoices => 'Facturas';

  @override
  String get accountShipments => 'Envíos';

  @override
  String get accountRefunds => 'Reembolsos';

  @override
  String get accountRefundSubtotal => 'Subtotal';

  @override
  String get accountRefundedQty => 'Cant. reembolsada';

  @override
  String get accountShippingAndHandling => 'Envío y manipulación';

  @override
  String get accountAdjustmentRefund => 'Adjustment Refund';

  @override
  String get accountAdjustmentFee => 'Adjustment Fee';

  @override
  String accountPlacedOn(Object date) {
    return 'Realizado el $date';
  }

  @override
  String accountItemsOrdered(int count) {
    return '$count artículo(s) pedidos';
  }

  @override
  String get accountBillingAddress => 'Dirección de facturación';

  @override
  String get accountShippingAddress => 'Dirección de envío';

  @override
  String get accountShippingMethod => 'Método de envío';

  @override
  String get accountPaymentMethod => 'Método de pago';

  @override
  String get accountNoInvoicesForOrder => 'No hay facturas para este pedido';

  @override
  String accountInvoicedCount(int count) {
    return '$count facturado(s)';
  }

  @override
  String get accountNoShipmentsForOrder => 'No hay envíos para este pedido';

  @override
  String get accountReorder => 'Volver a pedir';

  @override
  String get accountMoreInfo => 'Más información';

  @override
  String get accountOrderedQty => 'Cant. pedida';

  @override
  String get accountShipped => 'Enviado';

  @override
  String get accountInvoiced => 'Facturado';

  @override
  String get accountUnitPrice => 'Precio unitario';

  @override
  String get accountSubTotalWithSpace => 'Subtotal';

  @override
  String get accountTotalPaid => 'Total pagado';

  @override
  String get accountTotalRefunded => 'Total reembolsado';

  @override
  String get accountTotalDue => 'Total adeudado';

  @override
  String accountInvoiceNumber(Object number) {
    return 'Factura $number';
  }

  @override
  String accountShipmentNumber(Object number) {
    return 'Envío $number';
  }

  @override
  String get accountFailedToLoadInvoiceDetails =>
      'No se pudieron cargar los detalles de la factura';

  @override
  String get accountInvoiceStatus => 'Estado de la factura';

  @override
  String get accountInvoiceDate => 'Fecha de la factura';

  @override
  String get accountOrderId => 'ID del pedido';

  @override
  String get accountOrderDate => 'Fecha del pedido';

  @override
  String get accountOrderStatus => 'Estado del pedido';

  @override
  String get accountChannel => 'Canal';

  @override
  String get accountDefault => 'Predeterminado';

  @override
  String get accountStatusPaid => 'Pagado';

  @override
  String get accountStatusPending => 'Pendiente';

  @override
  String get accountStatusPendingPayment => 'Pago pendiente';

  @override
  String get accountStatusOverdue => 'Vencido';

  @override
  String get accountStatusRefunded => 'Reembolsado';

  @override
  String get accountShippedQty => 'Cant. enviada';

  @override
  String get accountInvoicedQty => 'Cant. facturada';

  @override
  String get accountUnitPriceWithColon => 'Precio unitario:';

  @override
  String get accountSubTotalWithColon => 'Subtotal:';

  @override
  String get accountDownloadInvoice => 'Descargar factura';

  @override
  String get accountInvoice => 'Factura';

  @override
  String get accountRecentOrders => 'Pedidos recientes';

  @override
  String get accountNoRecentOrders => 'No hay pedidos recientes';

  @override
  String get accountStatusProcessing => 'Procesando';

  @override
  String get accountStatusCompleted => 'Completado';

  @override
  String get accountStatusCancelled => 'Cancelado';

  @override
  String get accountStatusClosed => 'Cerrado';

  @override
  String get accountStatusUnknown => 'Desconocido';

  @override
  String accountWishlistItemsCount(int count) {
    return 'Artículos de la lista de deseos ($count)';
  }

  @override
  String get accountNoWishlistItems => 'No hay artículos en la lista de deseos';

  @override
  String get accountDefaultAddresses => 'Direcciones predeterminadas';

  @override
  String get accountNoProductReviewsYet => 'Aún no hay reseñas de productos';

  @override
  String get searchFailedTitle => 'Búsqueda fallida';

  @override
  String get searchHint => 'Buscar productos';

  @override
  String get searchImageSearch => 'Búsqueda por imagen';

  @override
  String get searchRecentSearches => 'Búsquedas recientes';

  @override
  String get searchClearAll => 'Borrar todo';

  @override
  String get searchTopCategories => 'Categorías principales';

  @override
  String searchResultsFound(int count) {
    return '$count resultados encontrados';
  }

  @override
  String searchDiscountOff(Object percent) {
    return '$percent% de descuento';
  }

  @override
  String get searchNoProductsFound => 'No se encontraron productos';

  @override
  String get searchTryDifferentTerm =>
      'Intenta buscar con un término diferente';

  @override
  String get searchSpeechNotAvailable =>
      'El reconocimiento de voz no está disponible';

  @override
  String searchFailedToStartVoice(Object error) {
    return 'No se pudo iniciar la entrada por voz: $error';
  }

  @override
  String get searchMicrophonePermissionDenied =>
      'Permiso de micrófono denegado';

  @override
  String get searchRetake => 'Volver a tomar';

  @override
  String get searchSearch => 'Buscar';

  @override
  String get searchTryAgain => 'Intentar de nuevo';

  @override
  String get searchRecognizedObjects => 'Objetos reconocidos';

  @override
  String get searchResult => 'Resultado:';

  @override
  String get searchFailedToCaptureImage => 'Error al capturar la imagen';

  @override
  String searchProcessing(int progress) {
    return 'Procesando... $progress%';
  }

  @override
  String get searchOpeningCamera => 'Abriendo cámara...';

  @override
  String get searchFailedToProcessImage => 'Error al procesar la imagen';

  @override
  String get homeRecentlyViewedProducts => 'Productos vistos recientemente';

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
    return '$count artículo(s)';
  }

  @override
  String get accountTrack => 'Rastrear';

  @override
  String accountTrackingVia(Object trackNumber, Object carrier) {
    return 'Seguimiento $trackNumber mediante $carrier';
  }

  @override
  String get accountUnknownCarrier => 'Transportista desconocido';

  @override
  String get accountTrackingNumber => 'Número de seguimiento';

  @override
  String accountSkuValue(Object sku) {
    return 'SKU : $sku';
  }

  @override
  String accountShippedQtyValue(int qty) {
    return 'Cant. enviada : $qty';
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
      other: '$count tiendas más venden el mismo producto',
      one: '1 tienda más vende el mismo producto',
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
  String get accountReturnSingular => 'Devolución';

  @override
  String get accountReturnPlural => 'Devoluciones';

  @override
  String get accountNoReturnsYet => 'Aún no hay devoluciones';

  @override
  String get accountReturnsEmptyDescription =>
      'Tus solicitudes de devolución aparecerán aquí.';

  @override
  String accountReturnWithNumber(Object number) {
    return 'Devolución $number';
  }

  @override
  String accountReturnOrderLabel(Object number) {
    return 'Pedido $number';
  }

  @override
  String accountReturnQtyValue(int count) {
    return 'Cant.: $count';
  }

  @override
  String accountReturnMaxQty(int count) {
    return 'Máx.: $count';
  }

  @override
  String get accountReturnResolution => 'Resolución';

  @override
  String get accountReturnResolutionReturn => 'Devolución';

  @override
  String get accountReturnResolutionCancel => 'Cancelar artículos';

  @override
  String get accountReturnReason => 'Motivo';

  @override
  String get accountReturnSelectReason => 'Selecciona un motivo';

  @override
  String get accountReturnPackageCondition => 'Estado del paquete';

  @override
  String get accountReturnPackageConditionHint =>
      'p. ej. abierto, sellado, caja dañada';

  @override
  String get accountReturnAdditionalInfo => 'Información adicional';

  @override
  String get accountReturnAdditionalInfoHint =>
      'Describe el problema (opcional)';

  @override
  String get accountReturnEvidenceImages => 'Imágenes';

  @override
  String get accountReturnAddImages => 'Añadir imágenes';

  @override
  String get accountReturnAgreement =>
      'Acepto los términos de la política de devoluciones';

  @override
  String get accountReturnAgreementRequired =>
      'Por favor acepta la política de devoluciones';

  @override
  String get accountReturnSubmit => 'Enviar solicitud';

  @override
  String get accountReturnCreatedTitle => 'Solicitud enviada';

  @override
  String get accountReturnCreatedMessage =>
      'Tu solicitud de devolución se ha enviado correctamente.';

  @override
  String get accountReturnSelectItem => 'Seleccionar artículo';

  @override
  String get accountReturnNoReturnableItems => 'Sin artículos retornables';

  @override
  String get accountReturnNoReturnableItemsDescription =>
      'Este pedido no tiene artículos aptos para devolución o cancelación.';

  @override
  String get accountReturnViewAction => 'Ver';

  @override
  String get accountReturnCancelAction => 'Cancelar solicitud';

  @override
  String get accountReturnCloseAction => 'Marcar como resuelta';

  @override
  String get accountReturnReopenAction => 'Reabrir solicitud';

  @override
  String get accountReturnCancelConfirmation =>
      '¿Seguro que quieres cancelar esta solicitud de devolución?';

  @override
  String get accountReturnCloseConfirmation =>
      '¿Marcar esta solicitud de devolución como resuelta?';

  @override
  String get accountReturnMessages => 'Mensajes';

  @override
  String get accountReturnNoMessages => 'Aún no hay mensajes.';

  @override
  String get accountReturnMessageHint => 'Escribe un mensaje…';

  @override
  String accountReturnStatusUpdated(Object status) {
    return 'Estado de la devolución actualizado a $status';
  }

  @override
  String get accountReturnExpired => 'Plazo de devolución vencido';

  @override
  String get accountReturnInformation => 'Información';

  @override
  String get accountReturnSelectOrder => 'Selecciona un pedido';

  @override
  String get accountReturnChangeOrder => 'Cambiar';

  @override
  String get accountReturnChooseAnotherOrder => 'Elegir otro pedido';

  @override
  String get accountCancelOrder => 'Cancelar pedido';

  @override
  String get accountCancelOrderConfirmation =>
      '¿Seguro que quieres cancelar este pedido? Esta acción no se puede deshacer.';

  @override
  String get accountReviewPhotosVideos => 'Fotos y videos';

  @override
  String get accountReviewGallery => 'Galería';

  @override
  String get accountReviewCamera => 'Cámara';

  @override
  String accountReviewMaxFiles(int count) {
    return 'Puedes adjuntar hasta $count archivos';
  }

  @override
  String get accountReviewFileTooLarge =>
      'Cada archivo debe pesar 5 MB o menos';

  @override
  String get accountReviewUnsupportedFile =>
      'Solo se admiten imágenes y videos';

  @override
  String get accountReviewPickFailed =>
      'No se pudo añadir el contenido. Inténtalo de nuevo';

  @override
  String get accountReviewVideoLoadFailed =>
      'No se puede reproducir este video';

  @override
  String accountShippedCount(int count) {
    return '$count enviado(s)';
  }

  @override
  String get accountReturnNoEligibleOrders =>
      'Ningún pedido es apto para devolución en este momento';

  @override
  String get accountRequestReturn => 'Solicitar una devolución';

  @override
  String get accountRefundBreakdown => 'Desglose del reembolso';

  @override
  String get accountSubtotalRefunded => 'Subtotal reembolsado';

  @override
  String get accountShippingRefunded => 'Envío reembolsado';

  @override
  String get accountTaxRefunded => 'Impuesto reembolsado';

  @override
  String get accountDiscountRefunded => 'Descuento reembolsado';

  @override
  String get accountRefunded => 'Reembolsado';

  @override
  String get accountCanceledQty => 'Cancelado';

  @override
  String get productBookingCancellation => 'Cancelación';

  @override
  String get productBookingCancellationNotAllowed => 'Cancelación no permitida';

  @override
  String get accountBookingItemsNotCanceled =>
      'Los artículos de reserva de este pedido no se cancelarán.';

  @override
  String cartQtyValue(int count) {
    return 'Cant.: $count';
  }

  @override
  String get checkoutAccountSuspended =>
      'Tu cuenta está suspendida. Puedes navegar por la tienda, pero no puedes realizar pedidos.';

  @override
  String get accountGenderRequiredLabel => 'Género *';

  @override
  String get accountGenderRequired => 'El género es obligatorio';

  @override
  String get accountPhoneRequiredLabel => 'Teléfono *';

  @override
  String get cartGuestCheckoutNotAllowed =>
      'Inicia sesión para comprar estos artículos.';

  @override
  String get accountEuWithdraw => 'Desistir del contrato';

  @override
  String get accountEuWithdrawGuestTitle => 'Desistir de tu contrato';

  @override
  String get accountEuWithdrawReason => 'Motivo (opcional)';

  @override
  String get accountEuWithdrawSubmit => 'Envíame el enlace de desistimiento';

  @override
  String get accountEuWithdrawSubmitted =>
      'Si existe un pedido coincidente, acabamos de enviar un enlace de desistimiento a esa dirección. Será válido durante 24 horas.';

  @override
  String accountEuWithdrawStatus(String status) {
    return 'Solicitud de desistimiento: $status';
  }

  @override
  String get accountEuWithdrawGuestDescription =>
      'Introduce el número de pedido y el correo electrónico que usaste al finalizar la compra. Te enviaremos un enlace para solicitar el desistimiento.';

  @override
  String get accountEuWithdrawOrderNumber => 'Número de pedido';

  @override
  String get accountEuWithdrawEmail => 'Correo electrónico';

  @override
  String get accountEuWithdrawFieldRequired => 'Este campo es obligatorio';

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
      'Escríbenos una nota y te responderemos lo antes posible';

  @override
  String get accountPhoneNumber => 'Número de teléfono';

  @override
  String get accountWhatsOnYourMind => '¿Qué tienes en mente?';

  @override
  String get accountDescribeHere => 'Descríbelo aquí';

  @override
  String get accountSubmit => 'Enviar';

  @override
  String get priceStartingAt => 'Starting at';

  @override
  String get priceStartingFrom => 'Starting from';

  @override
  String get priceAsLowAs => 'As low as';

  @override
  String get priceRangeTo => 'To';
}
