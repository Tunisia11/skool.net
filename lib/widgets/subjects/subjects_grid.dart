import 'package:flutter/material.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/subjects/subject_card.dart';

/// A responsive grid widget that displays subject cards.
class SubjectsGrid extends StatelessWidget {
  final List<SubjectModel> subjects;
  final void Function(SubjectModel subject)? onSubjectTap;

  const SubjectsGrid({
    super.key,
    required this.subjects,
    this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cross axis count based on available width
        int crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 900
                ? 3
                : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            childAspectRatio: 1.1,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return SubjectCard(
              subject: subject,
              onTap: onSubjectTap != null ? () => onSubjectTap!(subject) : null,
            );
          },
        );
      },
    );
  }
}
