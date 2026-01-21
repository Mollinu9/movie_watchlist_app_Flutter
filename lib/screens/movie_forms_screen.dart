import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:movie_watchlist_app/managers/movie_manager.dart';
import 'package:movie_watchlist_app/models/movie.dart';
import 'package:movie_watchlist_app/widgets/genre_dropdown.dart';
import 'package:movie_watchlist_app/widgets/rating_selector.dart';

class MovieFormsScreen extends StatefulWidget {
  const MovieFormsScreen({super.key});

  @override
  State<MovieFormsScreen> createState() => _MovieFormsScreenState();
}

class _MovieFormsScreenState extends State<MovieFormsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> _selectedGenres = [];
  int? _selectedRating;
  MovieStatus _selectedStatus = MovieStatus.toWatch;
  String? _imagePath;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // AppBar with back button
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Add Movie'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // Main body with form
  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildGenreSection(),
            const SizedBox(height: 16),
            _buildRatingSection(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 16),
            _buildStatusSection(),
            const SizedBox(height: 16),
            _buildImageSection(),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Title input field with validation
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Movie Title *',
        hintText: 'Enter movie title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Movie title is required';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  // Genre selection section
  Widget _buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genres',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GenreDropdown(
          selectedGenres: _selectedGenres,
          onGenresChanged: (genres) {
            setState(() {
              _selectedGenres = genres;
            });
          },
        ),
      ],
    );
  }

  // Rating selection section
  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        RatingSelector(
          currentRating: _selectedRating,
          onRatingChanged: (rating) {
            setState(() {
              _selectedRating = rating;
            });
          },
        ),
      ],
    );
  }

  // Notes input field
  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes',
        hintText: 'Add your notes about this movie',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textInputAction: TextInputAction.newline,
    );
  }

  // Status selection section
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildStatusRadioButtons(),
      ],
    );
  }

  // Radio buttons for status
  Widget _buildStatusRadioButtons() {
    return Column(
      children: [
        _buildRadioOption(MovieStatus.toWatch, 'To Watch'),
        _buildRadioOption(MovieStatus.watched, 'Watched'),
      ],
    );
  }

  // Individual radio button option
  Widget _buildRadioOption(MovieStatus value, String label) {
    final isSelected = _selectedStatus == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }

  // Image picker section
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Movie Poster',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildImageContainer(),
      ],
    );
  }

  // Image container with placeholder or image
  Widget _buildImageContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: _imagePath == null
          ? _buildImagePlaceholder()
          : Image.network(_imagePath!, fit: BoxFit.cover),
    );
  }

  // Placeholder when no image selected
  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text('No image selected', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _handleImagePicker,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Photo'),
        ),
      ],
    );
  }

  // Save button
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _saveMovie,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Save Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Handle image picker button tap
  void _handleImagePicker() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image picker coming soon!')));
  }

  // Save movie to manager
  void _saveMovie() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one genre'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final movie = Movie(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      genres: _selectedGenres,
      rating: _selectedRating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: _selectedStatus,
      imagePath: _imagePath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final movieManager = Provider.of<MovieManager>(context, listen: false);
    movieManager.addMovie(movie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title} added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}
