import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Header widget for the onboarding quiz page.
class QuizHeader extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final VoidCallback? onBackTap;
  final VoidCallback? onSkipTap;

  const QuizHeader({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.onBackTap,
    this.onSkipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBackTap,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
              Text(
                'اختبار البروفايل',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: onSkipTap,
                child: Text(
                  'تخطي',
                  style: GoogleFonts.cairo(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${currentQuestionIndex + 1}',
                style: GoogleFonts.cairo(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '${currentQuestionIndex + 1} / $totalQuestions',
                style: GoogleFonts.cairo(
                    color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / totalQuestions,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              color: AppColors.secondary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
