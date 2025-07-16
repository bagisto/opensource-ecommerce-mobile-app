/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:developer';

import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/widget/customizable_option_view.dart';
import 'package:bagisto_app_demo/utils/extension.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// ignore: must_be_immutable
class ProductTypeView extends StatefulWidget {
  final BookingSlotsData? bookingSlotsData;
  final ProductScreenBLoc? productScreenBLoc;
  final NewProducts? productData;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  bool isLoggedIn = false;
  Function(
    List configurableParams,
    List bundleParams,
    List selectList,
    List selectParam,
    List groupedParams,
    List downloadLinks,
    int qty,
    dynamic configurableProductId,
    Map<String, dynamic> bookingParams,
    Map<String, dynamic> customizableOptionsSelection, // <-- add here
  )? callback;
  int qty = 1;
  String? price;
  final ScrollController? scrollController;
  dynamic configurableProductId;

  ProductTypeView({
    Key? key,
    this.productScreenBLoc,
    this.productData,
    this.price,
    required this.scaffoldMessengerKey,
    this.scrollController,
    required this.qty,
    this.configurableProductId,
    required this.isLoggedIn,
    this.callback,
    required this.bookingSlotsData,
  }) : super(key: key);

  @override
  State<ProductTypeView> createState() => _ProductTypeViewState();
}

class _ProductTypeViewState extends State<ProductTypeView> {
  List downloadLinks = [];
  List groupedParams = [];
  List bundleParams = [];
  Map<String, dynamic> bookingParams = {};
  List configurableParams = [];
  List selectList = [];
  List selectParam = [];

  Map<String, dynamic> customizableOptionsSelection =
      {}; // Store latest selection
  double customOptionsPrice = 0.0; // Store calculated custom options price

  @override
  Widget build(BuildContext context) {
    double basePrice = double.tryParse(widget.productData?.price ?? '') ??
        double.tryParse(widget.productData?.priceHtml?.regularPrice ?? '') ??
        0.0;
    double totalPrice = basePrice + customOptionsPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData?.name ?? "",
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CommonWidgets().getHeightSpace(8),
                  // Show dynamic price
                  if (widget.productData?.type == StringConstants.configurable)
                    PriceWidgetHtml(
                      priceHtml:
                          formatCurrency(basePrice, GlobalData.currencyCode),
                    )
                  else
                    PriceWidgetHtml(
                        priceHtml:
                            widget.productData?.priceHtml?.priceHtml ?? ''),
                  CommonWidgets().getHeightSpace(8),
                  HtmlWidget(
                    widget.productData?.shortDescription ?? "",
                  ),
                  if (widget.productData?.reviews?.isNotEmpty ?? true)
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ReviewColorHelper.getColor(double.tryParse(
                                      widget.productData?.averageRating ??
                                          "0") ??
                                  0),
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: AppSizes.spacingNormal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.productData?.reviews?.isNotEmpty ??
                                  true)
                                Text(
                                    (widget.productData?.averageRating ?? 0)
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              if (widget.productData?.reviews?.isNotEmpty ??
                                  true)
                                CommonWidgets()
                                    .getWidthSpace(AppSizes.spacingSmall),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                        CommonWidgets().getWidthSpace(AppSizes.spacingNormal),
                        GestureDetector(
                          onTap: () {
                            ((widget.productData?.reviews?.length ?? 0) > 0)
                                ? widget.scrollController?.animateTo(
                                    widget.scrollController?.position
                                            .maxScrollExtent ??
                                        0.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease)
                                : null;
                          },
                          child: Text(
                            "${widget.productData?.reviews?.length} Review(s)"
                                .localized(),
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.productData?.type == StringConstants.grouped)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.grouped)
          Card(
            child: GroupProduct(
              groupedProducts: widget.productData?.groupedProducts,
              callBack: (qty) {
                groupedParams = qty;
                selectList = groupedParams;
                widget.callback!(
                  configurableParams,
                  bundleParams,
                  selectList,
                  selectParam,
                  groupedParams,
                  downloadLinks,
                  widget.qty,
                  widget.configurableProductId,
                  bookingParams,
                  customizableOptionsSelection, // <-- add here
                );
              },
            ),
          ),
        if (widget.productData?.type == StringConstants.downloadable)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.downloadable)
          Card(
            child: Column(
              children: [
                DownloadProductSample(
                  samples: widget.productData?.downloadableSamples,
                  scaffoldMessengerKey: widget.scaffoldMessengerKey,
                ),
                DownloadProductOptions(
                  options: widget.productData?.downloadableLinks,
                  scaffoldMessengerKey: widget.scaffoldMessengerKey,
                  callBack: (ids) {
                    downloadLinks = ids;
                    selectList = downloadLinks;
                    widget.callback!(
                      configurableParams,
                      bundleParams,
                      selectList,
                      selectParam,
                      groupedParams,
                      downloadLinks,
                      widget.qty,
                      widget.configurableProductId,
                      bookingParams,
                      customizableOptionsSelection, // <-- add here
                    );
                  },
                )
              ],
            ),
          ),
        if (widget.productData?.type == StringConstants.configurable)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.configurable)
          Card(
            child: CustomOptionsView(
              productData: widget.productData,
              customOptions: widget.productData?.configurableData?.attributes,
              variants: widget.productData?.variants,
              callback: (data, id) {
                configurableParams = data;
                widget.configurableProductId = id;
                selectList = configurableParams;
                widget.callback!(
                  configurableParams,
                  bundleParams,
                  selectList,
                  selectParam,
                  groupedParams,
                  downloadLinks,
                  widget.qty,
                  widget.configurableProductId,
                  bookingParams,
                  customizableOptionsSelection, // <-- add here
                );
                getConfigurablePrice();
              },
            ),
          ),
        if (widget.productData?.type == StringConstants.bundle)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.bundle)
          Card(
            child: BundleOptionsView(
              options: widget.productData?.bundleOptions,
              callBack: (data) {
                // ignore: unnecessary_type_check
                bundleParams = data;
                selectList = bundleParams;
                widget.callback!(
                  configurableParams,
                  bundleParams,
                  selectList,
                  selectParam,
                  groupedParams,
                  downloadLinks,
                  widget.qty,
                  widget.configurableProductId,
                  bookingParams,
                  customizableOptionsSelection, // <-- add here
                );
              },
            ),
          ),
        if ((widget.productData?.customizableOptions ?? []).length > 0)
          const SizedBox(
            height: 8,
          ),
        if ((widget.productData?.customizableOptions ?? []).length > 0)
          Card(
            elevation: 2,
            child: CustomizableOptionView(
                customizableOptions:
                    widget.productData?.customizableOptions ?? [],
                onOptionSelected: (selectedOption) {
                  setState(() {
                    customizableOptionsSelection = selectedOption;
                    customOptionsPrice =
                        _calculateCustomOptionsPrice(selectedOption);
                  });
                  // Always notify parent with latest selection
                  widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    widget.qty,
                    widget.configurableProductId,
                    bookingParams,
                    customizableOptionsSelection,
                  );
                }),
          ),
        if (widget.productData?.type == StringConstants.booking)
          SizedBox(
            height: 8,
          ),
        if (widget.productData?.type == StringConstants.booking)
          Card(
            elevation: 2,
            child: BookingOptionView(
              bookingSlotsData: widget.bookingSlotsData,
              productScreenBLoc: widget.productScreenBLoc,
              options: widget.productData?.booking,
              callBack: (data) {
                if (data['type'] == "default") {
                  bookingParams = {
                    "date": '"${data["date"]}"',
                    "slot": data["slot"] != null ? data["slot"] : null,
                    "note": '"Booking Table"'
                  };
                }
                if (data['type'] == "rental") {
                  if (data['rentingType'] == "daily") {
                    bookingParams = {
                      "note": '"Booking Table"',
                      "dateFrom": '"${data["from"]}"',
                      "dateTo": '"${data["to"]}"',
                      "rentingType": '${data["rentingType"]?.toUpperCase()}',
                    };
                  } else {
                    bookingParams = {
                      "date": '"${data["date"]}"',
                      "slot": data["slot"] != null ? data["slot"] : null,
                      "rentingType": '${data["rentingType"]?.toUpperCase()}',
                      "note": '"Booking Table"'
                    };
                  }
                }
                if (data['type'] == "appointment") {
                  bookingParams = {
                    "date": '"${data["date"]}"',
                    "slot": data["slot"] != null ? data["slot"] : null,
                    "note": '"Booking Table"'
                  };
                }
                if (data['type'] == "table") {
                  bookingParams = {
                    "date": '"${data["date"]}"',
                    "slot": data["slot"] != null ? data["slot"] : null,
                    "note": '"${data["note"]}"'
                  };
                }
                if (data['type'] == "event") {
                  bookingParams = {
                    "qty": data["qty"],
                  };
                }

                if (data['type'] == "event") {
                  widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    1,
                    widget.configurableProductId,
                    bookingParams,
                    customizableOptionsSelection, // <-- add here
                  );
                } else {
                  widget.callback!(
                    configurableParams,
                    bundleParams,
                    selectList,
                    selectParam,
                    groupedParams,
                    downloadLinks,
                    data["qty"],
                    widget.configurableProductId,
                    bookingParams,
                    customizableOptionsSelection, // <-- add here
                  );
                }
              },
            ),
          ),
        if (widget.productData?.type != StringConstants.grouped)
          const SizedBox(
            height: 8,
          ),
        if (widget.productData?.type != StringConstants.grouped &&
            widget.productData?.type != StringConstants.booking)
          Card(
            elevation: 2,
            child: StatefulBuilder(builder: (context, changeState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: QuantityView(
                  qty: widget.qty.toString(),
                  callBack: (qty) {
                    changeState(() {
                      widget.qty = qty;
                    });
                    widget.callback!(
                      configurableParams,
                      bundleParams,
                      selectList,
                      selectParam,
                      groupedParams,
                      downloadLinks,
                      widget.qty,
                      widget.configurableProductId,
                      bookingParams,
                      customizableOptionsSelection, // <-- add here
                    );
                  },
                ),
              );
            }),
          ),
      ],
    );
  }

  double _calculateCustomOptionsPrice(Map<String, dynamic> selectedOptions) {
    double total = 0.0;
    final options = widget.productData?.customizableOptions ?? [];
    for (var entry in selectedOptions.entries) {
      final optionId = int.tryParse(entry.key);
      if (optionId == null) continue;
      CustomizableOptions? option;
      try {
        option = options.firstWhere((o) => o.id == optionId);
      } catch (_) {
        continue;
      }
      final value = entry.value;
      // Handle different option types
      if (option.type == 'text' || option.type == 'textarea') {
        // Add price of the first price option if filled
        if ((value['value'] as String?)?.isNotEmpty ?? false) {
          total += (option.customizableOptionPrices?.first.price ?? 0.0);
        }
      } else if (option.type == 'checkbox' || option.type == 'multiselect') {
        final Set<int> selectedIds =
            (value['priceOptionIds'] as Set<int>? ?? {});
        for (final id in selectedIds) {
          var priceOption;
          try {
            priceOption =
                option.customizableOptionPrices?.firstWhere((p) => p.id == id);
          } catch (_) {
            continue;
          }
          if (priceOption != null) {
            total += priceOption.price ?? 0.0;
          }
        }
      } else if (option.type == 'radio' || option.type == 'select') {
        final int? selectedId = value['priceOptionId'] as int?;
        if (selectedId != null) {
          var priceOption;
          try {
            priceOption = option.customizableOptionPrices
                ?.firstWhere((p) => p.id == selectedId);
          } catch (_) {
            continue;
          }
          if (priceOption != null) {
            total += priceOption.price ?? 0.0;
          }
        }
      } else if (option.type == 'date' ||
          option.type == 'datetime' ||
          option.type == 'time') {
        if ((value['value'] as String?)?.isNotEmpty ?? false) {
          total += (option.customizableOptionPrices?.first.price ?? 0.0);
        }
      } else if (option.type == 'file') {
        if (value['value'] != null) {
          total += (option.customizableOptionPrices?.first.price ?? 0.0);
        }
      }
    }
    return total;
  }

  String? getConfigurablePrice() {
    for (int i = 0;
        i < (widget.productData?.configurableData?.variantPrices?.length ?? 0);
        i++) {
      if (widget.configurableProductId ==
          widget.productData?.configurableData?.variantPrices?[i].id) {
        setState(() {
          widget.price = widget.productData?.configurableData?.variantPrices?[i]
              .regularPrice?.formattedPrice;
        });
      } else {}
    }
    return widget.price;
  }
}
