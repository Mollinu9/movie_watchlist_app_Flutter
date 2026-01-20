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
        title: 'Inception',
        genres: ['Sci-Fi', 'Thriller'],
        rating: 5,
        notes: 'Mind-bending thriller by Christopher Nolan',
        status: MovieStatus.watched,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Movie(
        id: '3',
        title: 'The Dark Knight',
        genres: ['Action', 'Drama'],
        rating: 5,
        notes: 'Best Batman movie ever made',
        status: MovieStatus.watched,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Movie(
        id: '4',
        title: 'Dune: Part Two',
        genres: ['Sci-Fi', 'Action'],
        rating: null,
        notes: 'Looking forward to watching this epic sequel',
        status: MovieStatus.toWatch,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Movie(
        id: '5',
        title: 'Oppenheimer',
        genres: ['Drama', 'History'],
        rating: null,
        notes: 'Need to watch this biographical drama',
        status: MovieStatus.toWatch,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Movie(
        id: '6',
        title: 'Interstellar',
        genres: ['Sci-Fi', 'Drama'],
        rating: 4,
        notes: 'Amazing space exploration movie',
        status: MovieStatus.watched,
        imagePath: null,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
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

  // Get movie count
  int getMovieCount() {
    return _movies.length;
  }

  // Get movie count by status
  int getMovieCountByStatus(MovieStatus status) {
    return _movies.where((movie) => movie.status == status).length;
  }
}
