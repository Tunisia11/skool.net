import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Header widget for the Subjects page displaying title and subtitle.
class SubjectsHeader extends StatelessWidget {
  const SubjectsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.book_outlined, color: AppColors.primary, size: 32),
            const SizedBox(width: 12),
            Text(
              'المواد الدراسية',
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'تصفح دروسك وتابع تقدمك في كل مادة',
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
