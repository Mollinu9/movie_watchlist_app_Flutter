import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlist_app/models/movie.dart';

class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  /// Initialize Firebase Analytics
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('📊 ANALYTICS: Already initialized, skipping');
      return;
    }

    try {
      debugPrint('📊 ANALYTICS: Starting Firebase Analytics initialization...');
      _analytics = FirebaseAnalytics.instance;
      _initialized = true;
      debugPrint('✅ ANALYTICS: Firebase Analytics initialized successfully');
      debugPrint('📊 ANALYTICS: Instance ID: ${_analytics.hashCode}');
    } catch (e) {
      debugPrint('❌ ANALYTICS: Failed to initialize Firebase Analytics: $e');
      _initialized = false;
    }
  }

  /// Log when a movie is added
  static Future<void> logMovieAdded(String genre, MovieStatus status) async {
    final timestamp = DateTime.now().toIso8601String();

    if (!_initialized || _analytics == null) {
      debugPrint(
        '⚠️ ANALYTICS [$timestamp]: Not initialized, skipping movie_added event',
      );
      return;
    }

    try {
      debugPrint('📊 ANALYTICS [$timestamp]: Logging movie_added event');
      debugPrint('   └─ Genre: $genre');
      debugPrint('   └─ Status: ${status.name}');

      await _analytics!.logEvent(
        name: 'movie_added',
        parameters: {
          'genre': genre,
          'status': status.name,
          'timestamp': timestamp,
        },
      );

      debugPrint(
        '✅ ANALYTICS [$timestamp]: movie_added event sent successfully',
      );
    } catch (e) {
      debugPrint(
        '❌ ANALYTICS [$timestamp]: Failed to log movie_added event: $e',
      );
    }
  }

  /// Log when a movie is updated
  static Future<void> logMovieUpdated() async {
    final timestamp = DateTime.now().toIso8601String();

    if (!_initialized || _analytics == null) {
      debugPrint(
        '⚠️ ANALYTICS [$timestamp]: Not initialized, skipping movie_updated event',
      );
      return;
    }

    try {
      debugPrint('📊 ANALYTICS [$timestamp]: Logging movie_updated event');

      await _analytics!.logEvent(
        name: 'movie_updated',
        parameters: {'timestamp': timestamp},
      );

      debugPrint(
        '✅ ANALYTICS [$timestamp]: movie_updated event sent successfully',
      );
    } catch (e) {
      debugPrint(
        '❌ ANALYTICS [$timestamp]: Failed to log movie_updated event: $e',
      );
    }
  }

  /// Log when a movie is deleted
  static Future<void> logMovieDeleted() async {
    final timestamp = DateTime.now().toIso8601String();

    if (!_initialized || _analytics == null) {
      debugPrint(
        '⚠️ ANALYTICS [$timestamp]: Not initialized, skipping movie_deleted event',
      );
      return;
    }

    try {
      debugPrint('📊 ANALYTICS [$timestamp]: Logging movie_deleted event');

      await _analytics!.logEvent(
        name: 'movie_deleted',
        parameters: {'timestamp': timestamp},
      );

      debugPrint(
        '✅ ANALYTICS [$timestamp]: movie_deleted event sent successfully',
      );
    } catch (e) {
      debugPrint(
        '❌ ANALYTICS [$timestamp]: Failed to log movie_deleted event: $e',
      );
    }
  }

  /// Log when theme is changed
  static Future<void> logThemeChanged(bool isDarkMode) async {
    final timestamp = DateTime.now().toIso8601String();

    if (!_initialized || _analytics == null) {
      debugPrint(
        '⚠️ ANALYTICS [$timestamp]: Not initialized, skipping theme_changed event',
      );
      return;
    }

    try {
      final theme = isDarkMode ? 'dark' : 'light';
      debugPrint('📊 ANALYTICS [$timestamp]: Logging theme_changed event');
      debugPrint('   └─ Theme: $theme');

      await _analytics!.logEvent(
        name: 'theme_changed',
        parameters: {'theme': theme, 'timestamp': timestamp},
      );

      debugPrint(
        '✅ ANALYTICS [$timestamp]: theme_changed event sent successfully',
      );
    } catch (e) {
      debugPrint(
        '❌ ANALYTICS [$timestamp]: Failed to log theme_changed event: $e',
      );
    }
  }

  /// Log screen views
  static Future<void> logScreenView(String screenName) async {
    final timestamp = DateTime.now().toIso8601String();

    if (!_initialized || _analytics == null) {
      debugPrint(
        '⚠️ ANALYTICS [$timestamp]: Not initialized, skipping screen_view',
      );
      return;
    }

    try {
      debugPrint('📊 ANALYTICS [$timestamp]: Logging screen_view');
      debugPrint('   └─ Screen: $screenName');

      await _analytics!.logScreenView(screenName: screenName);

      debugPrint('✅ ANALYTICS [$timestamp]: screen_view logged successfully');
    } catch (e) {
      debugPrint('❌ ANALYTICS [$timestamp]: Failed to log screen_view: $e');
    }
  }
}
