import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for managing image capture and gallery selection
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Capture an image from the device camera
  /// Returns the permanent image path on success, null on failure
  Future<String?> captureFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        return await _saveImagePermanently(image);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Select an image from the device gallery
  /// Returns the permanent image path on success, null on failure
  Future<String?> selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return await _saveImagePermanently(image);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save the picked image to permanent app storage
  /// Returns the permanent file path
  Future<String?> _saveImagePermanently(XFile image) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDocDir.path}/movie_images');

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(image.path);
      final String fileName = 'movie_$timestamp$extension';
      final String permanentPath = '${imagesDir.path}/$fileName';

      final File sourceFile = File(image.path);
      await sourceFile.copy(permanentPath);

      return permanentPath;
    } catch (e) {
      return null;
    }
  }
}
