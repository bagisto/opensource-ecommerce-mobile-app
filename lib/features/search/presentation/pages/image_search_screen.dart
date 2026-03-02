import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import '../../data/models/label_model.dart';
import '../bloc/image_search_bloc.dart';

/// Image Search Screen — NEW FLOW:
/// 1. Auto-open camera when screen loads
/// 2. Capture photo → show crop editor
/// 3. Crop → show detected labels
/// 4. Select label → search and return to search page
class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  // States for crop editor
  File? _capturedImage;
  late Offset _cropStart = Offset.zero;
  late Offset _cropEnd = Offset.zero;
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    // Auto-open camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImageSearchBloc>().add(CaptureImageEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Search'),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
        ),
        body: BlocConsumer<ImageSearchBloc, ImageSearchState>(
          listener: (context, state) {
            if (state.status == ImageSearchStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
            // When image is captured, store it for cropping
            if (state.status == ImageSearchStatus.imageSelected &&
                _capturedImage == null &&
                state.selectedImage?.imageFile != null) {
              setState(() {
                _capturedImage = state.selectedImage!.imageFile;
                _isCropping = true;
              });
            }
          },
          builder: (context, state) {
            // Show crop editor while cropping
            if (_isCropping && _capturedImage != null) {
              return _buildCropEditor(context, state);
            }

            // Show labels if ready
            if (state.status == ImageSearchStatus.labelsReady ||
                state.status == ImageSearchStatus.labelSelected) {
              return _buildLabelsView(context, state);
            }

            // Show loading state
            if (state.status == ImageSearchStatus.loading ||
                state.status == ImageSearchStatus.processing) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: state.processingProgress > 0
                          ? state.processingProgress / 100
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.processingProgress > 0
                          ? 'Processing... ${state.processingProgress}%'
                          : 'Opening camera...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            // Initial state - waiting for camera (shouldn't show due to auto-init)
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Build crop editor UI
  Widget _buildCropEditor(BuildContext context, ImageSearchState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Crop canvas
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _cropStart = details.localPosition;
                _cropEnd = details.localPosition;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _cropEnd = details.localPosition;
              });
            },
            child: Stack(
              children: [
                // Image with semi-transparent overlay
                Image.file(
                  _capturedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Semi-transparent overlay outside crop area
                CustomPaint(
                  painter: _CropOverlayPainter(_cropStart, _cropEnd),
                  size: Size.infinite,
                ),
              ],
            ),
          ),
        ),

        // Controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _capturedImage = null;
                      _isCropping = false;
                    });
                    context
                        .read<ImageSearchBloc>()
                        .add(ClearImageSearchEvent());
                    context.read<ImageSearchBloc>().add(CaptureImageEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retake'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _processCroppedImage(context, state),
                  icon: const Icon(Icons.check),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Crop the image based on selection and run recognition
  Future<void> _processCroppedImage(
      BuildContext context, ImageSearchState state) async {
    try {
      // Read image and crop
      final imageBytes = await _capturedImage!.readAsBytes();
      var decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process image')),
        );
        return;
      }

      // Calculate crop bounds (clamp to image size)
      final left = _cropStart.dx.clamp(0, decodedImage.width).toInt();
      final top = _cropStart.dy.clamp(0, decodedImage.height).toInt();
      var width = (_cropEnd.dx - _cropStart.dx).abs().toInt();
      var height = (_cropEnd.dy - _cropStart.dy).abs().toInt();

      // If no crop selected, use full image
      if (width == 0 || height == 0) {
        width = decodedImage.width;
        height = decodedImage.height;
      } else {
        // Clamp width/height to image bounds
        if (left + width > decodedImage.width) {
          width = decodedImage.width - left;
        }
        if (top + height > decodedImage.height) {
          height = decodedImage.height - top;
        }

        // Crop the image
        decodedImage =
            img.copyCrop(decodedImage, x: left, y: top, width: width, height: height);
      }

      // Save cropped image back to the file
      await _capturedImage!.writeAsBytes(img.encodePng(decodedImage));

      // Process cropped image with ML Kit
      setState(() {
        _isCropping = false;
      });

      if (mounted && state.selectedImage != null) {
        // Use the same file reference (which now contains the cropped image)
        context
            .read<ImageSearchBloc>()
            .add(ProcessImageEvent(state.selectedImage!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crop error: $e')),
        );
      }
    }
  }

  /// Show recognized labels with list layout (matching screenshots)
  Widget _buildLabelsView(BuildContext context, ImageSearchState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Image preview (smaller)
        if (_capturedImage != null)
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Image.file(
              _capturedImage!,
              fit: BoxFit.cover,
            ),
          ),

        // Labels list with vertical layout
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Recognized Objects',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Labels as vertical list
                  ...state.labels.map((label) {
                    return _buildLabelListItem(context, label);
                  }).toList(),

                  const SizedBox(height: 20),

                  // Result count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Result:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          '${state.labels.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _capturedImage = null;
                      _isCropping = false;
                    });
                    context
                        .read<ImageSearchBloc>()
                        .add(ClearImageSearchEvent());
                    context.read<ImageSearchBloc>().add(CaptureImageEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.selectedLabel != null
                      ? () {
                          // Return selected label to search page
                          Navigator.pop(context, state.selectedLabel?.name);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Search'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build individual label list item (vertical layout)
  Widget _buildLabelListItem(BuildContext context, LabelModel label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        context.read<ImageSearchBloc>().add(SelectLabelEvent(label));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: label.isSelected
              ? Colors.blue.shade50
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: label.isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label.name,
                style: TextStyle(
                  color: label.isSelected
                      ? Colors.blue.shade900
                      : (isDark ? Colors.white : Colors.black87),
                  fontWeight: label.isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(label.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: label.isSelected
                    ? Colors.blue
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (label.isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: Colors.blue.shade700,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom painter for crop overlay effect
class _CropOverlayPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  _CropOverlayPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate crop area
    final left = start.dx < end.dx ? start.dx : end.dx;
    final top = start.dy < end.dy ? start.dy : end.dy;
    final right = start.dx < end.dx ? end.dx : start.dx;
    final bottom = start.dy < end.dy ? end.dy : start.dy;

    final cropRect = Rect.fromLTRB(left, top, right, bottom);

    // Draw semi-transparent overlay for areas outside crop
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..style = PaintingStyle.fill,
    );

    // Draw crop border
    if (left != right && top != bottom) {
      canvas.drawRect(
        cropRect,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );

      // Draw corner handles
      const handleSize = 12.0;
      for (var corner in [
        Offset(left, top),
        Offset(right, top),
        Offset(left, bottom),
        Offset(right, bottom)
      ]) {
        canvas.drawCircle(corner, handleSize / 2, Paint()..color = Colors.blue);
      }
    }
  }

  @override
  bool shouldRepaint(_CropOverlayPainter oldDelegate) => true;
}
