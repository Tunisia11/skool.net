import 'package:flutter/material.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/widgets/registration/form_fields/gender_card.dart';
import 'package:skool/widgets/registration/shared/step_header.dart';

class GenderSelectionStep extends StatelessWidget {
  final String? selectedGender;
  final int? age;
  final Function(String) onGenderChanged;

  const GenderSelectionStep({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    this.age,
  });

  /// Determines if lycee avatars should be used (age 13+)
  bool get _isLycee => age != null && age! >= 13;

  String get _maleVideoPath => _isLycee ? 'assets/lycee_male.mp4' : 'assets/kid.mp4';
  String get _femaleVideoPath => _isLycee ? 'assets/lycee_female.mp4' : 'assets/girl.mp4';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: RegistrationConstants.step1Title,
          subtitle: RegistrationConstants.step1Subtitle,
        ),
        const SizedBox(height: 50),
        
        // Gender Cards
        Row(
          children: [
            Expanded(
              child: GenderCard(
                key: ValueKey('male_${_isLycee ? 'lycee' : 'primary'}'),
                gender: RegistrationConstants.genderMale,
                icon: Icons.male,
                isSelected: selectedGender == RegistrationConstants.genderMale,
                onTap: () => onGenderChanged(RegistrationConstants.genderMale),
                videoPath: _maleVideoPath,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GenderCard(
                key: ValueKey('female_${_isLycee ? 'lycee' : 'primary'}'),
                gender: RegistrationConstants.genderFemale,
                icon: Icons.female,
                isSelected: selectedGender == RegistrationConstants.genderFemale,
                onTap: () => onGenderChanged(RegistrationConstants.genderFemale),
                videoPath: _femaleVideoPath,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
