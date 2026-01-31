import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/screens/onboarding/onboarding_quiz_page.dart';
import 'package:skool/widgets/web_video_background.dart';

class QuizIntroPage extends StatelessWidget {
  const QuizIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    if (isMobile) {
      return Scaffold(
        body: Stack(
          children: [
            // Video Background
            WebVideoBackground(
              videoPath: 'assets/blonetalking.mp4',
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),

            // Logo
            Positioned(
              top: 20,
              left: 20,
              child: Image.asset(
                'assets/logo.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _buildIntroContent(context, true),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Desktop Layout
    return Scaffold(
      body: Row(
        children: [
          // Left Side: Video Only
          Expanded(
            child: WebVideoBackground(
              videoPath: 'assets/blonetalking.mp4',
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.1,
                ), // Slight overlay if needed
              ),
            ),
          ),

          // Right Side: Content (Solid Background)
          Expanded(
            child: Container(
              color: const Color(
                0xFF1A1C2E,
              ), // Solid dark background matching button/theme
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    left: -40,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(child: _buildIntroContent(context, false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroContent(BuildContext context, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Icon Bubble
        Container(
          width: isMobile ? 80 : 100,
          height: isMobile ? 80 : 100,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.psychology_alt_outlined,
            size: isMobile ? 40 : 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          'قبل أن نبدأ...',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 32 : 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),

        // Subtitle
        Text(
          'نود أن نعرف المزيد عنك وعن طريقة دراستك لنتمكن من مساعدتك بشكل أفضل.',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 18 : 24,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 48),

        // Action Button
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingQuizPage()),
        );
      },
      child: Container(
        height: 65,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCC99),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 24),
            Text(
              'ابدأ الاختبار',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1C2E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
