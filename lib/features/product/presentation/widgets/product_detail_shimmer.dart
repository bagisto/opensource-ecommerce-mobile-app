import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';

/// Shimmer skeleton for the product detail page while data is loading
class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.neutral800 : AppColors.neutral200;
    final highlightColor =
        isDark ? AppColors.neutral700 : AppColors.neutral100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Carousel placeholder ──
            Container(
              width: double.infinity,
              height: 375,
              color: baseColor,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──
                  _shimmerBox(width: 250, height: 22, baseColor: baseColor),
                  const SizedBox(height: 8),
                  _shimmerBox(width: 180, height: 22, baseColor: baseColor),

                  const SizedBox(height: 16),

                  // ── Price row ──
                  Row(
                    children: [
                      _shimmerBox(
                          width: 80, height: 28, baseColor: baseColor),
                      const SizedBox(width: 8),
                      _shimmerBox(
                          width: 60, height: 20, baseColor: baseColor),
                      const SizedBox(width: 8),
                      _shimmerBox(
                          width: 50, height: 20, baseColor: baseColor),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Rating row ──
                  Row(
                    children: [
                      _shimmerBox(
                          width: 54, height: 24, baseColor: baseColor),
                      const SizedBox(width: 8),
                      _shimmerBox(
                          width: 40, height: 16, baseColor: baseColor),
                      const SizedBox(width: 8),
                      _shimmerBox(
                          width: 60, height: 24, baseColor: baseColor),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Attribute Section - "Select Size" ──
                  _shimmerBox(width: 100, height: 16, baseColor: baseColor),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      5,
                      (_) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _shimmerBox(
                            width: 46, height: 46, baseColor: baseColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Attribute Section - "Color" ──
                  _shimmerBox(width: 60, height: 16, baseColor: baseColor),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      4,
                      (_) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: baseColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Quantity Picker ──
                  _shimmerBox(width: 70, height: 16, baseColor: baseColor),
                  const SizedBox(height: 12),
                  _shimmerBox(width: 130, height: 36, baseColor: baseColor),

                  const SizedBox(height: 24),

                  // ── Wishlist / Compare / Share row ──
                  _shimmerBox(
                      width: double.infinity,
                      height: 48,
                      baseColor: baseColor),

                  const SizedBox(height: 24),

                  // ── Details Section ──
                  _shimmerBox(width: 80, height: 18, baseColor: baseColor),
                  const SizedBox(height: 12),
                  _shimmerBox(
                      width: double.infinity,
                      height: 14,
                      baseColor: baseColor),
                  const SizedBox(height: 6),
                  _shimmerBox(
                      width: double.infinity,
                      height: 14,
                      baseColor: baseColor),
                  const SizedBox(height: 6),
                  _shimmerBox(width: 200, height: 14, baseColor: baseColor),

                  const SizedBox(height: 24),

                  // ── More Informations Section ──
                  _shimmerBox(
                      width: 140, height: 18, baseColor: baseColor),
                  const SizedBox(height: 12),
                  ...List.generate(
                    4,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          _shimmerBox(
                              width: 100, height: 14, baseColor: baseColor),
                          const Spacer(),
                          _shimmerBox(
                              width: 80, height: 14, baseColor: baseColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Reviews Section ──
                  _shimmerBox(width: 80, height: 18, baseColor: baseColor),
                  const SizedBox(height: 12),
                  _shimmerBox(
                      width: double.infinity,
                      height: 100,
                      baseColor: baseColor),
                ],
              ),
            ),

            const SizedBox(height: 80), // space for bottom bar
          ],
        ),
      ),
    );
  }

  static Widget _shimmerBox({
    required double height,
    required Color baseColor,
    double? width,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
