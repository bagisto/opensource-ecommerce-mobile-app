import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that renders static content from the Bagisto API.
/// 
/// The static_content type contains HTML and CSS that defines custom
/// sections like "Top Collections" and "Bold Collections".
/// This widget parses the HTML structure and renders it as Flutter widgets.
class StaticContentWidget extends StatelessWidget {
  final String html;
  final String? css;
  final String baseUrl;
  
  /// Callback when "View All" or any action button is pressed
  final VoidCallback? onViewAllPressed;

  const StaticContentWidget({
    super.key,
    required this.html,
    this.css,
    required this.baseUrl,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the HTML and determine which layout to use
    if (html.contains('top-collection-container') || 
        html.contains('top-collection-grid')) {
      return _buildTopCollections(context);
    } else if (html.contains('inline-col-wrapper')) {
      return _buildBoldCollections(context);
    } else if (html.contains('services-grid') || 
               html.contains('service-card')) {
      return _buildServicesGrid(context);
    }
    
    // Fallback: try to extract and render images
    return _buildGenericContent(context);
  }

  /// Build "Top Collections" style layout
  /// A header with title followed by a grid of collection cards
  Widget _buildTopCollections(BuildContext context) {
    // Extract title from h2
    final titleMatch = RegExp(r'<h2[^>]*>(.*?)</h2>', dotAll: true).firstMatch(html);
    final title = titleMatch?.group(1)?.trim() ?? 'Collections';
    
    // Extract collection cards
    final cardPattern = RegExp(
      r'<div class="top-collection-card"[^>]*>.*?'
      r'data-src="([^"]*)"[^>]*>.*?'
      r'<h3[^>]*>(.*?)</h3>.*?'
      r'</div>',
      dotAll: true,
    );
    
    final cards = <_CollectionCard>[];
    for (final match in cardPattern.allMatches(html)) {
      final imagePath = match.group(1) ?? '';
      final cardTitle = match.group(2)?.trim() ?? '';
      cards.add(_CollectionCard(
        imageUrl: _getFullUrl(imagePath),
        title: cardTitle,
      ));
    }

    if (cards.isEmpty) {
      // Try alternative pattern for images
      final imgPattern = RegExp(r'data-src="([^"]*)"');
      final titlePattern = RegExp(r'<h3[^>]*>(.*?)</h3>');
      
      final images = imgPattern.allMatches(html).map((m) => m.group(1) ?? '').toList();
      final titles = titlePattern.allMatches(html).map((m) => m.group(1)?.trim() ?? '').toList();
      
      for (int i = 0; i < images.length && i < titles.length; i++) {
        cards.add(_CollectionCard(
          imageUrl: _getFullUrl(images[i]),
          title: titles[i],
        ));
      }
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(builder: (ctx) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return Text(
              title,
              style: TextStyle(
                fontFamily: 'DM Serif Display',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
            );
          }),
        ),
        const SizedBox(height: 24),
        // Grid of cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return _buildCollectionCard(cards[index], context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionCard(_CollectionCard card, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: card.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: isDark ? AppColors.neutral800 : AppColors.neutral100,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary500,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: isDark ? AppColors.neutral800 : AppColors.neutral100,
              child: Icon(
                Icons.image_outlined,
                size: 40,
                color: isDark ? AppColors.neutral500 : AppColors.neutral400,
              ),
            ),
          ),
        ),
        // Title overlay at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Text(
            card.title,
            style: TextStyle(
              fontFamily: 'DM Serif Display',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Build "Bold Collections" style layout
  /// An inline layout with image on one side and content on the other
  Widget _buildBoldCollections(BuildContext context) {
    // Extract image
    final imgMatch = RegExp(r'data-src="([^"]*)"').firstMatch(html);
    final imageUrl = _getFullUrl(imgMatch?.group(1) ?? '');
    
    // Extract title
    final titleMatch = RegExp(r'<h2[^>]*>(.*?)</h2>', dotAll: true).firstMatch(html);
    final title = titleMatch?.group(1)?.trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';
    
    // Extract description
    final descMatch = RegExp(r'<p class="inline-col-description"[^>]*>(.*?)</p>', dotAll: true).firstMatch(html);
    final description = descMatch?.group(1)?.trim() ?? '';
    
    // Check for button
    final hasButton = html.contains('primary-button') || html.contains('<button');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Builder(builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1.24, // 632/510
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'DM Serif Display',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                      height: 1.2,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (hasButton) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: onViewAllPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View All'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Build services grid layout
  Widget _buildServicesGrid(BuildContext context) {
    // Extract service cards
    final cardPattern = RegExp(
      r'<div class="service-card"[^>]*>.*?'
      r'<img[^>]*data-src="([^"]*)"[^>]*>.*?'
      r'<h3[^>]*>(.*?)</h3>.*?'
      r'<p[^>]*>(.*?)</p>.*?'
      r'</div>',
      dotAll: true,
    );
    
    final services = <_ServiceCard>[];
    for (final match in cardPattern.allMatches(html)) {
      services.add(_ServiceCard(
        imageUrl: _getFullUrl(match.group(1) ?? ''),
        title: match.group(2)?.trim() ?? '',
        description: match.group(3)?.trim() ?? '',
      ));
    }

    if (services.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: service.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 80,
                placeholder: (context, url) => Container(
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  child: Icon(
                    Icons.image_outlined,
                    color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (service.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
      },
    );
  }

  /// Generic content fallback - extract and display images
  Widget _buildGenericContent(BuildContext context) {
    final imgPattern = RegExp(r'(?:src|data-src)="([^"]*)"');
    final images = imgPattern.allMatches(html).map((m) => m.group(1) ?? '').toList();
    
    if (images.isEmpty) return const SizedBox.shrink();
    
    // Extract any text content
    final textPattern = RegExp(r'>([^<]+)<');
    final texts = textPattern
        .allMatches(html)
        .map((m) => m.group(1)?.trim())
        .where((t) => t != null && t.isNotEmpty && t.length > 2)
        .toList();

    return Builder(builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      return Column(
        children: [
          if (texts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                texts.first ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final itemIsDark =
                    Theme.of(context).brightness == Brightness.dark;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: _getFullUrl(images[index]),
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                      placeholder: (context, url) => Container(
                        color:
                            itemIsDark ? AppColors.neutral800 : AppColors.neutral100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color:
                            itemIsDark ? AppColors.neutral800 : AppColors.neutral100,
                        child: Icon(
                          Icons.image_outlined,
                          color: itemIsDark ? AppColors.neutral500 : AppColors.neutral400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  String _getFullUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanBase = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$cleanBase/$cleanPath';
  }
}

class _CollectionCard {
  final String imageUrl;
  final String title;

  _CollectionCard({required this.imageUrl, required this.title});
}

class _ServiceCard {
  final String imageUrl;
  final String title;
  final String description;

  _ServiceCard({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}
