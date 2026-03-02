import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
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
          'Downloadable Products',
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
          if (state.errorMessage != null &&
              state.status != DownloadableProductsStatus.error) {
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

          if (state.status == DownloadableProductsStatus.error &&
              state.products.isEmpty) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.products.isEmpty) {
            return _buildEmptyState(context);
          }

          return _DownloadableProductsList(
            products: state.products,
            totalCount: state.totalCount,
            hasNextPage: state.hasNextPage,
            isLoadingMore: state.isLoadingMore,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              'No Downloads Yet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your downloaded products will appear here.',
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
              message ?? 'Something went wrong',
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
              child: const Text(
                'Retry',
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
                '${widget.products.length} / ${widget.totalCount} Products',
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
                      '${product.remainingDownloadsLabel} left',
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
                label: const Text(
                  'Download',
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

  void _handleDownload(BuildContext context, DownloadableProduct product) {
    // Show a dialog with download information
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Download',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File: ${product.fileName}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.neutral300
                        : AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your download will start shortly. Check your downloads folder.',
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
