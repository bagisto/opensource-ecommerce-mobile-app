import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';

/// Shimmer loading state for the category page
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.neutral800 : AppColors.neutral200;
    final highlightColor = isDark ? AppColors.neutral700 : AppColors.neutral100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar shimmer
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Category chips shimmer
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (_, i) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          width: 40,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Banner shimmer
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                const SizedBox(height: 32),

                // Section header
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.white,
                ),

                const SizedBox(height: 12),

                // Sub-category shimmer
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    8,
                    (i) => Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          width: 45,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Products section header
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),

                const SizedBox(height: 16),

                // Product grid shimmer
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final crossAxisCount =
                        availableWidth >= 900 ? 4 : (availableWidth >= 600 ? 3 : 2);
                    final totalSpacing = 12.0 * (crossAxisCount - 1);
                    final cardWidth =
                        (availableWidth - totalSpacing) / crossAxisCount;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        crossAxisCount * 2,
                        (i) {
                          return SizedBox(
                            width: cardWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: cardWidth,
                                  height: cardWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: cardWidth * 0.8,
                                  height: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  width: 80,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
