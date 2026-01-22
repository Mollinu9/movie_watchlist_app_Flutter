import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_watchlist_app/models/movie.dart';

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
}
