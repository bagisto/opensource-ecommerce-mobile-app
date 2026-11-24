import 'package:flutter/material.dart';

import '../../../../core/store_config/store_config.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

/// Applies the storefront and product guest-checkout rules before checkout.
class CheckoutAccessGuard {
  const CheckoutAccessGuard._();

  static Future<bool> ensureGuestCheckoutAllowed(
    BuildContext context,
    CartBloc cartBloc,
  ) async {
    if (!StoreConfig.of(context, listen: false).allowGuestCheckout) {
      _sendGuestToLogin(context);
      return false;
    }

    final productIds = cartBloc.state.cart.items
        .map((item) => item.productId)
        .where((id) => id > 0);
    try {
      final allowed = await cartBloc.repository.guestCheckoutAllowed(
        productIds,
      );
      if (allowed || !context.mounted) return allowed;
      _sendGuestToLogin(context);
      return false;
    } catch (error) {
      // The checkout endpoint still validates guest access if this lookup fails.
      debugPrint('[CheckoutAccessGuard] guest checkout check failed: $error');
      return true;
    }
  }

  static void _sendGuestToLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.cartGuestCheckoutNotAllowed,
        ),
      ),
    );
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}
