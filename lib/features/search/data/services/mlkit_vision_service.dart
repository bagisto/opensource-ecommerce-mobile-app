import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../models/image_recognition_response.dart';
import '../models/label_model.dart';
import '../exceptions/image_search_exceptions.dart';
import 'vision_ai_service.dart';

/// On-device ML Kit implementation using a **custom MobileNet V2 model**
/// trained on ImageNet (1000 classes).
///
/// This model can detect specific objects like:
///   keyboard, mouse, cup, bottle, monitor, laptop, headphone, etc.
///
/// Strategy:
///  1. Run custom MobileNet V2 labeler on the full image
///  2. Run ML Kit Object Detection to find individual objects
///  3. Crop each detected object and re-label with the custom model
///  4. Merge and deduplicate results
///
/// Works fully offline — no API key required.
class MLKitVisionService implements VisionAIService {
  static const String _modelAssetPath = 'assets/ml/mobilenet_v2.tflite';

  /// Cached path to the model file on the device filesystem.
  String? _localModelPath;

  MLKitVisionService();

  /// Copy the bundled TFLite model asset to the device filesystem
  /// so ML Kit can load it via file path.
  Future<String> _ensureModelFile() async {
    if (_localModelPath != null && File(_localModelPath!).existsSync()) {
      return _localModelPath!;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/mobilenet_v2.tflite');

    if (!modelFile.existsSync()) {
      debugPrint('Copying MobileNet V2 model to device filesystem...');
      final data = await rootBundle.load(_modelAssetPath);
      await modelFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      debugPrint('Model copied to: ${modelFile.path}');
    }

    _localModelPath = modelFile.path;
    return _localModelPath!;
  }

  /// Create a labeler that uses our custom MobileNet V2 model.
  Future<ImageLabeler> _createCustomLabeler({
    double confidenceThreshold = 0.1,
    int maxCount = 20,
  }) async {
    final modelPath = await _ensureModelFile();
    return ImageLabeler(
      options: LocalLabelerOptions(
        modelPath: modelPath,
        confidenceThreshold: confidenceThreshold,
        maxCount: maxCount,
      ),
    );
  }

  @override
  Future<ImageRecognitionResponse> recognizeImage(
    File imageFile, {
    int maxResults = 20,
    double confidenceThreshold = 0.1,
  }) async {
    try {
      if (!imageFile.existsSync()) {
        throw VisionAIException(
          message: 'Image file does not exist',
          code: 'file_not_found',
        );
      }

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final allLabels = <LabelModel>[];
      final seenNames = <String>{};

      // Read the original image for cropping later
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      // ── 1. Custom MobileNet V2 labeling on the full image ──
      try {
        final labeler = await _createCustomLabeler(
          confidenceThreshold: confidenceThreshold,
          maxCount: maxResults,
        );
        final imageLabels = await labeler.processImage(inputImage);

        debugPrint('───── MobileNet V2 Full Image Labels ─────');
        for (final label in imageLabels) {
          debugPrint(
              '  [MobileNet] ${label.label} — ${(label.confidence * 100).toStringAsFixed(1)}%');
          final name = _cleanAndCapitalize(label.label);
          if (seenNames.add(name.toLowerCase())) {
            allLabels.add(LabelModel(
              id: 'mn_${label.index}',
              name: name,
              confidence: label.confidence,
              description: 'MobileNet V2 label',
            ));
          }
        }
        await labeler.close();
        debugPrint('Total MobileNet labels: ${imageLabels.length}');
      } catch (e) {
        debugPrint('Custom model labeling error (non-fatal): $e');
      }

      // ── 2. Also run default ML Kit labeling for broader categories ──
      try {
        final baseLabeler = ImageLabeler(
          options: ImageLabelerOptions(confidenceThreshold: confidenceThreshold),
        );
        final baseLabels = await baseLabeler.processImage(inputImage);

        debugPrint('───── ML Kit Base Labels ─────');
        for (final label in baseLabels) {
          debugPrint(
              '  [Base] ${label.label} — ${(label.confidence * 100).toStringAsFixed(1)}%');
          final name = _cleanAndCapitalize(label.label);
          if (seenNames.add(name.toLowerCase())) {
            allLabels.add(LabelModel(
              id: 'base_${label.index}',
              name: name,
              confidence: label.confidence,
              description: 'ML Kit label',
            ));
          }
        }
        await baseLabeler.close();
      } catch (e) {
        debugPrint('Base labeling error (non-fatal): $e');
      }

      // ── 3. Object Detection — find individual objects ──
      try {
        final detector = ObjectDetector(
          options: ObjectDetectorOptions(
            mode: DetectionMode.single,
            classifyObjects: true,
            multipleObjects: true,
          ),
        );
        final detectedObjects = await detector.processImage(inputImage);

        debugPrint('───── Object Detection: ${detectedObjects.length} objects ─────');

        for (final obj in detectedObjects) {
          // Add object detector's own generic labels
          for (final objLabel in obj.labels) {
            debugPrint(
                '  [Object] ${objLabel.text} — ${(objLabel.confidence * 100).toStringAsFixed(1)}%');
            final name = _cleanAndCapitalize(objLabel.text);
            if (seenNames.add(name.toLowerCase())) {
              allLabels.add(LabelModel(
                id: 'obj_${objLabel.index}_${obj.trackingId ?? 0}',
                name: name,
                confidence: objLabel.confidence,
                description: 'Detected object',
              ));
            }
          }

          // ── 4. Crop each object → re-label with custom MobileNet ──
          if (decodedImage != null) {
            try {
              final cropped = _cropObjectRegion(
                decodedImage,
                obj.boundingBox,
                decodedImage.width,
                decodedImage.height,
              );
              if (cropped != null) {
                final croppedLabels = await _labelCroppedImage(
                  cropped,
                  confidenceThreshold: confidenceThreshold,
                );
                for (final cl in croppedLabels) {
                  debugPrint(
                      '  [Crop→MobileNet] ${cl.label} — ${(cl.confidence * 100).toStringAsFixed(1)}%');
                  final name = _cleanAndCapitalize(cl.label);
                  if (seenNames.add(name.toLowerCase())) {
                    allLabels.add(LabelModel(
                      id: 'crop_${cl.index}_${obj.trackingId ?? 0}',
                      name: name,
                      confidence: cl.confidence,
                      description: 'Object-specific label',
                    ));
                  }
                }
              }
            } catch (e) {
              debugPrint('Crop labeling error (non-fatal): $e');
            }
          }
        }
        await detector.close();
      } catch (e) {
        debugPrint('Object detection error (non-fatal): $e');
      }

      // Sort by confidence descending, take top N
      allLabels.sort((a, b) => b.confidence.compareTo(a.confidence));
      final topLabels = allLabels.take(maxResults).toList();

      debugPrint('═════ Final Results: ${topLabels.length} labels ═════');
      for (final l in topLabels) {
        debugPrint(
            '  ✓ ${l.name} — ${(l.confidence * 100).toStringAsFixed(1)}%');
      }

      return ImageRecognitionResponse(
        labels: topLabels,
        processedAt: DateTime.now(),
      );
    } on VisionAIException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: 'MLKit Error: $e');
      throw VisionAIException(
        message: 'Failed to recognize image: ${e.toString()}',
        code: 'mlkit_recognition_failed',
        originalError: e,
      );
    }
  }

  /// Crop the bounding box region from the decoded image.
  img.Image? _cropObjectRegion(
    img.Image source,
    ui.Rect boundingBox,
    int imgWidth,
    int imgHeight,
  ) {
    final x = boundingBox.left.clamp(0, imgWidth - 1).toInt();
    final y = boundingBox.top.clamp(0, imgHeight - 1).toInt();
    var w = boundingBox.width.toInt();
    var h = boundingBox.height.toInt();
    if (x + w > imgWidth) w = imgWidth - x;
    if (y + h > imgHeight) h = imgHeight - y;
    if (w <= 0 || h <= 0) return null;

    return img.copyCrop(source, x: x, y: y, width: w, height: h);
  }

  /// Run custom MobileNet V2 labeling on a cropped image region.
  Future<List<ImageLabel>> _labelCroppedImage(
    img.Image croppedImage, {
    double confidenceThreshold = 0.1,
  }) async {
    final pngBytes = img.encodePng(croppedImage);
    final tempDir = Directory.systemTemp;
    final tempFile = File(
        '${tempDir.path}/mlkit_crop_${DateTime.now().millisecondsSinceEpoch}.png');
    await tempFile.writeAsBytes(pngBytes);

    try {
      final cropInput = InputImage.fromFilePath(tempFile.path);
      // Use our custom MobileNet V2 model for specific object names
      final labeler = await _createCustomLabeler(
        confidenceThreshold: confidenceThreshold,
        maxCount: 10,
      );
      final labels = await labeler.processImage(cropInput);
      await labeler.close();
      return labels;
    } finally {
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    }
  }

  /// Clean up ImageNet-style labels and capitalize nicely.
  /// e.g. "computer keyboard" → "Computer Keyboard"
  /// e.g. "mouse, computer mouse" → "Mouse"
  String _cleanAndCapitalize(String text) {
    if (text.isEmpty) return text;

    // ImageNet labels sometimes have format "primary, secondary"
    // Take the most readable form
    String cleaned = text;
    if (cleaned.contains(',')) {
      // Use the shortest/cleanest variant
      final parts = cleaned.split(',').map((s) => s.trim()).toList();
      cleaned = parts.reduce((a, b) => a.length <= b.length ? a : b);
    }

    // Remove underscores
    cleaned = cleaned.replaceAll('_', ' ');

    // Capitalize each word
    return cleaned
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  Future<void> dispose() async {
    // No persistent resources
  }
}
