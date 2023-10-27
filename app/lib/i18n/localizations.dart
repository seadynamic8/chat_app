import 'package:chat_app/i18n/locale_es.dart';
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final t =
      Translations.byLocale('en_us') + esLocale; // * Append new locales here

  // Main localization function
  String get i18n => localize(this, t);

  // This allows params to substitute values, using sprintf package
  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, t);

  String version(Object modifier) => localizeVersion(modifier, this, t);

  Map<String?, String> allVersions() => localizeAllVersions(this, t);
}
