/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../../../utils/radio_button_group.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class BundleOptionsView extends StatefulWidget {
  final Function(List)? callBack;
  final List<BundleOptions>? options;

  const BundleOptionsView({Key? key, this.options, this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BundleOptionsViewState();
  }
}

class _BundleOptionsViewState extends State<BundleOptionsView> {
  List newData = [];
  String? currentId;
  var bundleData = <dynamic, dynamic>{};
  var selectedQuantity = <String, String>{};
  List<BundleData> qtyArray = [];
  double totalAmount = 0.0;
  double dropDownTotal = 0.0;
  String totalUsingFold = "";
  String selectedProductName = '';
  bool dropDownChange = false;
  Map<String, int> selectedProductQty = {};
  BundleOptionProducts? radioSelectedProduct;
  Map<String, double> selectedPrices = {};

  String productIdKey = "productIdKey",
      quantityKey = "quantityKey",
      priceKey = "priceKey";
  Map<String, Map<String, dynamic>> selectedOptionsGlobal = {};
  Map<String, Set<Map<String, dynamic>>> selectedOptionsGlobalList = {};
  Map<String, BundleOptionProducts?> selectedRadio = {};

  @override
  void initState() {
    Map<String, dynamic> map = {};
    Map<String, List<int>> listMap = {};
    bundleData = {"bundleOptionQuantity": map, "bundleOptions": listMap};
    widget.options?.forEach((element) {
      element.bundleOptionProducts?.forEach((item) {
        if (item.isDefault == true) {
          String formattedPrice =
              (item.product?.priceHtml?.finalPrice ?? "").isEmpty
                  ? (item.product?.priceHtml?.regularPrice ?? "0")
                  : (item.product?.priceHtml?.finalPrice ?? "0");


          double price = double.parse(formattedPrice) * (item.qty ?? 1);
          selectedPrices[element.id ?? ""] = price;
          totalAmount = double.parse((totalAmount + price).toStringAsFixed(2));
          (bundleData['bundleOptionQuantity']
                  as Map<String, dynamic>?)?[element.id.toString()] =
              item.qty.toString();
          bundleData["bundleOptions"]
              ?[element.id.toString()] = [int.parse(item.id ?? "0")];

          if (element.type == StringConstants.checkBoxText ||
              element.type == StringConstants.multiSelect) {
            addToDataSet(element.id.toString() ?? "", item.productId ?? "0",
                price, item.qty ?? 1);
          } else {
            addDataToMap(element.id.toString() ?? "", item.productId ?? "0",
                price, item.qty ?? 1);
          }
        }
      });
    });
    super.initState();

    widget.options?.forEach((element) {
      for (var item in element.bundleOptionProducts ?? []) {
        if (item.isDefault == true) {
          _updateOptions(
              int.parse(element.id ?? ''), int.parse(item.id ?? ''), -1, true,
              qty: item?.qty?.toString() ?? "1");
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    totalAmount = 0;
    selectedOptionsGlobal.forEach((key, value) {
      totalAmount = totalAmount + (value[priceKey] ?? 0);
    });
    selectedOptionsGlobalList.forEach((key, value) {
      for (var element in value) {
        totalAmount = totalAmount + (element[priceKey] ?? 0);
      }
    });

    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.customizeOptions.localized(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.options?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = widget.options?[index];
                  switch (item?.type ?? '') {
                    case StringConstants.select:
                      return _getTextField(item);
                    case StringConstants.radioText:
                      return _getRadioButtonType(item);
                    case StringConstants.checkBoxText:
                      return _getCheckBoxType(item);
                    case StringConstants.multiSelect:
                      return _getCheckBoxType(item);
                    default:
                      break;
                  }
                  return const SizedBox();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(StringConstants.totalAmount.localized(),
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                    "${GlobalData.currencySymbol}${totalAmount.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            ...getWidgets(selectedProductQty: selectedProductQty),
          ],
        ));
  }

  Widget _getRadioButtonType(BundleOptions? option) {
    BundleOptionProducts? defaultItem = option?.bundleOptionProducts
        ?.firstWhereOrNull((element) => element.isDefault == true);
    radioSelectedProduct ??= defaultItem;

    selectedRadio[option?.id ?? "0"] ??= defaultItem;

    return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingLarge,
            AppSizes.spacingNormal,
            AppSizes.spacingLarge,
            AppSizes.spacingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option?.translations?.map((e) => e.label ?? '').toString() ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: AppSizes.spacingSmall,
            ),
            RadioButtonGroup(
              key: Key(option?.id?.toString() ?? ''),
              picked:
                  "${defaultItem?.product?.name} + ${defaultItem?.product?.priceHtml?.formattedFinalPrice}",
              labels: option?.bundleOptionProducts
                  ?.map((e) =>
                      "${e.product?.name} + ${e.product?.priceHtml?.formattedFinalPrice}")
                  .toList(),
              onChange: (label, index) {
                if ((option?.bundleOptionProducts?.length ?? 0) > index) {
                  radioSelectedProduct = option?.bundleOptionProducts?[index];
                  double selectedAmount = ((radioSelectedProduct?.qty ?? 1) *
                      double.parse(radioSelectedProduct
                              ?.product?.priceHtml?.finalPrice ??
                          "0"));

                  selectedRadio[option?.id ?? "0"] = radioSelectedProduct;

                  totalAmount =
                      totalAmount - (selectedPrices[option?.id ?? ""] ?? 0);
                  selectedPrices[option?.id ?? ""] = selectedAmount;

                  addDataToMap(
                      option?.id?.toString() ?? "",
                      radioSelectedProduct?.productId ?? "0",
                      selectedAmount,
                      radioSelectedProduct?.qty ?? 1);

                  (bundleData['bundleOptionQuantity'] as Map<String,
                          dynamic>?)?[option?.id.toString() ?? ""] =
                      radioSelectedProduct?.qty.toString();

                  totalAmount = double.parse(
                      (totalAmount + selectedAmount).toStringAsFixed(2));

                  _updateQtyValue(int.parse(option?.id ?? ''),
                      option?.bundleOptionProducts?[index].qty ?? 0);
                  _updateOptions(
                      int.parse(option?.id ?? ''),
                      int.parse(option?.bundleOptionProducts?[index].id ?? ''),
                      -1,
                      true,
                      qty: (bundleData['bundleOptionQuantity'] as Map<String,
                                  dynamic>?)?[option?.id.toString()]
                              ?.toString() ??
                          '');
                }
              },
            ),
            QuantityView(
                qty: (bundleData['bundleOptionQuantity']
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        ?.toString() ??
                    '0',
                callBack: (qty) {
                  selectedProductQty[
                      radioSelectedProduct?.product?.name ?? ''] = qty;

                  double selectedAmount = ((qty) *
                      double.parse(selectedRadio[option?.id ?? "0"]
                              ?.product
                              ?.priceHtml
                              ?.finalPrice ??
                          "0"));

                  addDataToMap(
                      option?.id?.toString() ?? "",
                      radioSelectedProduct?.productId ?? "0",
                      selectedAmount,
                      qty);

                  totalAmount =
                      totalAmount - (selectedPrices[option?.id ?? ""] ?? 0);
                  selectedPrices[option?.id ?? ""] = selectedAmount;
                  setState(() {
                    totalAmount = double.parse(
                        (totalAmount + selectedAmount).toStringAsFixed(2));
                  });
                  _updateQtyValue(int.parse(option?.id ?? ''), qty);
                })
          ],
        ));
  }

  Widget _getCheckBoxType(BundleOptions? option) {
    List<String> selectedItem = [];

    option?.bundleOptionProducts?.forEach((element) {
      if (element.isDefault == true) {
        String val =
            "${element.product?.name} + ${element.product?.priceHtml?.formattedFinalPrice}";
        selectedItem.add(val);
      }
    });

    var val = option?.bundleOptionProducts
        ?.map((e) =>
            "${e.product?.name} + ${e.product?.priceHtml?.formattedFinalPrice}")
        .toList();
    return (widget.options?.length ?? 0) > 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  ApplicationLocalizations.of(context)?.translate(option
                              ?.translations
                              ?.map((e) => e.label)
                              .toString() ??
                          '') ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxGroup(
                  checked: selectedItem,
                  activeColor: Theme.of(context).colorScheme.onBackground,
                  checkColor: Theme.of(context).colorScheme.background,
                  labels: val?.toList(),
                  onChange: (isChecked, label, index, key) {
                    var product = option?.bundleOptionProducts?[index];

                    setState(() {
                      if (isChecked) {
                        _updateQtyValue(int.parse(option?.id ?? '0'),
                            product?.qty?.toString() ?? '1');
                        _updateOptions(
                            int.parse(
                              option?.id ?? '0',
                            ),
                            int.parse(product?.id ?? '1'),
                            -1,
                            false,
                            qty: (bundleData['bundleOptionQuantity'] as Map<
                                        String,
                                        dynamic>?)?[option?.id.toString()]
                                    ?.toString() ??
                                '');
                        totalAmount = totalAmount +
                            ((product?.qty ?? 1) *
                                double.parse(
                                    product?.product?.priceHtml?.finalPrice ??
                                        "0"));

                        addToDataSet(
                            option?.id ?? "0",
                            product?.productId ?? "0",
                            ((product?.qty ?? 1) *
                                double.parse(
                                    product?.product?.priceHtml?.finalPrice ??
                                        "0")),
                            product?.qty ?? 1);
                      } else {
                        _updateOptions(int.parse(option?.id ?? ''), -1,
                            int.parse(product?.id ?? '1'), false,
                            qty: (bundleData['bundleOptionQuantity'] as Map<
                                        String,
                                        dynamic>?)?[option?.id.toString()]
                                    ?.toString() ??
                                '');
                        totalAmount = totalAmount -
                            ((product?.qty ?? 1) *
                                double.parse(
                                    product?.product?.priceHtml?.finalPrice ??
                                        "0"));

                        removeDataSet(
                            option?.id ?? "", product?.productId ?? "");
                      }
                    });
                  },
                ),
              ])
        : const SizedBox.shrink();
  }

  Widget _getTextField(BundleOptions? option) {
    BundleOptionProducts? defaultItem;
    String? defaultProductName = "";
    String? dropDownName;
    var product;
    if (!dropDownChange) {
      dropDownName = "";
    }

    String selectedProductAmount = '';
    var bundleOption;

    option?.bundleOptionProducts
            ?.map((e) => {
                  (e.isDefault) == true
                      ? {
                          selectedProductName == ''
                              ? selectedProductName = e.product?.name ?? ''
                              : Container(),
                          if (dropDownName == '' && !dropDownChange)
                            {
                              defaultItem = e,
                              dropDownName =
                                  e.product?.name ?? selectedProductName,
                            },
                          selectedProductAmount =
                              e.product?.priceHtml?.finalPrice ?? "0",
                          defaultProductName =
                              ("${e.product?.name} + ${e.product?.priceHtml?.formattedFinalPrice}")
                        }
                      : ''
                })
            .toList() ??
        [];

    selectedRadio[option?.id ?? "0"] ??= defaultItem;

    return Container(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingNormal,
            AppSizes.spacingNormal,
            AppSizes.spacingNormal,
            AppSizes.spacingNormal),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            child: CommonWidgets().getDropdown(
              Key(option?.id?.toString() ?? ''),
              context,
              option?.bundleOptionProducts
                      ?.map((e) =>
                          "${e.product?.name} + ${e.product?.priceHtml?.formattedFinalPrice}")
                      .toList() ??
                  [],
              option?.translations?.map((e) => e.label).toString(),
              (defaultProductName ?? "").isNotEmpty ? defaultProductName : null,
              null,
              option?.translations?.map((e) => e.label).toString(),
              (label, key) {
                dropDownChange = true;

                totalAmount =
                    totalAmount - (selectedPrices[option?.id ?? ""] ?? 0);

                product = option?.bundleOptionProducts?.firstWhereOrNull(
                    (element) => label.contains(element.product?.name ?? ""));
                bundleOption = option?.bundleOptionProducts?.firstWhereOrNull(
                    (element) =>
                        label.contains(element.product?.name.toString() ?? ""));

                defaultItem = bundleOption;
                selectedRadio[option?.id ?? "0"] = defaultItem;

                selectedProductName = bundleOption?.product?.name.toString() ??
                    "$defaultProductName ";
                dropDownName = selectedProductName;

                (bundleData['bundleOptionQuantity'] as Map<String, dynamic>?)?[
                    option?.id.toString() ?? ""] = product?.qty.toString();

                double selectedAmount =
                    ((selectedProductQty.containsKey(selectedProductName)
                            ? selectedProductQty[selectedProductName]
                            : product?.qty ?? 1) *
                        double.parse(
                            product?.product?.priceHtml?.finalPrice ?? "0"));

                addDataToMap(
                    option?.id?.toString() ?? "",
                    product.productId ?? "0",
                    selectedAmount,
                    product?.qty ?? 1);

                selectedProductAmount = selectedAmount.toString();
                dropDownTotal = selectedAmount;

                totalAmount = totalAmount + selectedAmount;
                selectedPrices[option?.id ?? ""] = selectedAmount;

                _updateQtyValue(
                    int.parse(option?.id ?? ''),
                    (bundleData['bundleOptionQuantity'] as Map<String,
                                dynamic>?)?[option?.id.toString()]
                            ?.toString() ??
                        '1');
                _updateOptions(int.parse(option?.id ?? ''),
                    int.parse(product?.id ?? '1'), -1, true,
                    qty: (bundleData['bundleOptionQuantity'] as Map<String,
                                dynamic>?)?[option?.id.toString()]
                            ?.toString() ??
                        '');
              },
              false,
            ),
          ),
          QuantityView(
              qty: (bundleData['bundleOptionQuantity']
                          as Map<String, dynamic>?)?[option?.id.toString()]
                      ?.toString() ??
                  '',
              callBack: (qty) {

                double selectedAmount = ((qty) *
                    double.parse(selectedRadio[option?.id ?? "0"]
                            ?.product
                            ?.priceHtml
                            ?.finalPrice ??
                        "0"));

                addDataToMap(
                    option?.id?.toString() ?? "",
                    selectedRadio[option?.id ?? "0"]?.product?.productId ?? "0",
                    selectedAmount,
                    qty);

                totalAmount =
                    totalAmount - (selectedPrices[option?.id ?? ""] ?? 0);
                selectedPrices[option?.id ?? ""] = selectedAmount;
                totalAmount = double.parse(
                    (totalAmount + selectedAmount).toStringAsFixed(2));

                selectedProductQty[dropDownName ?? selectedProductName] = qty;
                _updateQtyValue(int.parse(option?.id ?? ''), qty);

                setState(() {});
              }),
        ]));
  }

  _updateOptions(int id, int productId, int removeId, bool isReplace,
      {required String qty}) {
    if (bundleData['bundleOptions'] != null) {
      selectedQuantity[id.toString()] = qty;

      if (bundleData['bundleOptions'][id.toString()] != null) {
        if (removeId != -1) {}
        (bundleData['bundleOptions']?[id.toString()] as List<dynamic>)
            .remove(removeId);

        if (productId != -1) {
          if (isReplace) {
            bundleData['bundleOptions'][id.toString()] = [productId];
          } else {
            (bundleData['bundleOptions'][id.toString()] as List<dynamic>)
                .add(productId);
          }
        }
      } else {
        bundleData['bundleOptions'][id.toString()] = [productId];
      }
    } else {
      bundleData['bundleOptions'] = {
        id.toString(): [productId]
      };
      selectedQuantity[id.toString()] = qty;
    }

    Map<String, List<int>>? map = bundleData["bundleOptions"];

    int i = 0;
    qtyArray.clear();
    newData.clear();

    map?.forEach((key, value) {
      if (value.isNotEmpty) {
        qtyArray.add(BundleData(
            bundleOptionId: key,
            bundleOptionProductId: [...value.map((el) => el.toString())],
            qty: selectedQuantity[key]));

        newData.add(qtyArray[i].toJson());
        i++;
      }
    });

    if (widget.callBack != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.callBack!(newData);
      });
    }
  }

  _updateQtyValue(int id, dynamic qty) {
    selectedQuantity[id.toString()] = qty.toString();
    if (bundleData['bundleOptionQuantity'] != null) {
      (bundleData['bundleOptionQuantity']
          as Map<String, dynamic>?)?[id.toString()] = qty;
    } else {
      bundleData['bundleOptionQuantity'] = {id.toString(): qty};
    }
    _updateOptions(id, -1, -1, true, qty: qty?.toString() ?? "1");
  }

  List<Widget> getWidgets({Map? selectedProductQty}) {
    List<Widget> widgets = [];
    widget.options?.forEach((e) {
      widgets.add(Text(
        ApplicationLocalizations.of(context)?.translate(
                e.translations?.map((e) => e.label).toString() ?? '') ??
            '',
        style: Theme.of(context).textTheme.bodyMedium,
      ));

      BundleOptions? val =
          widget.options?.firstWhereOrNull((option) => option.id == e.id);
      List<int>? list = bundleData["bundleOptions"]?[e.id.toString()];

      list?.forEach((element) {
        BundleOptionProducts? temp =
            val?.bundleOptionProducts?.firstWhereOrNull((product) {
          return product.id == element.toString();
        });

        int? qty = 1;

        if (e.type == StringConstants.checkBoxText ||
            e.type == StringConstants.multiSelect) {
          qty = selectedOptionsGlobalList[e.id ?? "0"]?.firstWhereOrNull(
              (element) =>
                  element[productIdKey] == temp?.productId)?[quantityKey];
        } else {
          qty = selectedOptionsGlobal[e.id ?? "0"]?[quantityKey];
        }

        widgets.add(Text("${qty ?? 1} x ${temp?.product?.name}"));

        // if (selectedProductQty!.containsKey(temp?.product?.name)) {
        //   widgets.add(Text(
        //       "${selectedProductQty[temp?.product?.name]} x ${temp?.product?.name}"));
        // } else {
        //   widgets.add(Text("${temp?.qty ?? 1} x ${temp?.product?.name}"));
        // }
      });
    });

    return widgets;
  }

  void addDataToMap(
      String option, String productId, double selectedAmount, int qty) {
    Map<String, dynamic> data = {
      productIdKey: productId,
      quantityKey: qty,
      priceKey: selectedAmount,
    };

    selectedOptionsGlobal[option] = data;
  }

  void addToDataSet(
      String option, String productId, double selectedAmount, int qty) {
    Map<String, dynamic> data = {
      productIdKey: productId,
      quantityKey: qty,
      priceKey: selectedAmount,
    };

    Set<Map<String, dynamic>>? dataSet =
        selectedOptionsGlobalList[option] ?? {};
    dataSet.add(data);
    selectedOptionsGlobalList[option ?? "0"] = dataSet;
  }

  void removeDataSet(String option, String productId) {
    Set<Map<String, dynamic>>? dataSet =
        selectedOptionsGlobalList[option] ?? {};
    dataSet.removeWhere((element) => element[productIdKey] == productId);
    selectedOptionsGlobalList[option] = dataSet;
  }
}

class BundleData {
  String? bundleOptionId;
  List<String>? bundleOptionProductId;
  String? qty;

  BundleData({this.bundleOptionId, this.bundleOptionProductId, this.qty});

  factory BundleData.fromJson(Map<String, dynamic> json) => BundleData(
        bundleOptionId: json['bundleOptionId'],
        qty: json['qty'],
        bundleOptionProductId: json['bundleOptionProductId'].toList(),
      );

  Map<String, dynamic> toJson() => {
        'bundleOptionId': bundleOptionId,
        'bundleOptionProductId': bundleOptionProductId,
        'qty': qty
      };
}
