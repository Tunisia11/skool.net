import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Footer widget for the registration page with "already have account" link.
class RegistrationFooter extends StatelessWidget {
  final bool isMobile;

  const RegistrationFooter({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 13 : 14,
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'تسجيل الدخول',
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
