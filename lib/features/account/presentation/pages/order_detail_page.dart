import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/order_detail_bloc.dart';
import 'invoice_detail_page.dart';
import 'shipment_detail_bottom_sheet.dart';

/// Order Detail Page — Figma node-id=233-5499
///
/// Displays full order details with:
///   - AppBar: "Orders #{incrementId}"
///   - Status chip + placed date
///   - Tab chips: Details · Invoices · Shipments
///   - Items list with qty breakdown + pricing
///   - Price Break section
///   - Address cards (billing, shipping)
///   - Shipping Method + Payment Method cards
///   - Bottom bar: Reorder + Write a Review
///
/// Architecture:
///   BlocProvider<OrderDetailBloc> → OrderDetailPage → Repository → GraphQL
class OrderDetailPage extends StatelessWidget {
  final int orderId;
  final String? orderNumber; // Pre-populated from list for instant AppBar title

  const OrderDetailPage({super.key, required this.orderId, this.orderNumber});

  /// Navigate to this page from any context.
  /// Requires an [AccountRepository] in the widget tree.
  static void navigate(
    BuildContext context, {
    required int orderId,
    String? orderNumber,
    required AccountRepository repository,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              OrderDetailBloc(repository: repository)
                ..add(LoadOrderDetail(orderId))
                ..add(LoadOrderInvoices(orderId))
                ..add(LoadOrderShipments(orderId)),
          child: OrderDetailPage(orderId: orderId, orderNumber: orderNumber),
        ),
      ),
    );
  }

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
        title: BlocBuilder<OrderDetailBloc, OrderDetailState>(
          buildWhen: (prev, curr) => prev.order != curr.order,
          builder: (context, state) {
            final title = state.order?.orderNumber ?? orderNumber ?? 'Order';
            return Text(
              'Orders $title',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.black,
              ),
            );
          },
        ),
      ),
      body: BlocConsumer<OrderDetailBloc, OrderDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != OrderDetailStatus.error &&
              state.status != OrderDetailStatus.reorderSuccess) {
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
            context.read<OrderDetailBloc>().add(
              const ClearOrderDetailMessage(),
            );
          }
          // Handle reorder success
          if (state.status == OrderDetailStatus.reorderSuccess &&
              state.successMessage != null) {
            final itemsCount = state.reorderItemsCount ?? 0;
            // Show dialog with OK and Go to Cart buttons
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Reorder Successful'),
                content: Text(
                  itemsCount > 0
                      ? '${state.successMessage!} \n\n$itemsCount items added to your cart.'
                      : state.successMessage!,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('OK'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      // Navigate to cart
                      AppNavigator.navigateToCart(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Go to Cart'),
                  ),
                ],
              ),
            );
            context.read<OrderDetailBloc>().add(
              const ClearOrderDetailMessage(),
            );
          }
        },
        builder: (context, state) {
          if (state.status == OrderDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrderDetailStatus.error) {
            return _buildErrorState(context, state.errorMessage);
          }

          final order = state.order;
          if (order == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return _OrderDetailBody(order: order, orderId: orderId);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Failed to load order details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral600,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<OrderDetailBloc>().add(LoadOrderDetail(orderId));
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Order Detail Body — tabbed content
// ──────────────────────────────────────────────

class _OrderDetailBody extends StatefulWidget {
  final OrderDetail order;
  final int orderId;
  const _OrderDetailBody({required this.order, required this.orderId});

  @override
  State<_OrderDetailBody> createState() => _OrderDetailBodyState();
}

class _OrderDetailBodyState extends State<_OrderDetailBody> {
  int _selectedTabIndex = 0;
  bool _invoicesExpanded = true;
  bool _shipmentsExpanded = true;

  static const _tabs = ['Details', 'Invoices', 'Shipments'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Status chip + placed date
                _buildStatusRow(isDark),

                const SizedBox(height: 16),

                // Tab chips
                _buildTabChips(isDark),

                const SizedBox(height: 16),

                // Tab content
                if (_selectedTabIndex == 0) _buildDetailsTab(isDark),
                if (_selectedTabIndex == 1) _buildInvoicesTab(isDark),
                if (_selectedTabIndex == 2) _buildShipmentsTab(isDark),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Bottom bar: Reorder only
        _buildBottomBar(isDark),
      ],
    );
  }

  // ─── Status Row ───
  // Figma: status chip + "Placed on {date}"
  Widget _buildStatusRow(bool isDark) {
    final order = widget.order;
    final chipColors = _getStatusColors(order.status);

    return Row(
      children: [
        // Status chip — Figma: rounded-54, px-8 py-4, Bold 12
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? chipColors.bg.withAlpha(40) : chipColors.bg,
            border: Border.all(
              color: isDark
                  ? chipColors.border.withAlpha(60)
                  : chipColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(54),
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

        const SizedBox(width: 8),

        // "Placed on {date}" — Figma: Roboto Regular 14, #737373
        Text(
          'Placed on ${order.formattedDate}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral400 : AppColors.neutral500,
          ),
        ),
      ],
    );
  }

  // ─── Tab Chips ───
  // Figma: active = bg rgba(255,105,0,0.1), border rgba(255,105,0,0.3), text #FF6900
  //        inactive = bg #F5F5F5, text #171717
  // Each tab has an icon: Details (info), Invoices (description), Shipments (local_shipping)
  Widget _buildTabChips(bool isDark) {
    const tabIcons = [
      Icons.info_outline,        // Details
      Icons.description_outlined, // Invoices
      Icons.local_shipping_outlined, // Shipments
    ];

    return Row(
      children: List.generate(_tabs.length, (index) {
        final isActive = index == _selectedTabIndex;
        return Padding(
          padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark
                          ? AppColors.primary500.withAlpha(25)
                          : const Color(0x1AFF6900))
                    : (isDark ? AppColors.neutral800 : AppColors.neutral100),
                border: Border.all(
                  color: isActive
                      ? (isDark
                            ? AppColors.primary500.withAlpha(80)
                            : const Color(0x4DFF6900))
                      : (isDark ? AppColors.neutral700 : AppColors.neutral200),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tabIcons[index],
                    size: 24,
                    color: isActive
                        ? AppColors.primary500
                        : (isDark ? AppColors.neutral200 : AppColors.neutral900),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _tabs[index],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isActive
                          ? AppColors.primary500
                          : (isDark ? AppColors.neutral200 : AppColors.neutral900),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── Details Tab ───
  Widget _buildDetailsTab(bool isDark) {
    final order = widget.order;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "N Items Ordered" header — Figma: Roboto SemiBold 16, #262626
        Text(
          '${order.items.length} Item${order.items.length == 1 ? '' : 's'} Ordered',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),

        const SizedBox(height: 12),

        // Item cards
        ...order.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ItemCard(item: item, currencySymbol: order.currencySymbol),
          ),
        ),

        const SizedBox(height: 16),

        // Price Break
        _PriceBreakSection(order: order),

        const SizedBox(height: 16),

        // Billing Address
        _InfoCard(
          title: 'Billing Address',
          name: order.billingAddress?.fullName ?? 'N/A',
          details: order.billingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Address
        _InfoCard(
          title: 'Shipping Address',
          name: order.shippingAddress?.fullName ?? 'N/A',
          details: order.shippingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Method
        _InfoCard(
          title: 'Shipping Method',
          name: order.shippingTitle ?? order.shippingMethod ?? 'N/A',
          details: null,
        ),
        const SizedBox(height: 8),

        // Payment Method
        _InfoCard(
          title: 'Payment Method',
          name: order.payment?.methodTitle ?? order.payment?.method ?? 'N/A',
          details: null,
        ),
      ],
    );
  }

  // ─── Invoices Tab ───
  // Figma node-id=2109-6148: "account-invoice-list"
  // Shows: "N Invoiced" header with toggle, simple invoice cards
  Widget _buildInvoicesTab(bool isDark) {
    // Use invoices from the API state if available, fallback to order invoices
    final invoices = context.select<OrderDetailBloc, List<OrderInvoice>>(
      (bloc) => bloc.state.invoices,
    );

    // If no API invoices, fall back to order invoices
    final orderInvoices = widget.order.invoices;
    final displayInvoices = invoices.isNotEmpty ? invoices : orderInvoices;

    if (displayInvoices.isEmpty) {
      return _buildEmptyTabContent(isDark, 'No invoices for this order');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "N Invoiced" header — Figma: Roboto Medium 14, #171717
        GestureDetector(
          onTap: () => setState(() => _invoicesExpanded = !_invoicesExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${displayInvoices.length} Invoiced',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
              Icon(
                _invoicesExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ],
          ),
        ),

        if (_invoicesExpanded) ...[
          const SizedBox(height: 8),
          // Invoice cards — Figma: simple cards with invoice # + date
          ...displayInvoices.map(
            (invoice) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _InvoiceListCard(
                invoice: invoice,
                onTap: () {
                  // Get repository from bloc
                  final bloc = context.read<OrderDetailBloc>();
                  InvoiceDetailPage.navigate(
                    context,
                    invoice: invoice,
                    order: widget.order,
                    repository: bloc.repo,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─── Shipments Tab ───
  // Figma node-id=2157-6159: "account-shipment-list"
  // Shows: "N Invoiced" header with toggle, simple shipment cards with date
  // Loads from API via bloc (customerOrderShipments)
  Widget _buildShipmentsTab(bool isDark) {
    // Use shipments from the API state if available, fallback to order shipments
    final apiShipments = context.select<OrderDetailBloc, List<OrderShipment>>(
      (bloc) => bloc.state.shipments,
    );
    final isLoading = context.select<OrderDetailBloc, bool>(
      (bloc) => bloc.state.shipmentsLoading,
    );

    final orderShipments = widget.order.shipments;
    final displayShipments = apiShipments.isNotEmpty ? apiShipments : orderShipments;

    if (isLoading && displayShipments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (displayShipments.isEmpty) {
      return _buildEmptyTabContent(isDark, 'No shipments for this order');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "N Invoiced" header — Figma: Roboto Medium 14, #171717
        GestureDetector(
          onTap: () => setState(() => _shipmentsExpanded = !_shipmentsExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${displayShipments.length} Invoiced',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
              Icon(
                _shipmentsExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ],
          ),
        ),

        if (_shipmentsExpanded) ...[
          const SizedBox(height: 8),
          // Shipment cards — Figma: simple cards with shipment # + date
          ...displayShipments.map(
            (shipment) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _ShipmentListCard(
                shipment: shipment,
                onTap: () {
                  // Show shipment detail bottom sheet
                  final bloc = context.read<OrderDetailBloc>();
                  ShipmentDetailBottomSheet.show(
                    context,
                    shipment: shipment,
                    bloc: bloc,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyTabContent(bool isDark, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: isDark ? AppColors.neutral600 : AppColors.neutral400,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Bar ───
  // Figma: bg #FAFAFA, px-16 py-7, gap-16
  // Reorder: bg #FF6900, rounded-54, Bold 16, white text
  Widget _buildBottomBar(bool isDark) {
    // Use the orderId passed to the _OrderDetailBody widget
    final isReordering = context.select<OrderDetailBloc, bool>(
      (bloc) => bloc.state.status == OrderDetailStatus.reordering,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isReordering
                ? null
                : () {
                    context.read<OrderDetailBloc>().add(ReorderOrder(widget.orderId));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(54),
              ),
            ),
            child: isReordering
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Reorder',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
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

// ──────────────────────────────────────────────
// Item Card — Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-12
// Shows: name, "More info" link, qty breakdown, pricing
// ──────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final OrderItem item;
  final String currencySymbol;

  const _ItemCard({required this.item, required this.currencySymbol});

  String _formatPrice(double amount) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + "More info"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name — Roboto Medium 14, #171717
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // "More info" link — Roboto Regular 14, #155DFC
                    Text(
                      'More info',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color(0xFF155DFC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Qty + Price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: qty labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _qtyRow('Ordered Qty', item.qtyOrdered, isDark),
                    const SizedBox(height: 4),
                    _qtyRow('Shipped', item.qtyShipped, isDark),
                    const SizedBox(height: 4),
                    _qtyRow('Invoiced', item.qtyInvoiced, isDark),
                  ],
                ),
              ),

              // Right: unit price + sub total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // "Unit Price" label — Roboto Regular 12, #737373
                  Text(
                    'Unit Price',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: isDark
                          ? AppColors.neutral500
                          : AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Price — Roboto Regular 14, #262626
                  Text(
                    _formatPrice(item.price),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // "Sub Total" label — Roboto Regular 12, #737373
                  Text(
                    'Sub Total',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: isDark
                          ? AppColors.neutral500
                          : AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Sub total — Roboto SemiBold 14, #262626
                  Text(
                    _formatPrice(item.total),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyRow(String label, int qty, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral500 : AppColors.neutral500,
            ),
          ),
        ),
        Text(
          ': $qty',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Price Break Section
// Figma: title Roboto SemiBold 16, rows Regular 14, Grand Total SemiBold
// ──────────────────────────────────────────────

class _PriceBreakSection extends StatelessWidget {
  final OrderDetail order;
  const _PriceBreakSection({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Break',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
        const SizedBox(height: 12),
        _priceRow(
          'SubTotal',
          order.formatAmount(order.subTotal),
          isDark,
          isBold: false,
        ),
        const SizedBox(height: 8),
        _priceRow(
          'Delivery Charges',
          order.formatAmount(order.shippingAmount ?? 0),
          isDark,
          isBold: false,
        ),
        const SizedBox(height: 8),
        _priceRow(
          'Tax',
          order.formatAmount(order.taxAmount ?? 0),
          isDark,
          isBold: false,
        ),
        if (order.discountAmount != null && order.discountAmount! > 0) ...[
          const SizedBox(height: 8),
          _priceRow(
            'Discount',
            '-${order.formatAmount(order.discountAmount)}',
            isDark,
            isBold: false,
          ),
        ],
        const SizedBox(height: 8),
        _priceRow('Grand Total', order.formattedTotal, isDark, isBold: true),
        const SizedBox(height: 8),
        _priceRow(
          'Total Paid',
          order.formatAmount(order.totalPaid),
          isDark,
          isBold: false,
          valueColor: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
        const SizedBox(height: 8),
        _priceRow(
          'Total Refunded',
          order.formatAmount(order.totalRefunded),
          isDark,
          isBold: false,
          valueColor: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
        const SizedBox(height: 8),
        _priceRow(
          'Total Due',
          order.formatAmount(order.totalDue),
          isDark,
          isBold: false,
          valueColor: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
      ],
    );
  }

  Widget _priceRow(
    String label,
    String value,
    bool isDark, {
    required bool isBold,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
            color:
                valueColor ??
                (isDark ? AppColors.neutral200 : AppColors.neutral800),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Info Card (Address / Shipping Method / Payment Method)
// Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-16
// Title: Roboto Regular 14, #737373
// Name: Roboto Bold 16, #262626
// Details: Roboto Regular 16, #262626
// ──────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final String name;
  final String? details;

  const _InfoCard({required this.title, required this.name, this.details});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title — Figma: Roboto Regular 14, #737373
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 4),

          // Name — Figma: Roboto Bold 16, #262626
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),

          if (details != null && details!.isNotEmpty) ...[
            const SizedBox(height: 4),
            // Address details — Figma: Roboto Regular 16, #262626
            Text(
              details!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Invoice List Card — Figma node-id=2109-6148
// Simple card: "Invoice #89945" + "Placed on : 8 Oct 2025"
// bg #F5F5F5, border #E5E5E5, rounded-10, p-12
// ──────────────────────────────────────────────

class _InvoiceListCard extends StatelessWidget {
  final OrderInvoice invoice;
  final VoidCallback onTap;

  const _InvoiceListCard({
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice number — Figma: Roboto Medium 16, #171717
            Text(
              'Invoice ${invoice.invoiceNumber}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 6),
            // Date — Figma: Roboto Regular 14, #404040
            Text(
              'Placed on :  ${invoice.formattedDate}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shipment List Card — Figma node-id=2157-6159
// Simple card: "Invoice #89945" + "Placed on : 8 Oct 2025"
// bg #F5F5F5, border #E5E5E5, rounded-10, p-12
// ──────────────────────────────────────────────

class _ShipmentListCard extends StatelessWidget {
  final OrderShipment shipment;
  final VoidCallback onTap;

  const _ShipmentListCard({
    required this.shipment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipment number — Figma: Roboto Medium 16, #171717
            Text(
              'Invoice ${shipment.shipmentNumber}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 6),
            // Date — Figma: Roboto Regular 14, #404040
            Text(
              'Placed on :  ${shipment.formattedDate}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Status Chip Colors
// ──────────────────────────────────────────────

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
