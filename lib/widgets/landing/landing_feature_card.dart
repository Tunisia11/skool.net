import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// A single feature card widget.
class LandingFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const LandingFeatureCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      width: isMobile ? double.infinity : 300,
      height: isMobile ? 150 : 200,
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 40 : 50, color: AppColors.primary),
          SizedBox(height: isMobile ? 12 : 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
