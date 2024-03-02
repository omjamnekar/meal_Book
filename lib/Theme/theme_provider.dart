import 'package:MealBook/Theme/theme.dart'; // Importing your lightMode and darkMode themes
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // Default theme is set to lightMode

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners when the theme changes
  }

  void toggleTheme() {
    // Toggle between light and dark modes
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
