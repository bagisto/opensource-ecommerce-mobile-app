import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/filter_model.dart';

/// Filter bottom sheet – Figma node 103:1558
///
/// Two-panel layout:
///  ┌─────────────────────────────────┐
///  │  Filters (3)      Clear All  ✕  │
///  ├──────────┬──────────────────────┤
///  │ Price    │  ○──────────●        │
///  │ Color ●  │  $0        $500     │
///  │ Size  ●  │                      │
///  │ Brand   │                      │
///  ├──────────┴──────────────────────┤
///  │       [ Apply Filters (3) ]     │
///  └─────────────────────────────────┘
class FilterBottomSheet extends StatefulWidget {
  final List<FilterAttribute> filterAttributes;
  final Map<String, Set<String>> activeFilters;
  final double? priceRangeMin;
  final double? priceRangeMax;
  final double? selectedPriceMin;
  final double? selectedPriceMax;
  final int? initialSelectedIndex;
  final VoidCallback onApply;
  final VoidCallback onClearAll;
  final void Function(String attributeCode, String optionId) onToggle;
  final void Function(double min, double max)? onPriceRangeChanged;

  const FilterBottomSheet({
    super.key,
    required this.filterAttributes,
    required this.activeFilters,
    this.priceRangeMin,
    this.priceRangeMax,
    this.selectedPriceMin,
    this.selectedPriceMax,
    this.initialSelectedIndex,
    required this.onApply,
    required this.onClearAll,
    required this.onToggle,
    this.onPriceRangeChanged,
  });

  static void show(
    BuildContext context, {
    required List<FilterAttribute> filterAttributes,
    required Map<String, Set<String>> activeFilters,
    double? priceRangeMin,
    double? priceRangeMax,
    double? selectedPriceMin,
    double? selectedPriceMax,
    int? initialSelectedIndex,
    required VoidCallback onApply,
    required VoidCallback onClearAll,
    required void Function(String attributeCode, String optionId) onToggle,
    void Function(double min, double max)? onPriceRangeChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        filterAttributes: filterAttributes,
        activeFilters: activeFilters,
        priceRangeMin: priceRangeMin,
        priceRangeMax: priceRangeMax,
        selectedPriceMin: selectedPriceMin,
        selectedPriceMax: selectedPriceMax,
        initialSelectedIndex: initialSelectedIndex,
        onApply: onApply,
        onClearAll: onClearAll,
        onToggle: onToggle,
        onPriceRangeChanged: onPriceRangeChanged,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, Set<String>> _localFilters;
  late double _localPriceMin;
  late double _localPriceMax;
  late int _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _localFilters = widget.activeFilters.map(
      (key, value) => MapEntry(key, Set<String>.from(value)),
    );
    _localPriceMin =
        widget.selectedPriceMin ?? widget.priceRangeMin ?? 0;
    _localPriceMax =
        widget.selectedPriceMax ?? widget.priceRangeMax ?? 10000;
    _selectedCategoryIndex = widget.initialSelectedIndex ?? 0;
  }

  void _toggleOption(String attributeCode, String optionId) {
    setState(() {
      final currentSet = _localFilters[attributeCode] ?? <String>{};
      if (currentSet.contains(optionId)) {
        currentSet.remove(optionId);
      } else {
        currentSet.add(optionId);
      }
      if (currentSet.isEmpty) {
        _localFilters.remove(attributeCode);
      } else {
        _localFilters[attributeCode] = currentSet;
      }
    });
    widget.onToggle(attributeCode, optionId);
  }

  int get _totalSelected {
    int count = 0;
    for (final values in _localFilters.values) {
      count += values.length;
    }
    // Count price filter if active
    if (_isPriceActive) count++;
    return count;
  }

  bool get _isPriceActive {
    final hasMinChange = widget.priceRangeMin != null &&
        _localPriceMin > widget.priceRangeMin!;
    final hasMaxChange = widget.priceRangeMax != null &&
        _localPriceMax < widget.priceRangeMax!;
    return hasMinChange || hasMaxChange;
  }

  int _selectedCountForAttribute(FilterAttribute attr) {
    if (attr.isPriceFilter) return _isPriceActive ? 1 : 0;
    return (_localFilters[attr.code] ?? {}).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxHeight = MediaQuery.of(context).size.height * 0.80;
    final attrs = widget.filterAttributes;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──
          _buildHeader(isDark),

          Divider(
            height: 1,
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),

          // ── Two-panel body ──
          Flexible(
            child: attrs.isEmpty
                ? _buildEmptyFilters(isDark)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: filter category navigation
                      _buildLeftPanel(isDark, attrs),

                      // Vertical divider
                      Container(
                        width: 1,
                        color: isDark
                            ? AppColors.neutral700
                            : AppColors.neutral200,
                      ),

                      // Right: filter options
                      Expanded(
                        child: _buildRightPanel(isDark, attrs),
                      ),
                    ],
                  ),
          ),

          // ── Apply Button ──
          _buildApplyButton(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: AppTextStyles.text3(context),
              ),
              if (_totalSelected > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$_totalSelected',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              if (_totalSelected > 0)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _localFilters.clear();
                      _localPriceMin = widget.priceRangeMin ?? 0;
                      _localPriceMax = widget.priceRangeMax ?? 10000;
                    });
                    widget.onClearAll();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  size: 24,
                  color:
                      isDark ? AppColors.neutral300 : AppColors.neutral800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Left navigation panel showing filter categories
  Widget _buildLeftPanel(bool isDark, List<FilterAttribute> attrs) {
    // Responsive: slightly wider on tablets
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth >= 600 ? 140.0 : 110.0;

    return SizedBox(
      width: panelWidth,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: attrs.length,
        itemBuilder: (context, index) {
          final attr = attrs[index];
          final isSelected = _selectedCategoryIndex == index;
          final count = _selectedCountForAttribute(attr);

          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? AppColors.neutral700
                        : AppColors.white)
                    : (isDark
                        ? AppColors.neutral800
                        : AppColors.neutral50),
                border: Border(
                  left: BorderSide(
                    color: isSelected
                        ? AppColors.primary500
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      attr.displayName,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary500
                            : (isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Right panel showing options for the selected filter
  Widget _buildRightPanel(bool isDark, List<FilterAttribute> attrs) {
    if (_selectedCategoryIndex >= attrs.length) return const SizedBox.shrink();
    final attr = attrs[_selectedCategoryIndex];

    if (attr.isPriceFilter) {
      return _buildPriceRangePanel(isDark, attr);
    }

    return _buildOptionsPanel(isDark, attr);
  }

  /// Price range slider panel
  Widget _buildPriceRangePanel(bool isDark, FilterAttribute attr) {
    final rangeMin = attr.minPrice ?? widget.priceRangeMin ?? 0;
    final rangeMax = attr.maxPrice ?? widget.priceRangeMax ?? 10000;

    // Clamp local values to valid range
    final currentMin = _localPriceMin.clamp(rangeMin, rangeMax);
    final currentMax = _localPriceMax.clamp(rangeMin, rangeMax);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attr.displayName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 24),

          // ── Price display row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceTag(isDark, currentMin),
              Container(
                width: 16,
                height: 1,
                color: AppColors.neutral400,
              ),
              _buildPriceTag(isDark, currentMax),
            ],
          ),

          const SizedBox(height: 20),

          // ── Range Slider ──
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary500,
              inactiveTrackColor:
                  isDark ? AppColors.neutral700 : AppColors.neutral200,
              thumbColor: AppColors.primary500,
              overlayColor: AppColors.primary500.withValues(alpha: 0.12),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
                pressedElevation: 4,
              ),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 8,
                pressedElevation: 4,
              ),
            ),
            child: RangeSlider(
              values: RangeValues(currentMin, currentMax),
              min: rangeMin,
              max: rangeMax,
              divisions: rangeMax > rangeMin
                  ? ((rangeMax - rangeMin) / 1).clamp(10, 200).toInt()
                  : 100,
              onChanged: (values) {
                setState(() {
                  _localPriceMin = values.start;
                  _localPriceMax = values.end;
                });
                widget.onPriceRangeChanged
                    ?.call(values.start, values.end);
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Range Labels ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${rangeMin.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
              Text(
                '\$${rangeMax.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTag(bool isDark, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.neutral600 : AppColors.neutral200,
        ),
        color: isDark ? AppColors.neutral700 : AppColors.neutral50,
      ),
      child: Text(
        '\$${value.toStringAsFixed(0)}',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.neutral900,
        ),
      ),
    );
  }

  /// Options panel for select/swatch attributes
  Widget _buildOptionsPanel(bool isDark, FilterAttribute attr) {
    final selectedValues = _localFilters[attr.code] ?? <String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  attr.displayName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.neutral200
                        : AppColors.neutral900,
                  ),
                ),
              ),
              if (selectedValues.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _localFilters.remove(attr.code);
                    });
                    // Clear each selected option
                    for (final id in selectedValues.toList()) {
                      widget.onToggle(attr.code, id);
                    }
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        Expanded(
          child: _isColorSwatchAttribute(attr)
              ? _buildColorSwatchGrid(isDark, attr, selectedValues)
              : _buildOptionsList(isDark, attr, selectedValues),
        ),
      ],
    );
  }

  bool _isColorSwatchAttribute(FilterAttribute attr) {
    return attr.swatchType == 'color' ||
        attr.code == 'color' ||
        attr.options.any((o) => o.hasColorSwatch);
  }

  /// Color swatch grid
  Widget _buildColorSwatchGrid(
    bool isDark,
    FilterAttribute attr,
    Set<String> selectedValues,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: attr.options.map((option) {
          final optionId = option.resolvedId;
          final isSelected = selectedValues.contains(optionId);
          final swatchColor = _parseColor(option.swatchValue);

          return GestureDetector(
            onTap: () => _toggleOption(attr.code, optionId),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: swatchColor ?? AppColors.neutral300,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary500
                          : (isDark
                              ? AppColors.neutral600
                              : AppColors.neutral200),
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary500
                                  .withValues(alpha: 0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 18, color: AppColors.white)
                      : null,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 56,
                  child: Text(
                    option.displayName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary500
                          : (isDark
                              ? AppColors.neutral300
                              : AppColors.neutral700),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 56,
                  child: Text(
                    option.swatchValue?.isNotEmpty == true
                        ? '#${option.swatchValue!.replaceFirst('#', '').toUpperCase()}'
                        : '',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.neutral500
                          : AppColors.neutral500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color? _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    try {
      final hex = hexColor.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return null;
  }

  /// Standard checkbox-style options list
  Widget _buildOptionsList(
    bool isDark,
    FilterAttribute attr,
    Set<String> selectedValues,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: attr.options.length,
      itemBuilder: (context, index) {
        final option = attr.options[index];
        final optionId = option.resolvedId;
        final isSelected = selectedValues.contains(optionId);

        return InkWell(
          onTap: () => _toggleOption(attr.code, optionId),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // ── Checkbox ──
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary500
                          : (isDark
                              ? AppColors.neutral500
                              : AppColors.neutral300),
                      width: 1.5,
                    ),
                    color: isSelected
                        ? AppColors.primary500
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 10),

                // ── Image swatch (if any) ──
                if (option.hasImageSwatch) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      option.swatchValueUrl!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // ── Color swatch (if any, for inline display) ──
                if (option.hasColorSwatch &&
                    !option.hasImageSwatch) ...[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _parseColor(option.swatchValue) ??
                          AppColors.neutral300,
                      border: Border.all(
                        color: isDark
                            ? AppColors.neutral600
                            : AppColors.neutral200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // ── Label ──
                Expanded(
                  child: Text(
                    option.displayName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: isSelected
                          ? (isDark
                              ? AppColors.white
                              : AppColors.neutral900)
                          : (isDark
                              ? AppColors.neutral300
                              : AppColors.neutral700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyFilters(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 12),
            Text(
              'No filters available',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.neutral300 : AppColors.neutral700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Filters will appear when available for this category',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            widget.onApply();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            _totalSelected > 0
                ? 'Apply Filters ($_totalSelected)'
                : 'Apply Filters',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
