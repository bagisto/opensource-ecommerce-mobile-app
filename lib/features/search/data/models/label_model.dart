import 'package:equatable/equatable.dart';

/// Model representing a label/tag from Vision AI
class LabelModel extends Equatable {
  final String id;
  final String name;
  final double confidence;
  final String? description;
  final bool isSelected;

  const LabelModel({
    required this.id,
    required this.name,
    required this.confidence,
    this.description,
    this.isSelected = false,
  });

  /// Copy with method for updating fields
  LabelModel copyWith({
    String? id,
    String? name,
    double? confidence,
    String? description,
    bool? isSelected,
  }) {
    return LabelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      confidence: confidence ?? this.confidence,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  /// Convert from JSON
  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      id: json['id'] as String? ?? json['label'] as String? ?? '',
      name: json['name'] as String? ?? json['label'] as String? ?? '',
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      description: json['description'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'confidence': confidence,
      'description': description,
      'isSelected': isSelected,
    };
  }

  @override
  List<Object?> get props => [id, name, confidence, description, isSelected];
}
