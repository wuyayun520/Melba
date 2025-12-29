import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import '../models/melba_data.dart';
import '../screens/video_player_screen.dart';

class VideoCard extends StatefulWidget {
  final Post post;
  final UserInfo user;
  final String date;
  final VoidCallback? onVideoHidden;

  const VideoCard({
    super.key,
    required this.post,
    required this.user,
    required this.date,
    this.onVideoHidden,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final videoUrl = widget.post.content.videoUrl;
      debugPrint('Loading video: $videoUrl');
      _controller = VideoPlayerController.asset(videoUrl);
      await _controller!.initialize();
      debugPrint('Video initialized: ${_controller!.value.size}');
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
      debugPrint('Video URL: ${widget.post.content.videoUrl}');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.85;
    final cardHeight = cardWidth * 1.4;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final finalCardHeight = min(cardHeight, maxHeight - 20);
        
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  post: widget.post,
                  user: widget.user,
                ),
              ),
            );
            if (result == true && widget.onVideoHidden != null) {
              widget.onVideoHidden!();
            }
          },
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Container(
              width: cardWidth,
              height: finalCardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/melba_home_video_card.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 49,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _isInitialized && 
                             _controller != null && 
                             _controller!.value.isInitialized &&
                             _controller!.value.size.width > 0 &&
                             _controller!.value.size.height > 0
                          ? SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _controller!.value.size.width,
                                  height: _controller!.value.size.height,
                                  child: VideoPlayer(_controller!),
                                ),
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  widget.user.profileBackground,
                                  fit: BoxFit.cover,
                                ),
                                if (!_isInitialized)
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Loading video...',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                    Center(
                      child: Image.asset(
                        'assets/melba_home_play.webp',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 36,
                      right: 36,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.post.stats.views ?? Random().nextInt(500) + 100}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

