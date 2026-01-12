import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/screens/landing_page.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(String)? onNavigate;

  const AppSidebar({super.key, required this.currentRoute, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Logo
          Container(
            width: 350,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Nav Items
          _SidebarItem(
            icon: Icons.home_filled,
            title: 'الرئيسية',
            isActive: currentRoute == 'home',
            onTap: () => _handleNavigation(context, 'home'),
          ),
          _SidebarItem(
            icon: Icons.person_outline,
            title: 'ملفي الشخصي',
            isActive: currentRoute == 'profile',
            onTap: () => _handleNavigation(context, 'profile'),
          ),
          _SidebarItem(
            icon: Icons.diamond_outlined,
            title: 'العروض',
            isActive: currentRoute == 'offers',
            onTap: () => _handleNavigation(context, 'offers'),
          ),
          _SidebarItem(
            icon: Icons.book_outlined,
            title: 'المواد',
            isActive: currentRoute == 'subjects',
            onTap: () => _handleNavigation(context, 'subjects'),
          ),
          _SidebarItem(
            icon: Icons.live_tv,
            title: 'مباشر',
            isActive: currentRoute == 'live',
            onTap: () => _handleNavigation(context, 'live'),
          ),
          _SidebarItem(
            icon: Icons.wallet_giftcard,
            title: 'محفظتي',
            isActive: currentRoute == 'wallet',
            onTap: () => _handleNavigation(context, 'wallet'),
          ),
          _SidebarItem(
            icon: Icons.headset_mic_outlined,
            title: 'الدعم الفني',
            isActive: currentRoute == 'support',
            onTap: () => _handleNavigation(context, 'support'),
          ),

          const Spacer(),

          // Logout
          _SidebarItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            isDestructive: true,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, String route) {
    if (onNavigate != null) {
      onNavigate!(route);
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: isActive
          ? BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border(
                right: BorderSide(
                  color: AppColors.primary,
                  width: 4,
                ), // Right border for active indicator in RTL
              ),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? Colors.red
              : (isActive ? AppColors.primary : AppColors.textSecondary),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            color: isDestructive
                ? Colors.red
                : (isActive ? AppColors.primary : AppColors.textSecondary),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
