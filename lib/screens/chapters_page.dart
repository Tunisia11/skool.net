import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/chapters/chapters.dart';
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

  void _handleChapterTap(BuildContext context, ChapterModel chapter) {
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
    if (chapter.lessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا توجد دروس في هذا الفصل حالياً.',
            style: GoogleFonts.cairo(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey,
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
                  ChaptersHeader(subject: subject),
                  const SizedBox(height: 30),

                  // Chapters List
                  ChaptersList(
                    subject: subject,
                    onChapterTap: (chapter) => _handleChapterTap(context, chapter),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
