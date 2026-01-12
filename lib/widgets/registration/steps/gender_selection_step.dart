import 'package:flutter/material.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/widgets/registration/form_fields/gender_card.dart';
import 'package:skool/widgets/registration/shared/step_header.dart';

class GenderSelectionStep extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelectionStep({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

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
                gender: RegistrationConstants.genderMale,
                icon: Icons.male,
                isSelected: selectedGender == RegistrationConstants.genderMale,
                onTap: () => onGenderChanged(RegistrationConstants.genderMale),
                videoPath: 'assets/kid.mp4',
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GenderCard(
                gender: RegistrationConstants.genderFemale,
                icon: Icons.female,
                isSelected: selectedGender == RegistrationConstants.genderFemale,
                onTap: () => onGenderChanged(RegistrationConstants.genderFemale),
                videoPath: 'assets/girl.mp4',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
