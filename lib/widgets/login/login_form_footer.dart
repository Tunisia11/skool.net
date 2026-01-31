import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/screens/registration_page.dart';

/// Login form footer widget with "don't have account" link.
class LoginFormFooter extends StatelessWidget {
  final bool isMobile;

  const LoginFormFooter({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 13 : 14,
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrationPage()),
            );
          },
          child: Text(
            'سجل الآن',
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
