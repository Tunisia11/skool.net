import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/repositories/subject_repository.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';
import 'package:skool/screens/live_page.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/enhanced_calendar_card.dart';
import 'package:skool/widgets/dashboard/dashboard.dart';
import 'package:skool/widgets/dashboard/subject_progress_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SubjectRepository _subjectRepository = SubjectRepository();
  List<SubjectModel> _enrolledSubjects = [];
  Map<String, double> _subjectProgress = {};
  bool _isLoading = true;
  String _userName = 'Guest';
  String _userGrade = '';
  StudentModel? _student;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _userName = authState.user.name;
        if (authState.user is StudentModel) {
          _student = authState.user as StudentModel;
          _userGrade = _student!.grade;
        }
      });
      if (_userGrade.isNotEmpty) {
        await _loadSubjects();
      } else {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectRepository.getSubjectsForGrade(_userGrade);
      // Determine enrolled subjects. For now, assume all subjects for grade are "enrolled" or available
      // Ideally, filter by _student!.enrolledSubjectIds if that logic is strictly enforced.
      // But typically for school apps, grade subjects are auto-enrolled.
      
      final Map<String, double> progressMap = {};
      
      for (final subject in subjects) {
        int totalLessons = 0;
        int completedCount = 0;
        
        for (final chapter in subject.chapters) {
          totalLessons += chapter.lessons.length;
          for (final lesson in chapter.lessons) {
            if (_student!.completedLessonIds.contains(lesson.id)) {
              completedCount++;
            }
          }
        }
        
        progressMap[subject.id] = totalLessons > 0 ? completedCount / totalLessons : 0.0;
      }

      setState(() {
        _enrolledSubjects = subjects;
        _subjectProgress = progressMap;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading dashboard subjects: $e');
      setState(() => _isLoading = false);
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
            currentRoute: 'home',
            onNavigate: (route) => _handleNavigation(context, route),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  DashboardHeader(userName: _userName),
                  const SizedBox(height: 30),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (Main Stats & Courses)
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            DashboardWelcomeCard(userName: _userName),
                            const SizedBox(height: 20),
                            
                            // Progress / Subjects Section
                            _buildProgressSection(),
                            
                            const SizedBox(height: 20),
                            // Empty state for classes
                            const DashboardEmptyState(
                              title: 'الحصص القادمة',
                              message: 'لا توجد حصص مجدولة قريبًا.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Right Column (Profile Stats / Calendar)
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            DashboardProfileCard(
                              name: _userName,
                              grade: _userGrade,
                            ),
                            const SizedBox(height: 20),
                            const EnhancedCalendarCard(),
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

  Widget _buildProgressSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_enrolledSubjects.isEmpty) {
      return const DashboardEmptyState(
        title: 'تقدمك الدراسي',
        message: 'لم تبدأ أي دورات بعد.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('تقدمك الدراسي', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _handleNavigation(context, 'subjects'),
              child: Text('عرض الكل', style: GoogleFonts.cairo()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _enrolledSubjects.length,
            itemBuilder: (context, index) {
              final subject = _enrolledSubjects[index];
              final progress = _subjectProgress[subject.id] ?? 0.0;
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
                child: SubjectProgressCard(subject: subject, progress: progress),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleNavigation(BuildContext context, String route) {
    if (route == 'profile') {
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubjectsPage()),
      );
    } else if (route == 'live') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LivePage()),
      );
    }
  }
}
