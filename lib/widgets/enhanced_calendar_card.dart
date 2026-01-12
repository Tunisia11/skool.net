import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/live_lesson.dart';
import 'package:skool/widgets/calendar_widget.dart';

class EnhancedCalendarCard extends StatefulWidget {
  const EnhancedCalendarCard({super.key});

  @override
  State<EnhancedCalendarCard> createState() => _EnhancedCalendarCardState();
}

class _EnhancedCalendarCardState extends State<EnhancedCalendarCard> {
  bool showUpcoming = true; // Toggle between calendar and upcoming lessons

  @override
  Widget build(BuildContext context) {
    final upcomingLessons = LiveLesson.getFakeLessons()
        .where((lesson) => lesson.dateTime.isAfter(DateTime.now()))
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Toggle Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقويم',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(
                  showUpcoming ? Icons.calendar_month : Icons.list,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    showUpcoming = !showUpcoming;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showUpcoming
                ? _buildCalendarView()
                : _buildUpcomingLessonsView(upcomingLessons),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return const SizedBox(
      key: ValueKey('calendar'),
      child: CalendarWidget(),
    );
  }

  Widget _buildUpcomingLessonsView(List<LiveLesson> lessons) {
    return SizedBox(
      key: const ValueKey('lessons'),
      child: Column(
        children: [
          ...lessons.map((lesson) => _buildLessonItem(lesson)),
        ],
      ),
    );
  }

  Widget _buildLessonItem(LiveLesson lesson) {
    // Determine subject color
    Color subjectColor;
    switch (lesson.subject) {
      case 'الرياضيات':
        subjectColor = Colors.orange;
        break;
      case 'الفيزياء':
        subjectColor = Colors.blue;
        break;
      case 'الكيمياء':
        subjectColor = Colors.green;
        break;
      case 'العربية':
        subjectColor = Colors.purple;
        break;
      case 'الإنجليزية':
        subjectColor = Colors.pink;
        break;
      default:
        subjectColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: subjectColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(
            color: subjectColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: subjectColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lesson.subject,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: subjectColor,
                  ),
                ),
              ),
              if (lesson.isPopular) ...[
                const SizedBox(width: 6),
                Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            lesson.title,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${lesson.dateString} • ${lesson.timeString}',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person_outline, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  lesson.teacher,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
