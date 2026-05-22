import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/services/auth_storage.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchInvoiceDetails();
      }
    });
  }

  Future<void> _fetchInvoiceDetails() async {
    final l10n = AppLocalizations.of(context)!;
    // If invoice has numericId and we have a repository, fetch from API
    if (widget.invoice.numericId != null && widget.repository != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final invoice = await widget.repository!.getCustomerInvoice(
          widget.invoice.numericId!,
        );
        setState(() {
          _fetchedInvoice = invoice;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = l10n.accountFailedToLoadInvoiceDetails;
        });
      }
    }
  }

  // Use fetched invoice if available, otherwise use the passed invoice
  OrderInvoice get _displayInvoice => _fetchedInvoice ?? widget.invoice;

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
          l10n.accountInvoiceNumber(_displayInvoice.invoiceNumber),
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
                  if ((_displayInvoice.downloadUrl != null &&
                          _displayInvoice.downloadUrl!.isNotEmpty) ||
                      _displayInvoice.numericId != null)
                    _DownloadButton(
                      invoice: _displayInvoice,
                      downloadUrl: _displayInvoice.downloadUrl ?? '',
                    ),

                  const SizedBox(height: 24),

                  // ─── Items Section ───
                  _InvoiceItemsSection(
                    invoice: _displayInvoice,
                    order: widget.order,
                  ),

                  const SizedBox(height: 24),

                  // ─── Price Break ───
                  _InvoicePriceBreak(
                    invoice: _displayInvoice,
                    order: widget.order,
                  ),

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
              _errorMessage ?? l10n.accountFailedToLoadInvoiceDetails,
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
              child: Text(l10n.accountTryAgain),
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Invoice Status | Invoice Date
        Row(
          children: [
            Expanded(
              child: _InfoPair(
                label: l10n.accountInvoiceStatus,
                value: _invoiceStateLabel(invoice.state, l10n),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoPair(
                label: l10n.accountInvoiceDate,
                value: _formatDateTime(invoice.createdAt, l10n),
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
                label: l10n.accountOrderId,
                value: order.orderNumber,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoPair(
                label: l10n.accountOrderDate,
                value: _formatDateTime(order.createdAt, l10n),
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3: Order Status
        _InfoPair(
          label: l10n.accountOrderStatus,
          value: order.statusLabel,
          isDark: isDark,
        ),
      ],
    );
  }

  String _invoiceStateLabel(String? state, AppLocalizations l10n) {
    if (state == null || state.isEmpty) return l10n.accountNotAvailable;
    switch (state.toLowerCase()) {
      case 'paid':
        return l10n.accountStatusPaid;
      case 'pending':
        return l10n.accountStatusPending;
      case 'pending_payment':
        return l10n.accountStatusPendingPayment;
      case 'overdue':
        return l10n.accountStatusOverdue;
      case 'refunded':
        return l10n.accountStatusRefunded;
      default:
        return state[0].toUpperCase() + state.substring(1);
    }
  }

  /// Formats "2025-10-09T12:58:54.000000Z" → "09 Oct 2025, 12:58:54"
  String _formatDateTime(String? dateStr, AppLocalizations l10n) {
    if (dateStr == null || dateStr.isEmpty) return l10n.accountNotAvailable;
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        l10n.monthJanShort,
        l10n.monthFebShort,
        l10n.monthMarShort,
        l10n.monthAprShort,
        l10n.monthMayShort,
        l10n.monthJunShort,
        l10n.monthJulShort,
        l10n.monthAugShort,
        l10n.monthSepShort,
        l10n.monthOctShort,
        l10n.monthNovShort,
        l10n.monthDecShort,
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

  const _InvoiceItemsSection({required this.invoice, required this.order});

  @override
  State<_InvoiceItemsSection> createState() => _InvoiceItemsSectionState();
}

class _InvoiceItemsSectionState extends State<_InvoiceItemsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
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
                l10n.accountItemsOrdered(itemCount),
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

  List<String> _selectedOptionLines() {
    final additional = orderItem.additional;
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
                          orderItem.name,
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
                    if (optionLines.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () => _showMoreInfoSheet(context, optionLines),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
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
                      ),
                    ],
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
                    _qtyRow(
                      l10n.accountOrderedQty,
                      orderItem.qtyOrdered,
                      isDark,
                    ),
                    const SizedBox(height: 6),
                    _qtyRow(
                      l10n.accountShippedQty,
                      orderItem.qtyShipped,
                      isDark,
                    ),
                    const SizedBox(height: 6),
                    _qtyRow(
                      l10n.accountInvoicedQty,
                      orderItem.qtyInvoiced,
                      isDark,
                    ),
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
                          l10n.accountUnitPriceWithColon,
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
                          l10n.accountSubTotalWithColon,
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          l10n.cartPriceBreak,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
        const SizedBox(height: 8),

        _priceRow(l10n.cartSubTotal, _formatAmount(invoice.subTotal), isDark),
        const SizedBox(height: 6),
        _priceRow(
          l10n.cartDeliveryCharges,
          _formatAmount(invoice.shippingAmount ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow(l10n.cartTax, _formatAmount(invoice.taxAmount ?? 0), isDark),
        const SizedBox(height: 6),
        _priceRow(
          l10n.cartGrandTotal,
          _formatAmount(invoice.grandTotal),
          isDark,
          isBold: true,
        ),
        const SizedBox(height: 6),
        _priceRow(
          l10n.accountTotalPaid,
          _formatAmount(order.grandTotalInvoiced ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow(
          l10n.accountTotalRefunded,
          _formatAmount(order.grandTotalRefunded ?? 0),
          isDark,
        ),
        const SizedBox(height: 6),
        _priceRow(l10n.accountTotalDue, _formatAmount(order.totalDue), isDark),
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Billing Address
        _InvoiceInfoCard(
          title: l10n.accountBillingAddress,
          name: _buildAddressName(context, order.billingAddress),
          details: order.billingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Address
        _InvoiceInfoCard(
          title: l10n.accountShippingAddress,
          name: _buildAddressName(context, order.shippingAddress),
          details: order.shippingAddress?.formattedAddress,
        ),
        const SizedBox(height: 8),

        // Shipping Method
        _InvoiceInfoCard(
          title: l10n.accountShippingMethod,
          name:
              order.shippingTitle ??
              order.shippingMethod ??
              l10n.accountNotAvailable,
          details: order.shippingTitle ?? order.shippingMethod,
        ),
        const SizedBox(height: 8),

        // Payment Method
        _InvoiceInfoCard(
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

  String _buildAddressName(BuildContext context, OrderAddress? address) {
    final l10n = AppLocalizations.of(context)!;
    if (address == null) return l10n.accountNotAvailable;
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

class _DownloadButton extends StatefulWidget {
  final OrderInvoice invoice;
  final String downloadUrl;

  const _DownloadButton({required this.invoice, required this.downloadUrl});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _isDownloading ? null : () => _downloadInvoice(context),
        icon: _isDownloading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.download, size: 20),
        label: Text(
          l10n.accountDownloadInvoice,
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

  Future<void> _downloadInvoice(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => _isDownloading = true);

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
              Expanded(child: Text(l10n.accountDownloadWillStartShortly)),
            ],
          ),
          duration: const Duration(seconds: 30),
          behavior: SnackBarBehavior.floating,
        ),
      );

    try {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        throw const _InvoiceDownloadException('Missing customer access token');
      }

      final dir = await getApplicationDocumentsDirectory();
      final invoiceNumber =
          (widget.invoice.incrementId ??
                  widget.invoice.numericId?.toString() ??
                  'invoice')
              .replaceAll(RegExp(r'[^\w\-]'), '_');
      final savePath = '${dir.path}/invoice-$invoiceNumber.pdf';
      final resolvedDownloadUrl = _buildInvoiceDownloadUrl();
      final requestHeaders = <String, String>{
        'Authorization': 'Bearer $token',
        'X-STOREFRONT-KEY': storefrontKey,
      };

      _logInvoiceDownload('═══════════════════════════════════════════');
      _logInvoiceDownload('🧾 [Invoice Download Request]');
      _logInvoiceDownload('🔗 URL: $resolvedDownloadUrl');
      _logInvoiceDownload('🧾 Invoice ID: ${widget.invoice.id}');
      _logInvoiceDownload('🧾 Invoice Number: ${widget.invoice.invoiceNumber}');
      _logInvoiceDownload('💾 Save Path: $savePath');
      _logInvoiceDownload(
        '📋 Headers: ${_maskSensitiveHeaders(requestHeaders)}',
      );

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
      _logInvoiceDownload('✅ [Invoice Download Response]');
      _logInvoiceDownload('🔢 Status Code: $statusCode');
      _logInvoiceDownload('📋 Response Headers: ${response.headers.map}');
      _logInvoiceDownload('📍 Real URI: ${response.realUri}');
      _logInvoiceDownload('═══════════════════════════════════════════');

      if (statusCode < 200 || statusCode >= 300) {
        throw DioException.badResponse(
          statusCode: statusCode,
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!mounted) return;

      setState(() => _isDownloading = false);

      if (!context.mounted) return;

      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.accountInvoice} ${widget.invoice.invoiceNumber} downloaded',
            ),
            backgroundColor: AppColors.success500,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () => OpenFilex.open(savePath),
            ),
          ),
        );
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
      }

      if (!context.mounted) return;

      final message = e is DioException
          ? _dioErrorMessage(e)
          : e is _InvoiceDownloadException
          ? e.message
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

  String _buildInvoiceDownloadUrl() {
    final directDownloadUrl = widget.downloadUrl.trim();
    if (directDownloadUrl.isNotEmpty) {
      return _resolveDownloadUrl(directDownloadUrl);
    }

    final numericId = widget.invoice.numericId;
    if (numericId != null) {
      final origin = Uri.parse(bagistoEndpoint).origin;
      return '$origin/api/shop/customer-invoices/$numericId/pdf';
    }

    return directDownloadUrl;
  }

  String _resolveDownloadUrl(String downloadUrl) {
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

  String _dioErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    _logInvoiceDownload('❌ [Invoice Download Error]');
    _logInvoiceDownload('🔗 URL: ${error.requestOptions.uri}');
    _logInvoiceDownload(
      '📋 Request Headers: ${_maskSensitiveHeaders(error.requestOptions.headers)}',
    );
    _logInvoiceDownload('🔢 Status Code: $statusCode');
    _logInvoiceDownload('📋 Response Headers: ${error.response?.headers.map}');
    _logInvoiceDownload('📦 Response Body: ${_truncateForLog(responseData)}');
    _logInvoiceDownload('⚠️ Dio Message: ${error.message}');
    _logInvoiceDownload('═══════════════════════════════════════════');

    if (statusCode == 401) {
      return 'Unauthorized. Please log in again.';
    }

    if (statusCode == 403) {
      return 'You cannot download this invoice.';
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

  void _logInvoiceDownload(String message) {
    debugPrint(message);
    // ignore: avoid_print
    print(message);
  }
}

class _InvoiceDownloadException implements Exception {
  final String message;

  const _InvoiceDownloadException(this.message);
}
