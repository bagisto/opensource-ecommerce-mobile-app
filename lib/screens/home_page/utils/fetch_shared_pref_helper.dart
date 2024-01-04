
import '../../../utils/shared_preference_helper.dart';

///fetch that the user is login or not?
Future getCustomerLoggedInPrefValue() async {
  return await SharedPreferenceHelper.getCustomerLoggedIn();
}

///fetch cart count saved in shared pref
Future getSharePreferenceCartCount() async {
  return await SharedPreferenceHelper.getCartCount();
}

///fetch customer's language saved in shared pref
Future getCustomerLanguageName() async {
  return await SharedPreferenceHelper.getLanguageName();
}

///fetch customer's currency saved in shared pref
Future getCurrencyName() async {
  return await SharedPreferenceHelper.getCurrencyLabel();
}

///fetch customer's language saved in shared pref

Future getLanguageCode() async {
  return await SharedPreferenceHelper.getCustomerLanguage();
}
