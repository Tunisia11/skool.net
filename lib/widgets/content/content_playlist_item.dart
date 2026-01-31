import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';

/// A single playlist item widget.
class ContentPlaylistItem extends StatelessWidget {
  final LessonModel lesson;
  final bool isCurrent;
  final VoidCallback? onTap;

  const ContentPlaylistItem({
    super.key,
    required this.lesson,
    this.isCurrent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.primary.withValues(alpha: 0.05) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isCurrent ? Icons.play_circle_fill : Icons.play_circle_outline,
              color: isCurrent ? AppColors.primary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lesson.title,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              lesson.duration,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
