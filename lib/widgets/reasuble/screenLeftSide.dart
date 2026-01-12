import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skool/widgets/web_video_background.dart';

class Screenleftside extends StatelessWidget {
  const Screenleftside({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: kIsWeb
          ? WebVideoBackground(
              videoPath: 'assets/bgvedio.mp4',
              child: Stack(
                children: [
                  // Dark overlay
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 700,
                      height: 700,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: const Color(0xFF1A237E),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 700,
                  height: 700,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
