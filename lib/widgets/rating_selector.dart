import 'package:flutter/material.dart';

class RatingSelector extends StatelessWidget {
  final int? currentRating;
  final ValueChanged<int?> onRatingChanged;

  const RatingSelector({
    super.key,
    required this.currentRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildStarRow(), _buildRatingText()],
    );
  }

  // Row of star buttons with optional clear button
  Widget _buildStarRow() {
    return Row(
      children: [
        ..._buildStars(),
        if (currentRating != null) _buildClearButton(),
      ],
    );
  }

  // Generate 5 star buttons
  List<Widget> _buildStars() {
    return List.generate(5, (index) {
      final starValue = index + 1;
      final isSelected = currentRating != null && starValue <= currentRating!;

      return IconButton(
        icon: Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: isSelected ? Colors.amber : Colors.grey,
          size: 32,
        ),
        onPressed: () => _handleStarTap(starValue),
      );
    });
  }

  // Clear rating button
  Widget _buildClearButton() {
    return IconButton(
      icon: const Icon(Icons.clear, size: 24),
      onPressed: () => onRatingChanged(null),
      tooltip: 'Clear rating',
    );
  }

  // Display current rating text
  Widget _buildRatingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        currentRating != null
            ? 'Rating: $currentRating/5'
            : 'No rating selected',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
    );
  }

  // Handle star button tap
  void _handleStarTap(int starValue) {
    if (currentRating == starValue) {
      onRatingChanged(null);
    } else {
      onRatingChanged(starValue);
    }
  }
}
