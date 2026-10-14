import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

/// Auto-scrolling banner carousel with dot indicators.
///
/// Banners always use the storefront banner ratio (1920x700, about 2.74:1)
/// so the app shows them exactly like the web, on every screen width.
class ImageCarousel extends StatefulWidget {
  final List<BannerImage> images;
  final String baseUrl;

  /// Called when a banner with a configured link is tapped.
  final ValueChanged<BannerImage>? onBannerTap;

  const ImageCarousel({
    super.key,
    required this.images,
    this.baseUrl = '',
    this.onBannerTap,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  /// Bagisto storefront banner size: 1920x700.
  static const double bannerAspectRatio = 1920 / 700;
  static const double _horizontalPadding = 20;

  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images == widget.images) return;

    _autoPlayTimer?.cancel();
    _currentPage = widget.images.isEmpty
        ? 0
        : _currentPage.clamp(0, widget.images.length - 1);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.images.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  String _bannerUrl(BannerImage banner) {
    final effectiveBaseUrl = widget.baseUrl.isNotEmpty
        ? widget.baseUrl
        : bagistoPublicBaseUrl;
    return banner.fullImageUrl(effectiveBaseUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = (constraints.maxWidth - _horizontalPadding * 2)
            .clamp(0.0, double.infinity)
            .toDouble();
        final carouselHeight = imageWidth / bannerAspectRatio;

        return Column(
          children: [
            SizedBox(
              height: carouselHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final banner = widget.images[index];
                  final url = _bannerUrl(banner);
                  final onTap =
                      banner.linkSlug != null && widget.onBannerTap != null
                      ? () => widget.onBannerTap!(banner)
                      : null;
                  return GestureDetector(
                    key: ValueKey('home_banner_$index'),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalPadding,
                      ),
                      child: ClipRRect(
                        key: const ValueKey('home_banner_image_area'),
                        borderRadius: BorderRadius.circular(12),
                        child: ColoredBox(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: isDark
                                        ? AppColors.neutral500
                                        : AppColors.neutral400,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.images.length > 1) ...[
              const SizedBox(height: 12),
              _buildDotIndicators(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.images.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary500 : AppColors.neutral300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
