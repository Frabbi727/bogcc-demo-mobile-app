import 'package:flutter/material.dart';

import 'colors.dart';

/// Font families. Both are bundled assets — see pubspec.yaml for why they are
/// not fetched at runtime.
abstract final class AppFonts {
  /// Body, labels, controls. The web's `--font-sans`.
  static const sans = 'HindSiliguri';

  /// Headings, certificates, stamps. The web's `--font-display`.
  static const display = 'TiroBangla';

  /// Never let an unbundled glyph render as tofu. Android ships a Bengali face;
  /// if a character is missing from our two, fall through to it rather than
  /// drawing a box.
  static const fallback = <String>['Noto Sans Bengali', 'sans-serif'];
}

/// The text scale. Sizes follow the web's 15px body and 1.6 line height.
TextTheme buildTextTheme() {
  const display = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.fallback,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.35,
  );
  const body = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    color: AppColors.ink,
    height: 1.6,
  );

  return TextTheme(
    // Headings use Tiro Bangla at regular weight, as `h1,h2,h3` do on the web.
    displaySmall: display.copyWith(fontSize: 28),
    headlineMedium: display.copyWith(fontSize: 24),
    headlineSmall: display.copyWith(fontSize: 20),
    titleLarge: display.copyWith(fontSize: 18),

    titleMedium: body.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),

    bodyLarge: body.copyWith(fontSize: 16),
    bodyMedium: body.copyWith(fontSize: 15),
    bodySmall: body.copyWith(fontSize: 13, color: AppColors.muted),

    labelLarge: body.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
    labelMedium: body.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
    labelSmall: body.copyWith(fontSize: 12, color: AppColors.muted),
  );
}
