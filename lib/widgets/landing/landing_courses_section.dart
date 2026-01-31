import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/widgets/landing/landing_feature_card.dart';

/// Courses section widget for the Landing page.
class LandingCoursesSection extends StatelessWidget {
  const LandingCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Column(
        children: [
          Text(
            'ماذا نقدم ؟',
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 60),
          Wrap(
            spacing: isMobile ? 16 : 30,
            runSpacing: isMobile ? 16 : 30,
            alignment: WrapAlignment.center,
            children: const [
              LandingFeatureCard(
                title: 'فيديوهات تفسير الدروس',
                icon: Icons.video_library,
              ),
              LandingFeatureCard(
                title: 'مجلات رقمية',
                icon: Icons.book,
              ),
              LandingFeatureCard(
                title: 'أسئلة تفاعلية',
                icon: Icons.quiz,
              ),
              LandingFeatureCard(
                title: 'حصص مباشرة تفاعلية',
                icon: Icons.live_tv,
              ),
              LandingFeatureCard(
                title: 'تلاخيص الدروس',
                icon: Icons.summarize,
              ),
              LandingFeatureCard(
                title: 'منتدى للتفاعل',
                icon: Icons.forum,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
