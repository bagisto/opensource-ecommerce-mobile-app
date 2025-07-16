/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

const int defaultSplashDelay = 3;

/////base domain of the server
const String baseDomain = "";

const String baseUrl = "$baseDomain/graphql";

///default channel id
const String defaultChannelId = "1";

///default store code
const String defaultStoreCode = "en";

const String defaultLanguageName = "English";

const String defaultCurrencyCode = "USD";

const String defaultCurrencyName = "US Dollar";

const String defaultAppTitle = "Bagisto App";

///default channel name
const String defaultChannelName = "com.webkul.bagisto_mobikul/channel";

const String demoEmail = "";

const String demoPassword = "";

///supported locales in app
List<String> supportedLocale = ['en', 'fr', 'nl', 'tr', 'es', 'ar', 'pt_br'];

const bool isPreFetchingEnable = true;

///supported payment methods in app
const availablePaymentMethods = [
  "cashondelivery",
  "moneytransfer",
  "paypal_standard",
  "paypal_smart_button"
];
