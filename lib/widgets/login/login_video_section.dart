import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:skool/widgets/web_video_background.dart';

/// Video section widget for the Login page.
class LoginVideoSection extends StatelessWidget {
  const LoginVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? WebVideoBackground(
            videoPath: 'assets/bgvedio.mp4',
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.3)),
                ),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 800,
                    height: 800,
                    scale: 1.4,
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
                width: 500,
                height: 500,
                fit: BoxFit.contain,
              ),
            ),
          );
  }
}
