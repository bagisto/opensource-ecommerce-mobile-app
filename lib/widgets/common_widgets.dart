/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import '../utils/input_field_validators.dart';

class CommonWidgets with EmailValidator {
  Widget getTextField(
          BuildContext context, TextEditingController controller, String hint,
          {FormFieldValidator<String>? validator,
          String label = "",
          String? validLabel,
          String? emailValue,
          TextInputType? keyboardType,
          Function? onSaved,
          bool showPassword = true,
          bool isRequired = false,
          Widget? prefixIcon,
          Widget? suffixIcon,
          bool? readOnly,
          EdgeInsetsGeometry? contentPadding,
          VoidCallback? onTap}) =>
      TextFormField(
        readOnly: readOnly ?? false,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: !showPassword,
        onTap: onTap,
        decoration: InputDecoration(
            label: isRequired
                ? Text.rich(TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          label,
                        ),
                      ),
                      const WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ],
                  ))
                : label.isNotEmpty
                    ? Text(
                        label,
                      )
                    : null,
            hintText: hint,
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: prefixIcon,
            prefixIconColor: Theme.of(context).iconTheme.color,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade500),
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: suffixIcon,
            suffixIconColor: Theme.of(context).iconTheme.color),
        validator: validator,
        onSaved: (val) {
          if (onSaved != null) {
            onSaved(val);
          }
        },
      );

  ///widget for height
  Widget getHeightSpace(double? height) => SizedBox(height: height);

  Widget getWidthSpace(double? width) => SizedBox(width: width);

  ///widget for text like product name,drawer titles
  Widget getDrawerTileText(String text, BuildContext context,
          {bool isBold = false}) =>
      Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : null),
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      );

  ///widget for button
  Widget appButton(BuildContext context, String title, double buttonWidth,
          VoidCallback onPressed,
          {bool showIcon = false}) =>
      ElevatedButton(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(Size(buttonWidth, 60)),
          foregroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.onBackground,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacingMedium),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon)
              Icon(
                Icons.shopping_cart,
                size: 17,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onBackground),
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
          ],
        ),
      );

  Widget divider() => const Divider(
        thickness: 1,
      );

  /// widget for text like product price
  Widget priceText(String price, BuildContext context) => Text(
        price,
        style: Theme.of(context).textTheme.labelLarge,
      );

  Widget getDropdown(
    Key? key,
    BuildContext context,
    List<String>? itemList,
    String? hintText,
    String? value,
    String? dropDownValue,
    String? labelText,
    Function(String, Key?)? callBack,
    bool isRequired,
  ) {
    return Column(
      children: <Widget>[
        if (labelText != "")
          Row(
            children: <Widget>[
              Text(
                labelText ?? '',
              ),
            ],
          ),
        const SizedBox(height: 6),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).colorScheme.background,
          ),
          child: DropdownButtonFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
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
                callBack(newValue ?? '', key);
              }
            },
            items: itemList?.map((String value) {
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
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              fillColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppSizes.spacingNormal))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppSizes.spacingNormal))),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppSizes.spacingNormal)),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppSizes.spacingNormal)),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
        )
      ],
    );
  }
}
