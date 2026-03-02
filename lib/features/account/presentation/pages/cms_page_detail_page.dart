import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';

/// CMS Page Detail Page
/// Displays the full content of a CMS page with HTML rendering
class CmsPageDetailPage extends StatelessWidget {
  final CmsPage page;

  const CmsPageDetailPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral800 : AppColors.white;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral900;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          page.displayTitle,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              page.displayTitle,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Meta information (optional)
            if (page.translation.metaTitle != null &&
                page.translation.metaTitle!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  page.translation.metaTitle!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // HTML content
            Html(
              data: page.translation.htmlContent,
              style: {
                'body': Style(
                  fontSize: FontSize(16.0),
                  color: textColor,
                  fontFamily: 'Roboto',
                  lineHeight: LineHeight.percent(160),
                ),
                'p': Style(
                  margin: Margins.only(bottom: 12),
                  color: textColor,
                ),
                'h1': Style(
                  fontSize: FontSize(28.0),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  margin: Margins.symmetric(vertical: 16),
                ),
                'h2': Style(
                  fontSize: FontSize(24.0),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  margin: Margins.symmetric(vertical: 14),
                ),
                'h3': Style(
                  fontSize: FontSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  margin: Margins.symmetric(vertical: 12),
                ),
                'h4': Style(
                  fontSize: FontSize(18.0),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  margin: Margins.symmetric(vertical: 10),
                ),
                'h5': Style(
                  fontSize: FontSize(16.0),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  margin: Margins.symmetric(vertical: 8),
                ),
                'ul': Style(
                  margin: Margins.symmetric(vertical: 12),
                ),
                'li': Style(
                  margin: Margins.only(bottom: 8),
                ),
                'a': Style(
                  color: AppColors.primary500,
                  textDecoration: TextDecoration.underline,
                ),
              },
            ),

            const SizedBox(height: 24),

            // Footer with meta information
            if (page.translation.metaDescription != null &&
                page.translation.metaDescription!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this page',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark ? AppColors.neutral300 : AppColors.neutral600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      page.translation.metaDescription ?? '',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Page ID display (for debugging/reference)
            Center(
              child: Text(
                'Page ID: ${page.pageId}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
