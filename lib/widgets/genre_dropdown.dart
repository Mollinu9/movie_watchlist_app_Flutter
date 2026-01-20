import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/utils/constants.dart';

class GenreDropdown extends StatefulWidget {
  final List<String> selectedGenres;
  final ValueChanged<List<String>> onGenresChanged;

  const GenreDropdown({
    super.key,
    required this.selectedGenres,
    required this.onGenresChanged,
  });

  @override
  State<GenreDropdown> createState() => _GenreDropdownState();
}

class _GenreDropdownState extends State<GenreDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownButton(),
        if (widget.selectedGenres.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildGenreChips(),
        ],
      ],
    );
  }

  // Dropdown button to open genre selection dialog
  Widget _buildDropdownButton() {
    return InkWell(
      onTap: _showGenreDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.selectedGenres.isEmpty
                    ? 'Select genres'
                    : widget.selectedGenres.join(', '),
                style: TextStyle(
                  fontSize: 16,
                  color: widget.selectedGenres.isEmpty
                      ? Colors.grey[600]
                      : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // Display selected genres as removable chips
  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.selectedGenres.map((genre) {
        return Chip(
          label: Text(genre),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () => _removeGenre(genre),
        );
      }).toList(),
    );
  }

  // Show genre selection dialog
  void _showGenreDialog() {
    final tempSelectedGenres = List<String>.from(widget.selectedGenres);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Genres'),
              content: _buildGenreList(tempSelectedGenres, setDialogState),
              actions: _buildDialogActions(dialogContext, tempSelectedGenres),
            );
          },
        );
      },
    );
  }

  // List of genres with checkboxes
  Widget _buildGenreList(List<String> tempGenres, StateSetter setDialogState) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: AppConstants.genres.length,
        itemBuilder: (context, index) {
          final genre = AppConstants.genres[index];
          final isSelected = tempGenres.contains(genre);

          return CheckboxListTile(
            title: Text(genre),
            value: isSelected,
            onChanged: (bool? value) {
              setDialogState(() {
                if (value == true) {
                  tempGenres.add(genre);
                } else {
                  tempGenres.remove(genre);
                }
              });
            },
          );
        },
      ),
    );
  }

  // Dialog action buttons
  List<Widget> _buildDialogActions(
    BuildContext dialogContext,
    List<String> tempGenres,
  ) {
    return [
      TextButton(
        onPressed: () => Navigator.of(dialogContext).pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          widget.onGenresChanged(tempGenres);
          Navigator.of(dialogContext).pop();
        },
        child: const Text('OK'),
      ),
    ];
  }

  // Remove a genre from selection
  void _removeGenre(String genre) {
    final updatedGenres = List<String>.from(widget.selectedGenres);
    updatedGenres.remove(genre);
    widget.onGenresChanged(updatedGenres);
  }
}
