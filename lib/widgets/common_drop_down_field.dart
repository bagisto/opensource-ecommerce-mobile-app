/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, overridden_fields, file_names

import 'package:flutter/material.dart';

class CommonDropDownField extends StatelessWidget {
  @override
  Key? key;
  final List<String>? itemList;
  final String? hintText;
  final String? value;
  final String? dropDownValue;
  final String? labelText;
  void Function(String, Key?)? callBack;
  final bool isRequired;

  CommonDropDownField(
      {this.key,
      this.itemList,
      this.value,
      this.hintText,
      this.dropDownValue,
      this.labelText = "",
      this.callBack,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemList?.isEmpty == true
        ? Container()
        : Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).colorScheme.background,
            ),
            child: DropdownButtonFormField(
                iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                style: Theme.of(context).textTheme.bodyMedium,
                value: value,
                isExpanded: true,
                key: key,
                validator: (val) {
                  if (val == null) {
                    return "* Required";
                  } else {
                    return null;
                  }
                },
                onChanged: (String? newValue) {
                  if (callBack != null) {
                    callBack!(newValue ?? '', key);
                  }
                } ,
                items: itemList?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  '${hintText ?? ""} * ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  label: Text.rich(TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          labelText ?? "",
                        ),
                      ),
                      const WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red,fontSize: 18),
                        ),
                      ),
                    ],
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                  errorBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.red.shade500)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey.shade500),
                  ),
                )),
          );
  }
}
