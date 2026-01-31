import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A motivational welcome card widget for the dashboard.
class DashboardWelcomeCard extends StatelessWidget {
  final String userName;
  final VoidCallback? onBrowseCoursesTap;

  const DashboardWelcomeCard({
    super.key,
    required this.userName,
    this.onBrowseCoursesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF868CFF), Color(0xFF4318FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مجهود رائع يا $userName!',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابدأ رحلتك التعليمية الآن!',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onBrowseCoursesTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4318FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'تصفح الدورات',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
