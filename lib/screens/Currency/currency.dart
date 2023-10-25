/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:flutter/material.dart';

import '../../configuration/app_global_data.dart';
import '../../routes/route_constants.dart';
import '../recent_product/database.dart';

class CurrencyData extends StatefulWidget {

  CurrencyLanguageList? currencyLanguageList;
  CurrencyData({Key? key, required this.currencyLanguageList}) : super(key: key);

  @override
  State<CurrencyData> createState() => _CurrencyDataState();
}

class _CurrencyDataState extends State<CurrencyData> {
  int? _selectedIndex = -1;
  String? _currentCurrencyCode;

  @override
  void initState() {
    _fetchSharedPreferenceData(widget.currencyLanguageList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
      appBar: AppBar(
        title:  CommonWidgets.getHeadingText(
            "CurrencyTitle".localized(),context),
       centerTitle: false,
      ),
      body:  _currency(widget.currencyLanguageList),
      ),

    );
  }

  _currency(CurrencyLanguageList? currencyLanguageList){
    return ListView.builder(
        itemBuilder: (context, itemIndex) {
          return GestureDetector(
            onTap: (){
              _onTapCurrency(itemIndex,currencyLanguageList);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (itemIndex == _selectedIndex )
                      ? Icon(
                      Icons.radio_button_checked,
                      color:Theme.of(context).colorScheme.onPrimary,size: 20,
                  ) :Icon(
                      Icons.radio_button_off,
                      color:Theme.of(context).colorScheme.onPrimary
                    ,size: 20,
                  ),
                  const SizedBox(width: 14,),
                  Text((currencyLanguageList?.currencies![itemIndex].name?? "" )+(" (${currencyLanguageList?.currencies![itemIndex].code?? ""})"),
                    style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),

                ],
              ),
            ),
          );
        },
        itemCount:currencyLanguageList?.currencies!.length??0,);
  }


  _onTapCurrency(index,CurrencyLanguageList? currencyLanguageList) async {
    if (_selectedIndex == index) {
      SharedPreferenceHelper.setCurrencyCode(_currentCurrencyCode??"USD");
      Navigator.pop(context, _currentCurrencyCode);
    } else {
      setState(() {
        _selectedIndex = index;
        _currentCurrencyCode = currencyLanguageList?.currencies![index].code;
      });
      SharedPreferenceHelper.setCurrencyCode(_currentCurrencyCode??"USD");
      GlobalData.currency = await SharedPreferenceHelper.getCurrencyCode();
      SharedPreferenceHelper.setCurrencyLabel(currencyLanguageList?.currencies![index].name??"USD");
      AppDatabase.getDatabase().then(
                (value) => value.recentProductDao
                .deleteRecentProducts());

      _closeThisPage();
    }
  }

  _closeThisPage() {
    SharedPreferenceHelper.setCurrencyCode(_currentCurrencyCode??"USD");
    Navigator.pushNamedAndRemoveUntil(context, Splash, (route) => false);
  }

  _fetchSharedPreferenceData(CurrencyLanguageList? currencyLanguageList) {
    _getCurrencyCodeSharedPrefValue().then((currencyCode) {
     String? code= currencyCode ?? currencyLanguageList?.baseCurrency?.code;
     currencyLanguageList?.currencies?.forEach((currencyChild) {
        if (currencyChild.code == code) {
          setState(() {
            _currentCurrencyCode = code;
            _selectedIndex = currencyLanguageList.currencies?.indexOf(currencyChild);
          });
        }
      });
    });
  }

  Future _getCurrencyCodeSharedPrefValue() async {
    return await SharedPreferenceHelper.getCurrencyCode();
  }
}
