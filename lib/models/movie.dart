import 'movie_status.dart';

class Movie {
  final String id;
  final String title;
  final List<String> genres;
  final int? rating;
  final String? notes;
  final MovieStatus status;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Movie({
    required this.id,
    required this.title,
    required this.genres,
    this.rating,
    this.notes,
    required this.status,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genres': genres,
      'rating': rating,
      'notes': notes,
      'status': status.name,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      genres: List<String>.from(json['genres'] as List),
      rating: json['rating'] as int?,
      notes: json['notes'] as String?,
      status: MovieStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

