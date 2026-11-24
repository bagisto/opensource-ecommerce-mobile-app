import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';

/// Renders payment method logo matching Bagisto web storefront defaults.
///
/// If a custom icon URL is provided, it tries to load that image with fallback
/// to the default branded logo based on method code/title. If neither matches,
/// falls back to a clean payment icon.
class PaymentMethodLogo extends StatelessWidget {
  final String code;
  final String? title;
  final String? iconUrl;
  final double width;
  final double height;

  const PaymentMethodLogo({
    super.key,
    required this.code,
    this.title,
    this.iconUrl,
    this.width = 56,
    this.height = 40,
  });

  /// Maps a payment method code/title to a local asset path if one exists.
  static String? defaultLogoAsset(String? code, [String? title]) {
    final cleanCode =
        (code ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final cleanTitle =
        (title ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    bool matches(String term) =>
        cleanCode.contains(term) || cleanTitle.contains(term);

    if (matches('paypal')) {
      return 'assets/images/paypal.png';
    }
    if (matches('stripe')) {
      return 'assets/images/stripe.png';
    }
    if (matches('razorpay')) {
      return 'assets/images/razorpay.png';
    }
    if (matches('payu')) {
      return 'assets/images/payu.png';
    }
    if (matches('phonepe')) {
      return 'assets/images/phonepe.png';
    }
    if (matches('cashondelivery') || cleanCode == 'cod' || cleanTitle == 'cod') {
      return 'assets/images/cash-on-delivery.png';
    }
    if (matches('moneytransfer') || matches('banktransfer')) {
      return 'assets/images/money-transfer.png';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultAsset = defaultLogoAsset(code, title);

    Widget imageWidget;
    final trimmedIconUrl = iconUrl?.trim();
    if (trimmedIconUrl != null && trimmedIconUrl.isNotEmpty) {
      final fullUrl = trimmedIconUrl.startsWith('http')
          ? trimmedIconUrl
          : '${ApiEnv.base}/${trimmedIconUrl.startsWith('/') ? trimmedIconUrl.substring(1) : trimmedIconUrl}';
      imageWidget = Image.network(
        fullUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildAssetOrFallback(defaultAsset, isDark),
      );
    } else {
      imageWidget = _buildAssetOrFallback(defaultAsset, isDark);
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral300,
          width: 0.8,
        ),
      ),
      child: Center(child: imageWidget),
    );
  }

  Widget _buildAssetOrFallback(String? defaultAsset, bool isDark) {
    if (defaultAsset != null) {
      return Image.asset(
        defaultAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildFallbackIcon(code, isDark),
      );
    }
    return _buildFallbackIcon(code, isDark);
  }

  static Widget _buildFallbackIcon(String code, bool isDark) {
    IconData iconData;
    Color iconColor;

    final normalized =
        code.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (normalized.contains('paypal')) {
      iconData = Icons.paypal;
      iconColor = const Color(0xFF003087);
    } else if (normalized.contains('cashondelivery') || normalized == 'cod') {
      iconData = Icons.local_atm;
      iconColor = const Color(0xFF2E7D32);
    } else if (normalized.contains('moneytransfer') ||
        normalized.contains('banktransfer')) {
      iconData = Icons.account_balance;
      iconColor = const Color(0xFF1565C0);
    } else {
      iconData = Icons.payment;
      iconColor = AppColors.neutral800;
    }

    return Icon(iconData, size: 22, color: iconColor);
  }
}
