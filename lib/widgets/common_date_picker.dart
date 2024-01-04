/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../utils/index.dart';

class CommonDatePicker extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final bool? isRequired;
  final int? save;

  const CommonDatePicker(
      {Key? key,
        this.controller,
        this.save,
        this.hintText,
        this.labelText,
        this.helperText,
        this.isRequired = false})
      : super(key: key);

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  DateTime currentDate = DateTime.now();
  String initDate = "";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.controller?.text != null &&
        (widget.controller?.text ?? "").isNotEmpty) {
      String? text = widget.controller?.text ?? selectedDate.toString();
      DateTime tempDate = DateFormat('yyyy-MM-dd').parse(text);
      selectedDate = tempDate;
    }
    if (widget.save == 1 && initDate.isNotEmpty) {
      SharedPreferenceHelper.getDate().then((value) {
        initDate = value;
        selectedDate = DateTime.parse(initDate);
      });
    }
    super.initState();
  }

  Future<void> _selectedDate() async {
    DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              colorScheme: ColorScheme.light(
                  primary: Theme.of(context).colorScheme.onBackground,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                  secondary: Colors.black),
              dialogBackgroundColor: Colors.white,
            ),
            child: child ?? const Text(""),
          );
        },
        context: context,
        initialDate: (widget.controller?.text ?? "").isNotEmpty
            ? selectedDate
            : (widget.save == 1
            ? selectedDate.add(const Duration(days: 0))
            : DateTime.now().add(const Duration(days: 0))),
        firstDate: widget.save == 1
            ? selectedDate.add(const Duration(days: 0))
            : DateTime(1950 - 01 - 01),
        lastDate: DateTime.now().add(
            const Duration(days: 0, minutes: 0, seconds: 1, milliseconds: 1)));

    DateTime date = DateTime.parse(picked.toString());

    if (widget.save == 0) {
      SharedPreferenceHelper.setDate(picked.toString());
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    if (picked != null && picked != currentDate) {
      // picked.then((value) {
      setState(() {
        currentDate = picked;
        widget.controller?.value =
            TextEditingValue(text: formattedDate.toString());
      });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Theme.of(context).textTheme.bodySmall,
        controller: widget.controller,
        readOnly: true,
        onTap: () {
          _selectedDate();
        },
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (widget.save == 1) {
                    initDate = await SharedPreferenceHelper.getDate();
                    if(initDate.isNotEmpty) {
                      selectedDate = DateTime.parse(initDate);
                    }
                  }
                  _selectedDate();
                },
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.grey[600],
                )),
            hintStyle: Theme.of(context).textTheme.bodySmall,
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.red.shade500),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade500),
            )),
        validator: (value) {
          if (value?.isEmpty ?? false) {
            return "*Required";
          } else {
            return null;
          }
        });
  }
}
