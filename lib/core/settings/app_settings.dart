import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // Keys
  static const _kThemeKey = 'themeMode';
  static const _kLangKey  = 'languageCode';

  late final SharedPreferences _prefs;

  // ----- THEME -----
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // ----- LANGUAGE -----
  // "tr" | "en"
  String _languageCode = 'en';
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  AppSettings._(this._prefs) {
    _restore();
  }

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings._(prefs);
  }

  void _restore() {
    // Theme
    final raw = _prefs.getString(_kThemeKey);
    if (raw == 'light') {
      _themeMode = ThemeMode.light;
    } else if (raw == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    // Language
    final savedLang = _prefs.getString(_kLangKey);
if (savedLang != null && (savedLang == 'tr' || savedLang == 'en')) {
  _languageCode = savedLang;
} else {
      // cihaz dili tr/en ise onu al, değilse en
      final dev = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      _languageCode = (dev == 'tr') ? 'tr' : (dev == 'en' ? 'en' : 'en');
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(
      _kThemeKey,
      mode == ThemeMode.light
          ? 'light'
          : mode == ThemeMode.dark
              ? 'dark'
              : 'system',
    );
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    // yalnızca 'tr' ve 'en' kabul et
    final normalized = (code == 'tr') ? 'tr' : 'en';
    if (normalized == _languageCode) return;
    _languageCode = normalized;
    await _prefs.setString(_kLangKey, _languageCode);
    notifyListeners();
  }
}
