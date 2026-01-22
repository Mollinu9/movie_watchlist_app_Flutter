import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/models/movie.dart';
import 'package:movie_watchlist_app/managers/movie_manager.dart';
import 'package:movie_watchlist_app/screens/movie_forms_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPosterImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 12),
                  _buildGenreChips(context),
                  const SizedBox(height: 16),
                  _buildRatingDisplay(),
                  const SizedBox(height: 16),
                  _buildStatusBadge(context),
                  const SizedBox(height: 16),
                  _buildDateAdded(),
                  const SizedBox(height: 16),
                  _buildNotesSection(),
                  const SizedBox(height: 24),
                  _buildEditButton(context),
                  const SizedBox(height: 12),
                  _buildDeleteButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    if (movie.imagePath != null && movie.imagePath!.isNotEmpty) {
      final file = File(movie.imagePath!);
      if (file.existsSync()) {
        return SizedBox(
          width: double.infinity,
          height: 400,
          child: Image.file(file, fit: BoxFit.cover),
        );
      }
    }

    return Container(
      width: double.infinity,
      height: 400,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      movie.title,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGenreChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: movie.genres.map((genre) {
        return Chip(
          label: Text(genre),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingDisplay() {
    return Row(
      children: [
        const Text(
          'Rating: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        if (movie.rating != null) ...[
          ...List.generate(5, (index) {
            return Icon(
              index < movie.rating! ? Icons.star : Icons.star_border,
              size: 24,
              color: Colors.amber,
            );
          }),
          const SizedBox(width: 8),
          Text('${movie.rating}/5', style: const TextStyle(fontSize: 16)),
        ] else
          const Text(
            'Not rated',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Status: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: movie.status == MovieStatus.watched
                ? Colors.green[100]
                : Colors.blue[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            movie.status.displayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: movie.status == MovieStatus.watched
                  ? Colors.green[900]
                  : Colors.blue[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateAdded() {
    final formattedDate = DateFormat('MMM dd, yyyy').format(movie.createdAt);
    return Row(
      children: [
        const Text(
          'Date Added: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(formattedDate, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            movie.notes != null && movie.notes!.isNotEmpty
                ? movie.notes!
                : 'No notes',
            style: TextStyle(
              fontSize: 14,
              color: movie.notes != null && movie.notes!.isNotEmpty
                  ? Colors.black87
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MovieFormsScreen(movie: movie),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showDeleteConfirmationDialog(context),
        icon: const Icon(Icons.delete, color: Colors.red),
        label: const Text('Delete', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Movie'),
          content: Text(
            'Are you sure you want to delete "${movie.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await _deleteMovie(context);
    }
  }

  Future<void> _deleteMovie(BuildContext context) async {
    final movieManager = Provider.of<MovieManager>(context, listen: false);
    await movieManager.deleteMovie(movie.id);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
