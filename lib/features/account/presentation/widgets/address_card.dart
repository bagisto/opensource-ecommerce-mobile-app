import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Address card widget — Figma "billing" component (node-id=204:4494)
///
/// Displays a single customer address in a rounded neutral/100 card:
///   - Address type badge(s): "Home"/"Office" + optional "Default"
///   - Full name (with company in parentheses)
///   - Formatted address line
///   - Action buttons: "Set as Default" (if not default), "Edit", "Delete"
class AddressCard extends StatelessWidget {
  final CustomerAddress address;
  final VoidCallback? onSetDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    this.onSetDefault,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label:
          'Address for ${address.fullName}${address.isDefault ? ', ${l10n.accountDefault}' : ''}',
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tags row: address type + default badge ──
            _buildTagsRow(l10n, isDark),

            const SizedBox(height: 12),

            // ── Name (bold) with overflow protection ──
            Text(
              address.fullName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),

            const SizedBox(height: 6),

            // ── Full address ──
            Text(
              address.formattedAddress,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.4,
                color: isDark ? AppColors.neutral300 : AppColors.neutral900,
              ),
            ),

            const SizedBox(height: 12),

            // ── Action buttons row ──
            _buildActionsRow(l10n, isDark),
          ],
        ),
      ),
    );
  }

  /// Tags row: address type badge + optional "Default" badge
  /// Figma: node-id=204:5047
  Widget _buildTagsRow(AppLocalizations l10n, bool isDark) {
    final typeLabel = _addressTypeLabel(l10n);

    return Row(
      children: [
        // Address type tag (Home / Office / etc.)
        if (typeLabel.isNotEmpty) _buildTag(typeLabel, isDark),

        if (typeLabel.isNotEmpty && address.isDefault) const SizedBox(width: 4),

        // "Default" tag — only shown when address is default
        if (address.isDefault) _buildTag(l10n.accountDefault, isDark),
      ],
    );
  }

  /// Single tag chip
  Widget _buildTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral700 : AppColors.white,
        border: Border.all(
          color: isDark ? AppColors.neutral600 : AppColors.neutral200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
        ),
      ),
    );
  }

  /// Action buttons: Set as Default | Edit | Delete
  /// Figma: node-id=204:5134
  Widget _buildActionsRow(AppLocalizations l10n, bool isDark) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        // Show "Set as Default" only if NOT already default
        if (!address.isDefault && onSetDefault != null)
          _buildActionButton(l10n.accountSetAsDefault, onSetDefault!),

        if (onEdit != null) _buildActionButton(l10n.commonEdit, onEdit!),

        if (onDelete != null)
          _buildActionButton(
            l10n.accountDelete,
            onDelete!,
            isDestructive: true,
          ),
      ],
    );
  }

  /// Single text action button — bold primary/500 text with Material ripple
  Widget _buildActionButton(
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.primary500;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          splashColor: color.withAlpha(30),
          highlightColor: color.withAlpha(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Derive address type label from addressType field.
  /// Returns empty string if no type is set (instead of assuming "Home").
  String _addressTypeLabel(AppLocalizations l10n) {
    final type = address.addressType?.trim() ?? '';
    if (type.isEmpty) return '';
    final lower = type.toLowerCase();
    switch (lower) {
      case 'home':
        return l10n.accountAddressTypeHome;
      case 'office':
      case 'work':
        return l10n.accountAddressTypeOffice;
      case 'customer':
        return l10n.accountAddressTypeCustomer;
      default:
        // Capitalize fallback
        return type[0].toUpperCase() + type.substring(1).toLowerCase();
    }
  }
}
