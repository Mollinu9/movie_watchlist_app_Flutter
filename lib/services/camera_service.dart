import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Service for managing image capture and gallery selection
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Capture an image from the device camera
  /// Returns the image path on success, null on failure
  Future<String?> captureFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error capturing image from camera: $e');
      return null;
    }
  }

  /// Select an image from the device gallery
  /// Returns the image path on success, null on failure
  Future<String?> selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error selecting image from gallery: $e');
      return null;
    }
  }

  /// Show a dialog to let the user choose between camera and gallery
  /// Returns the selected image path, or null if cancelled or failed
  Future<String?> showImageSourceDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCameraOption(context),
              _buildGalleryOption(context),
            ],
          ),
          actions: [_buildCancelButton(context)],
        );
      },
    );
  }

  /// Build the camera option list tile
  Widget _buildCameraOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_alt),
      title: const Text('Camera'),
      onTap: () => _handleCameraSelection(context),
    );
  }

  /// Build the gallery option list tile
  Widget _buildGalleryOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.photo_library),
      title: const Text('Gallery'),
      onTap: () => _handleGallerySelection(context),
    );
  }

  /// Build the cancel button
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Cancel'),
    );
  }

  /// Handle camera selection
  Future<void> _handleCameraSelection(BuildContext context) async {
    Navigator.of(context).pop();
    final imagePath = await captureFromCamera();
    if (context.mounted) {
      if (imagePath == null) {
        _showErrorMessage(context, 'Failed to capture image from camera');
      } else {
        Navigator.of(context).pop(imagePath);
      }
    }
  }

  /// Handle gallery selection
  Future<void> _handleGallerySelection(BuildContext context) async {
    Navigator.of(context).pop();
    final imagePath = await selectFromGallery();
    if (context.mounted) {
      if (imagePath == null) {
        _showErrorMessage(context, 'Failed to select image from gallery');
      } else {
        Navigator.of(context).pop(imagePath);
      }
    }
  }

  /// Show error message via SnackBar
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
