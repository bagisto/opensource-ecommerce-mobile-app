import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/product_detail_bloc.dart';

/// Sticky bottom bar with "Add to Cart" and "Buy Now" buttons
/// Figma: navigation-bar/add-to-cart component
/// Light: neutral/50 bg | Dark: neutral/800 bg
class ProductActionBar extends StatelessWidget {
  const ProductActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<CartBloc, CartState>(
      listener: (context, cartState) {
        if (cartState.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cartState.successMessage!),
              backgroundColor: AppColors.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
          context.read<CartBloc>().add(ClearCartMessage());
        }
        if (cartState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cartState.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          context.read<CartBloc>().add(ClearCartMessage());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral50,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final isAdding = cartState.isAddingToCart;

              return Row(
                children: [
                  // ── Add to Cart (secondary) ──
                  Expanded(
                    child: GestureDetector(
                      onTap: isAdding ? null : () => _addToCart(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                          ),
                          borderRadius: BorderRadius.circular(54),
                        ),
                        alignment: Alignment.center,
                        child: isAdding
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary500,
                                ),
                              )
                            : Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary500,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ── Buy Now (primary) ──
                  Expanded(
                    child: GestureDetector(
                      onTap: isAdding ? null : () => _buyNow(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary500,
                          borderRadius: BorderRadius.circular(54),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final productState = context.read<ProductDetailBloc>().state;
    final product = productState.product;
    if (product == null) return;

    // For configurable products, check that a variant is selected
    if (product.isConfigurable) {
      final variant = productState.selectedVariant;
      if (variant == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select product options first'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // Add the variant (use variant's numeric ID)
      context.read<CartBloc>().add(
            AddToCart(
              productId: variant.numericId ?? int.tryParse(variant.id.split('/').last) ?? 0,
              quantity: productState.quantity,
            ),
          );
    } else {
      // Simple product — use product's numeric ID
      final productId =
          product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
      context.read<CartBloc>().add(
            AddToCart(
              productId: productId,
              quantity: productState.quantity,
            ),
          );
    }
  }

  void _buyNow(BuildContext context) {
    // Add to cart, then navigate to cart page on success
    _addToCart(context);

    // Listen for the cart success and navigate to the Cart tab
    late final void Function(CartState) listener;
    final cartBloc = context.read<CartBloc>();
    listener = (CartState state) {
      if (state.successMessage != null) {
        cartBloc.stream.listen((_) {}).cancel(); // clean up
        AppNavigator.navigateToCart(context);
      }
    };
    final sub = cartBloc.stream.listen(listener);
    // Auto-cancel after 10s to avoid leaks
    Future.delayed(const Duration(seconds: 10), () => sub.cancel());
  }
}
