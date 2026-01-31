import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';

/// Header widget for the Chapters page with back button and subject info.
class ChaptersHeader extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onBackTap;

  const ChaptersHeader({
    super.key,
    required this.subject,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onBackTap ?? () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 16),
              const SizedBox(width: 4),
              Text(
                'العودة للمواد',
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(subject.iconData, color: subject.color, size: 32),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'قائمة المحاور والدروس',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
