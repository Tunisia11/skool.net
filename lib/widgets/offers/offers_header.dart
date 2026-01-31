import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Header widget for the Offers page.
class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.diamond, color: AppColors.primary, size: 32),
            const SizedBox(width: 12),
            Text(
              'العروض',
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
          'اختر الباقة المناسبة لك وابدأ رحلتك التعليمية',
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
