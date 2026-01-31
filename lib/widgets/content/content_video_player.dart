import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// A video player widget for the content page.
class ContentVideoPlayer extends StatelessWidget {
  final String lessonDuration;

  const ContentVideoPlayer({
    super.key,
    required this.lessonDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildThumbnail(),
            _buildPlayButton(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Opacity(
        opacity: 0.6,
        child: Image.network(
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=675&fit=crop',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'الفيديو مشفر - متاح للمشتركين فقط',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '04:30 / $lessonDuration',
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.fullscreen, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
