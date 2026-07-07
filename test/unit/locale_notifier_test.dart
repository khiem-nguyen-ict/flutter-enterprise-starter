import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_enterprise_starter/config/locale/locale_notifier.dart';
import 'package:flutter_enterprise_starter/core/storage/app_settings_storage.dart';

class MockAppSettingsStorage extends Mock implements AppSettingsStorage {}

void main() {
  group('LocaleNotifier', () {
    late MockAppSettingsStorage mockStorage;

    setUp(() {
      mockStorage = MockAppSettingsStorage();
      when(() => mockStorage.getLocale()).thenReturn(null);
    });

    test('starts with en locale when storage returns null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = LocaleNotifier(mockStorage);
      final locale = notifier.state;

      expect(locale, const Locale('en'));
    });

    test('loads saved locale from storage', () {
      when(() => mockStorage.getLocale()).thenReturn('fi');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = LocaleNotifier(mockStorage);
      final locale = notifier.state;

      expect(locale, const Locale('fi'));
    });

    test('setLocale persists to storage and updates state', () async {
      when(() => mockStorage.setLocale(any())).thenAnswer((_) async {});
      when(() => mockStorage.getLocale()).thenReturn(null);

      final notifier = LocaleNotifier(mockStorage);

      await notifier.setLocale(const Locale('vi'));

      expect(notifier.state, const Locale('vi'));
      verify(() => mockStorage.setLocale('vi')).called(1);
    });
  });
}
