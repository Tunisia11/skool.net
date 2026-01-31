import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Header widget for the Content page with back button and chapter title.
class ContentHeader extends StatelessWidget {
  final String chapterTitle;
  final VoidCallback? onBackTap;

  const ContentHeader({
    super.key,
    required this.chapterTitle,
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
                'العودة للمحاور',
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          chapterTitle,
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
