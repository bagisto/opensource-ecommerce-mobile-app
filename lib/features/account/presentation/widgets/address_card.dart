import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';

/// Address card widget — Figma "billing" component (node-id=204:4494)
///
/// Displays a single customer address in a rounded neutral/100 card:
///   - Address type badge(s): "Home"/"Office" + optional "Default"
///   - Full name (with company in parentheses)
///   - Formatted address line
///   - Action buttons: "Select Address", "Set as Default" (if not default),
///     "Edit"
class AddressCard extends StatelessWidget {
  final CustomerAddress address;
  final VoidCallback? onSelect;
  final VoidCallback? onSetDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    this.onSelect,
    this.onSetDefault,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label:
          'Address for ${address.fullName}${address.isDefault ? ', default address' : ''}',
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
            _buildTagsRow(isDark),

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
            _buildActionsRow(isDark),
          ],
        ),
      ),
    );
  }

  /// Tags row: address type badge + optional "Default" badge
  /// Figma: node-id=204:5047
  Widget _buildTagsRow(bool isDark) {
    final typeLabel = _addressTypeLabel;

    return Row(
      children: [
        // Address type tag (Home / Office / etc.)
        if (typeLabel.isNotEmpty) _buildTag(typeLabel, isDark),

        if (typeLabel.isNotEmpty && address.isDefault) const SizedBox(width: 4),

        // "Default" tag — only shown when address is default
        if (address.isDefault) _buildTag('Default', isDark),
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

  /// Action buttons: Select Address | Set as Default | Edit
  /// Figma: node-id=204:5134
  Widget _buildActionsRow(bool isDark) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        if (onSelect != null) _buildActionButton('Select Address', onSelect!),

        // Show "Set as Default" only if NOT already default
        if (!address.isDefault && onSetDefault != null)
          _buildActionButton('Set as Default', onSetDefault!),

        if (onEdit != null) _buildActionButton('Edit', onEdit!),

        if (onDelete != null)
          _buildActionButton('Delete', onDelete!, isDestructive: true),
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
  String get _addressTypeLabel {
    final type = address.addressType?.trim() ?? '';
    if (type.isEmpty) return '';
    // Capitalize first letter
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }
}
