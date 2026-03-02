import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/orders_bloc.dart';
import '../pages/orders_page.dart';
import '../pages/order_detail_page.dart';
import 'section_header.dart';

/// Recent Orders horizontal scroll section
/// Figma: node-id=220-6589
class RecentOrdersSection extends StatelessWidget {
  final List<RecentOrder> orders;

  const RecentOrdersSection({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Recent Orders',
              onViewAll: orders.isNotEmpty
                  ? () {
                      final repository = context.read<AccountRepository>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: BlocProvider(
                              create: (_) =>
                                  OrdersBloc(repository: repository)
                                    ..add(const LoadOrders()),
                              child: const OrdersPage(),
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 2),
          if (orders.isEmpty)
            _buildEmptyState(context)
          else
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      // incrementId is the numeric order ID used by the API
                      // order.id may be a base64-encoded GraphQL ID
                      final numId =
                          order.incrementId ?? int.tryParse(order.id ?? '');
                      debugPrint(
                        '📦 RecentOrder tap: id=${order.id}, '
                        'incrementId=${order.incrementId}, numId=$numId',
                      );
                      if (numId != null) {
                        final repo = context.read<AccountRepository>();
                        OrderDetailPage.navigate(
                          context,
                          orderId: numId,
                          orderNumber: order.orderNumber,
                          repository: repo,
                        );
                      }
                    },
                    child: _buildOrderCard(context, order),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        child: Center(
          child: Text(
            'No recent orders',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, RecentOrder order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 270,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Row(
        children: [
          // Order details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Order number
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                // Status chip + date
                Row(
                  children: [
                    _buildStatusChip(order.status),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.formattedDate,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral300
                              : AppColors.neutral900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Total + item count
                Text(
                  '${order.formattedTotal} (Items ${order.itemCount})',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'processing':
        bgColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBEDBFF);
        textColor = const Color(0xFF2B7FFF);
        label = 'Processing';
        break;
      case 'completed':
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFFB9F8CF);
        textColor = const Color(0xFF00A63E);
        label = 'Completed';
        break;
      case 'pending':
        bgColor = const Color(0xFFFEF3C7);
        borderColor = const Color(0xFFFDE68A);
        textColor = const Color(0xFFD97706);
        label = 'Pending';
        break;
      case 'canceled':
      case 'cancelled':
        bgColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFFECACA);
        textColor = const Color(0xFFDC2626);
        label = 'Cancelled';
        break;
      case 'closed':
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF6B7280);
        label = 'Closed';
        break;
      default:
        bgColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBEDBFF);
        textColor = const Color(0xFF2B7FFF);
        label = status.isNotEmpty
            ? '${status[0].toUpperCase()}${status.substring(1)}'
            : 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
