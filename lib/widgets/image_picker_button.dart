import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/services/camera_service.dart';

/// A reusable widget for selecting images from camera or gallery
class ImagePickerButton extends StatelessWidget {
  final String? imagePath;
  final Function(String?) onImageSelected;
  final String buttonText;
  final bool showPreview;

  const ImagePickerButton({
    super.key,
    this.imagePath,
    required this.onImageSelected,
    this.buttonText = 'Add Photo',
    this.showPreview = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPreview && imagePath != null) ...[
          _buildImagePreview(),
          const SizedBox(height: 12),
        ],
        _buildPickerButton(context),
      ],
    );
  }

  /// Build the image preview section
  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        ),
      ),
    );
  }

  /// Build error placeholder when image fails to load
  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Build the picker button
  Widget _buildPickerButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleButtonPress(context),
      icon: Icon(imagePath == null ? Icons.add_photo_alternate : Icons.edit),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Handle button press - show image source dialog
  Future<void> _handleButtonPress(BuildContext context) async {
    final selectedImagePath = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => _handleCameraSelection(context),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => _handleGallerySelection(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedImagePath != null) {
      onImageSelected(selectedImagePath);
    }
  }

  /// Handle camera selection
  Future<void> _handleCameraSelection(BuildContext context) async {
    final cameraService = CameraService();
    final imagePath = await cameraService.captureFromCamera();
    if (context.mounted) {
      if (imagePath == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not available. Try using Gallery instead.'),
          ),
        );
      } else {
        Navigator.of(context).pop(imagePath);
      }
    }
  }

  /// Handle gallery selection
  Future<void> _handleGallerySelection(BuildContext context) async {
    final cameraService = CameraService();
    final imagePath = await cameraService.selectFromGallery();
    if (context.mounted) {
      if (imagePath == null) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop(imagePath);
      }
    }
  }
}
