 
 # Configuration Guide:-

**//--------------------Configuration Guide Opensource Bagisto app----------------------//**

### For setup the application:
- Path-Project.lib.configuration.serverConfiguration.dart
- Change BASE_URL,username & password.

```  
static const String BASE_URL = "***********";  
static const String API_WS_KEY  = "***********";  
static const String demoAdminEmail  = "***********";  
static const String demoAdminPassword  = "***********";  
```  

- Path-Project.project name.lib.configuration.MobikulTheme.dart
- Change primary & accent color.

```  
static const Color primaryColor = Color(***********);  
static const Color accentColor = Color(***********);  
```

&nbsp;

## For Application Title:
- **Android**
    * Path-android/app/src/main/AndroidManifest.xml
    * change app name - **android:label=```"***********"```**.
- **iOS**
    * Go to the ios then Runner and open the info.plist file
    * Find the key named as **CFBundleDisplayName** and replace the string value to reflect the new app name.
    * From here you can change your app name.

&nbsp;

##  For splash screen:
- **Android**
    * Path-android/app/src/main/res/drawable/
    * replace the **splash_background**.
- **iOS**
    * Go to the below given path and replace splash image with yours
    * path- ios/Runner/Assets.xcassets/LaunchImage.imageset/**LaunchImage.png**.

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
    * Path-ios/Runner/AppDelegate.m
    * GMSServices provideAPIKey:@"Your Google Map Key For ios".

  &nbsp;