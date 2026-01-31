import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Hero section widget for the Landing page.
class LandingHeroSection extends StatelessWidget {
  final VoidCallback? onStartTap;

  const LandingHeroSection({
    super.key,
    this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: isMobile ? 40 : 80,
      ),
      decoration: const BoxDecoration(color: Color(0xFFE0F7FA)),
      child: isMobile ? _buildMobileHero() : _buildDesktopHero(),
    );
  }

  Widget _buildMobileHero() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سكول أكاديمي',
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'المنصة التعليمية الأولى',
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'عبر الإنترنت في تونس',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تمتع الآن بدروس دعم عبر الإنترنت في جميع المواد وعلى مختلف المستويات (الابتدائي والأساسي والثانوي)، ابتداءً من السنة الرابعة ابتدائي إلى البكالوريا',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'ابدأ الآن',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/kidgraduated.png',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHero() {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            'assets/kidgraduated.png',
            height: 500,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سكول أكاديمي',
                style: GoogleFonts.cairo(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'المنصة التعليمية الأولى',
                style: GoogleFonts.cairo(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'عبر الإنترنت في تونس',
                style: GoogleFonts.cairo(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'تمتع الآن بدروس دعم عبر الإنترنت في جميع المواد وعلى مختلف المستويات (الابتدائي والأساسي والثانوي)، ابتداءً من السنة الرابعة ابتدائي إلى البكالوريا',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onStartTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                child: Text(
                  'ابدأ الآن',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
