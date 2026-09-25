import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// The single light theme. There is no dark theme: the whole visual idea is a
/// paper register book, and every printed artefact (licence, receipt,
/// certificate) is black ink on white regardless of the device setting.
ThemeData buildAppTheme() {
  final text = buildTextTheme();

  const scheme = ColorScheme.light(
    primary: AppColors.forest700,
    onPrimary: Colors.white,
    primaryContainer: AppColors.forest50,
    onPrimaryContainer: AppColors.forest800,
    secondary: AppColors.sky,
    onSecondary: Colors.white,
    error: AppColors.stamp,
    onError: Colors.white,
    surface: AppColors.page,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.muted,
    outline: AppColors.rule,
    outlineVariant: AppColors.rule,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.paper,
    textTheme: text,
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.forest700,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(color: Colors.white),
    ),

    cardTheme: CardThemeData(
      color: AppColors.page,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: const BorderSide(color: AppColors.rule),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.rule,
      thickness: 1,
      space: 1,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        // 48dp: these are thumbs on a phone, often outdoors.
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        foregroundColor: AppColors.forest700,
        side: const BorderSide(color: AppColors.rule),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        textStyle: text.labelLarge,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.page,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: const BorderSide(color: AppColors.rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: const BorderSide(color: AppColors.rule),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: const BorderSide(color: AppColors.forest700, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: const BorderSide(color: AppColors.stamp),
      ),
      labelStyle: text.bodyMedium?.copyWith(color: AppColors.muted),
      hintStyle: text.bodyMedium?.copyWith(color: AppColors.muted),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.page,
      indicatorColor: AppColors.forest50,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(text.labelSmall),
    ),

    listTileTheme: const ListTileThemeData(
      textColor: AppColors.ink,
      iconColor: AppColors.muted,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
