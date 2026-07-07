import 'package:flutter/material.dart';

/// Spacing scale (4pt base grid) exposed as a [ThemeExtension].
///
/// Access via `context.spacing.lg`. Also provides common [EdgeInsets]
/// presets so layouts stay consistent.
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.none,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.huge,
  });

  final double none;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double huge;

  /// Standard 4pt-based spacing scale used across the app.
  static const AppSpacing standard = AppSpacing(
    none: 0,
    xxs: 2,
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    xxl: 32,
    xxxl: 48,
    huge: 64,
  );

  EdgeInsets get screenPadding => EdgeInsets.all(lg);
  EdgeInsets get cardPadding => EdgeInsets.all(md);
  EdgeInsets get listItemPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
  EdgeInsets get inlinePadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: sm);

  @override
  AppSpacing copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? huge,
  }) {
    return AppSpacing(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      huge: huge ?? this.huge,
    );
  }

  @override
  AppSpacing lerp(AppSpacing? other, double t) => other ?? this;
}
