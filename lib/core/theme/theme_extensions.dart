import 'package:flutter/material.dart';

import 'app_elevation.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Ergonomic accessors for the design system via [BuildContext].
///
/// Usage:
/// ```dart
/// Container(
///   padding: context.spacing.cardPadding,
///   decoration: BoxDecoration(
///     borderRadius: context.radius.mdRadius,
///     boxShadow: context.elevation.shadow(context.elevation.medium),
///   ),
///   child: Text('Hi', style: context.typography.titleLarge),
/// );
/// ```
extension AppThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppTypography get typography =>
      Theme.of(this).extension<AppTypography>()!;
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
  AppRadius get radius => Theme.of(this).extension<AppRadius>()!;
  AppElevation get elevation => Theme.of(this).extension<AppElevation>()!;
}
