import 'package:flutter/material.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/content/content.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';

class ContentPage extends StatefulWidget {
  final SubjectModel subject;
  final ChapterModel chapter;
  final LessonModel initialLesson;

  const ContentPage({
    super.key,
    required this.subject,
    required this.chapter,
    required this.initialLesson,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late LessonModel currentLesson;

  @override
  void initState() {
    super.initState();
    currentLesson = widget.initialLesson;
  }

  void _handleNavigation(String route) {
    if (route == 'home') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else if (route == 'profile') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    } else if (route == 'offers') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const OffersPage()));
    } else if (route == 'subjects') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SubjectsPage()));
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
            onNavigate: _handleNavigation,
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  ContentHeader(chapterTitle: widget.chapter.title),
                  const SizedBox(height: 30),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Player Section
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContentVideoPlayer(
                              lessonDuration: currentLesson.duration,
                            ),
                            const SizedBox(height: 24),
                            ContentLessonInfo(lesson: currentLesson),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),

                      // Sidebar: Related Resources & Playlist
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            ContentResourcesList(
                              resources: currentLesson.resources,
                            ),
                            const SizedBox(height: 24),
                            ContentPlaylist(
                              lessons: widget.chapter.lessons,
                              currentLesson: currentLesson,
                              onLessonTap: (lesson) {
                                setState(() {
                                  currentLesson = lesson;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
