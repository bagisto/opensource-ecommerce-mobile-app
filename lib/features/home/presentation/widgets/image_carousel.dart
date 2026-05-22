import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

/// Auto-scrolling banner carousel with dot indicators.
///
/// Keeps home banners fully visible by adapting the height to the
/// active image's aspect ratio while preserving rounded corners.
class ImageCarousel extends StatefulWidget {
  final List<BannerImage> images;
  final String baseUrl;

  const ImageCarousel({super.key, required this.images, this.baseUrl = ''});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  static const double _fallbackAspectRatio = 16 / 9;
  static const double _minBannerHeight = 120;
  static const double _maxBannerHeight = 220;

  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;
  final Map<String, double> _aspectRatios = <String, double>{};
  final Set<String> _resolvingUrls = <String>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cacheBannerAspectRatios();
  }

  @override
  void didUpdateWidget(covariant ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images == widget.images &&
        oldWidget.baseUrl == widget.baseUrl) {
      return;
    }

    _autoPlayTimer?.cancel();
    _currentPage = widget.images.isEmpty
        ? 0
        : _currentPage.clamp(0, widget.images.length - 1);
    _startAutoPlay();
    _cacheBannerAspectRatios();
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

  void _cacheBannerAspectRatios() {
    if (!mounted) return;
    final imageConfiguration = createLocalImageConfiguration(context);

    for (final banner in widget.images) {
      final url = _bannerUrl(banner);
      if (url.isEmpty ||
          _aspectRatios.containsKey(url) ||
          _resolvingUrls.contains(url)) {
        continue;
      }

      _resolvingUrls.add(url);
      final imageProvider = NetworkImage(url);
      final imageStream = imageProvider.resolve(imageConfiguration);
      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (imageInfo, _) {
          imageStream.removeListener(listener);
          _resolvingUrls.remove(url);

          final width = imageInfo.image.width.toDouble();
          final height = imageInfo.image.height.toDouble();
          if (!mounted || width <= 0 || height <= 0) return;

          setState(() {
            _aspectRatios[url] = width / height;
          });
        },
        onError: (exception, stackTrace) {
          imageStream.removeListener(listener);
          _resolvingUrls.remove(url);
        },
      );
      imageStream.addListener(listener);
    }
  }

  String _bannerUrl(BannerImage banner) {
    final effectiveBaseUrl = widget.baseUrl.isNotEmpty
        ? widget.baseUrl
        : Uri.parse(bagistoEndpoint).origin;
    return banner.fullImageUrl(effectiveBaseUrl);
  }

  double _currentAspectRatio() {
    if (widget.images.isEmpty) return _fallbackAspectRatio;
    final safeIndex = _currentPage.clamp(0, widget.images.length - 1);
    final currentBanner = widget.images[safeIndex];
    final aspectRatio = _aspectRatios[_bannerUrl(currentBanner)];
    if (aspectRatio == null || !aspectRatio.isFinite || aspectRatio <= 0) {
      return _fallbackAspectRatio;
    }
    return aspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = (constraints.maxWidth - 40)
            .clamp(0.0, double.infinity)
            .toDouble();
        final computedHeight = availableWidth / _currentAspectRatio();
        final carouselHeight = computedHeight
            .clamp(_minBannerHeight, _maxBannerHeight)
            .toDouble();

        return Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: SizedBox(
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColoredBox(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                            width: double.infinity,
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
                    );
                  },
                ),
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
