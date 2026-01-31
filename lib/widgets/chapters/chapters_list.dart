import 'package:flutter/material.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/chapters/chapter_card.dart';

/// A list widget displaying chapter cards for a subject.
class ChaptersList extends StatelessWidget {
  final SubjectModel subject;
  final void Function(ChapterModel chapter)? onChapterTap;

  const ChaptersList({
    super.key,
    required this.subject,
    this.onChapterTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subject.chapters.length,
      itemBuilder: (context, index) {
        final chapter = subject.chapters[index];
        return ChapterCard(
          chapter: chapter,
          subject: subject,
          chapterNumber: index + 1,
          onTap: onChapterTap != null ? () => onChapterTap!(chapter) : null,
        );
      },
    );
  }
}
