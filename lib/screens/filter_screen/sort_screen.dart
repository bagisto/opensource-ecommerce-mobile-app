import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_model/categories_data_model/filter_product_model.dart';
import '../../utils/app_global_data.dart';
import '../../utils/mobikul_theme.dart';
import '../../utils/shared_preference_helper.dart';
import '../../utils/string_constants.dart';
import '../../widgets/common_error_msg.dart';
import '../categories_screen/bloc/categories_bloc.dart';
import '../categories_screen/bloc/categories_event.dart';
import 'bloc/filter_bloc.dart';
import 'bloc/filter_event.dart';
import 'bloc/filter_state.dart';

//ignore: must_be_immutable
class SortBottomSheet extends StatefulWidget {
  final int? page;
  final CategoryBloc? subCategoryBloc;
  List<Map<String, dynamic>> filters;

  SortBottomSheet(
      {Key? key,
      this.categorySlug,
      this.page,
      this.subCategoryBloc, required this.filters})
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
    value = await SharedPreferenceHelper.getSortName();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: BlocConsumer<FilterBloc, FilterBaseState>(
        listener: (BuildContext context, FilterBaseState state) {},
        builder: (BuildContext context, FilterBaseState state) {
          return getSort(state);
        },
      ),
    );
  }

  Widget getSort(FilterBaseState state) {
    if (state is FilterInitialState) {
      return const Loader();
    }
    if (state is FilterFetchState) {
      if (state.status == FilterStatus.success) {
        data = state.filterModel?.sortOrders;
        return sortList();
      }
      if (state.status == FilterStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
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
                  widget.filters.removeWhere((element) => element["key"] == '\"sort\"');
                  widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                      widget.filters, widget.page));
                  widget.subCategoryBloc?.add(
                      OnClickSubCategoriesLoaderEvent(
                          isReqToShowLoader: true));
                  SharedPreferenceHelper.setSortName("");

                  Navigator.pop(context);
                },
                child: Text(StringConstants.clear.localized().toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: MobikulTheme.accentColor)),
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
                    activeColor: Theme.of(context).iconTheme.color,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                    ),
                    value: itemLabel,
                    groupValue: value,
                    onChanged: (ind) {
                      setState(() {
                        value = ind;
                        SharedPreferenceHelper.setSortName(value ?? "");
                      });

                      widget.filters.removeWhere((element) => element["key"] == '\"sort\"');

                      widget.filters.add({
                        "key": '\"sort\"',
                        "value": '\"${data?[index].value}\"'
                      });

                      widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                              widget.filters,
                              widget.page,));

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
