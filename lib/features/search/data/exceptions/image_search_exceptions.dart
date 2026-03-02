/// Exception for permission-related errors
class PermissionException implements Exception {
  final String message;
  final String? code;

  PermissionException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'PermissionException: $message${code != null ? ' ($code)' : ''}';
}

/// Exception for image picker/selection errors
class ImagePickerException implements Exception {
  final String message;
  final String? code;

  ImagePickerException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ImagePickerException: $message${code != null ? ' ($code)' : ''}';
}

/// Exception for Vision AI service errors
class VisionAIException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  VisionAIException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'VisionAIException: $message${code != null ? ' ($code)' : ''}';
}

/// Exception for image processing errors
class ImageProcessingException implements Exception {
  final String message;
  final String? code;

  ImageProcessingException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ImageProcessingException: $message${code != null ? ' ($code)' : ''}';
}

/// Exception for repository/data layer errors
class ImageSearchRepositoryException implements Exception {
  final String message;
  final String? code;

  ImageSearchRepositoryException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ImageSearchRepositoryException: $message${code != null ? ' ($code)' : ''}';
}
