import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/constants/registration_constants.dart';

/// Navigation bar widget for the registration form.
class RegistrationNavBar extends StatelessWidget {
  final int currentStep;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isMobile;

  const RegistrationNavBar({
    super.key,
    required this.currentStep,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : onPrevious,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: Text(
                RegistrationConstants.buttonBack,
                style: GoogleFonts.cairo(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        if (currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    currentStep == 3
                        ? RegistrationConstants.buttonRegister
                        : RegistrationConstants.buttonNext,
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
