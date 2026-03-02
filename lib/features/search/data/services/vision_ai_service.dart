import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/image_recognition_response.dart';
import '../models/label_model.dart';
import '../exceptions/image_search_exceptions.dart';

/// Abstract base class for Vision AI services
abstract class VisionAIService {
  /// Recognize labels/objects in an image file
  Future<ImageRecognitionResponse> recognizeImage(File imageFile, {
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  });

  /// Dispose any resources
  Future<void> dispose();
}

/// Google Cloud Vision API implementation
class GoogleVisionAIService implements VisionAIService {
  static const String _visionApiUrl = 'https://vision.googleapis.com/v1/images:annotate';
  
  final String apiKey;
  final int maxResults;
  final double confidenceThreshold;

  GoogleVisionAIService({
    required this.apiKey,
    this.maxResults = 10,
    this.confidenceThreshold = 0.5,
  });

  @override
  Future<ImageRecognitionResponse> recognizeImage(
    File imageFile, {
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  }) async {
    try {
      if (!imageFile.existsSync()) {
        throw VisionAIException(
          message: 'Image file does not exist',
          code: 'file_not_found',
        );
      }

      // Read image file and convert to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = _bytesToBase64(imageBytes);

      // Prepare request body for Google Vision API
      final requestBody = {
        'requests': [
          {
            'image': {
              'content': base64Image,
            },
            'features': [
              {
                'type': 'LABEL_DETECTION',
                'maxResults': maxResults,
              },
              {
                'type': 'OBJECT_LOCALIZATION',
                'maxResults': 5,
              },
            ],
          },
        ],
      };

      // Make API request
      final response = await _makeApiRequest(requestBody);

      // Parse response
      return _parseVisionResponse(response);
    } on VisionAIException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: 'VisionAI Error: $e');
      throw VisionAIException(
        message: 'Failed to recognize image: ${e.toString()}',
        code: 'recognition_failed',
        originalError: e,
      );
    }
  }

  /// Make HTTP request to Google Vision API
  Future<Map<String, dynamic>> _makeApiRequest(Map<String, dynamic> requestBody) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('$_visionApiUrl?key=$apiKey'),
      );

      request.headers.contentType = ContentType.json;
      request.write(_jsonEncode(requestBody));

      final response = await request.close();
      final responseBytes = await response.toList();
      final responseBody = String.fromCharCodes(responseBytes.expand((x) => x));

      if (response.statusCode != 200) {
        throw VisionAIException(
          message: 'Vision API returned status code ${response.statusCode}',
          code: 'api_error',
        );
      }

      final jsonResponse = _jsonDecode(responseBody);
      httpClient.close();

      return jsonResponse as Map<String, dynamic>;
    } catch (e) {
      throw VisionAIException(
        message: 'API request failed: ${e.toString()}',
        code: 'api_request_failed',
        originalError: e,
      );
    }
  }

  /// Parse Vision API response
  ImageRecognitionResponse _parseVisionResponse(Map<String, dynamic> response) {
    try {
      final responses = response['responses'] as List<dynamic>?;
      if (responses == null || responses.isEmpty) {
        return ImageRecognitionResponse(
          labels: [],
          processedAt: DateTime.now(),
        );
      }

      final firstResponse = responses[0] as Map<String, dynamic>;

      // Extract labels from label detection
      final labels = <Map<String, dynamic>>[];
      if (firstResponse.containsKey('labelAnnotations')) {
        final labelAnnotations = firstResponse['labelAnnotations'] as List<dynamic>;
        labels.addAll(labelAnnotations.map((e) => e as Map<String, dynamic>));
      }

      // Extract objects from object localization
      if (firstResponse.containsKey('localizedObjectAnnotations')) {
        final objectAnnotations = firstResponse['localizedObjectAnnotations'] as List<dynamic>;
        labels.addAll(objectAnnotations.map((e) => e as Map<String, dynamic>));
      }

      return ImageRecognitionResponse(
        labels: labels
            .map((label) => _parseLabelFromJson(label))
            .where((label) => label.confidence >= confidenceThreshold)
            .toList(),
        processedAt: DateTime.now(),
        rawResponse: _jsonEncode(response),
      );
    } catch (e) {
      throw VisionAIException(
        message: 'Failed to parse Vision API response: ${e.toString()}',
        code: 'parse_error',
        originalError: e,
      );
    }
  }

  /// Parse individual label from JSON
  LabelModel _parseLabelFromJson(Map<String, dynamic> json) {
    return LabelModel(
      id: json['mid'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['description'] as String? ?? '',
      confidence: (json['score'] as num? ?? 0).toDouble(),
      description: json['description'] as String?,
    );
  }

  /// Convert bytes to base64
  String _bytesToBase64(List<int> bytes) {
    return base64Encode(bytes);
  }

  /// JSON encode helper
  String _jsonEncode(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  /// JSON decode helper
  dynamic _jsonDecode(String data) {
    return jsonDecode(data);
  }

  @override
  Future<void> dispose() async {
    // Cleanup if needed
  }
}

/// Mock implementation for testing/development
class MockVisionAIService implements VisionAIService {
  static const List<Map<String, dynamic>> _mockLabels = [
    {
      'id': 'shoe_1',
      'name': 'Shoe',
      'confidence': 0.95,
      'description': 'Athletic shoe',
    },
    {
      'id': 'casual_1',
      'name': 'Casual Wear',
      'confidence': 0.87,
      'description': 'Casual clothing',
    },
    {
      'id': 'sports_1',
      'name': 'Sport Equipment',
      'confidence': 0.78,
      'description': 'Sports related item',
    },
    {
      'id': 'fashion_1',
      'name': 'Fashion',
      'confidence': 0.72,
      'description': 'Fashion item',
    },
    {
      'id': 'footwear_1',
      'name': 'Footwear',
      'confidence': 0.88,
      'description': 'Footwear category',
    },
  ];

  @override
  Future<ImageRecognitionResponse> recognizeImage(
    File imageFile, {
    int maxResults = 10,
    double confidenceThreshold = 0.5,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock labels (filtered by confidence)
    final filteredLabels = _mockLabels
        .where((label) => (label['confidence'] as num).toDouble() >= confidenceThreshold)
        .take(maxResults)
        .toList();

    return ImageRecognitionResponse(
      labels: filteredLabels
          .map((label) => LabelModel.fromJson(label))
          .toList(),
      processedAt: DateTime.now(),
    );
  }

  @override
  Future<void> dispose() async {
    // No-op for mock service
  }
}
