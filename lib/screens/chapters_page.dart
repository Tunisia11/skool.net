import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';
import 'package:skool/screens/content_page.dart';

class ChaptersPage extends StatelessWidget {
  final SubjectModel subject;

  const ChaptersPage({super.key, required this.subject});

  void _handleNavigation(BuildContext context, String route) {
    if (route == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (route == 'profile') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else if (route == 'offers') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OffersPage()),
      );
    } else if (route == 'subjects') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SubjectsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          AppSidebar(
            currentRoute: 'subjects',
            onNavigate: (route) => _handleNavigation(context, route),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button & Header
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  // Chapters List
                  _buildChaptersList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 16),
              const SizedBox(width: 4),
              Text(
                'العودة للمواد',
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(subject.iconData, color: subject.color, size: 32),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'قائمة المحاور والدروس',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChaptersList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subject.chapters.length,
      itemBuilder: (context, index) {
        return _buildChapterCard(context, subject.chapters[index], index + 1);
      },
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    ChapterModel chapter,
    int chapterNumber,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (chapter.isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'هذا المحور مغلق حالياً. يرجى إكمال المحاور السابقة.',
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContentPage(
                  subject: subject,
                  chapter: chapter,
                  initialLesson: chapter.lessons.first,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Chapter Number
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: chapter.isLocked
                        ? Colors.grey.withValues(alpha: 0.1)
                        : subject.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      chapterNumber.toString(),
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: chapter.isLocked ? Colors.grey : subject.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Chapter Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chapter.title,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: chapter.isLocked
                                  ? Colors.grey
                                  : AppColors.textPrimary,
                            ),
                          ),
                          if (chapter.isLocked) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chapter.description,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStatItem(
                            Icons.play_circle_outline,
                            '${chapter.videoCount} فيديو',
                          ),
                          const SizedBox(width: 20),
                          _buildStatItem(
                            Icons.assignment_outlined,
                            '${chapter.exerciseCount} تمرين',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(chapter.progress * 100).toInt()}%',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: chapter.progress == 1.0
                            ? Colors.green
                            : subject.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (chapter.progress == 1.0)
                      const Icon(Icons.check_circle, color: Colors.green)
                    else
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: chapter.progress,
                            backgroundColor: subject.color.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              subject.color,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios,
                  color: chapter.isLocked ? Colors.grey[300] : Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
