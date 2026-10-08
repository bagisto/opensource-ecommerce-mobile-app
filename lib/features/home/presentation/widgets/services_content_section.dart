import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

/// Renders a `services_content` customization: a grid of service cards
/// (icon, title, description) like the storefront's "Services Content".
class ServicesContentSection extends StatelessWidget {
  final List<HomeService> services;

  const ServicesContentSection({super.key, required this.services});

  /// Maps storefront icon classes to Material icons.
  static IconData iconFor(String iconClass) {
    switch (iconClass) {
      case 'icon-truck':
        return Icons.local_shipping_outlined;
      case 'icon-product':
        return Icons.autorenew;
      case 'icon-dollar-sign':
        return Icons.attach_money;
      case 'icon-support':
        return Icons.support_agent;
      default:
        return Icons.verified_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 12.0;
          final cardWidth = (constraints.maxWidth - spacing) / 2;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final service in services)
                SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.white,
                          ),
                          child: Icon(
                            iconFor(service.icon),
                            color: AppColors.primary500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.neutral100
                                : AppColors.neutral900,
                          ),
                        ),
                        if (service.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            service.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
