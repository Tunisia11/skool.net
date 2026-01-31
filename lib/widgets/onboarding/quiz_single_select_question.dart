import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// Single select question widget for the onboarding quiz.
class QuizSingleSelectQuestion extends StatelessWidget {
  final String question;
  final String? subtitle;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const QuizSingleSelectQuestion({
    super.key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              question,
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: GoogleFonts.cairo(
                    fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'اختر إجابتك',
              style: GoogleFonts.cairo(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedOption == option;
              final letter = String.fromCharCode(65 + index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => onOptionSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: AppColors.secondary, width: 3)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$letter.',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.secondary),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
