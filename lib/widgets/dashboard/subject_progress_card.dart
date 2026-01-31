import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/models/subject_model.dart';

class SubjectProgressCard extends StatelessWidget {
  final SubjectModel subject;
  final double progress; // 0.0 to 1.0

  const SubjectProgressCard({
    super.key,
    required this.subject,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: subject.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(subject.icon),
              color: subject.color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subject.name,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: subject.color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(subject.color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% مكتمل',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'math': return Icons.calculate;
      case 'science': return Icons.science;
      case 'history': return Icons.history_edu;
      case 'geography': return Icons.public;
      case 'physics': return Icons.flash_on;
      case 'chemistry': return Icons.science_outlined;
      case 'biology': return Icons.biotech;
      case 'language': return Icons.language;
      case 'computer': return Icons.computer;
      case 'art': return Icons.palette;
      case 'music': return Icons.music_note;
      case 'sports': return Icons.sports_soccer;
      default: return Icons.book;
    }
  }
}
