import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildMoviePoster(movie.imagePath)),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(child: _buildGenreBadges(context, movie.genres)),
                    _buildRatingDisplay(movie.rating),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Movie poster image or placeholder
  Widget _buildMoviePoster(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      }
    }

    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie, size: 48, color: Colors.grey),
      ),
    );
  }

  // Genre badges (all genres displayed with scrolling)
  Widget _buildGenreBadges(BuildContext context, List<String> genres) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: genres.map((genre) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              genre,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Star rating display
  Widget _buildRatingDisplay(int? rating) {
    if (rating == null) {
      return const Text(
        'Not rated',
        style: TextStyle(fontSize: 11, color: Colors.grey),
      );
    }

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.amber,
        );
      }),
    );
  }
}
