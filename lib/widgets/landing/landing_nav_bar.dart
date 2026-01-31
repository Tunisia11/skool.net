import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Navigation bar widget for the Landing page.
class LandingNavBar extends StatelessWidget {
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;

  const LandingNavBar({
    super.key,
    this.onLoginTap,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    if (isMobile) {
      return _buildMobileNavBar(context);
    }
    return _buildDesktopNavBar(context);
  }

  Widget _buildMobileNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', height: 40),
          Row(
            children: [
              TextButton(
                onPressed: onLoginTap,
                child: Text(
                  'دخول',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onRegisterTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'سجل',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavBar(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    right: -130,
                    child: Container(
                      width: 350,
                      height: 90,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navLink('الرئيسية', isActive: true),
                  const SizedBox(width: 24),
                  _navLink('من نحن؟'),
                  const SizedBox(width: 24),
                  _navLink('المنصة'),
                  const SizedBox(width: 24),
                  _navLink('عروضنا'),
                  const SizedBox(width: 24),
                  _navLink('أساتذتنا'),
                ],
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: onLoginTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'تسجيل الدخول',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onRegisterTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'سجل مجانا',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navLink(String title, {bool isActive = false}) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.textPrimary,
      ),
    );
  }
}
