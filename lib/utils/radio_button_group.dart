/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RadioButtonGroup extends StatefulWidget {
  /// A list of strings that describes each Radio button. Each label must be distinct.
  final List<String>? labels;

  /// Specifies which Radio button to automatically pick.
  /// Every element must match a label.
  /// This is useful for clearing what is picked (set it to "").
  /// If this is non-null, then the user must handle updating this; otherwise, the state of the RadioButtonGroup won't change.
  final String? picked;

  /// Specifies which buttons should be disabled.
  /// If this is non-null, no buttons will be disabled.
  /// The strings passed to this must match the labels.
  final List<String>? disabled;

  /// Called when the value of the RadioButtonGroup changes.
  final void Function(String label, int index)? onChange;

  /// Called when the user makes a selection.
  final void Function(String selected)? onSelected;

  /// The style to use for the labels.
  final TextStyle? labelStyle;

  /// Specifies the orientation to display elements.

  /// Called when needed to build a RadioButtonGroup element.
  final Widget Function(Radio radioButton, Text label, int index)? itemBuilder;

  //RADIO BUTTON FIELDS
  /// The color to use when a Radio button is checked.
  final Color? activeColor;

  //SPACING STUFF
  /// Empty space in which to inset the RadioButtonGroup.
  final EdgeInsetsGeometry padding;

  /// Empty space surrounding the RadioButtonGroup.
  final EdgeInsetsGeometry margin;

  const RadioButtonGroup({
    Key? key,
    @required this.labels,
    this.picked,
    this.disabled,
    this.onChange,
    this.onSelected,
    this.labelStyle = const TextStyle(),
    this.activeColor, //defaults to toggleableActiveColor,
    this.itemBuilder,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  State<RadioButtonGroup> createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  String? _selected;

  @override
  void initState() {
    super.initState();

    //set the selected to the picked (if not null)
    _selected = widget.picked ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //set the selected to the picked (if not null)
    _selected = widget.picked ?? _selected;

    List<Widget> content = [];
    for (int i = 0; i < (widget.labels?.length ?? 0); i++) {
      Radio rb = Radio(
        activeColor: Theme.of(context)
            .colorScheme
            .onPrimary,
        groupValue: widget.labels?.indexOf(_selected ?? ''),
        value: i,

        //just changed the selected filter to current selection
        //since these are radio buttons, and you can only pick
        //one at a time
        onChanged: (widget.disabled != null &&
                (widget.disabled?.contains(widget.labels?.elementAt(i)) ??
                    false))
            ? null
            : (var index) => setState(() {
                  _selected = widget.labels?.elementAt(i) ?? '';

                  if (widget.onChange != null)
                    widget.onChange!(widget.labels?.elementAt(i) ?? '', i);
                  if (widget.onSelected != null)
                    widget.onSelected!(widget.labels?.elementAt(i) ?? '');
                }),
      );

      Text t = Text(widget.labels?.elementAt(i) ?? '',
          style: Theme.of(context).textTheme.labelMedium
          );

      //use user defined method to build
      if (widget.itemBuilder != null) {
        content.add(widget.itemBuilder!(rb, t, i));
      } else {

        content.add(Row(children: <Widget>[
          const SizedBox(width: 8.0),
          rb,
          t,
        ]));

      }
    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: Column(children: content),
    );
  }
}
