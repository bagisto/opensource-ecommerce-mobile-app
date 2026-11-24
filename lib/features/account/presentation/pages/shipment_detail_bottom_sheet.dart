import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';
import '../bloc/order_detail_bloc.dart';

/// Shipment Detail Bottom Sheet — Figma node-id=241-10773
///
/// Displays full shipment details as a modal bottom sheet with:
///   - Header: "Shipment #{shipmentNumber}" + close (X) button
///   - Tracking Number card (bg #F5F5F5, border #E5E5E5, rounded-10, p-12)
///   - "N Item(s)" label with toggle arrow
///   - Item cards: product name (Bold 16), SKU (Regular 14), Shipped Qty (Regular 14)
///   - Track button (bg #FF6900, rounded-54, Bold 16, white text)
///
/// Architecture:
///   Uses OrderDetailBloc for fetching individual shipment details via API.
class ShipmentDetailBottomSheet extends StatefulWidget {
  final OrderShipment shipment;
  final OrderDetailBloc bloc;

  const ShipmentDetailBottomSheet({
    super.key,
    required this.shipment,
    required this.bloc,
  });

  /// Show shipment detail as a modal bottom sheet.
  static void show(
    BuildContext context, {
    required OrderShipment shipment,
    required OrderDetailBloc bloc,
  }) {
    // Load shipment detail if we have a numeric ID
    if (shipment.numericId != null) {
      bloc.add(LoadShipmentDetail(shipment.numericId!));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: ShipmentDetailBottomSheet(shipment: shipment, bloc: bloc),
      ),
    );
  }

  @override
  State<ShipmentDetailBottomSheet> createState() =>
      _ShipmentDetailBottomSheetState();
}

class _ShipmentDetailBottomSheetState extends State<ShipmentDetailBottomSheet> {
  bool _itemsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      buildWhen: (prev, curr) =>
          prev.shipmentDetail != curr.shipmentDetail ||
          prev.shipmentDetailLoading != curr.shipmentDetailLoading,
      builder: (context, state) {
        // Use fetched detail if available, otherwise use passed shipment
        final displayShipment = state.shipmentDetail ?? widget.shipment;
        final isLoading = state.shipmentDetailLoading;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral900 : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ─── Header: "Shipment #000000003" + X ───
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.accountShipmentNumber(
                                displayShipment.shipmentNumber,
                              ),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: isDark
                                    ? AppColors.neutral200
                                    : AppColors.neutral900,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: isDark
                                    ? AppColors.neutral400
                                    : AppColors.neutral900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ─── Tracking Number Card ───
                      // Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-12
                      _TrackingNumberCard(shipment: displayShipment),

                      const SizedBox(height: 8),

                      // ─── "N Item(s)" header with toggle ───
                      GestureDetector(
                        onTap: () =>
                            setState(() => _itemsExpanded = !_itemsExpanded),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.accountItemsCount(
                                  displayShipment.items.length,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.neutral200
                                      : AppColors.neutral800,
                                ),
                              ),
                              Icon(
                                _itemsExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 20,
                                color: isDark
                                    ? AppColors.neutral400
                                    : AppColors.neutral700,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ─── Item Cards ───
                      if (_itemsExpanded)
                        ...displayShipment.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _ShipmentItemCard(item: item),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // ─── Track Button ───
                      // Figma: bg #FF6900, rounded-54, Bold 16, white text
                      if (displayShipment.trackNumber != null &&
                          displayShipment.trackNumber!.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              // Track action — can launch URL or show tracking info
                              _onTrackPressed(displayShipment);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(54),
                              ),
                            ),
                            child: Text(
                              l10n.accountTrack,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onTrackPressed(OrderShipment shipment) {
    final l10n = AppLocalizations.of(context)!;
    // Show a snackbar or launch tracking URL
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            l10n.accountTrackingVia(
              shipment.trackNumber ?? l10n.accountNotAvailable,
              shipment.carrierTitle ?? l10n.accountUnknownCarrier,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

// ──────────────────────────────────────────────
// Tracking Number Card
// Figma: bg #F5F5F5, border #E5E5E5, rounded-10, p-12
// "Tracking Number" — Roboto Regular 14, #262626
// Value — Roboto Bold 16, #262626
// ──────────────────────────────────────────────

class _TrackingNumberCard extends StatelessWidget {
  final OrderShipment shipment;

  const _TrackingNumberCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
          // "Tracking Number" label — Figma: Roboto Regular 14, #262626
          Text(
            l10n.accountTrackingNumber,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral300 : AppColors.neutral800,
            ),
          ),
          const SizedBox(height: 6),
          // Tracking number value — Figma: Roboto Bold 16, #262626
          Text(
            shipment.trackNumber ?? l10n.accountNotAvailable,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shipment Item Card — Figma node-id=241-10773
// bg #F5F5F5, border #E5E5E5, rounded-10, p-16
// Product name — Roboto Bold 16, #171717
// "SKU : {sku}" — Roboto Regular 14, #171717
// "Shipped Qty : {qty}" — Roboto Regular 14, #171717
// ──────────────────────────────────────────────

class _ShipmentItemCard extends StatelessWidget {
  final OrderShipmentItem item;

  const _ShipmentItemCard({required this.item});

  List<String> _selectedOptionLines() {
    final additional = item.additional;
    if (additional == null || additional.isEmpty) return const [];

    final optionSources = [
      additional['attributes'],
      additional['options'],
      additional['selected_options'],
      additional['selectedOptions'],
    ];

    final lines = <String>[];
    for (final source in optionSources) {
      lines.addAll(_extractOptionLines(source));
    }

    if (lines.isEmpty) {
      final superAttribute =
          additional['super_attribute'] ?? additional['superAttribute'];
      lines.addAll(_extractSuperAttributeLines(superAttribute));
    }

    return lines.toSet().toList();
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
            entryKey == 'id' ||
            entryKey == 'product_id' ||
            entryKey == 'cart_id' ||
            entryKey == 'locale' ||
            entryKey == 'quantity') {
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
        if ('$key' == '__typename' ||
            '$key' == 'product_id' ||
            '$key' == 'cart_id') {
          return;
        }
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

  Widget _buildOptionLine(String line, bool isDark) {
    final separatorIndex = line.indexOf(':');
    if (separatorIndex <= 0) {
      return Text(
        line,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
        ),
      );
    }

    final label = line.substring(0, separatorIndex).trim();
    final value = line.substring(separatorIndex + 1).trim();

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
        ),
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final optionLines = _selectedOptionLines();

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
          // Product name — Figma: Roboto Bold 16, #171717
          Text(
            item.name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          if (optionLines.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (final line in optionLines)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _buildOptionLine(line, isDark),
              ),
          ],
          const SizedBox(height: 6),
          // "SKU : {sku}" — Figma: Roboto Regular 14, #171717
          Text(
            l10n.accountSkuValue(item.sku ?? item.name),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),
          // "Shipped Qty : {qty}" — Figma: Roboto Regular 14, #171717
          Text(
            l10n.accountShippedQtyValue(item.qty),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}
