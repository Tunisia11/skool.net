import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Header widget for the Live page.
class LiveHeader extends StatelessWidget {
  const LiveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            'البث المباشر',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
