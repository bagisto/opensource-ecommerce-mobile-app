# Configuration Guide

This guide explains how to configure the Bagisto Flutter app for your specific needs.

---

## Table of Contents

1. [API Configuration](#api-configuration)
2. [Theme & Color Configuration](#theme--color-configuration)
3. [Application Title](#application-title)
4. [App Icons](#app-icons)
5. [Splash Screen](#splash-screen)
6. [Permissions Configuration](#permissions-configuration)
7. [Push Notifications (Firebase)](#push-notifications-firebase)
8. [Language & Localization Configuration](#language--localization-configuration)
9. [GraphQL Configuration](#graphql-configuration)
10. [Summary of Configuration Files](#summary-of-configuration-files)

---

## API Configuration

Configure the Bagisto API endpoint and storefront key:

**File:** [`lib/core/constants/api_constants.dart`](../lib/core/constants/api_constants.dart)

```dart
/// Bagisto API endpoint
const String bagistoEndpoint = 'https://your-bagisto-domain.com/graphql';

/// Storefront key for Bagisto API
const String storefrontKey = 'your_storefront_key';

/// Company name
const String companyName = 'Your Company Name';
```

### Steps:
1. Open [`lib/core/constants/api_constants.dart`](../lib/core/constants/api_constants.dart)
2. Replace `bagistoEndpoint` with your Bagisto GraphQL endpoint
3. Replace `storefrontKey` with your storefront API key from Bagisto Admin
4. Update `companyName` to your company name

---

## Theme & Color Configuration

Customize the app's primary colors and theme:

**File:** [`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart)

### Primary Colors

In the [`AppColors`](../lib/core/theme/app_theme.dart) class, modify the primary colors:

```dart
class AppColors {
  // Primary Colors
  static const Color primary500 = Color(0xFFFF6900);  // Main primary color (Orange)
  static const Color primary600 = Color(0xFFF54900);  // Darker variant for pressed states
  
  // Neutral Colors - Light Theme
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

### Theme Configuration

The app supports both Light and Dark themes configured in the [`AppTheme`](../lib/core/theme/app_theme.dart) class:

- **Light Theme:** Uses white backgrounds with neutral-900 text
- **Dark Theme:** Uses neutral-900 backgrounds with neutral-200 text

Both themes use Material3 design with Roboto font family.

For detailed color customization, see [ColorSetUp.md](./ColorSetUp.md).

---

## Application Title

### Android

**File:** [`android/app/src/main/AndroidManifest.xml`](../android/app/src/main/AndroidManifest.xml)

Find and modify the `android:label` attribute:

```xml
<application
    android:label="Your App Name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

Current default: `Mobikul Bagisto Laravel App`

### iOS

**File:** [`ios/Runner/Info.plist`](../ios/Runner/Info.plist)

Find and modify the `CFBundleDisplayName` key:

```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

Current default: `Mobikul Bagisto Laravel App`

---

## App Icons

### Android

1. Open the `android` folder in Android Studio
2. Right-click on `app` → New → Image Asset
3. Set your custom icon image

**Icon Location:** [`android/app/src/main/res/mipmap-xxxhdpi/`](../android/app/src/main/res/mipmap-xxxhdpi/)

### iOS

**File:** [`ios/Runner/Assets.xcassets/AppIcon.appiconset/`](../ios/Runner/Assets.xcassets/AppIcon.appiconset/)

Replace the existing app icon images with your custom icons. Use Xcode's AppIcon template for proper sizing.

---

## Splash Screen

### Android

**File:** [`android/app/src/main/res/drawable-v21/launch_background.xml`](../android/app/src/main/res/drawable-v21/launch_background.xml)

Modify the splash background:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />
</layer-list>
```

### iOS

**File:** [`ios/Runner/Assets.xcassets/LaunchImage.imageset/`](../ios/Runner/Assets.xcassets/LaunchImage.imageset/)

Replace the following files with your custom splash image:
- `LaunchImage.png` (1x)
- `LaunchImage@2x.png` (2x)
- `LaunchImage@3x.png` (3x)

Also update [`ios/Runner/Assets.xcassets/splash.imageset/`](../ios/Runner/Assets.xcassets/splash.imageset/) for Flutter splash.

---

## Permissions Configuration

The app requires several permissions for full functionality:

### Android Permissions

**File:** [`android/app/src/main/AndroidManifest.xml`](../android/app/src/main/AndroidManifest.xml)

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

**File:** [`ios/Runner/Info.plist`](../ios/Runner/Info.plist)

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

## Push Notifications (Firebase)

To enable Firebase Cloud Messaging (Push Notifications), replace the dummy configuration files:

### Android

**File:** [`android/app/google-services.json`](../android/app/google-services.json)

Replace this file with your Firebase configuration file from the [Firebase Console](https://console.firebase.google.com/):

1. Go to Firebase Console → Project Settings → General
2. Click "Add App" → Android
3. Download `google-services.json`
4. Replace the existing file in `android/app/`

### iOS

**File:** [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist)

Replace this file with your Firebase configuration file:

1. Go to Firebase Console → Project Settings → General
2. Click "Add App" → iOS
3. Download `GoogleService-Info.plist`
4. Replace the existing file in `ios/Runner/`

> **Note:** The current files contain dummy values and must be replaced with your actual Firebase project configuration for push notifications to work.

---

## Language & Localization Configuration

The app already includes Flutter localization support and a language selector backed by Bagisto locale data.

### Current Supported Languages

The current app build supports these locales:

- `ar` - Arabic
- `de` - German
- `en` - English
- `es` - Spanish
- `fa` - Persian
- `fr` - French
- `it` - Italian
- `nl` - Dutch
- `ru` - Russian
- `tr` - Turkish
- `uk` - Ukrainian

These locales are generated from the ARB files inside [`lib/l10n/`](../lib/l10n/).

### Core Localization Files

| Purpose | File |
|---------|------|
| Enable Flutter localization generation | [`pubspec.yaml`](../pubspec.yaml) |
| Localization generator config | [`l10n.yaml`](../l10n.yaml) |
| Base translation template | [`lib/l10n/app_en.arb`](../lib/l10n/app_en.arb) |
| Generated supported locales and delegates | [`lib/l10n/app_localizations.dart`](../lib/l10n/app_localizations.dart) |
| Apply locale to `MaterialApp` | [`lib/main.dart`](../lib/main.dart) |
| Save selected locale in storage | [`lib/core/locale/locale_cubit.dart`](../lib/core/locale/locale_cubit.dart) |
| Bootstrap Bagisto locales on app start | [`lib/core/channel/channel_bootstrap_service.dart`](../lib/core/channel/channel_bootstrap_service.dart) |
| Send selected locale in GraphQL headers | [`lib/core/graphql/graphql_client.dart`](../lib/core/graphql/graphql_client.dart) |
| Language selector UI | [`lib/features/account/presentation/pages/preferences_bottom_sheet.dart`](../lib/features/account/presentation/pages/preferences_bottom_sheet.dart) |

### How It Works

1. On app startup, [`ChannelBootstrapService`](../lib/core/channel/channel_bootstrap_service.dart) fetches channel locales and the default locale from Bagisto.
2. The selected locale code is stored in shared preferences using [`LocaleCubit`](../lib/core/locale/locale_cubit.dart).
3. [`MaterialApp`](../lib/main.dart) uses that locale together with `AppLocalizations.delegate` and `AppLocalizations.supportedLocales`.
4. When the user changes language from the account/settings UI, the app updates the locale, clears GraphQL cache, and reloads key screens.
5. Every GraphQL request includes the selected locale in the `X-LOCALE` header so Bagisto can return translated content.

### Important Note

The current implementation is built around simple language codes such as `en`, `fr`, and `ar`. If you want region-specific locale codes such as `pt_BR` or `en_GB`, you will need code changes in locale storage and comparison logic.

### Add a New Language

For the complete step-by-step guide to add a new language to the app, see [LanguageConfiguration.md](./LanguageConfiguration.md).

---

## GraphQL Configuration

The app uses GraphQL for API communication. The configuration is handled in:

**File:** [`lib/core/graphql/graphql_client.dart`](../lib/core/graphql/graphql_client.dart)

### Key Features:

| Feature | Configuration |
|---------|---------------|
| HTTP Timeout | 60 seconds (connect & receive) |
| Authentication | Bearer token for authenticated requests |
| Dynamic Headers | `X-STOREFRONT-KEY`, `X-LOCALE`, `X-CURRENCY` |
| Cache | HiveStore with fallback to InMemoryStore |
| Logging | Request/response logging enabled |
| Fetch Policy | networkOnly (bypasses cache for queries) |

### Client Types:

1. **Standard Client** ([`GraphQLClientProvider.client`](../lib/core/graphql/graphql_client.dart)) - For guest users
2. **Authenticated Client** ([`GraphQLClientProvider.authenticatedClient`](../lib/core/graphql/graphql_client.dart)) - For logged-in users with Bearer token

---

## Summary of Configuration Files

| Configuration | File Path |
|--------------|-----------|
| **API Endpoint** | [`lib/core/constants/api_constants.dart`](../lib/core/constants/api_constants.dart) |
| **Theme/Colors** | [`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart) |
| **Android App Name** | [`android/app/src/main/AndroidManifest.xml`](../android/app/src/main/AndroidManifest.xml) |
| **iOS App Name** | [`ios/Runner/Info.plist`](../ios/Runner/Info.plist) |
| **Android Icons** | [`android/app/src/main/res/mipmap-xxxhdpi/`](../android/app/src/main/res/mipmap-xxxhdpi/) |
| **iOS Icons** | [`ios/Runner/Assets.xcassets/AppIcon.appiconset/`](../ios/Runner/Assets.xcassets/AppIcon.appiconset/) |
| **Android Splash** | [`android/app/src/main/res/drawable-v21/launch_background.xml`](../android/app/src/main/res/drawable-v21/launch_background.xml) |
| **iOS Splash** | [`ios/Runner/Assets.xcassets/LaunchImage.imageset/`](../ios/Runner/Assets.xcassets/LaunchImage.imageset/) |
| **Android Firebase** | [`android/app/google-services.json`](../android/app/google-services.json) |
| **iOS Firebase** | [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) |
| **Localization ARB Files** | [`lib/l10n/`](../lib/l10n/) |
| **Localization Generator Config** | [`l10n.yaml`](../l10n.yaml) |
| **Locale State Management** | [`lib/core/locale/locale_cubit.dart`](../lib/core/locale/locale_cubit.dart) |
| **Locale Bootstrap from Bagisto** | [`lib/core/channel/channel_bootstrap_service.dart`](../lib/core/channel/channel_bootstrap_service.dart) |
| **GraphQL Client** | [`lib/core/graphql/graphql_client.dart`](../lib/core/graphql/graphql_client.dart) |
| **Android Permissions** | [`android/app/src/main/AndroidManifest.xml`](../android/app/src/main/AndroidManifest.xml) |
| **iOS Permissions** | [`ios/Runner/Info.plist`](../ios/Runner/Info.plist) |
| **Dependencies** | [`pubspec.yaml`](../pubspec.yaml) |

---

## Additional Resources

- [ColorSetUp.md](./ColorSetUp.md) - Detailed color customization guide
- [LanguageConfiguration.md](./LanguageConfiguration.md) - Add or update app languages
- [ServerConfig.md](./ServerConfig.md) - Server-side configuration
- [InstallationGuide.md](./installationGuide.md) - App installation instructions
- [PlaceholderSetup.md](./PlaceholderSetup.md) - Placeholder image configuration
