import 'package:flutter/material.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/models/registration_data.dart';
import 'package:skool/widgets/registration/form_fields/custom_dropdown.dart';
import 'package:skool/widgets/registration/shared/step_header.dart';

class AdditionalDataStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final RegistrationData registrationData;
  final Function(String?) onStateChanged;
  final Function(String?) onGradeChanged;
  final Function(String?) onSectionChanged;
  final Function(String?) onBacSectionChanged;

  const AdditionalDataStep({
    super.key,
    required this.formKey,
    required this.registrationData,
    required this.onStateChanged,
    required this.onGradeChanged,
    required this.onSectionChanged,
    required this.onBacSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: RegistrationConstants.step3Title,
            subtitle: RegistrationConstants.step3Subtitle,
          ),
          const SizedBox(height: 30),

          // State Dropdown
          CustomDropdown(
            label: RegistrationConstants.labelState,
            value: registrationData.state,
            items: RegistrationConstants.tunisianStates,
            icon: Icons.location_on_outlined,
            onChanged: onStateChanged,
            validator: (value) {
              if (value == null) {
                return RegistrationConstants.errorStateRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Grade Dropdown
          CustomDropdown(
            label: RegistrationConstants.labelGrade,
            value: registrationData.grade,
            items: RegistrationConstants.grades,
            icon: Icons.school_outlined,
            onChanged: onGradeChanged,
            validator: (value) {
              if (value == null) {
                return RegistrationConstants.errorGradeRequired;
              }
              return null;
            },
          ),

          // Section Dropdown (conditional)
          if (registrationData.needsSection && !registrationData.isBacGrade) ...[
            const SizedBox(height: 20),
            CustomDropdown(
              label: RegistrationConstants.labelSection,
              value: registrationData.section,
              items: RegistrationConstants.sections,
              icon: Icons.category_outlined,
              onChanged: onSectionChanged,
            ),
          ],

          // Bac Section Dropdown (if Bac)
          if (registrationData.isBacGrade) ...[
            const SizedBox(height: 20),
            CustomDropdown(
              label: RegistrationConstants.labelBacSection,
              value: registrationData.bacSection,
              items: RegistrationConstants.bacSections,
              icon: Icons.military_tech_outlined,
              onChanged: onBacSectionChanged,
              validator: (value) {
                if (value == null) {
                  return RegistrationConstants.errorBacSectionRequired;
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }
}
