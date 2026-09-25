import 'package:flutter/material.dart';

/// The palette, ported one-for-one from the web demo's `src/index.css` `@theme`
/// block so the two demos can be shown side by side without a visible seam.
///
/// The names are the web's names on purpose. When a colour looks wrong on a
/// screen, the fix is to change it in both places, not to invent a new token.
abstract final class AppColors {
  /// Corporation green. Primary actions, the app bar, selected nav.
  static const forest700 = Color(0xFF0E5A43);

  /// Pressed/darker green.
  static const forest800 = Color(0xFF0A4232);

  /// Tinted green surface — selected rows, info panels.
  static const forest50 = Color(0xFFEEF6F2);

  /// The app background. A register book is paper, not white.
  static const paper = Color(0xFFF4F6F3);

  /// Card and sheet surfaces, a shade warmer than pure white.
  static const page = Color(0xFFFFFFFC);

  /// Body text.
  static const ink = Color(0xFF1C2B27);

  /// Secondary text, labels, hints.
  static const muted = Color(0xFF5E6E69);

  /// Ledger rules, borders, dividers.
  static const rule = Color(0xFFCFDBEA);

  /// The red margin line down a register page.
  static const margin = Color(0xFFE8A0A0);

  /// Rubber stamps, cancellation, destructive actions.
  static const stamp = Color(0xFFB3261E);

  /// Due soon, warnings, pending payment.
  static const amber = Color(0xFFC27C0E);

  /// Informational, links, online-channel badges.
  static const sky = Color(0xFF1D6FA3);
}
