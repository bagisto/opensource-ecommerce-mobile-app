import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

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

  /// Called with the raw `href` when content wrapped in an `<a>` link
  /// configured in the admin HTML is tapped.
  final ValueChanged<String>? onLinkTap;

  const StaticContentWidget({
    super.key,
    required this.html,
    this.css,
    required this.baseUrl,
    this.onViewAllPressed,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the HTML and determine which layout to use
    if (html.contains('home-offer')) {
      return _buildOfferBar(context);
    } else if (html.contains('top-collection-container') ||
        html.contains('top-collection-grid') ||
        html.contains('collection-card-wrapper')) {
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

  // ──────────────────────────────────────────────────────────────────────
  // LINK HELPERS
  // ──────────────────────────────────────────────────────────────────────

  static final RegExp _anchorPattern = RegExp(
    r'''<a\b[^>]*\bhref\s*=\s*["']([^"']*)["'][^>]*>(.*?)</a>''',
    caseSensitive: false,
    dotAll: true,
  );

  static bool _isNavigable(String href) {
    final value = href.trim().toLowerCase();
    return value.isNotEmpty &&
        value != '#' &&
        !value.startsWith('javascript:') &&
        !value.startsWith('mailto:') &&
        !value.startsWith('tel:');
  }

  /// First navigable `href` in [htmlContent], or null.
  static String? firstHref(String htmlContent) {
    for (final match in _anchorPattern.allMatches(htmlContent)) {
      final href = match.group(1)?.trim() ?? '';
      if (_isNavigable(href)) return href;
    }
    return null;
  }

  /// Maps each image URL (as written in the HTML) that sits inside an
  /// `<a href>` to that link.
  static Map<String, String> imageLinks(String htmlContent) {
    final links = <String, String>{};
    for (final match in _anchorPattern.allMatches(htmlContent)) {
      final href = match.group(1)?.trim() ?? '';
      if (!_isNavigable(href)) continue;
      for (final url in _extractAllImageUrls(match.group(2) ?? '')) {
        links.putIfAbsent(url, () => href);
      }
    }
    return links;
  }

  /// Wraps [child] in a tap handler when [link] is set.
  Widget _linked(String? link, int index, Widget child) {
    if (link == null || onLinkTap == null) return child;
    return GestureDetector(
      key: ValueKey('static_link_$index'),
      behavior: HitTestBehavior.opaque,
      onTap: () => onLinkTap!(link),
      child: child,
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // IMAGE URL EXTRACTION HELPERS
  // ──────────────────────────────────────────────────────────────────────

  /// Extract the best image URL from an HTML snippet (e.g. a single tag or block).
  /// Prefers data-src over src, skips empty values and non-image URLs.
  static String _extractBestImageUrl(String htmlSnippet) {
    // Try data-src first (lazy-loaded images)
    final dataSrcMatch = RegExp(r'data-src="([^"]+)"').firstMatch(htmlSnippet);
    if (dataSrcMatch != null) {
      final url = dataSrcMatch.group(1) ?? '';
      if (url.isNotEmpty) return url;
    }

    // Try src (direct images), but skip empty or placeholder values
    final srcMatch = RegExp(r'\bsrc="([^"]+)"').firstMatch(htmlSnippet);
    if (srcMatch != null) {
      final url = srcMatch.group(1) ?? '';
      if (url.isNotEmpty && !url.contains('data:image') && !url.endsWith('.gif') ) {
        return url;
      }
    }

    // Also check for background-image in inline styles
    final bgMatch = RegExp(
      r'''background-image:\s*url\(['"]?([^'")\s]+)['"]?\)''',
    ).firstMatch(htmlSnippet);
    if (bgMatch != null) {
      final url = bgMatch.group(1) ?? '';
      if (url.isNotEmpty) return url;
    }

    // Last resort: try src even if it's a gif (could be real content)
    if (srcMatch != null) {
      return srcMatch.group(1) ?? '';
    }

    return '';
  }

  /// Extract all image URLs from <img> tags in HTML.
  /// Prefers data-src over src for each tag.
  static List<String> _extractAllImageUrls(String htmlContent) {
    final imgTagPattern = RegExp(r'<img[^>]*>', caseSensitive: false);
    final urls = <String>[];

    for (final match in imgTagPattern.allMatches(htmlContent)) {
      final tag = match.group(0) ?? '';
      final url = _extractBestImageUrl(tag);
      if (url.isNotEmpty) {
        urls.add(url);
      }
    }
    return urls;
  }

  // ──────────────────────────────────────────────────────────────────────
  // SECTION BUILDERS
  // ──────────────────────────────────────────────────────────────────────

  /// Build "Offer Information" bar (`.home-offer h1`).
  /// Storefront mobile CSS: full-width #E8EDFE bar, centered DM Serif Display
  /// text, weight 500, 14px, 6px vertical padding.
  Widget _buildOfferBar(BuildContext context) {
    final match = RegExp(
      r'<h1[^>]*>(.*?)</h1>',
      dotAll: true,
    ).firstMatch(html);
    final text = _plainText(match?.group(1) ?? '');
    if (text.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      key: const ValueKey('home_offer_bar'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isDark ? AppColors.neutral800 : const Color(0xFFE8EDFE),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'DM Serif Display',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.neutral100 : AppColors.neutral900,
        ),
      ),
    );
  }

  /// Strip tags, decode common entities and collapse whitespace.
  static String _plainText(String htmlSnippet) {
    return htmlSnippet
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Build "Top Collections" style layout
  /// A header with title followed by a grid of collection cards
  Widget _buildTopCollections(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Extract title from h2
    final titleMatch = RegExp(
      r'<h2[^>]*>(.*?)</h2>',
      dotAll: true,
    ).firstMatch(html);
    final parsedTitle = _plainText(titleMatch?.group(1) ?? '');
    final title = parsedTitle.isEmpty ? l10n.homeCollections : parsedTitle;

    // Extract collection cards — find each card block, then extract image + title
    // Top Collections use `top-collection-card`; the Game Container uses
    // `single-collection-card`.
    final cardBlockPattern = RegExp(
      r'<div class="(?:top|single)-collection-card"[^>]*>(.*?)</div>',
      dotAll: true,
    );
    final titlePattern = RegExp(r'<h3[^>]*>(.*?)</h3>', dotAll: true);
    final links = imageLinks(html);

    final cards = <_CollectionCard>[];

    for (final block in cardBlockPattern.allMatches(html)) {
      final blockHtml = block.group(0) ?? '';
      final imageUrl = _extractBestImageUrl(blockHtml);
      final cardTitleMatch = titlePattern.firstMatch(blockHtml);
      final cardTitle = _plainText(cardTitleMatch?.group(1) ?? '');

      cards.add(
        _CollectionCard(
          imageUrl: _getFullUrl(imageUrl),
          title: cardTitle,
          link: firstHref(blockHtml) ?? links[imageUrl],
        ),
      );
    }

    // Fallback: extract images and titles separately
    if (cards.isEmpty) {
      final images = _extractAllImageUrls(html);
      final titles = titlePattern
          .allMatches(html)
          .map((m) => _plainText(m.group(1) ?? ''))
          .toList();

      for (int i = 0; i < images.length && i < titles.length; i++) {
        cards.add(
          _CollectionCard(
            imageUrl: _getFullUrl(images[i]),
            title: titles[i],
          ),
        );
      }

      // If we have images but no titles, still show them
      if (cards.isEmpty && images.isNotEmpty) {
        for (final img in images) {
          cards.add(_CollectionCard(imageUrl: _getFullUrl(img), title: ''));
        }
      }
    }

    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (ctx) {
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
            },
          ),
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
              return _linked(
                cards[index].link,
                index,
                _buildCollectionCard(cards[index], context),
              );
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
        if (card.title.isNotEmpty)
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
    final l10n = AppLocalizations.of(context)!;
    // Extract image — prefer data-src over src
    final imageUrl = _getFullUrl(_extractBestImageUrl(html));

    // Extract title
    final titleMatch = RegExp(
      r'<h2[^>]*>(.*?)</h2>',
      dotAll: true,
    ).firstMatch(html);
    final title = _plainText(titleMatch?.group(1) ?? '');

    // Extract description
    final descMatch = RegExp(
      r'<p class="inline-col-description"[^>]*>(.*?)</p>',
      dotAll: true,
    ).firstMatch(html);
    final description = _plainText(descMatch?.group(1) ?? '');

    // Check for button
    // Button label as written in the admin HTML (e.g. "View Collections").
    final buttonLabel = _plainText(
      RegExp(
            r'<button[^>]*>(.*?)</button>',
            dotAll: true,
          ).firstMatch(html)?.group(1) ??
          '',
    );
    final hasButton =
        html.contains('primary-button') || html.contains('<button');
    // Admin can point the collection at a category/product with an <a href>.
    final link = firstHref(html);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Builder(
        builder: (ctx) {
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
                        color: isDark
                            ? AppColors.neutral800
                            : AppColors.neutral100,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark
                            ? AppColors.neutral800
                            : AppColors.neutral100,
                        child: Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: isDark
                              ? AppColors.neutral500
                              : AppColors.neutral400,
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
                        color: isDark
                            ? AppColors.neutral100
                            : AppColors.neutral900,
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
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (hasButton) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: link != null && onLinkTap != null
                            ? () => onLinkTap!(link)
                            : onViewAllPressed,
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
                        child: Text(
                          buttonLabel.isNotEmpty ? buttonLabel : l10n.homeViewAll,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build services grid layout
  Widget _buildServicesGrid(BuildContext context) {
    // Extract service cards — find each card block
    final cardBlockPattern = RegExp(
      r'<div class="service-card"[^>]*>(.*?)</div>',
      dotAll: true,
    );
    final titlePattern = RegExp(r'<h3[^>]*>(.*?)</h3>', dotAll: true);
    final descPattern = RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true);

    final services = <_ServiceCard>[];
    for (final block in cardBlockPattern.allMatches(html)) {
      final blockHtml = block.group(0) ?? '';
      final imageUrl = _extractBestImageUrl(blockHtml);
      final cardTitle = _plainText(
        titlePattern.firstMatch(blockHtml)?.group(1) ?? '',
      );
      final cardDesc = _plainText(
        descPattern.firstMatch(blockHtml)?.group(1) ?? '',
      );

      if (imageUrl.isNotEmpty || cardTitle.isNotEmpty) {
        services.add(
          _ServiceCard(
            imageUrl: _getFullUrl(imageUrl),
            title: cardTitle,
            description: cardDesc,
          ),
        );
      }
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

  /// Generic content fallback - extract and display images from <img> tags
  Widget _buildGenericContent(BuildContext context) {
    final images = _extractAllImageUrls(html);

    if (images.isEmpty) return const SizedBox.shrink();

    // Extract any text content
    final textPattern = RegExp(r'>([^<]+)<');
    final texts = textPattern
        .allMatches(html)
        .map((m) => m.group(1)?.trim())
        .where((t) => t != null && t.isNotEmpty && t.length > 2)
        .toList();

    return Builder(
      builder: (ctx) {
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
                          color: itemIsDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: itemIsDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          child: Icon(
                            Icons.image_outlined,
                            color: itemIsDark
                                ? AppColors.neutral500
                                : AppColors.neutral400,
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
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // URL HELPERS
  // ──────────────────────────────────────────────────────────────────────

  static const String _mediaToken = '__media__/';

  String _getFullUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    var cleanPath = path.startsWith('/') ? path.substring(1) : path;
    // Theme section images are stored as `__media__/...`; the storefront
    // renders that token as the public `storage/` folder.
    if (cleanPath.startsWith(_mediaToken)) {
      cleanPath = 'storage/${cleanPath.substring(_mediaToken.length)}';
    }
    return '$cleanBase/$cleanPath';
  }
}

class _CollectionCard {
  final String imageUrl;
  final String title;
  final String? link;

  _CollectionCard({required this.imageUrl, required this.title, this.link});
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
