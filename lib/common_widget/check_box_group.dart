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

class CheckboxGroup extends StatefulWidget {
  final List<String>? labels;
  final List<String>? checked;
  final void Function(bool isChecked, String label, int index,Key? key)? onChange;
  final void Function(List<String> selected)? onSelected;
  final TextStyle? labelStyle;
  final Color? activeColor;
  final Color checkColor;
  final bool tristate;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CheckboxGroup({
    Key? key,
    @required this.labels,
    this.checked,
    this.onChange,
    this.onSelected,
    this.labelStyle = const TextStyle(),
    this.activeColor, //defaults to toggleableActiveColor,
    this.checkColor = const Color(0xFFFFFFFF),
    this.tristate = false,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  }) : super(key: key);


  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}



class _CheckboxGroupState extends State<CheckboxGroup> {
  List<String> _selected = [];

  @override
  void initState(){
    super.initState();
    _selected = widget.checked ?? [];

  }

  @override
  Widget build(BuildContext context) {

    if(widget.checked != null){
      _selected = [];
      _selected.addAll(widget.checked!); //use add all to prevent a shallow copy
    }


    List<Widget> content = [];

    for(int i = 0; i < (widget.labels?.length ?? 0); i++){

      Checkbox cb = Checkbox(
        value: _selected.contains(widget.labels?.elementAt(i)),
        onChanged: (bool? isChecked) => onChanged(isChecked ?? false, i),
        checkColor: widget.checkColor,
        activeColor: widget.activeColor,
        tristate: widget.tristate,
      );

      Text t = Text(
          widget.labels?.elementAt(i) ?? '',
          style: widget.labelStyle
      );

      content.add(Row(children: <Widget>[
        cb,
        Expanded(flex: 10,child: t,),

      ]));

    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child:  Column(children: content),
    );
  }


  void onChanged(bool isChecked, int i){
    bool isAlreadyContained = _selected.contains(widget.labels?.elementAt(i));
    if(mounted){
      setState(() {
        if(!isChecked && isAlreadyContained){
          _selected.remove(widget.labels?.elementAt(i));
        }else if(isChecked && !isAlreadyContained){
          _selected.add(widget.labels?.elementAt(i) ?? '');
        }
        if(widget.onChange != null){
          widget.onChange!(isChecked, widget.labels?.elementAt(i) ?? '', i,widget.key);
          if(widget.onSelected != null) widget.onSelected!(_selected);
        }
      });
    }
  }

}