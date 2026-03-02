import 'package:equatable/equatable.dart';
import 'label_model.dart';

/// Model for response from Vision AI service
class ImageRecognitionResponse extends Equatable {
  final List<LabelModel> labels;
  final double? imageWidth;
  final double? imageHeight;
  final String? rawResponse;
  final DateTime processedAt;

  const ImageRecognitionResponse({
    required this.labels,
    this.imageWidth,
    this.imageHeight,
    this.rawResponse,
    required this.processedAt,
  });

  /// Copy with method for updating fields
  ImageRecognitionResponse copyWith({
    List<LabelModel>? labels,
    double? imageWidth,
    double? imageHeight,
    String? rawResponse,
    DateTime? processedAt,
  }) {
    return ImageRecognitionResponse(
      labels: labels ?? this.labels,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      rawResponse: rawResponse ?? this.rawResponse,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  /// Sort labels by confidence (descending)
  List<LabelModel> get sortedLabels {
    final sorted = List<LabelModel>.from(labels);
    sorted.sort((a, b) => b.confidence.compareTo(a.confidence));
    return sorted;
  }

  /// Get top N labels
  List<LabelModel> getTopLabels(int n) {
    return sortedLabels.take(n).toList();
  }

  /// Convert from JSON
  factory ImageRecognitionResponse.fromJson(Map<String, dynamic> json) {
    final labelsJson = json['labels'] as List<dynamic>? ?? [];
    return ImageRecognitionResponse(
      labels: labelsJson
          .map((label) => LabelModel.fromJson(label as Map<String, dynamic>))
          .toList(),
      imageWidth: (json['imageWidth'] as num?)?.toDouble(),
      imageHeight: (json['imageHeight'] as num?)?.toDouble(),
      rawResponse: json['rawResponse'] as String?,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'labels': labels.map((label) => label.toJson()).toList(),
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'rawResponse': rawResponse,
      'processedAt': processedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [labels, imageWidth, imageHeight, rawResponse, processedAt];
}
