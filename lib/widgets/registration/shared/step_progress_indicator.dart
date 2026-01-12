import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            return Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentStep >= index
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                if (index < totalSteps - 1)
                  Container(
                    width: 40,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: currentStep > index
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 30),
        
        // Step Counter
        Text(
          'الخطوة ${currentStep + 1} من $totalSteps',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
