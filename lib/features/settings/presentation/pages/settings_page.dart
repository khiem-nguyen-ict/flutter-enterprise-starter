import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/l10n/app_localizations.dart';
import '../../../../config/locale/locale_notifier.dart';
import '../../../../config/theme/theme_notifier.dart';
import '../../../../features/auth/data/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${l10n.appTitle} (${l10n.localeName})'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(l10n.backToHome),
            ),
            const SizedBox(height: 32),
            const Text('Theme'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ThemeChip(
                  label: 'Light',
                  themeMode: ThemeMode.light,
                  selected: currentThemeMode == ThemeMode.light,
                  onSelected: (mode) {
                    ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  },
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Dark',
                  themeMode: ThemeMode.dark,
                  selected: currentThemeMode == ThemeMode.dark,
                  onSelected: (mode) {
                    ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  },
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'System',
                  themeMode: ThemeMode.system,
                  selected: currentThemeMode == ThemeMode.system,
                  onSelected: (mode) {
                    ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Language / Kieli / Ngôn ngữ'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LanguageChip(
                  label: 'EN',
                  locale: const Locale('en'),
                  selected: currentLocale == const Locale('en'),
                  onSelected: (locale) {
                    ref.read(localeProvider.notifier).setLocale(locale);
                  },
                ),
                const SizedBox(width: 8),
                _LanguageChip(
                  label: 'FI',
                  locale: const Locale('fi'),
                  selected: currentLocale == const Locale('fi'),
                  onSelected: (locale) {
                    ref.read(localeProvider.notifier).setLocale(locale);
                  },
                ),
                const SizedBox(width: 8),
                _LanguageChip(
                  label: 'VI',
                  locale: const Locale('vi'),
                  selected: currentLocale == const Locale('vi'),
                  onSelected: (locale) {
                    ref.read(localeProvider.notifier).setLocale(locale);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
              icon: const Icon(Icons.logout_outlined),
              label: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.themeMode,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final ThemeMode themeMode;
  final bool selected;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(themeMode),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.locale,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final Locale locale;
  final bool selected;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(locale),
    );
  }
}
