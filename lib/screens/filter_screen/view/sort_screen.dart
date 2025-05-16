/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/filter_screen/utils/index.dart';

class SortBottomSheet extends StatefulWidget {
  final int? page;
  final CategoryBloc? subCategoryBloc;
  final List<Map<String, dynamic>> filters;

  const SortBottomSheet(
      {Key? key,
      this.categorySlug,
      this.page,
      this.subCategoryBloc,
      required this.filters})
      : super(key: key);

  final String? categorySlug;

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<SortOrder>? data;
  String? value;

  @override
  void initState() {
    getSortValue();
    FilterBloc filterDataBloc = context.read<FilterBloc>();
    filterDataBloc.add(FilterSortFetchEvent(widget.categorySlug ?? ""));
    super.initState();
  }

  getSortValue() async {
    value = appStoragePref.getSortName();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc, FilterBaseState>(
      listener: (BuildContext context, FilterBaseState state) {},
      builder: (BuildContext context, FilterBaseState state) {
        return getSort(state);
      },
    );
  }

  Widget getSort(FilterBaseState state) {
    if (state is FilterInitialState) {
      return const Loader();
    }
    if (state is FilterFetchState) {
      data = state.filterModel?.sortOrders;
      return sortList();
    }
    return sortList();
  }

  sortList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringConstants.sortBy.localized(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () async {
                  widget.filters
                      .removeWhere((element) => element["key"] == '"sort"');
                  widget.subCategoryBloc
                      ?.add(FetchSubCategoryEvent(widget.filters, widget.page));
                  widget.subCategoryBloc?.add(
                      OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
                  appStoragePref.setSortName("");

                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.onBackground),
                child: Text(StringConstants.clear.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        )),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              var itemLabel = data?[index].title ?? "";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String?>(
                    dense: true,
                    activeColor: Theme.of(context).colorScheme.onBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                    ),
                    value: itemLabel,
                    groupValue: value,
                    onChanged: (ind) {
                      setState(() {
                        value = ind;
                        appStoragePref.setSortName(value ?? "");
                      });

                      widget.filters
                          .removeWhere((element) => element["key"] == '"sort"');

                      widget.filters.add({
                        "key": '"sort"',
                        "value": '"${data?[index].value}"'
                      });

                      widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                        widget.filters,
                        widget.page,
                      ));

                      widget.subCategoryBloc?.add(
                          OnClickSubCategoriesLoaderEvent(
                              isReqToShowLoader: true));

                      Navigator.pop(context);
                    },
                    title: Text(
                      itemLabel,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              );
            },
            itemCount: data?.length,
          ),
        ),
      ],
    );
  }
}
