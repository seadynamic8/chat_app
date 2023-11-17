import 'dart:ui';

extension LocaleFromString on String {
  Locale getLocale() {
    final localeString = split('_');

    return switch (localeString) {
      [final lang, final script, final country] => Locale.fromSubtags(
          languageCode: lang,
          scriptCode: script,
          countryCode: country,
        ),
      [final lang, final script]
          when ['Cyrl', 'Latn', 'Hans', 'Hant'].contains(script) =>
        Locale.fromSubtags(
          languageCode: lang,
          scriptCode: script,
        ),
      [final lang, final country] => Locale.fromSubtags(
          languageCode: lang,
          countryCode: country,
        ),
      _ => Locale.fromSubtags(languageCode: localeString.first),
    };
  }
}
