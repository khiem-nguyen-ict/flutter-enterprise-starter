import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsStorage {
  AppSettingsStorage({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  final SharedPreferences _prefs;

  static const String _themeModeKey = 'app_setting_theme_mode';
  static const String _localeKey = 'app_setting_locale';

  Future<void> setThemeMode(String themeMode) =>
      _prefs.setString(_themeModeKey, themeMode);

  String? getThemeMode() => _prefs.getString(_themeModeKey);

  Future<void> setLocale(String locale) =>
      _prefs.setString(_localeKey, locale);

  String? getLocale() => _prefs.getString(_localeKey);

  Future<void> clear() async {
    await _prefs.remove(_themeModeKey);
    await _prefs.remove(_localeKey);
  }
}
