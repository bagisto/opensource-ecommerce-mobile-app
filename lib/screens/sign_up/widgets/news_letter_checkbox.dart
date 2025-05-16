import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:flutter/material.dart';


class NewsLetterCheckbox extends StatefulWidget {
  final Function(bool) isCheckboxSelected;
  final String? title;
  final bool isFromSignUp;
  final bool? initialSelection;
  final bool showError;
  final String errorText;

  const NewsLetterCheckbox(
      this.isCheckboxSelected,
      this.title,
      this.isFromSignUp,
      this.initialSelection, {
        this.showError = false,
        this.errorText = '',
        Key? key,
      }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _checkboxState();
  }
}

class _checkboxState extends State<NewsLetterCheckbox> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialSelection ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(
            widget.isFromSignUp
                ? -MediaQuery.of(context).size.height * 0.015
                : -MediaQuery.of(context).size.height * 0.004,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                checkColor: Colors.grey,
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value ?? false;
                  });
                  widget.isCheckboxSelected(isSelected);
                },
              ),
              Expanded(
                child: Text(
                  widget.title ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        if (widget.showError && !isSelected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

