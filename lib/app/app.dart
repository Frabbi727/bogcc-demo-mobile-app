import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/theme/app_theme.dart';
import 'router.dart';

/// Locale is fixed. The app is Bangla-only by design — a Bangla/English toggle
/// is a future step in the web spec and is not in Phase 1 scope. Declaring it
/// is what gives the stock date picker and dialogs Bangla chrome through
/// MaterialLocalizations.
const kAppLocale = Locale('bn', 'BD');

const _localizationsDelegates = <LocalizationsDelegate<Object>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class BogccApp extends ConsumerWidget {
  const BogccApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'বগুড়া সিটি কর্পোরেশন',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: kAppLocale,
      supportedLocales: const [kAppLocale],
      localizationsDelegates: _localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// A plain [MaterialApp] with the same chrome, for widget tests and goldens
/// that render one screen rather than driving the router.
class BogccAppHost extends StatelessWidget {
  const BogccAppHost({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'বগুড়া সিটি কর্পোরেশন',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: kAppLocale,
      supportedLocales: const [kAppLocale],
      localizationsDelegates: _localizationsDelegates,
      home: home,
    );
  }
}
