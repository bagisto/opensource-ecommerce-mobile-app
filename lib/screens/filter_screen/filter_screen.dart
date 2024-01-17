import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:flutter/material.dart';
import '../../data_model/categories_data_model/filter_product_model.dart';
import '../../utils/app_global_data.dart';
import '../../utils/app_constants.dart';
import '../../utils/mobikul_theme.dart';
import '../categories_screen/bloc/categories_bloc.dart';
import '../categories_screen/bloc/categories_event.dart';

//ignore: must_be_immutable
class SubCategoriesFilterScreen extends StatefulWidget {
  SubCategoriesFilterScreen(
      {Key? key,
      this.categorySlug,
      this.page,
      this.subCategoryBloc,
      this.data,
      this.superAttributes, required this.filters})
      : super(key: key);

  List<Map<String, dynamic>> filters;
  List<FilterAttribute>? data;
  String? categorySlug;
  int? page;
  CategoryBloc? subCategoryBloc;
  List? superAttributes = [];

  @override
  State<SubCategoriesFilterScreen> createState() =>
      _SubCategoriesFilterScreenState();
}

class _SubCategoriesFilterScreenState extends State<SubCategoriesFilterScreen> {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, superAttributes);
            widget.subCategoryBloc
                ?.add(OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
            widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                widget.filters, widget.page));
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringConstants.filterBy.localized(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    superAttributes = [];
                    widget.filters.removeWhere((element) =>
                        element["key"] != '\"category_id\"' ||
                        element["key"] == '\"sort\"');

                    widget.subCategoryBloc?.add(FetchSubCategoryEvent(
                      widget.filters,
                      widget.page,
                    ));
                    Navigator.pop(context);
                    widget.subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                        isReqToShowLoader: true));
                  });
                },
                child: Text(
                  StringConstants.clear.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: MobikulTheme.accentColor),
                ))
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
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
                        itemCount: (widget.data ?? []).length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 12.0,
                            color: Theme.of(context).brightness==Brightness.light?Colors.grey.shade200:
                            Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal,
          AppSizes.spacingNormal, AppSizes.spacingNormal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (options?.isNotEmpty == true)
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          const Divider(),
          title == "Price"
              ? SliderTheme(
                data: const SliderThemeData(
                    showValueIndicator: ShowValueIndicator.always
                ),
                child: RangeSlider(
                  min: 0,
                  max: 500,
                  activeColor: Theme.of(context).colorScheme.onBackground,
                  inactiveColor: Colors.grey.shade300,
                  labels: RangeLabels(
                    startPriceValue.toString(),
                    endPriceValue.toString(),
                  ),
                  values: RangeValues(startPriceValue, endPriceValue),
                  onChanged: (RangeValues value) {
                    setState(() {

                      widget.filters.removeWhere((element) => element["key"] == '\"$code\"');

                      widget.filters.add({
                        "key": '\"$code\"',
                        "value": '\"${value.start}, ${value.end}\"'
                      });

                      temp[code]?.clear();
                      superAttributes.clear();
                      startPriceValue = value.start.ceilToDouble();
                      endPriceValue = value.end.ceilToDouble();

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
              : const SizedBox(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (options ?? []).length,
            itemBuilder: (ctx, index) {
              Option? option = options?[index];
              return CheckboxListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  value: showItems.contains(('\"${option?.id}\"')),
                  title: Text(
                    option?.adminName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onChanged: (isChecked) {
                    widget.filters.removeWhere(
                        (element) => element["key"] == '\"$code\"');

                    widget.filters.add(
                        {"key": '\"$code\"', "value": '\"${option?.id}\"'});

                    setState(() {
                      temp.addAll(showTemp);
                      if (temp[code]?.contains('\"${option?.id}\"') ?? false) {
                        temp[code]?.remove('\"${option?.id}\"');
                      } else {
                        temp[code]?.add('\"${option?.id}\"');
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
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ],
      ),
    );
  }
}
