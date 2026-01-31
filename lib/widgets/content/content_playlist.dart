import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/content/content_playlist_item.dart';

/// A playlist widget displaying chapter lessons.
class ContentPlaylist extends StatelessWidget {
  final List<LessonModel> lessons;
  final LessonModel currentLesson;
  final void Function(LessonModel lesson)? onLessonTap;

  const ContentPlaylist({
    super.key,
    required this.lessons,
    required this.currentLesson,
    this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'دروس المحور',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...lessons.map((lesson) => ContentPlaylistItem(
                lesson: lesson,
                isCurrent: lesson.id == currentLesson.id,
                onTap: onLessonTap != null ? () => onLessonTap!(lesson) : null,
              )),
        ],
      ),
    );
  }
}
