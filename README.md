<p align="center">
    <a href="http://www.bagisto.com"><img src="https://bagisto.com/wp-content/themes/bagisto/images/logo.png" alt="Total Downloads"></a>
</p>

<p align="center">
    <a href="https://twitter.com/intent/follow?screen_name=bagistoshop"><img src="https://img.shields.io/twitter/follow/bagistoshop?style=social"></a>
    <a href="https://www.youtube.com/channel/UCbrfqnhyiDv-bb9QuZtonYQ"><img src="https://img.shields.io/youtube/channel/subscribers/UCbrfqnhyiDv-bb9QuZtonYQ?style=social"></a>
    <a href="https://deepwiki.com/bagisto/opensource-ecommerce-mobile-app"><img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki"></a>
</p>


# Open Source eCommerce Mobile App

[Bagisto](https://bagisto.com/en/) revolutionizes the world of mobile commerce with its open-source eCommerce mobile app solution. This open-source mobile ecommerce app seamlessly transforms your Bagisto store into a powerful mobile platform, providing real-time synchronization of products and categories. With a user-friendly interface, managing orders becomes a breeze, making it an essential tool for tech-savvy individuals and those new to eCommerce.

This mobile app, built on the foundation of the Bagisto eCommerce framework and leveraging the robust Laravel stack, offers many features for a comprehensive and efficient mobile shopping experience. The app ensures easy product information management and accelerates time-to-market for your products, all while giving you complete control over your store.

# Live Demo

Android: <https://play.google.com/store/apps/details?id=com.webkul.bagisto.mobikul>

iOS: <https://apps.apple.com/us/app/mobikul-bagisto-laravel-app/id6447519140>

# Features

The open-source ecommerce mobile app comes with an array of features to improve your customers' shopping experience.

## Interactive Home Page and Search

![Interactive Home Page and Search](Docs/features_images/Interactive%20Home%20Page%20and%20Search.png)

## All Type Product Supported

![All Type Product Supported](Docs/features_images/All%20Type%20Product%20Supported.png)

## Dark Mode and Push Notification 

![Dark Mode and Push Notification](Docs/features_images/Dark%20Mode%20and%20Push%20Notification.png)

## Discount Coupons and Guest Checkout

![Discount Coupons and Guest Checkout](Docs/features_images/Discount%20Coupons%20and%20Guest%20Checkout.png)

## Wishlist and Product Category

![Wishlist and Product Category](Docs/features_images/Wishlist%20and%20Product%20Category.png)

## Order Details and Product Reviews

![Order Details and Product Reviews](Docs/features_images/Order%20Details%20and%20Product%20Reviews.png)

## Installation Guide

Before beginning with the installation, you will need the following with the mentioned versions

- Bagisto Version - Bagisto v2.0.0 or higher
- Android Studio Meerkat | 2024.3.2
- Flutter Version - 3.38.9
- Dart - 3.10.8
- Xcode - 26.3
- Swift - 6.1

Make sure you have installed the [API module](https://github.com/bagisto/bagisto-api) and set this up properly on your bagisto.

> NOTE: It is recommended that you run a simple Hello World program in Flutter first before proceeding further so that you are sure that the environment is properly set up.

## Installation Steps

### Clone the repository

- Open your terminal or command prompt
- Navigate to the directory where you want to save the project
- Use the git clone command followed by the repository URL

```sh
git clone https://github.com/bagisto/opensource-ecommerce-mobile-app.git
```

### Install dependencies

- Navigate to the project's directory

```sh
cd <repository-name>
```

- Run the following command to install the required packages

```sh
flutter pub get
```

### Generate Required files

- Navigate to the project's directory

```sh
cd <repository-name>
```

- Run the following command to generate the required files

```sh
flutter pub run build_runner build --delete-conflicting-outputs 
```

### Connect a device or emulator

- Physical Device

  1. Enable USB debugging on your device
  2. Connect it to your computer using a USB cable.

- Emulator

  1. Start an Android or iOS emulator using your preferred IDE or tools.

### Run the Project

- Use the following command to build and run the project

```sh
flutter run
```

## Minimum Versions

- Android: 22
- iOS: 16

## Configurations Steps

### For Setup

Change the baseDomain  as per your store

Go to `lib/core/constants/api_constants.dart` and configure the following:

```dart
/// Bagisto GraphQL endpoint (e.g., https://your-bagisto-server.com/graphql)
const String bagistoEndpoint = 'YOUR_BAGISTO_ENDPOINT_HERE';

/// Storefront key for Bagisto API
/// Get this from your Bagisto admin panel
const String storefrontKey = 'YOUR_STOREFRONT_KEY_HERE';

/// Company name (optional metadata)
const String companyName = 'Your Company Name';
```

### For Theme

In the `AppColors` class, find and modify the primary colors:

```dart
class AppColors {
  // Primary Colors - Modify these hex values to change the app's primary color
  static const Color primary500 = Color(0xFFFF6900);  // Main primary color
  static const Color primary600 = Color(0xFFF54900);  // Darker variant for pressed states
  // ...
}
```

**To change the primary color:**
- Replace `0xFFFF6900` with your desired color hex value
- Adjust `primary600` to a slightly darker shade of your primary color
```

### For Push Notification Service

- Android

Replace "google-services.json".

- iOS

Replace "GoogleService-Info.plist".

> Helpful Articles

> Android  → <https://mobikul.com/knowledgebase/generating-google-service-file-enable-fcm-firebase-cloud-messaging-android-application/>

> iOS → <https://mobikul.com/knowledgebase/generating-new-googleservice-info-plist-file-fcm-based-project-ios-app/>

### For Application Title

- Android

  1. **Path:** android/app/src/main/AndroidManifest.xml
  2. **Change app name:** android:label="***********"

- iOS

  1. Go to the general tab and identity change the display name to your app name

> For Homepage Header Title - Go to ‘assets/language/en.json’
> (Note: Here, “en” in en.json refers to the languages that would be supported within the application)

### For Splash Screen

- For adding an Image as a Splash Screen

  1. **Path:** assets/images/splash.png
  2. After updating the Image file, update the ‘splashImage’ in lib/utils/assets_constants.

```sh
  static const String splashImage = "assets/images/splash.png";
```

### For App Icon

- **Android:** Open the android folder in Android Studio and then right click app > new > Image Asset set Image.
- **iOS:** Replace the icons over the path > ios/Runner/Assets.xcassets/AppIcon.appiconset

## Installation Video

[![Watch the video](https://i.ibb.co/c6qd31t/thumbnail-1.jpg)](https://www.youtube.com/watch?v=tvm2NUZP9ks)

## API Documentation

For the API Documentation, please go through - <https://api-docs.bagisto.com/api/graphql-api/introduction.html>

## Usage

For detailed usage instructions, refer to the official documentation

## Contributing

Contributions are welcome! Follow the contribution guidelines to get started.

## License

Bagisto is open-sourced software licensed under the MIT license.
