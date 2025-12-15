import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // App is locked to light mode only
  ThemeMode get themeMode => ThemeMode.light;

  bool get isDarkMode => false;

  void toggleTheme(bool enabled) {
    // Dark mode disabled; no-op
  }
}
