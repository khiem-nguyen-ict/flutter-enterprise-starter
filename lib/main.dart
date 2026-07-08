import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/l10n/app_localizations.dart';
import 'config/locale/locale_notifier.dart';
import 'config/theme/theme_notifier.dart';
import 'core/routing/app_router.dart';
import 'core/storage/storage_providers.dart';
import 'core/theme/app_theme.dart';

/// Replaces the Material 3 "stretch" overscroll indicator on Android.
///
/// Flutter's default [MaterialScrollBehavior] paints a
/// [StretchingOverscrollIndicator] on Android when [ThemeData.useMaterial3] is
/// true, which visibly stretches the whole viewport when the user scrolls past
/// the content bounds. This uses the classic, non-stretching edge-glow
/// indicator instead, while leaving every other platform untouched.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (getPlatform(context) == TargetPlatform.android) {
      return GlowingOverscrollIndicator(
        axisDirection: details.direction,
        color: Theme.of(context).colorScheme.secondary,
        child: child,
      );
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      scrollBehavior: const AppScrollBehavior(),
    );
  }
}
