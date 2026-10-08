import 'package:flutter/widgets.dart';

/// Maps a channel locale code to a locale the app has translations for.
///
/// Channel locales come from the API as-is (e.g. `AR`, `pt_BR`, `hi`).
/// The language part is matched case-insensitively; a language without app
/// translations falls back to English instead of Flutter's default of the
/// first supported locale. Returns null when [locale] is null so the device
/// locale is used.
Locale? resolveAppLocale(Locale? locale, Iterable<Locale> supported) {
  if (locale == null) return null;
  final language = locale.languageCode.split(RegExp('[_-]')).first.toLowerCase();
  for (final candidate in supported) {
    if (candidate.languageCode.toLowerCase() == language) return candidate;
  }
  for (final candidate in supported) {
    if (candidate.languageCode == 'en') return candidate;
  }
  return supported.isEmpty ? null : supported.first;
}
