/*
 *  Webkul Software.
 *
 *  @package  Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html 
 *  @link https://store.webkul.com/license.html
 *
 */
import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';
import 'package:bagisto_app_demo/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../utils/index.dart';

class CustomizableOptionView extends StatefulWidget {
  final List<CustomizableOptions> customizableOptions;
  final Function(Map<String, dynamic>) onOptionSelected;

  const CustomizableOptionView({
    Key? key,
    required this.customizableOptions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<CustomizableOptionView> createState() => _CustomizableOptionViewState();
}

class _CustomizableOptionViewState extends State<CustomizableOptionView> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, Map<String, dynamic>> _selectedValues =
      {}; // optionId -> {optionId, value, ...}

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(int id) {
    return _controllers.putIfAbsent(id, () {
      final controller = TextEditingController();
      controller.addListener(() {
        _setSelectedValue(id, {'optionId': id, 'value': controller.text});
      });
      return controller;
    });
  }

  Map<String, dynamic>? _getSelectedValue(int id) => _selectedValues[id];

  void _setSelectedValue(int id, Map<String, dynamic> value) {
    setState(() {
      _selectedValues[id] = value;
    });
    // Convert int keys to string for parent, and values as maps
    widget.onOptionSelected(
        _selectedValues.map((k, v) => MapEntry(k.toString(), v)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.customizableOptions.map((option) {
          switch (option.type) {
            case 'text':
              return _buildTextOption(option);
            case 'textarea':
              return _buildTextAreaOption(option);
            case 'checkbox':
              return _buildCheckboxOption(option);
            case 'radio':
              return _buildRadioOption(option);
            case 'select':
              return _buildSelectOption(option);
            case 'multiselect':
              return _buildMultiSelectOption(option);
            case 'date':
              return _buildDateOption(option, context);
            case 'datetime':
              return _buildDateTimeOption(option, context);
            case 'time':
              return _buildTimeOption(option, context);
            case 'file':
              return _buildFileOption(option);
            default:
              return const SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }

  Widget _buildTextOption(CustomizableOptions option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${option.translations?.label ?? option.label ?? ''}+${formatCurrency((option.customizableOptionPrices ?? [])[0].price ?? 0.0, GlobalData.currencyCode)}${(option.isRequired ?? false) ? "*" : ""}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        CommonWidgets().getTextField(
          context,
          _getController(option.id ?? 0),
          '',
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildTextAreaOption(CustomizableOptions option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${option.translations?.label ?? option.label ?? ''}+${formatCurrency((option.customizableOptionPrices ?? [])[0].price ?? 0.0, GlobalData.currencyCode)}${(option.isRequired ?? false) ? "*" : ""}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        CommonWidgets().getTextField(
          context,
          _getController(option.id ?? 0),
          '',
          maxLines: 5,
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildCheckboxOption(CustomizableOptions option) {
    final selected =
        (_getSelectedValue(option.id!)?['priceOptionIds'] as Set<int>?) ??
            <int>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired ?? false ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        ...?option.customizableOptionPrices?.map<Widget>((priceOption) {
          final isChecked = selected.contains(priceOption.id);
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              '${priceOption.label ?? ''}+${formatCurrency(priceOption.price ?? 0.0, GlobalData.currencyCode)}',
            ),
            value: isChecked,
            onChanged: (value) {
              final set = Set<int>.from(selected);
              if (value == true) {
                set.add(priceOption.id!);
              } else {
                set.remove(priceOption.id!);
              }
              _setSelectedValue(option.id!, {
                'optionId': option.id,
                'priceOptionIds': set,
                'values': set
                    .map((id) => option.customizableOptionPrices
                        ?.firstWhere((p) => p.id == id)
                        .label)
                    .toList(),
              });
            },
          );
        }).toList(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildRadioOption(CustomizableOptions option) {
    final selected = _getSelectedValue(option.id!)?['priceOptionId'] as int?;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired ?? false ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        ...?option.customizableOptionPrices?.map<Widget>((priceOption) {
          return RadioListTile<int>(
            title: Text(
              '${priceOption.label ?? ''}+${formatCurrency(priceOption.price ?? 0.0, GlobalData.currencyCode)}',
            ),
            value: priceOption.id!,
            groupValue: selected,
            activeColor: Theme.of(context).colorScheme.onBackground,
            selected: selected == priceOption.id,
            selectedTileColor: theme.colorScheme.onBackground
                .withOpacity(0.1), // subtle highlight
            onChanged: (value) {
              _setSelectedValue(option.id!, {
                'optionId': option.id,
                'priceOptionId': value,
                'value': priceOption.label,
              });
            },
          );
        }).toList(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildSelectOption(CustomizableOptions option) {
    final selected = _getSelectedValue(option.id!)?['priceOptionId'] as int?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired ?? false ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          child: DropdownButton<int>(
            isExpanded: true,
            value: selected,
            items: option.customizableOptionPrices
                ?.map<DropdownMenuItem<int>>((priceOption) {
              return DropdownMenuItem<int>(
                value: priceOption.id,
                child: Text(
                    '${priceOption.label ?? ''}+${formatCurrency(priceOption.price ?? 0.0, GlobalData.currencyCode)}'),
              );
            }).toList(),
            onChanged: (value) {
              final priceOption = option.customizableOptionPrices
                  ?.firstWhere((p) => p.id == value);
              _setSelectedValue(option.id!, {
                'optionId': option.id,
                'priceOptionId': value,
                'value': priceOption?.label,
              });
            },
          ),
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildMultiSelectOption(CustomizableOptions option) {
    final selected =
        (_getSelectedValue(option.id!)?['priceOptionIds'] as Set<int>?) ??
            <int>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired == true ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          direction: Axis.vertical,
          children: option.customizableOptionPrices?.map<Widget>((priceOption) {
                final isSelected = selected.contains(priceOption.id);
                return ChoiceChip(
                  label: Text(
                    '${priceOption.label ?? ''}+${formatCurrency(priceOption.price ?? 0.0, GlobalData.currencyCode)}',
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  elevation: 0,
                  side: isSelected
                      ? BorderSide(width: 1, color: MobiKulTheme.linkColor)
                      : BorderSide.none,
                  selectedShadowColor: MobiKulTheme.linkColor,
                  selectedColor: MobiKulTheme.linkColor.withAlpha(200),
                  onSelected: (value) {
                    final set = Set<int>.from(selected);
                    if (value) {
                      set.add(priceOption.id!);
                    } else {
                      set.remove(priceOption.id!);
                    }
                    _setSelectedValue(option.id!, {
                      'optionId': option.id,
                      'priceOptionIds': set,
                      'values': set
                          .map((id) => option.customizableOptionPrices
                              ?.firstWhere((p) => p.id == id)
                              .label)
                          .toList(),
                    });
                  },
                );
              }).toList() ??
              [],
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildDateOption(CustomizableOptions option, BuildContext context) {
    final controller = _getController(option.id ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired == true ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CommonWidgets().getTextField(
          context,
          controller,
          'Select Date',
          readOnly: true,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      controller.clear();
                    });
                    _setSelectedValue(
                        option.id!, {'optionId': option.id, 'value': null});
                  },
                )
              : null,
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                    primarySwatch: MobiKulTheme.greyColor,
                    colorScheme: const ColorScheme.light(
                      primary: MobiKulTheme.accentColor,
                    ),
                    datePickerTheme: Theme.of(context).datePickerTheme,
                    dialogBackgroundColor: MobiKulTheme.primaryColor,
                  ),
                  child: child ?? const Text(""),
                );
              },
            );
            if (selectedDate != null) {
              DateTime date = DateTime.parse(selectedDate.toString());
              final formatted = selectedDate.toIso8601String();
              String formattedDate = DateFormat('yyyy-MM-dd').format(date);
              setState(() {
                controller.text = formattedDate;
              });
              _setSelectedValue(
                  option.id!, {'optionId': option.id, 'value': formatted});
            }
          },
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildDateTimeOption(
      CustomizableOptions option, BuildContext context) {
    final controller = _getController(option.id ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired == true ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CommonWidgets().getTextField(
          context,
          controller,
          'Select Date & Time',
          readOnly: true,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      controller.clear();
                    });
                    _setSelectedValue(
                        option.id!, {'optionId': option.id, 'value': null});
                  },
                )
              : null,
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                    primarySwatch: MobiKulTheme.greyColor,
                    colorScheme: const ColorScheme.light(
                      primary: MobiKulTheme.accentColor,
                    ),
                    datePickerTheme: Theme.of(context).datePickerTheme,
                    dialogBackgroundColor: MobiKulTheme.primaryColor,
                  ),
                  child: child ?? const Text(""),
                );
              },
            );
            if (selectedDate != null) {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: MobiKulTheme.greyColor,
                      colorScheme: const ColorScheme.light(
                        primary: MobiKulTheme.accentColor,
                      ),
                      timePickerTheme:
                          Theme.of(context).timePickerTheme.copyWith(
                                backgroundColor: MobiKulTheme.primaryColor,
                                dialBackgroundColor: MobiKulTheme.primaryColor,
                                dayPeriodTextColor:
                                    MobiKulTheme.darkTheme.dividerTheme.color,
                              ),
                      dialogBackgroundColor: MobiKulTheme.primaryColor,
                    ),
                    child: child ?? const Text(""),
                  );
                },
              );
              if (selectedTime != null) {
                final dateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                final formatted = dateTime.toIso8601String();
                String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                setState(() {
                  controller.text = formattedDateTime;
                });
                _setSelectedValue(
                    option.id!, {'optionId': option.id, 'value': formatted});
              }
            }
          },
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildTimeOption(CustomizableOptions option, BuildContext context) {
    final controller = _getController(option.id ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${option.translations?.label ?? option.label ?? ''}${option.isRequired == true ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CommonWidgets().getTextField(
          context,
          controller,
          'Select Time',
          readOnly: true,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      controller.clear();
                    });
                    _setSelectedValue(
                        option.id!, {'optionId': option.id, 'value': null});
                  },
                )
              : null,
          onTap: () async {
            TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                    primarySwatch: MobiKulTheme.greyColor,
                    colorScheme: const ColorScheme.light(
                      primary: MobiKulTheme.accentColor,
                    ),
                    timePickerTheme: Theme.of(context).timePickerTheme.copyWith(
                          backgroundColor: MobiKulTheme.primaryColor,
                          dialBackgroundColor: MobiKulTheme.primaryColor,
                          dayPeriodTextColor:
                              MobiKulTheme.darkTheme.dividerTheme.color,
                        ),
                    dialogBackgroundColor: MobiKulTheme.primaryColor,
                  ),
                  child: child ?? const Text(""),
                );
              },
            );
            if (selectedTime != null) {
              final now = DateTime.now();
              final dateTime = DateTime(
                now.year,
                now.month,
                now.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              String formattedTime = DateFormat('HH:mm').format(dateTime);
              setState(() {
                controller.text = formattedTime;
              });
              _setSelectedValue(
                  option.id!, {'optionId': option.id, 'value': formattedTime});
            }
          },
        ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }

  Widget _buildFileOption(CustomizableOptions option) {
    final file = _getSelectedValue(option.id!)?['value'] as PlatformFile?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${option.translations?.label ?? option.label ?? ''}${option.isRequired == true ? '*' : ''}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.isNotEmpty) {
              final pickedFile = result.files.first;
              _setSelectedValue(
                  option.id!, {'optionId': option.id, 'value': pickedFile});
            }
          },
          child: Text(ApplicationLocalizations.of(context)
                  ?.translate(StringConstants.chooseFile) ??
              ""),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            elevation: 0.0,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            foregroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(file.name, style: const TextStyle(fontSize: 14)),
          ),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal),
        CommonWidgets().divider(),
        CommonWidgets().getHeightSpace(AppSizes.spacingNormal)
      ],
    );
  }
}
