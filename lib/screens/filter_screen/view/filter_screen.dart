import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/categories_data_model/filter_product_model.dart';
import '../../sub_categories/bloc/sub_categories_bloc.dart';
import '../../sub_categories/events/fetch_sub_categories_event.dart';
import '../../sub_categories/events/loader_sub_categories_event.dart';

// ignore: must_be_immutable
class FilterBottomSheet extends StatefulWidget {
  FilterBottomSheet(
      {Key? key,
      this.categorySlug,
      this.page,
      this.subCategoryBloc,
      this.data,
      this.superAttributes})
      : super(key: key);

  List<FilterAttribute>? data;
  String? categorySlug;
  int? page;
  SubCategoryBloc? subCategoryBloc;
  List? superAttributes = [];

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map<String, List> temp = {};
  Map<String, List> showTemp = {};
  List showItems = [];
  List superAttributes = [];
  List currentFilter = [];
  String? item;
  final GlobalKey globalKey = GlobalKey();
  double startPriceValue = 0, endPriceValue = 500;

  @override
  void initState() {
    if ((widget.superAttributes ?? []).isNotEmpty) {
      if (widget.superAttributes?[0]["key"] == "\"price\"") {
        startPriceValue = double.parse(
            widget.superAttributes?[0]["value"][0].replaceAll('"', ''));
        endPriceValue = double.parse(
            widget.superAttributes?[0]["value"][1].replaceAll('"', ''));
      }
    }
    fetchFilterData();
    super.initState();
  }

  fetchFilterData() {
    String? code;
    if ((widget.superAttributes ?? []).isNotEmpty) {
      for (var i in widget.superAttributes ?? []) {
        for (var data in widget.data!) {
          code = data.code;
          if (!(temp.containsKey(data.code))) {
            showTemp["${data.code}"] = [];
          }
          for (var options in data.options!) {
            for (var item in i["value"]) {
              if ('\"${options.id}\"' == item) {
                if (showTemp[code]?.contains('\"${options.id}\"') ?? false) {
                  showTemp[code]?.remove('\"${options.id}\"');
                } else {
                  showTemp[code]?.add('\"${options.id}\"');
                }
              }
            }
          }
          showTemp.forEach((key, value) {
            showItems.addAll(value);
          });
        }
      }
      currentFilter = (widget.superAttributes ?? []);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: globalKey,
      onTap: () {
        Navigator.pop(context, superAttributes);
        widget.subCategoryBloc
            ?.add(OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
        widget.subCategoryBloc?.add(FetchSubCategoryEvent(
            widget.categorySlug ?? "", widget.page, "", "",
            filter: superAttributes));
      },
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "FilterBy".localized(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                        onPressed: () {
                          setState(() {
                            superAttributes = [];
                            widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                                widget.categorySlug ?? "",
                                widget.page,
                                "",
                                ""));
                            Navigator.pop(context);
                            widget.subCategoryBloc?.add(
                                OnClickSubCategoriesLoaderEvent(
                                    isReqToShowLoader: true));
                          });
                        },
                        style: TextButton.styleFrom(
                            side: const BorderSide(),
                            backgroundColor: MobikulTheme.accentColor),
                        child: Text(
                          "Clear".localized().toUpperCase(),
                          style: TextStyle(color: MobikulTheme.primaryColor),
                        ))

              ],
            ),
            automaticallyImplyLeading: false,
          ),
          if ((currentFilter).isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20.0, 0, 10),
                      child: Row(
                        children: [
                          Text(
                            "currentFilter".localized(),
                            style: TextStyle(
                                color: MobikulTheme.accentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: currentFilter.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8.0, 0, 8),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
                                  color: MobikulTheme.borderColor,),

                                child: Row(
                                  children: [
                                    for (var data in widget.data!)
                                      if (currentFilter[index]["key"] ==
                                          '\"${data.code}\"')
                                        Text(
                                          "${data.adminName}:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                    for (var data in widget.data!)
                                      if ((data.options ?? []).isEmpty &&
                                          currentFilter[index]["key"] ==
                                              '\"price\"')
                                        for (var item in currentFilter[index]
                                            ["value"])
                                          Text(
                                            "${item.replaceAll('"', '')},",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                    for (var item in currentFilter[index]
                                        ["value"])
                                      for (var data in widget.data!)
                                        for (var items in data.options!)
                                          if ('\"${items.id}\"' == item)
                                            Text(
                                              "${items.adminName},",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, idx) {
                        if (!(temp.containsKey(widget.data?[idx].code))) {
                          temp["${widget.data?[idx].code}"] = [];
                        }
                        return _listElement(
                          "${widget.data?[idx].adminName}",
                          "${widget.data?[idx].code}",
                          widget.data?[idx].options,
                          context,
                        );
                      },
                      itemCount: widget.data?.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listElement(
    String title,
    String code,
    List<Option>? options,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.normalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold, fontSize: AppSizes.normalFontSize),
          ),
          title == "Price"
              ? SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    valueIndicatorShape: const RoundSliderOverlayShape(),
                    valueIndicatorTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 14.0),
                    rangeValueIndicatorShape:
                        const PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    min: 0,
                    max: 500,
                    divisions: 10,
                    activeColor: MobikulTheme.accentColor,
                    inactiveColor: Colors.grey.shade500,
                    labels: RangeLabels(
                      startPriceValue.toString(),
                      endPriceValue.toString(),
                    ),
                    values: RangeValues(startPriceValue, endPriceValue),
                    onChanged: (RangeValues value) {
                      setState(() {
                        temp[code]?.clear();
                        superAttributes.clear();
                        startPriceValue = value.start;
                        endPriceValue = value.end;
                        temp[code]?.add("\"$startPriceValue\"");
                        temp[code]?.add("\"$endPriceValue\"");
                        temp.forEach((key, value) {
                          if (value.isNotEmpty) {
                            Map<String, dynamic> colorMap = {
                              "key": '\"$key\"',
                              "value": value
                            };
                            superAttributes.add(colorMap);
                          }
                        });
                        currentFilter = superAttributes;
                      });
                    },
                  ),
                )
              : Container(),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options?.length,
              itemBuilder: (ctx, index) {
                return CheckboxListTile(
                    activeColor: MobikulTheme.accentColor,
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    visualDensity: const VisualDensity(),
                    value: showItems.contains(('\"${options?[index].id}\"')),
                    title: Text(
                      options?[index].adminName ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onChanged: (isChecked) {
                      setState(() {
                        temp.addAll(showTemp);
                        if (temp[code]?.contains('\"${options?[index].id}\"') ??
                            false) {
                          temp[code]?.remove('\"${options?[index].id}\"');
                        } else {
                          temp[code]?.add('\"${options?[index].id}\"');
                        }

                        showItems.clear();
                        temp.forEach((key, value) {
                          showItems.addAll(value);
                        });
                        superAttributes.clear();
                        temp.forEach((key, value) {
                          if (value.isNotEmpty) {
                            Map<String, dynamic> colorMap = {
                              "key": '\"$key\"',
                              "value": value
                            };
                            superAttributes.add(colorMap);
                          }
                        });
                        currentFilter = superAttributes;
                      });
                    });
              }),
        ],
      ),
    );
  }
}
