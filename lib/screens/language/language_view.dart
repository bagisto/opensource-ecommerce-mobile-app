import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:hive/hive.dart';
import '../../data_model/currency_language_model.dart';
import '../../main.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedCode = '';
  List<Locales>? languages;

  @override
  void initState() {
    languages = GlobalData.languageData?.locales;
    super.initState();
    getCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.language.localized()),
        centerTitle: false,
      ),
      body:  ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: languages?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                GlobalData.locale = languages?[index].code?? "";
                appStoragePref.setCustomerLanguage(languages?[index].code ?? "");
                GlobalData.locale = appStoragePref.getCustomerLanguage();
                appStoragePref.setLanguageName(
                    languages?[index].name ?? "");
                setState(() {
                  selectedCode = languages?[index].code ?? '';
                });
                Hive.deleteBoxFromDisk("getCategoriesDrawerData");
                Hive.deleteBoxFromDisk("recentProducts");

                if(mounted){
                  RestartWidget.restartApp(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, splash, (route) => false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacingLarge),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    languages?[index].code == selectedCode
                        ? const Icon(
                      Icons.radio_button_checked,
                      size: 20,
                    )
                        : const Icon(
                      Icons.radio_button_off,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Text(languages?[index].name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }


  void getCode() {
    var selectedCode1 = appStoragePref.getCustomerLanguage();
    setState(() {
      if (selectedCode1 == '') {
        selectedCode = languages?.first.code ?? '';
      } else {
        selectedCode = selectedCode1;
      }
    });
  }
}
