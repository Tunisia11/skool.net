import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/chapters/chapter_stat_item.dart';

/// A card widget displaying a single chapter with progress and stats.
class ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final SubjectModel subject;
  final int chapterNumber;
  final VoidCallback? onTap;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.subject,
    required this.chapterNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildChapterNumber(),
                const SizedBox(width: 24),
                _buildChapterInfo(),
                _buildProgressIndicator(),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios,
                  color: chapter.isLocked ? Colors.grey[300] : Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChapterNumber() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: chapter.isLocked
            ? Colors.grey.withValues(alpha: 0.1)
            : subject.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          chapterNumber.toString(),
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: chapter.isLocked ? Colors.grey : subject.color,
          ),
        ),
      ),
    );
  }

  Widget _buildChapterInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                chapter.title,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: chapter.isLocked ? Colors.grey : AppColors.textPrimary,
                ),
              ),
              if (chapter.isLocked) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.lock,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            chapter.description,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ChapterStatItem(
                icon: Icons.play_circle_outline,
                label: '${chapter.videoCount} فيديو',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(chapter.progress * 100).toInt()}%',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: chapter.progress == 1.0 ? Colors.green : subject.color,
          ),
        ),
        const SizedBox(height: 8),
        if (chapter.progress == 1.0)
          const Icon(Icons.check_circle, color: Colors.green)
        else
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: chapter.progress,
                backgroundColor: subject.color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                minHeight: 6,
              ),
            ),
          ),
      ],
    );
  }
}
