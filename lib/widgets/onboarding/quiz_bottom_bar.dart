import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Bottom bar widget for the onboarding quiz page with navigation buttons.
class QuizBottomBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isLoading;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;

  const QuizBottomBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.isLoading = false,
    this.onPreviousTap,
    this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          if (currentQuestionIndex > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: onPreviousTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('السابق',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              ),
            )
          else
            const Spacer(flex: 1),
          const SizedBox(width: 16),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : onNextTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentQuestionIndex == totalQuestions - 1
                              ? 'إنهاء'
                              : 'التالي',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
