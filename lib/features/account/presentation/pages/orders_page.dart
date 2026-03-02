import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/orders_bloc.dart';
import 'order_detail_page.dart';
import '../../../../core/widgets/app_back_button.dart';

/// Orders Page — Figma node-id=229-4260
///
/// Displays a paginated list of the customer's orders:
///   - AppBar: back arrow + "Orders" title
///   - Count header: "N Orders" + sort icon
///   - Order cards with product image, order #, status chip, date, total (Items N)
///
/// Status chip colors (from Figma):
///   Pending:    bg #FEF3C6, border #FEE685, text #E17100
///   Processing: bg #DBEAFE, border #BEDBFF, text #2B7FFF
///   Completed:  bg #DCFCE7, border #B9F8CF, text #00A63E
///   Cancel:     bg #FFE2E2, border #FFC9C9, text #FB2C36
///   Closed:     bg #F5F5F5, border #E5E5E5, text #525252
///   Fraud:      bg #FFE2E2, border #FFC9C9, text #FB2C36
///
/// Architecture:
///   BlocProvider<OrdersBloc> → OrdersPage → Repository → GraphQL
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != OrdersStatus.error) {
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
            context.read<OrdersBloc>().add(const ClearOrderMessage());
          }
        },
        builder: (context, state) {
          if (state.status == OrdersStatus.loading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrdersStatus.error && state.orders.isEmpty) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.orders.isEmpty) {
            return _buildEmptyState(context);
          }

          return _OrderList(
            orders: state.orders,
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
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Orders Yet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your orders will appear here once you make a purchase.',
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
              onPressed: () =>
                  context.read<OrdersBloc>().add(const LoadOrders()),
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
// Order List — scrollable list with count header
// ──────────────────────────────────────────────

class _OrderList extends StatefulWidget {
  final List<CustomerOrder> orders;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;

  const _OrderList({
    required this.orders,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
  });

  @override
  State<_OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<_OrderList> {
  final ScrollController _scrollController = ScrollController();

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
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<OrdersBloc>().add(const LoadMoreOrders());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // +1 for header, +1 for loading indicator if loading more
      itemCount: widget.orders.length + 1 + (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // First item: count header row
        if (index == 0) {
          return _CountHeader(totalCount: widget.totalCount);
        }

        // Loading more indicator at the bottom
        if (index == widget.orders.length + 1) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        // Order card — Figma gap between cards: 4px
        final order = widget.orders[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: GestureDetector(
            onTap: () {
              if (order.numericId != null) {
                final repo = RepositoryProvider.of<AccountRepository>(context);
                OrderDetailPage.navigate(
                  context,
                  orderId: order.numericId!,
                  orderNumber: order.orderNumber,
                  repository: repo,
                );
              }
            },
            child: _OrderCard(order: order),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────
// Count Header: "N Orders" + sort icon
// Figma node-id=233:6132
// Font: Roboto Medium 12, color #171717
// ──────────────────────────────────────────────

class _CountHeader extends StatelessWidget {
  final int totalCount;
  const _CountHeader({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "N Orders" — Figma: Roboto Medium 12, #171717
          Text(
            '$totalCount Order${totalCount == 1 ? '' : 's'}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),

          // Sort/filter icon — Figma node: 233:6134
          Icon(
            Icons.swap_vert_rounded,
            size: 20,
            color: isDark ? AppColors.neutral400 : AppColors.neutral700,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Order Card — Figma component: cart-item
// Background: #F5F5F5 (light) / neutral800 (dark)
// Border: 1px #E5E5E5 (light) / neutral700 (dark)
// Rounded: 10
// Padding: 12
// ──────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final CustomerOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Order details column ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order number — Figma: Roboto Medium 14, #171717
                Text(
                  order.orderNumber,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.neutral200
                        : const Color(0xFF171717),
                  ),
                ),

                const SizedBox(height: 5),

                // Status chip + date row
                _buildStatusDateRow(context, isDark),

                const SizedBox(height: 5),

                // Price + items — Figma: Roboto Regular 14, #525252
                Text(
                  '${order.formattedTotal} (Items ${order.totalItemCount})',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.neutral400
                        : const Color(0xFF525252),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Status chip + date — Figma: gap 6, height 24
  /// Status colors from Figma design tokens:
  ///   pending:    bg #FEF3C6, border #FEE685, text #E17100
  ///   processing: bg #DBEAFE, border #BEDBFF, text #2B7FFF
  ///   completed:  bg #DCFCE7, border #B9F8CF, text #00A63E
  ///   canceled:   bg #FFE2E2, border #FFC9C9, text #FB2C36
  ///   closed:     bg #F5F5F5, border #E5E5E5, text #525252
  ///   fraud:      bg #FFE2E2, border #FFC9C9, text #FB2C36
  Widget _buildStatusDateRow(BuildContext context, bool isDark) {
    final chipColors = _getStatusColors(order.status);

    return Row(
      children: [
        // Status chip — Figma: rounded-6, px-6, py-4
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? chipColors.bg.withAlpha(40) : chipColors.bg,
            border: Border.all(
              color: isDark
                  ? chipColors.border.withAlpha(60)
                  : chipColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            order.statusLabel,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: chipColors.text,
            ),
          ),
        ),

        const SizedBox(width: 6),

        // Date — Figma: Roboto Regular 14, #525252
        Text(
          order.formattedDate,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
          ),
        ),
      ],
    );
  }

  /// Map order status to Figma chip colors
  static _StatusChipColors _getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const _StatusChipColors(
          bg: Color(0xFFFEF3C6),
          border: Color(0xFFFEE685),
          text: Color(0xFFE17100),
        );
      case 'processing':
        return const _StatusChipColors(
          bg: Color(0xFFDBEAFE),
          border: Color(0xFFBEDBFF),
          text: Color(0xFF2B7FFF),
        );
      case 'completed':
        return const _StatusChipColors(
          bg: Color(0xFFDCFCE7),
          border: Color(0xFFB9F8CF),
          text: Color(0xFF00A63E),
        );
      case 'canceled':
      case 'cancelled':
      case 'fraud':
        return const _StatusChipColors(
          bg: Color(0xFFFFE2E2),
          border: Color(0xFFFFC9C9),
          text: Color(0xFFFB2C36),
        );
      case 'closed':
        return const _StatusChipColors(
          bg: Color(0xFFF5F5F5),
          border: Color(0xFFE5E5E5),
          text: Color(0xFF525252),
        );
      default:
        return const _StatusChipColors(
          bg: Color(0xFFF5F5F5),
          border: Color(0xFFE5E5E5),
          text: Color(0xFF525252),
        );
    }
  }
}

/// Figma status chip color scheme
class _StatusChipColors {
  final Color bg;
  final Color border;
  final Color text;

  const _StatusChipColors({
    required this.bg,
    required this.border,
    required this.text,
  });
}
