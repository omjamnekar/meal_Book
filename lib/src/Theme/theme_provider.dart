import 'package:flutter/material.dart';
import 'package:MealBook/src/Theme/theme.dart';
import 'package:MealBook/src/Theme/theme_preference.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // Default theme is set to lightMode

  ThemeProvider() {
    // Initialize the theme based on the saved dark mode status
    _initializeTheme();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners when the theme changes

    // Update the dark mode status in SharedPreferences
    ThemePreferences.setDarkMode(_themeData == darkMode);
  }

  void _initializeTheme() async {
    // Retrieve the dark mode status from SharedPreferences
    bool isDarkMode = await ThemePreferences.isDarkMode();

    // Set the theme based on the retrieved status
    themeData = isDarkMode ? darkMode : lightMode;
  }

  void toggleTheme() {
    // Toggle between light and dark modes
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }
}
