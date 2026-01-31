import 'package:flutter/material.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/widgets/web_video_background.dart';

/// Video section widget for the registration page.
/// Shows video based on selected gender and age level.
/// - Primary (age < 15): kid.mp4, girl.mp4
/// - Lycee (age >= 15): lycee_male.mp4, lycee_female.mp4
class RegistrationVideoSection extends StatelessWidget {
  final String? selectedGender;
  final int? age;
  final bool isMobile;

  const RegistrationVideoSection({
    super.key,
    required this.selectedGender,
    required this.isMobile,
    this.age,
  });

  /// Determines if the age corresponds to lycee level (13+, primary is 12 and under)
  bool get _isLycee => age != null && age! >= 13;

  String _getVideoPath() {
    if (selectedGender == RegistrationConstants.genderMale) {
      return _isLycee ? 'assets/lycee_male.mp4' : 'assets/kid.mp4';
    } else if (selectedGender == RegistrationConstants.genderFemale) {
      return _isLycee ? 'assets/lycee_female.mp4' : 'assets/girl.mp4';
    }
    // Default fallback
    return _isLycee ? 'assets/lycee_male.mp4' : 'assets/kid.mp4';
  }

  @override
  Widget build(BuildContext context) {
    if (selectedGender != null) {
      return WebVideoBackground(
        key: ValueKey('${selectedGender}_${_isLycee ? 'lycee' : 'primary'}'),
        videoPath: _getVideoPath(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_outline,
          size: isMobile ? 60 : 120,
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
