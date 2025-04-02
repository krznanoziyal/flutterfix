// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final String key = 'theme';
  late SharedPreferences prefs;
  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeService() {
    _isDarkMode = false;
    _loadFromPrefs();
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _isDarkMode);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }
}