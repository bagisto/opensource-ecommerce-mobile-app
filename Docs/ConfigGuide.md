# Configuration Guide

This guide explains how to configure the Bagisto Flutter app for your specific needs.

---

## API Configuration

Configure the Bagisto API endpoint and storefront key:

**File:** `lib/core/constants/api_constants.dart`

```dart
/// Bagisto API endpoint
const String bagistoEndpoint = 'https://your-bagisto-domain.com/graphql';

/// Storefront key for Bagisto API
const String storefrontKey = 'your_storefront_key';

/// Company name
const String companyName = 'Your Company Name';
```

---

## Theme & Color Configuration

Customize the app's primary colors and theme:

**File:** `lib/core/theme/app_theme.dart`

In the `AppColors` class, modify the primary colors:

```dart
class AppColors {
  // Primary Colors
  static const Color primary500 = Color(0xFFFF6900);  // Main primary color
  static const Color primary600 = Color(0xFFF54900);  // Darker variant for pressed states
  // ... neutral, status, and other colors
}
```

For detailed color customization, see [ColorSetUp.md](./ColorSetUp.md).

---

## Application Title

### Android

**File:** `android/app/src/main/AndroidManifest.xml`

Find and modify the `android:label` attribute:

```xml
<application
    android:label="Your App Name"
    ... >
```

### iOS

**File:** `ios/Runner/Info.plist`

Find and modify the `CFBundleDisplayName` key:

```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

---

## Splash Screen

### Android

**File:** `android/app/src/main/res/drawable/launch_background.xml`

Modify the splash background color:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />
</layer-list>
```

### iOS

**File:** `ios/Runner/Assets.xcassets/LaunchImage.imageset/`

Replace `LaunchImage.png` with your custom splash image.

---

## App Icons

### Android

1. Open the `android` folder in Android Studio
2. Right-click on `app` → New → Image Asset
3. Set your custom icon image

### iOS

**File:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Replace the existing app icon images with your custom icons.

---

## Push Notifications

### Android

**File:** `android/app/google-services.json`

Replace this file with your Firebase configuration file from the Firebase Console.

### iOS

**File:** `ios/Runner/GoogleService-Info.plist`

Replace this file with your Firebase configuration file from the Firebase Console.

---

## Google Maps

This app does not currently include Google Maps integration. If you need to add Google Maps:

### Android

**File:** `android/app/src/main/AndroidManifest.xml`

Add the following permission and meta-data:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

### iOS

**File:** `ios/Runner/AppDelegate.swift` (or AppDelegate.m for Objective-C)

Add the API key initialization:

```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

---

## GraphQL Configuration

The app uses GraphQL for API communication. The configuration is handled in:

**File:** `lib/core/graphql/graphql_client.dart`

This file sets up:
- HTTP client with 30-second timeout
- Authentication headers (X-STOREFRONT-KEY)
- Cache management using Hive

---

## Summary of Configuration Files

| Configuration | File Path |
|--------------|-----------|
| API Endpoint | `lib/core/constants/api_constants.dart` |
| Theme/Colors | `lib/core/theme/app_theme.dart` |
| Android App Name | `android/app/src/main/AndroidManifest.xml` |
| iOS App Name | `ios/Runner/Info.plist` |
| Push Notifications | `android/app/google-services.json` / `ios/Runner/GoogleService-Info.plist` |
| GraphQL Client | `lib/core/graphql/graphql_client.dart` |
