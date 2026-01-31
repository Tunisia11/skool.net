import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/live_lesson.dart';
import 'package:skool/widgets/live/live_lesson_card.dart';

/// Grid widget displaying live lesson cards.
class LiveLessonsGrid extends StatelessWidget {
  final List<LiveLesson> lessons;
  final bool isReplay;
  final void Function(LiveLesson lesson)? onLessonTap;

  const LiveLessonsGrid({
    super.key,
    required this.lessons,
    this.isReplay = false,
    this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'لا توجد حصص في هذه القائمة',
            style: GoogleFonts.cairo(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 320,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return LiveLessonCard(
          lesson: lesson,
          isReplay: isReplay,
          onTap: onLessonTap != null ? () => onLessonTap!(lesson) : null,
        );
      },
    );
  }
}
