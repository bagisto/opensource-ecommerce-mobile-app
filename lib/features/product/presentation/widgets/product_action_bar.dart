import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/store_config/store_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../category/data/models/product_model.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/models/customizable_file_selection.dart';
import '../bloc/product_detail_bloc.dart';

/// Sticky bottom bar with "Add to Cart" and "Buy Now" buttons
/// Figma: navigation-bar/add-to-cart component
/// Light: neutral/50 bg | Dark: neutral/800 bg
class ProductActionBar extends StatelessWidget {
  const ProductActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cart page off in admin: no Add to Cart / Buy Now at all.
    if (!StoreConfig.of(context).showCartPage) return const SizedBox.shrink();

    return BlocListener<CartBloc, CartState>(
      listener: (context, cartState) {
        if (ModalRoute.of(context)?.isCurrent != true) return;

        if (cartState.successMessage != null) {
          final message = _localizedCartMessage(
            context,
            cartState.successMessage!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
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
              // Out of stock: both actions dimmed and disabled, like the web.
              final isOutOfStock = context.select<ProductDetailBloc, bool>(
                (bloc) => bloc.state.isOutOfStock,
              );
              final disabledColor = isDark
                  ? AppColors.neutral600
                  : AppColors.neutral400;
              final showBuyNow = StoreConfig.of(context).showBuyNow;

              return Row(
                children: [
                  // ── Add to Cart (secondary) ──
                  Expanded(
                    child: GestureDetector(
                      onTap: isAdding || isOutOfStock
                          ? null
                          : () => _addToCart(context),
                      child: Container(
                        key: isOutOfStock
                            ? const ValueKey('product_add_to_cart_disabled')
                            : null,
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
                                l10n.productAddToCart,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isOutOfStock
                                      ? disabledColor
                                      : AppColors.primary500,
                                ),
                              ),
                      ),
                    ),
                  ),

                  if (showBuyNow) ...[
                  const SizedBox(width: 16),

                  // ── Buy Now (primary) ──
                  Expanded(
                    child: GestureDetector(
                      onTap: isAdding || isOutOfStock
                          ? null
                          : () => _buyNow(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? disabledColor
                              : AppColors.primary500,
                          borderRadius: BorderRadius.circular(54),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.productBuyNow,
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

    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;

    final customizableOptions = _buildCustomizableOptionsPayload(
      context: context,
      product: product,
      selections: productState.customizableOptionValues,
    );
    if (customizableOptions == null) return;

    if (product.isGrouped) {
      final groupedItems = product.groupedProducts
          .map((groupedProduct) {
            final qty = productState.groupedQuantities[groupedProduct.id] ?? 0;
            final associatedProductId = _resolveProductId(
              groupedProduct.associatedProduct?.numericId,
              groupedProduct.associatedProduct?.id,
            );

            if (qty <= 0 || associatedProductId <= 0) return null;
            return {'productId': associatedProductId, 'quantity': qty};
          })
          .whereType<Map<String, int>>()
          .toList();

      if (groupedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter quantity for at least one item"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      context.read<CartBloc>().add(
        AddToCart(
          productId: productId,
          quantity: 1,
          groupedItems: groupedItems,
          customizableOptions: customizableOptions,
        ),
      );
    } else if (product.isBooking) {
      final booking = product.bookingProducts.isNotEmpty
          ? product.bookingProducts.first
          : null;
      if (booking == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking configuration is missing"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final bookingPayload = _buildBookingPayload(
        context: context,
        booking: booking,
        form: productState.bookingForm,
        ticketQuantities: productState.bookingTicketQuantities,
      );

      if (bookingPayload == null) {
        return;
      }

      context.read<CartBloc>().add(
        AddToCart(
          productId: productId,
          quantity: 1,
          bookingData: bookingPayload,
          customizableOptions: customizableOptions,
        ),
      );
    } else if (product.isBundle) {
      final selectedOptions = productState.selectedBundleOptions;
      final selectedQuantities = productState.bundleOptionQuantities;

      for (final option in product.bundleOptions) {
        final selections = selectedOptions[option.id] ?? const <String>[];
        if (option.isRequired && selections.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${option.label ?? 'Bundle option'} is required'),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
      }

      final bundleOptions = <Map<String, dynamic>>[];
      for (final option in product.bundleOptions) {
        final selections = selectedOptions[option.id] ?? const <String>[];
        if (selections.isEmpty) continue;

        final optionId = _resolveProductId(null, option.id);
        if (optionId <= 0) continue;

        for (final selectionId in selections) {
          final matches = option.bundleOptionProducts
              .where((item) => item.id == selectionId)
              .toList();
          final selectedProduct = matches.isNotEmpty ? matches.first : null;

          if (selectedProduct == null) continue;
          final selectionNumericId = _resolveProductId(null, selectionId);
          if (selectionNumericId <= 0) continue;

          final qty =
              selectedQuantities[selectionId] ??
              ((selectedProduct.qty ?? 1) > 0 ? (selectedProduct.qty ?? 1) : 1);

          bundleOptions.add({
            'bundleOptionId': optionId,
            'bundleOptionProductId': [selectionNumericId],
            'qty': qty,
          });
        }
      }

      if (bundleOptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one bundle option"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      context.read<CartBloc>().add(
        AddToCart(
          productId: productId,
          quantity: 1,
          bundleOptions: bundleOptions,
          customizableOptions: customizableOptions,
        ),
      );
    } else if (product.isConfigurable) {
      // New API: use combinations + superAttribute
      final variantId = productState.selectedVariantId;
      if (variantId == null) {
        // Fallback: try legacy variant
        final variant = productState.selectedVariant;
        if (variant == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.productSelectOptionsFirst,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        // Legacy: send variant ID as productId
        final variantNumericId =
            variant.numericId ?? int.tryParse(variant.id.split('/').last) ?? 0;
        context.read<CartBloc>().add(
          AddToCart(
            productId: variantNumericId,
            quantity: productState.quantity,
            customizableOptions: customizableOptions,
          ),
        );
        return;
      }

      // Build superAttribute from combinations using numeric attribute IDs
      // expected by the cart API: [{23: 5}, {24: 7}]
      final superAttribute = <Map<String, dynamic>>[];
      final combination = product.getCombinationForVariant(variantId);
      if (combination != null) {
        for (final entry in combination.entries) {
          final attributeId = product.getConfigurableAttributeId(entry.key);
          final attributeKey = attributeId?.toString() ?? entry.key;
          superAttribute.add({
            attributeKey: entry.value is int
                ? entry.value
                : (int.tryParse(entry.value.toString()) ?? entry.value),
          });
        }
      }

      context.read<CartBloc>().add(
        AddToCart(
          productId: productId, // Parent configurable product ID
          quantity: productState.quantity,
          selectedConfigurableOption: variantId,
          superAttribute: superAttribute,
          customizableOptions: customizableOptions,
        ),
      );
    } else if (product.type == 'downloadable') {
      // Validation for downloadable products
      if (product.downloadableLinks.isNotEmpty &&
          productState.selectedDownloadableLinks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.productSelectDownloadLink,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      // Get integer IDs for selected links
      final selectedLinkIds = productState.selectedDownloadableLinks.map((id) {
        final link = product.downloadableLinks.firstWhere((l) => l.id == id);
        return (link.numericId ?? int.tryParse(link.id.split('/').last) ?? 0)
            .toString();
      }).toList();

      context.read<CartBloc>().add(
        AddToCart(
          productId: productId,
          quantity: productState.quantity,
          downloadableLinks: selectedLinkIds,
          customizableOptions: customizableOptions,
        ),
      );
    } else {
      // Simple or Virtual
      context.read<CartBloc>().add(
        AddToCart(
          productId: productId,
          quantity: productState.quantity,
          customizableOptions: customizableOptions,
        ),
      );
    }
  }

  Map<String, dynamic>? _buildCustomizableOptionsPayload({
    required BuildContext context,
    required ProductModel product,
    required Map<String, dynamic> selections,
  }) {
    if (product.customizableOptions.isEmpty) return const {};

    final payload = <String, dynamic>{};

    for (final option in product.customizableOptions) {
      final optionId = _resolveProductId(option.numericId, option.id);
      if (optionId <= 0) continue;

      final value = selections[option.id];
      final hasValue = _hasCustomizableOptionValue(value);
      final type = option.normalizedType;

      if (type == 'file') {
        if (option.isRequired && !hasValue) {
          _showSnackBar(context, '${option.displayLabel} is required');
          return null;
        }

        if (!hasValue) continue;

        if (value is! CustomizableFileSelection) {
          _showSnackBar(context, 'Please select ${option.displayLabel}');
          return null;
        }

        if (!value.isAllowedBy(option.supportedFileExtensionList)) {
          _showSnackBar(
            context,
            'Please select ${option.supportedFileExtensionList.join(', ')} file',
          );
          return null;
        }

        payload[optionId.toString()] = [value];
        continue;
      }

      if (option.isRequired && !hasValue) {
        _showSnackBar(context, '${option.displayLabel} is required');
        return null;
      }

      if (!hasValue) continue;

      if (option.hasChoicePrices) {
        final selectedValues = value is List
            ? value.map((item) => item.toString()).toList()
            : <String>[value.toString()];

        final selectedPriceIds = selectedValues
            .map((id) => _resolveCustomizablePriceId(option, id))
            .where((id) => id > 0)
            .toList();

        if (option.isRequired && selectedPriceIds.isEmpty) {
          _showSnackBar(context, '${option.displayLabel} is required');
          return null;
        }

        if (selectedPriceIds.isNotEmpty) {
          payload[optionId.toString()] = selectedPriceIds;
        }
        continue;
      }

      payload[optionId.toString()] = [value.toString().trim()];
    }

    return payload;
  }

  bool _hasCustomizableOptionValue(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is List) return value.isNotEmpty;
    return true;
  }

  int _resolveCustomizablePriceId(
    ProductCustomizableOption option,
    String selectedId,
  ) {
    for (final price in option.prices) {
      if (price.id == selectedId || price.numericId?.toString() == selectedId) {
        return _resolveProductId(price.numericId, price.id);
      }
    }

    return int.tryParse(selectedId.split('/').last) ?? 0;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Map<String, dynamic>? _buildBookingPayload({
    required BuildContext context,
    required BookingProductData booking,
    required Map<String, dynamic> form,
    required Map<String, int> ticketQuantities,
  }) {
    final type = (booking.type ?? '').toLowerCase().trim();

    if (type == 'event') {
      final qty = ticketQuantities.entries
          .where((entry) => entry.value > 0)
          .map((entry) {
            final ticket = booking.eventTickets
                .where((t) => t.id == entry.key)
                .toList();
            final ticketId = ticket.isNotEmpty
                ? (ticket.first.numericId ?? int.tryParse(ticket.first.id) ?? 0)
                : 0;
            if (ticketId <= 0) return null;
            return <String, dynamic>{
              'ticketId': ticketId,
              'quantity': entry.value,
            };
          })
          .whereType<Map<String, dynamic>>()
          .toList();
      if (qty.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one ticket"),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
      return {
        'type': 'event',
        'qty': {
          for (final item in qty)
            '${item['ticketId']}': (item['quantity'] as int?) ?? 0,
        },
      };
    }

    final date = form['date']?.toString().trim();
    final slot = form['slot']?.toString().trim();
    if (type == 'default' || type == 'appointment' || type == 'table') {
      if ((date ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a booking date"),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
      if ((slot ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an available time slot"),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
      final payload = <String, dynamic>{
        'type': type,
        'date': date,
        'slot': slot,
      };
      if (type == 'table') {
        final note = form['note']?.toString().trim() ?? '';
        if (note.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please enter special request or notes"),
              duration: Duration(seconds: 2),
            ),
          );
          return null;
        }
        payload['specialNote'] = note;
      }
      return payload;
    }

    if (type == 'rental') {
      final rentingType =
          (form['rentingType']?.toString().toLowerCase() ?? 'daily');
      if (rentingType == 'daily') {
        final dateFrom = form['dateFrom']?.toString().trim();
        final dateTo = form['dateTo']?.toString().trim();
        if ((dateFrom ?? '').isEmpty || (dateTo ?? '').isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please select rental start and end date"),
              duration: Duration(seconds: 2),
            ),
          );
          return null;
        }
        return {
          'type': 'rental',
          'renting_type': 'daily',
          'date_from': dateFrom,
          'date_to': dateTo,
        };
      }

      if ((date ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a rental date"),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
      if ((slot ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a rental time slot"),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
      return {
        'type': 'rental',
        'date': date,
        'slot': slot,
        'renting_type': 'hourly',
      };
    }

    return null;
  }

  int _resolveProductId(int? numericId, String? graphId) {
    if (numericId != null && numericId > 0) return numericId;
    if (graphId == null || graphId.isEmpty) return 0;
    return int.tryParse(graphId.split('/').last) ?? 0;
  }

  String _localizedCartMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    switch (message) {
      case 'Product added to cart successfully':
        return l10n.cartAddedToCartSuccess;
      default:
        return message;
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
