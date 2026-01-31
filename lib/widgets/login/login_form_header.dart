import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Login form header widget with title and subtitle.
class LoginFormHeader extends StatelessWidget {
  final bool isMobile;

  const LoginFormHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تسجيل الدخول',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),
        Text(
          'مرحبًا بك مجددًا! الرجاء إدخال بياناتك',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 14 : 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
