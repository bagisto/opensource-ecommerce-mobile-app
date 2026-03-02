import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';
import 'section_header.dart';

/// Default Addresses section (Billing + Shipping)
/// Figma: node-id=220-7109
class DefaultAddressesSection extends StatelessWidget {
  final List<CustomerAddress> addresses;
  final VoidCallback? onViewAll;

  const DefaultAddressesSection({
    super.key,
    required this.addresses,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    // Find default billing and shipping addresses
    CustomerAddress? billingAddress;
    CustomerAddress? shippingAddress;

    for (final address in addresses) {
      if (address.isDefault) {
        billingAddress ??= address;
        if (billingAddress != address) {
          shippingAddress ??= address;
        }
      }
    }

    // If no default addresses found, use first two
    if (billingAddress == null && addresses.isNotEmpty) {
      billingAddress = addresses.first;
    }
    if (shippingAddress == null && addresses.length > 1) {
      shippingAddress = addresses[1];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Default Addresses',
              onViewAll: addresses.isNotEmpty
                  ? onViewAll
                  : null,
            ),
          ),
          const SizedBox(height: 2),
          if (addresses.isEmpty)
            _buildEmptyState(context)
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (billingAddress != null)
                    _buildAddressCard(
                      context,
                      address: billingAddress,
                      type: 'Billing Address',
                    ),
                  if (shippingAddress != null) ...[
                    const SizedBox(height: 8),
                    _buildAddressCard(
                      context,
                      address: shippingAddress,
                      type: 'Shipping Address',
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        child: Center(
          child: Text(
            'No saved addresses',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context, {
    required CustomerAddress address,
    required String type,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address type + Default badge
          Row(
            children: [
              Text(
                type,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDark
                      ? AppColors.neutral300
                      : AppColors.neutral900,
                ),
              ),
              if (address.isDefault) ...[
                const SizedBox(width: 4),
                _buildDefaultBadge(),
              ],
            ],
          ),
          const SizedBox(height: 6),
          // Full name with company
          Text(
            address.fullName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),
          // Full address
          Text(
            address.formattedAddress,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFB9F8CF)),
      ),
      child: const Text(
        'Default',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: Color(0xFF00A63E),
        ),
      ),
    );
  }
}
