import 'package:flutter/material.dart';
import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
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
                AppLocalizations.of(context)!.categoryFilters,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      AppLocalizations.of(context)!.categoryClearAll,
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
                CurrencyFormatter.formatAmount(rangeMin, fractionDigits: 0),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
              Text(
                CurrencyFormatter.formatAmount(rangeMax, fractionDigits: 0),
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
        CurrencyFormatter.formatAmount(value, fractionDigits: 0),
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
        attr.code.toLowerCase() == 'color' ||
        attr.code.toLowerCase().contains('color') ||
        attr.displayName.toLowerCase().contains('color') ||
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
          final swatchColor = _parseColor(
            option.swatchValue,
            fallbackName: option.displayName,
          );

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
                              : AppColors.neutral300),
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
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: (swatchColor != null &&
                                  swatchColor.computeLuminance() > 0.65)
                              ? Colors.black87
                              : AppColors.white,
                        )
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
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color? _parseColor(String? hexOrName, {String? fallbackName}) {
    if (hexOrName != null && hexOrName.trim().isNotEmpty) {
      final hex = _parseHex(hexOrName);
      if (hex != null) return hex;
      final named = _getColorByName(hexOrName);
      if (named != null) return named;
    }
    if (fallbackName != null && fallbackName.trim().isNotEmpty) {
      final hex = _parseHex(fallbackName);
      if (hex != null) return hex;
      final named = _getColorByName(fallbackName);
      if (named != null) return named;
    }
    return null;
  }

  Color? _parseHex(String value) {
    try {
      final hex = value.trim().replaceFirst('#', '');
      if (hex.length == 6 && RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8 && RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(hex)) {
        return Color(int.parse(hex, radix: 16));
      }
      if (hex.length == 3 && RegExp(r'^[0-9a-fA-F]{3}$').hasMatch(hex)) {
        final r = hex[0];
        final g = hex[1];
        final b = hex[2];
        return Color(int.parse('FF$r$r$g$g$b$b', radix: 16));
      }
    } catch (_) {}
    return null;
  }

  static const Map<String, Color> _colorNameMap = {
    // Primary & basic
    'red': Color(0xFFE53935),
    'green': Color(0xFF43A047),
    'blue': Color(0xFF1E88E5),
    'yellow': Color(0xFFFDD835),
    'black': Color(0xFF000000),
    'white': Color(0xFFFFFFFF),
    'orange': Color(0xFFFB8C00),
    'purple': Color(0xFF8E24AA),
    'pink': Color(0xFFE91E63),
    'brown': Color(0xFF795548),
    'grey': Color(0xFF9E9E9E),
    'gray': Color(0xFF9E9E9E),

    // Blues
    'navy': Color(0xFF000080),
    'navy blue': Color(0xFF000080),
    'navyblue': Color(0xFF000080),
    'dark blue': Color(0xFF0D47A1),
    'darkblue': Color(0xFF0D47A1),
    'light blue': Color(0xFF64B5F6),
    'lightblue': Color(0xFF64B5F6),
    'sky blue': Color(0xFF87CEEB),
    'skyblue': Color(0xFF87CEEB),
    'royal blue': Color(0xFF4169E1),
    'royalblue': Color(0xFF4169E1),
    'baby blue': Color(0xFF89CFF0),
    'babyblue': Color(0xFF89CFF0),
    'cyan': Color(0xFF00BCD4),
    'teal': Color(0xFF00897B),
    'turquoise': Color(0xFF40E0D0),
    'aqua': Color(0xFF00FFFF),
    'indigo': Color(0xFF3F51B5),
    'denim': Color(0xFF1560BD),
    'midnight blue': Color(0xFF191970),
    'cobalt': Color(0xFF0047AB),

    // Reds & Pinks
    'crimson': Color(0xFFDC143C),
    'maroon': Color(0xFF800000),
    'burgundy': Color(0xFF800020),
    'wine': Color(0xFF722F37),
    'ruby': Color(0xFFE0115F),
    'scarlet': Color(0xFFFF2400),
    'coral': Color(0xFFFF7F50),
    'salmon': Color(0xFFFA8072),
    'hot pink': Color(0xFFFF69B4),
    'hotpink': Color(0xFFFF69B4),
    'light pink': Color(0xFFF8BBD0),
    'lightpink': Color(0xFFF8BBD0),
    'deep pink': Color(0xFFFF1493),
    'deeppink': Color(0xFFFF1493),
    'magenta': Color(0xFFFF00FF),
    'fuchsia': Color(0xFFFF00FF),
    'rose': Color(0xFFFF007F),
    'rose gold': Color(0xFFB76E79),
    'rosegold': Color(0xFFB76E79),
    'blush': Color(0xFFDE5D83),
    'peach': Color(0xFFFFDAB9),
    'rust': Color(0xFFB7410E),

    // Greens
    'dark green': Color(0xFF1B5E20),
    'darkgreen': Color(0xFF1B5E20),
    'light green': Color(0xFF81C784),
    'lightgreen': Color(0xFF81C784),
    'lime': Color(0xFFCDDC39),
    'lime green': Color(0xFF32CD32),
    'limegreen': Color(0xFF32CD32),
    'olive': Color(0xFF808000),
    'olive green': Color(0xFF556B2F),
    'olivegreen': Color(0xFF556B2F),
    'mint': Color(0xFF98FF98),
    'mint green': Color(0xFF98FF98),
    'mintgreen': Color(0xFF98FF98),
    'emerald': Color(0xFF50C878),
    'forest green': Color(0xFF228B22),
    'forestgreen': Color(0xFF228B22),
    'sage': Color(0xFF9CAF88),
    'sage green': Color(0xFF9CAF88),
    'sea green': Color(0xFF2E8B57),

    // Yellows & Oranges
    'light yellow': Color(0xFFFFF59D),
    'dark yellow': Color(0xFFFBC02D),
    'mustard': Color(0xFFFFDB58),
    'mustard yellow': Color(0xFFFFDB58),
    'gold': Color(0xFFFFD700),
    'golden': Color(0xFFFFD700),
    'amber': Color(0xFFFFBF00),
    'lemon': Color(0xFFFFF44F),
    'dark orange': Color(0xFFFF8C00),
    'light orange': Color(0xFFFFB74D),
    'apricot': Color(0xFFFBCEB1),
    'tangerine': Color(0xFFF28500),
    'terracotta': Color(0xFFE2725B),

    // Purples & Violets
    'violet': Color(0xFF7B1FA2),
    'dark purple': Color(0xFF4A148C),
    'light purple': Color(0xFFCE93D8),
    'lavender': Color(0xFFE6E6FA),
    'lilac': Color(0xFFC8A2C8),
    'plum': Color(0xFFDDA0DD),
    'mauve': Color(0xFFE0B0FF),
    'palatinate purple': Color(0xFF682860),

    // Neutrals & Greys
    'off white': Color(0xFFFAF9F6),
    'offwhite': Color(0xFFFAF9F6),
    'ivory': Color(0xFFFFFFF0),
    'cream': Color(0xFFFFFDD0),
    'snow': Color(0xFFFFFAFA),
    'pearl': Color(0xFFEAE0C8),
    'beige': Color(0xFFF5F5DC),
    'khaki': Color(0xFFC3B091),
    'tan': Color(0xFFD2B48C),
    'camel': Color(0xFFC19A6B),
    'sand': Color(0xFFC2B280),
    'caramel': Color(0xFFFFD59A),
    'chocolate': Color(0xFF7B3F00),
    'coffee': Color(0xFF6F4E37),
    'dark brown': Color(0xFF4E342E),
    'light brown': Color(0xFFBCAAA4),
    'copper': Color(0xFFB87333),
    'bronze': Color(0xFFCD7F32),
    'charcoal': Color(0xFF36454F),
    'jet black': Color(0xFF0A0A0A),
    'dark grey': Color(0xFF424242),
    'dark gray': Color(0xFF424242),
    'light grey': Color(0xFFE0E0E0),
    'light gray': Color(0xFFE0E0E0),
    'silver': Color(0xFFC0C0C0),
    'ash grey': Color(0xFFB2BEB5),
    'ash gray': Color(0xFFB2BEB5),
    'lavender grey': Color(0xFFC4C3D0),
    'slate': Color(0xFF708090),
    'slate grey': Color(0xFF708090),
    'slate gray': Color(0xFF708090),
    'dark lava': Color(0xFF483C32),
  };

  static Color? _getColorByName(String name) {
    final normalized = name.toLowerCase().trim();
    if (_colorNameMap.containsKey(normalized)) {
      return _colorNameMap[normalized];
    }
    final cleaned = normalized
        .replaceAll(RegExp(r'[-_/]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (_colorNameMap.containsKey(cleaned)) {
      return _colorNameMap[cleaned];
    }
    final noSpaces = cleaned.replaceAll(' ', '');
    if (_colorNameMap.containsKey(noSpaces)) {
      return _colorNameMap[noSpaces];
    }
    for (final part in cleaned.split(' ')) {
      if (_colorNameMap.containsKey(part)) {
        return _colorNameMap[part];
      }
    }
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
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // ── Color swatch (if any, for inline display) ──
                if ((option.hasColorSwatch || _isColorSwatchAttribute(attr)) &&
                    !option.hasImageSwatch) ...[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _parseColor(
                            option.swatchValue,
                            fallbackName: option.displayName,
                          ) ??
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
              AppLocalizations.of(context)!.categoryNoFiltersAvailable,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.neutral300 : AppColors.neutral700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.categoryFiltersWillAppear,
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
                ? AppLocalizations.of(context)!.categoryApplyFiltersCount(_totalSelected)
                : AppLocalizations.of(context)!.categoryApplyFilters,
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
