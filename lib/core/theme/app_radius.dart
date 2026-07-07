import 'package:flutter/material.dart';

/// Corner radius tokens (Material 3 shape scale) as a [ThemeExtension].
///
/// Use the raw doubles for [BorderRadius] customization, or the convenience
/// `*.radius` getters for ready-made [BorderRadius] values.
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  static const AppRadius standard = AppRadius(
    none: 0,
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999,
  );

  BorderRadius get noneRadius => BorderRadius.zero;
  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get fullRadius => BorderRadius.circular(full);

  @override
  AppRadius copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return AppRadius(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  AppRadius lerp(AppRadius? other, double t) => other ?? this;
}
