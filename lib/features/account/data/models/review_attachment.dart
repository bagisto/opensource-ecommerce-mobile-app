import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ReviewAttachmentType { image, video }

/// A photo or video attached to a product review.
///
/// The Bagisto API returns `attachments` as a JSON string:
/// `[{"type":"image","url":"https://..."}, {"type":"video","url":"..."}]`.
class ReviewAttachment extends Equatable {
  final ReviewAttachmentType type;
  final String url;

  const ReviewAttachment({required this.type, required this.url});

  bool get isVideo => type == ReviewAttachmentType.video;

  static const Set<String> _videoExtensions = {
    'mp4',
    'mov',
    'm4v',
    '3gp',
    'webm',
    'mkv',
  };

  /// Accepts a JSON string, an already decoded list, or null.
  /// Never throws: invalid data yields an empty list.
  static List<ReviewAttachment> parseList(dynamic raw) {
    dynamic decoded = raw;
    if (raw is String) {
      if (raw.trim().isEmpty) return const [];
      try {
        decoded = jsonDecode(raw);
      } catch (_) {
        return const [];
      }
    }
    if (decoded is! List) return const [];

    final attachments = <ReviewAttachment>[];
    for (final item in decoded) {
      if (item is! Map) continue;
      final url = item['url']?.toString().trim() ?? '';
      if (url.isEmpty) continue;
      attachments.add(
        ReviewAttachment(
          type: _typeFor(item['type']?.toString(), url),
          url: url,
        ),
      );
    }
    return attachments;
  }

  static ReviewAttachmentType _typeFor(String? type, String url) {
    final normalized = type?.toLowerCase().trim() ?? '';
    if (normalized == 'video' || normalized.startsWith('video/')) {
      return ReviewAttachmentType.video;
    }
    if (normalized == 'image' || normalized.startsWith('image/')) {
      return ReviewAttachmentType.image;
    }
    final path = Uri.tryParse(url)?.path ?? url;
    final dot = path.lastIndexOf('.');
    final extension = dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
    return _videoExtensions.contains(extension)
        ? ReviewAttachmentType.video
        : ReviewAttachmentType.image;
  }

  @override
  List<Object?> get props => [type, url];
}

/// A review id reduced to its number, so ids from different queries match.
///
/// The server hands the same review out under two IRIs: the product's own
/// `reviews` connection says `/api/shop/reviews/17` while `productReviews`
/// says `/theme/api-4.9/public/api/shop/reviews/17`. Only the trailing
/// number is dependable, so that is what the media is keyed by.
String reviewIdKey(Object? raw) {
  final text = raw?.toString() ?? '';
  final match = RegExp(r'(\d+)\s*$').firstMatch(text.trim());
  return match?.group(1) ?? text.trim();
}
