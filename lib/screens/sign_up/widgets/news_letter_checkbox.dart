import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class NewsLetterCheckbox extends StatefulWidget {
  final Function(bool) isCheckboxSelected;
  final String? title;
  final bool isFromSignUp;
  final bool? initialSelection;

  const NewsLetterCheckbox(this.isCheckboxSelected, this.title,this.isFromSignUp,this.initialSelection,
      {Key? key})
      : super(key: key);

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
    isSelected = widget.initialSelection ?? false; // Set initial state based on passed parameter
  }
 // AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    //localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset:  Offset(widget.isFromSignUp ?-MediaQuery.of(context).size.height * 0.015:-MediaQuery.of(context).size.height * 0.004 , 0), // Adjust the X value to shift left
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
          Text(
            StringConstants.subscribeToNewsletter.localized(),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

}
