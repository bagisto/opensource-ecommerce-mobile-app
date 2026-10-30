# Language & Localization Configuration

This guide explains how language support works in the Bagisto Flutter app and how to add a new language correctly.

---

## Overview

The app uses Flutter's `gen_l10n` localization system with ARB files stored in [`lib/l10n/`](../lib/l10n/). Language selection is also connected to Bagisto backend locales, so adding a new language requires both:

1. Flutter app translations
2. Matching locale support in Bagisto

If only the app translations are added, the UI text can be localized, but Bagisto content like categories, CMS pages, and other translated storefront data may still come from the default backend language.

---

## Current Localization Files

| File | Purpose |
|------|---------|
| [`pubspec.yaml`](../pubspec.yaml) | Enables generated Flutter localization support with `flutter: generate: true` |
| [`l10n.yaml`](../l10n.yaml) | Configures the ARB directory and generated localization output |
| [`lib/l10n/app_en.arb`](../lib/l10n/app_en.arb) | Base English translation template |
| [`lib/l10n/app_*.arb`](../lib/l10n/) | Language translation files |
| [`lib/l10n/app_localizations.dart`](../lib/l10n/app_localizations.dart) | Generated localization delegate and supported locale list |
| [`lib/main.dart`](../lib/main.dart) | Applies selected locale to `MaterialApp` |
| [`lib/core/locale/locale_cubit.dart`](../lib/core/locale/locale_cubit.dart) | Saves and updates selected locale |
| [`lib/core/channel/channel_bootstrap_service.dart`](../lib/core/channel/channel_bootstrap_service.dart) | Loads available locales from Bagisto and stores the default locale |
| [`lib/core/graphql/graphql_client.dart`](../lib/core/graphql/graphql_client.dart) | Adds the `X-LOCALE` header to GraphQL requests |
| [`lib/features/account/presentation/pages/preferences_bottom_sheet.dart`](../lib/features/account/presentation/pages/preferences_bottom_sheet.dart) | Language selector in the account preferences UI |
| [`lib/features/account/presentation/pages/settings_bottom_sheet.dart`](../lib/features/account/presentation/pages/settings_bottom_sheet.dart) | Alternate language selector UI |

---

## Currently Supported Locales

The current generated app supports:

- `ar`
- `de`
- `en`
- `es`
- `fa`
- `fr`
- `it`
- `nl`
- `ru`
- `tr`
- `uk`

You can verify this in [`lib/l10n/app_localizations.dart`](../lib/l10n/app_localizations.dart).

---

## How Language Selection Works

1. At startup, [`ChannelBootstrapService`](../lib/core/channel/channel_bootstrap_service.dart) fetches the Bagisto channel configuration.
2. The service caches available locales and stores a default locale if it matches a Flutter-supported locale.
3. [`LocaleCubit`](../lib/core/locale/locale_cubit.dart) reads the saved locale code from shared preferences.
4. [`MaterialApp`](../lib/main.dart) applies the locale using:
   - `locale`
   - `localizationsDelegates`
   - `supportedLocales`
5. When the user changes the language in the app, the locale is saved again and key screens refresh.
6. [`GraphQLClientProvider`](../lib/core/graphql/graphql_client.dart) sends the selected locale in the `X-LOCALE` header, which allows Bagisto to return localized content.

---

## Add a New Language

### Step 1: Choose a Locale Code

Use a simple locale code that matches both Flutter and Bagisto, for example:

- `pt`
- `ja`
- `hi`

> Current app logic expects simple language codes like `en` or `fr`. Region-based locale codes such as `pt_BR` are not fully supported by the current locale storage/comparison flow.

### Step 2: Create a New ARB File

Copy the English template and create a new ARB file in [`lib/l10n/`](../lib/l10n/).

Example for Portuguese:

**New file:** [`lib/l10n/app_pt.arb`](../lib/l10n/)

```json
{
  "@@locale": "pt",
  "appTitle": "Bagisto Store",
  "homeFailedToLoad": "Falha ao carregar a pagina inicial",
  "commonRetry": "Tentar novamente"
}
```

### Rules for ARB Files

- **All keys from [`app_en.arb`](../lib/l10n/app_en.arb) must be present** in the new file. Missing keys may cause build failures or silent fallbacks to English.
- Keep placeholder metadata entries such as `@messageName`
- Translate only the values
- Make sure `@@locale` matches the file code

For messages with placeholders, keep the placeholder names unchanged:

```json
"homeAddedToCartMessage": "{productName} added to cart",
"@homeAddedToCartMessage": {
  "placeholders": {
    "productName": {}
  }
}
```

---

## Step 3: Regenerate Flutter Localization Files

Run:

```bash
flutter gen-l10n
```

This updates the generated files inside [`lib/l10n/`](../lib/l10n/), including:

- `app_localizations.dart`
- `app_localizations_<locale>.dart`

Because [`pubspec.yaml`](../pubspec.yaml) already has `flutter: generate: true`, Flutter can also regenerate these files during normal builds, but running `flutter gen-l10n` is the clearest manual step after adding a new ARB file.

---

## Step 4: Verify Generated Locale Support

After generation, confirm all of the following:

1. A generated file exists for the new locale, such as `app_localizations_pt.dart`
2. [`lib/l10n/app_localizations.dart`](../lib/l10n/app_localizations.dart) includes `Locale('pt')` in `supportedLocales`
3. The app still builds without localization errors

No manual update is normally required in [`lib/main.dart`](../lib/main.dart) because it already reads `AppLocalizations.supportedLocales`.

---

## Step 5: Add the Same Locale in Bagisto

This step is required if you want the language to appear in the app's language selector and receive translated storefront data from the backend.

Make sure Bagisto is configured so that:

1. The locale exists in Bagisto
2. The locale is assigned to the active channel
3. The locale code returned by Bagisto matches the ARB locale code exactly
4. The channel default locale is set if you want the app to start in that language by default

The app reads locale data from these GraphQL paths:

- [`lib/core/graphql/queries.dart`](../lib/core/graphql/queries.dart) → `channel.locales` and `channel.defaultLocale`
- [`lib/core/graphql/account_queries.dart`](../lib/core/graphql/account_queries.dart) → `locales`

If Bagisto does not return the new locale, the app will not show it in the dropdown even if the ARB file exists.

---

## Step 6: Test the New Language in the App

Recommended verification steps:

1. Launch the app after the new ARB file is generated
2. Open the account preferences or settings language selector
3. Confirm the new language appears in the dropdown
4. Select the language and verify UI labels update
5. Confirm Bagisto content is returned in the same language where backend translations exist
6. Restart the app and confirm the language remains selected

You can also inspect debug logs or network headers and verify that GraphQL requests include:

```text
X-LOCALE: <your-locale-code>
```

---

## Updating an Existing Language

To change translations for an existing language:

1. Edit the relevant [`app_<locale>.arb`](../lib/l10n/) file
2. Run `flutter gen-l10n`
3. Rebuild or restart the app

---

## iOS Note

If you want the iOS project metadata to explicitly list the language:

1. Open the Xcode project and add the language under the Runner target localizations.
2. Ensure the locale is listed in `CFBundleLocalizations` inside `Info.plist`, so iOS properly recognizes the supported language.

This is separate from Flutter ARB generation but is useful for native iOS configuration consistency.

---

## RTL (Right-to-Left) Language Support

Flutter automatically handles text direction based on the locale. If you add a new RTL language (such as `he` for Hebrew or `fa` for Persian), Flutter will apply RTL layout for standard widgets. However:

- Verify that custom widgets and padding/alignment values in the app are not hardcoded for LTR. Look for uses of `EdgeInsets.only(left: ...)` or `Alignment.centerLeft` that should use directional equivalents (`EdgeInsetsDirectional`, `AlignmentDirectional`).
- Test the full app in RTL mode to catch layout issues. Arabic (`ar`) is already supported, so most layouts should already work, but new screens added after the initial RTL pass may not have been tested.

---

## Current Codebase Caveats

When adding a new language, be aware of these existing behaviors:

- [`lib/features/search/presentation/pages/search_page.dart`](../lib/features/search/presentation/pages/search_page.dart) uses `localeId: 'en_US'` for speech recognition, so voice input does not currently follow the selected app language.
- [`lib/features/home/data/models/home_models.dart`](../lib/features/home/data/models/home_models.dart) prefers English theme customization translations when available, then falls back to the first available translation.
- Some parsing and fallback logic uses English as a safe default when localized backend data is missing.

These do not block adding a new UI language, but they are worth reviewing if you want a fully localized experience.

---

## Quick Checklist

- [ ] New `app_<locale>.arb` file created with **all keys** from `app_en.arb`
- [ ] `@@locale` matches the new code
- [ ] `flutter gen-l10n` completed without errors
- [ ] Generated localization file created (`app_localizations_<locale>.dart`)
- [ ] `supportedLocales` includes the new locale
- [ ] Bagisto channel exposes the same locale code
- [ ] Language appears in app settings
- [ ] GraphQL requests include the correct `X-LOCALE` header
- [ ] If RTL language: layout tested for RTL correctness
- [ ] If targeting iOS: locale added to Xcode localizations and `CFBundleLocalizations`

