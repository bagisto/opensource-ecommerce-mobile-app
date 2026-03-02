import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

/// Image carousel at the top of the product detail page
/// Figma: 375×375 product image with page dots below
class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageCarousel({super.key, required this.imageUrls});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.imageUrls.isEmpty) {
      return Container(
        width: screenWidth,
        height: screenWidth,
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: AppColors.neutral400,
        ),
      );
    }

    return Column(
      children: [
        // ── Image PageView ──
        SizedBox(
          width: screenWidth,
          height: screenWidth,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary500,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: AppColors.neutral400,
                  ),
                ),
              );
            },
          ),
        ),

        // ── Page Indicator Dots ──
        if (widget.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 6 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.primary500
                        : (isDark
                            ? AppColors.neutral50.withValues(alpha: 0.4)
                            : AppColors.neutral50),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
