import 'dart:io';
import 'package:equatable/equatable.dart';

/// Model representing the image data for search
class ImageDataModel extends Equatable {
  final String imagePath;
  final File? imageFile;
  final int? fileSize; // in bytes
  final String? mimeType;
  final DateTime? capturedAt;
  final bool isFromCamera;

  const ImageDataModel({
    required this.imagePath,
    this.imageFile,
    this.fileSize,
    this.mimeType,
    this.capturedAt,
    required this.isFromCamera,
  });

  /// Copy with method for updating fields
  ImageDataModel copyWith({
    String? imagePath,
    File? imageFile,
    int? fileSize,
    String? mimeType,
    DateTime? capturedAt,
    bool? isFromCamera,
  }) {
    return ImageDataModel(
      imagePath: imagePath ?? this.imagePath,
      imageFile: imageFile ?? this.imageFile,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      capturedAt: capturedAt ?? this.capturedAt,
      isFromCamera: isFromCamera ?? this.isFromCamera,
    );
  }

  /// Check if image file exists
  bool get exists => File(imagePath).existsSync();

  /// Get file size in KB
  double? get fileSizeKB => fileSize != null ? fileSize! / 1024 : null;

  /// Get file size in MB
  double? get fileSizeMB => fileSizeKB != null ? fileSizeKB! / 1024 : null;

  @override
  List<Object?> get props =>
      [imagePath, imageFile, fileSize, mimeType, capturedAt, isFromCamera];
}
