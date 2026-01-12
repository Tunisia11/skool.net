import 'package:flutter/material.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/widgets/registration/form_fields/custom_text_field.dart';
import 'package:skool/widgets/registration/shared/step_header.dart';

class NameEntryStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final String? selectedGender;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onAgeChanged;

  const NameEntryStep({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.selectedGender,
    this.onNameChanged,
    this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: RegistrationConstants.step2Title,
          subtitle: RegistrationConstants.step2Subtitle,
        ),
        const SizedBox(height: 40),

        // Name Field
        CustomTextField(
          controller: nameController,
          label: RegistrationConstants.labelName,
          icon: Icons.person_outline,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 20),

        // Age Field
        CustomTextField(
          controller: ageController,
          label: RegistrationConstants.labelAge,
          icon: Icons.cake_outlined,
          onChanged: onAgeChanged,
        ),
      ],
    );
  }
}
