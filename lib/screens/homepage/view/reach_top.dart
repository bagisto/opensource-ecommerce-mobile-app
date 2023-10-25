/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';


Widget buildReachBottomView(BuildContext context, ScrollController scrollController){
  return  Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.only(
        top: 15,
       ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("youHaveReachedToTheBottomOfThePage".localized()),
        TextButton(
            onPressed: (){
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: Text( "backToTop".localized())),
      ],
    ),
  );
}
