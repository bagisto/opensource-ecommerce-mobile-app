

import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';
import 'package:bagisto_app_demo/screens/filter_screen/utils/index.dart';

class SubCategoriesFilterScreen extends StatefulWidget {
  const SubCategoriesFilterScreen(
      {Key? key,
        this.categorySlug,
        this.page,
        this.subCategoryBloc,
        this.data,
        this.superAttributes, required this.filters})
      : super(key: key);

  final List<Map<String, dynamic>> filters;
  final GetFilterAttribute? data;
  final String? categorySlug;
  final int? page;
  final CategoryBloc? subCategoryBloc;
  final List? superAttributes;

  @override
  State<SubCategoriesFilterScreen> createState() =>
      _SubCategoriesFilterScreenState();
}

class _SubCategoriesFilterScreenState extends State<SubCategoriesFilterScreen> {
  Map<String, List> temp = {};
  Map<String, List> showTemp = {};
  List showItems = [];
  List superAttributes = [];
  String? item;
  double startPriceValue = 0, endPriceValue = 1;

  @override
  void initState() {
    if ((widget.superAttributes ?? []).isNotEmpty) {
      if (widget.superAttributes?[0]["key"] == "\"price\"") {
        startPriceValue = double.parse(
            widget.superAttributes?[0]["value"][0].replaceAll('"', ''));
        endPriceValue = double.parse(
            widget.superAttributes?[0]["value"][1].replaceAll('"', ''));
      }
      else{
        startPriceValue = widget.data?.minPrice ?? 0;
        endPriceValue = widget.data?.maxPrice ?? 1;
      }
    }
    else{
      startPriceValue = widget.data?.minPrice ?? 0;
      endPriceValue = widget.data?.maxPrice ?? 1;
    }
    fetchFilterData();
    super.initState();
  }

  fetchFilterData() {
    String? code;
    if ((widget.superAttributes ?? []).isNotEmpty) {
      for (var i in widget.superAttributes ?? []) {
        for (var data in widget.data?.filterAttributes ?? []) {
          code = data.code;
          if (!(temp.containsKey(data.code))) {
            showTemp["${data.code}"] = [];
          }
          if(data.code=="price"){
            showTemp[code]?.add('"$startPriceValue"');
            showTemp[code]?.add('"$endPriceValue"');
          }
          for (var options in data.options!) {
            for (var item in i["value"]) {
              if ('"${options.id}"' == item) {
                if (showTemp[code]?.contains('"${options.id}"') ?? false) {
                  showTemp[code]?.remove('"${options.id}"');
                } else {
                  showTemp[code]?.add('"${options.id}"');
                }
              }
            }
          }
          showTemp.forEach((key, value) {
            showItems.addAll(value);
          });
          debugPrint("superAttributes---->$showTemp");

        }
      }
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
            if(superAttributes.isNotEmpty) {
              debugPrint("superAttributes---->$superAttributes");
              Navigator.pop(context, superAttributes);
            }
            else {
              debugPrint("superAttributes---->${widget.superAttributes}");
              Navigator.pop(context, widget.superAttributes);
            }
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
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    superAttributes = [];
                    widget.filters.removeWhere((element) =>
                    element["key"] != '"category_id"' ||
                        element["key"] == '"sort"');

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
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: MobiKulTheme.appbarTextColor),
                ))
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
                        if (!(temp.containsKey(widget.data?.filterAttributes?[idx].code))) {
                          temp["${widget.data?.filterAttributes?[idx].code}"] = [];
                        }
                        return _listElement(
                          "${widget.data?.filterAttributes?[idx].adminName}",
                          "${widget.data?.filterAttributes?[idx].code}",
                          widget.data?.filterAttributes?[idx].options,
                          context,
                        );
                      },
                      itemCount: (widget.data?.filterAttributes ?? []).length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 12.0,
                          color: Theme.of(context).brightness==Brightness.light?Colors.grey.shade200:
                          Theme.of(context).colorScheme.secondaryContainer,
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
              min: widget.data?.minPrice ?? 0,
              max: widget.data?.maxPrice ?? 500,
              activeColor: Theme.of(context).colorScheme.onBackground,
              inactiveColor: Colors.grey.shade300,
              labels: RangeLabels(
                startPriceValue.toString(),
                endPriceValue.toString(),
              ),
              values: RangeValues(startPriceValue, endPriceValue),
              onChanged: (RangeValues value) {
                setState(() {

                  widget.filters.removeWhere((element) => element["key"] == '"$code"');

                  widget.filters.add({
                    "key": '"$code"',
                    "value": '"${value.start}, ${value.end}"'
                  });

                  temp[code]?.clear();
                  superAttributes.clear();
                  startPriceValue = value.start.floorToDouble();
                  endPriceValue = value.end.floorToDouble();
                  temp[code]?.add('"$startPriceValue"');
                  temp[code]?.add('"$endPriceValue"');
                  temp.addAll(showTemp);
                  temp.forEach((key, value) {
                    if (value.isNotEmpty) {
                      Map<String, dynamic> colorMap = {
                        "key": '"$key"',
                        "value": value
                      };
                      superAttributes.add(colorMap);
                    }
                  });
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
                  value: showItems.contains(('"${option?.id}"')),
                  title: Text(
                    option?.adminName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onChanged: (isChecked) {
                    if(isChecked == true){
                      int index =  widget.filters.indexWhere((element) => element["key"] == '"$code"');
                      if (index >= 0) {
                        Map<String, dynamic> item = widget.filters[index];
                        List<String> currentValues = item['value'].toString().replaceAll('"', "").split(',');
                        if (!currentValues.contains('${option?.id}')) {
                          currentValues.add('${option?.id}');
                        }
                        widget.filters[index] = {"key": '"$code"', "value": '"${currentValues.join(',')}"'};
                      } else {
                        widget.filters.add({
                          "key": '"$code"',
                          "value": '"${option?.id}"'
                        });
                      }
                    }
                    else {
                      int index = widget.filters.indexWhere((element) => element["key"] == '"$code"');

                      if (index >= 0) {
                        Map<String, dynamic> item = widget.filters[index];
                        List<String> currentValues = item['value'].toString().replaceAll('"', "").split(',');
                        currentValues.remove('${option?.id}');

                        if (currentValues.isEmpty) {
                          widget.filters.removeAt(index);
                        } else {
                          widget.filters[index] = {"key": '"$code"', "value": '"${currentValues.join(',')}"'};
                        }
                      }
                    }

                    setState(() {
                      temp.addAll(showTemp);
                      if (temp[code]?.contains('"${option?.id}"') ?? false) {
                        temp[code]?.remove('"${option?.id}"');
                      } else {
                        temp[code]?.add('"${option?.id}"');
                      }

                      showItems.clear();
                      temp.forEach((key, value) {
                        showItems.addAll(value);
                      });
                      superAttributes.clear();
                      showTemp.addAll(temp);
                      showTemp.forEach((key, value) {
                        if (value.isNotEmpty) {
                          Map<String, dynamic> colorMap = {
                            "key": '"$key"',
                            "value": value
                          };
                          superAttributes.add(colorMap);
                        }
                      });
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
