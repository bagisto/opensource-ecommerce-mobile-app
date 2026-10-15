import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';
import 'product_booking_options_section.dart';
import 'product_bundle_options_section.dart';
import 'product_customizable_options_section.dart';
import 'product_grouped_products_section.dart';
import '../../../../core/store_config/store_config.dart';

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
        final isGrouped = product.isGrouped;
        final isBundle = product.isBundle;
        final isBooking = product.isBooking;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGrouped) ...[
                ProductGroupedProductsSection(product: product),
              ] else if (isBundle) ...[
                ProductBundleOptionsSection(product: product),
              ] else if (isBooking) ...[
                ProductBookingOptionsSection(product: product),
              ] else ...[
                // ── Configurable Attributes (derived from variants) ──
                ...configurableAttrs.map((attr) {
                  // Get available values based on other selections (cascading)
                  final otherSelections = Map<String, String>.from(
                    state.selectedAttributes,
                  );
                  final availableValues = product.getAvailableValues(
                    attr.code,
                    otherSelections,
                  );

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
              ],

              if (product.customizableOptions.isNotEmpty) ...[
                const SizedBox(height: 24),
                ProductCustomizableOptionsSection(product: product),
              ],

              if (product.isDownloadable &&
                  !isGrouped &&
                  !isBundle &&
                  !isBooking) ...[
                const SizedBox(height: 24),
                _buildDownloadableOptions(context, state),
              ],

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
            final isSelected = option.selectionId == selectedValue;
            final isAvailable = availableValues.contains(option.selectionId);

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
                  optionId: option.selectionId,
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
                : Border.all(color: borderColor, width: 1),
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
                  optionId: option.selectionId,
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
                  color: Color.alphaBlend(Colors.white.withAlpha(128), color),
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
                  border: Border.all(color: AppColors.white, width: 3),
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productQuantity,
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
                  context.read<ProductDetailBloc>().add(
                    UpdateQuantity(quantity - 1),
                  );
                }
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: 20,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
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
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '$quantity ${quantity == 1 ? l10n.cartUnit : l10n.cartUnits}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Plus
            GestureDetector(
              onTap: () {
                context.read<ProductDetailBloc>().add(
                  UpdateQuantity(quantity + 1),
                );
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;

    return BlocBuilder<WishlistCubit, WishlistCubitState>(
      builder: (context, wishlistState) {
        final isWishlisted =
            productId != 0 && wishlistState.isWishlisted(productId);
        final isProcessing =
            productId != 0 && wishlistState.isProcessing(productId);
        final config = StoreConfig.of(context);
        if (!config.showWishlist &&
            !config.showCompare &&
            !config.showSocialShare) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (config.showWishlist)
              _buildActionItem(
                context,
                icon: isWishlisted ? Icons.favorite : Icons.favorite_border,
                iconColor: isWishlisted
                    ? Colors.red
                    : (isDark ? AppColors.neutral200 : AppColors.neutral900),
                label: l10n.productWishlistAction,
                isDark: isDark,
                isLoading: isProcessing,
                onTap: isProcessing
                    ? null
                    : () => _toggleWishlist(context, productId),
              ),
              if (config.showCompare)
              _buildActionItem(
                context,
                icon: Icons.compare_arrows,
                label: l10n.productCompareAction,
                isDark: isDark,
                onTap: () => _addToCompare(context),
              ),
              if (config.showSocialShare)
              _buildActionItem(
                context,
                icon: Icons.share_outlined,
                label: l10n.productShareAction,
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
                      color:
                          iconColor ??
                          (isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900),
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
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );

      if (context.mounted) {
        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.homeAddedToWishlist),
              backgroundColor: AppColors.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (result == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.homeRemovedFromWishlist,
              ),
              backgroundColor: AppColors.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // result == null means authentication required
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.homeLoginToManageWishlist,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorMapper.getUserMessage(e, context: 'updating wishlist'),
            ),
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
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId == 0) return;

    try {
      // Get authenticated client
      final accessToken = await AuthStorage.getToken();
      if (accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.productLoginToCompare,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final client = GraphQLClientProvider.authenticatedClient(
        accessToken,
      ).value;
      final accountRepo = AccountRepository(client: client);
      await accountRepo.addToCompare(productId: productId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.productAddedToCompare),
            backgroundColor: AppColors.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorMapper.getUserMessage(e, context: 'adding to compare'),
            ),
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
    final base = Uri.parse(bagistoEndpoint).origin;
    final String shareUrl = '$base/${product.urlKey ?? ''}';

    // Use share_plus to share the product
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareUrl,
      subject: product.name,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : Rect.zero,
    );
  }

  Widget _buildDownloadableOptions(
    BuildContext context,
    ProductDetailState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.downloadableLinks.isNotEmpty) ...[
          Text(
            l10n.productDownloadableLinks,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.neutral200 : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...product.downloadableLinks.map((link) {
            final isSelected = state.selectedDownloadableLinks.contains(
              link.id,
            );
            return GestureDetector(
              onTap: () {
                context.read<ProductDetailBloc>().add(
                  SelectDownloadableLink(link.id),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary500
                              : (isDark
                                    ? AppColors.neutral600
                                    : AppColors.neutral300),
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: isSelected ? AppColors.primary500 : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            link.title ?? '',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral800,
                            ),
                          ),
                          if ((link.sampleFileUrl ?? '').trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                _downloadProductSampleFile(
                                  context,
                                  fileUrl: link.sampleFileUrl,
                                  fileName:
                                      '${link.title ?? 'sample_${link.numericId}'}_sample',
                                );
                              },
                              child: Text(
                                l10n.productDownloadSample,
                                style: AppTextStyles.text6(context).copyWith(
                                  color: AppColors.primary500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if ((link.displayPriceLabel ?? '').isNotEmpty)
                      const SizedBox(width: 12),
                    if ((link.displayPriceLabel ?? '').isNotEmpty)
                      Text(
                        '+ ${link.displayPriceLabel}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary500,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
        if (product.downloadableSamples.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.productDownloadableSamples,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.neutral200 : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...product.downloadableSamples.map((sample) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sample.title ?? '',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _downloadProductSampleFile(
                        context,
                        fileUrl: sample.fileUrl,
                        fileName: sample.title ?? 'sample_${sample.numericId}',
                      );
                    },
                    child: Text(
                      l10n.productDownloadSample,
                      style: AppTextStyles.text6(context).copyWith(
                        color: AppColors.primary500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _downloadProductSampleFile(
    BuildContext context, {
    required String? fileUrl,
    required String fileName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final resolvedDownloadUrl = _resolveDownloadUrl(fileUrl?.trim() ?? '');

    if (resolvedDownloadUrl.isEmpty) {
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Download failed: sample file URL is missing'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.accountDownloadWillStartShortly)),
            ],
          ),
          duration: const Duration(seconds: 30),
          behavior: SnackBarBehavior.floating,
        ),
      );

    try {
      final token = await AuthStorage.getToken();
      final dir = await getApplicationDocumentsDirectory();
      final sanitizedName = _sanitizeFileName(
        _resolvedSampleFileName(fileName, resolvedDownloadUrl),
      );
      final savePath = '${dir.path}/$sanitizedName';
      final requestHeaders = <String, String>{
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        'X-STOREFRONT-KEY': storefrontKey,
      };

      _logSampleDownload('═══════════════════════════════════════════');
      _logSampleDownload('📦 [Product Sample Download Request]');
      _logSampleDownload('🔗 URL: $resolvedDownloadUrl');
      _logSampleDownload('🧾 File Name: $sanitizedName');
      _logSampleDownload('💾 Save Path: $savePath');
      _logSampleDownload(
        '📋 Headers: ${_maskSensitiveHeaders(requestHeaders)}',
      );

      final dio = Dio();
      final response = await dio.download(
        resolvedDownloadUrl,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          receiveDataWhenStatusError: true,
          headers: requestHeaders,
          followRedirects: true,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      _logSampleDownload('✅ [Product Sample Download Response]');
      _logSampleDownload('🔢 Status Code: $statusCode');
      _logSampleDownload('📋 Response Headers: ${response.headers.map}');
      _logSampleDownload('📍 Real URI: ${response.realUri}');
      _logSampleDownload('═══════════════════════════════════════════');

      if (statusCode < 200 || statusCode >= 300) {
        throw DioException.badResponse(
          statusCode: statusCode,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      final finalSavePath = await _normalizeDownloadedFilePath(
        initialSavePath: savePath,
        response: response,
      );

      if (!context.mounted) return;

      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('$sanitizedName downloaded'),
            backgroundColor: AppColors.success500,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () => OpenFilex.open(finalSavePath),
            ),
          ),
        );
    } catch (e) {
      if (!context.mounted) return;

      final message = e is DioException
          ? _sampleDioErrorMessage(e)
          : e.toString();

      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Download failed: $message'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  String _resolveDownloadUrl(String downloadUrl) {
    if (downloadUrl.isEmpty) {
      return '';
    }

    final uri = Uri.tryParse(downloadUrl);
    if (uri == null) {
      return downloadUrl;
    }

    if (uri.hasScheme && uri.host.isNotEmpty) {
      return downloadUrl;
    }

    final baseUri = Uri.parse(bagistoEndpoint);
    return baseUri.resolveUri(uri).toString();
  }

  String _resolvedSampleFileName(String fileName, String downloadUrl) {
    final trimmedName = fileName.trim();
    final parsedUrl = Uri.tryParse(downloadUrl);
    final urlFileName = parsedUrl != null && parsedUrl.pathSegments.isNotEmpty
        ? parsedUrl.pathSegments.last
        : '';

    final urlExtension = urlFileName.contains('.')
        ? urlFileName.substring(urlFileName.lastIndexOf('.'))
        : '';

    if (trimmedName.isEmpty) {
      if (urlFileName.isNotEmpty) {
        return urlFileName;
      }
      return urlExtension.isNotEmpty ? 'sample$urlExtension' : 'sample_file';
    }

    final hasExtension = trimmedName.contains('.');
    if (hasExtension || urlExtension.isEmpty) {
      return trimmedName;
    }

    return '$trimmedName$urlExtension';
  }

  String _sanitizeFileName(String fileName) {
    final sanitized = fileName.replaceAll(RegExp(r'[^\w\s\-.]'), '_').trim();
    return sanitized.isEmpty ? 'sample_file' : sanitized;
  }

  Future<String> _normalizeDownloadedFilePath({
    required String initialSavePath,
    required Response<dynamic> response,
  }) async {
    final currentExtension = _extensionFromPath(initialSavePath);
    if (currentExtension.isNotEmpty) {
      return initialSavePath;
    }

    final inferredExtension = _inferExtensionFromResponse(response);
    if (inferredExtension.isEmpty) {
      return initialSavePath;
    }

    final renamedPath = '$initialSavePath$inferredExtension';
    final file = File(initialSavePath);
    if (!await file.exists()) {
      return initialSavePath;
    }

    final renamedFile = await file.rename(renamedPath);
    return renamedFile.path;
  }

  String _inferExtensionFromResponse(Response<dynamic> response) {
    final contentTypeHeader = response.headers.value(Headers.contentTypeHeader);
    final normalizedContentType = contentTypeHeader?.split(';').first.trim();
    final contentTypeExtension = switch (normalizedContentType) {
      'application/pdf' => '.pdf',
      'image/png' => '.png',
      'image/jpeg' => '.jpg',
      'image/jpg' => '.jpg',
      'image/webp' => '.webp',
      _ => '',
    };

    if (contentTypeExtension.isNotEmpty) {
      return contentTypeExtension;
    }

    final realUri = response.realUri;
    return _extensionFromPath(realUri.path);
  }

  String _extensionFromPath(String path) {
    final sanitizedPath = path.split('?').first;
    final lastSlash = sanitizedPath.lastIndexOf('/');
    final fileName = lastSlash >= 0
        ? sanitizedPath.substring(lastSlash + 1)
        : sanitizedPath;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return '';
    }

    return fileName.substring(dotIndex).toLowerCase();
  }

  String _sampleDioErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    _logSampleDownload('❌ [Product Sample Download Error]');
    _logSampleDownload('🔗 URL: ${error.requestOptions.uri}');
    _logSampleDownload(
      '📋 Request Headers: ${_maskSensitiveHeaders(error.requestOptions.headers)}',
    );
    _logSampleDownload('🔢 Status Code: $statusCode');
    _logSampleDownload('📋 Response Headers: ${error.response?.headers.map}');
    _logSampleDownload('📦 Response Body: ${_truncateForLog(responseData)}');
    _logSampleDownload('⚠️ Dio Message: ${error.message}');
    _logSampleDownload('═══════════════════════════════════════════');

    if (statusCode == 401) {
      return 'Unauthorized. Please log in again.';
    }

    if (statusCode == 403) {
      return 'You cannot download this sample.';
    }

    if (statusCode == 429) {
      return 'Rate limit exceeded. Please wait a moment and try again.';
    }

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return error.message ?? 'Unknown error';
  }

  Map<String, dynamic> _maskSensitiveHeaders(Map<dynamic, dynamic> headers) {
    return headers.map((key, value) {
      final headerKey = key.toString();
      final lowerKey = headerKey.toLowerCase();
      if (lowerKey == 'authorization') {
        return MapEntry(headerKey, _maskBearerToken(value?.toString() ?? ''));
      }
      if (lowerKey == 'x-storefront-key') {
        return MapEntry(headerKey, _maskValue(value?.toString() ?? ''));
      }
      return MapEntry(headerKey, value);
    });
  }

  String _maskBearerToken(String rawValue) {
    if (!rawValue.startsWith('Bearer ')) {
      return _maskValue(rawValue);
    }

    final token = rawValue.substring(7);
    return 'Bearer ${_maskValue(token)}';
  }

  String _maskValue(String value) {
    if (value.length <= 8) {
      return '***';
    }

    return '${value.substring(0, 4)}***${value.substring(value.length - 4)}';
  }

  String _truncateForLog(dynamic data) {
    final text = data?.toString() ?? 'null';
    if (text.length <= 1500) {
      return text;
    }

    return '${text.substring(0, 1500)}...';
  }

  void _logSampleDownload(String message) {
    debugPrint(message);
    // ignore: avoid_print
    print(message);
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
