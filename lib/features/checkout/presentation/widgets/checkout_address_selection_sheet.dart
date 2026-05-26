import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/checkout_model.dart';

class CheckoutAddressSelectionSheet extends StatelessWidget {
  final String title;
  final String addButtonLabel;
  final List<CheckoutAddress> addresses;
  final String? selectedAddressId;
  final ScrollController? scrollController;
  final ValueChanged<CheckoutAddress> onAddressSelected;
  final VoidCallback onAddNewAddress;
  final String Function(String phone) phoneLabelBuilder;

  const CheckoutAddressSelectionSheet({
    super.key,
    required this.title,
    required this.addButtonLabel,
    required this.addresses,
    required this.onAddressSelected,
    required this.onAddNewAddress,
    required this.phoneLabelBuilder,
    this.selectedAddressId,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral700 : AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final address = addresses[index];
                final isSelected = selectedAddressId == address.id;

                return GestureDetector(
                  onTap: () => onAddressSelected(address),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary500.withValues(alpha: 0.05)
                          : (isDark
                                ? AppColors.neutral800
                                : AppColors.neutral100),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary500
                            : (isDark
                                  ? AppColors.neutral700
                                  : AppColors.neutral200),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                address.displayName,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppColors.primary500
                                      : (isDark
                                            ? AppColors.neutral100
                                            : AppColors.neutral900),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address.fullAddress,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral800,
                          ),
                        ),
                        if (address.phone != null &&
                            address.phone!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            phoneLabelBuilder(address.phone!),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.neutral500
                                  : AppColors.neutral500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddNewAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(54),
                  ),
                ),
                child: Text(
                  addButtonLabel,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
