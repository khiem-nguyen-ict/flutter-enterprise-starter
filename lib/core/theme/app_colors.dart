import 'package:flutter/material.dart';

/// Central color system for the application.
///
/// Built on Material 3: a single brand [seed] drives [ColorScheme.fromSeed]
/// so light and dark schemes stay harmonized automatically. Raw palette
/// constants are exposed for non-theme usage (charts, custom paints, etc.).
abstract final class AppColors {
  // Brand seed color drives the entire Material 3 palette.
  static const Color seed = Color(0xFF4F6EF7);

  // Scrims for modals / overlays.
  static const Color lightScrim = Color(0x80000000);
  static const Color darkScrim = Color(0xB3000000);

  // Theme-agnostic semantic status colors.
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);
  static const Color error = Color(0xFFD32F2F);

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
}
