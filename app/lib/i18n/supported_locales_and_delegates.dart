import 'dart:ui';

import 'package:flutter_localizations/flutter_localizations.dart';

const supportedLocales = [
  Locale('en', "US"),
  Locale('es'),
  Locale('zh'),
];

const localizationDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
