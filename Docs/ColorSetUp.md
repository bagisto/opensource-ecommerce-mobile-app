# Color Setup Guide

This document explains how to customize colors in the Bagisto Flutter app.

## Color Architecture

The app uses a centralized color system defined in `lib/core/theme/app_theme.dart`. All colors are defined in the `AppColors` class and are used throughout the application.

## Steps to Customize Colors

### 1. Locate the Theme File

Navigate to:
```
lib/core/theme/app_theme.dart
```

### 2. Modify Primary Colors

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

### 3. Color Categories Available

The app defines several color categories:

| Category | Description |
|----------|-------------|
| **Primary** | Main brand colors (primary500, primary600) |
| **Neutral** | Grayscale palette (neutral50-neutral900) for backgrounds, text, borders |
| **Status** | Success colors (green shades for success states) |
| **Process** | Info/blue colors (process600, process700) |
| **Static** | Basic colors (white, black) |

### 4. How Colors Are Used

The colors are consumed in multiple ways:

**Directly via AppColors class:**
```dart
Container(
  color: AppColors.primary500,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.neutral900),
  ),
)
```

**Via ThemeData (Material 3):**
```dart
ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary500,
    secondary: AppColors.primary600,
  ),
)
```

**Via TextStyles:**
```dart
TextStyle(
  color: AppColors.primary500,
)
```

### 5. Dark Mode Support

The app supports both light and dark themes. Colors automatically adjust based on the theme:

- Light theme uses: neutral50-neutral800 for backgrounds and text
- Dark theme uses: neutral800-neutral900 for backgrounds, neutral200 for text

### 6. Theme Switching

To toggle between light and dark themes programmatically:

```dart
context.read<ThemeCubit>().toggleTheme();
```

Or set a specific theme:
```dart
context.read<ThemeCubit>().setLight();
context.read<ThemeCubit>().setDark();
```

## Color Hex Value Format

Flutter uses the format `0xFF` followed by 6 hexadecimal digits:
- `0xFF` = Alpha channel (fully opaque)
- First 2 digits = Red
- Middle 2 digits = Green
- Last 2 digits = Blue

Examples:
- White: `0xFFFFFFFF`
- Black: `0xFF000000`
- Orange: `0xFFFF6900`
- Blue: `0xFF155DFC`

## Best Practices

1. **Maintain contrast**: Ensure text colors have sufficient contrast with backgrounds
2. **Primary color consistency**: Use primary500 for main actions and primary600 for pressed states
3. **Semantic colors**: Use status colors (successGreen) for feedback messages
4. **Test both themes**: Verify colors work well in both light and dark modes
