import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Social login button widget.
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool isMobile;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.isMobile = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
