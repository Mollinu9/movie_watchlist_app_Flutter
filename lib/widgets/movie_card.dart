import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/models/movie.dart';

// ============================================================================
// Main MovieCard Widget
// ============================================================================

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
            // Poster image or placeholder
            Expanded(flex: 3, child: _buildMoviePoster(movie.imagePath)),
            // Movie information
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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
                    // Genre badges
                    _buildGenreBadges(context, movie.genres),

                    const Spacer(),
                    // Rating stars
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

  // ==========================================================================
  // Movie Poster Section
  // ==========================================================================

  Widget _buildMoviePoster(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      }
    }

    // Placeholder when no image
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie, size: 48, color: Colors.grey),
      ),
    );
  }

  // ==========================================================================
  // Genre Badges Section
  // ==========================================================================

  Widget _buildGenreBadges(
    BuildContext context,
    List<String> genres, {
    int maxGenres = 2,
  }) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      direction: Axis.horizontal,
      children: genres.take(maxGenres).map((genre) {
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
    );
  }

  // ==========================================================================
  // Rating Display Section
  // ==========================================================================

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
