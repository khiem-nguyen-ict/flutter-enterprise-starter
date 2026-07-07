import 'package:flutter/material.dart';

/// Elevation / shadow tokens (Material 3 elevation levels) as a [ThemeExtension].
///
/// Provides both raw elevation values (for [Material.elevation]) and a
/// [shadow] helper that returns a tuned [BoxShadow] list for custom widgets.
class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.none,
    required this.low,
    required this.medium,
    required this.high,
    required this.highest,
  });

  final double none;
  final double low;
  final double medium;
  final double high;
  final double highest;

  static const AppElevation standard = AppElevation(
    none: 0,
    low: 1,
    medium: 3,
    high: 6,
    highest: 8,
  );

  /// Returns a subtle, tuned shadow list for the given elevation level.
  List<BoxShadow> shadow(double elevation) {
    if (elevation <= none) return const [];
    final double opacity = 0.12 * (elevation / highest).clamp(0.0, 1.0);
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: opacity),
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation),
      ),
    ];
  }

  @override
  AppElevation copyWith({
    double? none,
    double? low,
    double? medium,
    double? high,
    double? highest,
  }) {
    return AppElevation(
      none: none ?? this.none,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
      highest: highest ?? this.highest,
    );
  }

  @override
  AppElevation lerp(AppElevation? other, double t) => other ?? this;
}
