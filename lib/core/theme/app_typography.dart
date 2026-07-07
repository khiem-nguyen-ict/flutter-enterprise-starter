import 'package:flutter/material.dart';

import 'app_colors.dart';

TextStyle _style(double size, FontWeight weight, double height,
    [double letterSpacing = 0]) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Typography tokens following the Material 3 type scale.
///
/// Exposed both as a [ThemeExtension] (for `context.typography.*` access) and
/// as a [TextTheme] (so standard widgets pick up the scale automatically).
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  factory AppTypography.fromColorScheme(ColorScheme scheme) {
    final Color onSurface = scheme.onSurface;
    final Color onSurfaceVariant = scheme.onSurfaceVariant;
    final Color onError = scheme.onError;

    TextStyle tint(TextStyle base, Color color) => base.copyWith(color: color);

    return AppTypography(
      displayLarge: tint(_style(57, FontWeight.w400, 1.12), onSurface),
      displayMedium: tint(_style(45, FontWeight.w400, 1.16), onSurface),
      displaySmall: tint(_style(36, FontWeight.w400, 1.22), onSurface),
      headlineLarge: tint(_style(32, FontWeight.w400, 1.25), onSurface),
      headlineMedium: tint(_style(28, FontWeight.w400, 1.29), onSurface),
      headlineSmall: tint(_style(24, FontWeight.w400, 1.33), onSurface),
      titleLarge: tint(_style(22, FontWeight.w500, 1.27), onSurface),
      titleMedium:
          tint(_style(16, FontWeight.w500, 1.5, 0.15), onSurface),
      titleSmall:
          tint(_style(14, FontWeight.w500, 1.57, 0.1), onSurfaceVariant),
      bodyLarge: tint(_style(16, FontWeight.w400, 1.5, 0.5), onSurface),
      bodyMedium:
          tint(_style(14, FontWeight.w400, 1.43, 0.25), onSurface),
      bodySmall:
          tint(_style(12, FontWeight.w400, 1.33, 0.4), onSurfaceVariant),
      labelLarge:
          tint(_style(14, FontWeight.w500, 1.43, 0.1), onSurface),
      labelMedium:
          tint(_style(12, FontWeight.w500, 1.33, 0.5), onSurfaceVariant),
      labelSmall:
          tint(_style(11, FontWeight.w500, 1.45, 0.5), onError),
    );
  }

  static final AppTypography light = AppTypography.fromColorScheme(
    AppColors.lightColorScheme,
  );

  static final AppTypography dark = AppTypography.fromColorScheme(
    AppColors.darkColorScheme,
  );

  /// Material 3 [TextTheme] built from these tokens so default widgets
  /// inherit the scale automatically.
  TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  @override
  AppTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return AppTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  AppTypography lerp(AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium:
          TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }
}
