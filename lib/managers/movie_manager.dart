import 'package:flutter/foundation.dart';
import 'package:movie_watchlist_app/models/movie.dart';
import 'package:movie_watchlist_app/services/storage_service.dart';

class MovieManager extends ChangeNotifier {
  final List<Movie> _movies = [];
  bool _isInitialized = false;

  /// Initialize MovieManager by loading movies from storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final loadedMovies = await StorageService.instance.loadMovies();
      _movies.clear();
      _movies.addAll(loadedMovies);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, start with empty list
      debugPrint('Error loading movies: $e');
      _isInitialized = true;
    }
  }

  // Get all movies
  List<Movie> getAllMovies() {
    return List.unmodifiable(_movies);
  }

  // Filter - Get movies by status
  List<Movie> getMoviesByStatus(MovieStatus status) {
    return _movies.where((movie) => movie.status == status).toList();
  }

  // Get movie count
  int getMovieCount() {
    return _movies.length;
  }

  // Get movie count by status
  int getMovieCountByStatus(MovieStatus status) {
    return _movies.where((movie) => movie.status == status).length;
  }

  // Add a new movie
  Future<void> addMovie(Movie movie) async {
    _movies.add(movie);
    await _saveMovies();
    notifyListeners();
  }

  // Update an existing movie
  Future<void> updateMovie(Movie movie) async {
    final index = _movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
      await _saveMovies();
      notifyListeners();
    }
  }

  // Private helper method to save movies to storage
  Future<void> _saveMovies() async {
    try {
      await StorageService.instance.saveMovies(_movies);
    } catch (e) {
      debugPrint('Error saving movies: $e');
    }
  }

  // Delete a movie by ID
  Future<void> deleteMovie(String id) async {
    _movies.removeWhere((movie) => movie.id == id);
    await _saveMovies();
    notifyListeners();
  }
}
