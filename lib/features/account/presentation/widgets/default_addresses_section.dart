import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';
import '../helpers/account_dashboard_helpers.dart';
import 'section_header.dart';

/// Default address section
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
    final l10n = AppLocalizations.of(context)!;
    final defaultAddress = resolveDashboardDefaultAddress(addresses);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: l10n.accountDefaultAddresses,
              onViewAll: addresses.isNotEmpty ? onViewAll : null,
            ),
          ),
          const SizedBox(height: 2),
          if (addresses.isEmpty)
            _buildEmptyState(context)
          else if (defaultAddress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildAddressCard(context, address: defaultAddress),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
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
            l10n.accountNoAddressesSaved,
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
          if (address.isDefault) ...[
            _buildDefaultBadge(context),
            const SizedBox(height: 8),
          ],
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

  Widget _buildDefaultBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFB9F8CF)),
      ),
      child: Text(
        l10n.accountDefault,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: Color(0xFF00A63E),
        ),
      ),
    );
  }
}
