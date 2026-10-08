import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bloc_refresh.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../data/models/account_models.dart';
import '../bloc/wishlist_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

String _localizedWishlistMessage(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;
  switch (message) {
    case 'Item removed from wishlist':
      return l10n.wishlistItemRemoved;
    default:
      return message;
  }
}

/// Wishlist page matching Figma node 245:5225
/// Design: Back arrow + "Wishlist" title, item count, list of wishlist items
/// Each item: 93×93 rounded image, product name, price, qty stepper, Add to Cart, Remove
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: AppBackButton(isIosStyle: false),
        leadingWidth: 60,
        title: Text(
          l10n.accountWishlist,
          style: AppTextStyles.text4(
            context,
          ).copyWith(color: isDark ? AppColors.neutral100 : AppColors.black),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<WishlistBloc, WishlistState>(
        listener: (context, state) {
          // Show snackbar for success/error messages
          if (state.successMessage != null) {
            final message =
                _localizedWishlistMessage(context, state.successMessage!);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.success700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            // Reload cart when item is added from wishlist
            context.read<WishlistBloc>().add(const ClearWishlistMessage());
            context.read<CartBloc>().add(LoadCart());
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );

            // Navigate to product detail page if it's a configurable product error
            if (state.errorUrlKey != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    urlKey: state.errorUrlKey!,
                    productId: state.errorProductId?.toString(),
                    productName: state.errorProductName,
                    productType: state.errorProductType,
                  ),
                ),
              );
            }

            context.read<WishlistBloc>().add(const ClearWishlistMessage());
          }
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          // Only block the screen on first load; a pull-to-refresh keeps the
          // current items visible under the refresh spinner.
          if (state.status == WishlistStatus.loading && state.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            );
          }

          final Widget content;
          if (state.status == WishlistStatus.error && state.items.isEmpty) {
            content = _fillViewport(_buildErrorState(context, state, isDark));
          } else if (state.items.isEmpty) {
            content = _fillViewport(_buildEmptyState(context, isDark));
          } else {
            content = _buildWishlistContent(context, state);
          }

          return RefreshIndicator(
            color: AppColors.primary500,
            onRefresh: () => _refresh(context),
            child: content,
          );
        },
      ),
    );
  }

  /// Pull-to-refresh: reloads the wishlist and resolves once it finishes.
  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<WishlistBloc>();
    return refreshBloc<WishlistState>(
      bloc,
      () => bloc.add(const LoadWishlist()),
      (s) =>
          s.status == WishlistStatus.loaded || s.status == WishlistStatus.error,
    );
  }

  /// Makes a non-list view pullable by placing it in an always-scrollable
  /// viewport that fills the body.
  Widget _fillViewport(Widget child) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WishlistState state,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? l10n.categorySomethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTextStyles.text5(context).copyWith(
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.read<WishlistBloc>().add(const LoadWishlist());
              },
              child: Text(
                l10n.accountTryAgain,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.accountYourWishlistEmpty,
              style: AppTextStyles.text4(context).copyWith(
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountWishlistEmptyDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.text5(
                context,
              ).copyWith(color: AppColors.neutral500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, WishlistState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WishlistList(
      items: state.items,
      totalCount: state.totalCount,
      hasNextPage: state.hasNextPage,
      isLoadingMore: state.isLoadingMore,
      processingIds: state.processingIds,
      isDark: isDark,
    );
  }
}

class _WishlistList extends StatefulWidget {
  final List<WishlistItem> items;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final Set<String> processingIds;
  final bool isDark;

  const _WishlistList({
    required this.items,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.processingIds,
    required this.isDark,
  });

  @override
  State<_WishlistList> createState() => _WishlistListState();
}

class _WishlistListState extends State<_WishlistList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, int> _quantities = <String, int>{};

  @override
  void initState() {
    super.initState();
    _syncQuantities(widget.items);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant _WishlistList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _syncQuantities(widget.items);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _syncQuantities(List<WishlistItem> items) {
    final nextIds = items.map((item) => item.id).whereType<String>().toSet();
    _quantities.removeWhere((id, _) => !nextIds.contains(id));

    for (final item in items) {
      final id = item.id;
      if (id == null) continue;
      _quantities[id] = (_quantities[id] ?? item.quantity).clamp(1, 9999);
    }
  }

  void _handleQuantityChanged(WishlistItem item, int quantity) {
    final id = item.id;
    if (id == null) return;

    final safeQuantity = quantity.clamp(1, 9999);
    setState(() {
      _quantities[id] = safeQuantity;
    });

    context.read<WishlistBloc>().add(
      UpdateWishlistItemQuantity(id: id, quantity: safeQuantity),
    );
  }

  void _handleAddToCart(BuildContext context, WishlistItem item, int quantity) {
    if (_requiresProductDetails(item)) {
      if (item.urlKey == null || item.urlKey!.isEmpty) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(
            urlKey: item.urlKey!,
            productId: item.productNumericId?.toString(),
            productName: item.name,
            productType: item.type,
          ),
        ),
      );
      return;
    }

    if (item.numericId == null) return;

    context.read<WishlistBloc>().add(
      MoveWishlistItemToCart(
        numericId: item.numericId!,
        quantity: quantity,
      ),
    );
  }

  bool _requiresProductDetails(WishlistItem item) {
    switch ((item.type ?? '').toLowerCase()) {
      case 'configurable':
      case 'bundle':
      case 'grouped':
      case 'downloadable':
      case 'booking':
        return true;
      default:
        return false;
    }
  }

  void _onScroll() {
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<WishlistBloc>().add(const LoadMoreWishlist());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item count header — "3 Items"
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 0),
            child: Text(
              '${widget.totalCount} ${widget.totalCount == 1 ? l10n.accountItemSingular : l10n.accountItemPlural}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: widget.isDark
                    ? AppColors.neutral200
                    : AppColors.neutral900,
              ),
            ),
          ),
          // Wishlist items list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 0, bottom: 24),
              itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary500,
                      ),
                    ),
                  );
                }

                final item = widget.items[index];
                final quantity = item.id != null
                    ? (_quantities[item.id!] ?? item.quantity)
                    : item.quantity;
                final isProcessing = widget.processingIds.contains(
                  item.id ?? '',
                );
                return _WishlistItemCard(
                  key: ValueKey(item.id ?? item.numericId ?? index),
                  item: item,
                  quantity: quantity,
                  isProcessing: isProcessing,
                  isDark: widget.isDark,
                  onQuantityChanged: (qty) => _handleQuantityChanged(item, qty),
                  onAddToCart: () => _handleAddToCart(context, item, quantity),
                  onRemove: () {
                    if (item.id != null) {
                      context.read<WishlistBloc>().add(
                        RemoveWishlistItem(id: item.id!),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

/// Single wishlist item card matching Figma design
class _WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final int quantity;
  final bool isProcessing;
  final bool isDark;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const _WishlistItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.isProcessing,
    required this.isDark,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral800 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Opacity(
        opacity: isProcessing ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image — 93×93 with 12px radius
            GestureDetector(
              onTap: () {
                if (item.urlKey != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(
                        urlKey: item.urlKey!,
                        productId: item.productNumericId?.toString(),
                        productName: item.name,
                        productType: item.type,
                      ),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 93,
                  height: 93,
                  child:
                      item.baseImageUrl != null && item.baseImageUrl!.isNotEmpty
                      ? Image.network(
                          item.baseImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: isDark
                                ? AppColors.neutral800
                                : AppColors.neutral100,
                            child: Icon(
                              Icons.image_outlined,
                              color: isDark
                                  ? AppColors.neutral600
                                  : AppColors.neutral400,
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          child: Icon(
                            Icons.image_outlined,
                            color: isDark
                                ? AppColors.neutral600
                                : AppColors.neutral400,
                            size: 32,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name — Roboto Medium 14px, neutral900
                  GestureDetector(
                    onTap: () {
                      if (item.urlKey != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              urlKey: item.urlKey!,
                              productId: item.productNumericId?.toString(),
                              productName: item.name,
                              productType: item.type,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price — "Starting at $336.00"
                  Text(
                    _buildPriceText(context),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity stepper + Add to Cart
                  Row(
                    children: [
                      // Quantity stepper
                      _QuantityStepper(
                        quantity: quantity,
                        onChanged: onQuantityChanged,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      // Add to Cart button
                      _AddToCartButton(
                        onPressed: isProcessing ? null : onAddToCart,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Remove link — blue text
                  GestureDetector(
                    onTap: isProcessing ? null : onRemove,
                    child: Text(
                      AppLocalizations.of(context)!.cartRemove,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.process600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildPriceText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (item.specialPrice != null && item.specialPrice! > 0) {
      return l10n.accountStartingAt(item.formattedSpecialPrice ?? '');
    }
    return l10n.accountStartingAt(item.formattedPrice);
  }
}

/// Quantity stepper: [ - ] count [ + ] with bordered container
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final bool isDark;

  const _QuantityStepper({
    required this.quantity,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          InkWell(
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                Icons.remove,
                size: 16,
                color: quantity > 1
                    ? (isDark ? AppColors.neutral200 : AppColors.neutral900)
                    : AppColors.neutral400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Quantity display
          SizedBox(
            width: 20,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Plus button
          InkWell(
            onTap: () => onChanged(quantity + 1),
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                Icons.add,
                size: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Add to Cart" outlined button with orange text
class _AddToCartButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDark;

  const _AddToCartButton({this.onPressed, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 36,
        width: 108,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          l10n.accountMoveToCart,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.primary500,
          ),
        ),
      ),
    );
  }
}
