import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    return null;
  }

  Locale? set(Locale locale) {
    state = locale;
    return state;
  }
}
