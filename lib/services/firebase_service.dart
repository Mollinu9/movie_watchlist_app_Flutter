import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlist_app/models/movie.dart';

class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  /// Initialize Firebase Analytics
  static Future<void> initialize() async {
    if (_initialized) return;

    _analytics = FirebaseAnalytics.instance;
    _initialized = true;
    debugPrint('📊 ANALYTICS: Firebase Analytics initialized successfully');
  }

  /// Log when a movie is added
  static Future<void> logMovieAdded(String genre, MovieStatus status) async {
    if (!_initialized || _analytics == null) {
      debugPrint('⚠️ ANALYTICS: Not initialized, skipping movie_added event');
      return;
    }

    debugPrint(
      '📊 ANALYTICS: Logging movie_added event - genre: $genre, status: ${status.name}',
    );
    await _analytics!.logEvent(
      name: 'movie_added',
      parameters: {'genre': genre, 'status': status.name},
    );
    debugPrint('✅ ANALYTICS: movie_added event sent to Firebase');
  }

  /// Log when a movie is updated
  static Future<void> logMovieUpdated() async {
    if (!_initialized || _analytics == null) {
      debugPrint('⚠️ ANALYTICS: Not initialized, skipping movie_updated event');
      return;
    }

    debugPrint('📊 ANALYTICS: Logging movie_updated event');
    await _analytics!.logEvent(name: 'movie_updated');
    debugPrint('✅ ANALYTICS: movie_updated event sent to Firebase');
  }

  /// Log when a movie is deleted
  static Future<void> logMovieDeleted() async {
    if (!_initialized || _analytics == null) {
      debugPrint('⚠️ ANALYTICS: Not initialized, skipping movie_deleted event');
      return;
    }

    debugPrint('📊 ANALYTICS: Logging movie_deleted event');
    await _analytics!.logEvent(name: 'movie_deleted');
    debugPrint('✅ ANALYTICS: movie_deleted event sent to Firebase');
  }

  /// Log when theme is changed
  static Future<void> logThemeChanged(bool isDarkMode) async {
    if (!_initialized || _analytics == null) {
      debugPrint('⚠️ ANALYTICS: Not initialized, skipping theme_changed event');
      return;
    }

    debugPrint(
      '📊 ANALYTICS: Logging theme_changed event - theme: ${isDarkMode ? 'dark' : 'light'}',
    );
    await _analytics!.logEvent(
      name: 'theme_changed',
      parameters: {'theme': isDarkMode ? 'dark' : 'light'},
    );
    debugPrint('✅ ANALYTICS: theme_changed event sent to Firebase');
  }
}
