import 'package:flutter/material.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/widgets/landing/landing.dart';
import 'package:skool/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LandingNavBar(
              onLoginTap: () => _navigateToLogin(context),
              onRegisterTap: () => _navigateToLogin(context),
            ),
            LandingHeroSection(onStartTap: () {}),
            const LandingStatsSection(),
            const LandingCoursesSection(),
            const LandingFooter(),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  static final navigatorKey = GlobalKey<NavigatorState>();
}
