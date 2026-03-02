import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../models/image_data_model.dart';
import '../exceptions/image_search_exceptions.dart';

/// Service for picking and optimizing images
class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
  static const int maxFileSizeKB = 500; // 500 KB max

  /// Pick image from camera
  Future<ImageDataModel> pickFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile == null) {
        throw ImagePickerException(
          message: 'Camera image selection cancelled',
          code: 'user_cancelled',
        );
      }

      final imageData = await _processPickedImage(
        pickedFile.path,
        isFromCamera: true,
      );

      return imageData;
    } on ImagePickerException {
      rethrow;
    } catch (e) {
      throw ImagePickerException(
        message: 'Failed to pick camera image: ${e.toString()}',
        code: 'camera_error',
      );
    }
  }

  /// Pick image from gallery
  Future<ImageDataModel> pickFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        throw ImagePickerException(
          message: 'Gallery image selection cancelled',
          code: 'user_cancelled',
        );
      }

      final imageData = await _processPickedImage(
        pickedFile.path,
        isFromCamera: false,
      );

      return imageData;
    } on ImagePickerException {
      rethrow;
    } catch (e) {
      throw ImagePickerException(
        message: 'Failed to pick gallery image: ${e.toString()}',
        code: 'gallery_error',
      );
    }
  }

  /// Process and optimize picked image
  Future<ImageDataModel> _processPickedImage(
    String imagePath, {
    required bool isFromCamera,
  }) async {
    try {
      final originalFile = File(imagePath);
      if (!originalFile.existsSync()) {
        throw ImagePickerException(
          message: 'Image file does not exist',
          code: 'file_not_found',
        );
      }

      // Optimize the image
      final optimizedFile = await optimizeImage(originalFile);

      final fileSize = optimizedFile.lengthSync();

      return ImageDataModel(
        imagePath: optimizedFile.path,
        imageFile: optimizedFile,
        fileSize: fileSize,
        mimeType: 'image/jpeg',
        capturedAt: DateTime.now(),
        isFromCamera: isFromCamera,
      );
    } catch (e) {
      throw ImagePickerException(
        message: 'Failed to process image: ${e.toString()}',
        code: 'processing_error',
      );
    }
  }

  /// Optimize image for API upload
  Future<File> optimizeImage(File imageFile) async {
    try {
      // Read image
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw ImageProcessingException(
          message: 'Failed to decode image',
          code: 'decode_error',
        );
      }

      // Resize if necessary
      if (image.width > maxImageWidth || image.height > maxImageHeight) {
        image = img.copyResize(
          image,
          width: maxImageWidth,
          height: maxImageHeight,
          maintainAspect: true,
        );
      }

      // Encode to JPEG with quality adjustment
      Uint8List optimizedBytes = Uint8List.fromList(
        img.encodeJpg(image, quality: 85),
      );

      // If still too large, reduce quality further
      int attempts = 0;
      int currentQuality = 85;
      while (optimizedBytes.lengthInBytes > maxFileSizeKB * 1024 && attempts < 5) {
        currentQuality = (currentQuality * 0.9).toInt();
        optimizedBytes = Uint8List.fromList(
          img.encodeJpg(image, quality: currentQuality.clamp(20, 100)),
        );
        attempts++;
      }

      // Save optimized image to temporary file
      final tempDir = Directory.systemTemp;
      final optimizedFile = File(
        '${tempDir.path}/optimized_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await optimizedFile.writeAsBytes(optimizedBytes);

      debugPrint(
        'Image optimized: ${imageBytes.length} bytes → ${optimizedBytes.lengthInBytes} bytes (quality: $currentQuality)',
      );

      return optimizedFile;
    } catch (e) {
      throw ImageProcessingException(
        message: 'Failed to optimize image: ${e.toString()}',
        code: 'optimization_error',
      );
    }
  }

  /// Get image dimensions
  Future<(int width, int height)?> getImageDimensions(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        return null;
      }

      return (image.width, image.height);
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
      return null;
    }
  }

  /// Delete optimized image file
  Future<void> deleteOptimizedImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
