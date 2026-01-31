import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// A single stat card widget.
class LandingStatCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const LandingStatCard({
    super.key,
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      width: isMobile ? (size.width - 48) / 2 : 250,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: isMobile ? 30 : 40, color: AppColors.primary),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            number,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 12 : 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
