/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:flutter/material.dart';

import '../screens/home_page/data_model/new_product_data.dart';
import '../screens/product_screen/view/file_download.dart';

class CheckboxGroup extends StatefulWidget {
  final List<String>? labels;
  final List<String>? checked;
  final void Function(bool isChecked, String label, int index, Key? key)?
      onChange;
  final void Function(List<String> selected)? onSelected;
  final TextStyle? labelStyle;
  final Color? activeColor;
  final Color checkColor;
  final bool triState;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<DownloadableLinks>? data;
  final bool showText;

  const CheckboxGroup({
    Key? key,
    @required this.labels,
    this.checked,
    this.onChange,
    this.onSelected,
    this.labelStyle = const TextStyle(),
    this.activeColor, //defaults to toggleableActiveColor,
    this.checkColor = const Color(0xFFFFFFFF),
    this.triState = false,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
    this.data, this.showText = false
  }) : super(key: key);

  @override
  _CheckboxGroupState createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = widget.checked ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checked != null) {
      _selected = [];
      _selected.addAll(widget.checked!); //use add all to prevent a shallow copy
    }


    List<Widget> content = [];

    for (int i = 0; i < (widget.labels?.length ?? 0); i++) {
      Checkbox cb = Checkbox(
        value: _selected.contains(widget.labels?.elementAt(i)),
        onChanged: (bool? isChecked) => onChanged(isChecked ?? false, i),
        checkColor: Theme.of(context).colorScheme.background,
        activeColor: Theme.of(context).colorScheme.onBackground,
        tristate: widget.triState,
      );

      Text t =
          Text(widget.labels?.elementAt(i) ?? '', style: widget.labelStyle);
      content.add(Row(children: <Widget>[
        cb,
        Expanded(
          flex: 1,
          child: t,
        ),
        if(widget.showText && (widget.data?[i].sampleFileUrl ?? "").isNotEmpty)Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              DownloadFile().downloadPersonalData(
                  widget.data?[i].sampleUrl ?? widget.data?[i].sampleFileUrl ?? "",
                  widget.data?[i].sampleFileName ?? "sampleLink$i.jpg",
                  widget.data?[i].type ?? "",
                  context, GlobalKey());
            },
            child: Text(StringConstants.sample.localized(),
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        )
      ]));
    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: Column(children: content),
    );
  }

  void onChanged(bool isChecked, int i) {
    bool isAlreadyContained = _selected.contains(widget.labels?.elementAt(i));
    if (mounted) {
      setState(() {
        if (!isChecked && isAlreadyContained) {
          _selected.remove(widget.labels?.elementAt(i));
        } else if (isChecked && !isAlreadyContained) {
          _selected.add(widget.labels?.elementAt(i) ?? '');
        }
        if (widget.onChange != null) {
          widget.onChange!(
              isChecked, widget.labels?.elementAt(i) ?? '', i, widget.key);
          if (widget.onSelected != null) widget.onSelected!(_selected);
        }
      });
    }
  }
}
