// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/filter_screen/event/filter_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../configuration/mobikul_theme.dart';
import '../../../helper/shared_preference_helper.dart';
import '../../../models/categories_data_model/filter_product_model.dart';
import '../../sub_categories/bloc/sub_categories_bloc.dart';
import '../../sub_categories/events/fetch_sub_categories_event.dart';
import '../../sub_categories/events/loader_sub_categories_event.dart';
import '../bloc/filter_bloc.dart';
import '../state/filter_state.dart';

class SortBottomSheet extends StatefulWidget {
  int? page;

  SubCategoryBloc ? subCategoryBloc;

   SortBottomSheet({Key? key, this.categorySlug,this.page,this.subCategoryBloc})
      : super(key: key);

  String ? categorySlug;


  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<SortOrder> ?data;
  String ? value="from-z-a";

  @override
  void initState() {
    get();
    FilterBloc filterDataBloc =
    context.read<FilterBloc>();
    filterDataBloc.add(FilterSortFetchEvent(widget.categorySlug ?? ""));
    super.initState();
  }
  get() async {
    value = await SharedPreferenceHelper.getSortName();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc,
        FilterBaseState>(
      listener: (BuildContext context, FilterBaseState state) {},
      builder: (BuildContext context, FilterBaseState state) {
        return getSort(state);
      },
    );
  }
  Widget getSort(FilterBaseState state) {
    if (state is FilterInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
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
  sortList(){
   return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SortBy".localized(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: MobikulTheme.accentColor,),
                onPressed: () async {
                   widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                      widget.categorySlug ?? "", widget.page, "", "" ));
                  widget.subCategoryBloc?.add(
                      OnClickSubCategoriesLoaderEvent(
                          isReqToShowLoader: true));
                  SharedPreferenceHelper.setSortName("");

                  Navigator.pop(context);
                },
                child:  Text('Clear'.localized().toUpperCase(),style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RadioListTile<String?>(
                  dense: true,
                  activeColor: MobikulTheme.accentColor,
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity: const VisualDensity(),
                  value:data?[index].label ?? "",
                  groupValue:value,
                  onChanged: (ind) {
                    setState(() {
                      value=ind;
                      SharedPreferenceHelper.setSortName(value ?? "");
                    });
                    widget.subCategoryBloc?.add(FetchSubCategoryEvent(widget.categorySlug ?? "", widget.page,data?[index].value?.sort,data?[index].value?.order,));
                    widget.subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
                    Navigator.pop(context);
                  },
                  title: Text(
                    "${data?[index].label?[0].toUpperCase()}${data?[index].label?.substring(1).toLowerCase()}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ),
              ],
            ),
            itemCount:data?.length,
          ),
        ),
      ],
    );
  }
}
