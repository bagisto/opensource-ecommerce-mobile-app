
# Configuration Guide:-

**//--------------------Configuration Guide Bagisto app----------------------//**

### For setup the application:
- Path-lib/utils/server_configuration.dart
- Change baseUrl, defaultAppTitle, demo login email & password.
- To disable preFetching and caching change isPreFetchingEnable to false.

```  
static const String baseUrl = "***********";   
static const String demoEmail  = "***********";  
static const String demoPassword  = "***********"; 
static const String defaultAppTitle  = "***********"; 
```  

- Path-lib/utils/mobikul_theme.dart
- Change primary & accent color.

```  
static const Color primaryColor = Color(***********);  
static const Color accentColor = Color(***********);  
```

- Path-assets/language/
- Change builderAppName with new app name in language string json files (en.json, ar.json, es.json etc)

&nbsp;

## For Application Title:
- **Android**
    * Path-android/app/src/main/AndroidManifest.xml
    * change app name - **android:label=```"***********"```**.
- **iOS**
    * Go to the ios then Runner and open the info.plist file
    * Find the key named as **CFBundleDisplayName** and replace the string value to reflect the new app name.

&nbsp;

##  For splash screen:
- **Change splash screen with lottie json**
    * Path-assets/lottie/
    * replace the **splash_screen**.
- **Or change splash screen with image**
    * Path-assets/images/
    * replace the **splash.png**.
    * Go to lib/screens/splash_screen/view/splash_screen.dart
    * comment the lottie asset splash code and uncomment stack code for asset image splash.

  &nbsp;

## For App icon:
- **Android** - open **android** folder right click **app > new > Image Asset** set Image.
- **iOS** - ios/Runner/Assets.xcassets/AppIcon.appiconset

  &nbsp;

## For push notification service:
- **Android** - Replace **"google-services.json"**.
- **iOS** - Replace **"GoogleService-Info.plist"**.

  &nbsp;

## For Google maps:
- **Android**
    * Path-Project/Project name/android/app/src/main/AndroidManifest.xml
    * Replace Your Google Map Key For android.
- **iOS**
    * Path-ios/Runner/AppDelegate.swift
    * GMSServices provideAPIKey:@"Your Google Map Key For ios".

  &nbsp;

## For deeplink:
- **Android**
    * Path-android/app/src/main/AndroidManifest.xml
    * Change host - **android:host=```"***********"```**.
    * Change path - **android:pathPrefix=```"***********"```**.
- **iOS**
    * Path-ios/Runner/Info.plist
    * Find the key named as **CFBundleURLName** and replace with the host name.
    * Open ios project in Xcode and go to signing and capabilities expand associated domains and from here replace - **applinks:```***********```**

  &nbsp;
