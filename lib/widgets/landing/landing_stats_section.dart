import 'package:flutter/material.dart';
import 'package:skool/widgets/landing/landing_stat_card.dart';

/// Stats section widget for the Landing page.
class LandingStatsSection extends StatelessWidget {
  const LandingStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 0,
      ),
      child: Center(
        child: Wrap(
          spacing: isMobile ? 16 : 40,
          runSpacing: isMobile ? 16 : 40,
          alignment: WrapAlignment.center,
          children: const [
            LandingStatCard(
              number: '+450',
              label: 'حصة مباشرة شهريًا',
              icon: Icons.live_tv,
            ),
            LandingStatCard(
              number: '+50.000',
              label: 'فيديو في جميع المواد',
              icon: Icons.play_circle_fill,
            ),
            LandingStatCard(
              number: '+410K',
              label: 'تلميذ مسجّل في الموقع',
              icon: Icons.people,
            ),
            LandingStatCard(
              number: '+340',
              label: 'أستاذًا و معلمًا ذوي خبرة',
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }
}
