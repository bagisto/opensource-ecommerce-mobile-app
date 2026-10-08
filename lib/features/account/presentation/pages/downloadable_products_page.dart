import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bloc_refresh.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../data/models/account_models.dart';
import '../bloc/downloadable_products_bloc.dart';

/// Downloadable Products Page
///
/// Displays a list of the customer's downloadable products:
///   - AppBar: back arrow + "Downloadable Products" title
///   - Count header: "N Products" 
///   - Product cards with product name, file name, order number, remaining downloads, status
///   - Download button for products that are available
///
/// Architecture:
///   BlocProvider<DownloadableProductsBloc> → DownloadableProductsPage → Repository → GraphQL
class DownloadableProductsPage extends StatelessWidget {
  const DownloadableProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: AppBackButton(),
        leadingWidth: 60,
        titleSpacing: 0,
        title: Text(
          l10n.accountDownloadableProducts,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocConsumer<DownloadableProductsBloc, DownloadableProductsState>(
        listener: (context, state) {
          // A failed refresh keeps the old list on screen, so surface its
          // error as a snackbar too.
          if (state.errorMessage != null &&
              (state.status != DownloadableProductsStatus.error ||
                  state.products.isNotEmpty)) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            context
                .read<DownloadableProductsBloc>()
                .add(const ClearDownloadableProductsMessage());
          }
        },
        builder: (context, state) {
          if (state.status == DownloadableProductsStatus.loading &&
              state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final Widget content;
          if (state.status == DownloadableProductsStatus.error &&
              state.products.isEmpty) {
            content = _fillViewport(
              _buildErrorState(context, state.errorMessage),
            );
          } else if (state.products.isEmpty) {
            content = _fillViewport(_buildEmptyState(context));
          } else {
            content = _DownloadableProductsList(
              products: state.products,
              totalCount: state.totalCount,
              hasNextPage: state.hasNextPage,
              isLoadingMore: state.isLoadingMore,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary500,
            onRefresh: () => _refresh(context),
            child: content,
          );
        },
      ),
    );
  }

  /// Pull-to-refresh: reloads the first page and resolves once it finishes.
  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<DownloadableProductsBloc>();
    return refreshBloc<DownloadableProductsState>(
      bloc,
      () => bloc.add(const LoadDownloadableProducts()),
      (s) =>
          s.status == DownloadableProductsStatus.loaded ||
          s.status == DownloadableProductsStatus.error,
    );
  }

  /// Makes a non-list view pullable by placing it in an always-scrollable
  /// viewport that fills the body.
  Widget _fillViewport(Widget child) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_outlined,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.accountNoDownloadsYet,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountDownloadsEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? l10n.categorySomethingWentWrong,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context
                  .read<DownloadableProductsBloc>()
                  .add(const LoadDownloadableProducts()),
              child: Text(
                l10n.commonRetry,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Downloadable Products List
// ──────────────────────────────────────────────

class _DownloadableProductsList extends StatefulWidget {
  final List<DownloadableProduct> products;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;

  const _DownloadableProductsList({
    required this.products,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
  });

  @override
  State<_DownloadableProductsList> createState() =>
      _DownloadableProductsListState();
}

class _DownloadableProductsListState extends State<_DownloadableProductsList> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Update scroll arrow visibility
    final hasScrollableContent =
        _scrollController.position.maxScrollExtent > 0;
    final atTop = _scrollController.position.pixels <= 0;
    final atBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10;

    setState(() {
      _canScrollUp = hasScrollableContent && !atTop;
      _canScrollDown = hasScrollableContent && !atBottom;
    });

    // Load more products when reaching near the bottom
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context
          .read<DownloadableProductsBloc>()
          .add(const LoadMoreDownloadableProducts());
    }
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Header with scroll controls
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              // Scroll up button
              Opacity(
                opacity: _canScrollUp ? 1.0 : 0.3,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _canScrollUp ? _scrollUp : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Count text
              Text(
                l10n.accountProductsProgress(widget.products.length, widget.totalCount),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                ),
              ),
              const Spacer(),
              // Scroll down button
              Opacity(
                opacity: _canScrollDown ? 1.0 : 0.3,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _canScrollDown ? _scrollDown : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider
        Divider(
          height: 1,
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
          indent: 20,
          endIndent: 20,
        ),
        // Product list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: widget.products.length +
                (widget.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= widget.products.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final product = widget.products[index];
              return _DownloadableProductCard(product: product);
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Downloadable Product Card
// ──────────────────────────────────────────────

class _DownloadableProductCard extends StatelessWidget {
  final DownloadableProduct product;

  const _DownloadableProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.neutral800 : AppColors.neutral50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name and status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName ?? product.name,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.fileName,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(product.status, isDark).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.statusLabel,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: _getStatusColor(product.status, isDark),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Information row with order and remaining downloads
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                // Order number
                if (product.order != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 14,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.order!.orderNumber,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: isDark
                              ? AppColors.neutral300
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                // Purchase date
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.formattedDate,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                  ],
                ),
                // Remaining downloads
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.accountRemainingDownloadsLeft(product.remainingDownloadsLabel),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Download button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: product.canDownload
                    ? () => _handleDownload(context, product)
                    : null,
                icon: Icon(
                  Icons.download_rounded,
                  size: 18,
                ),
                label: Text(
                  l10n.accountDownload,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.canDownload
                      ? AppColors.primary500
                      : AppColors.neutral400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status, bool isDark) {
    final statusStr = status?.toLowerCase() ?? 'pending';
    switch (statusStr) {
      case 'available':
        return AppColors.success500;
      case 'pending':
        return AppColors.primary500;
      case 'expired':
      case 'inactive':
        return AppColors.neutral500;
      default:
        return isDark ? AppColors.neutral300 : AppColors.neutral700;
    }
  }

  Future<void> _handleDownload(
      BuildContext context, DownloadableProduct product) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final resolvedDownloadUrl = _resolveDownloadUrl(
      product.downloadUrl?.trim() ?? '',
      product,
    );

    if (resolvedDownloadUrl.isEmpty) {
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Download failed: download URL is missing'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(l10n.accountDownloadWillStartShortly),
              ),
            ],
          ),
          duration: const Duration(seconds: 30),
          behavior: SnackBarBehavior.floating,
        ),
      );

    try {
      final token = await AuthStorage.getToken();
      final dir = await getApplicationDocumentsDirectory();
      final sanitizedName = _sanitizeFileName(
        _resolvedDownloadFileName(product.fileName, resolvedDownloadUrl),
      );
      final savePath = '${dir.path}/$sanitizedName';
      final requestHeaders = <String, String>{
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        'X-STOREFRONT-KEY': storefrontKey,
      };

      _logDownload('═══════════════════════════════════════════');
      _logDownload('📦 [Downloadable Product Request]');
      _logDownload('🔗 URL: $resolvedDownloadUrl');
      _logDownload('🧾 Product ID: ${product.id}');
      _logDownload('🧾 File Name: $sanitizedName');
      _logDownload('💾 Save Path: $savePath');
      _logDownload('📋 Headers: ${_maskSensitiveHeaders(requestHeaders)}');

      final dio = Dio();
      final response = await dio.download(
        resolvedDownloadUrl,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          receiveDataWhenStatusError: true,
          headers: requestHeaders,
          followRedirects: true,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      _logDownload('✅ [Downloadable Product Response]');
      _logDownload('🔢 Status Code: $statusCode');
      _logDownload('📋 Response Headers: ${response.headers.map}');
      _logDownload('📍 Real URI: ${response.realUri}');
      _logDownload('═══════════════════════════════════════════');

      if (statusCode < 200 || statusCode >= 300) {
        throw DioException.badResponse(
          statusCode: statusCode,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      final finalSavePath = await _normalizeDownloadedFilePath(
        initialSavePath: savePath,
        response: response,
      );

      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${product.fileName} downloaded'),
            backgroundColor: AppColors.success500,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () => OpenFilex.open(finalSavePath),
            ),
          ),
        );
    } catch (e) {
      final message = e is DioException
          ? _dioErrorMessage(e)
          : e.toString();
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Download failed: $message'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  String _resolveDownloadUrl(String downloadUrl, DownloadableProduct product) {
    if (downloadUrl.isNotEmpty) {
      final uri = Uri.tryParse(downloadUrl);
      if (uri == null) {
        return downloadUrl;
      }
      if (uri.hasScheme && uri.host.isNotEmpty) {
        return downloadUrl;
      }

      final baseUri = Uri.parse(bagistoEndpoint);
      return baseUri.resolveUri(uri).toString();
    }

    final baseUrl = Uri.parse(bagistoEndpoint).origin;
    return '$baseUrl/downloadable/download/purchased/${product.id}';
  }

  String _resolvedDownloadFileName(String fileName, String downloadUrl) {
    final trimmedName = fileName.trim();
    final parsedUrl = Uri.tryParse(downloadUrl);
    final urlFileName = parsedUrl != null && parsedUrl.pathSegments.isNotEmpty
        ? parsedUrl.pathSegments.last
        : '';
    final urlExtension = urlFileName.contains('.')
        ? urlFileName.substring(urlFileName.lastIndexOf('.'))
        : '';

    if (trimmedName.isEmpty) {
      if (urlFileName.isNotEmpty) {
        return urlFileName;
      }
      return urlExtension.isNotEmpty ? 'download$urlExtension' : 'download_file';
    }

    final hasExtension = trimmedName.contains('.');
    if (hasExtension || urlExtension.isEmpty) {
      return trimmedName;
    }

    return '$trimmedName$urlExtension';
  }

  String _sanitizeFileName(String fileName) {
    final sanitized = fileName.replaceAll(RegExp(r'[^\w\s\-.]'), '_').trim();
    return sanitized.isEmpty ? 'download_file' : sanitized;
  }

  Future<String> _normalizeDownloadedFilePath({
    required String initialSavePath,
    required Response<dynamic> response,
  }) async {
    final currentExtension = _extensionFromPath(initialSavePath);
    if (currentExtension.isNotEmpty) {
      return initialSavePath;
    }

    final inferredExtension = _inferExtensionFromResponse(response);
    if (inferredExtension.isEmpty) {
      return initialSavePath;
    }

    final renamedPath = '$initialSavePath$inferredExtension';
    final file = File(initialSavePath);
    if (!await file.exists()) {
      return initialSavePath;
    }

    final renamedFile = await file.rename(renamedPath);
    return renamedFile.path;
  }

  String _inferExtensionFromResponse(Response<dynamic> response) {
    final contentTypeHeader = response.headers.value(Headers.contentTypeHeader);
    final normalizedContentType = contentTypeHeader?.split(';').first.trim();
    final contentTypeExtension = switch (normalizedContentType) {
      'application/pdf' => '.pdf',
      'image/png' => '.png',
      'image/jpeg' => '.jpg',
      'image/jpg' => '.jpg',
      'image/webp' => '.webp',
      _ => '',
    };

    if (contentTypeExtension.isNotEmpty) {
      return contentTypeExtension;
    }

    return _extensionFromPath(response.realUri.path);
  }

  String _extensionFromPath(String path) {
    final sanitizedPath = path.split('?').first;
    final lastSlash = sanitizedPath.lastIndexOf('/');
    final fileName = lastSlash >= 0
        ? sanitizedPath.substring(lastSlash + 1)
        : sanitizedPath;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return '';
    }

    return fileName.substring(dotIndex).toLowerCase();
  }

  String _dioErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    _logDownload('❌ [Downloadable Product Error]');
    _logDownload('🔗 URL: ${error.requestOptions.uri}');
    _logDownload(
      '📋 Request Headers: ${_maskSensitiveHeaders(error.requestOptions.headers)}',
    );
    _logDownload('🔢 Status Code: $statusCode');
    _logDownload('📋 Response Headers: ${error.response?.headers.map}');
    _logDownload('📦 Response Body: ${_truncateForLog(responseData)}');
    _logDownload('⚠️ Dio Message: ${error.message}');
    _logDownload('═══════════════════════════════════════════');

    if (statusCode == 401) {
      return 'Unauthorized. Please log in again.';
    }

    if (statusCode == 403) {
      return 'You cannot download this file.';
    }

    if (statusCode == 429) {
      return 'Rate limit exceeded. Please wait a moment and try again.';
    }

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return error.message ?? 'Unknown error';
  }

  Map<String, dynamic> _maskSensitiveHeaders(Map<dynamic, dynamic> headers) {
    return headers.map((key, value) {
      final headerKey = key.toString();
      final lowerKey = headerKey.toLowerCase();
      if (lowerKey == 'authorization') {
        return MapEntry(headerKey, _maskBearerToken(value?.toString() ?? ''));
      }
      if (lowerKey == 'x-storefront-key') {
        return MapEntry(headerKey, _maskValue(value?.toString() ?? ''));
      }
      return MapEntry(headerKey, value);
    });
  }

  String _maskBearerToken(String rawValue) {
    if (!rawValue.startsWith('Bearer ')) {
      return _maskValue(rawValue);
    }

    final token = rawValue.substring(7);
    return 'Bearer ${_maskValue(token)}';
  }

  String _maskValue(String value) {
    if (value.length <= 8) {
      return '***';
    }

    return '${value.substring(0, 4)}***${value.substring(value.length - 4)}';
  }

  String _truncateForLog(dynamic data) {
    final text = data?.toString() ?? 'null';
    if (text.length <= 1500) {
      return text;
    }

    return '${text.substring(0, 1500)}...';
  }

  void _logDownload(String message) {
    debugPrint(message);
    // ignore: avoid_print
    print(message);
  }
}
