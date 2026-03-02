import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/image_data_model.dart';
import '../../data/models/image_recognition_response.dart';
import '../../data/models/label_model.dart';
import '../../data/repository/image_search_repository.dart';
import '../../data/exceptions/image_search_exceptions.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class ImageSearchEvent extends Equatable {
  const ImageSearchEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize image search
class InitImageSearch extends ImageSearchEvent {}

/// Capture image using camera
class CaptureImageEvent extends ImageSearchEvent {}

/// Select image from gallery
class SelectImageEvent extends ImageSearchEvent {}

/// Process selected image with Vision AI
class ProcessImageEvent extends ImageSearchEvent {
  final ImageDataModel imageData;

  const ProcessImageEvent(this.imageData);

  @override
  List<Object?> get props => [imageData];
}

/// Select a label from recognized labels
class SelectLabelEvent extends ImageSearchEvent {
  final LabelModel label;

  const SelectLabelEvent(this.label);

  @override
  List<Object?> get props => [label];
}

/// Deselect a label
class DeselectLabelEvent extends ImageSearchEvent {
  final String labelId;

  const DeselectLabelEvent(this.labelId);

  @override
  List<Object?> get props => [labelId];
}

/// Clear current image and labels
class ClearImageSearchEvent extends ImageSearchEvent {}

/// Retry image processing after error
class RetryImageProcessingEvent extends ImageSearchEvent {}

// ─── State ─────────────────────────────────────────────────────────────────

enum ImageSearchStatus {
  initial,
  loading,
  imageSelected,
  processing,
  labelsReady,
  labelSelected,
  error,
}

class ImageSearchState extends Equatable {
  final ImageSearchStatus status;
  final ImageDataModel? selectedImage;
  final ImageRecognitionResponse? recognitionResponse;
  final List<LabelModel> labels;
  final LabelModel? selectedLabel;
  final String? errorMessage;
  final String? errorCode;
  final bool isProcessing;
  final int processingProgress; // 0-100

  const ImageSearchState({
    this.status = ImageSearchStatus.initial,
    this.selectedImage,
    this.recognitionResponse,
    this.labels = const [],
    this.selectedLabel,
    this.errorMessage,
    this.errorCode,
    this.isProcessing = false,
    this.processingProgress = 0,
  });

  /// Copy with method
  ImageSearchState copyWith({
    ImageSearchStatus? status,
    ImageDataModel? selectedImage,
    ImageRecognitionResponse? recognitionResponse,
    List<LabelModel>? labels,
    LabelModel? selectedLabel,
    String? errorMessage,
    String? errorCode,
    bool? isProcessing,
    int? processingProgress,
  }) {
    return ImageSearchState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      recognitionResponse: recognitionResponse ?? this.recognitionResponse,
      labels: labels ?? this.labels,
      selectedLabel: selectedLabel ?? this.selectedLabel,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      isProcessing: isProcessing ?? this.isProcessing,
      processingProgress: processingProgress ?? this.processingProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedImage,
        recognitionResponse,
        labels,
        selectedLabel,
        errorMessage,
        errorCode,
        isProcessing,
        processingProgress,
      ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class ImageSearchBloc extends Bloc<ImageSearchEvent, ImageSearchState> {
  final ImageSearchRepository repository;

  ImageSearchBloc({required this.repository})
      : super(const ImageSearchState()) {
    on<InitImageSearch>(_onInitImageSearch);
    on<CaptureImageEvent>(_onCaptureImage);
    on<SelectImageEvent>(_onSelectImage);
    on<ProcessImageEvent>(_onProcessImage);
    on<SelectLabelEvent>(_onSelectLabel);
    on<DeselectLabelEvent>(_onDeselectLabel);
    on<ClearImageSearchEvent>(_onClearImageSearch);
    on<RetryImageProcessingEvent>(_onRetryImageProcessing);
  }

  Future<void> _onInitImageSearch(
    InitImageSearch event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(state.copyWith(status: ImageSearchStatus.initial));
  }

  Future<void> _onCaptureImage(
    CaptureImageEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(state.copyWith(
      status: ImageSearchStatus.loading,
      isProcessing: true,
      processingProgress: 0,
    ));

    try {
      // Capture image WITHOUT processing (for crop workflow)
      final imageData = await repository.captureImageOnly();

      emit(state.copyWith(
        status: ImageSearchStatus.imageSelected,
        selectedImage: imageData,
        isProcessing: false,
        processingProgress: 50,
      ));
    } on PermissionException catch (e) {
      emit(state.copyWith(
        status: ImageSearchStatus.error,
        errorMessage: e.message,
        errorCode: e.code,
        isProcessing: false,
      ));
    } catch (e) {
      debugPrint('Error capturing image: $e');
      emit(state.copyWith(
        status: ImageSearchStatus.error,
        errorMessage: 'Failed to capture image',
        errorCode: 'capture_error',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onSelectImage(
    SelectImageEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(state.copyWith(
      status: ImageSearchStatus.loading,
      isProcessing: true,
      processingProgress: 0,
    ));

    try {
      // Select image WITHOUT processing (for crop workflow)
      final imageData = await repository.selectImageOnly();

      emit(state.copyWith(
        status: ImageSearchStatus.imageSelected,
        selectedImage: imageData,
        isProcessing: false,
        processingProgress: 50,
      ));
    } on PermissionException catch (e) {
      emit(state.copyWith(
        status: ImageSearchStatus.error,
        errorMessage: e.message,
        errorCode: e.code,
        isProcessing: false,
      ));
    } catch (e) {
      debugPrint('Error selecting image: $e');
      emit(state.copyWith(
        status: ImageSearchStatus.error,
        errorMessage: 'Failed to select image',
        errorCode: 'selection_error',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(state.copyWith(
      status: ImageSearchStatus.processing,
      selectedImage: event.imageData,
      isProcessing: true,
      processingProgress: 30,
    ));

    try {
      emit(state.copyWith(processingProgress: 60));

      if (event.imageData.imageFile == null) {
        throw ImageSearchRepositoryException(
          message: 'Image file not available',
          code: 'no_image_file',
        );
      }

      final response = await repository.recognizeImageFile(
        event.imageData.imageFile!,
        maxResults: 20,
        confidenceThreshold: 0.1,
      );

      emit(state.copyWith(
        processingProgress: 100,
      ));

      emit(state.copyWith(
        status: ImageSearchStatus.labelsReady,
        recognitionResponse: response,
        labels: response.labels,
        isProcessing: false,
      ));
    } catch (e) {
      debugPrint('Error processing image: $e');
      emit(state.copyWith(
        status: ImageSearchStatus.error,
        errorMessage: 'Failed to process image',
        errorCode: 'processing_error',
        isProcessing: false,
      ));
    }
  }

  Future<void> _onSelectLabel(
    SelectLabelEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    final updatedLabels = state.labels
        .map((label) => label.id == event.label.id
            ? label.copyWith(isSelected: true)
            : label.copyWith(isSelected: false))
        .toList();

    emit(state.copyWith(
      status: ImageSearchStatus.labelSelected,
      labels: updatedLabels,
      selectedLabel: event.label.copyWith(isSelected: true),
    ));
  }

  Future<void> _onDeselectLabel(
    DeselectLabelEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    final updatedLabels = state.labels
        .map((label) =>
            label.id == event.labelId ? label.copyWith(isSelected: false) : label)
        .toList();

    emit(state.copyWith(
      status: ImageSearchStatus.labelsReady,
      labels: updatedLabels,
      selectedLabel: null,
    ));
  }

  Future<void> _onClearImageSearch(
    ClearImageSearchEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(const ImageSearchState(status: ImageSearchStatus.initial));
  }

  Future<void> _onRetryImageProcessing(
    RetryImageProcessingEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    if (state.selectedImage != null) {
      add(ProcessImageEvent(state.selectedImage!));
    }
  }

  @override
  Future<void> close() async {
    await repository.dispose();
    await super.close();
  }
}
