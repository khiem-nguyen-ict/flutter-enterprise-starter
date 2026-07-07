import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings_storage.dart';
import 'secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnsupportedError(
    'sharedPreferencesProvider must be overridden with SharedPreferences.getInstance()',
  );
});

final appSettingsStorageProvider = Provider<AppSettingsStorage>((ref) {
  return AppSettingsStorage(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});
