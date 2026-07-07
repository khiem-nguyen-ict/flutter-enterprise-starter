import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_elevation.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Assembles the full [ThemeData] for light and dark modes.
///
/// All design tokens (typography, spacing, radius, elevation) are attached as
/// [ThemeExtension]s so they can be accessed uniformly via [BuildContext].
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = AppColors.lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: AppTypography.light.textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppElevation.standard.none,
        scrolledUnderElevation: AppElevation.standard.low,
      ),
      cardTheme: CardThemeData(
        elevation: AppElevation.standard.low,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.standard.mdRadius,
        ),
      ),
      extensions: [
        AppTypography.light,
        AppSpacing.standard,
        AppRadius.standard,
        AppElevation.standard,
      ],
    );
  }

  static ThemeData dark() {
    final colorScheme = AppColors.darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: AppTypography.dark.textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppElevation.standard.none,
        scrolledUnderElevation: AppElevation.standard.low,
      ),
      cardTheme: CardThemeData(
        elevation: AppElevation.standard.low,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.standard.mdRadius,
        ),
      ),
      extensions: [
        AppTypography.dark,
        AppSpacing.standard,
        AppRadius.standard,
        AppElevation.standard,
      ],
    );
  }
}
