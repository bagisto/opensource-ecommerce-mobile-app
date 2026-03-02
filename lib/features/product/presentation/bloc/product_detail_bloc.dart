import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
  const LoadProductDetail({required this.urlKey});

  @override
  List<Object?> get props => [urlKey];
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

class UpdateQuantity extends ProductDetailEvent {
  final int quantity;
  const UpdateQuantity(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class ToggleDescriptionExpanded extends ProductDetailEvent {}

class ToggleMoreInfoExpanded extends ProductDetailEvent {}

class RefreshProductDetail extends ProductDetailEvent {
  final String urlKey;
  const RefreshProductDetail({required this.urlKey});

  @override
  List<Object?> get props => [urlKey];
}

// ─── State ─────────────────────────────────────────────────────────────────

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductModel? product;
  final List<ProductModel> relatedProducts;
  final Map<String, String> selectedAttributes; // code -> value (e.g. "color" -> "Yellow")
  final ProductVariant? selectedVariant; // matched variant for current selection
  final int quantity;
  final bool isDescriptionExpanded;
  final bool isMoreInfoExpanded;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.selectedAttributes = const {},
    this.selectedVariant,
    this.quantity = 1,
    this.isDescriptionExpanded = false,
    this.isMoreInfoExpanded = false,
    this.errorMessage,
  });

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
    int? quantity,
    bool? isDescriptionExpanded,
    bool? isMoreInfoExpanded,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      selectedVariant:
          clearSelectedVariant ? null : (selectedVariant ?? this.selectedVariant),
      quantity: quantity ?? this.quantity,
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
        quantity,
        isDescriptionExpanded,
        isMoreInfoExpanded,
        errorMessage,
      ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final CategoryRepository repository;

  ProductDetailBloc({required this.repository})
      : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<RefreshProductDetail>(_onRefreshProductDetail);
    on<SelectAttributeOption>(_onSelectAttributeOption);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ToggleDescriptionExpanded>(_onToggleDescriptionExpanded);
    on<ToggleMoreInfoExpanded>(_onToggleMoreInfoExpanded);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product = await repository.getProductByUrlKey(event.urlKey);

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

      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
        relatedProducts: related,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshProductDetail(
    RefreshProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    // Keep the current product data while refreshing
    final currentProduct = state.product;
    
    try {
      final product = await repository.getProductByUrlKey(event.urlKey);

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

      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
        relatedProducts: related,
      ));
    } catch (e) {
      // On refresh error, keep the current product data if available
      if (currentProduct != null) {
        emit(state.copyWith(
          status: ProductDetailStatus.loaded,
          product: currentProduct,
        ));
      } else {
        emit(state.copyWith(
          status: ProductDetailStatus.error,
          errorMessage: e.toString(),
        ));
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

    // Try to find a matching variant for the current selection
    final variant = state.product?.findVariant(updated);

    emit(state.copyWith(
      selectedAttributes: updated,
      selectedVariant: variant,
      clearSelectedVariant: variant == null,
    ));
  }

  void _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    if (event.quantity >= 1) {
      emit(state.copyWith(quantity: event.quantity));
    }
  }

  void _onToggleDescriptionExpanded(
    ToggleDescriptionExpanded event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(
        isDescriptionExpanded: !state.isDescriptionExpanded));
  }

  void _onToggleMoreInfoExpanded(
    ToggleMoreInfoExpanded event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isMoreInfoExpanded: !state.isMoreInfoExpanded));
  }
}
