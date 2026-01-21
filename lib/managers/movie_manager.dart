import 'package:flutter/foundation.dart';
import 'package:movie_watchlist_app/models/movie.dart';

class MovieManager extends ChangeNotifier {
  final List<Movie> _movies = [];

  // Initialize with mock data for testing UI
  void loadMockData() {
    _movies.clear();
    _movies.addAll([
      Movie(
        id: '1',
        title: 'The Shawshank Redemption',
        genres: ['Drama'],
        rating: 5,
        notes: 'A must-watch classic about hope and friendship',
        status: MovieStatus.watched,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Movie(
        id: '2',
        title: 'Dune: Part Two',
        genres: ['Sci-Fi', 'Action'],
        rating: null,
        notes: 'Looking forward to watching this epic sequel',
        status: MovieStatus.toWatch,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ]);
    notifyListeners();
  }

  // Get all movies
  List<Movie> getAllMovies() {
    return List.unmodifiable(_movies);
  }

  // Filter - Get movies by status
  List<Movie> getMoviesByStatus(MovieStatus status) {
    return _movies.where((movie) => movie.status == status).toList();
  }

  // Add a new movie
  void addMovie(Movie movie) {
    _movies.add(movie);
    notifyListeners();
  }

  // Update an existing movie
  void updateMovie(Movie movie) {
    final index = _movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
      notifyListeners();
    }
  }

  // Get movie count
  int getMovieCount() {
    return _movies.length;
  }

  // Get movie count by status
  int getMovieCountByStatus(MovieStatus status) {
    return _movies.where((movie) => movie.status == status).length;
  }

  // Delete a movie by ID
  void deleteMovie(String id) {
    _movies.removeWhere((movie) => movie.id == id);
    notifyListeners();
  }
}
