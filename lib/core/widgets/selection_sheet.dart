import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable searchable bottom sheet for selecting an item from a list.
///
/// Works generically with any type [T]. Provide [itemLabel] to extract
/// the display string from each item. The sheet includes a search bar
/// for filtering long lists (e.g. countries, states).
///
/// Used by both the Account Address form and the Checkout Address form.
class SelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemLabel;
  final bool isDark;

  const SelectionSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    required this.itemLabel,
    required this.isDark,
  });

  /// Shows the selection sheet as a modal bottom sheet and returns the
  /// selected item, or `null` if the user dismissed it.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    T? selectedItem,
    required String Function(T) itemLabel,
    bool? isDark,
  }) {
    final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: dark ? AppColors.neutral800 : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SelectionSheet<T>(
        title: title,
        items: items,
        selectedItem: selectedItem,
        itemLabel: itemLabel,
        isDark: dark,
      ),
    );
  }

  @override
  State<SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<SelectionSheet<T>> {
  final _searchCtrl = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.itemLabel(item).toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: widget.isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: widget.isDark
                        ? AppColors.neutral400
                        : AppColors.neutral600,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: widget.isDark
                    ? AppColors.neutral200
                    : AppColors.neutral800,
              ),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(
                  color: AppColors.neutral500,
                  fontFamily: 'Roboto',
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.neutral500,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isDark
                        ? AppColors.neutral700
                        : AppColors.neutral200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isDark
                        ? AppColors.neutral700
                        : AppColors.neutral200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary500),
                ),
                filled: false,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── List ──
          Flexible(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No results found',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 8,
                    ),
                    itemBuilder: (ctx, index) {
                      final item = _filteredItems[index];
                      final label = widget.itemLabel(item);
                      final isSelected = item == widget.selectedItem;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context, item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontSize: 14,
                                      color: isSelected
                                          ? AppColors.primary500
                                          : (widget.isDark
                                                ? AppColors.neutral200
                                                : AppColors.neutral800),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: AppColors.primary500,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Shows a dialog for free-text state entry when no states are available
/// from the API for the selected country.
Future<String?> showFreeTextStateDialog({
  required BuildContext context,
  String? currentValue,
  bool? isDark,
}) async {
  final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
  final textController = TextEditingController(text: currentValue ?? '');
  final focusNode = FocusNode();

  final value = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: dark ? AppColors.neutral800 : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Enter State',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: dark ? AppColors.neutral200 : AppColors.neutral900,
        ),
      ),
      content: TextField(
        controller: textController,
        focusNode: focusNode,
        autofocus: true,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          color: dark ? AppColors.neutral200 : AppColors.neutral800,
        ),
        decoration: InputDecoration(
          hintText: 'State name',
          hintStyle: const TextStyle(color: AppColors.neutral500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            focusNode.unfocus();
            Navigator.pop(ctx);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: dark ? AppColors.neutral400 : AppColors.neutral600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final text = textController.text;
            focusNode.unfocus();
            Navigator.pop(ctx, text);
          },
          child: const Text(
            'OK',
            style: TextStyle(color: AppColors.primary500),
          ),
        ),
      ],
    ),
  );

  // Wait for the dialog dismiss animation to fully complete
  await WidgetsBinding.instance.endOfFrame;
  await WidgetsBinding.instance.endOfFrame;

  textController.dispose();
  focusNode.dispose();

  return value;
}
