import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
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
            _buildNavBar(context),
            _buildHeroSection(context),
            _buildStatsSection(context),
            _buildCoursesSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    if (isMobile) {
      // Mobile: Simple navbar with logo and buttons
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
            // Logo
            Image.asset('assets/logo.png', height: 40),
            // Buttons
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
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

    // Desktop: Full navbar
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
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

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: isMobile ? 40 : 80,
      ),
      decoration: const BoxDecoration(color: Color(0xFFE0F7FA)),
      child: isMobile
          ? Column(
              children: [
                // Text First on Mobile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سكول أكاديمي',
                      style: GoogleFonts.cairo(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'المنصة التعليمية الأولى',
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'عبر الإنترنت في تونس',
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'تمتع الآن بدروس دعم عبر الإنترنت في جميع المواد وعلى مختلف المستويات (الابتدائي والأساسي والثانوي)، ابتداءً من السنة الرابعة ابتدائي إلى البكالوريا',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'ابدأ الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Image Second
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/kidgraduated.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/kidgraduated.png',
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سكول أكاديمي',
                        style: GoogleFonts.cairo(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'المنصة التعليمية الأولى',
                        style: GoogleFonts.cairo(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'عبر الإنترنت في تونس',
                        style: GoogleFonts.cairo(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'تمتع الآن بدروس دعم عبر الإنترنت في جميع المواد وعلى مختلف المستويات (الابتدائي والأساسي والثانوي)، ابتداءً من السنة الرابعة ابتدائي إلى البكالوريا',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: Text(
                          'ابدأ الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 0,
      ),
      child: Center(
        child: Wrap(
          spacing: isMobile ? 16 : 40,
          runSpacing: isMobile ? 16 : 40,
          alignment: WrapAlignment.center,
          children: [
            _statCard(
              '+450',
              'حصة مباشرة شهريًا',
              Icons.live_tv,
              isMobile,
              context,
            ),
            _statCard(
              '+50.000',
              'فيديو في جميع المواد',
              Icons.play_circle_fill,
              isMobile,
              context,
            ),
            _statCard(
              '+410K',
              'تلميذ مسجّل في الموقع',
              Icons.people,
              isMobile,
              context,
            ),
            _statCard(
              '+340',
              'أستاذًا و معلمًا ذوي خبرة',
              Icons.school,
              isMobile,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    String number,
    String label,
    IconData icon,
    bool isMobile,
    BuildContext context,
  ) {
    return Container(
      width: isMobile ? (MediaQuery.of(context).size.width - 48) / 2 : 250,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: isMobile ? 30 : 40, color: AppColors.primary),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            number,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 12 : 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Column(
        children: [
          Text(
            'ماذا نقدم ؟',
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 60),
          Wrap(
            spacing: isMobile ? 16 : 30,
            runSpacing: isMobile ? 16 : 30,
            alignment: WrapAlignment.center,
            children: [
              _featureCard(
                'فيديوهات تفسير الدروس',
                Icons.video_library,
                isMobile,
              ),
              _featureCard('مجلات رقمية', Icons.book, isMobile),
              _featureCard('أسئلة تفاعلية', Icons.quiz, isMobile),
              _featureCard('حصص مباشرة تفاعلية', Icons.live_tv, isMobile),
              _featureCard('تلاخيص الدروس', Icons.summarize, isMobile),
              _featureCard('منتدى للتفاعل', Icons.forum, isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCard(String title, IconData icon, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 300,
      height: isMobile ? 150 : 200,
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 40 : 50, color: AppColors.primary),
          SizedBox(height: isMobile ? 12 : 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      color: Colors.white,
      child: Center(
        child: Text(
          '© 2025 Skool. All rights reserved.',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 12 : 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Global navigator key for accessing context
  static final navigatorKey = GlobalKey<NavigatorState>();
}
