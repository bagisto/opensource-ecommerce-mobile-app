import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

/// Invoice Detail Page — Figma node-id=240-10119
///
/// Displays full invoice details with:
///   - AppBar: "Invoice #{incrementId}"
///   - Info grid: Invoice Status, Invoice Date, Order ID, Order Date,
///                Order Status, Channel
///   - Items list with name, options, qty breakdown, pricing
///   - Price Break section
///   - Address cards (billing, shipping)
///   - Shipping Method + Payment Method cards
///
/// Fetches invoice details from API using customerInvoice query.
class InvoiceDetailPage extends StatefulWidget {
  final OrderInvoice invoice;
  final OrderDetail order;
  final AccountRepository? repository;

  const InvoiceDetailPage({
    super.key,
    required this.invoice,
    required this.order,
    this.repository,
  });

  /// Navigate to this page from any context.
  static void navigate(
    BuildContext context, {
    required OrderInvoice invoice,
    required OrderDetail order,
    AccountRepository? repository,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoiceDetailPage(
          invoice: invoice,
          order: order,
          repository: repository,
        ),
      ),
    );
  }

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  bool _isLoading = false;
  OrderInvoice? _fetchedInvoice;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInvoiceDetails();
  }

  Future<void> _fetchInvoiceDetails() async {
    // If invoice has numericId and we have a repository, fetch from API
    if (widget.invoice.numericId != null && widget.repository != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final invoice = await widget.repository!.getCustomerInvoice(widget.invoice.numericId!);
        setState(() {
          _fetchedInvoice = invoice;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load invoice details';
        });
      }
    }
  }

  // Use fetched invoice if available, otherwise use the passed invoice
  OrderInvoice get _displayInvoice => _fetchedInvoice ?? widget.invoice;

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
          'Invoice ${_displayInvoice.invoiceNumber}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState(isDark)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ─── Info Grid ───
                      _InvoiceInfoGrid(
                        invoice: _displayInvoice,
                        order: widget.order,
                      ),

                      const SizedBox(height: 16),

                      // Download Invoice Button
                      if (_displayInvoice.downloadUrl != null &&
                          _displayInvoice.downloadUrl!.isNotEmpty)
                        _DownloadButton(
                          downloadUrl: _displayInvoice.downloadUrl!,
                        ),

                      const SizedBox(height: 24),

                      // ─── Items Section ───
                      _InvoiceItemsSection(
                        invoice: _displayInvoice,
                        order: widget.order,
                      ),

                      const SizedBox(height: 24),

                      // ─── Price Break ───
                      _InvoicePriceBreak(invoice: _displayInvoice, order: widget.order),

                      const SizedBox(height: 24),

                      // ─── Address & Method Cards ───
                      _InvoiceInfoCards(order: widget.order),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErrorState(bool isDark) {
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
              _errorMessage ?? 'Failed to load invoice details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral600,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _fetchInvoiceDetails,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Info Grid — Figma: 2-column layout with label/value pairs
// Label: Roboto Regular 12, #262626
// Value: Roboto SemiBold 14, #262626
// Gap between rows: 16px, between columns: 12px
// ──────────────────────────────────────────────

class _InvoiceInfoGrid extends StatelessWidget {
  final OrderInvoice invoice;
  final OrderDetail order;

  const _InvoiceInfoGrid({required this.invoice, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Invoice Status | Invoice Date
        Row(
          children: [
            Expanded(
              child: _InfoPair(
                label: 'Invoice Status',
                value: _invoiceStateLabel(invoice.state),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoPair(
                label: 'Invoice Date',
                value: _formatDateTime(invoice.createdAt),
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: Order ID | Order Date
        Row(
          children: [
            Expanded(
              child: _InfoPair(
                label: 'Order ID',
                value: order.orderNumber,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoPair(
                label: 'Order Date',
                value: _formatDateTime(order.createdAt),
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3: Order Status | Channel
        Row(
          children: [
            Expanded(
              child: _InfoPair(
                label: 'Order Status',
                value: order.statusLabel,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoPair(
                label: 'Channel',
                value: order.channelName ?? 'Default',
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _invoiceStateLabel(String? state) {
    if (state == null || state.isEmpty) return 'N/A';
    switch (state.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'pending_payment':
        return 'Pending Payment';
      case 'overdue':
        return 'Overdue';
      case 'refunded':
        return 'Refunded';
      default:
        return state[0].toUpperCase() + state.substring(1);
    }
  }

  /// Formats "2025-10-09T12:58:54.000000Z" → "09 Oct 2025, 12:58:54"
  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final day = date.day.toString().padLeft(2, '0');
      final month = months[date.month - 1];
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final min = date.minute.toString().padLeft(2, '0');
      final sec = date.second.toString().padLeft(2, '0');
      return '$day $month $year, $hour:$min:$sec';
    } catch (_) {
      return dateStr;
    }
  }
}

class _InfoPair extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InfoPair({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label — Figma: Roboto Regular 12, #262626
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: isDark ? AppColors.neutral400 : AppColors.neutral800,
          ),
        ),
        const SizedBox(height: 2),
        // Value — Figma: Roboto SemiBold 14, #262626
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Items Section — Figma: "N Items Ordered" + collapsible item cards
// ──────────────────────────────────────────────

class _InvoiceItemsSection extends StatefulWidget {
  final OrderInvoice invoice;
  final OrderDetail order;

  const _InvoiceItemsSection({
    required this.invoice,
    required this.order,
  });

  @override
  State<_InvoiceItemsSection> createState() => _InvoiceItemsSectionState();
}

class _InvoiceItemsSectionState extends State<_InvoiceItemsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemCount = widget.invoice.items.isNotEmpty
        ? widget.invoice.items.length
        : widget.order.items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "N Items Ordered" + toggle
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemCount Item${itemCount == 1 ? '' : 's'} Ordered',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ],
          ),
        ),

        if (_isExpanded) ...[
          const SizedBox(height: 8),
          // Item cards
          ...widget.order.items.map((orderItem) {
            // Find matching invoice item by sku or name for pricing
            final invoiceItem = _findInvoiceItem(orderItem);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _InvoiceItemCard(
                orderItem: orderItem,
                invoiceItem: invoiceItem,
                currencySymbol: widget.order.currencySymbol,
              ),
            );
          }),
        ],
      ],
    );
  }

  /// Match order item to invoice item by sku or name
  OrderInvoiceItem? _findInvoiceItem(OrderItem orderItem) {
    if (widget.invoice.items.isEmpty) return null;
    try {
      return widget.invoice.items.firstWhere(
        (ii) =>
            (ii.sku != null &&
                orderItem.sku != null &&
                ii.sku == orderItem.sku) ||
            ii.name == orderItem.name,
      );
    } catch (_) {
      return null;
    }
  }
}

// ──────────────────────────────────────────────
// Invoice Item Card — Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-12
// Shows: name, options, qty breakdown, pricing
// ──────────────────────────────────────────────

class _InvoiceItemCard extends StatelessWidget {
  final OrderItem orderItem;
  final OrderInvoiceItem? invoiceItem;
  final String currencySymbol;

  const _InvoiceItemCard({
    required this.orderItem,
    this.invoiceItem,
    required this.currencySymbol,
  });

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
          // Top row: Name + Options
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name — Roboto Medium 16, #171717
                    Text(
                      orderItem.name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Options / variant text — Roboto Regular 14, #404040
                    if (_getOptionsText().isNotEmpty)
                      Text(
                        _getOptionsText(),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Qty + Price breakdown
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Qty breakdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _qtyRow('Ordered Qty', orderItem.qtyOrdered, isDark),
                    const SizedBox(height: 6),
                    _qtyRow('Shipped Qty', orderItem.qtyShipped, isDark),
                    const SizedBox(height: 6),
                    _qtyRow('Invoiced Qty', orderItem.qtyInvoiced, isDark),
                  ],
                ),
              ),

              // Right: Unit Price + Sub Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Unit Price row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Unit Price :',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPrice(invoiceItem?.price ?? orderItem.price),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Sub Total row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Sub Total :',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.neutral400
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPrice(invoiceItem?.total ?? orderItem.total),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Extract options from additional data
  String _getOptionsText() {
    final additional = orderItem.additional;
    if (additional == null) return '';

    // Try to build options string from 'attributes' or 'options'
    final attrs = additional['attributes'];
    if (attrs is Map) {
      return attrs.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');
    }

    // For configurable products, try super_attribute
    final superAttr = additional['super_attribute'];
    if (superAttr is Map) {
      return superAttr.entries
          .map((e) => '${e.value}')
          .join('-');
    }

    return '';
  }

  Widget _qtyRow(String label, int qty, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral700,
            ),
          ),
        ),
        Text(
          ': $qty',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral700,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Price Break Section — Figma: matching order detail price break
// Title: Roboto SemiBold 16, black
// Rows: Regular 14, #262626 — Grand Total: SemiBold
// ──────────────────────────────────────────────

class _InvoicePriceBreak extends StatelessWidget {
  final OrderInvoice invoice;
  final OrderDetail order;

  const _InvoicePriceBreak({required this.invoice, required this.order});

  String _formatAmount(double? amount) {
    final sym = order.currencySymbol;
    if (amount == null) return '${sym}0.00';
    return '$sym${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Price Break',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
        const SizedBox(height: 8),

        _priceRow('SubTotal', _formatAmount(invoice.subTotal), isDark),
        const SizedBox(height: 6),
        _priceRow(
          'Delivery Charges',
          _formatAmount(invoice.shippingAmount ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow('Tax', _formatAmount(invoice.taxAmount ?? 0), isDark),
        const SizedBox(height: 6),
        _priceRow(
          'Grand Total',
          _formatAmount(invoice.grandTotal),
          isDark,
          isBold: true,
        ),
        const SizedBox(height: 6),
        _priceRow(
          'Total Paid',
          _formatAmount(order.grandTotalInvoiced ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow(
          'Total Refunded',
          _formatAmount(order.grandTotalRefunded ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow(
          'Total Due',
          _formatAmount(order.totalDue),
          isDark,
        ),
      ],
    );
  }

  Widget _priceRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
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
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Info Cards (Billing, Shipping Address, Shipping/Payment Method)
// Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-16
// ──────────────────────────────────────────────

class _InvoiceInfoCards extends StatelessWidget {
  final OrderDetail order;

  const _InvoiceInfoCards({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Billing Address
        _InvoiceInfoCard(
          title: 'Billing Address',
          name: _buildAddressName(order.billingAddress),
          details: order.billingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Address
        _InvoiceInfoCard(
          title: 'Shipping Address',
          name: _buildAddressName(order.shippingAddress),
          details: order.shippingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Method
        _InvoiceInfoCard(
          title: 'Shipping Method',
          name: order.shippingTitle ?? order.shippingMethod ?? 'N/A',
          details: order.shippingTitle ?? order.shippingMethod,
        ),
        const SizedBox(height: 8),

        // Payment Method
        _InvoiceInfoCard(
          title: 'Payment Method',
          name: order.payment?.methodTitle ?? order.payment?.method ?? 'N/A',
          details: null,
        ),
      ],
    );
  }

  String _buildAddressName(OrderAddress? address) {
    if (address == null) return 'N/A';
    final name = address.fullName;
    final company = address.companyName;
    if (company != null && company.isNotEmpty) {
      return '$name ($company)';
    }
    return name;
  }
}

class _InvoiceInfoCard extends StatelessWidget {
  final String title;
  final String name;
  final String? details;

  const _InvoiceInfoCard({
    required this.title,
    required this.name,
    this.details,
  });

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
          // Title — Figma: Roboto Regular 14, #171717
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),

          // Name — Figma: Roboto Bold 16, #171717
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),

          if (details != null && details!.isNotEmpty) ...[
            const SizedBox(height: 6),
            // Details — Figma: Roboto Regular 16, #171717
            Text(
              details!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Download Button Widget
// ──────────────────────────────────────────────

class _DownloadButton extends StatelessWidget {
  final String downloadUrl;

  const _DownloadButton({required this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _openPdfInApp(context, downloadUrl),
        icon: const Icon(Icons.download, size: 20),
        label: const Text(
          'Download Invoice',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(54),
          ),
        ),
      ),
    );
  }

  void _openPdfInApp(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PdfViewerPage(pdfUrl: url),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// PDF Viewer Page
// ──────────────────────────────────────────────

class _PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const _PdfViewerPage({required this.pdfUrl});

  @override
  State<_PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<_PdfViewerPage> {
  InAppWebViewController? _webViewController;
  double _loadingProgress = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        leading: AppBackButton(),
        leadingWidth: 60,
        title: const Text(
          'Invoice',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_loadingProgress < 1.0)
            LinearProgressIndicator(
              value: _loadingProgress,
              backgroundColor: isDark ? AppColors.neutral800 : AppColors.neutral100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary500),
            ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.pdfUrl)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {},
              onLoadStop: (controller, url) {},
              onProgressChanged: (controller, progress) {
                setState(() {
                  _loadingProgress = progress / 100;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),
        ],
      ),
    );
  }
}
