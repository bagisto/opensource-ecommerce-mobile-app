import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
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
///   BlocProvider OrderDetailBloc -> OrderDetailPage -> Repository -> GraphQL
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
          create: (_) => OrderDetailBloc(repository: repository)
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
        title: BlocBuilder<OrderDetailBloc, OrderDetailState>(
          buildWhen: (prev, curr) => prev.order != curr.order,
          builder: (context, state) {
            final title =
                state.order?.orderNumber ??
                orderNumber ??
                l10n.accountOrderSingular;
            return Text(
              l10n.accountOrdersWithNumber(title),
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
                title: Text(l10n.accountReorderSuccessful),
                content: Text(
                  itemsCount > 0
                      ? l10n.accountReorderItemsAdded(
                          state.successMessage!,
                          itemsCount,
                        )
                      : state.successMessage!,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(l10n.accountOk),
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
                    child: Text(l10n.accountGoToCart),
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
    final l10n = AppLocalizations.of(context)!;
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
              message ?? l10n.accountFailedToLoadOrderDetails,
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
              child: Text(l10n.accountTryAgain),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      l10n.accountDetails,
      l10n.accountInvoices,
      l10n.accountShipments,
    ];

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
                _buildTabChips(isDark, tabs),

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
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
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
          l10n.accountPlacedOn(order.formattedDate),
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
  Widget _buildTabChips(bool isDark, List<String> tabs) {
    const tabIcons = [
      Icons.info_outline, // Details
      Icons.description_outlined, // Invoices
      Icons.local_shipping_outlined, // Shipments
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(tabs.length, (index) {
        final isActive = index == _selectedTabIndex;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _selectedTabIndex = index),
            borderRadius: BorderRadius.circular(10),
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
                        : (isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isActive
                          ? AppColors.primary500
                          : (isDark
                                ? AppColors.neutral200
                                : AppColors.neutral900),
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "N Items Ordered" header — Figma: Roboto SemiBold 16, #262626
        Text(
          l10n.accountItemsOrdered(order.items.length),
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
          title: l10n.accountBillingAddress,
          name: order.billingAddress?.fullName ?? l10n.accountNotAvailable,
          details: order.billingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Address
        _InfoCard(
          title: l10n.accountShippingAddress,
          name: order.shippingAddress?.fullName ?? l10n.accountNotAvailable,
          details: order.shippingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Method
        _InfoCard(
          title: l10n.accountShippingMethod,
          name:
              order.shippingTitle ??
              order.shippingMethod ??
              l10n.accountNotAvailable,
          details: null,
        ),
        const SizedBox(height: 8),

        // Payment Method
        _InfoCard(
          title: l10n.accountPaymentMethod,
          name:
              order.payment?.methodTitle ??
              order.payment?.method ??
              l10n.accountNotAvailable,
          details: null,
        ),
      ],
    );
  }

  // ─── Invoices Tab ───
  // Figma node-id=2109-6148: "account-invoice-list"
  // Shows: "N Invoiced" header with toggle, simple invoice cards
  Widget _buildInvoicesTab(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    // Use invoices from the API state if available, fallback to order invoices
    final invoices = context.select<OrderDetailBloc, List<OrderInvoice>>(
      (bloc) => bloc.state.invoices,
    );

    // If no API invoices, fall back to order invoices
    final orderInvoices = widget.order.invoices;
    final displayInvoices = invoices.isNotEmpty ? invoices : orderInvoices;

    if (displayInvoices.isEmpty) {
      return _buildEmptyTabContent(isDark, l10n.accountNoInvoicesForOrder);
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
                l10n.accountInvoicedCount(displayInvoices.length),
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
    final l10n = AppLocalizations.of(context)!;
    // Use shipments from the API state if available, fallback to order shipments
    final apiShipments = context.select<OrderDetailBloc, List<OrderShipment>>(
      (bloc) => bloc.state.shipments,
    );
    final isLoading = context.select<OrderDetailBloc, bool>(
      (bloc) => bloc.state.shipmentsLoading,
    );

    final orderShipments = widget.order.shipments;
    final displayShipments = apiShipments.isNotEmpty
        ? apiShipments
        : orderShipments;

    if (isLoading && displayShipments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (displayShipments.isEmpty) {
      return _buildEmptyTabContent(isDark, l10n.accountNoShipmentsForOrder);
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
                l10n.accountInvoicedCount(displayShipments.length),
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
                    context.read<OrderDetailBloc>().add(
                      ReorderOrder(widget.orderId),
                    );
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
                : Text(
                    AppLocalizations.of(context)!.accountReorder,
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

  List<String> _selectedOptionLines() {
    final additional = item.additional;
    if (additional == null || additional.isEmpty) return const [];

    final optionSources = [
      additional['options'],
      additional['attributes'],
      additional['selected_options'],
      additional['selectedOptions'],
    ];

    for (final source in optionSources) {
      final lines = _extractOptionLines(source);
      if (lines.isNotEmpty) {
        return lines;
      }
    }

    final superAttribute =
        additional['super_attribute'] ?? additional['superAttribute'];
    final superAttributeLines = _extractSuperAttributeLines(superAttribute);
    if (superAttributeLines.isNotEmpty) {
      return superAttributeLines;
    }

    return const [];
  }

  List<String> _extractSuperAttributeLines(dynamic value) {
    if (value == null) return const [];

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return const [];
      try {
        return _extractSuperAttributeLines(jsonDecode(trimmed));
      } catch (_) {
        return <String>[trimmed];
      }
    }

    if (value is List) {
      return value
          .map((entry) => _formatOptionValue(entry))
          .where((entry) => entry.isNotEmpty)
          .toSet()
          .toList();
    }

    if (value is Map) {
      return value.values
          .map((entry) => _formatOptionValue(entry))
          .where((entry) => entry.isNotEmpty)
          .toSet()
          .toList();
    }

    final text = value.toString().trim();
    return text.isEmpty ? const [] : <String>[text];
  }

  List<String> _extractOptionLines(dynamic value) {
    if (value == null) return const [];

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return const [];
      try {
        return _extractOptionLines(jsonDecode(trimmed));
      } catch (_) {
        return <String>[trimmed];
      }
    }

    if (value is List) {
      return value
          .expand(_extractOptionLines)
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toSet()
          .toList();
    }

    if (value is Map) {
      final label = value['label']?.toString().trim();
      final rawOptionValue =
          value['value'] ?? value['optionValue'] ?? value['option_value'];
      final formattedValue = _formatOptionValue(rawOptionValue);

      if ((label ?? '').isNotEmpty && formattedValue.isNotEmpty) {
        return <String>['${label!} : $formattedValue'];
      }

      final attrName =
          (value['attributeName'] ??
                  value['attribute_name'] ??
                  value['attributename'])
              ?.toString()
              .trim();
      final optLabel =
          (value['optionLabel'] ??
                  value['option_label'] ??
                  value['optionlabel'])
              ?.toString()
              .trim();

      if ((attrName ?? '').isNotEmpty && (optLabel ?? '').isNotEmpty) {
        return <String>['$attrName : $optLabel'];
      }

      final lines = <String>[];
      value.forEach((key, entryValue) {
        final entryKey = '$key';
        if (entryKey == '__typename' ||
            entryKey == 'optionId' ||
            entryKey == 'option_id' ||
            entryKey == 'optionid' ||
            entryKey == 'id') {
          return;
        }

        final entryFormatted = _formatOptionValue(entryValue);
        if (entryFormatted.isNotEmpty &&
            entryValue is! Map &&
            entryValue is! List &&
            entryKey != 'label') {
          lines.add('${_normalizeOptionLabel(entryKey)} : $entryFormatted');
        } else {
          lines.addAll(_extractOptionLines(entryValue));
        }
      });
      return lines;
    }

    final text = value.toString().trim();
    return text.isEmpty ? const [] : <String>[text];
  }

  String _formatOptionValue(dynamic value) {
    if (value == null) return '';

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return '';
      try {
        return _formatOptionValue(jsonDecode(trimmed));
      } catch (_) {
        return trimmed;
      }
    }

    if (value is List) {
      return value
          .map(_formatOptionValue)
          .where((entry) => entry.isNotEmpty)
          .join(', ');
    }

    if (value is Map) {
      if (value.containsKey('label') && value.containsKey('value')) {
        return _formatOptionValue(value['value']);
      }

      final pieces = <String>[];
      value.forEach((key, entryValue) {
        if ('$key' == '__typename') return;
        final entryFormatted = _formatOptionValue(entryValue);
        if (entryFormatted.isEmpty) return;
        if (entryValue is Map || entryValue is List) {
          pieces.add(entryFormatted);
        } else {
          pieces.add('${_normalizeOptionLabel('$key')}: $entryFormatted');
        }
      });
      return pieces.join(', ');
    }

    return value.toString();
  }

  String _normalizeOptionLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .trim();
  }

  List<MapEntry<String, String>> _buildOptionEntries(List<String> lines) {
    return lines
        .map((line) {
          final separatorIndex = line.indexOf(':');
          if (separatorIndex <= 0) {
            final text = line.trim();
            return text.isEmpty ? null : MapEntry<String, String>('', text);
          }

          final label = line.substring(0, separatorIndex).trim();
          final value = line.substring(separatorIndex + 1).trim();
          if (label.isEmpty && value.isEmpty) return null;
          if (value.isEmpty) {
            return MapEntry<String, String>('', line.trim());
          }
          return MapEntry<String, String>(label, value);
        })
        .whereType<MapEntry<String, String>>()
        .toList();
  }

  Future<void> _showMoreInfoSheet(BuildContext context, List<String> lines) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final optionEntries = _buildOptionEntries(lines);

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final mediaQuery = MediaQuery.of(sheetContext);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral900 : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height * 0.72,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                mediaQuery.viewPadding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.neutral700
                            : AppColors.neutral300,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: isDark
                                ? AppColors.neutral100
                                : AppColors.neutral900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: l10n.accountClose,
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          minimumSize: const Size(40, 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral50,
                      border: Border.all(
                        color: isDark
                            ? AppColors.neutral700
                            : AppColors.neutral200,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      l10n.accountMoreInfo,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...optionEntries.asMap().entries.map((entry) {
                    final option = entry.value;
                    final isLast = entry.key == optionEntries.length - 1;

                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: option.key.isEmpty
                            ? Text(
                                option.value,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: isDark
                                      ? AppColors.neutral100
                                      : AppColors.neutral900,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.key,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    option.value,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: isDark
                                          ? AppColors.neutral100
                                          : AppColors.neutral900,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final optionLines = _selectedOptionLines();

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
                    if (optionLines.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () => _showMoreInfoSheet(context, optionLines),
                          child: Text(
                            l10n.accountMoreInfo,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF155DFC),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    _qtyRow(l10n.accountOrderedQty, item.qtyOrdered, isDark),
                    const SizedBox(height: 4),
                    _qtyRow(l10n.accountShipped, item.qtyShipped, isDark),
                    const SizedBox(height: 4),
                    _qtyRow(l10n.accountInvoiced, item.qtyInvoiced, isDark),
                  ],
                ),
              ),

              // Right: unit price + sub total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // "Unit Price" label — Roboto Regular 12, #737373
                  Text(
                    l10n.accountUnitPrice,
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
                    l10n.accountSubTotalWithSpace,
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cartPriceBreak,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.neutral800,
          ),
        ),
        const SizedBox(height: 12),
        _priceRow(
          l10n.cartSubTotal,
          order.formatAmount(order.subTotal),
          isDark,
          isBold: false,
        ),
        const SizedBox(height: 8),
        _priceRow(
          l10n.cartDeliveryCharges,
          order.formatAmount(order.shippingAmount ?? 0),
          isDark,
          isBold: false,
        ),
        const SizedBox(height: 8),
        _priceRow(
          l10n.cartTax,
          order.formatAmount(order.taxAmount ?? 0),
          isDark,
          isBold: false,
        ),
        if (order.discountAmount != null && order.discountAmount! > 0) ...[
          const SizedBox(height: 8),
          _priceRow(
            l10n.cartDiscount,
            '-${order.formatAmount(order.discountAmount)}',
            isDark,
            isBold: false,
          ),
        ],
        const SizedBox(height: 8),
        _priceRow(
          l10n.cartGrandTotal,
          order.formattedTotal,
          isDark,
          isBold: true,
        ),
        const SizedBox(height: 8),
        _priceRow(
          l10n.accountTotalPaid,
          order.formatAmount(order.totalPaid),
          isDark,
          isBold: false,
          valueColor: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
        const SizedBox(height: 8),
        _priceRow(
          l10n.accountTotalRefunded,
          order.formatAmount(order.totalRefunded),
          isDark,
          isBold: false,
          valueColor: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
        const SizedBox(height: 8),
        _priceRow(
          l10n.accountTotalDue,
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

  const _InvoiceListCard({required this.invoice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
              l10n.accountInvoiceNumber(invoice.invoiceNumber),
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
              l10n.accountPlacedOn(invoice.formattedDate),
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

  const _ShipmentListCard({required this.shipment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
              l10n.accountShipmentNumber(shipment.shipmentNumber),
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
              l10n.accountPlacedOn(shipment.formattedDate),
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
