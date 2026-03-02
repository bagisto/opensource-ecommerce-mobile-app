import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/account_models.dart';
import '../bloc/compare_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../product/presentation/pages/product_detail_page.dart';

/// Compare Products Page — Figma node-id=1866-5772
///
/// Displays a horizontally scrollable comparison table:
///   - Fixed left column with attribute labels
///     (Products, SKU, Description, Short Description, Activity, Seller)
///   - One column per product showing product card + attribute values
///   - Each product column: 162px image, name, price, rating, Add to Cart + delete
///   - Attribute rows alternate between gray headers (#F5F5F5) and white value rows
///
/// Architecture:
///   BlocProvider<CompareBloc> → CompareProductsPage → Repository → GraphQL
class CompareProductsPage extends StatelessWidget {
  const CompareProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: AppBackButton(),
        leadingWidth: 60,
        titleSpacing: 0,
        title: Text(
          'Compare Products',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, cartState) {
          if (cartState.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(cartState.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            context.read<CartBloc>().add(ClearCartMessage());
          }
          if (cartState.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(cartState.successMessage!),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            context.read<CartBloc>().add(ClearCartMessage());
          }
        },
        child: BlocConsumer<CompareBloc, CompareState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            context.read<CompareBloc>().add(const ClearCompareMessage());
          }
          if (state.errorMessage != null &&
              state.status != CompareStatus.error) {
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
            context.read<CompareBloc>().add(const ClearCompareMessage());
          }
        },
        builder: (context, state) {
          if (state.status == CompareStatus.loading &&
              state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CompareStatus.error &&
              state.items.isEmpty) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.items.isEmpty) {
            return _buildEmptyState(context);
          }

          return _CompareTable(items: state.items);
        },
      ),
        ),
      );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows_rounded,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Products to Compare',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to compare from the product detail page.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context
                  .read<CompareBloc>()
                  .add(const LoadCompareItems()),
              child: const Text(
                'Retry',
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
}

// ──────────────────────────────────────────────
// Compare Table — horizontally scrollable
// ──────────────────────────────────────────────

/// Attribute row types matching the Figma design order
enum _AttrType {
  productCard,
  sku,
  description,
  shortDescription,
  activity,
  seller,
}

const _attrLabels = <_AttrType, String>{
  _AttrType.productCard: 'Products',
  _AttrType.sku: 'SKU',
  _AttrType.description: 'Description',
  _AttrType.shortDescription: 'Short Description',
  _AttrType.activity: 'Activity',
  _AttrType.seller: 'Seller',
};

/// Width of each product column (Figma: 162px content + 20px padding each side)
const double _kProductColumnWidth = 202.0;

class _CompareTable extends StatelessWidget {
  final List<CompareItem> items;
  const _CompareTable({required this.items});

  @override
  Widget build(BuildContext context) {
    // The Figma layout: horizontally scrollable table.
    // Each "section" = a gray header row (full width) + a value row
    //   where the value row contains a horizontally scrollable row of cells.
    // The left-most column in the Figma shows labels overlaid on the first
    //   gray header column. We replicate this by making the header row show
    //   the label text, and the value row shows one cell per product.
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _AttrType.values
            .expand((attr) => [
                  _buildHeaderRow(context, attr),
                  _buildValueRow(context, attr),
                ])
            .toList(),
      ),
    );
  }

  /// Gray section header: "Products", "SKU", "Description", etc.
  Widget _buildHeaderRow(BuildContext context, _AttrType attr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: isDark ? AppColors.neutral800 : AppColors.neutral100,
      child: Text(
        _attrLabels[attr] ?? '',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
        ),
      ),
    );
  }

  /// Value row — horizontally scrollable row of product value cells
  Widget _buildValueRow(BuildContext context, _AttrType attr) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.map((item) {
            if (attr == _AttrType.productCard) {
              return _ProductCard(item: item);
            }
            return _ValueCell(item: item, attrType: attr);
          }).toList(),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Product Card (in the "Products" row)
// ──────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final CompareItem item;
  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: _kProductColumnWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Product Image (Tappable) ──
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.urlKey != null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            urlKey: item.urlKey!,
                            productName: item.productName,
                          ),
                        ),
                      );
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 162,
                    width: 162,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: item.urlKey != null
                          ? [
                              BoxShadow(
                                color: AppColors.primary500.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isDark
                            ? AppColors.neutral800
                            : const Color(0x1A0E1019),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          item.baseImageUrl != null &&
                                  item.baseImageUrl!.isNotEmpty
                              ? Image.network(
                                  item.baseImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 48,
                                      color: AppColors.neutral400,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: AppColors.neutral400,
                                  ),
                                ),
                          // View icon overlay when urlKey is available
                          if (item.urlKey != null)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.visibility_outlined,
                                        size: 18,
                                        color: AppColors.neutral800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Wishlist heart icon (top-right of image)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: _WishlistIcon(productId: item.numericId),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Product Name + Price (Tappable) ──
          GestureDetector(
            onTap: item.urlKey != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          urlKey: item.urlKey!,
                          productName: item.productName,
                        ),
                      ),
                    );
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Product Name (single line, ellipsis) ──
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                  ),
                ),

                const SizedBox(height: 7),

                // ── Price ──
                Text(
                  item.formattedPrice,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 7),

          // ── Rating Badge + Review Count ──
          _buildRatingRow(context),

          const SizedBox(height: 10),

          // ── Add to Cart + Delete ──
          _buildActionRow(context),
        ],
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = item.averageRating ?? 0;
    final reviews = item.reviewCount ?? 0;

    return Row(
      children: [
        // Green rating badge
        Container(
          padding: const EdgeInsets.only(left: 2, right: 4, top: 3, bottom: 3),
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.white),
              const SizedBox(width: 1),
              Text(
                rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 3),

        Text(
          reviews.toString(),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return BlocBuilder<CompareBloc, CompareState>(
      builder: (context, state) {
        final isProcessing = state.processingIds.contains(item.id);

        return Row(
          children: [
            // Orange "Add to Cart" pill button
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  final isAddingToCart = cartState.isAddingToCart;
                  
                  return SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: isAddingToCart
                          ? null
                          : () => _addProductToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(54),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: isAddingToCart
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 8),

            // Delete (trash) icon
            if (isProcessing)
              const SizedBox(
                width: 32,
                height: 32,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              InkWell(
                borderRadius: BorderRadius.circular(54),
                onTap: () {
                  context
                      .read<CompareBloc>()
                      .add(RemoveCompareItem(id: item.id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 24,
                    color: AppColors.neutral500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _addProductToCart(BuildContext context) {
    context.read<CartBloc>().add(
          AddToCart(
            productId: item.numericId,
            quantity: 1,
          ),
        );
  }
}

// ──────────────────────────────────────────────
// Value Cell (for text attribute rows)
// ──────────────────────────────────────────────

class _ValueCell extends StatelessWidget {
  final CompareItem item;
  final _AttrType attrType;
  const _ValueCell({required this.item, required this.attrType});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String value;
    bool isBold = false;

    switch (attrType) {
      case _AttrType.productCard:
        return const SizedBox.shrink(); // handled by _ProductCard
      case _AttrType.sku:
        value = item.sku ?? 'N/A';
        isBold = true;
        break;
      case _AttrType.description:
        value = _getDescription();
        break;
      case _AttrType.shortDescription:
        value = item.shortDescription?.isNotEmpty == true
            ? _stripHtml(item.shortDescription!)
            : 'N/A';
        break;
      case _AttrType.activity:
        value = item.attributes['Activity'] ??
            item.attributes['activity'] ??
            'N/A';
        break;
      case _AttrType.seller:
        value = item.attributes['Seller'] ??
            item.attributes['seller'] ??
            item.attributes['Brand'] ??
            item.attributes['brand'] ??
            'N/A';
        break;
    }

    return Container(
      width: _kProductColumnWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: attrType == _AttrType.sku ? 16 : 12,
      ),
      child: SizedBox(
        width: 162,
        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
            height: 1.5,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
        ),
      ),
    );
  }

  String _getDescription() {
    final desc = item.description;
    if (desc == null || desc.isEmpty) return 'N/A';
    return _stripHtml(desc);
  }

  /// Strip HTML, converting <li> to bullet points
  static String _stripHtml(String html) {
    var text = html
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'</div>'), '\n');

    text = text.replaceAll(RegExp(r'<li[^>]*>'), '• ');
    text = text.replaceAll(RegExp(r'</li>'), '\n');
    text = text.replaceAll(RegExp(r'<[^>]+>'), '');

    text = text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');

    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return text.trim();
  }
}
// ──────────────────────────────────────────────
// Wishlist Icon Widget
// ──────────────────────────────────────────────

class _WishlistIcon extends StatelessWidget {
  final int productId;
  
  const _WishlistIcon({required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistCubitState>(
      builder: (context, wishlistState) {
        final isWishlisted = wishlistState.isWishlisted(productId);
        final isProcessing = wishlistState.isProcessing(productId);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isProcessing
                ? null
                : () async {
                    try {
                      await context.read<WishlistCubit>().toggleWishlist(
                            productId: productId,
                          );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error updating wishlist: ${e.toString()}'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      }
                    }
                  },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 24,
                      color: isWishlisted
                          ? Colors.red
                          : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.neutral300
                              : AppColors.neutral500),
                    ),
            ),
          ),
        );
      },
    );
  }
}