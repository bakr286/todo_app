import 'package:flutter/material.dart';
import '/data/themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = lightTheme; // Default theme

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners(); 
  }
}