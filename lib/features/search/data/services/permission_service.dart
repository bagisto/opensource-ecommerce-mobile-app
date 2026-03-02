import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../exceptions/image_search_exceptions.dart';

/// Service for handling permissions
class PermissionService {
  /// Check and request camera permission
  Future<bool> requestCameraPermission() async {
    try {
      // First check current status
      final currentStatus = await Permission.camera.status;
      debugPrint('Current camera permission status: $currentStatus');
      
      // If already granted, return true
      if (currentStatus.isGranted) {
        return true;
      }
      
      // If permanently denied, guide user to settings
      if (currentStatus.isPermanentlyDenied) {
        await openAppSettings();
        throw PermissionException(
          message: 'Camera permission permanently denied. Please enable in Settings > Privacy > Camera.',
          code: 'camera_permanently_denied',
        );
      }
      
      // Request permission
      final status = await Permission.camera.request();
      debugPrint('Camera permission request result: $status');

      if (status.isGranted) {
        return true;
      }
      
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        throw PermissionException(
          message: 'Camera permission permanently denied. Please enable in Settings > Privacy > Camera.',
          code: 'camera_permanently_denied',
        );
      }

      if (status.isDenied) {
        throw PermissionException(
          message: 'Camera permission denied. Please allow camera access to use image search.',
          code: 'camera_denied',
        );
      }
      
      if (status.isRestricted) {
        throw PermissionException(
          message: 'Camera access is restricted on this device.',
          code: 'camera_restricted',
        );
      }

      return status.isGranted;
    } on PermissionException {
      rethrow;
    } catch (e) {
      debugPrint('Error requesting camera permission: $e');
      throw PermissionException(
        message: 'Failed to request camera permission: ${e.toString()}',
        code: 'camera_permission_error',
      );
    }
  }

  /// Check and request photo library/gallery permission
  Future<bool> requestPhotoLibraryPermission() async {
    try {
      // First check current status
      final currentStatus = await Permission.photos.status;
      debugPrint('Current photos permission status: $currentStatus');
      
      // If already granted, return true
      if (currentStatus.isGranted) {
        return true;
      }
      
      // If permanently denied, guide user to settings
      if (currentStatus.isPermanentlyDenied) {
        await openAppSettings();
        throw PermissionException(
          message: 'Photo library permission permanently denied. Please enable in Settings > Privacy > Photos.',
          code: 'photos_permanently_denied',
        );
      }
      
      // Request permission
      final status = await Permission.photos.request();
      debugPrint('Photos permission request result: $status');

      if (status.isGranted) {
        return true;
      }
      
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        throw PermissionException(
          message: 'Photo library permission permanently denied. Please enable in Settings > Privacy > Photos.',
          code: 'photos_permanently_denied',
        );
      }

      if (status.isDenied) {
        throw PermissionException(
          message: 'Photo library permission denied. Please allow photo access to select images.',
          code: 'photos_denied',
        );
      }
      
      if (status.isRestricted) {
        throw PermissionException(
          message: 'Photo library access is restricted on this device.',
          code: 'photos_restricted',
        );
      }

      return status.isGranted;
    } on PermissionException {
      rethrow;
    } catch (e) {
      debugPrint('Error requesting photo library permission: $e');
      throw PermissionException(
        message: 'Failed to request photo library permission: ${e.toString()}',
        code: 'photos_permission_error',
      );
    }
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('Error checking camera permission: $e');
      return false;
    }
  }

  /// Check if photo library permission is granted
  Future<bool> hasPhotoLibraryPermission() async {
    try {
      final status = await Permission.photos.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('Error checking photo library permission: $e');
      return false;
    }
  }

  /// Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    try {
      final statuses = await permissions.request();
      return statuses;
    } catch (e) {
      debugPrint('Error requesting multiple permissions: $e');
      rethrow;
    }
  }

  /// Get permission status description
  String getPermissionStatusDescription(PermissionStatus status) {
    if (status.isGranted) {
      return 'Permission granted';
    } else if (status.isDenied) {
      return 'Permission denied';
    } else if (status.isPermanentlyDenied) {
      return 'Permission permanently denied. Open app settings to enable.';
    } else if (status.isRestricted) {
      return 'Permission restricted by system';
    } else if (status.isProvisional) {
      return 'Permission provisional (iOS only)';
    }
    return 'Unknown permission status';
  }

  /// Open app settings
  static Future<bool> openAppSettingsDialog() {
    return openAppSettings();
  }
}
