import 'package:flutter/material.dart';
import '../database/settings_database.dart' show SettingDatabase;
import '/data/themes.dart';

class ThemeProvider with ChangeNotifier {
   ThemeData _currentTheme= themes[0]; 
  final SettingDatabase _settingDatabase = SettingDatabase();

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final themeIndex = await _settingDatabase.getThemeIndex();
    _currentTheme = themes[themeIndex];
    notifyListeners();
  }

  ThemeData get currentTheme => _currentTheme;

  Future<void> setTheme(ThemeData theme) async {
    _currentTheme = theme;
    final themeIndex = themes.indexOf(theme);
    await _settingDatabase.setThemeIndex(themeIndex);
    notifyListeners();
  }
}