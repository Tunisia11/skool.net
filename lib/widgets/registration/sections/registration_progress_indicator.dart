import 'package:flutter/material.dart';
import 'package:skool/constants/app_colors.dart';

/// Progress indicator widget for the registration steps.
class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
