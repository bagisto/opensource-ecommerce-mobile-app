
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// Application Specific Constants
const int defaultSplashDelay =3;///it is the default timing of splash screen

// Web Server Related Default Setting Constants (Will Be Configured as per client Recommendations, if any)
    const String baseUrl = "https://demo.bagisto.com/mobikul-common/graphql";//1.4.5 instance live demo shift
//     const String baseUrl = "http://192.168.15.113/laravel/docker-demo/mobikul/public/graphql";//1.4.5 instance local
//   const String baseUrl = "http://192.168.15.113/mp-graphql/public/graphql";//1.4.5  instance live demo shift
// const String baseUrl = "https://demo.bagisto.com/social-signup-common/graphql"; //1.4.5 social login for truecaller
const String defaultWebsiteId = "1";///default website id
const String defaultChannelId = "1";///default channel id
const String defaultChannelName= "com.mlkit";///default channel id
const String defaultStoreCode = "en";///default store code
const String defaultCurrencyCode = "";
const String storage =  "storage/";///this storage keyword is appending with image url to get the image
List <String> supportedLocale=['en',"ar","fr","nl","tr","es","pt_br"];///supported locales in app
const availablePaymentMethods = ["cashondelivery","moneytransfer",];


