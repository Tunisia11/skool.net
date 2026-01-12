import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

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
  late html.VideoElement _videoElement;
  final String _viewId = 'video-background-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoElement = html.VideoElement()
      ..src = widget.videoPath
      ..autoplay = true
      ..muted = true
      ..loop = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.display = 'block' // Ensures it behaves as a block element
      ..style.pointerEvents = 'none';

    // Register the view
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _videoElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: HtmlElementView(
            viewType: _viewId,
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
    _videoElement.pause();
    _videoElement.remove();
    super.dispose();
  }
}
