# Configuration Guide

**Bagisto Flutter App Configuration Guide**

---

## Table of Contents

1. [API Configuration](#api-configuration)
2. [Theme Configuration](#theme-configuration)
3. [Application Title](#application-title)
4. [Splash Screen](#splash-screen)
5. [App Icon](#app-icon)
6. [Push Notification Service](#push-notification-service)
7. [Permissions Configuration](#permissions-configuration)

---

## API Configuration

**File:** [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart:1)

Configure the Bagisto GraphQL API endpoint and storefront key:

```dart
/// Bagisto API endpoint
const String bagistoEndpoint = 'https://your-bagisto-domain.com/graphql';

/// Storefront key for Bagisto API
const String storefrontKey = 'your_storefront_key';

/// Company name
const String companyName = 'Your Company Name';
```

### Steps:
1. Open [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart:1)
2. Replace `bagistoEndpoint` with your Bagisto GraphQL endpoint URL
3. Replace `storefrontKey` with your storefront API key from Bagisto Admin Panel
4. Update `companyName` to your company name (default: "Webkul Software (Registered in India)")

---

## Theme Configuration

**File:** [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart:1)

Change primary colors in the [`AppColors`](lib/core/theme/app_theme.dart:7) class:

```dart
class AppColors {
  // Primary Colors
  static const Color primary500 = Color(0xFFFF6900);  // Main primary color (Orange)
  static const Color primary600 = Color(0xFFF54900);  // Darker variant for pressed states
  
  // Neutral Colors (Light Theme)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA1A1A1);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  
  // Status Colors
  static const Color successGreen = Color(0xFF00A63E);
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success500 = Color(0xFF00C950);
  static const Color success700 = Color(0xFF008236);
  
  // Process / Info Colors
  static const Color process600 = Color(0xFF155DFC);
  static const Color process700 = Color(0xFF1447E6);
  
  // Static Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
```

### Theme Modes

The app supports both Light and Dark themes configured in the [`AppTheme`](lib/core/theme/app_theme.dart:172) class:

- **Light Theme:** Uses white backgrounds with neutral-900 text
- **Dark Theme:** Uses neutral-900 backgrounds with neutral-200 text

Both themes use Material3 design with Roboto font family.

For detailed color customization, see [`Docs/ColorSetUp.md`](Docs/ColorSetUp.md).

---

## Application Title

### Android

**File:** [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml:17)

Change the app name by modifying the `android:label` attribute:

```xml
<application
    android:label="Your App Name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

Current default: `Mobikul Bagisto Laravel App`

### iOS

**File:** [`ios/Runner/Info.plist`](ios/Runner/Info.plist:10)

Find the key `CFBundleDisplayName` and replace the string value:

```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

Current default: `Mobikul Bagisto Laravel App`

---

## Splash Screen

**File:** [`assets/images/splash.png`](assets/images/splash.png)

Replace the existing splash.png file with your custom splash screen image.

### Platform-Specific Configuration:

#### Android
**File:** [`android/app/src/main/res/drawable-v21/launch_background.xml`](android/app/src/main/res/drawable-v21/launch_background.xml:1)

#### iOS
**Files:** 
- [`ios/Runner/Assets.xcassets/LaunchImage.imageset/`](ios/Runner/Assets.xcassets/LaunchImage.imageset/)
- [`ios/Runner/Assets.xcassets/splash.imageset/`](ios/Runner/Assets.xcassets/splash.imageset/)

Replace the following files:
- `LaunchImage.png` (1x)
- `LaunchImage@2x.png` (2x)
- `LaunchImage@3x.png` (3x)

---

## App Icon

### Android

1. Open the `android` folder in Android Studio
2. Right-click on `app` → New → Image Asset
3. Set your custom icon image

**Icon Location:** [`android/app/src/main/res/mipmap-xxxhdpi/`](android/app/src/main/res/mipmap-xxxhdpi/)

### iOS

**File:** [`ios/Runner/Assets.xcassets/AppIcon.appiconset/`](ios/Runner/Assets.xcassets/AppIcon.appiconset/)

Replace the existing app icon images with your custom icons. Use Xcode's AppIcon template for proper sizing.

---

## Push Notification Service

### Android

**File:** [`android/app/google-services.json`](android/app/google-services.json:1)

Replace this file with your Firebase configuration file from the [Firebase Console](https://console.firebase.google.com/).

> **Note:** The current file contains dummy values and must be replaced with your actual Firebase project configuration.

### iOS

**File:** [`ios/Runner/GoogleService-Info.plist`](ios/Runner/GoogleService-Info.plist:1)

Replace this file with your Firebase configuration file from the [Firebase Console](https://console.firebase.google.com/).

> **Note:** The current file contains dummy values and must be replaced with your actual Firebase project configuration.

---

## Permissions Configuration

The app requires several permissions for full functionality:

### Android Permissions

**File:** [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml:1)

```xml
<!-- Camera permissions for image search -->
<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

<!-- Microphone permission for speech recognition -->
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<!-- Internet permission -->
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS Permissions

**File:** [`ios/Runner/Info.plist`](ios/Runner/Info.plist:29)

```xml
<!-- Camera for image search -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture photos for image-based product search.</string>

<!-- Microphone for voice search -->
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice search functionality.</string>

<!-- Photo Library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select images for product search.</string>
<key>NSPhotoLibraryAddOnlyUsageDescription</key>
<string>This app needs permission to save photos from your camera.</string>

<!-- Speech Recognition -->
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app uses speech recognition for voice search.</string>
```

---

## Summary of Configuration Files

| Configuration | File Path |
|--------------|-----------|
| API Endpoint & Keys | [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart:1) |
| Theme/Colors | [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart:1) |
| Android App Name | [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml:17) |
| iOS App Name | [`ios/Runner/Info.plist`](ios/Runner/Info.plist:10) |
| Android Icons | [`android/app/src/main/res/mipmap-xxxhdpi/`](android/app/src/main/res/mipmap-xxxhdpi/) |
| iOS Icons | [`ios/Runner/Assets.xcassets/AppIcon.appiconset/`](ios/Runner/Assets.xcassets/AppIcon.appiconset/) |
| Splash Screen Image | [`assets/images/splash.png`](assets/images/splash.png) |
| Android Firebase Config | [`android/app/google-services.json`](android/app/google-services.json:1) |
| iOS Firebase Config | [`ios/Runner/GoogleService-Info.plist`](ios/Runner/GoogleService-Info.plist:1) |
| GraphQL Client | [`lib/core/graphql/graphql_client.dart`](lib/core/graphql/graphql_client.dart:1) |
| Dependencies | [`pubspec.yaml`](pubspec.yaml:1) |

---

## Additional Resources

- [`Docs/ConfigGuide.md`](Docs/ConfigGuide.md) - Alternative detailed configuration guide
- [`Docs/ColorSetUp.md`](Docs/ColorSetUp.md) - Detailed color customization guide
- [`Docs/ServerConfig.md`](Docs/ServerConfig.md) - Server-side configuration
- [`Docs/installationGuide.md`](Docs/installationGuide.md) - App installation instructions
- [`Docs/PlaceholderSetup.md`](Docs/PlaceholderSetup.md) - Placeholder image configuration
