import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/widgets/dashboard/dashboard_stat_item.dart';

/// A profile card widget displaying user info and stats.
class DashboardProfileCard extends StatelessWidget {
  final String name;
  final String grade;

  const DashboardProfileCard({
    super.key,
    required this.name,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            grade,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardStatItem(value: '0', label: 'الدورات'),
              DashboardStatItem(value: '0', label: 'ساعة'),
              DashboardStatItem(value: '-', label: 'المعدل'),
            ],
          ),
        ],
      ),
    );
  }
}
