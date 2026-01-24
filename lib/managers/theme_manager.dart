import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

class ThemeManager extends ChangeNotifier {
  AppSettings _settings;

  ThemeManager() : _settings = AppSettings.defaultSettings();

  // Initialize ThemeManager by loading settings from storage
  Future<void> initialize() async {
    _settings = await StorageService.instance.loadSettings();
    notifyListeners();
  }

  // Get current dark mode state
  bool get isDarkMode => _settings.isDarkMode;

  // Get current theme data
  ThemeData getCurrentTheme() {
    return _settings.isDarkMode ? _darkTheme : _lightTheme;
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    await StorageService.instance.saveSettings(_settings);
    notifyListeners();

    // Log analytics event
    await AnalyticsService.logThemeChanged(_settings.isDarkMode);
  }

  // Light theme definition
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // Dark theme definition
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
