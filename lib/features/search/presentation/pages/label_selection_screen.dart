import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/label_model.dart';
import '../../data/models/image_recognition_response.dart';
import '../bloc/image_search_bloc.dart';

/// Label Selection Screen
/// Displays recognized labels in a detailed list format
/// Allows user to select one label to use for product search
class LabelSelectionScreen extends StatelessWidget {
  final ImageRecognitionResponse recognitionResponse;

  const LabelSelectionScreen({
    super.key,
    required this.recognitionResponse,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<ImageSearchBloc>().add(ClearImageSearchEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Object'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: _buildLabelsList(context),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildLabelsList(BuildContext context) {
    final sortedLabels = recognitionResponse.sortedLabels;

    if (sortedLabels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_search,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No objects detected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try a different image',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<ImageSearchBloc, ImageSearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedLabels.length,
          itemBuilder: (context, index) {
            final label = sortedLabels[index];
            final isSelected = state.selectedLabel?.id == label.id;

            return _buildLabelListItem(
              context,
              label,
              isSelected,
              index + 1,
            );
          },
        );
      },
    );
  }

  Widget _buildLabelListItem(
    BuildContext context,
    LabelModel label,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ImageSearchBloc>().add(SelectLabelEvent(label));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Order number
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Label info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  if (label.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      label.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Confidence score and check icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(label.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue.shade500,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<ImageSearchBloc, ImageSearchState>(
      builder: (context, state) {
        return Container(
          padding: MediaQuery.of(context).viewInsets +
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<ImageSearchBloc>()
                        .add(ClearImageSearchEvent());
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.selectedLabel != null
                      ? () {
                          // Return selected label to previous screen
                          Navigator.pop(context, state.selectedLabel?.name);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
