import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

/// Full-screen in-app player for a review video attachment.
class ReviewVideoPlayerPage extends StatefulWidget {
  final String? url;
  final File? file;

  const ReviewVideoPlayerPage({super.key, this.url, this.file})
    : assert((url == null) != (file == null));

  static Future<void> navigate(BuildContext context, String url) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ReviewVideoPlayerPage(url: url)));
  }

  /// Play a picked (not yet uploaded) video.
  static Future<void> navigateFile(BuildContext context, File file) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReviewVideoPlayerPage(file: file)),
    );
  }

  @override
  State<ReviewVideoPlayerPage> createState() => _ReviewVideoPlayerPageState();
}

class _ReviewVideoPlayerPageState extends State<ReviewVideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _hasError = false;

  /// The local copy made by [_playFromDownload], removed on the way out.
  File? _downloaded;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _load(_controller);
  }

  VideoPlayerController _createController() => widget.file != null
      ? VideoPlayerController.file(widget.file!)
      : VideoPlayerController.networkUrl(Uri.parse(widget.url!));

  Future<void> _load(VideoPlayerController controller) async {
    try {
      await controller.initialize();
      if (!mounted || controller != _controller) return;
      await controller.play();
      setState(() {});
    } catch (e) {
      debugPrint('🎬 ReviewVideoPlayerPage load error: $e');
      if (!mounted || controller != _controller) return;
      if (await _playFromDownload()) return;
      if (!mounted || controller != _controller) return;
      setState(() => _hasError = true);
    }
  }

  /// Plays the video from a local copy when streaming it refuses to start.
  ///
  /// Review videos are served as `application/octet-stream` under a
  /// `.quicktime` name, with `X-Content-Type-Options: nosniff`, so the player
  /// cannot tell it is a movie at all. Saved under the extension its own
  /// header says, the very same bytes play.
  Future<bool> _playFromDownload() async {
    final url = widget.url;
    if (url == null || _downloaded != null) return false;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return false;
      }
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/review_video_'
        '${DateTime.now().microsecondsSinceEpoch}'
        '${debugVideoExtensionFor(response.bodyBytes)}',
      );
      await file.writeAsBytes(response.bodyBytes);
      if (!mounted) {
        await file.delete().catchError((_) => file);
        return false;
      }

      _downloaded = file;
      final previous = _controller;
      final controller = VideoPlayerController.file(file);
      setState(() => _controller = controller);
      await previous.dispose();
      await controller.initialize();
      if (!mounted || controller != _controller) return false;
      await controller.play();
      setState(() => _hasError = false);
      return true;
    } catch (e) {
      debugPrint('🎬 ReviewVideoPlayerPage download fallback failed: $e');
      return false;
    }
  }

  void _retry() {
    final previous = _controller;
    setState(() {
      _controller = _createController();
      _hasError = false;
    });
    previous.dispose();
    _load(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _downloaded?.delete().catchError((_) => _downloaded!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: _buildContent(context)),
            Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_hasError) return _buildError(context);
    if (!_controller.value.isInitialized) {
      return const CircularProgressIndicator(
        color: AppColors.primary500,
        strokeWidth: 2,
      );
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        if (value.hasError) return _buildError(context);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () =>
                  value.isPlaying ? _controller.pause() : _controller.play(),
              child: AspectRatio(
                aspectRatio: value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    if (!value.isPlaying)
                      const Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white70,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary500,
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            l10n.accountReviewVideoLoadFailed,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(54),
                ),
              ),
              child: Text(
                l10n.commonRetry,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The container these bytes really are, read from the ISO-BMFF `ftyp` box
/// rather than trusted from the URL — review videos arrive named
/// `.quicktime` under `application/octet-stream`, which names nothing.
@visibleForTesting
String debugVideoExtensionFor(List<int> bytes) {
  if (bytes.length < 12) return '.mp4';
  if (String.fromCharCodes(bytes.sublist(4, 8)) != 'ftyp') return '.mp4';
  return String.fromCharCodes(bytes.sublist(8, 12)).startsWith('qt')
      ? '.mov'
      : '.mp4';
}
