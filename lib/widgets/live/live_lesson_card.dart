import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/live_lesson.dart';

/// A card widget displaying a live lesson with details and action button.
class LiveLessonCard extends StatelessWidget {
  final LiveLesson lesson;
  final bool isReplay;
  final VoidCallback? onTap;

  const LiveLessonCard({
    super.key,
    required this.lesson,
    this.isReplay = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubjectRow(),
                  const SizedBox(height: 12),
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildTeacherRow(),
                  const Spacer(),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isReplay
            ? Colors.grey[200]
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Icon(
                isReplay
                    ? Icons.play_circle_outline
                    : Icons.calendar_today_outlined,
                size: 48,
                color: isReplay ? Colors.grey : AppColors.primary,
              ),
            ),
          ),
          if (lesson.isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'شائع',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            lesson.subject,
            style: GoogleFonts.cairo(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Text(
          isReplay
              ? '${lesson.participants} مشاهدة'
              : lesson.dateString,
          style: GoogleFonts.cairo(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      lesson.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTeacherRow() {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            lesson.teacher,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isReplay ? Colors.white : AppColors.primary,
          foregroundColor: isReplay ? AppColors.primary : Colors.white,
          elevation: 0,
          side: isReplay ? BorderSide(color: AppColors.primary) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          isReplay ? 'مشاهدة التسجيل' : 'تذكيري',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
