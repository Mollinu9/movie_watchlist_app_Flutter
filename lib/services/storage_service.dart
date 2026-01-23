import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_watchlist_app/models/movie.dart';
import 'package:movie_watchlist_app/models/app_settings.dart';
import 'package:movie_watchlist_app/models/user_profile.dart';

/// Service for handling local data persistence using Shared Preferences
class StorageService {
  late final SharedPreferences prefs;

  StorageService._(this.prefs);

  static StorageService? _instance;

  static Future<void> initialize() async {
    _instance ??= StorageService._(await SharedPreferences.getInstance());
  }

  static StorageService get instance => _instance!;

  // Storage keys
  static const String _moviesKey = 'movies_data';
  static const String _settingsKey = 'app_settings';
  static const String _profileKey = 'user_profile';

  /// Save movies to local storage
  Future<void> saveMovies(List<Movie> movies) async {
    final jsonList = movies.map((movie) => movie.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_moviesKey, jsonString);
  }

  /// Load movies from local storage
  Future<List<Movie>> loadMovies() async {
    final jsonString = prefs.getString(_moviesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  /// Save app settings to local storage
  Future<void> saveSettings(AppSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);
  }

  /// Load app settings from local storage
  Future<AppSettings> loadSettings() async {
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return AppSettings.defaultSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      // If there's an error parsing, return default settings
      return AppSettings.defaultSettings();
    }
  }

  /// Save user profile to local storage
  Future<void> saveProfile(UserProfile profile) async {
    final jsonString = jsonEncode(profile.toJson());
    debugPrint('DEBUG StorageService: Saving profile JSON: $jsonString');
    await prefs.setString(_profileKey, jsonString);
    debugPrint('DEBUG StorageService: Profile saved to key: $_profileKey');
  }

  /// Load user profile from local storage
  Future<UserProfile> loadProfile() async {
    final jsonString = prefs.getString(_profileKey);
    debugPrint('DEBUG StorageService: Loading profile from key: $_profileKey');
    debugPrint('DEBUG StorageService: Loaded JSON: $jsonString');
    if (jsonString == null || jsonString.isEmpty) {
      debugPrint('DEBUG StorageService: No profile found, returning default');
      return UserProfile.defaultProfile();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(json);
      debugPrint(
        'DEBUG StorageService: Parsed profile with username: "${profile.username}"',
      );
      return profile;
    } catch (e) {
      debugPrint('DEBUG StorageService: Error parsing profile: $e');
      // If there's an error parsing, return default profile
      return UserProfile.defaultProfile();
    }
  }
}
