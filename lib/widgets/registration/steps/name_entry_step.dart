import 'package:flutter/material.dart';
import 'package:skool/widgets/registration/form_fields/age_selector.dart';
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
    // Parse initial age from controller or default to 10
    final initialAge = int.tryParse(ageController.text) ?? 10;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'أدخل معلوماتك',
            subtitle: 'من فضلك أدخل اسمك وعمرك',
          ),
          const SizedBox(height: 32),

          // Name Field
          CustomTextField(
            controller: nameController,
            label: 'الاسم الكامل',
            icon: Icons.person_outline,
            onChanged: onNameChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الاسم مطلوب';
              }
              if (value.length < 3) {
                return 'الاسم يجب أن يكون 3 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Age Selector
          AgeSelector(
            initialAge: initialAge,
            minAge: 5,
            maxAge: 60,
            onAgeChanged: (age) {
              ageController.text = age.toString();
              onAgeChanged?.call(age.toString());
            },
          ),
        ],
      ),
    );
  }
}
