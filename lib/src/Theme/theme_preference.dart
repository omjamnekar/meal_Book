import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String _isDarkModeKey = 'isDarkMode';

  // Get the current dark mode status
  static Future<bool> isDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  // Set the dark mode status
  static Future<void> setDarkMode(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }
}
