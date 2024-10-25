/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:hive/hive.dart';
import '../../data_model/currency_language_model.dart';
import '../../main.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  int? _selectedIndex = -1;
  String? _currentCurrencyCode;
  CurrencyLanguageList? currencyLanguageList;

  @override
  void initState() {
    currencyLanguageList = GlobalData.languageData;
    _fetchSharedPreferenceData(GlobalData.languageData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text(StringConstants.currencyTitle.localized()),
        centerTitle: false,
      ),
      body: currencyLanguageList!=null ?  _currency(currencyLanguageList):const SizedBox(),
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
            padding: const EdgeInsets.all(AppSizes.spacingLarge),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (itemIndex == _selectedIndex)
                    ? const Icon(
                  Icons.radio_button_checked,
                  size: AppSizes.spacingWide,
                ) : const Icon(
                  Icons.radio_button_off,
                  size: AppSizes.spacingWide,
                ),
                const SizedBox(width: AppSizes.spacingLarge),
                Text((currencyLanguageList?.currencies?[itemIndex].name?? "" )+(" (${currencyLanguageList?.currencies?[itemIndex].code?? ""})"),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    )),

              ],
            ),
          ),
        );
      },
      itemCount:currencyLanguageList?.currencies?.length??0);
  }


  _onTapCurrency(index,CurrencyLanguageList? currencyLanguageList) async {
    if (_selectedIndex == index) {
      appStoragePref.setCurrencyCode(_currentCurrencyCode??"USD");
      Navigator.pop(context, _currentCurrencyCode);
    } else {
      setState(() {
        _selectedIndex = index;
        _currentCurrencyCode = currencyLanguageList?.currencies?[index].code;
      });
      appStoragePref.setCurrencyCode(_currentCurrencyCode??"USD");
      GlobalData.currencyCode = appStoragePref.getCurrencyCode();
      appStoragePref.setCurrencyLabel(currencyLanguageList?.currencies![index].name??"USD");
      Hive.deleteBoxFromDisk("recentProducts");

      _closeThisPage();
    }
  }

  _closeThisPage() {
    appStoragePref.setCurrencyCode(_currentCurrencyCode??"US Dollar");
    Hive.deleteBoxFromDisk("getCategoriesDrawerData");
    RestartWidget.restartApp(context);
    Navigator.pushNamedAndRemoveUntil(context, splash, (route) => false);
  }

  _fetchSharedPreferenceData(CurrencyLanguageList? currencyLanguageList) {
    String? currencyCode = appStoragePref.getCurrencyCode();
      String? code= currencyCode;
      currencyLanguageList?.currencies?.forEach((currencyChild) {
        if (currencyChild.code == code) {
          setState(() {
            _currentCurrencyCode = code;
            _selectedIndex = currencyLanguageList.currencies?.indexOf(currencyChild);
          });
        }
      });
  }
}
