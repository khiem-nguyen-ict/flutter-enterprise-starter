import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/app_settings_storage.dart';
import '../../core/storage/storage_providers.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._appSettingsStorage) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final AppSettingsStorage _appSettingsStorage;

  void _loadThemeMode() {
    final savedThemeMode = _appSettingsStorage.getThemeMode();
    if (savedThemeMode != null) {
      state = _parseThemeMode(savedThemeMode);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _appSettingsStorage.setThemeMode(themeMode.name);
    state = themeMode;
  }

  static ThemeMode _parseThemeMode(String value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(appSettingsStorageProvider));
});
