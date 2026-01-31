import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WebVideoBackground extends StatefulWidget {
  final String videoPath;
  final Widget child;

  const WebVideoBackground({
    super.key,
    required this.videoPath,
    required this.child,
  });

  @override
  State<WebVideoBackground> createState() => _WebVideoBackgroundState();
}

class _WebVideoBackgroundState extends State<WebVideoBackground> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(WebVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller.dispose();
      _initialized = false;
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    // For web, assets might need 'assets/' prefix if not handled automatically, 
    // but VideoPlayerController.asset usually handles it.
    _controller = VideoPlayerController.asset(widget.videoPath);
    
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0); // Mute is required for autoplay
      await _controller.play();
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_initialized)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(
              color: Colors.black, // Fallback background
            ),
          ),
        Positioned.fill(
          child: widget.child,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
