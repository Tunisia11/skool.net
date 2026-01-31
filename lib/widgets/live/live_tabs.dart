import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Tab bar widget for switching between upcoming and recorded lessons.
class LiveTabs extends StatelessWidget {
  final TabController controller;
  final VoidCallback? onTap;

  const LiveTabs({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        onTap: onTap != null ? (_) => onTap!() : null,
        tabs: const [
          Tab(text: 'الحصص القادمة'),
          Tab(text: 'التسجيلات السابقة'),
        ],
      ),
    );
  }
}
