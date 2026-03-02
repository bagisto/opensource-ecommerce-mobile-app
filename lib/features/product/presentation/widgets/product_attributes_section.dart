import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

/// Attributes section: Size swatches, Color swatches, Text swatches,
/// Quantity picker, and Wishlist/Compare/Share action row
/// Figma: Frame 1984079207
///
/// Configurable product options are derived from variants since
/// superAttributes.options returns null from the Bagisto API.
class ProductAttributesSection extends StatelessWidget {
  final ProductModel product;

  const ProductAttributesSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final configurableAttrs = product.configurableAttributes;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Configurable Attributes (derived from variants) ──
              ...configurableAttrs.map((attr) {
                // Get available values based on other selections (cascading)
                final otherSelections =
                    Map<String, String>.from(state.selectedAttributes);
                final availableValues =
                    product.getAvailableValues(attr.code, otherSelections);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildConfigurableAttributeRow(
                    context,
                    attribute: attr,
                    selectedValue: state.selectedAttributes[attr.code],
                    availableValues: availableValues,
                  ),
                );
              }),

              // ── Quantity Picker ──
              _buildQuantityPicker(context, state.quantity),

              const SizedBox(height: 16),

              // ── Wishlist / Compare / Share ──
              _buildActionRow(context),
            ],
          ),
        );
      },
    );
  }

  /// Build a row of options for a configurable attribute
  Widget _buildConfigurableAttributeRow(
    BuildContext context, {
    required ConfigurableAttribute attribute,
    String? selectedValue,
    required Set<String> availableValues,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isColor = attribute.code == 'color';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (e.g. "Select Size", "Color") — Figma: Roboto Medium 14, black
        Text(
          attribute.label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
        const SizedBox(height: 6),

        // Options
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: attribute.options.map((option) {
            final isSelected = option.value == selectedValue;
            final isAvailable = availableValues.contains(option.value);

            if (isColor && option.swatchColor != null) {
              return _buildColorSwatch(
                context,
                option: option,
                isSelected: isSelected,
                isDisabled: !isAvailable,
                attributeCode: attribute.code,
              );
            }

            return _buildTextSwatch(
              context,
              option: option,
              isSelected: isSelected,
              isDisabled: !isAvailable,
              attributeCode: attribute.code,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Text swatch (XS, S, M, L, XL, etc.)
  /// Figma node-id=135-5820:
  ///   Normal:   border-solid #E5E5E5, bg transparent, text #404040
  ///   Selected: bg #FF6900, border #FF6900, text white
  ///   Disabled: bg #F5F5F5, border-dashed #D4D4D4, text #A1A1A1
  Widget _buildTextSwatch(
    BuildContext context, {
    required ConfigurableOption option,
    required bool isSelected,
    required bool isDisabled,
    required String attributeCode,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isSelected) {
      // Figma: bg #FF6900, border #FF6900, text white
      bgColor = AppColors.primary500;
      borderColor = AppColors.primary500;
      textColor = AppColors.white;
    } else if (isDisabled) {
      // Figma: bg #F5F5F5, border-dashed #D4D4D4, text #A1A1A1
      bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;
      borderColor = isDark ? AppColors.neutral700 : AppColors.neutral300;
      textColor = isDark ? AppColors.neutral600 : AppColors.neutral400;
    } else {
      // Figma: border-solid #E5E5E5, bg transparent, text #404040
      bgColor = Colors.transparent;
      borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
      textColor = isDark ? AppColors.neutral100 : AppColors.neutral700;
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              context.read<ProductDetailBloc>().add(
                    SelectAttributeOption(
                      attributeCode: attributeCode,
                      optionId: option.value,
                    ),
                  );
            },
      child: CustomPaint(
        painter: isDisabled
            ? _DashedBorderPainter(
                color: borderColor,
                radius: 10,
                strokeWidth: 1,
              )
            : null,
        child: Container(
          constraints: const BoxConstraints(minWidth: 46),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: bgColor,
            border: isDisabled
                ? null
                : Border.all(
                    color: borderColor,
                    width: 1,
                  ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            widthFactor: 1.0,
            child: Text(
              option.value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Color swatch (square with color fill, rounded-10)
  /// Figma node-id=135-5837:
  ///   Normal:   bg={color}, border-solid #E5E5E5
  ///   Selected: bg={color}, inner white border-4, outer dark border
  ///   Disabled: bg={color} with 50% white overlay, border-dashed #E5E5E5
  Widget _buildColorSwatch(
    BuildContext context, {
    required ConfigurableOption option,
    required bool isSelected,
    required bool isDisabled,
    required String attributeCode,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _parseColor(option.swatchColor ?? '#000000');

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              context.read<ProductDetailBloc>().add(
                    SelectAttributeOption(
                      attributeCode: attributeCode,
                      optionId: option.value,
                    ),
                  );
            },
      child: isDisabled
          ? CustomPaint(
              painter: _DashedBorderPainter(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                radius: 10,
                strokeWidth: 1,
              ),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    Colors.white.withAlpha(128),
                    color,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : isSelected
              // Selected: white inner border + dark outer border (stacked)
              ? Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                )
              // Normal: color fill, solid border
              : Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
    );
  }

  /// Quantity picker with minus / count / plus
  Widget _buildQuantityPicker(BuildContext context, int quantity) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.neutral500 : AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // Minus
            GestureDetector(
              onTap: () {
                if (quantity > 1) {
                  context
                      .read<ProductDetailBloc>()
                      .add(UpdateQuantity(quantity - 1));
                }
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: 20,
                  color:
                      isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Count
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '$quantity ${quantity == 1 ? 'Unit' : 'Units'}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color:
                      isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Plus
            GestureDetector(
              onTap: () {
                context
                    .read<ProductDetailBloc>()
                    .add(UpdateQuantity(quantity + 1));
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color:
                      isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Wishlist / Compare / Share action row
  Widget _buildActionRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productId = product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;

    return BlocBuilder<WishlistCubit, WishlistCubitState>(
      builder: (context, wishlistState) {
        final isWishlisted = productId != 0 && wishlistState.isWishlisted(productId);
        final isProcessing = productId != 0 && wishlistState.isProcessing(productId);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildActionItem(
                context,
                icon: isWishlisted ? Icons.favorite : Icons.favorite_border,
                iconColor: isWishlisted ? Colors.red : (isDark ? AppColors.neutral200 : AppColors.neutral900),
                label: 'Wishlist',
                isDark: isDark,
                isLoading: isProcessing,
                onTap: isProcessing ? null : () => _toggleWishlist(context, productId),
              ),
              _buildActionItem(
                context,
                icon: Icons.compare_arrows,
                label: 'Compare',
                isDark: isDark,
                onTap: () => _addToCompare(context),
              ),
              _buildActionItem(
                context,
                icon: Icons.share_outlined,
                label: 'Share',
                isDark: isDark,
                onTap: () => _shareProduct(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String label,
    required bool isDark,
    bool isLoading = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary500,
                      ),
                    )
                  : Icon(
                      icon,
                      size: 24,
                      color: iconColor ?? (isDark ? AppColors.neutral200 : AppColors.neutral900),
                    ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleWishlist(BuildContext context, int productId) async {
    if (productId == 0) return;

    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(productId: productId);
      
      if (context.mounted) {
        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to wishlist'),
              backgroundColor: AppColors.successGreen,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (result == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from wishlist'),
              backgroundColor: AppColors.successGreen,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // result == null means authentication required
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to manage wishlist'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update wishlist: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _addToCompare(BuildContext context) async {
    final productState = context.read<ProductDetailBloc>().state;
    final product = productState.product;
    if (product == null) return;

    // Get product ID
    final productId = product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId == 0) return;

    try {
      // Get authenticated client
      final accessToken = await AuthStorage.getToken();
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to add to compare'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }
      
      final client = GraphQLClientProvider.authenticatedClient(accessToken).value;
      final accountRepo = AccountRepository(client: client);
      await accountRepo.addToCompare(productId: productId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to compare'),
            backgroundColor: AppColors.successGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to compare: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _shareProduct(BuildContext context) {
    final productState = context.read<ProductDetailBloc>().state;
    final product = productState.product;
    if (product == null) return;

    // Build share text and URL
    final String shareText;
    final String shareUrl = 'https://api-demo.bagisto.com/${product.urlKey ?? 'https://api-demo.bagisto.com'}';
    
    // if (product.price != null && product.price! > 0) {
    //   shareText = '${product.name}\nPrice: \${product.price!.toStringAsFixed(2)}\n$shareUrl';
    // } else {
    //   shareText = '${product.name}\n$shareUrl';
    // }

    // Use share_plus to share the product
    Share.share(shareUrl, subject: product.name);
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return AppColors.neutral400;
  }
}

/// Custom painter that draws a dashed rounded-rect border.
/// Used for disabled swatches to match Figma's border-dashed style.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    this.radius = 10,
    this.strokeWidth = 1,
    this.dashWidth = 4,
    this.dashGap = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashWidth, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance = end + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      radius != oldDelegate.radius ||
      strokeWidth != oldDelegate.strokeWidth;
}
