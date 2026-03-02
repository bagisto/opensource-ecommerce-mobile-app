import 'dart:io';
import '../models/image_data_model.dart';
import '../models/image_recognition_response.dart';
import '../services/image_picker_service.dart';
import '../services/permission_service.dart';
import '../services/vision_ai_service.dart';
import '../exceptions/image_search_exceptions.dart';

/// Repository for image-based searching
/// Coordinates between: Permission Service, Image Picker Service, Vision AI Service
class ImageSearchRepository {
  final PermissionService permissionService;
  final ImagePickerService imagePickerService;
  final VisionAIService visionAIService;

  ImageSearchRepository({
    required this.permissionService,
    required this.imagePickerService,
    required this.visionAIService,
  });

  /// Capture image from camera WITHOUT processing
  /// Used for crop-enabled workflow
  Future<ImageDataModel> captureImageOnly() async {
    try {
      final hasPermission = await permissionService.requestCameraPermission();
      if (!hasPermission) {
        throw PermissionException(
          message: 'Camera permission not granted',
          code: 'camera_permission_denied',
        );
      }
      return await imagePickerService.pickFromCamera();
    } catch (e) {
      rethrow;
    }
  }

  /// Select image from gallery WITHOUT processing
  /// Used for crop-enabled workflow
  Future<ImageDataModel> selectImageOnly() async {
    try {
      final hasPermission = await permissionService.requestPhotoLibraryPermission();
      if (!hasPermission) {
        throw PermissionException(
          message: 'Photo library permission not granted',
          code: 'photo_permission_denied',
        );
      }
      return await imagePickerService.pickFromGallery();
    } catch (e) {
      rethrow;
    }
  }

  /// Pick image from camera and process with Vision AI
  Future<ImageRecognitionResponse> captureAndRecognizeImage({
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  }) async {
    try {
      // Request camera permission
      final hasPermission = await permissionService.requestCameraPermission();
      if (!hasPermission) {
        throw PermissionException(
          message: 'Camera permission not granted',
          code: 'camera_permission_denied',
        );
      }

      // Pick image from camera
      final imageData = await imagePickerService.pickFromCamera();

      // Process with Vision AI
      return await _recognizeImage(
        imageData,
        maxResults: maxResults,
        confidenceThreshold: confidenceThreshold,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Pick image from gallery and process with Vision AI
  Future<ImageRecognitionResponse> selectAndRecognizeImage({
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  }) async {
    try {
      // Request photo library permission
      final hasPermission = await permissionService.requestPhotoLibraryPermission();
      if (!hasPermission) {
        throw PermissionException(
          message: 'Photo library permission not granted',
          code: 'photo_permission_denied',
        );
      }

      // Pick image from gallery
      final imageData = await imagePickerService.pickFromGallery();

      // Process with Vision AI
      return await _recognizeImage(
        imageData,
        maxResults: maxResults,
        confidenceThreshold: confidenceThreshold,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Recognize image from file
  Future<ImageRecognitionResponse> recognizeImageFile(
    File imageFile, {
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  }) async {
    try {
      if (!imageFile.existsSync()) {
        throw ImageSearchRepositoryException(
          message: 'Image file does not exist',
          code: 'file_not_found',
        );
      }

      return await visionAIService.recognizeImage(
        imageFile,
        maxResults: maxResults,
        confidenceThreshold: confidenceThreshold,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Internal method to recognize image data
  Future<ImageRecognitionResponse> _recognizeImage(
    ImageDataModel imageData, {
    required int maxResults,
    required double confidenceThreshold,
  }) async {
    try {
      if (imageData.imageFile == null) {
        throw ImageSearchRepositoryException(
          message: 'Image file not available',
          code: 'no_image_file',
        );
      }

      return await visionAIService.recognizeImage(
        imageData.imageFile!,
        maxResults: maxResults,
        confidenceThreshold: confidenceThreshold,
      );
    } on ImageRecognitionResponse {
      rethrow;
    } catch (e) {
      throw ImageSearchRepositoryException(
        message: 'Failed to recognize image: ${e.toString()}',
        code: 'recognition_failed',
      );
    }
  }

  /// Clean up resources
  Future<void> dispose() async {
    await visionAIService.dispose();
  }
}
