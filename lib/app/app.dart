import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../ui/theme/app_theme.dart';

/// Locale is fixed. The app is Bangla-only by design — a Bangla/English toggle
/// is listed as a future step in the web spec and is not in Phase 1 scope.
/// Declaring it here is what gives the stock date picker and dialogs Bangla
/// chrome via MaterialLocalizations.
const kAppLocale = Locale('bn', 'BD');

class BogccApp extends StatelessWidget {
  const BogccApp({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'বগুড়া সিটি কর্পোরেশন',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: kAppLocale,
      supportedLocales: const [kAppLocale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );
  }
}
