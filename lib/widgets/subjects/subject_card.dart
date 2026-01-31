import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';

/// A card widget displaying a single subject with its icon, name, stats, and progress.
class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Spacer(),
                _buildTitle(),
                const SizedBox(height: 4),
                _buildStats(),
                const SizedBox(height: 20),
                _buildProgressSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: subject.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            subject.iconData,
            color: subject.color,
            size: 28,
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'details',
              child: Text('التفاصيل', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      subject.name,
      style: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStats() {
    return Text(
      '${subject.chapterCount} محور • ${subject.videoCount} فيديو',
      style: GoogleFonts.cairo(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(subject.progress * 100).toInt()}%',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: subject.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: subject.progress,
            backgroundColor: subject.color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(subject.color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
