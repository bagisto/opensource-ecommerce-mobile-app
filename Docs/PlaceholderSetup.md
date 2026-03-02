# Placeholder & Image Setup

This guide explains how to set up splash screens, logos, icons, and placeholders in the Bagisto Flutter app.

---

## Asset Directory Structure

The app's assets are stored in the `assets/` folder:

```
assets/
├── images/
│   ├── splash.png          # Splash screen image
│   ├── bagisto_logo.svg    # Bagisto logo (SVG)
│   ├── apple_icon.svg      # Apple sign-in icon
│   ├── facebook_icon.svg   # Facebook sign-in icon
│   └── google_icon.svg     # Google sign-in icon
└── ml/
    └── (ML model files)
```

---

## Splash Screen

### Image Location

**File:** `assets/images/splash.png`

The splash screen is configured in:
**File:** `lib/features/splash/presentation/splash_screen.dart`

```dart
SplashScreen(
  backgroundColor: Colors.white,
  child: Image.asset(
    'assets/images/splash.png',
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,
  ),
)
```

### To Customize Splash Screen

1. Replace `assets/images/splash.png` with your custom image
2. Recommended size: 1920x1080 pixels (or higher for high-DPI displays)
3. The splash displays for 3 seconds before navigating to the home screen

### Android Splash Configuration

**File:** `android/app/src/main/res/drawable/launch_background.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />
</layer-list>
```

### iOS Splash Configuration

**File:** `ios/Runner/Base.lproj/LaunchScreen.storyboard`

Modify the storyboard to customize the iOS launch screen.

---

## App Icons (Launcher Icons)

### Android

**Location:** `android/app/src/main/res/`

The Android adaptive icons are stored in various `mipmap` directories:
- `mipmap-mdpi/`
- `mipmap-hdpi/`
- `mipmap-xhdpi/`
- `mipmap-xxhdpi/`
- `mipmap-xxxhdpi/`

**To change the app icon:**
1. Use Android Studio's Image Asset tool:
   - Right-click on `app` → New → Image Asset
   - Select "Launcher Icons" as the icon type
   - Choose your custom icon image

### iOS

**File:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**To change the app icon:**
1. Replace the existing icon images in this folder with your custom icons
2. Ensure you provide all required sizes (20, 29, 40, 60, 76, 83.5 points @1x, @2x, @3x)

---

## Logo & Social Login Icons

The app includes SVG logos for branding and social login:

| Icon | File Path |
|------|-----------|
| Bagisto Logo | `assets/images/bagisto_logo.svg` |
| Apple Icon | `assets/images/apple_icon.svg` |
| Facebook Icon | `assets/images/facebook_icon.svg` |
| Google Icon | `assets/images/google_icon.svg` |

### To Customize Logos

1. Add your custom SVG or PNG files to `assets/images/`
2. Update the `pubspec.yaml` to include the new assets:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/ml/
```

3. Reference the image in your code:

```dart
Image.asset('assets/images/your-logo.png')
// or for SVG
SvgPicture.asset('assets/images/your-logo.svg')
```

---

## Image Placeholders

This app uses **code-based placeholders** rather than placeholder images. When images are loading, the app displays colored containers as placeholders.

### Placeholder Colors

Placeholders use theme-aware colors defined in `lib/core/theme/app_theme.dart`:

```dart
// Light mode placeholder
AppColors.neutral100  // Light gray background

// Dark mode placeholder
AppColors.neutral800  // Dark gray background
```

### How Placeholders Work

The app uses the `cached_network_image` package which provides a `placeholder` callback:

```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => Container(
    color: isDark ? AppColors.neutral800 : AppColors.neutral100,
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Widgets with Placeholders

The following widgets implement placeholder support:
- Product cards (`product_card_large.dart`, `product_card_small.dart`)
- Category banners (`category_banner.dart`)
- Category images (`category_chip_row.dart`, `sub_category_section.dart`)
- Product images (`product_image_carousel.dart`, `product_related_section.dart`)
- Cart items (`cart_page.dart`)
- Home page widgets (`static_content_widget.dart`, `category_carousel.dart`)

---

## Adding Custom Placeholder Images

If you want to use custom placeholder images instead of code-based placeholders:

1. Add placeholder images to `assets/images/`:
   ```
   assets/images/placeholder.png
   ```

2. Use them in your widgets:

```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => Image.asset(
    'assets/images/placeholder.png',
    fit: BoxFit.cover,
  ),
)
```

---

## Summary

| Asset Type | Location |
|------------|----------|
| Splash Screen | `assets/images/splash.png` |
| App Logo | `assets/images/bagisto_logo.svg` |
| Social Icons | `assets/images/{apple,facebook,google}_icon.svg` |
| Android Icons | `android/app/src/main/res/mipmap-*/` |
| iOS Icons | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` |
| Placeholders | Code-based (Container widgets) |
