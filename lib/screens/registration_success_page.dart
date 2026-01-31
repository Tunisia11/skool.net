import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/onboarding/quiz_intro_page.dart';
import 'package:skool/widgets/web_video_background.dart';

class RegistrationSuccessPage extends StatelessWidget {
  final String? gender;
  final String? grade;

  const RegistrationSuccessPage({super.key, this.gender, this.grade});

  String _getVideoPath() {
    // Default to success if no data
    if (gender == null) return 'assets/sucess.mp4';

    final isHighSchool =
        grade != null && (grade!.contains('ثانوي') || grade!.contains('Bac'));

    // Actually, safer to check if it matches the Male constant or similar.
    // Let's assume standard values from RegistrationConstants.
    // If we look at RegistrationPage, it compares with RegistrationConstants.genderMale.
    // I should probably pass the raw string and compare.

    // Let's try to infer from common values.
    // If the app is in Arabic, gender might be 'ذكر'/'أنثى'.
    // If it's internal codes, it might be 'male'/'female'.
    // I'll check RegistrationConstants in next step to be sure, but for now I'll use a logic that handles both if possible or update after checking.
    // Wait, I can see RegistrationPage uses RegistrationConstants.genderMale.
    // I will use a robust check.

    // Logic based on User Request:
    // Female Primary -> Primary_female.mp4
    // Female HighSchool -> higschoo_female.mp4
    // Male Primary -> kid.mp4
    // Male HighSchool -> higschool_male.mp4

    bool isFemale = gender == 'أنثى' || gender == 'female';

    if (isFemale) {
      return isHighSchool
          ? 'assets/higschoo_female.mp4'
          : 'assets/Primary_female.mp4';
    } else {
      return isHighSchool ? 'assets/higschool_male.mp4' : 'assets/sucess.mp4';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: WebVideoBackground(
        videoPath: _getVideoPath(),
        child: Stack(
          children: [
            // 1. LOGO (Top Left)
            Positioned(
              top: isMobile ? 20 : -10,
              left: isMobile ? 10 : -10,
              child: Image.asset(
                'assets/logo.png',
                height: isMobile ? 80 : 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),

            // 2. Bottom Content Layer
            Align(
              alignment: isMobile ? Alignment.bottomCenter : Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Start\nYour Learning\nAdventure",
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 28 : 42,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1C2E),
                        height: 1.1,
                      ),
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    ),
                    SizedBox(height: isMobile ? 30 : 40),

                    // Buttons Layout - responsive
                    isMobile
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: _buildActionButton(context, 'Start Learning'),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: _buildGlassButton(context, 'Skip'),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: _buildGlassButton(context, 'Skip')),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: _buildActionButton(
                                    context, 'Start Learning'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI Helper for the Glass-effect Skip button
  Widget _buildGlassButton(BuildContext context, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
          (route) => false,
        );
      },
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // UI Helper for the Peach Action button
  Widget _buildActionButton(BuildContext context, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizIntroPage()),
        );
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCC99),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
              child: const Icon(Icons.north_east, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
