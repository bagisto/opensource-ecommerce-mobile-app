import 'package:bagisto_app_demo/configuration/app_global_data.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../main.dart';
import '../../routes/route_constants.dart';
import '../recent_product/database.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedCode = '';

  @override
  void initState() {
    super.initState();
    getCode();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child:Scaffold(
        appBar: AppBar(
          title: CommonWidgets.getHeadingText("Language".localized(), context),
          centerTitle: false,
        ),
        body:  _language() ,
      ),


    );


  }

  _language() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: GlobalData.languageData?.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              GlobalData.selectedLanguage=GlobalData.languageData?[index].code?? "";
              SharedPreferenceHelper.setCustomerLanguage(
                  GlobalData.languageData?[index].code ?? "");
              GlobalData.locale =
              await SharedPreferenceHelper.getCustomerLanguage();
              SharedPreferenceHelper.setLanguageName(
                  GlobalData.languageData?[index].name ?? "");
              setState(() {
                selectedCode = GlobalData.languageData?[index].code ?? '';
              });
              AppDatabase.getDatabase().then(
                      (value) => value.recentProductDao.deleteRecentProducts());
              Hive.deleteBoxFromDisk("newProductData");
              Hive.deleteBoxFromDisk("featureProductData");
              Hive.deleteBoxFromDisk("getCategoriesDrawerData");
              RestartWidget.restartApp(context);
              // ignore: use_build_context_synchronously
              Navigator.pushNamedAndRemoveUntil(
                  context, Splash, (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GlobalData.languageData?[index].code == selectedCode
                      ? Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  )
                      : Icon(
                    Icons.radio_button_off,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Text(GlobalData.languageData?[index].name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18)),
                ],
              ),
            ),
          );
        });
  }

  void getCode() async {
    var selectedCode1 = await SharedPreferenceHelper.getCustomerLanguage();
    setState(() {
      if (selectedCode1 == '') {
        selectedCode = GlobalData.languageData?.first.code ?? '';
      } else {
        selectedCode = selectedCode1;
      }
    });
  }
}
