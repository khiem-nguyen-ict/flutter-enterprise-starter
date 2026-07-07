import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_enterprise_starter/config/theme/theme_notifier.dart';
import 'package:flutter_enterprise_starter/core/storage/app_settings_storage.dart';

class MockAppSettingsStorage extends Mock implements AppSettingsStorage {}

void main() {
  group('ThemeModeNotifier', () {
    late MockAppSettingsStorage mockStorage;

    setUp(() {
      mockStorage = MockAppSettingsStorage();
      when(() => mockStorage.getThemeMode()).thenReturn(null);
    });

    test('starts with system mode when storage returns null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = ThemeModeNotifier(mockStorage);

      expect(notifier.state, ThemeMode.system);
    });

    test('loads saved theme mode from storage', () {
      when(() => mockStorage.getThemeMode()).thenReturn('light');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = ThemeModeNotifier(mockStorage);

      expect(notifier.state, ThemeMode.light);
    });

    test('setThemeMode persists to storage and updates state', () async {
      when(() => mockStorage.setThemeMode(any())).thenAnswer((_) async {});
      when(() => mockStorage.getThemeMode()).thenReturn(null);

      final notifier = ThemeModeNotifier(mockStorage);

      await notifier.setThemeMode(ThemeMode.dark);

      expect(notifier.state, ThemeMode.dark);
      verify(() => mockStorage.setThemeMode('dark')).called(1);
    });

    test('delegates parseThemeMode by persisting and reading back', () async {
      when(() => mockStorage.setThemeMode(any())).thenAnswer((_) async {});

      final notifier = ThemeModeNotifier(mockStorage);

      await notifier.setThemeMode(ThemeMode.system);

      expect(notifier.state, ThemeMode.system);
      verify(() => mockStorage.setThemeMode('system')).called(1);
    });
  });
}
