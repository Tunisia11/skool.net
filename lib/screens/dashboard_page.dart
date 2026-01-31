import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';
import 'package:skool/screens/live_page.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/enhanced_calendar_card.dart';
import 'package:skool/widgets/dashboard/dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String userName = 'Guest';
    String userGrade = '';

    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
      if (authState.user is StudentModel) {
        userGrade = (authState.user as StudentModel).grade ?? '';
      }
    }

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
                  DashboardHeader(userName: userName),
                  const SizedBox(height: 30),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (Main Stats & Courses)
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            DashboardWelcomeCard(userName: userName),
                            const SizedBox(height: 20),
                            // Empty state for progress
                            const DashboardEmptyState(
                              title: 'تقدمك الدراسي',
                              message: 'لم تبدأ أي دورات بعد.',
                            ),
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
                              name: userName,
                              grade: userGrade,
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
