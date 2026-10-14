import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../category/data/models/product_model.dart';
import '../../../category/data/repository/category_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String urlKey;
  final String? productId;
  final String? productType;

  const LoadProductDetail({
    required this.urlKey,
    this.productId,
    this.productType,
  });

  @override
  List<Object?> get props => [urlKey, productId, productType];
}

class RefreshProductDetail extends ProductDetailEvent {
  final String urlKey;
  final String? productId;
  final String? productType;

  const RefreshProductDetail({
    required this.urlKey,
    this.productId,
    this.productType,
  });

  @override
  List<Object?> get props => [urlKey, productId, productType];
}

class SelectAttributeOption extends ProductDetailEvent {
  final String attributeCode;
  final String optionId;
  const SelectAttributeOption({
    required this.attributeCode,
    required this.optionId,
  });

  @override
  List<Object?> get props => [attributeCode, optionId];
}

class SelectDownloadableLink extends ProductDetailEvent {
  final String linkId;
  const SelectDownloadableLink(this.linkId);

  @override
  List<Object?> get props => [linkId];
}

class UpdateQuantity extends ProductDetailEvent {
  final int quantity;
  const UpdateQuantity(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class UpdateGroupedProductQuantity extends ProductDetailEvent {
  final String groupedItemId;
  final int quantity;

  const UpdateGroupedProductQuantity({
    required this.groupedItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [groupedItemId, quantity];
}

class SelectBundleOptionProduct extends ProductDetailEvent {
  final String bundleOptionId;
  final String bundleOptionProductId;
  final bool isMultiSelect;
  final int defaultQty;

  const SelectBundleOptionProduct({
    required this.bundleOptionId,
    required this.bundleOptionProductId,
    required this.isMultiSelect,
    this.defaultQty = 1,
  });

  @override
  List<Object?> get props => [
    bundleOptionId,
    bundleOptionProductId,
    isMultiSelect,
    defaultQty,
  ];
}

class UpdateBundleOptionProductQuantity extends ProductDetailEvent {
  final String bundleOptionProductId;
  final int quantity;

  const UpdateBundleOptionProductQuantity({
    required this.bundleOptionProductId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [bundleOptionProductId, quantity];
}

class UpdateBookingField extends ProductDetailEvent {
  final String key;
  final dynamic value;

  const UpdateBookingField({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class UpdateCustomizableOption extends ProductDetailEvent {
  final String optionId;
  final dynamic value;

  const UpdateCustomizableOption({required this.optionId, required this.value});

  @override
  List<Object?> get props => [optionId, value];
}

class UpdateBookingTicketQuantity extends ProductDetailEvent {
  final String ticketId;
  final int quantity;

  const UpdateBookingTicketQuantity({
    required this.ticketId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [ticketId, quantity];
}

class LoadBookingSlots extends ProductDetailEvent {
  const LoadBookingSlots();
}

class ToggleDescriptionExpanded extends ProductDetailEvent {}

class ToggleMoreInfoExpanded extends ProductDetailEvent {}

// ─── State ─────────────────────────────────────────────────────────────────

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductModel? product;
  final List<ProductModel> relatedProducts;
  final Map<String, String>
  selectedAttributes; // code -> selectionId (optionId or label)
  final ProductVariant?
  selectedVariant; // matched variant for current selection (legacy)
  final int? selectedVariantId; // variant ID from combinations (new API)
  final List<String> selectedDownloadableLinks; // list of link IDs
  final int quantity;
  final Map<String, int> groupedQuantities;
  final Map<String, List<String>> selectedBundleOptions;
  final Map<String, int> bundleOptionQuantities;
  final Map<String, dynamic> bookingForm;
  final Map<String, dynamic> customizableOptionValues;
  final Map<String, int> bookingTicketQuantities;
  final List<BookingSlotOption> bookingSlots;
  final bool isBookingSlotsLoading;
  final String? bookingSlotsError;
  final bool isDescriptionExpanded;
  final bool isMoreInfoExpanded;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.selectedAttributes = const {},
    this.selectedVariant,
    this.selectedVariantId,
    this.selectedDownloadableLinks = const [],
    this.quantity = 1,
    this.groupedQuantities = const {},
    this.selectedBundleOptions = const {},
    this.bundleOptionQuantities = const {},
    this.bookingForm = const {},
    this.customizableOptionValues = const {},
    this.bookingTicketQuantities = const {},
    this.bookingSlots = const [],
    this.isBookingSlotsLoading = false,
    this.bookingSlotsError,
    this.isDescriptionExpanded = false,
    this.isMoreInfoExpanded = false,
    this.errorMessage,
  });

  /// True when the API reports the product (or the selected variant) as not
  /// saleable, e.g. out of stock. A missing `isSaleable` is not treated as
  /// out of stock.
  bool get isOutOfStock {
    final variantSaleable = selectedVariant?.isSaleable;
    if (variantSaleable != null) {
      final value = variantSaleable.trim().toLowerCase();
      if (value != '1' && value != 'true') return true;
    }
    return product?.isSaleable == false;
  }

  /// Get the effective display price (variant price if selected, else product price)
  double get effectiveDisplayPrice {
    if (selectedVariant != null) return selectedVariant!.displayPrice;
    return product?.displayPrice ?? 0;
  }

  /// Get the effective image URL (variant image if selected, else product images)
  String? get effectiveImageUrl {
    return selectedVariant?.baseImageUrl;
  }

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductModel? product,
    List<ProductModel>? relatedProducts,
    Map<String, String>? selectedAttributes,
    ProductVariant? selectedVariant,
    bool clearSelectedVariant = false,
    int? selectedVariantId,
    bool clearSelectedVariantId = false,
    List<String>? selectedDownloadableLinks,
    int? quantity,
    Map<String, int>? groupedQuantities,
    Map<String, List<String>>? selectedBundleOptions,
    Map<String, int>? bundleOptionQuantities,
    Map<String, dynamic>? bookingForm,
    Map<String, dynamic>? customizableOptionValues,
    Map<String, int>? bookingTicketQuantities,
    List<BookingSlotOption>? bookingSlots,
    bool? isBookingSlotsLoading,
    String? bookingSlotsError,
    bool? isDescriptionExpanded,
    bool? isMoreInfoExpanded,
    String? errorMessage,
    bool clearBookingSlotsError = false,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      selectedVariant: clearSelectedVariant
          ? null
          : (selectedVariant ?? this.selectedVariant),
      selectedVariantId: clearSelectedVariantId
          ? null
          : (selectedVariantId ?? this.selectedVariantId),
      selectedDownloadableLinks:
          selectedDownloadableLinks ?? this.selectedDownloadableLinks,
      quantity: quantity ?? this.quantity,
      groupedQuantities: groupedQuantities ?? this.groupedQuantities,
      selectedBundleOptions:
          selectedBundleOptions ?? this.selectedBundleOptions,
      bundleOptionQuantities:
          bundleOptionQuantities ?? this.bundleOptionQuantities,
      bookingForm: bookingForm ?? this.bookingForm,
      customizableOptionValues:
          customizableOptionValues ?? this.customizableOptionValues,
      bookingTicketQuantities:
          bookingTicketQuantities ?? this.bookingTicketQuantities,
      bookingSlots: bookingSlots ?? this.bookingSlots,
      isBookingSlotsLoading:
          isBookingSlotsLoading ?? this.isBookingSlotsLoading,
      bookingSlotsError: clearBookingSlotsError
          ? null
          : (bookingSlotsError ?? this.bookingSlotsError),
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      isMoreInfoExpanded: isMoreInfoExpanded ?? this.isMoreInfoExpanded,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    product,
    relatedProducts,
    selectedAttributes,
    selectedVariant,
    selectedVariantId,
    selectedDownloadableLinks,
    quantity,
    groupedQuantities,
    selectedBundleOptions,
    bundleOptionQuantities,
    bookingForm,
    customizableOptionValues,
    bookingTicketQuantities,
    bookingSlots,
    isBookingSlotsLoading,
    bookingSlotsError,
    isDescriptionExpanded,
    isMoreInfoExpanded,
    errorMessage,
  ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final CategoryRepository repository;

  ProductDetailBloc({required this.repository})
    : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<RefreshProductDetail>(_onRefreshProductDetail);
    on<SelectAttributeOption>(_onSelectAttributeOption);
    on<SelectDownloadableLink>(_onSelectDownloadableLink);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<UpdateGroupedProductQuantity>(_onUpdateGroupedProductQuantity);
    on<SelectBundleOptionProduct>(_onSelectBundleOptionProduct);
    on<UpdateBundleOptionProductQuantity>(_onUpdateBundleOptionProductQuantity);
    on<UpdateBookingField>(_onUpdateBookingField);
    on<UpdateCustomizableOption>(_onUpdateCustomizableOption);
    on<UpdateBookingTicketQuantity>(_onUpdateBookingTicketQuantity);
    on<LoadBookingSlots>(_onLoadBookingSlots);
    on<ToggleDescriptionExpanded>(_onToggleDescriptionExpanded);
    on<ToggleMoreInfoExpanded>(_onToggleMoreInfoExpanded);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product = await _fetchProductWithFallback(
        urlKey: event.urlKey,
        productId: event.productId,
        productType: event.productType,
      );

      // Related products are already included in the detailed query response
      List<ProductModel> related = product.relatedProducts;

      // If no related products from inline, try separate query
      if (related.isEmpty) {
        try {
          related = await repository.getRelatedProducts(event.urlKey);
        } catch (_) {
          // Silently ignore
        }
      }

      emit(
        state.copyWith(
          status: ProductDetailStatus.loaded,
          product: product,
          relatedProducts: related,
          groupedQuantities: {
            for (final grouped in product.groupedProducts)
              grouped.id:
                  (grouped.associatedProduct?.qty ?? grouped.qty ?? 0) > 0
                  ? (grouped.associatedProduct?.qty ?? grouped.qty ?? 0)
                  : 0,
          },
          selectedBundleOptions: _defaultBundleSelections(product),
          bundleOptionQuantities: _defaultBundleQuantities(product),
          bookingForm: _defaultBookingForm(product),
          customizableOptionValues: const {},
          bookingTicketQuantities: _defaultBookingTicketQuantities(product),
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.error,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'loading product details',
          ),
        ),
      );
    }
  }

  Future<void> _onRefreshProductDetail(
    RefreshProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    // Keep the current product data while refreshing
    final currentProduct = state.product;

    try {
      final product = await _fetchProductWithFallback(
        urlKey: event.urlKey,
        productId: event.productId,
        productType: event.productType,
      );

      // Related products are already included in the detailed query response
      List<ProductModel> related = product.relatedProducts;

      // If no related products from inline, try separate query
      if (related.isEmpty) {
        try {
          related = await repository.getRelatedProducts(event.urlKey);
        } catch (_) {
          // Silently ignore
        }
      }

      emit(
        state.copyWith(
          status: ProductDetailStatus.loaded,
          product: product,
          relatedProducts: related,
          groupedQuantities: {
            for (final grouped in product.groupedProducts)
              grouped.id:
                  (grouped.associatedProduct?.qty ?? grouped.qty ?? 0) > 0
                  ? (grouped.associatedProduct?.qty ?? grouped.qty ?? 0)
                  : 0,
          },
          selectedBundleOptions: _defaultBundleSelections(product),
          bundleOptionQuantities: _defaultBundleQuantities(product),
          bookingForm: _defaultBookingForm(product),
          customizableOptionValues: const {},
          bookingTicketQuantities: _defaultBookingTicketQuantities(product),
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
    } catch (e) {
      // On refresh error, keep the current product data if available
      if (currentProduct != null) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.loaded,
            product: currentProduct,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: ErrorMapper.getUserMessage(
              e,
              context: 'refreshing product details',
            ),
          ),
        );
      }
    }
  }

  void _onSelectAttributeOption(
    SelectAttributeOption event,
    Emitter<ProductDetailState> emit,
  ) {
    final updated = Map<String, String>.from(state.selectedAttributes);

    // Toggle: deselect if already selected
    if (updated[event.attributeCode] == event.optionId) {
      updated.remove(event.attributeCode);
    } else {
      updated[event.attributeCode] = event.optionId;
    }

    // Try combinations first (new API), then legacy variant matching
    final variantId = state.product?.findVariantIdFromCombinations(updated);

    // Resolve the variant object: by ID from combinations, or by attribute match (legacy)
    ProductVariant? variant;
    if (variantId != null) {
      variant = state.product?.findVariantById(variantId);
    }
    variant ??= state.product?.findVariant(updated);

    emit(
      state.copyWith(
        selectedAttributes: updated,
        selectedVariant: variant,
        clearSelectedVariant: variant == null,
        selectedVariantId: variantId,
        clearSelectedVariantId: variantId == null,
      ),
    );
  }

  void _onSelectDownloadableLink(
    SelectDownloadableLink event,
    Emitter<ProductDetailState> emit,
  ) {
    final updated = List<String>.from(state.selectedDownloadableLinks);
    if (updated.contains(event.linkId)) {
      updated.remove(event.linkId);
    } else {
      updated.add(event.linkId);
    }
    emit(state.copyWith(selectedDownloadableLinks: updated));
  }

  void _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    if (event.quantity >= 1) {
      emit(state.copyWith(quantity: event.quantity));
    }
  }

  void _onUpdateGroupedProductQuantity(
    UpdateGroupedProductQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    final updated = Map<String, int>.from(state.groupedQuantities);
    updated[event.groupedItemId] = event.quantity < 0 ? 0 : event.quantity;
    emit(state.copyWith(groupedQuantities: updated));
  }

  void _onSelectBundleOptionProduct(
    SelectBundleOptionProduct event,
    Emitter<ProductDetailState> emit,
  ) {
    final updatedSelections = Map<String, List<String>>.from(
      state.selectedBundleOptions,
    );
    final currentSelections = List<String>.from(
      updatedSelections[event.bundleOptionId] ?? const <String>[],
    );

    if (event.isMultiSelect) {
      if (currentSelections.contains(event.bundleOptionProductId)) {
        currentSelections.remove(event.bundleOptionProductId);
      } else {
        currentSelections.add(event.bundleOptionProductId);
      }
    } else {
      currentSelections
        ..clear()
        ..add(event.bundleOptionProductId);
    }

    updatedSelections[event.bundleOptionId] = currentSelections;

    final updatedQuantities = Map<String, int>.from(
      state.bundleOptionQuantities,
    );
    if (!updatedQuantities.containsKey(event.bundleOptionProductId)) {
      updatedQuantities[event.bundleOptionProductId] = event.defaultQty > 0
          ? event.defaultQty
          : 1;
    }

    emit(
      state.copyWith(
        selectedBundleOptions: updatedSelections,
        bundleOptionQuantities: updatedQuantities,
      ),
    );
  }

  void _onUpdateBundleOptionProductQuantity(
    UpdateBundleOptionProductQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    final updatedQuantities = Map<String, int>.from(
      state.bundleOptionQuantities,
    );
    updatedQuantities[event.bundleOptionProductId] = event.quantity < 1
        ? 1
        : event.quantity;
    emit(state.copyWith(bundleOptionQuantities: updatedQuantities));
  }

  Future<void> _onUpdateBookingField(
    UpdateBookingField event,
    Emitter<ProductDetailState> emit,
  ) async {
    final updated = Map<String, dynamic>.from(state.bookingForm);
    updated[event.key] = event.value;
    final shouldResetSlots = event.key == 'date' || event.key == 'rentingType';

    if (shouldResetSlots) {
      updated['slot'] = null;
    }

    if (event.key == 'rentingType') {
      final rentingType = event.value?.toString().toLowerCase().trim();
      if (rentingType == 'daily') {
        updated['date'] = null;
      } else {
        updated['dateFrom'] = null;
        updated['dateTo'] = null;
      }
    }

    emit(
      state.copyWith(
        bookingForm: updated,
        bookingSlots: shouldResetSlots ? const [] : null,
        isBookingSlotsLoading: shouldResetSlots ? false : null,
        clearBookingSlotsError: shouldResetSlots,
      ),
    );

    if (shouldResetSlots && _shouldLoadBookingSlots(updated)) {
      add(const LoadBookingSlots());
    }
  }

  void _onUpdateBookingTicketQuantity(
    UpdateBookingTicketQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    final updated = Map<String, int>.from(state.bookingTicketQuantities);
    if (event.quantity <= 0) {
      updated.remove(event.ticketId);
    } else {
      updated[event.ticketId] = event.quantity;
    }
    emit(state.copyWith(bookingTicketQuantities: updated));
  }

  void _onUpdateCustomizableOption(
    UpdateCustomizableOption event,
    Emitter<ProductDetailState> emit,
  ) {
    final updated = Map<String, dynamic>.from(state.customizableOptionValues);
    final value = event.value;

    final isEmptyList = value is List && value.isEmpty;
    final isEmptyString = value is String && value.trim().isEmpty;
    if (value == null || isEmptyList || isEmptyString) {
      updated.remove(event.optionId);
    } else {
      updated[event.optionId] = value;
    }

    emit(state.copyWith(customizableOptionValues: updated));
  }

  Future<void> _onLoadBookingSlots(
    LoadBookingSlots event,
    Emitter<ProductDetailState> emit,
  ) async {
    final product = state.product;
    final booking = product?.bookingProducts.isNotEmpty == true
        ? product!.bookingProducts.first
        : null;

    if (booking == null) {
      emit(
        state.copyWith(
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
      return;
    }

    final type = (booking.type ?? '').toLowerCase().trim();
    final rentingType = state.bookingForm['rentingType']?.toString();

    if (!_supportsDynamicSlots(type: type, rentingType: rentingType)) {
      emit(
        state.copyWith(
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
      return;
    }

    final date = state.bookingForm['date']?.toString().trim();
    if ((date ?? '').isEmpty) {
      emit(
        state.copyWith(
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        bookingSlots: const [],
        isBookingSlotsLoading: true,
        clearBookingSlotsError: true,
      ),
    );

    try {
      final slots = await repository.getBookingSlots(
        booking: booking,
        date: date!,
        rentingType: rentingType,
      );

      final latestDate = state.bookingForm['date']?.toString().trim();
      final latestRentingType = state.bookingForm['rentingType']
          ?.toString()
          .toLowerCase()
          .trim();
      final requestedRentingType = (rentingType ?? '').toLowerCase().trim();

      if (latestDate != date || latestRentingType != requestedRentingType) {
        return;
      }

      emit(
        state.copyWith(
          bookingSlots: slots,
          isBookingSlotsLoading: false,
          clearBookingSlotsError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bookingSlots: const [],
          isBookingSlotsLoading: false,
          bookingSlotsError: ErrorMapper.getUserMessage(
            e,
            context: 'loading booking slots',
          ),
        ),
      );
    }
  }

  void _onToggleDescriptionExpanded(
    ToggleDescriptionExpanded event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded));
  }

  void _onToggleMoreInfoExpanded(
    ToggleMoreInfoExpanded event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isMoreInfoExpanded: !state.isMoreInfoExpanded));
  }

  Map<String, List<String>> _defaultBundleSelections(ProductModel product) {
    final defaults = <String, List<String>>{};

    for (final option in product.bundleOptions) {
      final selectedIds = option.bundleOptionProducts
          .where((item) => item.isDefault)
          .map((item) => item.id)
          .toList();

      final type = option.type?.toLowerCase() ?? '';
      final isMultiType = type.contains('checkbox') || type.contains('multi');

      if (selectedIds.isEmpty) continue;

      defaults[option.id] = isMultiType
          ? selectedIds
          : <String>[selectedIds.first];
    }

    return defaults;
  }

  Map<String, int> _defaultBundleQuantities(ProductModel product) {
    final quantities = <String, int>{};

    for (final option in product.bundleOptions) {
      for (final item in option.bundleOptionProducts) {
        if (!item.isDefault) continue;
        quantities[item.id] = (item.qty ?? 1) > 0 ? (item.qty ?? 1) : 1;
      }
    }

    return quantities;
  }

  Map<String, dynamic> _defaultBookingForm(ProductModel product) {
    final booking = product.bookingProducts.isNotEmpty
        ? product.bookingProducts.first
        : null;
    if (booking == null) return const {};

    final bookingType = (booking.type ?? '').toLowerCase().trim();
    final defaultRentingType = _defaultRentalType(booking);

    return <String, dynamic>{
      'type': bookingType,
      'qty': bookingType == 'appointment'
          ? 1
          : (booking.qty > 0 ? booking.qty : 1),
      'date': null,
      'slot': null,
      'dateFrom': null,
      'dateTo': null,
      'rentingType': defaultRentingType,
      'note': '',
      'startTime': null,
      'endTime': null,
    };
  }

  Map<String, int> _defaultBookingTicketQuantities(ProductModel product) {
    final booking = product.bookingProducts.isNotEmpty
        ? product.bookingProducts.first
        : null;
    if (booking == null || booking.eventTickets.isEmpty) return const {};

    return {
      for (final ticket in booking.eventTickets)
        ticket.id: (ticket.qty > 0 ? 1 : 0),
    }..removeWhere((_, qty) => qty <= 0);
  }

  String _defaultRentalType(BookingProductData booking) {
    final rentalType = (booking.rentalSlot?.rentingType ?? '')
        .toLowerCase()
        .trim();
    if (rentalType == 'hourly') return 'hourly';
    return 'daily';
  }

  bool _shouldLoadBookingSlots(Map<String, dynamic> form) {
    final product = state.product;
    final booking = product?.bookingProducts.isNotEmpty == true
        ? product!.bookingProducts.first
        : null;
    if (booking == null) return false;

    final type = (booking.type ?? '').toLowerCase().trim();
    final rentingType = form['rentingType']?.toString();

    if (!_supportsDynamicSlots(type: type, rentingType: rentingType)) {
      return false;
    }

    final date = form['date']?.toString().trim();
    return (date ?? '').isNotEmpty;
  }

  bool _supportsDynamicSlots({required String type, String? rentingType}) {
    switch (type) {
      case 'default':
      case 'appointment':
      case 'table':
        return true;
      case 'rental':
        return (rentingType ?? '').toLowerCase().trim() == 'hourly';
      default:
        return false;
    }
  }

  Future<ProductModel> _fetchProductWithFallback({
    required String urlKey,
    String? productId,
    String? productType,
  }) async {
    final normalizedUrlKey = urlKey.trim();
    final normalizedProductId = productId?.trim();

    if (normalizedUrlKey.isNotEmpty) {
      try {
        return await repository.getProductByUrlKey(
          normalizedUrlKey,
          productType: productType,
        );
      } catch (_) {
        if (normalizedProductId == null || normalizedProductId.isEmpty) {
          rethrow;
        }
      }
    }

    if (normalizedProductId != null && normalizedProductId.isNotEmpty) {
      return repository.getProductById(
        normalizedProductId,
        productType: productType,
      );
    }

    throw Exception('Missing both urlKey and productId for product detail');
  }
}
